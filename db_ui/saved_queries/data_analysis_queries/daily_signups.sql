SELECT
  DATE(created_at) as signup_date,
  COUNT(*) as new_users
FROM
  users
WHERE
  created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY
  DATE(created_at)
ORDER BY
  signup_date DESC;
