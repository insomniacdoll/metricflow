test_name: test_simple_query_with_date_part
test_filename: test_granularity_date_part_rendering.py
sql_engine: Trino
---
-- Aggregate Measures
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  metric_time__extract_dow
  , SUM(bookings) AS bookings
FROM (
  -- Read Elements From Semantic Model 'bookings_source'
  -- Metric Time Dimension 'ds'
  -- Pass Only Elements: ['bookings', 'metric_time__extract_dow']
  SELECT
    EXTRACT(DAY_OF_WEEK FROM ds) AS metric_time__extract_dow
    , 1 AS bookings
  FROM ***************************.fct_bookings bookings_source_src_28000
) subq_7
GROUP BY
  metric_time__extract_dow
