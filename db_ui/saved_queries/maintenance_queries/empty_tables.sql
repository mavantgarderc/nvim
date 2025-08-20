SELECT
  t.table_name,
  t.table_rows
FROM
  information_schema.tables t
WHERE
  t.table_schema = DATABASE ()
  AND t.table_rows = 0
ORDER BY
  t.table_name;
