test_name: test_query_with_simple_metric_in_where_filter
test_filename: test_metric_filter_rendering.py
docstring:
  Tests a query with a simple metric in the query-level where filter.
sql_engine: Trino
---
-- Write to DataTable
SELECT
  subq_15.listings
FROM (
  -- Compute Metrics via Expressions
  SELECT
    subq_14.listings
  FROM (
    -- Aggregate Measures
    SELECT
      SUM(subq_13.listings) AS listings
    FROM (
      -- Pass Only Elements: ['listings']
      SELECT
        subq_12.listings
      FROM (
        -- Constrain Output with WHERE
        SELECT
          subq_11.ds__day
          , subq_11.ds__week
          , subq_11.ds__month
          , subq_11.ds__quarter
          , subq_11.ds__year
          , subq_11.ds__extract_year
          , subq_11.ds__extract_quarter
          , subq_11.ds__extract_month
          , subq_11.ds__extract_day
          , subq_11.ds__extract_dow
          , subq_11.ds__extract_doy
          , subq_11.created_at__day
          , subq_11.created_at__week
          , subq_11.created_at__month
          , subq_11.created_at__quarter
          , subq_11.created_at__year
          , subq_11.created_at__extract_year
          , subq_11.created_at__extract_quarter
          , subq_11.created_at__extract_month
          , subq_11.created_at__extract_day
          , subq_11.created_at__extract_dow
          , subq_11.created_at__extract_doy
          , subq_11.listing__ds__day
          , subq_11.listing__ds__week
          , subq_11.listing__ds__month
          , subq_11.listing__ds__quarter
          , subq_11.listing__ds__year
          , subq_11.listing__ds__extract_year
          , subq_11.listing__ds__extract_quarter
          , subq_11.listing__ds__extract_month
          , subq_11.listing__ds__extract_day
          , subq_11.listing__ds__extract_dow
          , subq_11.listing__ds__extract_doy
          , subq_11.listing__created_at__day
          , subq_11.listing__created_at__week
          , subq_11.listing__created_at__month
          , subq_11.listing__created_at__quarter
          , subq_11.listing__created_at__year
          , subq_11.listing__created_at__extract_year
          , subq_11.listing__created_at__extract_quarter
          , subq_11.listing__created_at__extract_month
          , subq_11.listing__created_at__extract_day
          , subq_11.listing__created_at__extract_dow
          , subq_11.listing__created_at__extract_doy
          , subq_11.metric_time__day
          , subq_11.metric_time__week
          , subq_11.metric_time__month
          , subq_11.metric_time__quarter
          , subq_11.metric_time__year
          , subq_11.metric_time__extract_year
          , subq_11.metric_time__extract_quarter
          , subq_11.metric_time__extract_month
          , subq_11.metric_time__extract_day
          , subq_11.metric_time__extract_dow
          , subq_11.metric_time__extract_doy
          , subq_11.listing
          , subq_11.user
          , subq_11.listing__user
          , subq_11.country_latest
          , subq_11.is_lux_latest
          , subq_11.capacity_latest
          , subq_11.listing__country_latest
          , subq_11.listing__is_lux_latest
          , subq_11.listing__capacity_latest
          , subq_11.listing__bookings
          , subq_11.listings
          , subq_11.largest_listing
          , subq_11.smallest_listing
        FROM (
          -- Join Standard Outputs
          SELECT
            subq_10.listing__bookings AS listing__bookings
            , subq_4.ds__day AS ds__day
            , subq_4.ds__week AS ds__week
            , subq_4.ds__month AS ds__month
            , subq_4.ds__quarter AS ds__quarter
            , subq_4.ds__year AS ds__year
            , subq_4.ds__extract_year AS ds__extract_year
            , subq_4.ds__extract_quarter AS ds__extract_quarter
            , subq_4.ds__extract_month AS ds__extract_month
            , subq_4.ds__extract_day AS ds__extract_day
            , subq_4.ds__extract_dow AS ds__extract_dow
            , subq_4.ds__extract_doy AS ds__extract_doy
            , subq_4.created_at__day AS created_at__day
            , subq_4.created_at__week AS created_at__week
            , subq_4.created_at__month AS created_at__month
            , subq_4.created_at__quarter AS created_at__quarter
            , subq_4.created_at__year AS created_at__year
            , subq_4.created_at__extract_year AS created_at__extract_year
            , subq_4.created_at__extract_quarter AS created_at__extract_quarter
            , subq_4.created_at__extract_month AS created_at__extract_month
            , subq_4.created_at__extract_day AS created_at__extract_day
            , subq_4.created_at__extract_dow AS created_at__extract_dow
            , subq_4.created_at__extract_doy AS created_at__extract_doy
            , subq_4.listing__ds__day AS listing__ds__day
            , subq_4.listing__ds__week AS listing__ds__week
            , subq_4.listing__ds__month AS listing__ds__month
            , subq_4.listing__ds__quarter AS listing__ds__quarter
            , subq_4.listing__ds__year AS listing__ds__year
            , subq_4.listing__ds__extract_year AS listing__ds__extract_year
            , subq_4.listing__ds__extract_quarter AS listing__ds__extract_quarter
            , subq_4.listing__ds__extract_month AS listing__ds__extract_month
            , subq_4.listing__ds__extract_day AS listing__ds__extract_day
            , subq_4.listing__ds__extract_dow AS listing__ds__extract_dow
            , subq_4.listing__ds__extract_doy AS listing__ds__extract_doy
            , subq_4.listing__created_at__day AS listing__created_at__day
            , subq_4.listing__created_at__week AS listing__created_at__week
            , subq_4.listing__created_at__month AS listing__created_at__month
            , subq_4.listing__created_at__quarter AS listing__created_at__quarter
            , subq_4.listing__created_at__year AS listing__created_at__year
            , subq_4.listing__created_at__extract_year AS listing__created_at__extract_year
            , subq_4.listing__created_at__extract_quarter AS listing__created_at__extract_quarter
            , subq_4.listing__created_at__extract_month AS listing__created_at__extract_month
            , subq_4.listing__created_at__extract_day AS listing__created_at__extract_day
            , subq_4.listing__created_at__extract_dow AS listing__created_at__extract_dow
            , subq_4.listing__created_at__extract_doy AS listing__created_at__extract_doy
            , subq_4.metric_time__day AS metric_time__day
            , subq_4.metric_time__week AS metric_time__week
            , subq_4.metric_time__month AS metric_time__month
            , subq_4.metric_time__quarter AS metric_time__quarter
            , subq_4.metric_time__year AS metric_time__year
            , subq_4.metric_time__extract_year AS metric_time__extract_year
            , subq_4.metric_time__extract_quarter AS metric_time__extract_quarter
            , subq_4.metric_time__extract_month AS metric_time__extract_month
            , subq_4.metric_time__extract_day AS metric_time__extract_day
            , subq_4.metric_time__extract_dow AS metric_time__extract_dow
            , subq_4.metric_time__extract_doy AS metric_time__extract_doy
            , subq_4.listing AS listing
            , subq_4.user AS user
            , subq_4.listing__user AS listing__user
            , subq_4.country_latest AS country_latest
            , subq_4.is_lux_latest AS is_lux_latest
            , subq_4.capacity_latest AS capacity_latest
            , subq_4.listing__country_latest AS listing__country_latest
            , subq_4.listing__is_lux_latest AS listing__is_lux_latest
            , subq_4.listing__capacity_latest AS listing__capacity_latest
            , subq_4.listings AS listings
            , subq_4.largest_listing AS largest_listing
            , subq_4.smallest_listing AS smallest_listing
          FROM (
            -- Metric Time Dimension 'ds'
            SELECT
              subq_3.ds__day
              , subq_3.ds__week
              , subq_3.ds__month
              , subq_3.ds__quarter
              , subq_3.ds__year
              , subq_3.ds__extract_year
              , subq_3.ds__extract_quarter
              , subq_3.ds__extract_month
              , subq_3.ds__extract_day
              , subq_3.ds__extract_dow
              , subq_3.ds__extract_doy
              , subq_3.created_at__day
              , subq_3.created_at__week
              , subq_3.created_at__month
              , subq_3.created_at__quarter
              , subq_3.created_at__year
              , subq_3.created_at__extract_year
              , subq_3.created_at__extract_quarter
              , subq_3.created_at__extract_month
              , subq_3.created_at__extract_day
              , subq_3.created_at__extract_dow
              , subq_3.created_at__extract_doy
              , subq_3.listing__ds__day
              , subq_3.listing__ds__week
              , subq_3.listing__ds__month
              , subq_3.listing__ds__quarter
              , subq_3.listing__ds__year
              , subq_3.listing__ds__extract_year
              , subq_3.listing__ds__extract_quarter
              , subq_3.listing__ds__extract_month
              , subq_3.listing__ds__extract_day
              , subq_3.listing__ds__extract_dow
              , subq_3.listing__ds__extract_doy
              , subq_3.listing__created_at__day
              , subq_3.listing__created_at__week
              , subq_3.listing__created_at__month
              , subq_3.listing__created_at__quarter
              , subq_3.listing__created_at__year
              , subq_3.listing__created_at__extract_year
              , subq_3.listing__created_at__extract_quarter
              , subq_3.listing__created_at__extract_month
              , subq_3.listing__created_at__extract_day
              , subq_3.listing__created_at__extract_dow
              , subq_3.listing__created_at__extract_doy
              , subq_3.ds__day AS metric_time__day
              , subq_3.ds__week AS metric_time__week
              , subq_3.ds__month AS metric_time__month
              , subq_3.ds__quarter AS metric_time__quarter
              , subq_3.ds__year AS metric_time__year
              , subq_3.ds__extract_year AS metric_time__extract_year
              , subq_3.ds__extract_quarter AS metric_time__extract_quarter
              , subq_3.ds__extract_month AS metric_time__extract_month
              , subq_3.ds__extract_day AS metric_time__extract_day
              , subq_3.ds__extract_dow AS metric_time__extract_dow
              , subq_3.ds__extract_doy AS metric_time__extract_doy
              , subq_3.listing
              , subq_3.user
              , subq_3.listing__user
              , subq_3.country_latest
              , subq_3.is_lux_latest
              , subq_3.capacity_latest
              , subq_3.listing__country_latest
              , subq_3.listing__is_lux_latest
              , subq_3.listing__capacity_latest
              , subq_3.listings
              , subq_3.largest_listing
              , subq_3.smallest_listing
            FROM (
              -- Read Elements From Semantic Model 'listings_latest'
              SELECT
                1 AS listings
                , listings_latest_src_28000.capacity AS largest_listing
                , listings_latest_src_28000.capacity AS smallest_listing
                , DATE_TRUNC('day', listings_latest_src_28000.created_at) AS ds__day
                , DATE_TRUNC('week', listings_latest_src_28000.created_at) AS ds__week
                , DATE_TRUNC('month', listings_latest_src_28000.created_at) AS ds__month
                , DATE_TRUNC('quarter', listings_latest_src_28000.created_at) AS ds__quarter
                , DATE_TRUNC('year', listings_latest_src_28000.created_at) AS ds__year
                , EXTRACT(year FROM listings_latest_src_28000.created_at) AS ds__extract_year
                , EXTRACT(quarter FROM listings_latest_src_28000.created_at) AS ds__extract_quarter
                , EXTRACT(month FROM listings_latest_src_28000.created_at) AS ds__extract_month
                , EXTRACT(day FROM listings_latest_src_28000.created_at) AS ds__extract_day
                , EXTRACT(DAY_OF_WEEK FROM listings_latest_src_28000.created_at) AS ds__extract_dow
                , EXTRACT(doy FROM listings_latest_src_28000.created_at) AS ds__extract_doy
                , DATE_TRUNC('day', listings_latest_src_28000.created_at) AS created_at__day
                , DATE_TRUNC('week', listings_latest_src_28000.created_at) AS created_at__week
                , DATE_TRUNC('month', listings_latest_src_28000.created_at) AS created_at__month
                , DATE_TRUNC('quarter', listings_latest_src_28000.created_at) AS created_at__quarter
                , DATE_TRUNC('year', listings_latest_src_28000.created_at) AS created_at__year
                , EXTRACT(year FROM listings_latest_src_28000.created_at) AS created_at__extract_year
                , EXTRACT(quarter FROM listings_latest_src_28000.created_at) AS created_at__extract_quarter
                , EXTRACT(month FROM listings_latest_src_28000.created_at) AS created_at__extract_month
                , EXTRACT(day FROM listings_latest_src_28000.created_at) AS created_at__extract_day
                , EXTRACT(DAY_OF_WEEK FROM listings_latest_src_28000.created_at) AS created_at__extract_dow
                , EXTRACT(doy FROM listings_latest_src_28000.created_at) AS created_at__extract_doy
                , listings_latest_src_28000.country AS country_latest
                , listings_latest_src_28000.is_lux AS is_lux_latest
                , listings_latest_src_28000.capacity AS capacity_latest
                , DATE_TRUNC('day', listings_latest_src_28000.created_at) AS listing__ds__day
                , DATE_TRUNC('week', listings_latest_src_28000.created_at) AS listing__ds__week
                , DATE_TRUNC('month', listings_latest_src_28000.created_at) AS listing__ds__month
                , DATE_TRUNC('quarter', listings_latest_src_28000.created_at) AS listing__ds__quarter
                , DATE_TRUNC('year', listings_latest_src_28000.created_at) AS listing__ds__year
                , EXTRACT(year FROM listings_latest_src_28000.created_at) AS listing__ds__extract_year
                , EXTRACT(quarter FROM listings_latest_src_28000.created_at) AS listing__ds__extract_quarter
                , EXTRACT(month FROM listings_latest_src_28000.created_at) AS listing__ds__extract_month
                , EXTRACT(day FROM listings_latest_src_28000.created_at) AS listing__ds__extract_day
                , EXTRACT(DAY_OF_WEEK FROM listings_latest_src_28000.created_at) AS listing__ds__extract_dow
                , EXTRACT(doy FROM listings_latest_src_28000.created_at) AS listing__ds__extract_doy
                , DATE_TRUNC('day', listings_latest_src_28000.created_at) AS listing__created_at__day
                , DATE_TRUNC('week', listings_latest_src_28000.created_at) AS listing__created_at__week
                , DATE_TRUNC('month', listings_latest_src_28000.created_at) AS listing__created_at__month
                , DATE_TRUNC('quarter', listings_latest_src_28000.created_at) AS listing__created_at__quarter
                , DATE_TRUNC('year', listings_latest_src_28000.created_at) AS listing__created_at__year
                , EXTRACT(year FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_year
                , EXTRACT(quarter FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_quarter
                , EXTRACT(month FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_month
                , EXTRACT(day FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_day
                , EXTRACT(DAY_OF_WEEK FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_dow
                , EXTRACT(doy FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_doy
                , listings_latest_src_28000.country AS listing__country_latest
                , listings_latest_src_28000.is_lux AS listing__is_lux_latest
                , listings_latest_src_28000.capacity AS listing__capacity_latest
                , listings_latest_src_28000.listing_id AS listing
                , listings_latest_src_28000.user_id AS user
                , listings_latest_src_28000.user_id AS listing__user
              FROM ***************************.dim_listings_latest listings_latest_src_28000
            ) subq_3
          ) subq_4
          LEFT OUTER JOIN (
            -- Pass Only Elements: ['listing', 'listing__bookings']
            SELECT
              subq_9.listing
              , subq_9.listing__bookings
            FROM (
              -- Compute Metrics via Expressions
              SELECT
                subq_8.listing
                , subq_8.bookings AS listing__bookings
              FROM (
                -- Aggregate Measures
                SELECT
                  subq_7.listing
                  , SUM(subq_7.bookings) AS bookings
                FROM (
                  -- Pass Only Elements: ['bookings', 'listing']
                  SELECT
                    subq_6.listing
                    , subq_6.bookings
                  FROM (
                    -- Metric Time Dimension 'ds'
                    SELECT
                      subq_5.ds__day
                      , subq_5.ds__week
                      , subq_5.ds__month
                      , subq_5.ds__quarter
                      , subq_5.ds__year
                      , subq_5.ds__extract_year
                      , subq_5.ds__extract_quarter
                      , subq_5.ds__extract_month
                      , subq_5.ds__extract_day
                      , subq_5.ds__extract_dow
                      , subq_5.ds__extract_doy
                      , subq_5.ds_partitioned__day
                      , subq_5.ds_partitioned__week
                      , subq_5.ds_partitioned__month
                      , subq_5.ds_partitioned__quarter
                      , subq_5.ds_partitioned__year
                      , subq_5.ds_partitioned__extract_year
                      , subq_5.ds_partitioned__extract_quarter
                      , subq_5.ds_partitioned__extract_month
                      , subq_5.ds_partitioned__extract_day
                      , subq_5.ds_partitioned__extract_dow
                      , subq_5.ds_partitioned__extract_doy
                      , subq_5.paid_at__day
                      , subq_5.paid_at__week
                      , subq_5.paid_at__month
                      , subq_5.paid_at__quarter
                      , subq_5.paid_at__year
                      , subq_5.paid_at__extract_year
                      , subq_5.paid_at__extract_quarter
                      , subq_5.paid_at__extract_month
                      , subq_5.paid_at__extract_day
                      , subq_5.paid_at__extract_dow
                      , subq_5.paid_at__extract_doy
                      , subq_5.booking__ds__day
                      , subq_5.booking__ds__week
                      , subq_5.booking__ds__month
                      , subq_5.booking__ds__quarter
                      , subq_5.booking__ds__year
                      , subq_5.booking__ds__extract_year
                      , subq_5.booking__ds__extract_quarter
                      , subq_5.booking__ds__extract_month
                      , subq_5.booking__ds__extract_day
                      , subq_5.booking__ds__extract_dow
                      , subq_5.booking__ds__extract_doy
                      , subq_5.booking__ds_partitioned__day
                      , subq_5.booking__ds_partitioned__week
                      , subq_5.booking__ds_partitioned__month
                      , subq_5.booking__ds_partitioned__quarter
                      , subq_5.booking__ds_partitioned__year
                      , subq_5.booking__ds_partitioned__extract_year
                      , subq_5.booking__ds_partitioned__extract_quarter
                      , subq_5.booking__ds_partitioned__extract_month
                      , subq_5.booking__ds_partitioned__extract_day
                      , subq_5.booking__ds_partitioned__extract_dow
                      , subq_5.booking__ds_partitioned__extract_doy
                      , subq_5.booking__paid_at__day
                      , subq_5.booking__paid_at__week
                      , subq_5.booking__paid_at__month
                      , subq_5.booking__paid_at__quarter
                      , subq_5.booking__paid_at__year
                      , subq_5.booking__paid_at__extract_year
                      , subq_5.booking__paid_at__extract_quarter
                      , subq_5.booking__paid_at__extract_month
                      , subq_5.booking__paid_at__extract_day
                      , subq_5.booking__paid_at__extract_dow
                      , subq_5.booking__paid_at__extract_doy
                      , subq_5.ds__day AS metric_time__day
                      , subq_5.ds__week AS metric_time__week
                      , subq_5.ds__month AS metric_time__month
                      , subq_5.ds__quarter AS metric_time__quarter
                      , subq_5.ds__year AS metric_time__year
                      , subq_5.ds__extract_year AS metric_time__extract_year
                      , subq_5.ds__extract_quarter AS metric_time__extract_quarter
                      , subq_5.ds__extract_month AS metric_time__extract_month
                      , subq_5.ds__extract_day AS metric_time__extract_day
                      , subq_5.ds__extract_dow AS metric_time__extract_dow
                      , subq_5.ds__extract_doy AS metric_time__extract_doy
                      , subq_5.listing
                      , subq_5.guest
                      , subq_5.host
                      , subq_5.booking__listing
                      , subq_5.booking__guest
                      , subq_5.booking__host
                      , subq_5.is_instant
                      , subq_5.booking__is_instant
                      , subq_5.bookings
                      , subq_5.instant_bookings
                      , subq_5.booking_value
                      , subq_5.max_booking_value
                      , subq_5.min_booking_value
                      , subq_5.bookers
                      , subq_5.average_booking_value
                      , subq_5.referred_bookings
                      , subq_5.median_booking_value
                      , subq_5.booking_value_p99
                      , subq_5.discrete_booking_value_p99
                      , subq_5.approximate_continuous_booking_value_p99
                      , subq_5.approximate_discrete_booking_value_p99
                    FROM (
                      -- Read Elements From Semantic Model 'bookings_source'
                      SELECT
                        1 AS bookings
                        , CASE WHEN is_instant THEN 1 ELSE 0 END AS instant_bookings
                        , bookings_source_src_28000.booking_value
                        , bookings_source_src_28000.booking_value AS max_booking_value
                        , bookings_source_src_28000.booking_value AS min_booking_value
                        , bookings_source_src_28000.guest_id AS bookers
                        , bookings_source_src_28000.booking_value AS average_booking_value
                        , bookings_source_src_28000.booking_value AS booking_payments
                        , CASE WHEN referrer_id IS NOT NULL THEN 1 ELSE 0 END AS referred_bookings
                        , bookings_source_src_28000.booking_value AS median_booking_value
                        , bookings_source_src_28000.booking_value AS booking_value_p99
                        , bookings_source_src_28000.booking_value AS discrete_booking_value_p99
                        , bookings_source_src_28000.booking_value AS approximate_continuous_booking_value_p99
                        , bookings_source_src_28000.booking_value AS approximate_discrete_booking_value_p99
                        , bookings_source_src_28000.is_instant
                        , DATE_TRUNC('day', bookings_source_src_28000.ds) AS ds__day
                        , DATE_TRUNC('week', bookings_source_src_28000.ds) AS ds__week
                        , DATE_TRUNC('month', bookings_source_src_28000.ds) AS ds__month
                        , DATE_TRUNC('quarter', bookings_source_src_28000.ds) AS ds__quarter
                        , DATE_TRUNC('year', bookings_source_src_28000.ds) AS ds__year
                        , EXTRACT(year FROM bookings_source_src_28000.ds) AS ds__extract_year
                        , EXTRACT(quarter FROM bookings_source_src_28000.ds) AS ds__extract_quarter
                        , EXTRACT(month FROM bookings_source_src_28000.ds) AS ds__extract_month
                        , EXTRACT(day FROM bookings_source_src_28000.ds) AS ds__extract_day
                        , EXTRACT(DAY_OF_WEEK FROM bookings_source_src_28000.ds) AS ds__extract_dow
                        , EXTRACT(doy FROM bookings_source_src_28000.ds) AS ds__extract_doy
                        , DATE_TRUNC('day', bookings_source_src_28000.ds_partitioned) AS ds_partitioned__day
                        , DATE_TRUNC('week', bookings_source_src_28000.ds_partitioned) AS ds_partitioned__week
                        , DATE_TRUNC('month', bookings_source_src_28000.ds_partitioned) AS ds_partitioned__month
                        , DATE_TRUNC('quarter', bookings_source_src_28000.ds_partitioned) AS ds_partitioned__quarter
                        , DATE_TRUNC('year', bookings_source_src_28000.ds_partitioned) AS ds_partitioned__year
                        , EXTRACT(year FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_year
                        , EXTRACT(quarter FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_quarter
                        , EXTRACT(month FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_month
                        , EXTRACT(day FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_day
                        , EXTRACT(DAY_OF_WEEK FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_dow
                        , EXTRACT(doy FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_doy
                        , DATE_TRUNC('day', bookings_source_src_28000.paid_at) AS paid_at__day
                        , DATE_TRUNC('week', bookings_source_src_28000.paid_at) AS paid_at__week
                        , DATE_TRUNC('month', bookings_source_src_28000.paid_at) AS paid_at__month
                        , DATE_TRUNC('quarter', bookings_source_src_28000.paid_at) AS paid_at__quarter
                        , DATE_TRUNC('year', bookings_source_src_28000.paid_at) AS paid_at__year
                        , EXTRACT(year FROM bookings_source_src_28000.paid_at) AS paid_at__extract_year
                        , EXTRACT(quarter FROM bookings_source_src_28000.paid_at) AS paid_at__extract_quarter
                        , EXTRACT(month FROM bookings_source_src_28000.paid_at) AS paid_at__extract_month
                        , EXTRACT(day FROM bookings_source_src_28000.paid_at) AS paid_at__extract_day
                        , EXTRACT(DAY_OF_WEEK FROM bookings_source_src_28000.paid_at) AS paid_at__extract_dow
                        , EXTRACT(doy FROM bookings_source_src_28000.paid_at) AS paid_at__extract_doy
                        , bookings_source_src_28000.is_instant AS booking__is_instant
                        , DATE_TRUNC('day', bookings_source_src_28000.ds) AS booking__ds__day
                        , DATE_TRUNC('week', bookings_source_src_28000.ds) AS booking__ds__week
                        , DATE_TRUNC('month', bookings_source_src_28000.ds) AS booking__ds__month
                        , DATE_TRUNC('quarter', bookings_source_src_28000.ds) AS booking__ds__quarter
                        , DATE_TRUNC('year', bookings_source_src_28000.ds) AS booking__ds__year
                        , EXTRACT(year FROM bookings_source_src_28000.ds) AS booking__ds__extract_year
                        , EXTRACT(quarter FROM bookings_source_src_28000.ds) AS booking__ds__extract_quarter
                        , EXTRACT(month FROM bookings_source_src_28000.ds) AS booking__ds__extract_month
                        , EXTRACT(day FROM bookings_source_src_28000.ds) AS booking__ds__extract_day
                        , EXTRACT(DAY_OF_WEEK FROM bookings_source_src_28000.ds) AS booking__ds__extract_dow
                        , EXTRACT(doy FROM bookings_source_src_28000.ds) AS booking__ds__extract_doy
                        , DATE_TRUNC('day', bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__day
                        , DATE_TRUNC('week', bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__week
                        , DATE_TRUNC('month', bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__month
                        , DATE_TRUNC('quarter', bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__quarter
                        , DATE_TRUNC('year', bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__year
                        , EXTRACT(year FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_year
                        , EXTRACT(quarter FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_quarter
                        , EXTRACT(month FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_month
                        , EXTRACT(day FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_day
                        , EXTRACT(DAY_OF_WEEK FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_dow
                        , EXTRACT(doy FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_doy
                        , DATE_TRUNC('day', bookings_source_src_28000.paid_at) AS booking__paid_at__day
                        , DATE_TRUNC('week', bookings_source_src_28000.paid_at) AS booking__paid_at__week
                        , DATE_TRUNC('month', bookings_source_src_28000.paid_at) AS booking__paid_at__month
                        , DATE_TRUNC('quarter', bookings_source_src_28000.paid_at) AS booking__paid_at__quarter
                        , DATE_TRUNC('year', bookings_source_src_28000.paid_at) AS booking__paid_at__year
                        , EXTRACT(year FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_year
                        , EXTRACT(quarter FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_quarter
                        , EXTRACT(month FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_month
                        , EXTRACT(day FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_day
                        , EXTRACT(DAY_OF_WEEK FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_dow
                        , EXTRACT(doy FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_doy
                        , bookings_source_src_28000.listing_id AS listing
                        , bookings_source_src_28000.guest_id AS guest
                        , bookings_source_src_28000.host_id AS host
                        , bookings_source_src_28000.listing_id AS booking__listing
                        , bookings_source_src_28000.guest_id AS booking__guest
                        , bookings_source_src_28000.host_id AS booking__host
                      FROM ***************************.fct_bookings bookings_source_src_28000
                    ) subq_5
                  ) subq_6
                ) subq_7
                GROUP BY
                  subq_7.listing
              ) subq_8
            ) subq_9
          ) subq_10
          ON
            subq_4.listing = subq_10.listing
        ) subq_11
        WHERE listing__bookings > 2
      ) subq_12
    ) subq_13
  ) subq_14
) subq_15
