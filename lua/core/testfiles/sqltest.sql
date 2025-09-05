-- create, insert, and a simple report
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  signup DATE DEFAULT CURRENT_DATE,
  credits INTEGER DEFAULT 0
);

INSERT INTO users (name, credits) VALUES ('Mava', 10), ('Alex', 5), ('Sam', 7);

-- report: active users and average credits
SELECT COUNT(*) AS total_users, ROUND(AVG(credits),2) AS avg_credits FROM users;

-- list recent signups (last 7 days)
SELECT id,name,signup FROM users WHERE signup >= date('now','-7 days') ORDER BY signup DESC;
