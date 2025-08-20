SELECT
  o.*,
  c.name AS customer_name,
  c.email AS customer_email
FROM
  orders o
  JOIN customers c ON o.customer_id = c.id
WHERE
  o.total_amount > 1000
ORDER BY
  o.total_amountDESC;
