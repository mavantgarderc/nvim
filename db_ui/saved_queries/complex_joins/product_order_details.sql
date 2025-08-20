SELECT
  p.name AS product_name,
  p.category,
  oi.quantity,
  oi.price,
  o.created_at AS order_date,
  c.name AS customer_name
FROM
  products p
  JOIN order_items oi ON p.id = oi.product_id
  JOIN orders o ON oi.order_id = o.id
  JOIN customers c ON o.customer_id = c.id
WHERE
  p.id = PRODUCT_ID
ORDER BY
  o.created_atDESC;
