WITH hr_dept_count AS(
SELECT department, COUNT(*) AS hr_cnt
FROM cleaned_hr_data
GROUP BY department
)
SELECT * FROM hr_dept_count 
WHERE hr_cnt>187;


WITH hr_count AS(
SELECT department, COUNT(*) AS hr_dept_cnt
FROM cleaned_hr_data
GROUP BY department
)
SELECT * FROM hr_count;


WITH join_date_2020 AS(
SELECT name, department, joining_date FROM cleaned_hr_data
WHERE YEAR(joining_date)=2020
)
SELECT * FROM join_date_2020;