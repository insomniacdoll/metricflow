test_name: test_cumulative_metric
test_filename: test_cumulative_metric_rendering.py
docstring:
  Tests rendering a basic cumulative metric query.
sql_engine: BigQuery
---
-- Read Elements From Semantic Model 'revenue'
-- Metric Time Dimension 'ds'
-- Pass Only Elements: ['txn_revenue', 'ds__day']
-- Aggregate Measures
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  DATETIME_TRUNC(created_at, day) AS ds__day
  , SUM(revenue) AS trailing_2_months_revenue
FROM ***************************.fct_revenue revenue_src_28000
GROUP BY
  ds__day
