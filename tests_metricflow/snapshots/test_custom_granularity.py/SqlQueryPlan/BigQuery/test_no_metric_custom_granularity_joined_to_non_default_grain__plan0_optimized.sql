-- Join Standard Outputs
-- Join to Custom Granularity Dataset
-- Join to Custom Granularity Dataset
-- Pass Only Elements: ['metric_time__day', 'metric_time__martian_day', 'user__bio_added_ts__martian_day', 'user__bio_added_ts__month']
SELECT
  subq_12.martian_day AS user__bio_added_ts__martian_day
  , subq_11.martian_day AS metric_time__martian_day
  , DATETIME_TRUNC(users_ds_source_src_28000.bio_added_ts, month) AS user__bio_added_ts__month
  , DATETIME_TRUNC(time_spine_src_28006.ds, day) AS metric_time__day
FROM ***************************.dim_users users_ds_source_src_28000
CROSS JOIN
  ***************************.mf_time_spine time_spine_src_28006
LEFT OUTER JOIN
  ***************************.mf_time_spine subq_11
ON
  DATETIME_TRUNC(time_spine_src_28006.ds, day) = subq_11.ds
LEFT OUTER JOIN
  ***************************.mf_time_spine subq_12
ON
  DATETIME_TRUNC(users_ds_source_src_28000.bio_added_ts, day) = subq_12.ds
GROUP BY
  user__bio_added_ts__martian_day
  , metric_time__martian_day
  , user__bio_added_ts__month
  , metric_time__day