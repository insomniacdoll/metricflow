test_name: test_conversion_metric_with_custom_granularity
test_filename: test_custom_granularity.py
sql_engine: Snowflake
---
-- Write to DataTable
SELECT
  subq_16.metric_time__alien_day
  , subq_16.visit_buy_conversion_rate_7days
FROM (
  -- Compute Metrics via Expressions
  SELECT
    subq_15.metric_time__alien_day
    , CAST(subq_15.buys AS DOUBLE) / CAST(NULLIF(subq_15.visits, 0) AS DOUBLE) AS visit_buy_conversion_rate_7days
  FROM (
    -- Combine Aggregated Outputs
    SELECT
      COALESCE(subq_4.metric_time__alien_day, subq_14.metric_time__alien_day) AS metric_time__alien_day
      , MAX(subq_4.visits) AS visits
      , MAX(subq_14.buys) AS buys
    FROM (
      -- Aggregate Measures
      SELECT
        subq_3.metric_time__alien_day
        , SUM(subq_3.visits) AS visits
      FROM (
        -- Pass Only Elements: ['visits', 'metric_time__alien_day']
        SELECT
          subq_2.metric_time__alien_day
          , subq_2.visits
        FROM (
          -- Metric Time Dimension 'ds'
          -- Join to Custom Granularity Dataset
          SELECT
            subq_0.ds__day AS ds__day
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
            , subq_0.visit__ds__day AS visit__ds__day
            , subq_0.visit__ds__week AS visit__ds__week
            , subq_0.visit__ds__month AS visit__ds__month
            , subq_0.visit__ds__quarter AS visit__ds__quarter
            , subq_0.visit__ds__year AS visit__ds__year
            , subq_0.visit__ds__extract_year AS visit__ds__extract_year
            , subq_0.visit__ds__extract_quarter AS visit__ds__extract_quarter
            , subq_0.visit__ds__extract_month AS visit__ds__extract_month
            , subq_0.visit__ds__extract_day AS visit__ds__extract_day
            , subq_0.visit__ds__extract_dow AS visit__ds__extract_dow
            , subq_0.visit__ds__extract_doy AS visit__ds__extract_doy
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
            , subq_0.user AS user
            , subq_0.session AS session
            , subq_0.visit__user AS visit__user
            , subq_0.visit__session AS visit__session
            , subq_0.referrer_id AS referrer_id
            , subq_0.visit__referrer_id AS visit__referrer_id
            , subq_0.visits AS visits
            , subq_0.visitors AS visitors
            , subq_1.alien_day AS metric_time__alien_day
          FROM (
            -- Read Elements From Semantic Model 'visits_source'
            SELECT
              1 AS visits
              , visits_source_src_28000.user_id AS visitors
              , DATE_TRUNC('day', visits_source_src_28000.ds) AS ds__day
              , DATE_TRUNC('week', visits_source_src_28000.ds) AS ds__week
              , DATE_TRUNC('month', visits_source_src_28000.ds) AS ds__month
              , DATE_TRUNC('quarter', visits_source_src_28000.ds) AS ds__quarter
              , DATE_TRUNC('year', visits_source_src_28000.ds) AS ds__year
              , EXTRACT(year FROM visits_source_src_28000.ds) AS ds__extract_year
              , EXTRACT(quarter FROM visits_source_src_28000.ds) AS ds__extract_quarter
              , EXTRACT(month FROM visits_source_src_28000.ds) AS ds__extract_month
              , EXTRACT(day FROM visits_source_src_28000.ds) AS ds__extract_day
              , EXTRACT(dayofweekiso FROM visits_source_src_28000.ds) AS ds__extract_dow
              , EXTRACT(doy FROM visits_source_src_28000.ds) AS ds__extract_doy
              , visits_source_src_28000.referrer_id
              , DATE_TRUNC('day', visits_source_src_28000.ds) AS visit__ds__day
              , DATE_TRUNC('week', visits_source_src_28000.ds) AS visit__ds__week
              , DATE_TRUNC('month', visits_source_src_28000.ds) AS visit__ds__month
              , DATE_TRUNC('quarter', visits_source_src_28000.ds) AS visit__ds__quarter
              , DATE_TRUNC('year', visits_source_src_28000.ds) AS visit__ds__year
              , EXTRACT(year FROM visits_source_src_28000.ds) AS visit__ds__extract_year
              , EXTRACT(quarter FROM visits_source_src_28000.ds) AS visit__ds__extract_quarter
              , EXTRACT(month FROM visits_source_src_28000.ds) AS visit__ds__extract_month
              , EXTRACT(day FROM visits_source_src_28000.ds) AS visit__ds__extract_day
              , EXTRACT(dayofweekiso FROM visits_source_src_28000.ds) AS visit__ds__extract_dow
              , EXTRACT(doy FROM visits_source_src_28000.ds) AS visit__ds__extract_doy
              , visits_source_src_28000.referrer_id AS visit__referrer_id
              , visits_source_src_28000.user_id AS user
              , visits_source_src_28000.session_id AS session
              , visits_source_src_28000.user_id AS visit__user
              , visits_source_src_28000.session_id AS visit__session
            FROM ***************************.fct_visits visits_source_src_28000
          ) subq_0
          LEFT OUTER JOIN
            ***************************.mf_time_spine subq_1
          ON
            subq_0.ds__day = subq_1.ds
        ) subq_2
      ) subq_3
      GROUP BY
        subq_3.metric_time__alien_day
    ) subq_4
    FULL OUTER JOIN (
      -- Aggregate Measures
      SELECT
        subq_13.metric_time__alien_day
        , SUM(subq_13.buys) AS buys
      FROM (
        -- Pass Only Elements: ['buys', 'metric_time__alien_day']
        SELECT
          subq_12.metric_time__alien_day
          , subq_12.buys
        FROM (
          -- Find conversions for user within the range of 7 day
          SELECT
            subq_11.metric_time__alien_day
            , subq_11.metric_time__day
            , subq_11.user
            , subq_11.buys
            , subq_11.visits
          FROM (
            -- Dedupe the fanout with mf_internal_uuid in the conversion data set
            SELECT DISTINCT
              FIRST_VALUE(subq_7.visits) OVER (
                PARTITION BY
                  subq_10.user
                  , subq_10.metric_time__day
                  , subq_10.mf_internal_uuid
                ORDER BY subq_7.metric_time__day DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
              ) AS visits
              , FIRST_VALUE(subq_7.metric_time__alien_day) OVER (
                PARTITION BY
                  subq_10.user
                  , subq_10.metric_time__day
                  , subq_10.mf_internal_uuid
                ORDER BY subq_7.metric_time__day DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
              ) AS metric_time__alien_day
              , FIRST_VALUE(subq_7.metric_time__day) OVER (
                PARTITION BY
                  subq_10.user
                  , subq_10.metric_time__day
                  , subq_10.mf_internal_uuid
                ORDER BY subq_7.metric_time__day DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
              ) AS metric_time__day
              , FIRST_VALUE(subq_7.user) OVER (
                PARTITION BY
                  subq_10.user
                  , subq_10.metric_time__day
                  , subq_10.mf_internal_uuid
                ORDER BY subq_7.metric_time__day DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
              ) AS user
              , subq_10.mf_internal_uuid AS mf_internal_uuid
              , subq_10.buys AS buys
            FROM (
              -- Pass Only Elements: ['visits', 'metric_time__day', 'metric_time__alien_day', 'user']
              SELECT
                subq_6.metric_time__alien_day
                , subq_6.metric_time__day
                , subq_6.user
                , subq_6.visits
              FROM (
                -- Metric Time Dimension 'ds'
                -- Join to Custom Granularity Dataset
                SELECT
                  subq_0.ds__day AS ds__day
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
                  , subq_0.visit__ds__day AS visit__ds__day
                  , subq_0.visit__ds__week AS visit__ds__week
                  , subq_0.visit__ds__month AS visit__ds__month
                  , subq_0.visit__ds__quarter AS visit__ds__quarter
                  , subq_0.visit__ds__year AS visit__ds__year
                  , subq_0.visit__ds__extract_year AS visit__ds__extract_year
                  , subq_0.visit__ds__extract_quarter AS visit__ds__extract_quarter
                  , subq_0.visit__ds__extract_month AS visit__ds__extract_month
                  , subq_0.visit__ds__extract_day AS visit__ds__extract_day
                  , subq_0.visit__ds__extract_dow AS visit__ds__extract_dow
                  , subq_0.visit__ds__extract_doy AS visit__ds__extract_doy
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
                  , subq_0.user AS user
                  , subq_0.session AS session
                  , subq_0.visit__user AS visit__user
                  , subq_0.visit__session AS visit__session
                  , subq_0.referrer_id AS referrer_id
                  , subq_0.visit__referrer_id AS visit__referrer_id
                  , subq_0.visits AS visits
                  , subq_0.visitors AS visitors
                  , subq_5.alien_day AS metric_time__alien_day
                FROM (
                  -- Read Elements From Semantic Model 'visits_source'
                  SELECT
                    1 AS visits
                    , visits_source_src_28000.user_id AS visitors
                    , DATE_TRUNC('day', visits_source_src_28000.ds) AS ds__day
                    , DATE_TRUNC('week', visits_source_src_28000.ds) AS ds__week
                    , DATE_TRUNC('month', visits_source_src_28000.ds) AS ds__month
                    , DATE_TRUNC('quarter', visits_source_src_28000.ds) AS ds__quarter
                    , DATE_TRUNC('year', visits_source_src_28000.ds) AS ds__year
                    , EXTRACT(year FROM visits_source_src_28000.ds) AS ds__extract_year
                    , EXTRACT(quarter FROM visits_source_src_28000.ds) AS ds__extract_quarter
                    , EXTRACT(month FROM visits_source_src_28000.ds) AS ds__extract_month
                    , EXTRACT(day FROM visits_source_src_28000.ds) AS ds__extract_day
                    , EXTRACT(dayofweekiso FROM visits_source_src_28000.ds) AS ds__extract_dow
                    , EXTRACT(doy FROM visits_source_src_28000.ds) AS ds__extract_doy
                    , visits_source_src_28000.referrer_id
                    , DATE_TRUNC('day', visits_source_src_28000.ds) AS visit__ds__day
                    , DATE_TRUNC('week', visits_source_src_28000.ds) AS visit__ds__week
                    , DATE_TRUNC('month', visits_source_src_28000.ds) AS visit__ds__month
                    , DATE_TRUNC('quarter', visits_source_src_28000.ds) AS visit__ds__quarter
                    , DATE_TRUNC('year', visits_source_src_28000.ds) AS visit__ds__year
                    , EXTRACT(year FROM visits_source_src_28000.ds) AS visit__ds__extract_year
                    , EXTRACT(quarter FROM visits_source_src_28000.ds) AS visit__ds__extract_quarter
                    , EXTRACT(month FROM visits_source_src_28000.ds) AS visit__ds__extract_month
                    , EXTRACT(day FROM visits_source_src_28000.ds) AS visit__ds__extract_day
                    , EXTRACT(dayofweekiso FROM visits_source_src_28000.ds) AS visit__ds__extract_dow
                    , EXTRACT(doy FROM visits_source_src_28000.ds) AS visit__ds__extract_doy
                    , visits_source_src_28000.referrer_id AS visit__referrer_id
                    , visits_source_src_28000.user_id AS user
                    , visits_source_src_28000.session_id AS session
                    , visits_source_src_28000.user_id AS visit__user
                    , visits_source_src_28000.session_id AS visit__session
                  FROM ***************************.fct_visits visits_source_src_28000
                ) subq_0
                LEFT OUTER JOIN
                  ***************************.mf_time_spine subq_5
                ON
                  subq_0.ds__day = subq_5.ds
              ) subq_6
            ) subq_7
            INNER JOIN (
              -- Add column with generated UUID
              SELECT
                subq_9.ds__day
                , subq_9.ds__week
                , subq_9.ds__month
                , subq_9.ds__quarter
                , subq_9.ds__year
                , subq_9.ds__extract_year
                , subq_9.ds__extract_quarter
                , subq_9.ds__extract_month
                , subq_9.ds__extract_day
                , subq_9.ds__extract_dow
                , subq_9.ds__extract_doy
                , subq_9.ds_month__month
                , subq_9.ds_month__quarter
                , subq_9.ds_month__year
                , subq_9.ds_month__extract_year
                , subq_9.ds_month__extract_quarter
                , subq_9.ds_month__extract_month
                , subq_9.buy__ds__day
                , subq_9.buy__ds__week
                , subq_9.buy__ds__month
                , subq_9.buy__ds__quarter
                , subq_9.buy__ds__year
                , subq_9.buy__ds__extract_year
                , subq_9.buy__ds__extract_quarter
                , subq_9.buy__ds__extract_month
                , subq_9.buy__ds__extract_day
                , subq_9.buy__ds__extract_dow
                , subq_9.buy__ds__extract_doy
                , subq_9.buy__ds_month__month
                , subq_9.buy__ds_month__quarter
                , subq_9.buy__ds_month__year
                , subq_9.buy__ds_month__extract_year
                , subq_9.buy__ds_month__extract_quarter
                , subq_9.buy__ds_month__extract_month
                , subq_9.metric_time__day
                , subq_9.metric_time__week
                , subq_9.metric_time__month
                , subq_9.metric_time__quarter
                , subq_9.metric_time__year
                , subq_9.metric_time__extract_year
                , subq_9.metric_time__extract_quarter
                , subq_9.metric_time__extract_month
                , subq_9.metric_time__extract_day
                , subq_9.metric_time__extract_dow
                , subq_9.metric_time__extract_doy
                , subq_9.user
                , subq_9.session_id
                , subq_9.buy__user
                , subq_9.buy__session_id
                , subq_9.buys
                , subq_9.buyers
                , UUID_STRING() AS mf_internal_uuid
              FROM (
                -- Metric Time Dimension 'ds'
                SELECT
                  subq_8.ds__day
                  , subq_8.ds__week
                  , subq_8.ds__month
                  , subq_8.ds__quarter
                  , subq_8.ds__year
                  , subq_8.ds__extract_year
                  , subq_8.ds__extract_quarter
                  , subq_8.ds__extract_month
                  , subq_8.ds__extract_day
                  , subq_8.ds__extract_dow
                  , subq_8.ds__extract_doy
                  , subq_8.ds_month__month
                  , subq_8.ds_month__quarter
                  , subq_8.ds_month__year
                  , subq_8.ds_month__extract_year
                  , subq_8.ds_month__extract_quarter
                  , subq_8.ds_month__extract_month
                  , subq_8.buy__ds__day
                  , subq_8.buy__ds__week
                  , subq_8.buy__ds__month
                  , subq_8.buy__ds__quarter
                  , subq_8.buy__ds__year
                  , subq_8.buy__ds__extract_year
                  , subq_8.buy__ds__extract_quarter
                  , subq_8.buy__ds__extract_month
                  , subq_8.buy__ds__extract_day
                  , subq_8.buy__ds__extract_dow
                  , subq_8.buy__ds__extract_doy
                  , subq_8.buy__ds_month__month
                  , subq_8.buy__ds_month__quarter
                  , subq_8.buy__ds_month__year
                  , subq_8.buy__ds_month__extract_year
                  , subq_8.buy__ds_month__extract_quarter
                  , subq_8.buy__ds_month__extract_month
                  , subq_8.ds__day AS metric_time__day
                  , subq_8.ds__week AS metric_time__week
                  , subq_8.ds__month AS metric_time__month
                  , subq_8.ds__quarter AS metric_time__quarter
                  , subq_8.ds__year AS metric_time__year
                  , subq_8.ds__extract_year AS metric_time__extract_year
                  , subq_8.ds__extract_quarter AS metric_time__extract_quarter
                  , subq_8.ds__extract_month AS metric_time__extract_month
                  , subq_8.ds__extract_day AS metric_time__extract_day
                  , subq_8.ds__extract_dow AS metric_time__extract_dow
                  , subq_8.ds__extract_doy AS metric_time__extract_doy
                  , subq_8.user
                  , subq_8.session_id
                  , subq_8.buy__user
                  , subq_8.buy__session_id
                  , subq_8.buys
                  , subq_8.buyers
                FROM (
                  -- Read Elements From Semantic Model 'buys_source'
                  SELECT
                    1 AS buys
                    , 1 AS buys_month
                    , buys_source_src_28000.user_id AS buyers
                    , DATE_TRUNC('day', buys_source_src_28000.ds) AS ds__day
                    , DATE_TRUNC('week', buys_source_src_28000.ds) AS ds__week
                    , DATE_TRUNC('month', buys_source_src_28000.ds) AS ds__month
                    , DATE_TRUNC('quarter', buys_source_src_28000.ds) AS ds__quarter
                    , DATE_TRUNC('year', buys_source_src_28000.ds) AS ds__year
                    , EXTRACT(year FROM buys_source_src_28000.ds) AS ds__extract_year
                    , EXTRACT(quarter FROM buys_source_src_28000.ds) AS ds__extract_quarter
                    , EXTRACT(month FROM buys_source_src_28000.ds) AS ds__extract_month
                    , EXTRACT(day FROM buys_source_src_28000.ds) AS ds__extract_day
                    , EXTRACT(dayofweekiso FROM buys_source_src_28000.ds) AS ds__extract_dow
                    , EXTRACT(doy FROM buys_source_src_28000.ds) AS ds__extract_doy
                    , DATE_TRUNC('month', buys_source_src_28000.ds_month) AS ds_month__month
                    , DATE_TRUNC('quarter', buys_source_src_28000.ds_month) AS ds_month__quarter
                    , DATE_TRUNC('year', buys_source_src_28000.ds_month) AS ds_month__year
                    , EXTRACT(year FROM buys_source_src_28000.ds_month) AS ds_month__extract_year
                    , EXTRACT(quarter FROM buys_source_src_28000.ds_month) AS ds_month__extract_quarter
                    , EXTRACT(month FROM buys_source_src_28000.ds_month) AS ds_month__extract_month
                    , DATE_TRUNC('day', buys_source_src_28000.ds) AS buy__ds__day
                    , DATE_TRUNC('week', buys_source_src_28000.ds) AS buy__ds__week
                    , DATE_TRUNC('month', buys_source_src_28000.ds) AS buy__ds__month
                    , DATE_TRUNC('quarter', buys_source_src_28000.ds) AS buy__ds__quarter
                    , DATE_TRUNC('year', buys_source_src_28000.ds) AS buy__ds__year
                    , EXTRACT(year FROM buys_source_src_28000.ds) AS buy__ds__extract_year
                    , EXTRACT(quarter FROM buys_source_src_28000.ds) AS buy__ds__extract_quarter
                    , EXTRACT(month FROM buys_source_src_28000.ds) AS buy__ds__extract_month
                    , EXTRACT(day FROM buys_source_src_28000.ds) AS buy__ds__extract_day
                    , EXTRACT(dayofweekiso FROM buys_source_src_28000.ds) AS buy__ds__extract_dow
                    , EXTRACT(doy FROM buys_source_src_28000.ds) AS buy__ds__extract_doy
                    , DATE_TRUNC('month', buys_source_src_28000.ds_month) AS buy__ds_month__month
                    , DATE_TRUNC('quarter', buys_source_src_28000.ds_month) AS buy__ds_month__quarter
                    , DATE_TRUNC('year', buys_source_src_28000.ds_month) AS buy__ds_month__year
                    , EXTRACT(year FROM buys_source_src_28000.ds_month) AS buy__ds_month__extract_year
                    , EXTRACT(quarter FROM buys_source_src_28000.ds_month) AS buy__ds_month__extract_quarter
                    , EXTRACT(month FROM buys_source_src_28000.ds_month) AS buy__ds_month__extract_month
                    , buys_source_src_28000.user_id AS user
                    , buys_source_src_28000.session_id
                    , buys_source_src_28000.user_id AS buy__user
                    , buys_source_src_28000.session_id AS buy__session_id
                  FROM ***************************.fct_buys buys_source_src_28000
                ) subq_8
              ) subq_9
            ) subq_10
            ON
              (
                subq_7.user = subq_10.user
              ) AND (
                (
                  subq_7.metric_time__day <= subq_10.metric_time__day
                ) AND (
                  subq_7.metric_time__day > DATEADD(day, -7, subq_10.metric_time__day)
                )
              )
          ) subq_11
        ) subq_12
      ) subq_13
      GROUP BY
        subq_13.metric_time__alien_day
    ) subq_14
    ON
      subq_4.metric_time__alien_day = subq_14.metric_time__alien_day
    GROUP BY
      COALESCE(subq_4.metric_time__alien_day, subq_14.metric_time__alien_day)
  ) subq_15
) subq_16
