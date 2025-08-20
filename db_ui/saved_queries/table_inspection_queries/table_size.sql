SELECT
  table_name,
  round(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM
  information_schema.tables
WHERE
  table_schema = DATABASE ()
ORDER BY
  size_mbDESC;
