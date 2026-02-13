create table student(std_id INT,
    std_name VARCHAR(100),
    department VARCHAR(50),
    age INT);
    
select * from student;
    
INSERT INTO student (std_id, std_name, department, age)
VALUES (1,'Ram', 'CSE', 20);
INSERT INTO student (std_id, std_name, department, age)
VALUES (2,'Bhavitha', 'CSE', 20);
INSERT INTO student (std_id, std_name, department, age)
VALUES (3,'Shyam', 'CSD', 22);
INSERT INTO student (std_id, std_name, department, age)
VALUES (4,'Seetha', 'CSM', 18);

call get_student_info(@records,18);

select @records as Totalrecords;

