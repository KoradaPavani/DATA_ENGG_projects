CREATE database Practice_DB;
use Practice_DB;
describe messy_hr_data;
SELECT * FROM messy_hr_data;

-- col1
SELECT name, UPPER(TRIM(name))AS trimmed_name
FROM messy_hr_data;

-- col2
SELECT age,
	CAST(REPLACE(NULLIF(TRIM(age), 'nan'),'thirty', '30') AS UNSIGNED)
FROM messy_hr_data; 

-- col3
SELECT salary, 
	CAST(REPLACE(NULLIF(TRIM(salary), 'nan'), 'SIXTY THOUSAND', '60000') AS UNSIGNED)
FROM messy_hr_data;

-- COL4
SELECT gender, 
LOWER(TRIM(gender)) FROM messy_hr_data;


-- col5
SELECT department,
TRIM(department) FROM messy_hr_data;

SELECT * FROM messy_hr_data WHERE department IN('IT','marketing', 'FINANCE');

-- COL6
SELECT position,
TRIM(position) FROM messy_hr_data;

-- COL7
SELECT TRIM(`performance score`) FROM messy_hr_data;
SELECT `performance score` FROM messy_hr_data;
SELECT DISTINCT TRIM(`Performance Score`) FROM messy_hr_data;
SELECT DISTINCT
    CONCAT('[', `Performance Score`, ']') AS score_check
FROM messy_hr_data;


-- col8
SELECT `joining date`,
DATE_FORMAT(
	COALESCE(
		STR_TO_DATE(TRIM(`joining date`), '%Y.%m.%d'),
        STR_TO_DATE(TRIM(`joining date`), '%m-%d-%Y'),
        STR_TO_DATE(TRIM(`joining date`), '%M %d, %Y'),
        STR_TO_DATE(TRIM(`joining date`), '%Y/%m/%d'),
        STR_TO_DATE(TRIM(`joining date`), '%m/%d/%Y')
	),
'%d-%M-%Y'
)AS formatted_date
FROM messy_hr_data;

-- COL 9
SELECT email,
NULLIF(NULLIF(LOWER(TRIM(email)), ''), 'NAN') AS email FROM messy_hr_data;

SELECT name, email, CONCAT(LOWER(TRIM(name)), '@email.com') AS Proper_Email FROM messy_hr_data;

SELECT name,email,
	CASE 
		WHEN LOWER(TRIM(email)) IN ('','nan') OR email IS NULL
        THEN NULL
        ELSE CONCAT(LOWER(TRIM(name)), '@gmail.com')
	END AS proper_email
FROM messy_hr_data;


-- COL10
SELECT NULLIF(REGEXP_REPLACE(TRIM(`PHONE NUMBER`), '[^0-9]', ''), '') AS clean_phn_num 
FROM messy_hr_data 
WHERE LENGTH(REGEXP_REPLACE(TRIM(`PHONE NUMBER`), '[^0-9]', ''))=10;








