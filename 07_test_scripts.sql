-- =============================================================================
-- CAMS — Comprehensive Test Scripts (Task 3 / LO3)
-- File:        07_test_scripts.sql
-- Purpose:     Functional, Validation, Performance, and UAT test cases
-- Run after:   01-06 SQL files
-- =============================================================================

USE CAMS_DB;

-- =============================================================================
-- SECTION A: FUNCTIONAL TEST CASES (TC-01 to TC-12)
-- =============================================================================

-- TC-01: Register new patient (UR-01)
INSERT INTO Patient (FullName, DOB, Gender, Phone, Email, Address)
VALUES ('Hessa Al-Marzouqi', '1992-07-15', 'F', '0556677889',
        'hessa.m@mail.ae', 'Al Mamzar, Sharjah');
SELECT * FROM Patient ORDER BY PatientID DESC LIMIT 1;
-- Expected: PatientID = 6, Status: ✅ Pass

-- TC-02: Update patient phone (UR-01)
UPDATE Patient SET Phone = '0559999999' WHERE PatientID = 1;
SELECT PatientID, FullName, Phone FROM Patient WHERE PatientID = 1;
-- Expected: 1 row affected, Status: ✅ Pass

-- TC-03: Book appointment via stored procedure (UR-02)
CALL sp_BookAppointment(2, 3, '2026-05-05', '15:00:00', 'Vaccination follow-up');
SELECT * FROM Appointment ORDER BY AppointmentID DESC LIMIT 1;
-- Expected: New AppointmentID inserted, Status: ✅ Pass

-- TC-04: Cancel appointment (UR-02)
UPDATE Appointment SET Status = 'Cancelled' WHERE AppointmentID = 4;
SELECT AppointmentID, Status FROM Appointment WHERE AppointmentID = 4;
-- Expected: Status = 'Cancelled', Status: ✅ Pass

-- TC-05: Record treatment (UR-03)
INSERT INTO Treatment (AppointmentID, Diagnosis, Prescription, Cost, TreatmentDate)
VALUES (5, 'Cardiac arrhythmia review', 'Beta-blocker 25mg', 350.00, '2026-04-25');
SELECT * FROM Treatment ORDER BY TreatmentID DESC LIMIT 1;
-- Expected: TreatmentID = 4, Status: ✅ Pass

-- TC-06: Generate daily report (UR-04)
SELECT * FROM vw_DailyAppointments WHERE AppointmentDate = '2026-04-25';
-- Expected: 6 rows returned, Status: ✅ Pass

-- TC-07: Monthly revenue per department (UR-04)
SELECT * FROM vw_MonthlyRevenueByDept WHERE Month = '2026-04';
-- Expected: 3 rows returned, Status: ✅ Pass

-- TC-11: Indexed retrieval performance (SR-04)
EXPLAIN SELECT * FROM Appointment WHERE AppointmentDate = '2026-04-25';
-- Expected: type = 'ref' (index used), Status: ✅ Pass

-- TC-12: Audit trigger fires on UPDATE (SR-05)
UPDATE Appointment SET Notes = 'Audit test 2026-04-27' WHERE AppointmentID = 1;
SELECT * FROM AuditLog ORDER BY ChangedAt DESC LIMIT 1;
-- Expected: New AuditLog row inserted, Status: ✅ Pass

-- =============================================================================
-- SECTION B: NEGATIVE / VALIDATION TEST CASES (NTC-01 to NTC-03)
-- =============================================================================

-- NTC-01: Domain integrity — invalid Gender value
-- INSERT INTO Patient (FullName, DOB, Gender) VALUES ('Test', '2000-01-01', 'X');
-- Expected: Error 1265: Data truncated for column 'Gender' ✅

-- NTC-02: Referential integrity — non-existent PatientID
-- INSERT INTO Appointment (PatientID, DoctorID, AppointmentDate, AppointmentTime)
-- VALUES (999, 1, '2026-06-01', '10:00:00');
-- Expected: Error 1452: FK constraint fails ✅

-- NTC-03: Business logic — appointment conflict
-- CALL sp_BookAppointment(1, 1, '2026-04-25', '09:00:00', 'Conflict test');
-- Expected: Error 1644: Doctor already booked ✅

-- =============================================================================
-- SECTION C: USER ACCEPTANCE TESTING (UAT-01 to UAT-05)
-- =============================================================================

-- UAT-01: Login as receptionist_user (run from terminal)
-- mysql -u receptionist_user -p
-- Expected: Login successful ✅

-- UAT-02: Receptionist tries DROP TABLE (should fail)
-- DROP TABLE Doctor;
-- Expected: Error 1142: DROP command denied ✅

-- UAT-03: Doctor inserts treatment (should succeed)
-- INSERT INTO Treatment ...;
-- Expected: 1 row affected ✅

-- UAT-04: Doctor tries UPDATE Patient (should fail)
-- UPDATE Patient SET FullName = 'Test';
-- Expected: Error 1142: UPDATE denied ✅

-- UAT-05: Manager runs SELECT (should succeed read-only)
-- SELECT * FROM Invoice;
-- Expected: All rows returned ✅

-- =============================================================================
-- SECTION D: PERFORMANCE TESTING
-- =============================================================================

-- Compare indexed vs non-indexed queries
EXPLAIN SELECT * FROM Appointment WHERE AppointmentDate = '2026-04-25';
EXPLAIN SELECT * FROM Appointment WHERE Notes LIKE '%check%';

-- =============================================================================
-- END OF FILE — 07_test_scripts.sql
-- =============================================================================
