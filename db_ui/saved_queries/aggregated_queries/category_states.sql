SELECT
  category,
  COUNT(*) AS product_count,
  AVG(price) AS avg_price,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM
  products
GROUP BY
  category
ORDER BY
  product_countDESC;
