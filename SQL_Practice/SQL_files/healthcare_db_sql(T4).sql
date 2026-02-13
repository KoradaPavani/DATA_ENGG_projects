CREATE database healthcare_db_sql;
use healthcare_db_sql;
CREATE TABLE Departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Patients (
  patient_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  dob DATE NOT NULL,
  gender VARCHAR(10),
  phone VARCHAR(15),
  email VARCHAR(100),
  address TEXT
);
CREATE TABLE Doctors (
  doctor_id INT PRIMARY KEY,
  doctor_name VARCHAR(100) NOT NULL,
  phone VARCHAR(15),
  email VARCHAR(100) UNIQUE,
  department_id INT NOT NULL,
  FOREIGN KEY (department_id)
    REFERENCES Departments(department_id)
);
CREATE TABLE Appointments (
  appointment_id INT PRIMARY KEY,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled')),
  FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id),
  FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id)
);
CREATE TABLE Diagnoses (
  diagnosis_id INT PRIMARY KEY,
  appointment_id INT NOT NULL,
  diagnosis_details TEXT NOT NULL,
  diagnosis_date DATE NOT NULL,
  FOREIGN KEY (appointment_id)
    REFERENCES Appointments(appointment_id)
);
CREATE TABLE Prescriptions (
  prescription_id INT PRIMARY KEY,
  appointment_id INT NOT NULL,
  prescription_date DATE NOT NULL,
  FOREIGN KEY (appointment_id)
    REFERENCES Appointments(appointment_id)
);
CREATE TABLE Medications (
  medication_id INT PRIMARY KEY,
  medication_name VARCHAR(100) NOT NULL UNIQUE,
  dosage VARCHAR(50),
  instructions TEXT
);
CREATE TABLE Prescription_Medications (
  prescription_id INT,
  medication_id INT,
  quantity INT CHECK (quantity > 0),
  PRIMARY KEY (prescription_id, medication_id),
  FOREIGN KEY (prescription_id)
    REFERENCES Prescriptions(prescription_id),
  FOREIGN KEY (medication_id)
    REFERENCES Medications(medication_id)
);
CREATE TABLE Lab_Tests (
  lab_test_id INT PRIMARY KEY,
  appointment_id INT NOT NULL,
  test_name VARCHAR(100) NOT NULL,
  test_date DATE NOT NULL,
  result TEXT,
  FOREIGN KEY (appointment_id)
    REFERENCES Appointments(appointment_id)
);
CREATE TABLE Billing (
  bill_id INT PRIMARY KEY,
  appointment_id INT NOT NULL,
  amount DECIMAL(10,2) CHECK (amount >= 0),
  payment_status VARCHAR(20)
    CHECK (payment_status IN ('Pending', 'Paid', 'Cancelled')),
  payment_date DATE,
  FOREIGN KEY (appointment_id)
    REFERENCES Appointments(appointment_id)
);
CREATE TABLE Insurance (
  insurance_id INT PRIMARY KEY,
  patient_id INT NOT NULL,
  provider_name VARCHAR(100) NOT NULL,
  policy_number VARCHAR(50) UNIQUE NOT NULL,
  coverage_details TEXT,
  FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id)
);

SET FOREIGN_KEY_CHECKS = 1;

DROP TABLE patients;



select count(*) from Patients;
SELECT * FROM patients LIMIT 10;

