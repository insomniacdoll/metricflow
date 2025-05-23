from __future__ import annotations

from enum import Enum
from typing import Optional, TypeVar


class SqlDialect(Enum):
    """All SQL dialects that MQL currently supports. Value of enum is used in URLs as the dialect."""

    DUCKDB = "duckdb"
    REDSHIFT = "redshift"
    POSTGRESQL = "postgresql"
    SNOWFLAKE = "snowflake"
    BIGQUERY = "bigquery"
    DATABRICKS = "databricks"
    TRINO = "trino"


T = TypeVar("T")


def not_empty(value: Optional[T], component_name: str, url: str) -> T:
    """Helper to check the value is not None - otherwise raise a helpful exception."""
    if not value:
        raise ValueError(f"Missing {component_name} in {url}")
    else:
        return value
