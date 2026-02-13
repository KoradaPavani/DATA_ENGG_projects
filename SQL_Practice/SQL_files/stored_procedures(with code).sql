use healthcare_new;

Describe employee_txt;

select *from employee_txt;
 
DELIMITER //
 
CREATE PROCEDURE GetHighSalaryEmployees (
    IN min_salary INT
)
BEGIN
    SELECT *
    FROM Employee_txt
    WHERE salary >= min_salary;
END //
 
DELIMITER ;
 
DROP PROCEDURE IF EXISTS GetHighSalaryEmployees;
 
CALL GetHighSalaryEmployees(500000);
 
