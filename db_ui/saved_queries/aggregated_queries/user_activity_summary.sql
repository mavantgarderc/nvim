SELECT
  DATE_FORMAT (created_at, '%Y-%m') ASMONTH,
  COUNT(*) AS new_users,
  COUNT(
    CASE
      WHEN status = 'active' THEN 1
    END
  ) AS active_users,
  ROUND(
    COUNT(
      CASE
        WHEN status = 'active' THEN 1
      END
    ) * 100.0 / COUNT(*),
    2
  ) AS activation_rate
FROM
  users
GROUP BY
  DATE_FORMAT (created_at, '%Y-%m')
ORDER BY
  MONTH DESC;
