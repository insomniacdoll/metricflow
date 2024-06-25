-- Compute Metrics via Expressions
SELECT
  subq_12.user__home_state_latest
  , subq_12.listings
FROM (
  -- Aggregate Measures
  SELECT
    subq_11.user__home_state_latest
    , SUM(subq_11.listings) AS listings
  FROM (
    -- Pass Only Elements: ['listings', 'user__home_state_latest']
    SELECT
      subq_10.user__home_state_latest
      , subq_10.listings
    FROM (
      -- Constrain Output with WHERE
      SELECT
        subq_9.listing__is_lux_latest
        , subq_9.listing__capacity_latest
        , subq_9.user__home_state_latest
        , subq_9.listings
      FROM (
        -- Pass Only Elements: ['listings', 'user__home_state_latest', 'listing__is_lux_latest', 'listing__capacity_latest']
        SELECT
          subq_8.listing__is_lux_latest
          , subq_8.listing__capacity_latest
          , subq_8.user__home_state_latest
          , subq_8.listings
        FROM (
          -- Join Standard Outputs
          SELECT
            subq_5.user AS user
            , subq_5.listing__is_lux_latest AS listing__is_lux_latest
            , subq_5.listing__capacity_latest AS listing__capacity_latest
            , subq_7.home_state_latest AS user__home_state_latest
            , subq_5.listings AS listings
          FROM (
            -- Pass Only Elements: ['listings', 'listing__is_lux_latest', 'listing__capacity_latest', 'user']
            SELECT
              subq_4.user
              , subq_4.listing__is_lux_latest
              , subq_4.listing__capacity_latest
              , subq_4.listings
            FROM (
              -- Constrain Output with WHERE
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
                , subq_3.metric_time__day
                , subq_3.metric_time__week
                , subq_3.metric_time__month
                , subq_3.metric_time__quarter
                , subq_3.metric_time__year
                , subq_3.metric_time__extract_year
                , subq_3.metric_time__extract_quarter
                , subq_3.metric_time__extract_month
                , subq_3.metric_time__extract_day
                , subq_3.metric_time__extract_dow
                , subq_3.metric_time__extract_doy
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
                -- Metric Time Dimension 'ds'
                SELECT
                  subq_2.ds__day
                  , subq_2.ds__week
                  , subq_2.ds__month
                  , subq_2.ds__quarter
                  , subq_2.ds__year
                  , subq_2.ds__extract_year
                  , subq_2.ds__extract_quarter
                  , subq_2.ds__extract_month
                  , subq_2.ds__extract_day
                  , subq_2.ds__extract_dow
                  , subq_2.ds__extract_doy
                  , subq_2.created_at__day
                  , subq_2.created_at__week
                  , subq_2.created_at__month
                  , subq_2.created_at__quarter
                  , subq_2.created_at__year
                  , subq_2.created_at__extract_year
                  , subq_2.created_at__extract_quarter
                  , subq_2.created_at__extract_month
                  , subq_2.created_at__extract_day
                  , subq_2.created_at__extract_dow
                  , subq_2.created_at__extract_doy
                  , subq_2.listing__ds__day
                  , subq_2.listing__ds__week
                  , subq_2.listing__ds__month
                  , subq_2.listing__ds__quarter
                  , subq_2.listing__ds__year
                  , subq_2.listing__ds__extract_year
                  , subq_2.listing__ds__extract_quarter
                  , subq_2.listing__ds__extract_month
                  , subq_2.listing__ds__extract_day
                  , subq_2.listing__ds__extract_dow
                  , subq_2.listing__ds__extract_doy
                  , subq_2.listing__created_at__day
                  , subq_2.listing__created_at__week
                  , subq_2.listing__created_at__month
                  , subq_2.listing__created_at__quarter
                  , subq_2.listing__created_at__year
                  , subq_2.listing__created_at__extract_year
                  , subq_2.listing__created_at__extract_quarter
                  , subq_2.listing__created_at__extract_month
                  , subq_2.listing__created_at__extract_day
                  , subq_2.listing__created_at__extract_dow
                  , subq_2.listing__created_at__extract_doy
                  , subq_2.ds__day AS metric_time__day
                  , subq_2.ds__week AS metric_time__week
                  , subq_2.ds__month AS metric_time__month
                  , subq_2.ds__quarter AS metric_time__quarter
                  , subq_2.ds__year AS metric_time__year
                  , subq_2.ds__extract_year AS metric_time__extract_year
                  , subq_2.ds__extract_quarter AS metric_time__extract_quarter
                  , subq_2.ds__extract_month AS metric_time__extract_month
                  , subq_2.ds__extract_day AS metric_time__extract_day
                  , subq_2.ds__extract_dow AS metric_time__extract_dow
                  , subq_2.ds__extract_doy AS metric_time__extract_doy
                  , subq_2.listing
                  , subq_2.user
                  , subq_2.listing__user
                  , subq_2.country_latest
                  , subq_2.is_lux_latest
                  , subq_2.capacity_latest
                  , subq_2.listing__country_latest
                  , subq_2.listing__is_lux_latest
                  , subq_2.listing__capacity_latest
                  , subq_2.listings
                  , subq_2.largest_listing
                  , subq_2.smallest_listing
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
                ) subq_2
              ) subq_3
              WHERE listing__is_lux_latest OR listing__capacity_latest > 4
            ) subq_4
          ) subq_5
          LEFT OUTER JOIN (
            -- Pass Only Elements: ['home_state_latest', 'user']
            SELECT
              subq_6.user
              , subq_6.home_state_latest
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
            ) subq_6
          ) subq_7
          ON
            subq_5.user = subq_7.user
        ) subq_8
      ) subq_9
      WHERE listing__is_lux_latest OR listing__capacity_latest > 4
    ) subq_10
  ) subq_11
  GROUP BY
    subq_11.user__home_state_latest
) subq_12