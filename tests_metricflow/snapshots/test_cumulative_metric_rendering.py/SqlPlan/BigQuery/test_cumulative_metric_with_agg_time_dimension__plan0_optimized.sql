test_name: test_cumulative_metric_with_agg_time_dimension
test_filename: test_cumulative_metric_rendering.py
docstring:
  Tests rendering a query for a cumulative metric queried with agg time dimension.
sql_engine: BigQuery
---
-- Join Self Over Time Range
-- Pass Only Elements: ['txn_revenue', 'revenue_instance__ds__day']
-- Aggregate Measures
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  subq_11.ds AS revenue_instance__ds__day
  , SUM(revenue_src_28000.revenue) AS trailing_2_months_revenue
FROM ***************************.mf_time_spine subq_11
INNER JOIN
  ***************************.fct_revenue revenue_src_28000
ON
  (
    DATETIME_TRUNC(revenue_src_28000.created_at, day) <= subq_11.ds
  ) AND (
    DATETIME_TRUNC(revenue_src_28000.created_at, day) > DATE_SUB(CAST(subq_11.ds AS DATETIME), INTERVAL 2 month)
  )
GROUP BY
  revenue_instance__ds__day
