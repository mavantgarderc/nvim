SELECT
  c.id,
  c.name,
  c.email,
  COUNT(o.id) AS total_orders,
  COALESCE(SUM(o.total_amount), 0) AS total_spent,
  MAX(o.created_at) AS last_order_date
FROM
  customers c
  LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY
  c.id,
  c.name,
  c.email
ORDER BY
  total_spentDESC;
