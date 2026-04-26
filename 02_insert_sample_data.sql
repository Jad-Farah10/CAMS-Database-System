-- =============================================================================
-- CAMS — Sample Data Insertion (DML)
-- File:        02_insert_sample_data.sql
-- Purpose:     Populate all tables with realistic test data
-- Run after:   01_create_schema.sql
-- =============================================================================

USE CAMS_DB;

-- -----------------------------------------------------------------------------
-- INSERT: Department
-- -----------------------------------------------------------------------------
INSERT INTO Department (DeptName, Location) VALUES
('General Medicine', 'Ground Floor, Wing A'),
('Dentistry',        'First Floor, Wing B'),
('Paediatrics',      'Ground Floor, Wing C');

-- -----------------------------------------------------------------------------
-- INSERT: Doctor
-- -----------------------------------------------------------------------------
INSERT INTO Doctor (FullName, Specialization, Phone, Email, DepartmentID) VALUES
('Dr. Ahmed Al-Saadi',  'Internal Medicine',  '0501234567', 'ahmed.s@medicareplus.ae', 1),
('Dr. Layla Hassan',    'Orthodontics',       '0502345678', 'layla.h@medicareplus.ae', 2),
('Dr. Omar Khalil',     'Paediatric Care',    '0503456789', 'omar.k@medicareplus.ae', 3),
('Dr. Sara Mansour',    'Cardiology',         '0504567890', 'sara.m@medicareplus.ae', 1);

-- -----------------------------------------------------------------------------
-- INSERT: Patient
-- -----------------------------------------------------------------------------
INSERT INTO Patient (FullName, DOB, Gender, Phone, Email, Address) VALUES
('Mariam Al-Zahra',    '1995-03-14', 'F', '0556781234', 'mariam.z@mail.ae',  'Al Majaz, Sharjah'),
('Yousef Rahman',      '1988-07-22', 'M', '0557892345', 'yousef.r@mail.ae',  'Al Nahda, Sharjah'),
('Noura Al-Sharif',    '2010-11-05', 'F', '0558903456', 'noura.s@mail.ae',   'Al Qasimia, Sharjah'),
('Khalid Al-Mansoori', '1975-05-30', 'M', '0559014567', 'khalid.m@mail.ae',  'Al Khan, Sharjah'),
('Ali Al-Hashimi',     '1982-09-18', 'M', '0551234567', 'ali.h@mail.ae',     'Al Taawun, Sharjah');

-- -----------------------------------------------------------------------------
-- INSERT: Appointment
-- -----------------------------------------------------------------------------
INSERT INTO Appointment (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, Notes) VALUES
(1, 1, '2026-04-25', '09:00:00', 'Completed', 'Routine check-up'),
(2, 2, '2026-04-25', '09:30:00', 'Completed', 'Dental cleaning'),
(3, 3, '2026-04-25', '10:00:00', 'Completed', 'Fever follow-up'),
(4, 4, '2026-04-25', '11:00:00', 'Cancelled', 'Patient rescheduled'),
(1, 4, '2026-04-25', '13:00:00', 'Scheduled', 'Cardiology referral'),
(5, 1, '2026-04-25', '14:00:00', 'Scheduled', 'Annual physical');

-- -----------------------------------------------------------------------------
-- INSERT: Treatment
-- -----------------------------------------------------------------------------
INSERT INTO Treatment (AppointmentID, Diagnosis, Prescription, Cost, TreatmentDate) VALUES
(1, 'Hypertension Stage 1', 'Amlodipine 5mg daily',      250.00, '2026-04-25'),
(2, 'Mild gingivitis',      'Chlorhexidine rinse',       180.00, '2026-04-25'),
(3, 'Viral fever',          'Paracetamol 250mg, fluids', 120.00, '2026-04-25');

-- -----------------------------------------------------------------------------
-- INSERT: Invoice
-- -----------------------------------------------------------------------------
INSERT INTO Invoice (PatientID, TreatmentID, TotalAmount, PaymentStatus) VALUES
(1, 1, 250.00, 'Paid'),
(2, 2, 180.00, 'Unpaid'),
(3, 3, 120.00, 'Paid');

-- =============================================================================
-- VERIFICATION: Check inserted data
-- =============================================================================
SELECT 'Departments inserted: ' AS Status, COUNT(*) AS Total FROM Department
UNION ALL
SELECT 'Doctors inserted: ',     COUNT(*) FROM Doctor
UNION ALL
SELECT 'Patients inserted: ',    COUNT(*) FROM Patient
UNION ALL
SELECT 'Appointments inserted: ',COUNT(*) FROM Appointment
UNION ALL
SELECT 'Treatments inserted: ',  COUNT(*) FROM Treatment
UNION ALL
SELECT 'Invoices inserted: ',    COUNT(*) FROM Invoice;

-- =============================================================================
-- END OF FILE — 02_insert_sample_data.sql
-- =============================================================================
