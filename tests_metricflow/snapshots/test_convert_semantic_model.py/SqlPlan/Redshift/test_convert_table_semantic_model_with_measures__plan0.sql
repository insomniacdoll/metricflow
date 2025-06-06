test_name: test_convert_table_semantic_model_with_measures
test_filename: test_convert_semantic_model.py
docstring:
  Complete test of table semantic model conversion. This includes the full set of measures/entities/dimensions.

      Measures trigger a primary time dimension validation. Additionally, this includes both categorical and time
      dimension types, which should cover most, if not all, of the table source branches in the target class.
sql_engine: Redshift
---
-- Read Elements From Semantic Model 'id_verifications'
SELECT
  1 AS identity_verifications
  , DATE_TRUNC('day', id_verifications_src_28000.ds) AS ds__day
  , DATE_TRUNC('week', id_verifications_src_28000.ds) AS ds__week
  , DATE_TRUNC('month', id_verifications_src_28000.ds) AS ds__month
  , DATE_TRUNC('quarter', id_verifications_src_28000.ds) AS ds__quarter
  , DATE_TRUNC('year', id_verifications_src_28000.ds) AS ds__year
  , EXTRACT(year FROM id_verifications_src_28000.ds) AS ds__extract_year
  , EXTRACT(quarter FROM id_verifications_src_28000.ds) AS ds__extract_quarter
  , EXTRACT(month FROM id_verifications_src_28000.ds) AS ds__extract_month
  , EXTRACT(day FROM id_verifications_src_28000.ds) AS ds__extract_day
  , CASE WHEN EXTRACT(dow FROM id_verifications_src_28000.ds) = 0 THEN EXTRACT(dow FROM id_verifications_src_28000.ds) + 7 ELSE EXTRACT(dow FROM id_verifications_src_28000.ds) END AS ds__extract_dow
  , EXTRACT(doy FROM id_verifications_src_28000.ds) AS ds__extract_doy
  , DATE_TRUNC('day', id_verifications_src_28000.ds_partitioned) AS ds_partitioned__day
  , DATE_TRUNC('week', id_verifications_src_28000.ds_partitioned) AS ds_partitioned__week
  , DATE_TRUNC('month', id_verifications_src_28000.ds_partitioned) AS ds_partitioned__month
  , DATE_TRUNC('quarter', id_verifications_src_28000.ds_partitioned) AS ds_partitioned__quarter
  , DATE_TRUNC('year', id_verifications_src_28000.ds_partitioned) AS ds_partitioned__year
  , EXTRACT(year FROM id_verifications_src_28000.ds_partitioned) AS ds_partitioned__extract_year
  , EXTRACT(quarter FROM id_verifications_src_28000.ds_partitioned) AS ds_partitioned__extract_quarter
  , EXTRACT(month FROM id_verifications_src_28000.ds_partitioned) AS ds_partitioned__extract_month
  , EXTRACT(day FROM id_verifications_src_28000.ds_partitioned) AS ds_partitioned__extract_day
  , CASE WHEN EXTRACT(dow FROM id_verifications_src_28000.ds_partitioned) = 0 THEN EXTRACT(dow FROM id_verifications_src_28000.ds_partitioned) + 7 ELSE EXTRACT(dow FROM id_verifications_src_28000.ds_partitioned) END AS ds_partitioned__extract_dow
  , EXTRACT(doy FROM id_verifications_src_28000.ds_partitioned) AS ds_partitioned__extract_doy
  , id_verifications_src_28000.verification_type
  , DATE_TRUNC('day', id_verifications_src_28000.ds) AS verification__ds__day
  , DATE_TRUNC('week', id_verifications_src_28000.ds) AS verification__ds__week
  , DATE_TRUNC('month', id_verifications_src_28000.ds) AS verification__ds__month
  , DATE_TRUNC('quarter', id_verifications_src_28000.ds) AS verification__ds__quarter
  , DATE_TRUNC('year', id_verifications_src_28000.ds) AS verification__ds__year
  , EXTRACT(year FROM id_verifications_src_28000.ds) AS verification__ds__extract_year
  , EXTRACT(quarter FROM id_verifications_src_28000.ds) AS verification__ds__extract_quarter
  , EXTRACT(month FROM id_verifications_src_28000.ds) AS verification__ds__extract_month
  , EXTRACT(day FROM id_verifications_src_28000.ds) AS verification__ds__extract_day
  , CASE WHEN EXTRACT(dow FROM id_verifications_src_28000.ds) = 0 THEN EXTRACT(dow FROM id_verifications_src_28000.ds) + 7 ELSE EXTRACT(dow FROM id_verifications_src_28000.ds) END AS verification__ds__extract_dow
  , EXTRACT(doy FROM id_verifications_src_28000.ds) AS verification__ds__extract_doy
  , DATE_TRUNC('day', id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__day
  , DATE_TRUNC('week', id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__week
  , DATE_TRUNC('month', id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__month
  , DATE_TRUNC('quarter', id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__quarter
  , DATE_TRUNC('year', id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__year
  , EXTRACT(year FROM id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__extract_year
  , EXTRACT(quarter FROM id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__extract_quarter
  , EXTRACT(month FROM id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__extract_month
  , EXTRACT(day FROM id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__extract_day
  , CASE WHEN EXTRACT(dow FROM id_verifications_src_28000.ds_partitioned) = 0 THEN EXTRACT(dow FROM id_verifications_src_28000.ds_partitioned) + 7 ELSE EXTRACT(dow FROM id_verifications_src_28000.ds_partitioned) END AS verification__ds_partitioned__extract_dow
  , EXTRACT(doy FROM id_verifications_src_28000.ds_partitioned) AS verification__ds_partitioned__extract_doy
  , id_verifications_src_28000.verification_type AS verification__verification_type
  , id_verifications_src_28000.verification_id AS verification
  , id_verifications_src_28000.user_id AS user
  , id_verifications_src_28000.user_id AS verification__user
FROM ***************************.fct_id_verifications id_verifications_src_28000
