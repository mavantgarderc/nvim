SELECT
  *
FROM
  orders
WHERE
  status = '%STATUS%'
ORDER BY
  created_atDESC;
