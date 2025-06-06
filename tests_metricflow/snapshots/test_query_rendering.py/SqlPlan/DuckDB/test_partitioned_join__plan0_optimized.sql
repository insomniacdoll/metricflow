test_name: test_partitioned_join
test_filename: test_query_rendering.py
docstring:
  Tests converting a dataflow plan where there's a join on a partitioned dimension.
sql_engine: DuckDB
---
-- Join Standard Outputs
-- Pass Only Elements: ['identity_verifications', 'user__home_state']
-- Aggregate Measures
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  users_ds_source_src_28000.home_state AS user__home_state
  , SUM(subq_10.identity_verifications) AS identity_verifications
FROM (
  -- Read Elements From Semantic Model 'id_verifications'
  -- Metric Time Dimension 'ds'
  SELECT
    DATE_TRUNC('day', ds_partitioned) AS ds_partitioned__day
    , user_id AS user
    , 1 AS identity_verifications
  FROM ***************************.fct_id_verifications id_verifications_src_28000
) subq_10
LEFT OUTER JOIN
  ***************************.dim_users users_ds_source_src_28000
ON
  (
    subq_10.user = users_ds_source_src_28000.user_id
  ) AND (
    subq_10.ds_partitioned__day = DATE_TRUNC('day', users_ds_source_src_28000.ds_partitioned)
  )
GROUP BY
  users_ds_source_src_28000.home_state
