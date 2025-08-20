SELECT
  status,
  COUNT(*) AS COUNT,
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT
        COUNT(*)
      FROM
        orders
    ),
    2
  ) AS percentage
FROM
  orders
GROUP BY
  status
ORDER BY
  COUNTDESC;
