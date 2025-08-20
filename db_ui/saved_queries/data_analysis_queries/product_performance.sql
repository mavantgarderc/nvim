SELECT
  p.name,
  p.price,
  COUNT(oi.id) AS times_ordered,
  SUM(oi.quantity) AS total_quantity,
  SUM(oi.price * oi.quantity) AS total_revenue
FROM
  products p
  LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY
  p.id,
  p.name,
  p.price
ORDER BY
  total_revenueDESC;
