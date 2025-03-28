test_name: test_join_to_timespine_metric_with_custom_granularity_filter
test_filename: test_custom_granularity.py
sql_engine: Postgres
---
-- Join to Time Spine Dataset
-- Compute Metrics via Expressions
SELECT
  subq_20.metric_time__alien_day AS metric_time__alien_day
  , subq_16.bookings AS bookings_join_to_time_spine
FROM (
  -- Constrain Output with WHERE
  -- Pass Only Elements: ['metric_time__alien_day',]
  SELECT
    metric_time__alien_day
  FROM (
    -- Read From Time Spine 'mf_time_spine'
    -- Change Column Aliases
    SELECT
      alien_day AS metric_time__alien_day
    FROM ***************************.mf_time_spine time_spine_src_28006
  ) subq_18
  WHERE metric_time__alien_day = '2020-01-01'
  GROUP BY
    metric_time__alien_day
) subq_20
LEFT OUTER JOIN (
  -- Constrain Output with WHERE
  -- Pass Only Elements: ['bookings', 'metric_time__alien_day']
  -- Aggregate Measures
  SELECT
    metric_time__alien_day
    , SUM(bookings) AS bookings
  FROM (
    -- Metric Time Dimension 'ds'
    -- Join to Custom Granularity Dataset
    SELECT
      subq_11.bookings AS bookings
      , subq_12.alien_day AS metric_time__alien_day
    FROM (
      -- Read Elements From Semantic Model 'bookings_source'
      SELECT
        1 AS bookings
        , DATE_TRUNC('day', ds) AS ds__day
      FROM ***************************.fct_bookings bookings_source_src_28000
    ) subq_11
    LEFT OUTER JOIN
      ***************************.mf_time_spine subq_12
    ON
      subq_11.ds__day = subq_12.ds
  ) subq_13
  WHERE metric_time__alien_day = '2020-01-01'
  GROUP BY
    metric_time__alien_day
) subq_16
ON
  subq_20.metric_time__alien_day = subq_16.metric_time__alien_day