-- CREATING CLEANED TABLE
CREATE TABLE cleaned_hr_data( 
	name VARCHAR(100),
    age INT,
    salary INT,
    gender VARCHAR(20),
    department VARCHAR(50),
    position VARCHAR(50),
    joining_date VARCHAR(50),
    performance_score VARCHAR(20),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

DROP TABLE cleaned_hr_data;

INSERT INTO cleaned_hr_data
SELECT
    UPPER(TRIM(name)),
    CAST(REPLACE(NULLIF(TRIM(age),'nan'),'thirty','30') AS UNSIGNED),
    CAST(REPLACE(NULLIF(TRIM(salary),'nan'),'SIXTY THOUSAND','60000') AS UNSIGNED),
    TRIM(gender),
    TRIM(department),
    TRIM(position),
	TRIM(`joining date`),
    TRIM(`performance score`),
    NULLIF(NULLIF(LOWER(TRIM(email)),''),'nan'),
    NULLIF(REGEXP_REPLACE(TRIM(`phone number`),'[^0-9]',''),'')
FROM messy_hr_data;


SELECT
TRIM(`joining date`) AS raw,
COALESCE(
    STR_TO_DATE(REPLACE(TRIM(`joining date`), ',', ''), '%M %e %Y'),
    STR_TO_DATE(REPLACE(REPLACE(REPLACE(TRIM(`joining date`), '/', '-'), '.', '-'), ',', ''), '%Y-%c-%e'),
    STR_TO_DATE(REPLACE(REPLACE(REPLACE(TRIM(`joining date`), '/', '-'), '.', '-'), ',', ''), '%m-%d-%Y')
) AS final_date
FROM messy_hr_data;

describe cleaned_hr_data;

UPDATE cleaned_hr_data
SET joining_date =
  CASE
    WHEN joining_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      THEN STR_TO_DATE(joining_date, '%Y-%m-%d')
    WHEN joining_date REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
      THEN STR_TO_DATE(joining_date, '%Y/%m/%d')
    WHEN joining_date REGEXP '^[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}$'
      THEN STR_TO_DATE(joining_date, '%Y.%m.%d')
    WHEN joining_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
      THEN STR_TO_DATE(joining_date, '%m/%d/%Y')
    WHEN joining_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
      THEN STR_TO_DATE(joining_date, '%m-%d-%Y')
    WHEN joining_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
      THEN STR_TO_DATE(joining_date, '%d-%m-%Y')
    WHEN joining_date REGEXP '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
      THEN STR_TO_DATE(joining_date, '%M %e, %Y')
    WHEN joining_date REGEXP '^[A-Za-z]+ [0-9]{1,2} [0-9]{4}$'
      THEN STR_TO_DATE(joining_date, '%M %e %Y')

    ELSE NULL
  END;

SET SQL_SAFE_UPDATES = 0;

TRUNCATE TABLE cleaned_hr_data;

SELECT * FROM cleaned_hr_data;



SELECT * FROM messy_hr_data;
SELECT 
CASE
WHEN NULLIF(NULLIF(TRIM(LOWER(salary)), ''), 'nan') IS NULL
	THEN NULL
WHEN LOWER(salary) REGEXP '^[a-z ]+$'
    THEN NULL   
WHEN LOWER(salary) REGEXP 'crore'
    THEN CAST(REGEXP_REPLACE(salary,'[^0-9]','') AS UNSIGNED) * 10000000
WHEN LOWER(salary) REGEXP '(lakh|l)'
    THEN CAST(REGEXP_REPLACE(salary,'[^0-9]','') AS UNSIGNED) * 100000
WHEN LOWER(salary) REGEXP '(million|m)'
    THEN CAST(REGEXP_REPLACE(salary,'[^0-9]','') AS UNSIGNED) * 1000000
WHEN LOWER(salary) REGEXP '(thousand|k)'
    THEN CAST(REGEXP_REPLACE(salary,'[^0-9]','') AS UNSIGNED) * 1000
WHEN LOWER(salary) REGEXP 'hundred'
    THEN CAST(REGEXP_REPLACE(salary,'[^0-9]','') AS UNSIGNED) * 100
WHEN REGEXP_REPLACE(salary,'[^0-9]','') <> ''
    THEN CAST(REGEXP_REPLACE(salary,'[^0-9]','') AS UNSIGNED)
ELSE NULL
  END AS clean_salary FROM messy_hr_data;

UPDATE messy_hr_data
SET salary= '70000'
WHERE name= ' GRACE ';



-- deduplication
SELECT
name, age, salary, gender, department, position,`joining_date`, `performance_score`, email, `phone_number`,
COUNT(*) AS cnt
FROM messy_hr_data
GROUP BY
name, age, salary, gender, department, position,`joining date`, `performance score`, email, `phone number`
HAVING COUNT(*) > 1;


SELECT * FROM (
    SELECT
        name,age,salary,gender,department,position,`joining date`,`performance score`,email,`phone number`,
        ROW_NUMBER() OVER (
            PARTITION BY
                name,age,salary,gender,department,position,`joining date`,`performance score`,email,`phone number`
            ORDER BY name
        ) AS rn
    FROM messy_hr_data
) t
WHERE rn > 1;


-- CTEs
WITH hr_data AS(
SELECT name FROM cleaned_hr_data
)
SELECT * FROM hr_data;


WITH join_date_2020 AS(
SELECT name, department, joining_date FROM cleaned_hr_data
WHERE YEAR(joining_date)=2020
)
SELECT * FROM join_date_2020;

WITH hr_count AS(
SELECT department, COUNT(*) AS hr_dept_cnt
FROM cleaned_hr_data
GROUP BY department
)
SELECT * FROM hr_count;

WITH hr_dept_count AS(
SELECT department, COUNT(*) AS hr_cnt
FROM cleaned_hr_data
GROUP BY department
)
SELECT * FROM hr_dept_count 
WHERE hr_cnt>187;

WITH dept_count AS(
SELECT department, count(*) AS cnt
FROM cleaned_hr_data
GROUP BY department
)
SELECT 
c.name,
c.department,
d.cnt
FROM cleaned_hr_data c
JOIN dept_count d
	ON c.department=d.department;