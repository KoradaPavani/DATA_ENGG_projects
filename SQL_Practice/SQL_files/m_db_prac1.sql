use practice_db;
select name,count(*) from prac_hr_data;
WITH salary_rank AS (
    SELECT
	id,name,department,salary,position,join_date,performance_score,
	DENSE_RANK() OVER
    (PARTITION BY department
	ORDER BY salary DESC) AS salary_rank,
    count(*) over(partition by id,name,department,salary,position,join_date,performance_score) as cnt
    FROM prac_hr_data
)
SELECT * FROM salary_rank
WHERE salary_rank <= 2 
ORDER BY department, salary DESC, join_date;



with comparision_cte as(
SELECT id,name,department,position,performance_score,
CAST(salary AS UNSIGNED) AS salary,
RANK() OVER(ORDER BY CAST(salary AS UNSIGNED) DESC)AS rank_sal,
DENSE_RANK() OVER(ORDER BY CAST(salary AS UNSIGNED) DESC)AS dense_rank_sal,
ROW_NUMBER() OVER(ORDER BY CAST(salary AS UNSIGNED) DESC)AS rn
FROM prac_hr_data
)
select * from comparision_cte;



use sakila;
select * from film;


-- rank movies acc to their ratings
with rental_cte as(
select film_id,title,rental_rate,
rank() over(order by rental_rate desc)as rate_rank
from film
)
select * from rental_cte
order by rate_rank;



-- take tables in sakila and rank them with rows(using info_schema)
with tables_sakila as(
select table_name, table_rows
from information_schema.tables
where table_schema='sakila'
),
rank_sakila_tables as(
select table_name, table_rows,
rank() over(order by table_rows desc) as rank_rows
from tables_sakila)
select * from rank_sakila_tables;


select * from film;
select * from actor;
select * from film_actor;
-- films with actor names
WITH film_actor_cte AS (
select fa.film_id,a.actor_id,
concat(a.first_name, ' ', a.last_name) AS actor_name
from film_actor fa
join actor a
on fa.actor_id = a.actor_id
)
select f.title,fac.actor_name
from film f
join film_actor_cte fac
on f.film_id = fac.film_id
order by f.title;




