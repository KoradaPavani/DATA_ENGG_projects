USE practice_db;
CREATE TABLE prac_hr_data (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  age INT,
  salary VARCHAR(50),
  gender VARCHAR(10),
  department VARCHAR(50),
  position VARCHAR(50),
  join_date VARCHAR(30),
  performance_score CHAR(1),
  email VARCHAR(100),
  phone_num VARCHAR(30)
);

    
DROP TABLE prac_hr_data;

SELECT COUNT(*) FROM prac_hr_data;

INSERT INTO prac_hr_data(
name,
age,
salary,
gender,
department,
position,
join_date,
performance_score,
email,
phone_num)
SELECT 
	TRIM(name),
    CAST(REPLACE(NULLIF(TRIM(age),'nan'),'thirty','30') AS UNSIGNED),
    CAST(
		NULLIF(REGEXP_REPLACE(TRIM(salary), '[^0-9]', ''), '') AS UNSIGNED),
    TRIM(gender),
    TRIM(department),
    TRIM(position),
    TRIM(`joining date`),
    TRIM(`performance score`),
    NULLIF(NULLIF(LOWER(TRIM(email)), ''), 'NAN'),
    REGEXP_REPLACE(TRIM(`phone number`), '[^0-9]', '')
FROM messy_hr_data;

SELECT * FROM prac_hr_data;
SELECT * FROM messy_hr_data;


SET SQL_SAFE_UPDATES = 0;

-- i did this becoz my records started from 18..earlier i have inserted and deleted
TRUNCATE TABLE prac_hr_data;   


UPDATE prac_hr_data
SET join_date =
  CASE
    WHEN join_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      THEN STR_TO_DATE(join_date, '%Y-%m-%d')

    WHEN join_date REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
      THEN STR_TO_DATE(join_date, '%Y/%m/%d')

    WHEN join_date REGEXP '^[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}$'
      THEN STR_TO_DATE(join_date, '%Y.%m.%d')

    WHEN join_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
      THEN STR_TO_DATE(join_date, '%m/%d/%Y')

    WHEN join_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
      THEN STR_TO_DATE(join_date, '%m-%d-%Y')

    WHEN join_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
      THEN STR_TO_DATE(join_date, '%d-%m-%Y')

    WHEN join_date REGEXP '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
      THEN STR_TO_DATE(join_date, '%M %e, %Y')

    WHEN join_date REGEXP '^[A-Za-z]+ [0-9]{1,2} [0-9]{4}$'
      THEN STR_TO_DATE(join_date, '%M %e %Y')

    ELSE NULL
  END;



ALTER TABLE prac_hr_data
MODIFY join_date DATE;

DESCRIBE prac_hr_data;

SELECT count(*) FROM prac_hr_data;

-- PRACTICE

SELECT department, MAX(salary) 
FROM prac_hr_data 
GROUP BY department;

SELECT join_date, name
FROM prac_hr_data
WHERE join_date > '2019-12-31';

SELECT name FROM prac_hr_data
WHERE name LIKE 'A%'; 

SELECT name, salary
FROM prac_hr_data
ORDER BY CAST(salary AS UNSIGNED) DESC;

SELECT department, count(*) AS EMP_CNT
FROM prac_hr_data
GROUP BY department;

SELECT department, AVG(CAST(salary AS UNSIGNED))
FROM prac_hr_data
GROUP BY department;

SELECT department, count(*) AS CNT
FROM prac_hr_data
GROUP BY department
HAVING count(*) >= 200;

SELECT name,join_date
FROM prac_hr_data
WHERE YEAR(join_date)=2020;

SELECT name,salary,
CASE
	WHEN CAST(salary AS UNSIGNED)>=70000 THEN 'high_salary'
    WHEN CAST(salary AS UNSIGNED)>=55000 THEN 'Medium_salary'
    ELSE 'Low'
END AS salary_category
FROM prac_hr_data;

SELECT name,department,
CAST(salary AS UNSIGNED) AS salary,
RANK() OVER(ORDER BY CAST(salary AS UNSIGNED) DESC) AS salary_rank
FROM prac_hr_data;

SELECT name,department,
CAST(salary AS UNSIGNED) AS salary,
DENSE_RANK() OVER(ORDER BY CAST(salary AS UNSIGNED)DESC) AS salary_dense_rank
FROM prac_hr_data;

SELECT name,department,
CAST(salary AS UNSIGNED) AS salary,
DENSE_RANK() OVER(
	PARTITION BY department
    ORDER BY CAST(salary AS UNSIGNED) DESC) AS dept_sal_rank
FROM prac_hr_data;

