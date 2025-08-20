DELETE FROM users
WHERE
  email LIKE "%test%"
  OR emailLIKE "%example.com";
