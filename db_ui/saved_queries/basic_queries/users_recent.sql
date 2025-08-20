SELECT
  *
FROM
  users
WHERE
  created_at >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY
  created_at DESC;
