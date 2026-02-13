use Data;


CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100),
  gender VARCHAR(10),
  date_of_birth DATE,
  email VARCHAR(100),
  phone VARCHAR(30),
  department VARCHAR(50),
  designation VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(50),
  join_date DATE,
  salary INT,
  employment_status VARCHAR(20)
);


CREATE TABLE healthcare_claims (
  claim_id INT PRIMARY KEY,
  employee_id INT,
  hospital_name VARCHAR(100),
  diagnosis VARCHAR(100),
  treatment_type VARCHAR(50),
  admission_date DATE,
  discharge_date DATE,
  claim_amount INT,
  approved_amount INT,
  claim_status VARCHAR(20),
  claim_date DATE
);

CREATE TABLE finance_transactions (
  transaction_id INT PRIMARY KEY,
  employee_id INT,
  transaction_type VARCHAR(50),
  amount INT,
  payment_mode VARCHAR(50),
  bank_name VARCHAR(50),
  account_number VARCHAR(50),
  transaction_date DATE,
  transaction_status VARCHAR(20)
);

select count(*) from finance_transactions;