SELECT * FROM(
SELECT name,department,
CAST(salary AS UNSIGNED) AS salary,
DENSE_RANK() OVER(
PARTITION BY department
ORDER BY CAST(salary AS UNSIGNED) DESC) AS dept_sal_rank
FROM prac_hr_data
)t
WHERE dept_sal_rank<=2;


SELECT * FROM(
SELECT name,department,
CAST(salary AS UNSIGNED) AS salary,
ROW_NUMBER() OVER(
PARTITION BY department
ORDER BY CAST(salary AS UNSIGNED) DESC) AS dept_sal_rank
FROM prac_hr_data
)t
WHERE dept_sal_rank=1;


SELECT AVG(CAST(salary AS UNSIGNED)) AS company_avg_sal
FROM prac_hr_data;

SELECT department,
AVG(CAST(salary AS UNSIGNED)) AS dept_sal
FROM prac_hr_data
GROUP BY department;

-- COMAPRING BOTH
SELECT department,
AVG(CAST(salary AS UNSIGNED)) AS dept_sal
FROM prac_hr_data
GROUP BY department
HAVING AVG(CAST(salary AS UNSIGNED)) >
		(SELECT AVG(CAST(salary AS UNSIGNED)) FROM prac_hr_data);





START transaction;

SAVEPOINT before_dupe_insert;
COMMIT;
select COUNT(*) from prac_hr_data;
-- CREATED 5 RECORDS(DUP)
INSERT INTO prac_hr_data
	(name,age,salary,gender,department,position,join_date,performance_score,email,phone_num)
SELECT 
	name,age,salary,gender,department,position,join_date,performance_score,email,phone_num 
FROM prac_hr_data
LIMIT 5;


-- DEDUPLICATION
-- TO CHECK DUPLICATES
SELECT name,age,salary,gender,department,position,join_date,performance_score,email,phone_num,
COUNT(*) AS CNT
FROM prac_hr_data
GROUP BY
name,age,salary,gender,department,position,join_date,performance_score,email,phone_num
HAVING COUNT(*)>1;

SELECT COUNT(*) FROM prac_hr_data;

-- DUPE USING WINDOW FUNCTIONS
SELECT * FROM( 
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY name,age,salary,gender,department,position,join_date,performance_score,email,phone_num
ORDER BY id
) AS rn
FROM prac_hr_data
)t
WHERE rn>1;


-- DEDUPLICATION EXAMPLES
SELECT id,name,email,
ROW_NUMBER() OVER(
PARTITION BY name,email
ORDER BY id)AS rn
FROM prac_hr_data;

SELECT id,name,email,
COUNT(*) AS CNT
FROM prac_hr_data
GROUP BY name,email
HAVING COUNT(*)>1;


-- RANK,D-RANK,ROW-NUM(COMPARISION)
SELECT name,department,
CAST(salary AS UNSIGNED) AS salary,
RANK() OVER(ORDER BY CAST(salary AS UNSIGNED) DESC)AS rank_sal,
DENSE_RANK() OVER(ORDER BY CAST(salary AS UNSIGNED) DESC)AS dense_rank_sal,
ROW_NUMBER() OVER(ORDER BY CAST(salary AS UNSIGNED) DESC)AS rn
FROM prac_hr_data;


-- EXISTS
SELECT *
FROM prac_hr_data p1
WHERE EXISTS (
SELECT 1
FROM prac_hr_data p2
WHERE p1.name = p2.name
    AND p1.email = p2.email
    AND p1.id <> p2.id
);


SELECT *
FROM prac_hr_data p1
WHERE NOT EXISTS (
SELECT 1
FROM prac_hr_data p2
WHERE p1.name = p2.name
    AND p1.email = p2.email
    AND p1.id <> p2.id
);

 
 SELECT * FROM prac_hr_data
 WHERE id NOT IN(
 SELECT p2.id FROM prac_hr_data p1
 JOIN prac_hr_data p2
 ON p1.name=p2.name
 AND p1.email=p2.email
 AND p1.id<>p2.id
 );
 
 SELECT * FROM prac_hr_data
 WHERE id IN(
 SELECT p2.id FROM prac_hr_data p1
 JOIN prac_hr_data p2
 ON p1.name=p2.name
 AND p1.email=p2.email
 AND p1.id<>p2.id
 );
 
 
SELECT *
FROM prac_hr_data p1
WHERE EXISTS (
  SELECT 1
  FROM prac_hr_data p2
  WHERE p1.id <> p2.id
    AND p1.name = p2.name
    AND p1.age <=> p2.age
    AND p1.salary <=> p2.salary
    AND p1.gender <=> p2.gender
    AND p1.department <=> p2.department
    AND p1.position <=> p2.position
    AND p1.join_date <=> p2.join_date
    AND p1.performance_score <=> p2.performance_score
    AND p1.email <=> p2.email
    AND p1.phone_num <=> p2.phone_num
);
