test_name: test_cumulative_metric_with_multiple_agg_time_dimensions
test_filename: test_cumulative_metric_rendering.py
docstring:
  Tests rendering a query for a cumulative metric queried with multiple agg time dimensions.
sql_engine: BigQuery
---
-- Join Self Over Time Range
-- Pass Only Elements: ['txn_revenue', 'revenue_instance__ds__day', 'revenue_instance__ds__month']
-- Aggregate Measures
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  subq_11.ds AS revenue_instance__ds__day
  , DATETIME_TRUNC(subq_11.ds, month) AS revenue_instance__ds__month
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
  , revenue_instance__ds__month
