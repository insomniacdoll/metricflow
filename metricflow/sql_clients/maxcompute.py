import logging
from typing import ClassVar, Mapping, Optional, Sequence, Union

import sqlalchemy
from metricflow.protocols.sql_client import SqlEngineAttributes, SupportedSqlEngine
from metricflow.sql.render.maxcompute import MaxComputeSqlQueryPlanRenderer
from metricflow.sql.render.sql_plan_renderer import SqlQueryPlanRenderer
from metricflow.sql_clients.common_client import SqlDialect, not_empty
from metricflow.sql_clients.sqlalchemy_dialect import SqlAlchemySqlClient

logger = logging.getLogger(__name__)


class MaxComputeEngineAttributes(SqlEngineAttributes):
    """Engine-specific attributes for the MaxCompute query engine

    This is an implementation of the SqlEngineAttributes protocol for MaxCompute
    """

    sql_engine_type: ClassVar[SupportedSqlEngine] = SupportedSqlEngine.MAXCOMPUTE

    # SQL Engine capabilities
    date_trunc_supported: ClassVar[bool] = True
    full_outer_joins_supported: ClassVar[bool] = True
    indexes_supported: ClassVar[bool] = False
    multi_threading_supported: ClassVar[bool] = True
    timestamp_type_supported: ClassVar[bool] = False
    timestamp_to_string_comparison_supported: ClassVar[bool] = False
    # Cancelling should be possible, but not yet implemented.
    cancel_submitted_queries_supported: ClassVar[bool] = False

    # SQL Dialect replacement strings
    double_data_type_name: ClassVar[str] = "DOUBLE"
    timestamp_type_name: ClassVar[Optional[str]] = "TIMESTAMP"

    # MetricFlow attributes
    sql_query_plan_renderer: ClassVar[SqlQueryPlanRenderer] = MaxComputeSqlQueryPlanRenderer()


class MaxComputeSqlClient(SqlAlchemySqlClient):
    """Implements MaxCompute."""

    @staticmethod
    def from_connection_details(url: str, password: Optional[str]) -> SqlAlchemySqlClient:  # noqa: D
        parsed_url = sqlalchemy.engine.url.make_url(url)
        dialect = SqlDialect.MAXCOMPUTE.value
        if parsed_url.drivername != dialect:
            raise ValueError(f"Expected dialect '{dialect}' in {url}")

        if password is None:
            raise ValueError(f"Password not supplied for {url}")

        return MaxComputeSqlClient(
            host=not_empty(parsed_url.host, "host", url),
            port=not_empty(parsed_url.port, "port", url),
            username=not_empty(parsed_url.username, "username", url),
            password=password,
            database=not_empty(parsed_url.database, "database", url),
            query=parsed_url.query,
        )

    def __init__(  # noqa: D
        self,
        port: int,
        database: str,
        username: str,
        password: str,
        host: str,
        query: Optional[Mapping[str, Union[str, Sequence[str]]]] = None,
    ) -> None:
        super().__init__(
            engine=self.create_engine(
                dialect=SqlDialect.MAXCOMPUTE.value,
                driver="psycopg2",
                port=port,
                database=database,
                username=username,
                password=password,
                host=host,
                query=query,
            )
        )

    @property
    def sql_engine_attributes(self) -> SqlEngineAttributes:
        """Collection of attributes and features specific to the Snowflake SQL engine"""
        return MaxComputeEngineAttributes()

    def cancel_submitted_queries(self) -> None:  # noqa: D
        raise NotImplementedError
