test_name: test_nested_fill_nulls_without_time_spine_multi_metric
test_filename: test_derived_metric_rendering.py
sql_engine: Postgres
---
-- Combine Aggregated Outputs
-- Write to DataTable
SELECT
  COALESCE(subq_19.metric_time__day, subq_24.metric_time__day) AS metric_time__day
  , MAX(subq_19.nested_fill_nulls_without_time_spine) AS nested_fill_nulls_without_time_spine
  , MAX(subq_24.listings) AS listings
FROM (
  -- Compute Metrics via Expressions
  SELECT
    metric_time__day
    , 3 * twice_bookings_fill_nulls_with_0_without_time_spine AS nested_fill_nulls_without_time_spine
  FROM (
    -- Compute Metrics via Expressions
    SELECT
      metric_time__day
      , 2 * bookings_fill_nulls_with_0_without_time_spine AS twice_bookings_fill_nulls_with_0_without_time_spine
    FROM (
      -- Compute Metrics via Expressions
      SELECT
        metric_time__day
        , COALESCE(bookings, 0) AS bookings_fill_nulls_with_0_without_time_spine
      FROM (
        -- Aggregate Measures
        SELECT
          metric_time__day
          , SUM(bookings) AS bookings
        FROM (
          -- Read Elements From Semantic Model 'bookings_source'
          -- Metric Time Dimension 'ds'
          -- Pass Only Elements: ['bookings', 'metric_time__day']
          SELECT
            DATE_TRUNC('day', ds) AS metric_time__day
            , 1 AS bookings
          FROM ***************************.fct_bookings bookings_source_src_28000
        ) subq_15
        GROUP BY
          metric_time__day
      ) subq_16
    ) subq_17
  ) subq_18
) subq_19
FULL OUTER JOIN (
  -- Aggregate Measures
  -- Compute Metrics via Expressions
  SELECT
    metric_time__day
    , SUM(listings) AS listings
  FROM (
    -- Read Elements From Semantic Model 'listings_latest'
    -- Metric Time Dimension 'ds'
    -- Pass Only Elements: ['listings', 'metric_time__day']
    SELECT
      DATE_TRUNC('day', created_at) AS metric_time__day
      , 1 AS listings
    FROM ***************************.dim_listings_latest listings_latest_src_28000
  ) subq_22
  GROUP BY
    metric_time__day
) subq_24
ON
  subq_19.metric_time__day = subq_24.metric_time__day
GROUP BY
  COALESCE(subq_19.metric_time__day, subq_24.metric_time__day)
