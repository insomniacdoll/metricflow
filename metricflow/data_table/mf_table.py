from __future__ import annotations

import datetime
import importlib.util
import itertools
import logging
import threading
import typing
from dataclasses import dataclass
from decimal import Decimal
from typing import Iterable, Iterator, List, Optional, Sequence, Tuple, Type

import tabulate
from metricflow_semantics.helpers.string_helpers import mf_indent
from metricflow_semantics.mf_logging.pretty_print import mf_pformat, mf_pformat_dict
from typing_extensions import Self

from metricflow.data_table.column_types import CellValue, InputCellValue, row_cell_types
from metricflow.data_table.mf_column import ColumnDescription

if typing.TYPE_CHECKING:
    from mypy.moduleinspect import ModuleType


logger = logging.getLogger(__name__)


@dataclass(frozen=True, eq=False)
class MetricFlowDataTable:
    """Container for tabular data stored in memory.

    This is feature-limited and is used to pass tabular data for tests and the CLI. The only data types that are
    supported are described by `CellValue`.

    When constructing the table, additional input types (as described by `InputCellValue`) can be used, but those
    additional types will be converted into one of the `CellValue` types.

    Don't use `=` to compare tables as there many be NaNs. Instead, use `check_data_tables_are_equal`.
    """

    column_descriptions: Tuple[ColumnDescription, ...]
    rows: Tuple[Tuple[CellValue, ...], ...]

    def __post_init__(self) -> None:  # noqa: D105
        expected_column_count = self.column_count
        for row_index, row in enumerate(self.rows):
            # Check that the number of columns in the rows match.
            row_column_count = len(row)
            assert row_column_count == expected_column_count, (
                f"Row at index {row_index} has {row_column_count} columns instead of {expected_column_count}. "
                f"Row is:"
                f"\n{mf_indent(mf_pformat(row))}"
            )
            # Check that the type of the object in the rows match.
            for column_index, cell_value in enumerate(row):
                expected_cell_value_type = self.column_descriptions[column_index].column_type
                assert cell_value is None or isinstance(cell_value, expected_cell_value_type), mf_pformat_dict(
                    "Cell value type mismatch.",
                    {
                        "row_index": row_index,
                        "column_index": column_index,
                        "expected_cell_value_type": expected_cell_value_type,
                        "actual_cell_value_type": type(cell_value),
                        "cell_value": cell_value,
                    },
                )
                # Check that datetimes don't have a timezone set.
                if isinstance(cell_value, datetime.datetime):
                    assert cell_value.tzinfo is None, mf_pformat_dict(
                        "Time zone provided for datetime.",
                        {
                            "row_index": row_index,
                            "column_index": column_index,
                            "cell_value": cell_value,
                        },
                    )

    @property
    def column_count(self) -> int:  # noqa: D102
        return len(self.column_descriptions)

    @property
    def row_count(self) -> int:  # noqa: D102
        return len(self.rows)

    def column_name_index(self, column_name: str) -> int:
        """Return the index of the column that matches the given name. Raises `ValueError` if the name is invalid."""
        for i, column_description in enumerate(self.column_descriptions):
            if column_description.column_name == column_name:
                return i
        raise ValueError(
            f"Unknown column name {repr(column_name)}. Known column names are:"
            f"\n{mf_indent(mf_pformat([column_name for column_name in self.column_descriptions]))}"
        )

    @property
    def column_names(self) -> Sequence[str]:  # noqa: D102
        return tuple(column_description.column_name for column_description in self.column_descriptions)

    def column_values_iterator(self, column_index: int) -> Iterator[CellValue]:
        """Returns an iterator for values of the column at the tiven index."""
        return (row[column_index] for row in self.rows)

    def _sorted_by_column_name(self) -> MetricFlowDataTable:  # noqa: D102
        new_rows: List[List[CellValue]] = [[] for _ in range(self.row_count)]
        sorted_column_names = sorted(self.column_names)
        for column_name in sorted_column_names:
            old_column_index = self.column_name_index(column_name)
            for row_index, cell_value in enumerate(self.column_values_iterator(old_column_index)):
                new_rows[row_index].append(cell_value)

        return MetricFlowDataTable(
            column_descriptions=tuple(
                self.column_descriptions[self.column_name_index(column_name)] for column_name in sorted_column_names
            ),
            rows=tuple(
                tuple(row_dict[column_index] for column_index in range(self.column_count)) for row_dict in new_rows
            ),
        )

    def _sorted_by_row(self) -> MetricFlowDataTable:  # noqa: D102
        def _cell_sort_key(cell: CellValue) -> str:
            if isinstance(cell, datetime.datetime):
                return cell.isoformat()
            return str(cell)

        def _row_sort_key(row: Tuple[CellValue, ...]) -> Tuple[str, ...]:
            return tuple(_cell_sort_key(cell) for cell in row)

        return MetricFlowDataTable(
            column_descriptions=self.column_descriptions,
            rows=tuple(sorted((row for row in self.rows), key=_row_sort_key)),
        )

    def sorted(self) -> MetricFlowDataTable:
        """Returns this but with the columns in order by name, and the rows in order by values."""
        return self._sorted_by_column_name()._sorted_by_row()

    def text_format(self, float_decimals: Optional[int] = None) -> str:
        """Return a text version of this table that is suitable for printing."""
        str_rows: List[List[Optional[str]]] = []

        for row in self.rows:
            str_row: List[Optional[str]] = []
            for column_index, cell_value in enumerate(row):
                if cell_value is None:
                    str_row.append(None)
                elif self.column_descriptions[column_index].column_type in {float, Decimal}:
                    # Use `g` (general number format) by default.
                    float_format = f".{float_decimals}f" if float_decimals is not None else "g"
                    str_row.append(format(cell_value, float_format))
                elif isinstance(cell_value, datetime.datetime):
                    str_row.append(cell_value.isoformat())
                else:
                    str_row.append(str(cell_value))

            str_rows.append(str_row)

        column_alignment: List[str] = []
        # Align numeric values by the decimal point, otherwise to the left.
        # Numeric values could also be aligned to the right to be similar to spreadsheets.
        for column_description in self.column_descriptions:
            if column_description.column_type in {int, float, Decimal}:
                column_alignment.append("decimal")
            else:
                column_alignment.append("left")
        headers = tuple(column_description.column_name for column_description in self.column_descriptions)

        return _IsolatedTabulateRunner.tabulate(
            tabular_data=str_rows,
            headers=headers,
            column_alignment=column_alignment,
        )

    def with_lower_case_column_names(self) -> MetricFlowDataTable:
        """Return this but with columns names in lowercase."""
        return MetricFlowDataTable(
            column_descriptions=tuple(
                column_description.with_lower_case_column_name() for column_description in self.column_descriptions
            ),
            rows=self.rows,
        )

    def get_cell_value(self, row_index: int, column_index: int) -> CellValue:  # noqa: D102
        return self.rows[row_index][column_index]

    @staticmethod
    def create_from_rows(  # noqa: D102
        column_names: Sequence[str], rows: Iterable[Sequence[InputCellValue]]
    ) -> MetricFlowDataTable:
        builder = _MetricFlowDataTableBuilder(column_names)
        for row in rows:
            builder.add_row(row)
        return builder.build()


