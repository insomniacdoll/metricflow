test_name: test_conversion_metric_with_categorical_filter
test_filename: test_conversion_metric_rendering.py
docstring:
  Test rendering a query against a conversion metric with a categorical filter.
sql_engine: Trino
---
-- Compute Metrics via Expressions
-- Write to DataTable
WITH sma_28019_cte AS (
  -- Read Elements From Semantic Model 'visits_source'
  -- Metric Time Dimension 'ds'
  SELECT
    DATE_TRUNC('day', ds) AS metric_time__day
    , user_id AS user
    , referrer_id AS visit__referrer_id
    , 1 AS visits
  FROM ***************************.fct_visits visits_source_src_28000
)

SELECT
  metric_time__day AS metric_time__day
  , visit__referrer_id AS visit__referrer_id
  , CAST(buys AS DOUBLE) / CAST(NULLIF(visits, 0) AS DOUBLE) AS visit_buy_conversion_rate
FROM (
  -- Combine Aggregated Outputs
  SELECT
    COALESCE(subq_21.metric_time__day, subq_31.metric_time__day) AS metric_time__day
    , COALESCE(subq_21.visit__referrer_id, subq_31.visit__referrer_id) AS visit__referrer_id
    , MAX(subq_21.visits) AS visits
    , MAX(subq_31.buys) AS buys
  FROM (
    -- Constrain Output with WHERE
    -- Pass Only Elements: ['visits', 'visit__referrer_id', 'metric_time__day']
    -- Aggregate Measures
    SELECT
      metric_time__day
      , visit__referrer_id
      , SUM(visits) AS visits
    FROM (
      -- Read From CTE For node_id=sma_28019
      SELECT
        metric_time__day
        , visit__referrer_id
        , visits
      FROM sma_28019_cte sma_28019_cte
    ) subq_18
    WHERE visit__referrer_id = 'ref_id_01'
    GROUP BY
      metric_time__day
      , visit__referrer_id
  ) subq_21
  FULL OUTER JOIN (
    -- Find conversions for user within the range of INF
    -- Pass Only Elements: ['buys', 'visit__referrer_id', 'metric_time__day']
    -- Aggregate Measures
    SELECT
      metric_time__day
      , visit__referrer_id
      , SUM(buys) AS buys
    FROM (
      -- Dedupe the fanout with mf_internal_uuid in the conversion data set
      SELECT DISTINCT
        FIRST_VALUE(subq_24.visits) OVER (
          PARTITION BY
            subq_27.user
            , subq_27.metric_time__day
            , subq_27.mf_internal_uuid
          ORDER BY subq_24.metric_time__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS visits
        , FIRST_VALUE(subq_24.visit__referrer_id) OVER (
          PARTITION BY
            subq_27.user
            , subq_27.metric_time__day
            , subq_27.mf_internal_uuid
          ORDER BY subq_24.metric_time__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS visit__referrer_id
        , FIRST_VALUE(subq_24.metric_time__day) OVER (
          PARTITION BY
            subq_27.user
            , subq_27.metric_time__day
            , subq_27.mf_internal_uuid
          ORDER BY subq_24.metric_time__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS metric_time__day
        , FIRST_VALUE(subq_24.user) OVER (
          PARTITION BY
            subq_27.user
            , subq_27.metric_time__day
            , subq_27.mf_internal_uuid
          ORDER BY subq_24.metric_time__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS user
        , subq_27.mf_internal_uuid AS mf_internal_uuid
        , subq_27.buys AS buys
      FROM (
        -- Constrain Output with WHERE
        -- Pass Only Elements: ['visits', 'visit__referrer_id', 'metric_time__day', 'user']
        SELECT
          metric_time__day
          , subq_22.user
          , visit__referrer_id
          , visits
        FROM (
          -- Read From CTE For node_id=sma_28019
          SELECT
            metric_time__day
            , sma_28019_cte.user
            , visit__referrer_id
            , visits
          FROM sma_28019_cte sma_28019_cte
        ) subq_22
        WHERE visit__referrer_id = 'ref_id_01'
      ) subq_24
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
      ) subq_27
      ON
        (
          subq_24.user = subq_27.user
        ) AND (
          (subq_24.metric_time__day <= subq_27.metric_time__day)
        )
    ) subq_28
    GROUP BY
      metric_time__day
      , visit__referrer_id
  ) subq_31
  ON
    (
      subq_21.visit__referrer_id = subq_31.visit__referrer_id
    ) AND (
      subq_21.metric_time__day = subq_31.metric_time__day
    )
  GROUP BY
    COALESCE(subq_21.metric_time__day, subq_31.metric_time__day)
    , COALESCE(subq_21.visit__referrer_id, subq_31.visit__referrer_id)
) subq_32
