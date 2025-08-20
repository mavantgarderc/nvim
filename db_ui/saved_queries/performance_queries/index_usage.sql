SELECT
    table_name,
    index_name,
    cardinality,
    non_unique
FROM
    information_schema.statistics
WHERE
    table_schema = DATABASE()
ORDER BY
    table_name, cardinality DESC;
