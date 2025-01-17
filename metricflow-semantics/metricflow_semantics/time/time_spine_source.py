from __future__ import annotations

import logging
from dataclasses import dataclass
from typing import Dict, Optional, Sequence

from dbt_semantic_interfaces.implementations.time_spine import PydanticTimeSpineCustomGranularityColumn
from dbt_semantic_interfaces.protocols import SemanticManifest
from dbt_semantic_interfaces.type_enums.time_granularity import TimeGranularity

from metricflow_semantics.specs.time_dimension_spec import DEFAULT_TIME_GRANULARITY, TimeDimensionSpec
from metricflow_semantics.sql.sql_table import SqlTable
from metricflow_semantics.time.granularity import ExpandedTimeGranularity

logger = logging.getLogger(__name__)

TIME_SPINE_DATA_SET_DESCRIPTION = "Time Spine"


@dataclass(frozen=True)
class TimeSpineSource:
    """A calendar table. Should contain at least one column with dates/times that map to a standard granularity.

    Dates should be contiguous. May also contain custom granularity columns.
    """

    schema_name: Optional[str]
    table_name: str = "mf_time_spine"
    # Name of the column in the table that contains date/time values that map to a standard granularity.
    base_column: str = "ds"
    # The time granularity of the base column.
    base_granularity: TimeGranularity = DEFAULT_TIME_GRANULARITY
    db_name: Optional[str] = None
    custom_granularities: Sequence[PydanticTimeSpineCustomGranularityColumn] = ()

    @property
    def spine_table(self) -> SqlTable:
        """Table containing all dates."""
        return SqlTable(schema_name=self.schema_name, table_name=self.table_name, db_name=self.db_name)

    @staticmethod
    def build_standard_time_spine_sources(
        semantic_manifest: SemanticManifest,
    ) -> Dict[TimeGranularity, TimeSpineSource]:
        """Creates a time spine source based on what's in the manifest."""
        time_spine_sources = {
            time_spine.primary_column.time_granularity: TimeSpineSource(
                schema_name=time_spine.node_relation.schema_name,
                table_name=time_spine.node_relation.alias,
                db_name=time_spine.node_relation.database,
                base_column=time_spine.primary_column.name,
                base_granularity=time_spine.primary_column.time_granularity,
                custom_granularities=tuple(
                    [
                        PydanticTimeSpineCustomGranularityColumn(
                            name=custom_granularity.name, column_name=custom_granularity.column_name
                        )
                        for custom_granularity in time_spine.custom_granularities
                    ]
                ),
            )
            for time_spine in semantic_manifest.project_configuration.time_spines
        }

        # For backward compatibility: if legacy time spine config exists in the manifest, add that time spine here for
        # backward compatibility. Ignore it if there is a new time spine config with the same granularity.
        legacy_time_spines = semantic_manifest.project_configuration.time_spine_table_configurations
        for legacy_time_spine in legacy_time_spines:
            if legacy_time_spine.grain not in time_spine_sources:
                time_spine_table = SqlTable.from_string(legacy_time_spine.location)
                time_spine_sources[legacy_time_spine.grain] = TimeSpineSource(
                    schema_name=time_spine_table.schema_name,
                    table_name=time_spine_table.table_name,
                    db_name=time_spine_table.db_name,
                    base_column=legacy_time_spine.column_name,
                    base_granularity=legacy_time_spine.grain,
                )

        return time_spine_sources

    @staticmethod
    def build_custom_time_spine_sources(time_spine_sources: Sequence[TimeSpineSource]) -> Dict[str, TimeSpineSource]:
        """Creates a set of time spine sources with custom granularities based on what's in the manifest."""
        return {
            custom_granularity.name: time_spine_source
            for time_spine_source in time_spine_sources
            for custom_granularity in time_spine_source.custom_granularities
        }

    @staticmethod
    def build_custom_granularities(time_spine_sources: Sequence[TimeSpineSource]) -> Dict[str, ExpandedTimeGranularity]:
        """Creates a set of supported custom granularities based on what's in the manifest."""
        return {
            custom_granularity.name: ExpandedTimeGranularity(
                name=custom_granularity.name, base_granularity=time_spine_source.base_granularity
            )
            for time_spine_source in time_spine_sources
            for custom_granularity in time_spine_source.custom_granularities
        }

    @staticmethod
    def choose_time_spine_source(
        required_time_spine_specs: Sequence[TimeDimensionSpec],
        time_spine_sources: Dict[TimeGranularity, TimeSpineSource],
    ) -> TimeSpineSource:
        """Determine which time spine source to use to satisfy the given specs.

        Will choose the time spine with the largest granularity that can be used to get the smallest granularity required to
        satisfy the time spine specs. Example:
        - Time spines available: SECOND, MINUTE, DAY
        - Time granularities needed for request: HOUR, DAY
        --> Selected time spine: MINUTE

        Note time spines are identified by their base granularity.
        """
        assert required_time_spine_specs, (
            "Choosing time spine source requires time spine specs, but the `required_time_spine_specs` param is empty. "
            "This indicates internal misconfiguration."
        )
        smallest_agg_time_grain = min(spec.time_granularity.base_granularity for spec in required_time_spine_specs)
        time_spine_grains = time_spine_sources.keys()
        compatible_time_spine_grains = [
            grain for grain in time_spine_grains if grain.to_int() <= smallest_agg_time_grain.to_int()
        ]
        if not compatible_time_spine_grains:
            raise RuntimeError(
                f"This query requires a time spine with granularity {smallest_agg_time_grain.name} or smaller, which is not configured. "
                f"The smallest available time spine granularity is {min(time_spine_grains).name}, which is too large."
                "See documentation for how to configure a new time spine: https://docs.getdbt.com/docs/build/metricflow-time-spine"
            )
        return time_spine_sources[max(compatible_time_spine_grains)]
