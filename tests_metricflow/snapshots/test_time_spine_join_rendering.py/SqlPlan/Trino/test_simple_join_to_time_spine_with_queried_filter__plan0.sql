test_name: test_simple_join_to_time_spine_with_queried_filter
test_filename: test_time_spine_join_rendering.py
docstring:
  Test case where metric fills nulls and filter is in group by. Should apply constraint twice.
sql_engine: Trino
---
-- Write to DataTable
SELECT
  subq_10.metric_time__day
  , subq_10.booking__is_instant
  , subq_10.bookings_fill_nulls_with_0
FROM (
  -- Compute Metrics via Expressions
  SELECT
    subq_9.metric_time__day
    , subq_9.booking__is_instant
    , COALESCE(subq_9.bookings, 0) AS bookings_fill_nulls_with_0
  FROM (
    -- Constrain Output with WHERE
    SELECT
      subq_8.metric_time__day
      , subq_8.booking__is_instant
      , subq_8.bookings
    FROM (
      -- Join to Time Spine Dataset
      SELECT
        subq_7.metric_time__day AS metric_time__day
        , subq_4.booking__is_instant AS booking__is_instant
        , subq_4.bookings AS bookings
      FROM (
        -- Pass Only Elements: ['metric_time__day']
        SELECT
          subq_6.metric_time__day
        FROM (
          -- Change Column Aliases
          SELECT
            subq_5.ds__day AS metric_time__day
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
            , subq_5.ds__alien_day
          FROM (
            -- Read From Time Spine 'mf_time_spine'
            SELECT
              time_spine_src_28006.ds AS ds__day
              , DATE_TRUNC('week', time_spine_src_28006.ds) AS ds__week
              , DATE_TRUNC('month', time_spine_src_28006.ds) AS ds__month
              , DATE_TRUNC('quarter', time_spine_src_28006.ds) AS ds__quarter
              , DATE_TRUNC('year', time_spine_src_28006.ds) AS ds__year
              , EXTRACT(year FROM time_spine_src_28006.ds) AS ds__extract_year
              , EXTRACT(quarter FROM time_spine_src_28006.ds) AS ds__extract_quarter
              , EXTRACT(month FROM time_spine_src_28006.ds) AS ds__extract_month
              , EXTRACT(day FROM time_spine_src_28006.ds) AS ds__extract_day
              , EXTRACT(DAY_OF_WEEK FROM time_spine_src_28006.ds) AS ds__extract_dow
              , EXTRACT(doy FROM time_spine_src_28006.ds) AS ds__extract_doy
              , time_spine_src_28006.alien_day AS ds__alien_day
            FROM ***************************.mf_time_spine time_spine_src_28006
          ) subq_5
        ) subq_6
      ) subq_7
      LEFT OUTER JOIN (
        -- Aggregate Measures
        SELECT
          subq_3.metric_time__day
          , subq_3.booking__is_instant
          , SUM(subq_3.bookings) AS bookings
        FROM (
          -- Pass Only Elements: ['bookings', 'booking__is_instant', 'metric_time__day']
          SELECT
            subq_2.metric_time__day
            , subq_2.booking__is_instant
            , subq_2.bookings
          FROM (
            -- Constrain Output with WHERE
            SELECT
              subq_1.ds__day
              , subq_1.ds__week
              , subq_1.ds__month
              , subq_1.ds__quarter
              , subq_1.ds__year
              , subq_1.ds__extract_year
              , subq_1.ds__extract_quarter
              , subq_1.ds__extract_month
              , subq_1.ds__extract_day
              , subq_1.ds__extract_dow
              , subq_1.ds__extract_doy
              , subq_1.ds_partitioned__day
              , subq_1.ds_partitioned__week
              , subq_1.ds_partitioned__month
              , subq_1.ds_partitioned__quarter
              , subq_1.ds_partitioned__year
              , subq_1.ds_partitioned__extract_year
              , subq_1.ds_partitioned__extract_quarter
              , subq_1.ds_partitioned__extract_month
              , subq_1.ds_partitioned__extract_day
              , subq_1.ds_partitioned__extract_dow
              , subq_1.ds_partitioned__extract_doy
              , subq_1.paid_at__day
              , subq_1.paid_at__week
              , subq_1.paid_at__month
              , subq_1.paid_at__quarter
              , subq_1.paid_at__year
              , subq_1.paid_at__extract_year
              , subq_1.paid_at__extract_quarter
              , subq_1.paid_at__extract_month
              , subq_1.paid_at__extract_day
              , subq_1.paid_at__extract_dow
              , subq_1.paid_at__extract_doy
              , subq_1.booking__ds__day
              , subq_1.booking__ds__week
              , subq_1.booking__ds__month
              , subq_1.booking__ds__quarter
              , subq_1.booking__ds__year
              , subq_1.booking__ds__extract_year
              , subq_1.booking__ds__extract_quarter
              , subq_1.booking__ds__extract_month
              , subq_1.booking__ds__extract_day
              , subq_1.booking__ds__extract_dow
              , subq_1.booking__ds__extract_doy
              , subq_1.booking__ds_partitioned__day
              , subq_1.booking__ds_partitioned__week
              , subq_1.booking__ds_partitioned__month
              , subq_1.booking__ds_partitioned__quarter
              , subq_1.booking__ds_partitioned__year
              , subq_1.booking__ds_partitioned__extract_year
              , subq_1.booking__ds_partitioned__extract_quarter
              , subq_1.booking__ds_partitioned__extract_month
              , subq_1.booking__ds_partitioned__extract_day
              , subq_1.booking__ds_partitioned__extract_dow
              , subq_1.booking__ds_partitioned__extract_doy
              , subq_1.booking__paid_at__day
              , subq_1.booking__paid_at__week
              , subq_1.booking__paid_at__month
              , subq_1.booking__paid_at__quarter
              , subq_1.booking__paid_at__year
              , subq_1.booking__paid_at__extract_year
              , subq_1.booking__paid_at__extract_quarter
              , subq_1.booking__paid_at__extract_month
              , subq_1.booking__paid_at__extract_day
              , subq_1.booking__paid_at__extract_dow
              , subq_1.booking__paid_at__extract_doy
              , subq_1.metric_time__day
              , subq_1.metric_time__week
              , subq_1.metric_time__month
              , subq_1.metric_time__quarter
              , subq_1.metric_time__year
              , subq_1.metric_time__extract_year
              , subq_1.metric_time__extract_quarter
              , subq_1.metric_time__extract_month
              , subq_1.metric_time__extract_day
              , subq_1.metric_time__extract_dow
              , subq_1.metric_time__extract_doy
              , subq_1.listing
              , subq_1.guest
              , subq_1.host
              , subq_1.booking__listing
              , subq_1.booking__guest
              , subq_1.booking__host
              , subq_1.is_instant
              , subq_1.booking__is_instant
              , subq_1.bookings
              , subq_1.instant_bookings
              , subq_1.booking_value
              , subq_1.max_booking_value
              , subq_1.min_booking_value
              , subq_1.bookers
              , subq_1.average_booking_value
              , subq_1.referred_bookings
              , subq_1.median_booking_value
              , subq_1.booking_value_p99
              , subq_1.discrete_booking_value_p99
              , subq_1.approximate_continuous_booking_value_p99
              , subq_1.approximate_discrete_booking_value_p99
            FROM (
              -- Metric Time Dimension 'ds'
              SELECT
                subq_0.ds__day
                , subq_0.ds__week
                , subq_0.ds__month
                , subq_0.ds__quarter
                , subq_0.ds__year
                , subq_0.ds__extract_year
                , subq_0.ds__extract_quarter
                , subq_0.ds__extract_month
                , subq_0.ds__extract_day
                , subq_0.ds__extract_dow
                , subq_0.ds__extract_doy
                , subq_0.ds_partitioned__day
                , subq_0.ds_partitioned__week
                , subq_0.ds_partitioned__month
                , subq_0.ds_partitioned__quarter
                , subq_0.ds_partitioned__year
                , subq_0.ds_partitioned__extract_year
                , subq_0.ds_partitioned__extract_quarter
                , subq_0.ds_partitioned__extract_month
                , subq_0.ds_partitioned__extract_day
                , subq_0.ds_partitioned__extract_dow
                , subq_0.ds_partitioned__extract_doy
                , subq_0.paid_at__day
                , subq_0.paid_at__week
                , subq_0.paid_at__month
                , subq_0.paid_at__quarter
                , subq_0.paid_at__year
                , subq_0.paid_at__extract_year
                , subq_0.paid_at__extract_quarter
                , subq_0.paid_at__extract_month
                , subq_0.paid_at__extract_day
                , subq_0.paid_at__extract_dow
                , subq_0.paid_at__extract_doy
                , subq_0.booking__ds__day
                , subq_0.booking__ds__week
                , subq_0.booking__ds__month
                , subq_0.booking__ds__quarter
                , subq_0.booking__ds__year
                , subq_0.booking__ds__extract_year
                , subq_0.booking__ds__extract_quarter
                , subq_0.booking__ds__extract_month
                , subq_0.booking__ds__extract_day
                , subq_0.booking__ds__extract_dow
                , subq_0.booking__ds__extract_doy
                , subq_0.booking__ds_partitioned__day
                , subq_0.booking__ds_partitioned__week
                , subq_0.booking__ds_partitioned__month
                , subq_0.booking__ds_partitioned__quarter
                , subq_0.booking__ds_partitioned__year
                , subq_0.booking__ds_partitioned__extract_year
                , subq_0.booking__ds_partitioned__extract_quarter
                , subq_0.booking__ds_partitioned__extract_month
                , subq_0.booking__ds_partitioned__extract_day
                , subq_0.booking__ds_partitioned__extract_dow
                , subq_0.booking__ds_partitioned__extract_doy
                , subq_0.booking__paid_at__day
                , subq_0.booking__paid_at__week
                , subq_0.booking__paid_at__month
                , subq_0.booking__paid_at__quarter
                , subq_0.booking__paid_at__year
                , subq_0.booking__paid_at__extract_year
                , subq_0.booking__paid_at__extract_quarter
                , subq_0.booking__paid_at__extract_month
                , subq_0.booking__paid_at__extract_day
                , subq_0.booking__paid_at__extract_dow
                , subq_0.booking__paid_at__extract_doy
                , subq_0.ds__day AS metric_time__day
                , subq_0.ds__week AS metric_time__week
                , subq_0.ds__month AS metric_time__month
                , subq_0.ds__quarter AS metric_time__quarter
                , subq_0.ds__year AS metric_time__year
                , subq_0.ds__extract_year AS metric_time__extract_year
                , subq_0.ds__extract_quarter AS metric_time__extract_quarter
                , subq_0.ds__extract_month AS metric_time__extract_month
                , subq_0.ds__extract_day AS metric_time__extract_day
                , subq_0.ds__extract_dow AS metric_time__extract_dow
                , subq_0.ds__extract_doy AS metric_time__extract_doy
                , subq_0.listing
                , subq_0.guest
                , subq_0.host
                , subq_0.booking__listing
                , subq_0.booking__guest
                , subq_0.booking__host
                , subq_0.is_instant
                , subq_0.booking__is_instant
                , subq_0.bookings
                , subq_0.instant_bookings
                , subq_0.booking_value
                , subq_0.max_booking_value
                , subq_0.min_booking_value
                , subq_0.bookers
                , subq_0.average_booking_value
                , subq_0.referred_bookings
                , subq_0.median_booking_value
                , subq_0.booking_value_p99
                , subq_0.discrete_booking_value_p99
                , subq_0.approximate_continuous_booking_value_p99
                , subq_0.approximate_discrete_booking_value_p99
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
              ) subq_0
            ) subq_1
            WHERE booking__is_instant
          ) subq_2
        ) subq_3
        GROUP BY
          subq_3.metric_time__day
          , subq_3.booking__is_instant
      ) subq_4
      ON
        subq_7.metric_time__day = subq_4.metric_time__day
    ) subq_8
    WHERE booking__is_instant
  ) subq_9
) subq_10
