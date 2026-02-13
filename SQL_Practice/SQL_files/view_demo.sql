use healthcare_new;

describe employee_txt;
describe healthcare_claims_xml;

CREATE VIEW Oper_Employees AS
SELECT employee_id, employee_name, salary
FROM Employee_txt
WHERE Department = 'Operations';

SELECT * FROM Oper_Employees;
select * from employee_txt where department='IT        ';

CREATE VIEW Employee_Healthcare_View AS
SELECT e.employee_name, h.hospital_name
FROM Employee_txt e
JOIN healthcare_claims_xml h
ON e.employee_id = h.employee_id;

select * from Employee_Healthcare_View;

CREATE VIEW IT_Employees AS
SELECT employee_id, employee_name, salary
FROM Employee_txt
WHERE TRIM(Department)= 'IT';

drop view IT_Employees;

SELECT * from IT_Employees;