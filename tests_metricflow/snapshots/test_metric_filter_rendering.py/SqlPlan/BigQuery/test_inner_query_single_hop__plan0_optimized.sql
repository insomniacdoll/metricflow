test_name: test_inner_query_single_hop
test_filename: test_metric_filter_rendering.py
docstring:
  Tests rendering for a metric filter using a one-hop join in the inner query.
sql_engine: BigQuery
---
-- Constrain Output with WHERE
-- Pass Only Elements: ['third_hop_count']
-- Aggregate Measures
-- Compute Metrics via Expressions
-- Write to DataTable
SELECT
  COUNT(DISTINCT third_hop_count) AS third_hop_count
FROM (
  -- Join Standard Outputs
  SELECT
    subq_26.customer_id__customer_third_hop_id__paraguayan_customers AS customer_third_hop_id__customer_id__customer_third_hop_id__paraguayan_customers
    , third_hop_table_src_22000.customer_third_hop_id AS third_hop_count
  FROM ***************************.third_hop_table third_hop_table_src_22000
  LEFT OUTER JOIN (
    -- Constrain Output with WHERE
    -- Pass Only Elements: ['customers_with_other_data', 'customer_id__customer_third_hop_id']
    -- Aggregate Measures
    -- Compute Metrics via Expressions
    -- Pass Only Elements: ['customer_id__customer_third_hop_id', 'customer_id__customer_third_hop_id__paraguayan_customers']
    SELECT
      customer_id__customer_third_hop_id
      , SUM(customers_with_other_data) AS customer_id__customer_third_hop_id__paraguayan_customers
    FROM (
      -- Read Elements From Semantic Model 'customer_other_data'
      -- Metric Time Dimension 'acquired_ds'
      SELECT
        customer_third_hop_id AS customer_id__customer_third_hop_id
        , country AS customer_id__country
        , 1 AS customers_with_other_data
      FROM ***************************.customer_other_data customer_other_data_src_22000
    ) subq_21
    WHERE customer_id__country = 'paraguay'
    GROUP BY
      customer_id__customer_third_hop_id
  ) subq_26
  ON
    third_hop_table_src_22000.customer_third_hop_id = subq_26.customer_id__customer_third_hop_id
) subq_27
WHERE customer_third_hop_id__customer_id__customer_third_hop_id__paraguayan_customers > 0
