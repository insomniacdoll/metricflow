test_name: test_render_order_by
test_filename: test_sql_plan_render.py
sql_engine: DuckDB
---
-- test0
SELECT
  a.booking_value
  , a.bookings
FROM demo.fct_bookings a
ORDER BY a.booking_value, a.bookings DESC
