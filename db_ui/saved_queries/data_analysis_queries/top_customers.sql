SELECT
  customer_id,
  customer_name,
  COUNT(*) AS order_count,
  SUM(total_amount) AS total_spent
FROM
  orders o
  JOIN customers c ON o.customer_id = c.id
GROUP BY
  customer_id,
  customer_name
ORDER BY
  total_spentDESC
LIMIT
  10;
