-- HOSPITAL MANAGEMENT SYSTEM
-- Simplified Oracle SQL Implementation

-- Create Patients table to store patient information
CREATE TABLE Patients (
    patient_id NUMBER PRIMARY KEY,         -- Unique patient identifier
    first_name VARCHAR2(50) NOT NULL,      -- Patient's first name
    last_name VARCHAR2(50) NOT NULL,       -- Patient's last name
    dob DATE NOT NULL,                     -- Date of birth (YYYY-MM-DD)
    gender CHAR(1) NOT NULL,               -- M/F/O (Male/Female/Other)
    phone VARCHAR2(15) NOT NULL            -- Contact phone number
);

-- Create Doctors table to store doctor information
CREATE TABLE Doctors (
    doctor_id NUMBER PRIMARY KEY,          -- Unique doctor identifier
    first_name VARCHAR2(50) NOT NULL,      -- Doctor's first name
    last_name VARCHAR2(50) NOT NULL,       -- Doctor's last name
    specialty VARCHAR2(50) NOT NULL        -- Medical specialty
);

-- Create Appointments table to track patient appointments
CREATE TABLE Appointments (
    appt_id NUMBER PRIMARY KEY,            -- Unique appointment ID
    patient_id NUMBER NOT NULL,            -- References Patients table
    doctor_id NUMBER NOT NULL,             -- References Doctors table
    appt_date DATE NOT NULL,               -- Appointment date and time
    status VARCHAR2(20) NOT NULL,          -- Scheduled/Completed/Cancelled
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Create MedicalRecords table for patient health records
CREATE TABLE MedicalRecords (
    record_id NUMBER PRIMARY KEY,          -- Unique record ID
    patient_id NUMBER NOT NULL,            -- References Patients table
    doctor_id NUMBER NOT NULL,             -- References Doctors table
    diagnosis VARCHAR2(100) NOT NULL,      -- Medical diagnosis
    treatment VARCHAR2(100) NOT NULL,      -- Prescribed treatment
    record_date DATE NOT NULL,             -- Date of medical record
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Create Departments table for hospital departments
CREATE TABLE Departments (
    dept_id NUMBER PRIMARY KEY,            -- Unique department ID
    dept_name VARCHAR2(50) NOT NULL,       -- Department name
    head_doctor_id NUMBER NOT NULL,        -- Department head (references Doctors)
    FOREIGN KEY (head_doctor_id) REFERENCES Doctors(doctor_id)
);

-- Insert sample patients
INSERT INTO Patients VALUES (1, 'John', 'Doe', TO_DATE('1980-01-01', 'YYYY-MM-DD'), 'M', '555-1234');
INSERT INTO Patients VALUES (2, 'Jane', 'Smith', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'F', '555-5678');
INSERT INTO Patients VALUES (3, 'Robert', 'Brown', TO_DATE('1975-09-30', 'YYYY-MM-DD'), 'M', '555-9012');
INSERT INTO Patients VALUES (4, 'Emily', 'Davis', TO_DATE('1988-03-22', 'YYYY-MM-DD'), 'F', '555-3456');

-- Insert sample doctors
INSERT INTO Doctors VALUES (101, 'Michael', 'Chen', 'Cardiology');
INSERT INTO Doctors VALUES (102, 'Sarah', 'Johnson', 'Pediatrics');
INSERT INTO Doctors VALUES (103, 'James', 'Wilson', 'Orthopedics');
INSERT INTO Doctors VALUES (104, 'Lisa', 'Anderson', 'Neurology');

-- Insert sample departments
INSERT INTO Departments VALUES (201, 'Cardiology', 101);
INSERT INTO Departments VALUES (202, 'Pediatrics', 102);
INSERT INTO Departments VALUES (203, 'Orthopedics', 103);
INSERT INTO Departments VALUES (204, 'Neurology', 104);

-- Insert sample appointments
INSERT INTO Appointments VALUES (1001, 1, 101, TO_DATE('2023-06-15 10:00', 'YYYY-MM-DD HH24:MI'), 'Completed');
INSERT INTO Appointments VALUES (1002, 2, 102, TO_DATE('2023-06-16 14:30', 'YYYY-MM-DD HH24:MI'), 'Scheduled');
INSERT INTO Appointments VALUES (1003, 3, 103, TO_DATE('2023-06-17 09:15', 'YYYY-MM-DD HH24:MI'), 'Scheduled');
INSERT INTO Appointments VALUES (1004, 4, 104, TO_DATE('2023-06-18 11:00', 'YYYY-MM-DD HH24:MI'), 'Completed');

-- Insert sample medical records
INSERT INTO MedicalRecords VALUES (5001, 1, 101, 'Hypertension', 'Prescribed medication', TO_DATE('2023-06-15', 'YYYY-MM-DD'));
INSERT INTO MedicalRecords VALUES (5002, 2, 102, 'Annual Checkup', 'Routine vaccination', TO_DATE('2023-05-10', 'YYYY-MM-DD'));
INSERT INTO MedicalRecords VALUES (5003, 3, 103, 'Knee Pain', 'Physical therapy', TO_DATE('2023-06-10', 'YYYY-MM-DD'));
INSERT INTO MedicalRecords VALUES (5004, 4, 104, 'Migraine', 'Specialist referral', TO_DATE('2023-06-18', 'YYYY-MM-DD'));

-- QUERY 1: Get all scheduled appointments with patient and doctor details
SELECT 
    a.appt_id AS "Appointment ID",
    p.first_name || ' ' || p.last_name AS "Patient Name",
    d.first_name || ' ' || d.last_name AS "Doctor Name",
    TO_CHAR(a.appt_date, 'YYYY-MM-DD HH24:MI') AS "Appointment Time"
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled'
ORDER BY a.appt_date;

-- QUERY 2: Show medical history for a specific patient (Patient ID = 1)
SELECT 
    TO_CHAR(m.record_date, 'YYYY-MM-DD') AS "Record Date",
    d.first_name || ' ' || d.last_name AS "Doctor",
    m.diagnosis AS "Diagnosis",
    m.treatment AS "Treatment"
FROM MedicalRecords m
JOIN Doctors d ON m.doctor_id = d.doctor_id
WHERE m.patient_id = 1
ORDER BY m.record_date DESC;

-- QUERY 3: List all doctors and their specialties
SELECT 
    first_name || ' ' || last_name AS "Doctor Name",
    specialty AS "Specialty"
FROM Doctors
ORDER BY last_name;

-- QUERY 4: Count appointments per doctor
SELECT 
    d.first_name || ' ' || d.last_name AS "Doctor Name",
    COUNT(a.appt_id) AS "Appointment Count"
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.first_name, d.last_name
ORDER BY "Appointment Count" DESC;

-- QUERY 5: Find patients with upcoming appointments today
SELECT 
    p.first_name || ' ' || p.last_name AS "Patient",
    d.first_name || ' ' || d.last_name AS "Doctor",
    TO_CHAR(a.appt_date, 'HH24:MI') AS "Time"
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE TRUNC(a.appt_date) = TRUNC(SYSDATE)  -- Today's appointments
AND a.status = 'Scheduled';

-- QUERY 6: Add a new patient
INSERT INTO Patients 
VALUES (5, 'William', 'Taylor', TO_DATE('1995-11-08', 'YYYY-MM-DD'), 'M', '555-7890');

-- QUERY 7: Update appointment status (Mark appointment 1002 as completed)
UPDATE Appointments
SET status = 'Completed'
WHERE appt_id = 1002;

-- QUERY 8: Show department heads
SELECT 
    d.dept_name AS "Department",
    doc.first_name || ' ' || doc.last_name AS "Head Doctor"
FROM Departments d
JOIN Doctors doc ON d.head_doctor_id = doc.doctor_id;

-- QUERY 9: Find patients born before 1980
SELECT 
    first_name || ' ' || last_name AS "Patient",
    TO_CHAR(dob, 'YYYY-MM-DD') AS "Birth Date",
    phone AS "Contact"
FROM Patients
WHERE dob < TO_DATE('1980-01-01', 'YYYY-MM-DD');

-- QUERY 10: List all treatments for a specific diagnosis ('Migraine')
SELECT 
    p.first_name || ' ' || p.last_name AS "Patient",
    m.treatment AS "Treatment",
    TO_CHAR(m.record_date, 'YYYY-MM-DD') AS "Date"
FROM MedicalRecords m
JOIN Patients p ON m.patient_id = p.patient_id
WHERE LOWER(m.diagnosis) = 'migraine';  -- Case-insensitive search

-- COMMIT changes to database
COMMIT;