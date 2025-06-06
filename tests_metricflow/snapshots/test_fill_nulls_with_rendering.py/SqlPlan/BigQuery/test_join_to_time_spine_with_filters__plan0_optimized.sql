test_name: test_join_to_time_spine_with_filters
test_filename: test_fill_nulls_with_rendering.py
sql_engine: BigQuery
---
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  metric_time__day
  , COALESCE(bookings, 0) AS bookings_fill_nulls_with_0
FROM (
  -- Join to Time Spine Dataset
  -- Constrain Time Range to [2020-01-03T00:00:00, 2020-01-05T00:00:00]
  SELECT
    subq_25.metric_time__day AS metric_time__day
    , subq_20.bookings AS bookings
  FROM (
    -- Constrain Output with WHERE
    -- Constrain Time Range to [2020-01-03T00:00:00, 2020-01-05T00:00:00]
    -- Pass Only Elements: ['metric_time__day']
    SELECT
      metric_time__day
    FROM (
      -- Read From Time Spine 'mf_time_spine'
      -- Change Column Aliases
      SELECT
        ds AS metric_time__day
        , DATETIME_TRUNC(ds, isoweek) AS metric_time__week
      FROM ***************************.mf_time_spine time_spine_src_28006
    ) subq_22
    WHERE (
      metric_time__day BETWEEN '2020-01-03' AND '2020-01-05'
    ) AND (
      metric_time__week > '2020-01-01'
    )
  ) subq_25
  LEFT OUTER JOIN (
    -- Constrain Output with WHERE
    -- Pass Only Elements: ['bookings', 'metric_time__day']
    -- Aggregate Measures
    SELECT
      metric_time__day
      , SUM(bookings) AS bookings
    FROM (
      -- Read Elements From Semantic Model 'bookings_source'
      -- Metric Time Dimension 'ds'
      -- Constrain Time Range to [2020-01-03T00:00:00, 2020-01-05T00:00:00]
      SELECT
        DATETIME_TRUNC(ds, day) AS metric_time__day
        , DATETIME_TRUNC(ds, isoweek) AS metric_time__week
        , 1 AS bookings
      FROM ***************************.fct_bookings bookings_source_src_28000
      WHERE DATETIME_TRUNC(ds, day) BETWEEN '2020-01-03' AND '2020-01-05'
    ) subq_17
    WHERE metric_time__week > '2020-01-01'
    GROUP BY
      metric_time__day
  ) subq_20
  ON
    subq_25.metric_time__day = subq_20.metric_time__day
  WHERE subq_25.metric_time__day BETWEEN '2020-01-03' AND '2020-01-05'
) subq_27
