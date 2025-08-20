SELECT
  *
FROM
  users
WHERE
  last_login < CURRENT_DATE - INTERVAL '90 days'
  OR last_login IS NULL
ORDER BY
  created_at DESC;
