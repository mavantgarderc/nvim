SELECT
    id,
    name,
    email,
    status,
    created_at
FROM users
INTO OUTFILE "/tmp/users_export.csv"
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
