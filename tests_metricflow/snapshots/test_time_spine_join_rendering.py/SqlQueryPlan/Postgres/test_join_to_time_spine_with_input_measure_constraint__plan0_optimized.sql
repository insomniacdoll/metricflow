-- Join to Time Spine Dataset
-- Compute Metrics via Expressions
SELECT
  subq_16.metric_time__day AS metric_time__day
  , subq_15.booking__is_instant AS booking__is_instant
  , subq_15.bookings AS instant_bookings_with_measure_filter
FROM (
  -- Filter Time Spine
  SELECT
    metric_time__day
  FROM (
    -- Time Spine
    SELECT
      ds AS metric_time__day
    FROM ***************************.mf_time_spine subq_17
  ) subq_18
  WHERE metric_time__day > '2020-01-01'
) subq_16
LEFT OUTER JOIN (
  -- Constrain Output with WHERE
  -- Pass Only Elements: ['bookings', 'booking__is_instant', 'metric_time__day']
  -- Aggregate Measures
  SELECT
    metric_time__day
    , booking__is_instant
    , SUM(bookings) AS bookings
  FROM (
    -- Read Elements From Semantic Model 'bookings_source'
    -- Metric Time Dimension 'ds'
    -- Pass Only Elements: ['bookings', 'booking__is_instant', 'metric_time__day', 'listing']
    SELECT
      DATE_TRUNC('day', ds) AS metric_time__day
      , listing_id AS listing
      , is_instant AS booking__is_instant
      , 1 AS bookings
    FROM ***************************.fct_bookings bookings_source_src_28000
  ) subq_12
  WHERE ((booking__is_instant) AND (listing IS NOT NULL)) AND (metric_time__day > '2020-01-01')
  GROUP BY
    metric_time__day
    , booking__is_instant
) subq_15
ON
  subq_16.metric_time__day = subq_15.metric_time__day
