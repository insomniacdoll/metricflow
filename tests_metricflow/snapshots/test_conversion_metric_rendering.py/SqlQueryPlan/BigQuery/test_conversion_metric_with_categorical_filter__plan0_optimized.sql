-- Compute Metrics via Expressions
SELECT
  metric_time__day
  , visit__referrer_id
  , CAST(buys AS FLOAT64) / CAST(NULLIF(visits, 0) AS FLOAT64) AS visit_buy_conversion_rate
FROM (
  -- Combine Aggregated Outputs
  SELECT
    COALESCE(subq_21.metric_time__day, subq_32.metric_time__day) AS metric_time__day
    , COALESCE(subq_21.visit__referrer_id, subq_32.visit__referrer_id) AS visit__referrer_id
    , MAX(subq_21.visits) AS visits
    , MAX(subq_32.buys) AS buys
  FROM (
    -- Constrain Output with WHERE
    -- Aggregate Measures
    SELECT
      metric_time__day
      , visit__referrer_id
      , SUM(visits) AS visits
    FROM (
      -- Read Elements From Semantic Model 'visits_source'
      -- Metric Time Dimension 'ds'
      -- Pass Only Elements: ['visits', 'visit__referrer_id', 'metric_time__day']
      SELECT
        DATETIME_TRUNC(ds, day) AS metric_time__day
        , referrer_id AS visit__referrer_id
        , 1 AS visits
      FROM ***************************.fct_visits visits_source_src_28000
    ) subq_19
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
        FIRST_VALUE(subq_25.visits) OVER (
          PARTITION BY
            subq_28.user
            , subq_28.ds__day
            , subq_28.mf_internal_uuid
          ORDER BY subq_25.ds__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS visits
        , FIRST_VALUE(subq_25.visit__referrer_id) OVER (
          PARTITION BY
            subq_28.user
            , subq_28.ds__day
            , subq_28.mf_internal_uuid
          ORDER BY subq_25.ds__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS visit__referrer_id
        , FIRST_VALUE(subq_25.ds__day) OVER (
          PARTITION BY
            subq_28.user
            , subq_28.ds__day
            , subq_28.mf_internal_uuid
          ORDER BY subq_25.ds__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS ds__day
        , FIRST_VALUE(subq_25.metric_time__day) OVER (
          PARTITION BY
            subq_28.user
            , subq_28.ds__day
            , subq_28.mf_internal_uuid
          ORDER BY subq_25.ds__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS metric_time__day
        , FIRST_VALUE(subq_25.user) OVER (
          PARTITION BY
            subq_28.user
            , subq_28.ds__day
            , subq_28.mf_internal_uuid
          ORDER BY subq_25.ds__day DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS user
        , subq_28.mf_internal_uuid AS mf_internal_uuid
        , subq_28.buys AS buys
      FROM (
        -- Constrain Output with WHERE
        -- Pass Only Elements: ['visits', 'visit__referrer_id', 'ds__day', 'metric_time__day', 'user']
        SELECT
          ds__day
          , metric_time__day
          , subq_23.user
          , visit__referrer_id
          , visits
        FROM (
          -- Read Elements From Semantic Model 'visits_source'
          -- Metric Time Dimension 'ds'
          SELECT
            DATETIME_TRUNC(ds, day) AS ds__day
            , DATETIME_TRUNC(ds, day) AS metric_time__day
            , user_id AS user
            , referrer_id AS visit__referrer_id
            , 1 AS visits
          FROM ***************************.fct_visits visits_source_src_28000
        ) subq_23
        WHERE visit__referrer_id = 'ref_id_01'
      ) subq_25
      INNER JOIN (
        -- Read Elements From Semantic Model 'buys_source'
        -- Metric Time Dimension 'ds'
        -- Add column with generated UUID
        SELECT
          DATETIME_TRUNC(ds, day) AS ds__day
          , user_id AS user
          , 1 AS buys
          , GENERATE_UUID() AS mf_internal_uuid
        FROM ***************************.fct_buys buys_source_src_28000
      ) subq_28
      ON
        (
          subq_25.user = subq_28.user
        ) AND (
          (subq_25.ds__day <= subq_28.ds__day)
        )
    ) subq_29
    GROUP BY
      metric_time__day
      , visit__referrer_id
  ) subq_32
  ON
    (
      subq_21.visit__referrer_id = subq_32.visit__referrer_id
    ) AND (
      subq_21.metric_time__day = subq_32.metric_time__day
    )
  GROUP BY
    metric_time__day
    , visit__referrer_id
) subq_33
