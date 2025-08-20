SELECT
  o.*
FROM
  orders o
  LEFT JOIN customers c ON o.customer_id = c.id
WHERE
  c.id IS NULL;
