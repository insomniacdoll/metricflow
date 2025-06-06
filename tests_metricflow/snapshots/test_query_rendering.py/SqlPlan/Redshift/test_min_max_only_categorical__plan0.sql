test_name: test_min_max_only_categorical
test_filename: test_query_rendering.py
docstring:
  Tests a min max only query with a categorical dimension.
sql_engine: Redshift
---
-- Write to DataTable
SELECT
  subq_2.listing__country_latest__min
  , subq_2.listing__country_latest__max
FROM (
  -- Calculate min and max
  SELECT
    MIN(subq_1.listing__country_latest) AS listing__country_latest__min
    , MAX(subq_1.listing__country_latest) AS listing__country_latest__max
  FROM (
    -- Pass Only Elements: ['listing__country_latest']
    SELECT
      subq_0.listing__country_latest
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
        , CASE WHEN EXTRACT(dow FROM listings_latest_src_28000.created_at) = 0 THEN EXTRACT(dow FROM listings_latest_src_28000.created_at) + 7 ELSE EXTRACT(dow FROM listings_latest_src_28000.created_at) END AS ds__extract_dow
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
        , CASE WHEN EXTRACT(dow FROM listings_latest_src_28000.created_at) = 0 THEN EXTRACT(dow FROM listings_latest_src_28000.created_at) + 7 ELSE EXTRACT(dow FROM listings_latest_src_28000.created_at) END AS created_at__extract_dow
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
        , CASE WHEN EXTRACT(dow FROM listings_latest_src_28000.created_at) = 0 THEN EXTRACT(dow FROM listings_latest_src_28000.created_at) + 7 ELSE EXTRACT(dow FROM listings_latest_src_28000.created_at) END AS listing__ds__extract_dow
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
        , CASE WHEN EXTRACT(dow FROM listings_latest_src_28000.created_at) = 0 THEN EXTRACT(dow FROM listings_latest_src_28000.created_at) + 7 ELSE EXTRACT(dow FROM listings_latest_src_28000.created_at) END AS listing__created_at__extract_dow
        , EXTRACT(doy FROM listings_latest_src_28000.created_at) AS listing__created_at__extract_doy
        , listings_latest_src_28000.country AS listing__country_latest
        , listings_latest_src_28000.is_lux AS listing__is_lux_latest
        , listings_latest_src_28000.capacity AS listing__capacity_latest
        , listings_latest_src_28000.listing_id AS listing
        , listings_latest_src_28000.user_id AS user
        , listings_latest_src_28000.user_id AS listing__user
      FROM ***************************.dim_listings_latest listings_latest_src_28000
    ) subq_0
    GROUP BY
      subq_0.listing__country_latest
  ) subq_1
) subq_2
