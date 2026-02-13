CREATE TABLE appointments (
appointment_id INT PRIMARY KEY,
patient_name VARCHAR(100),
doctor_name VARCHAR(100),
department VARCHAR(50),
appointment_date DATE,
fee INT,
status VARCHAR(30)
);

INSERT INTO appointments VALUES
(1,'Anu','Dr. Rao','Cardiology','2026-02-01',500,'Booked'),
(2,'Vijay','Dr. Meena','Neurology','2026-02-02',700,'Completed'),
(3,'Sara','Dr. Rao','Cardiology','2026-02-03',500,'Booked'),
(4,'Arjun','Dr. Kumar','Ortho','2026-02-04',400,'Cancelled');

-- no parameters
DELIMITER //
CREATE PROCEDURE get_all_appointments()
BEGIN
SELECT * FROM appointments;
END //
DELIMITER ;

CALL get_all_appointments();

-- in parameter
DELIMITER //
CREATE PROCEDURE get_by_dept(IN dept varchar(50))
BEGIN
SELECT * FROM appointments WHERE department=dept;
END//
DELIMITER ;

CALL get_by_dept('Cardiology');

-- out Parameter
DELIMITER $$
CREATE PROCEDURE total_appointments(OUT total INT)
BEGIN
SELECT COUNT(*) INTO total FROM appointments;
END$$
DELIMITER ;

CALL total_appointments(@tot);
SELECT @tot;

--  conditional logic
DELIMITER !!
CREATE PROCEDURE fee_category(IN a_id INT)
BEGIN
DECLARE Fees INT;
SELECT fee INTO Fees FROM appointments WHERE appointment_id=a_id;
IF Fees>= 600 THEN
SELECT 'High fee';
else
SELECT 'Low fee';
END IF;
END!!
DELIMITER ;

CALL fee_category(2);

-- update,commit,transaction
DELIMITER ##
CREATE PROCEDURE update_status(IN a_id INT, IN new_status VARCHAR(30))
BEGIN
	START TRANSACTION;
    
    UPDATE appointments
    SET status=new_status
    WHERE appointment_id=a_id;
    COMMIT;
END ##
DELIMITER ;

CALL update_status(1,'Completed');

-- inserting
DELIMITER //
CREATE PROCEDURE add_appointment(IN a_id INT, IN p_name VARCHAR(100), IN d_name VARCHAR(100), IN dept VARCHAR(50),
	IN a_date DATE, IN fee_amt INT, IN a_status VARCHAR(30))
    BEGIN
		IF fee_amt>0 THEN
			INSERT INTO appointments
			VALUES(a_id, p_name,d_name,dept,a_date,fee_amt,a_status);
        ELSE
			SELECT 'Invalid Fee';
	END IF;
END//
DELIMITER ;

CALL add_appointment(5,'Priya','Dr. Ravi','Neurology','2026-02-05', 1000,'Boooked');

SHOW PROCEDURE STATUS
WHERE Db = DATABASE();
