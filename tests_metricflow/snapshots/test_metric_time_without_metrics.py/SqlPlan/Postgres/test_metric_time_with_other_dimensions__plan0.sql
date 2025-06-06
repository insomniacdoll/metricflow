test_name: test_metric_time_with_other_dimensions
test_filename: test_metric_time_without_metrics.py
sql_engine: Postgres
---
-- Write to DataTable
SELECT
  subq_7.metric_time__day
  , subq_7.listing__is_lux_latest
  , subq_7.user__home_state_latest
FROM (
  -- Pass Only Elements: ['user__home_state_latest', 'listing__is_lux_latest', 'metric_time__day']
  SELECT
    subq_6.metric_time__day
    , subq_6.listing__is_lux_latest
    , subq_6.user__home_state_latest
  FROM (
    -- Join Standard Outputs
    SELECT
      subq_5.home_state_latest AS user__home_state_latest
      , subq_0.ds__day AS ds__day
      , subq_0.ds__week AS ds__week
      , subq_0.ds__month AS ds__month
      , subq_0.ds__quarter AS ds__quarter
      , subq_0.ds__year AS ds__year
      , subq_0.ds__extract_year AS ds__extract_year
      , subq_0.ds__extract_quarter AS ds__extract_quarter
      , subq_0.ds__extract_month AS ds__extract_month
      , subq_0.ds__extract_day AS ds__extract_day
      , subq_0.ds__extract_dow AS ds__extract_dow
      , subq_0.ds__extract_doy AS ds__extract_doy
      , subq_0.created_at__day AS created_at__day
      , subq_0.created_at__week AS created_at__week
      , subq_0.created_at__month AS created_at__month
      , subq_0.created_at__quarter AS created_at__quarter
      , subq_0.created_at__year AS created_at__year
      , subq_0.created_at__extract_year AS created_at__extract_year
      , subq_0.created_at__extract_quarter AS created_at__extract_quarter
      , subq_0.created_at__extract_month AS created_at__extract_month
      , subq_0.created_at__extract_day AS created_at__extract_day
      , subq_0.created_at__extract_dow AS created_at__extract_dow
      , subq_0.created_at__extract_doy AS created_at__extract_doy
      , subq_0.listing__ds__day AS listing__ds__day
      , subq_0.listing__ds__week AS listing__ds__week
      , subq_0.listing__ds__month AS listing__ds__month
      , subq_0.listing__ds__quarter AS listing__ds__quarter
      , subq_0.listing__ds__year AS listing__ds__year
      , subq_0.listing__ds__extract_year AS listing__ds__extract_year
      , subq_0.listing__ds__extract_quarter AS listing__ds__extract_quarter
      , subq_0.listing__ds__extract_month AS listing__ds__extract_month
      , subq_0.listing__ds__extract_day AS listing__ds__extract_day
      , subq_0.listing__ds__extract_dow AS listing__ds__extract_dow
      , subq_0.listing__ds__extract_doy AS listing__ds__extract_doy
      , subq_0.listing__created_at__day AS listing__created_at__day
      , subq_0.listing__created_at__week AS listing__created_at__week
      , subq_0.listing__created_at__month AS listing__created_at__month
      , subq_0.listing__created_at__quarter AS listing__created_at__quarter
      , subq_0.listing__created_at__year AS listing__created_at__year
      , subq_0.listing__created_at__extract_year AS listing__created_at__extract_year
      , subq_0.listing__created_at__extract_quarter AS listing__created_at__extract_quarter
      , subq_0.listing__created_at__extract_month AS listing__created_at__extract_month
      , subq_0.listing__created_at__extract_day AS listing__created_at__extract_day
      , subq_0.listing__created_at__extract_dow AS listing__created_at__extract_dow
      , subq_0.listing__created_at__extract_doy AS listing__created_at__extract_doy
      , subq_3.metric_time__day AS metric_time__day
      , subq_0.listing AS listing
      , subq_0.user AS user
      , subq_0.listing__user AS listing__user
      , subq_0.country_latest AS country_latest
      , subq_0.is_lux_latest AS is_lux_latest
      , subq_0.capacity_latest AS capacity_latest
      , subq_0.listing__country_latest AS listing__country_latest
      , subq_0.listing__is_lux_latest AS listing__is_lux_latest
      , subq_0.listing__capacity_latest AS listing__capacity_latest
      , subq_0.listings AS listings
      , subq_0.largest_listing AS largest_listing
      , subq_0.smallest_listing AS smallest_listing
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
        , EXTRACT(isodow FROM listings_latest_src_28000.created_at) AS ds__extract_dow
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
        , EXTRACT(isodow FROM listings_latest_src_28000.created_at) AS created_at__extract_dow
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
        , EXTRACT(isodow FROM listings_latest_src_28000.created_at) AS listing__ds__extract_dow
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
        , EXTRACT(isodow FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_dow
        , EXTRACT(doy FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_doy
        , listings_latest_src_28000.country AS listing__country_latest
        , listings_latest_src_28000.is_lux AS listing__is_lux_latest
        , listings_latest_src_28000.capacity AS listing__capacity_latest
        , listings_latest_src_28000.listing_id AS listing
        , listings_latest_src_28000.user_id AS user
        , listings_latest_src_28000.user_id AS listing__user
      FROM ***************************.dim_listings_latest listings_latest_src_28000
    ) subq_0
    CROSS JOIN (
      -- Pass Only Elements: ['metric_time__day']
      SELECT
        subq_2.metric_time__day
      FROM (
        -- Metric Time Dimension 'ds'
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
          , subq_1.ds__alien_day
          , subq_1.ds__day AS metric_time__day
          , subq_1.ds__week AS metric_time__week
          , subq_1.ds__month AS metric_time__month
          , subq_1.ds__quarter AS metric_time__quarter
          , subq_1.ds__year AS metric_time__year
          , subq_1.ds__extract_year AS metric_time__extract_year
          , subq_1.ds__extract_quarter AS metric_time__extract_quarter
          , subq_1.ds__extract_month AS metric_time__extract_month
          , subq_1.ds__extract_day AS metric_time__extract_day
          , subq_1.ds__extract_dow AS metric_time__extract_dow
          , subq_1.ds__extract_doy AS metric_time__extract_doy
          , subq_1.ds__alien_day AS metric_time__alien_day
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
            , EXTRACT(isodow FROM time_spine_src_28006.ds) AS ds__extract_dow
            , EXTRACT(doy FROM time_spine_src_28006.ds) AS ds__extract_doy
            , time_spine_src_28006.alien_day AS ds__alien_day
          FROM ***************************.mf_time_spine time_spine_src_28006
        ) subq_1
      ) subq_2
    ) subq_3
    FULL OUTER JOIN (
      -- Pass Only Elements: ['home_state_latest', 'user']
      SELECT
        subq_4.user
        , subq_4.home_state_latest
      FROM (
        -- Read Elements From Semantic Model 'users_latest'
        SELECT
          DATE_TRUNC('day', users_latest_src_28000.ds) AS ds_latest__day
          , DATE_TRUNC('week', users_latest_src_28000.ds) AS ds_latest__week
          , DATE_TRUNC('month', users_latest_src_28000.ds) AS ds_latest__month
          , DATE_TRUNC('quarter', users_latest_src_28000.ds) AS ds_latest__quarter
          , DATE_TRUNC('year', users_latest_src_28000.ds) AS ds_latest__year
          , EXTRACT(year FROM users_latest_src_28000.ds) AS ds_latest__extract_year
          , EXTRACT(quarter FROM users_latest_src_28000.ds) AS ds_latest__extract_quarter
          , EXTRACT(month FROM users_latest_src_28000.ds) AS ds_latest__extract_month
          , EXTRACT(day FROM users_latest_src_28000.ds) AS ds_latest__extract_day
          , EXTRACT(isodow FROM users_latest_src_28000.ds) AS ds_latest__extract_dow
          , EXTRACT(doy FROM users_latest_src_28000.ds) AS ds_latest__extract_doy
          , users_latest_src_28000.home_state_latest
          , DATE_TRUNC('day', users_latest_src_28000.ds) AS user__ds_latest__day
          , DATE_TRUNC('week', users_latest_src_28000.ds) AS user__ds_latest__week
          , DATE_TRUNC('month', users_latest_src_28000.ds) AS user__ds_latest__month
          , DATE_TRUNC('quarter', users_latest_src_28000.ds) AS user__ds_latest__quarter
          , DATE_TRUNC('year', users_latest_src_28000.ds) AS user__ds_latest__year
          , EXTRACT(year FROM users_latest_src_28000.ds) AS user__ds_latest__extract_year
          , EXTRACT(quarter FROM users_latest_src_28000.ds) AS user__ds_latest__extract_quarter
          , EXTRACT(month FROM users_latest_src_28000.ds) AS user__ds_latest__extract_month
          , EXTRACT(day FROM users_latest_src_28000.ds) AS user__ds_latest__extract_day
          , EXTRACT(isodow FROM users_latest_src_28000.ds) AS user__ds_latest__extract_dow
          , EXTRACT(doy FROM users_latest_src_28000.ds) AS user__ds_latest__extract_doy
          , users_latest_src_28000.home_state_latest AS user__home_state_latest
          , users_latest_src_28000.user_id AS user
        FROM ***************************.dim_users_latest users_latest_src_28000
      ) subq_4
    ) subq_5
    ON
      subq_0.user = subq_5.user
  ) subq_6
  GROUP BY
    subq_6.metric_time__day
    , subq_6.listing__is_lux_latest
    , subq_6.user__home_state_latest
) subq_7
