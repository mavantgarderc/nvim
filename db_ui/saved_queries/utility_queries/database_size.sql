SELECT
  table_schema AS "Database",
  ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) AS "Size (MB)"
FROM
  information_schema.tables
GROUP BY
  table_schema
ORDER BY
  SUM(data_length + index_length) DESC;
