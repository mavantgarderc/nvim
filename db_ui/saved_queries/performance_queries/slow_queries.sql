SELECT
  query_time,
  lock_time,
  rows_sent,
  rows_examined,
  sql_text
FROM
  mysql.slow_log
ORDER BY
  query_timeDESC
LIMIT
  20;
