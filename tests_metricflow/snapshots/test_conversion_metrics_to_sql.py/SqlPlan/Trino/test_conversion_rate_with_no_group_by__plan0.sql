test_name: test_conversion_rate_with_no_group_by
test_filename: test_conversion_metrics_to_sql.py
docstring:
  Test conversion metric with no group by data flow plan rendering.
sql_engine: Trino
---
-- Write to DataTable
SELECT
  subq_14.visit_buy_conversion_rate_7days
FROM (
  -- Compute Metrics via Expressions
  SELECT
    CAST(subq_13.buys AS DOUBLE) / CAST(NULLIF(subq_13.visits, 0) AS DOUBLE) AS visit_buy_conversion_rate_7days
  FROM (
    -- Combine Aggregated Outputs
    SELECT
      MAX(subq_3.visits) AS visits
      , MAX(subq_12.buys) AS buys
    FROM (
      -- Aggregate Measures
      SELECT
        SUM(subq_2.visits) AS visits
      FROM (
        -- Pass Only Elements: ['visits']
        SELECT
          subq_1.visits
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
            , subq_0.visit__ds__day
            , subq_0.visit__ds__week
            , subq_0.visit__ds__month
            , subq_0.visit__ds__quarter
            , subq_0.visit__ds__year
            , subq_0.visit__ds__extract_year
            , subq_0.visit__ds__extract_quarter
            , subq_0.visit__ds__extract_month
            , subq_0.visit__ds__extract_day
            , subq_0.visit__ds__extract_dow
            , subq_0.visit__ds__extract_doy
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
            , subq_0.user
            , subq_0.session
            , subq_0.visit__user
            , subq_0.visit__session
            , subq_0.referrer_id
            , subq_0.visit__referrer_id
            , subq_0.visits
            , subq_0.visitors
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
              , EXTRACT(DAY_OF_WEEK FROM visits_source_src_28000.ds) AS ds__extract_dow
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
              , EXTRACT(DAY_OF_WEEK FROM visits_source_src_28000.ds) AS visit__ds__extract_dow
              , EXTRACT(doy FROM visits_source_src_28000.ds) AS visit__ds__extract_doy
              , visits_source_src_28000.referrer_id AS visit__referrer_id
              , visits_source_src_28000.user_id AS user
              , visits_source_src_28000.session_id AS session
              , visits_source_src_28000.user_id AS visit__user
              , visits_source_src_28000.session_id AS visit__session
            FROM ***************************.fct_visits visits_source_src_28000
          ) subq_0
        ) subq_1
      ) subq_2
    ) subq_3
    CROSS JOIN (
      -- Aggregate Measures
      SELECT
        SUM(subq_11.buys) AS buys
      FROM (
        -- Pass Only Elements: ['buys']
        SELECT
          subq_10.buys
        FROM (
          -- Find conversions for user within the range of 7 day
          SELECT
            subq_9.metric_time__day
            , subq_9.user
            , subq_9.buys
            , subq_9.visits
          FROM (
            -- Dedupe the fanout with mf_internal_uuid in the conversion data set
            SELECT DISTINCT
              FIRST_VALUE(subq_5.visits) OVER (
                PARTITION BY
                  subq_8.user
                  , subq_8.metric_time__day
                  , subq_8.mf_internal_uuid
                ORDER BY subq_5.metric_time__day DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
              ) AS visits
              , FIRST_VALUE(subq_5.metric_time__day) OVER (
                PARTITION BY
                  subq_8.user
                  , subq_8.metric_time__day
                  , subq_8.mf_internal_uuid
                ORDER BY subq_5.metric_time__day DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
              ) AS metric_time__day
              , FIRST_VALUE(subq_5.user) OVER (
                PARTITION BY
                  subq_8.user
                  , subq_8.metric_time__day
                  , subq_8.mf_internal_uuid
                ORDER BY subq_5.metric_time__day DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
              ) AS user
              , subq_8.mf_internal_uuid AS mf_internal_uuid
              , subq_8.buys AS buys
            FROM (
              -- Pass Only Elements: ['visits', 'metric_time__day', 'user']
              SELECT
                subq_4.metric_time__day
                , subq_4.user
                , subq_4.visits
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
                  , subq_0.visit__ds__day
                  , subq_0.visit__ds__week
                  , subq_0.visit__ds__month
                  , subq_0.visit__ds__quarter
                  , subq_0.visit__ds__year
                  , subq_0.visit__ds__extract_year
                  , subq_0.visit__ds__extract_quarter
                  , subq_0.visit__ds__extract_month
                  , subq_0.visit__ds__extract_day
                  , subq_0.visit__ds__extract_dow
                  , subq_0.visit__ds__extract_doy
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
                  , subq_0.user
                  , subq_0.session
                  , subq_0.visit__user
                  , subq_0.visit__session
                  , subq_0.referrer_id
                  , subq_0.visit__referrer_id
                  , subq_0.visits
                  , subq_0.visitors
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
                    , EXTRACT(DAY_OF_WEEK FROM visits_source_src_28000.ds) AS ds__extract_dow
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
                    , EXTRACT(DAY_OF_WEEK FROM visits_source_src_28000.ds) AS visit__ds__extract_dow
                    , EXTRACT(doy FROM visits_source_src_28000.ds) AS visit__ds__extract_doy
                    , visits_source_src_28000.referrer_id AS visit__referrer_id
                    , visits_source_src_28000.user_id AS user
                    , visits_source_src_28000.session_id AS session
                    , visits_source_src_28000.user_id AS visit__user
                    , visits_source_src_28000.session_id AS visit__session
                  FROM ***************************.fct_visits visits_source_src_28000
                ) subq_0
              ) subq_4
            ) subq_5
            INNER JOIN (
              -- Add column with generated UUID
              SELECT
                subq_7.ds__day
                , subq_7.ds__week
                , subq_7.ds__month
                , subq_7.ds__quarter
                , subq_7.ds__year
                , subq_7.ds__extract_year
                , subq_7.ds__extract_quarter
                , subq_7.ds__extract_month
                , subq_7.ds__extract_day
                , subq_7.ds__extract_dow
                , subq_7.ds__extract_doy
                , subq_7.ds_month__month
                , subq_7.ds_month__quarter
                , subq_7.ds_month__year
                , subq_7.ds_month__extract_year
                , subq_7.ds_month__extract_quarter
                , subq_7.ds_month__extract_month
                , subq_7.buy__ds__day
                , subq_7.buy__ds__week
                , subq_7.buy__ds__month
                , subq_7.buy__ds__quarter
                , subq_7.buy__ds__year
                , subq_7.buy__ds__extract_year
                , subq_7.buy__ds__extract_quarter
                , subq_7.buy__ds__extract_month
                , subq_7.buy__ds__extract_day
                , subq_7.buy__ds__extract_dow
                , subq_7.buy__ds__extract_doy
                , subq_7.buy__ds_month__month
                , subq_7.buy__ds_month__quarter
                , subq_7.buy__ds_month__year
                , subq_7.buy__ds_month__extract_year
                , subq_7.buy__ds_month__extract_quarter
                , subq_7.buy__ds_month__extract_month
                , subq_7.metric_time__day
                , subq_7.metric_time__week
                , subq_7.metric_time__month
                , subq_7.metric_time__quarter
                , subq_7.metric_time__year
                , subq_7.metric_time__extract_year
                , subq_7.metric_time__extract_quarter
                , subq_7.metric_time__extract_month
                , subq_7.metric_time__extract_day
                , subq_7.metric_time__extract_dow
                , subq_7.metric_time__extract_doy
                , subq_7.user
                , subq_7.session_id
                , subq_7.buy__user
                , subq_7.buy__session_id
                , subq_7.buys
                , subq_7.buyers
                , uuid() AS mf_internal_uuid
              FROM (
                -- Metric Time Dimension 'ds'
                SELECT
                  subq_6.ds__day
                  , subq_6.ds__week
                  , subq_6.ds__month
                  , subq_6.ds__quarter
                  , subq_6.ds__year
                  , subq_6.ds__extract_year
                  , subq_6.ds__extract_quarter
                  , subq_6.ds__extract_month
                  , subq_6.ds__extract_day
                  , subq_6.ds__extract_dow
                  , subq_6.ds__extract_doy
                  , subq_6.ds_month__month
                  , subq_6.ds_month__quarter
                  , subq_6.ds_month__year
                  , subq_6.ds_month__extract_year
                  , subq_6.ds_month__extract_quarter
                  , subq_6.ds_month__extract_month
                  , subq_6.buy__ds__day
                  , subq_6.buy__ds__week
                  , subq_6.buy__ds__month
                  , subq_6.buy__ds__quarter
                  , subq_6.buy__ds__year
                  , subq_6.buy__ds__extract_year
                  , subq_6.buy__ds__extract_quarter
                  , subq_6.buy__ds__extract_month
                  , subq_6.buy__ds__extract_day
                  , subq_6.buy__ds__extract_dow
                  , subq_6.buy__ds__extract_doy
                  , subq_6.buy__ds_month__month
                  , subq_6.buy__ds_month__quarter
                  , subq_6.buy__ds_month__year
                  , subq_6.buy__ds_month__extract_year
                  , subq_6.buy__ds_month__extract_quarter
                  , subq_6.buy__ds_month__extract_month
                  , subq_6.ds__day AS metric_time__day
                  , subq_6.ds__week AS metric_time__week
                  , subq_6.ds__month AS metric_time__month
                  , subq_6.ds__quarter AS metric_time__quarter
                  , subq_6.ds__year AS metric_time__year
                  , subq_6.ds__extract_year AS metric_time__extract_year
                  , subq_6.ds__extract_quarter AS metric_time__extract_quarter
                  , subq_6.ds__extract_month AS metric_time__extract_month
                  , subq_6.ds__extract_day AS metric_time__extract_day
                  , subq_6.ds__extract_dow AS metric_time__extract_dow
                  , subq_6.ds__extract_doy AS metric_time__extract_doy
                  , subq_6.user
                  , subq_6.session_id
                  , subq_6.buy__user
                  , subq_6.buy__session_id
                  , subq_6.buys
                  , subq_6.buyers
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
                    , EXTRACT(DAY_OF_WEEK FROM buys_source_src_28000.ds) AS ds__extract_dow
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
                    , EXTRACT(DAY_OF_WEEK FROM buys_source_src_28000.ds) AS buy__ds__extract_dow
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
                ) subq_6
              ) subq_7
            ) subq_8
            ON
              (
                subq_5.user = subq_8.user
              ) AND (
                (
                  subq_5.metric_time__day <= subq_8.metric_time__day
                ) AND (
                  subq_5.metric_time__day > DATE_ADD('day', -7, subq_8.metric_time__day)
                )
              )
          ) subq_9
        ) subq_10
      ) subq_11
    ) subq_12
  ) subq_13
) subq_14
