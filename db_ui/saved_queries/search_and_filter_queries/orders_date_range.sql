SELECT
  *
FROM
  orders
WHERE
  created_at BETWEEN '%START_DATE%' AND '%END_DATE%'
ORDER BY
  created_atDESC;
