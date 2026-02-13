USE sakila;
-- DDL
CREATE TABLE demo_students (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    marks INT
);
ALTER TABLE demo_students ADD grade VARCHAR(5);
INSERT INTO demo_students VALUES
(1, 'A', 80, 'A+'),
(2, 'B', 70, 'C'),
(3, 'C', 60, 'B');
SELECT * FROM demo_students;
TRUNCATE TABLE demo_students;
DROP TABLE demo_students;

-- DML
INSERT INTO actor (first_name, last_name)
VALUES ('TEST', 'ACTOR');
SELECT * 
FROM actor 
WHERE first_name = 'TEST' AND last_name = 'ACTOR';
-- (OR)
SELECT * 
FROM actor 
ORDER BY actor_id DESC
LIMIT 1;
UPDATE actor
SET first_name = 'UPDATED'
WHERE actor_id = 201;
DELETE FROM actor WHERE actor_id = 201;
SELECT * FROM actor WHERE actor_id = 201;


-- DCL
CREATE USER 'user1'@'localhost' IDENTIFIED BY 'test123';
SELECT user, host FROM mysql.user;
GRANT SELECT ON sakila.* TO 'user1'@'localhost';
REVOKE SELECT ON sakila.* FROM 'user1'@'localhost';
DROP USER 'user1'@'localhost';


-- TCL(ROLLBACK)
SET autocommit = 0;

SELECT * FROM actor WHERE actor_id = 1;
UPDATE actor 
SET first_name = 'FRANCE'
WHERE actor_id = 1;
ROLLBACK;

-- TCL(COMMIT)
UPDATE actor 
SET first_name = 'FINAL'
WHERE actor_id = 1;
SELECT * FROM actor WHERE actor_id = 1;

-- TCL(SAVEPOINT)
UPDATE actor SET first_name = 'A1' WHERE actor_id = 1;
SAVEPOINT s1;
UPDATE actor SET first_name = 'A2' WHERE actor_id = 1;
SELECT * FROM actor WHERE actor_id = 1;
ROLLBACK TO s1;

