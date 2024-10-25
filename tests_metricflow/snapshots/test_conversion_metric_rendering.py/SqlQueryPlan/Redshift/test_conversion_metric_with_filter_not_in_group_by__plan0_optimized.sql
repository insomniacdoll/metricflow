-- Combine Aggregated Outputs
-- Compute Metrics via Expressions
SELECT
  COALESCE(MAX(subq_34.buys), 0) AS visit_buy_conversions
FROM (
  -- Constrain Output with WHERE
  -- Pass Only Elements: ['visits',]
  -- Aggregate Measures
  SELECT
    SUM(visits) AS visits
  FROM (
    -- Read Elements From Semantic Model 'visits_source'
    -- Metric Time Dimension 'ds'
    -- Pass Only Elements: ['visits', 'visit__referrer_id']
    SELECT
      referrer_id AS visit__referrer_id
      , 1 AS visits
    FROM ***************************.fct_visits visits_source_src_28000
  ) subq_20
  WHERE visit__referrer_id = 'ref_id_01'
) subq_23
CROSS JOIN (
  -- Find conversions for user within the range of 7 day
  -- Pass Only Elements: ['buys',]
  -- Aggregate Measures
  SELECT
    SUM(buys) AS buys
  FROM (
    -- Dedupe the fanout with mf_internal_uuid in the conversion data set
    SELECT DISTINCT
      FIRST_VALUE(subq_27.visits) OVER (
        PARTITION BY
          subq_30.user
          , subq_30.ds__day
          , subq_30.mf_internal_uuid
        ORDER BY subq_27.ds__day DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS visits
      , FIRST_VALUE(subq_27.visit__referrer_id) OVER (
        PARTITION BY
          subq_30.user
          , subq_30.ds__day
          , subq_30.mf_internal_uuid
        ORDER BY subq_27.ds__day DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS visit__referrer_id
      , FIRST_VALUE(subq_27.ds__day) OVER (
        PARTITION BY
          subq_30.user
          , subq_30.ds__day
          , subq_30.mf_internal_uuid
        ORDER BY subq_27.ds__day DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS ds__day
      , FIRST_VALUE(subq_27.user) OVER (
        PARTITION BY
          subq_30.user
          , subq_30.ds__day
          , subq_30.mf_internal_uuid
        ORDER BY subq_27.ds__day DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS user
      , subq_30.mf_internal_uuid AS mf_internal_uuid
      , subq_30.buys AS buys
    FROM (
      -- Constrain Output with WHERE
      -- Pass Only Elements: ['visits', 'visit__referrer_id', 'ds__day', 'user']
      SELECT
        ds__day
        , subq_25.user
        , visit__referrer_id
        , visits
      FROM (
        -- Read Elements From Semantic Model 'visits_source'
        -- Metric Time Dimension 'ds'
        SELECT
          DATE_TRUNC('day', ds) AS ds__day
          , user_id AS user
          , referrer_id AS visit__referrer_id
          , 1 AS visits
        FROM ***************************.fct_visits visits_source_src_28000
      ) subq_25
      WHERE visit__referrer_id = 'ref_id_01'
    ) subq_27
    INNER JOIN (
      -- Read Elements From Semantic Model 'buys_source'
      -- Metric Time Dimension 'ds'
      -- Add column with generated UUID
      SELECT
        DATE_TRUNC('day', ds) AS ds__day
        , user_id AS user
        , 1 AS buys
        , CONCAT(CAST(RANDOM()*100000000 AS INT)::VARCHAR,CAST(RANDOM()*100000000 AS INT)::VARCHAR) AS mf_internal_uuid
      FROM ***************************.fct_buys buys_source_src_28000
    ) subq_30
    ON
      (
        subq_27.user = subq_30.user
      ) AND (
        (
          subq_27.ds__day <= subq_30.ds__day
        ) AND (
          subq_27.ds__day > DATEADD(day, -7, subq_30.ds__day)
        )
      )
  ) subq_31
) subq_34