class _MetricFlowDataTableBuilder:
    """Helps build `MetricFlowDataTable`, one row at a time.

    This validates each row as it is input to give better error messages.
    """

    def __init__(self, column_names: Sequence[str]) -> None:  # noqa: D107
        self._rows: List[Tuple[CellValue, ...]] = []
        self._column_names = tuple(column_names)

    def _build_table_from_rows(self) -> MetricFlowDataTable:  # noqa: D102
        # Figure out the type of the column based on the types of the values in the rows.
        # Can't use the type of the columns in the first row because it might contain None, so iterate through the rows
        # and use the first non-None type.
        column_types_so_far: Optional[Tuple[Type[CellValue], ...]] = None
        cell_value: CellValue
        for row in self._rows:
            if column_types_so_far is None:
                column_types_so_far = row_cell_types(row)
                continue

            # If the types of the objects in the row are the same, no need for updates.
            row_column_types = row_cell_types(row)
            if row_column_types == column_types_so_far:
                continue

            # Types of objects in the row are different from what's known so far.
            # They can only be different in that one can be None and other can be not None.
            updated_column_types: List[Type[CellValue]] = []
            for column_type_so_far, cell_type, cell_value in itertools.zip_longest(
                column_types_so_far, row_column_types, row
            ):
                if column_type_so_far is cell_type:
                    updated_column_types.append(column_type_so_far)
                elif column_type_so_far is type(None) and cell_type is not None:
                    updated_column_types.append(cell_type)
                elif column_type_so_far is not None and cell_type is type(None):
                    updated_column_types.append(column_type_so_far)
                else:
                    raise ValueError(f"Expected cell type {column_type_so_far} but got: {cell_type}")

            column_types_so_far = tuple(updated_column_types)

        # Empty table case.
        if column_types_so_far is None:
            column_types_so_far = tuple(type(None) for _ in range(len(self._column_names)))

        final_column_types = column_types_so_far

        return MetricFlowDataTable(
            column_descriptions=tuple(
                ColumnDescription(column_name=column_name, column_type=column_type)
                for column_name, column_type in itertools.zip_longest(self._column_names, final_column_types)
            ),
            rows=tuple(self._rows),
        )

    def _convert_row_to_supported_types(self, row: Sequence[InputCellValue]) -> Sequence[CellValue]:
        """Since only a limited set of types are supported, convert the input type to the supported type."""
        updated_row: List[CellValue] = []
        for cell_value in row:
            if (
                cell_value is None
                or isinstance(cell_value, float)
                or isinstance(cell_value, bool)
                or isinstance(cell_value, int)
                or isinstance(cell_value, str)
            ):
                updated_row.append(cell_value)
                continue

            if isinstance(cell_value, datetime.datetime):
                updated_row.append(cell_value.replace(tzinfo=None))
                continue

            if isinstance(cell_value, Decimal):
                updated_row.append(float(cell_value))
                continue

            if isinstance(cell_value, datetime.date):
                updated_row.append(datetime.datetime.combine(cell_value, datetime.datetime.min.time()))
                continue

            raise ValueError(f"Row cell has unexpected type: {repr(cell_value)}")
        return updated_row

    def add_row(self, row: Sequence[InputCellValue], parse_strings: bool = False) -> Self:  # noqa: D102
        row = tuple(row)
        expected_column_count = len(self._column_names)
        actual_column_count = len(row)
        if actual_column_count != expected_column_count:
            raise ValueError(
                f"Input row has {actual_column_count} columns, but expected {expected_column_count} columns. Row is:"
                f"\n{mf_indent(mf_pformat(row))}"
            )
        self._rows.append(tuple(self._convert_row_to_supported_types(row)))
        return self

    def build(self) -> MetricFlowDataTable:  # noqa: D102
        return self._build_table_from_rows()


