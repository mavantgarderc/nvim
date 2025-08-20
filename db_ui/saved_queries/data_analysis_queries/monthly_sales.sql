SELECT
  DATE_FORMAT (created_at, '%Y-%m') as month,
  COUNT(*) as orders,
  SUM(total_amount) as revenue
FROM
  orders
WHERE
  created_at >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY
  DATE_FORMAT (created_at, '%Y-%m')
ORDER BY
  month DESC;
