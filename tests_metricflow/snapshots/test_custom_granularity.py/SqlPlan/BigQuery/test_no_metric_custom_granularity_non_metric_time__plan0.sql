test_name: test_no_metric_custom_granularity_non_metric_time
test_filename: test_custom_granularity.py
sql_engine: BigQuery
---
-- Write to DataTable
SELECT
  subq_2.booking__ds__alien_day
FROM (
  -- Pass Only Elements: ['booking__ds__alien_day']
  SELECT
    subq_1.booking__ds__alien_day
  FROM (
    -- Read Elements From Semantic Model 'bookings_source'
    -- Join to Custom Granularity Dataset
    SELECT
      1 AS bookings
      , CASE WHEN is_instant THEN 1 ELSE 0 END AS instant_bookings
      , bookings_source_src_28000.booking_value AS booking_value
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
      , bookings_source_src_28000.is_instant AS is_instant
      , DATETIME_TRUNC(bookings_source_src_28000.ds, day) AS ds__day
      , DATETIME_TRUNC(bookings_source_src_28000.ds, isoweek) AS ds__week
      , DATETIME_TRUNC(bookings_source_src_28000.ds, month) AS ds__month
      , DATETIME_TRUNC(bookings_source_src_28000.ds, quarter) AS ds__quarter
      , DATETIME_TRUNC(bookings_source_src_28000.ds, year) AS ds__year
      , EXTRACT(year FROM bookings_source_src_28000.ds) AS ds__extract_year
      , EXTRACT(quarter FROM bookings_source_src_28000.ds) AS ds__extract_quarter
      , EXTRACT(month FROM bookings_source_src_28000.ds) AS ds__extract_month
      , EXTRACT(day FROM bookings_source_src_28000.ds) AS ds__extract_day
      , IF(EXTRACT(dayofweek FROM bookings_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM bookings_source_src_28000.ds) - 1) AS ds__extract_dow
      , EXTRACT(dayofyear FROM bookings_source_src_28000.ds) AS ds__extract_doy
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, day) AS ds_partitioned__day
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, isoweek) AS ds_partitioned__week
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, month) AS ds_partitioned__month
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, quarter) AS ds_partitioned__quarter
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, year) AS ds_partitioned__year
      , EXTRACT(year FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_year
      , EXTRACT(quarter FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_quarter
      , EXTRACT(month FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_month
      , EXTRACT(day FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_day
      , IF(EXTRACT(dayofweek FROM bookings_source_src_28000.ds_partitioned) = 1, 7, EXTRACT(dayofweek FROM bookings_source_src_28000.ds_partitioned) - 1) AS ds_partitioned__extract_dow
      , EXTRACT(dayofyear FROM bookings_source_src_28000.ds_partitioned) AS ds_partitioned__extract_doy
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, day) AS paid_at__day
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, isoweek) AS paid_at__week
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, month) AS paid_at__month
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, quarter) AS paid_at__quarter
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, year) AS paid_at__year
      , EXTRACT(year FROM bookings_source_src_28000.paid_at) AS paid_at__extract_year
      , EXTRACT(quarter FROM bookings_source_src_28000.paid_at) AS paid_at__extract_quarter
      , EXTRACT(month FROM bookings_source_src_28000.paid_at) AS paid_at__extract_month
      , EXTRACT(day FROM bookings_source_src_28000.paid_at) AS paid_at__extract_day
      , IF(EXTRACT(dayofweek FROM bookings_source_src_28000.paid_at) = 1, 7, EXTRACT(dayofweek FROM bookings_source_src_28000.paid_at) - 1) AS paid_at__extract_dow
      , EXTRACT(dayofyear FROM bookings_source_src_28000.paid_at) AS paid_at__extract_doy
      , bookings_source_src_28000.is_instant AS booking__is_instant
      , DATETIME_TRUNC(bookings_source_src_28000.ds, day) AS booking__ds__day
      , DATETIME_TRUNC(bookings_source_src_28000.ds, isoweek) AS booking__ds__week
      , DATETIME_TRUNC(bookings_source_src_28000.ds, month) AS booking__ds__month
      , DATETIME_TRUNC(bookings_source_src_28000.ds, quarter) AS booking__ds__quarter
      , DATETIME_TRUNC(bookings_source_src_28000.ds, year) AS booking__ds__year
      , EXTRACT(year FROM bookings_source_src_28000.ds) AS booking__ds__extract_year
      , EXTRACT(quarter FROM bookings_source_src_28000.ds) AS booking__ds__extract_quarter
      , EXTRACT(month FROM bookings_source_src_28000.ds) AS booking__ds__extract_month
      , EXTRACT(day FROM bookings_source_src_28000.ds) AS booking__ds__extract_day
      , IF(EXTRACT(dayofweek FROM bookings_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM bookings_source_src_28000.ds) - 1) AS booking__ds__extract_dow
      , EXTRACT(dayofyear FROM bookings_source_src_28000.ds) AS booking__ds__extract_doy
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, day) AS booking__ds_partitioned__day
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, isoweek) AS booking__ds_partitioned__week
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, month) AS booking__ds_partitioned__month
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, quarter) AS booking__ds_partitioned__quarter
      , DATETIME_TRUNC(bookings_source_src_28000.ds_partitioned, year) AS booking__ds_partitioned__year
      , EXTRACT(year FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_year
      , EXTRACT(quarter FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_quarter
      , EXTRACT(month FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_month
      , EXTRACT(day FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_day
      , IF(EXTRACT(dayofweek FROM bookings_source_src_28000.ds_partitioned) = 1, 7, EXTRACT(dayofweek FROM bookings_source_src_28000.ds_partitioned) - 1) AS booking__ds_partitioned__extract_dow
      , EXTRACT(dayofyear FROM bookings_source_src_28000.ds_partitioned) AS booking__ds_partitioned__extract_doy
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, day) AS booking__paid_at__day
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, isoweek) AS booking__paid_at__week
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, month) AS booking__paid_at__month
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, quarter) AS booking__paid_at__quarter
      , DATETIME_TRUNC(bookings_source_src_28000.paid_at, year) AS booking__paid_at__year
      , EXTRACT(year FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_year
      , EXTRACT(quarter FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_quarter
      , EXTRACT(month FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_month
      , EXTRACT(day FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_day
      , IF(EXTRACT(dayofweek FROM bookings_source_src_28000.paid_at) = 1, 7, EXTRACT(dayofweek FROM bookings_source_src_28000.paid_at) - 1) AS booking__paid_at__extract_dow
      , EXTRACT(dayofyear FROM bookings_source_src_28000.paid_at) AS booking__paid_at__extract_doy
      , bookings_source_src_28000.listing_id AS listing
      , bookings_source_src_28000.guest_id AS guest
      , bookings_source_src_28000.host_id AS host
      , bookings_source_src_28000.listing_id AS booking__listing
      , bookings_source_src_28000.guest_id AS booking__guest
      , bookings_source_src_28000.host_id AS booking__host
      , subq_0.alien_day AS booking__ds__alien_day
    FROM ***************************.fct_bookings bookings_source_src_28000
    LEFT OUTER JOIN
      ***************************.mf_time_spine subq_0
    ON
      DATETIME_TRUNC(bookings_source_src_28000.ds, day) = subq_0.ds
  ) subq_1
  GROUP BY
    booking__ds__alien_day
) subq_2