class _IsolatedTabulateRunner:
    """Helps run `tabulate` with different module options.

    The `tabulate.tabulate` method uses some options defined in the module instead of being provided as arguments to
    the function. This runner is used to change those options in isolation by loading a copy of the `tabulate` module.
    This helps to ensure that other calls to `tabulate.tabulate` don't see unexpected results.
    """

    _TABULATE_MODULE_COPY: Optional[ModuleType] = None
    _STATE_LOCK = threading.Lock()

    @classmethod
    def tabulate(
        cls,
        tabular_data: Sequence[Sequence[CellValue]],
        headers: Sequence[str],
        column_alignment: Optional[Sequence[str]],
    ) -> str:
        """Produce a text table from the given data. Also see class docstring."""
        with _IsolatedTabulateRunner._STATE_LOCK:
            try:
                if _IsolatedTabulateRunner._TABULATE_MODULE_COPY is None:
                    tabulate_module_spec = importlib.util.find_spec("tabulate")
                    if tabulate_module_spec is None:
                        raise RuntimeError("Unable to find spec for `tabulate`.")
                    tabulate_module_copy = importlib.util.module_from_spec(tabulate_module_spec)
                    if tabulate_module_copy is None:
                        raise RuntimeError(f"Unable to load module using {tabulate_module_spec=}")
                    if tabulate_module_spec.loader is None:
                        raise RuntimeError(f"Loader missing for {tabulate_module_spec=}")
                    tabulate_module_spec.loader.exec_module(tabulate_module_copy)
                    tabulate_module_copy.PRESERVE_WHITESPACE = True  # type: ignore[attr-defined]
                    _IsolatedTabulateRunner._TABULATE_MODULE_COPY = tabulate_module_copy
            except Exception:
                logger.exception(
                    "Failed to load a copy of the `tabulate` module. This means that some table-formatting options "
                    "can't be applied. This is a bug and should be investigated."
                )

        # `tabulate.tabulate` can detect numeric values and apply special formatting rules. This can
        # result in unexpected values when coupled with the `--decimals` option, so disabling that feature.
        disable_numparse = True

        if _IsolatedTabulateRunner._TABULATE_MODULE_COPY is None:
            logger.warning(
                "Generating text table without required options set as there was an error loading the "
                "`tabulate` module."
            )
            return tabulate.tabulate(
                tabular_data=tabular_data,
                headers=headers,
                disable_numparse=disable_numparse,
                colalign=column_alignment,
            )

        return _IsolatedTabulateRunner._TABULATE_MODULE_COPY.tabulate(
            tabular_data=tabular_data,
            headers=headers,
            disable_numparse=disable_numparse,
            colalign=column_alignment,
        )
