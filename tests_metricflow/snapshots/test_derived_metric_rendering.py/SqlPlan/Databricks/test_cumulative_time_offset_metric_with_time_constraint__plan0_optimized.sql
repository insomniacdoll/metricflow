test_name: test_cumulative_time_offset_metric_with_time_constraint
test_filename: test_derived_metric_rendering.py
sql_engine: Databricks
---
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  metric_time__day
  , every_2_days_bookers_2_days_ago AS every_2_days_bookers_2_days_ago
FROM (
  -- Join to Time Spine Dataset
  -- Constrain Time Range to [2019-12-19T00:00:00, 2020-01-02T00:00:00]
  -- Pass Only Elements: ['bookers', 'metric_time__day']
  -- Aggregate Measures
  -- Compute Metrics via Expressions
  SELECT
    time_spine_src_28006.ds AS metric_time__day
    , COUNT(DISTINCT subq_18.bookers) AS every_2_days_bookers_2_days_ago
  FROM ***************************.mf_time_spine time_spine_src_28006
  INNER JOIN (
    -- Join Self Over Time Range
    SELECT
      subq_17.ds AS metric_time__day
      , bookings_source_src_28000.guest_id AS bookers
    FROM ***************************.mf_time_spine subq_17
    INNER JOIN
      ***************************.fct_bookings bookings_source_src_28000
    ON
      (
        DATE_TRUNC('day', bookings_source_src_28000.ds) <= subq_17.ds
      ) AND (
        DATE_TRUNC('day', bookings_source_src_28000.ds) > DATEADD(day, -2, subq_17.ds)
      )
  ) subq_18
  ON
    DATEADD(day, -2, time_spine_src_28006.ds) = subq_18.metric_time__day
  WHERE time_spine_src_28006.ds BETWEEN '2019-12-19' AND '2020-01-02'
  GROUP BY
    time_spine_src_28006.ds
) subq_26
