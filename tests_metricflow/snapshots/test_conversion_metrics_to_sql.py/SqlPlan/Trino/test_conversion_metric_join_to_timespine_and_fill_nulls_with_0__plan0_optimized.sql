test_name: test_conversion_metric_join_to_timespine_and_fill_nulls_with_0
test_filename: test_conversion_metrics_to_sql.py
docstring:
  Test conversion metric that joins to time spine and fills nulls with 0.
sql_engine: Trino
---
-- Compute Metrics via Expressions
WITH sma_28019_cte AS (
  -- Read Elements From Semantic Model 'visits_source'
  -- Metric Time Dimension 'ds'
  SELECT
    DATE_TRUNC('day', ds) AS metric_time__day
    , user_id AS user
    , 1 AS visits
  FROM ***************************.fct_visits visits_source_src_28000
)

, rss_28018_cte AS (
  -- Read From Time Spine 'mf_time_spine'
  SELECT
    ds AS ds__day
  FROM ***************************.mf_time_spine time_spine_src_28006
)

SELECT
  metric_time__day AS metric_time__day
  , CAST(buys AS DOUBLE) / CAST(NULLIF(visits, 0) AS DOUBLE) AS visit_buy_conversion_rate_7days_fill_nulls_with_0
FROM (
  -- Combine Aggregated Outputs
  SELECT
    COALESCE(subq_29.metric_time__day, subq_42.metric_time__day) AS metric_time__day
    , COALESCE(MAX(subq_29.visits), 0) AS visits
    , COALESCE(MAX(subq_42.buys), 0) AS buys
  FROM (
    -- Join to Time Spine Dataset
    SELECT
      rss_28018_cte.ds__day AS metric_time__day
      , subq_25.visits AS visits
    FROM rss_28018_cte rss_28018_cte
    LEFT OUTER JOIN (
      -- Read From CTE For node_id=sma_28019
      -- Pass Only Elements: ['visits', 'metric_time__day']
      -- Aggregate Measures
      SELECT
        metric_time__day
        , SUM(visits) AS visits
      FROM sma_28019_cte sma_28019_cte
      GROUP BY
        metric_time__day
    ) subq_25
    ON
      rss_28018_cte.ds__day = subq_25.metric_time__day
  ) subq_29
  FULL OUTER JOIN (
    -- Join to Time Spine Dataset
    SELECT
      rss_28018_cte.ds__day AS metric_time__day
      , subq_38.buys AS buys
    FROM rss_28018_cte rss_28018_cte
    LEFT OUTER JOIN (
      -- Find conversions for user within the range of 7 day
      -- Pass Only Elements: ['buys', 'metric_time__day']
      -- Aggregate Measures
      SELECT
        metric_time__day
        , SUM(buys) AS buys
      FROM (
        -- Dedupe the fanout with mf_internal_uuid in the conversion data set
        SELECT DISTINCT
          FIRST_VALUE(sma_28019_cte.visits) OVER (
            PARTITION BY
              subq_34.user
              , subq_34.metric_time__day
              , subq_34.mf_internal_uuid
            ORDER BY sma_28019_cte.metric_time__day DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
          ) AS visits
          , FIRST_VALUE(sma_28019_cte.metric_time__day) OVER (
            PARTITION BY
              subq_34.user
              , subq_34.metric_time__day
              , subq_34.mf_internal_uuid
            ORDER BY sma_28019_cte.metric_time__day DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
          ) AS metric_time__day
          , FIRST_VALUE(sma_28019_cte.user) OVER (
            PARTITION BY
              subq_34.user
              , subq_34.metric_time__day
              , subq_34.mf_internal_uuid
            ORDER BY sma_28019_cte.metric_time__day DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
          ) AS user
          , subq_34.mf_internal_uuid AS mf_internal_uuid
          , subq_34.buys AS buys
        FROM sma_28019_cte sma_28019_cte
        INNER JOIN (
          -- Read Elements From Semantic Model 'buys_source'
          -- Metric Time Dimension 'ds'
          -- Add column with generated UUID
          SELECT
            DATE_TRUNC('day', ds) AS metric_time__day
            , user_id AS user
            , 1 AS buys
            , uuid() AS mf_internal_uuid
          FROM ***************************.fct_buys buys_source_src_28000
        ) subq_34
        ON
          (
            sma_28019_cte.user = subq_34.user
          ) AND (
            (
              sma_28019_cte.metric_time__day <= subq_34.metric_time__day
            ) AND (
              sma_28019_cte.metric_time__day > DATE_ADD('day', -7, subq_34.metric_time__day)
            )
          )
      ) subq_35
      GROUP BY
        metric_time__day
    ) subq_38
    ON
      rss_28018_cte.ds__day = subq_38.metric_time__day
  ) subq_42
  ON
    subq_29.metric_time__day = subq_42.metric_time__day
  GROUP BY
    COALESCE(subq_29.metric_time__day, subq_42.metric_time__day)
) subq_43
