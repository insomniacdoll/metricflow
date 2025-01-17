-- Compute Metrics via Expressions
SELECT
  metric_time__day
  , COALESCE(bookings, 0) AS bookings_fill_nulls_with_0
FROM (
  -- Join to Time Spine Dataset
  -- Constrain Time Range to [2020-01-03T00:00:00, 2020-01-05T00:00:00]
  SELECT
    subq_19.metric_time__day AS metric_time__day
    , subq_18.bookings AS bookings
  FROM (
    -- Filter Time Spine
    SELECT
      metric_time__day
    FROM (
      -- Time Spine
      SELECT
        ds AS metric_time__day
        , DATETIME_TRUNC(ds, isoweek) AS metric_time__week
      FROM ***************************.mf_time_spine subq_20
      WHERE ds BETWEEN '2020-01-03' AND '2020-01-05'
    ) subq_21
    WHERE metric_time__week > '2020-01-01'
  ) subq_19
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
      -- Pass Only Elements: ['bookings', 'metric_time__day', 'metric_time__week']
      SELECT
        DATETIME_TRUNC(ds, day) AS metric_time__day
        , DATETIME_TRUNC(ds, isoweek) AS metric_time__week
        , 1 AS bookings
      FROM ***************************.fct_bookings bookings_source_src_28000
      WHERE DATETIME_TRUNC(ds, day) BETWEEN '2020-01-03' AND '2020-01-05'
    ) subq_15
    WHERE metric_time__week > '2020-01-01'
    GROUP BY
      metric_time__day
  ) subq_18
  ON
    subq_19.metric_time__day = subq_18.metric_time__day
  WHERE subq_19.metric_time__day BETWEEN '2020-01-03' AND '2020-01-05'
) subq_23
