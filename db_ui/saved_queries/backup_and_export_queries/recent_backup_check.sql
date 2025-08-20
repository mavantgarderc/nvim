SELECT
  "users" AS table_name,
  COUNT(*) AS current_count,
  MAX(created_at) AS latest_record
FROM
  users UNION ALL
    SELECT "orders" AS table_name,
      COUNT(*) AS current_count,
      MAX(created_at) AS latest_record
    FROM
      orders;
