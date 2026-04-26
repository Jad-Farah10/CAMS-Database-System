-- =============================================================================
-- CAMS — SQL Views for Reporting
-- File:        06_views.sql
-- Purpose:     Encapsulate complex reporting logic into reusable views
-- Run after:   01_create_schema.sql + 02_insert_sample_data.sql
-- =============================================================================

USE CAMS_DB;

-- =============================================================================
-- VIEW 1: vw_DailyAppointments
-- Purpose: Powers the Daily Appointment Report (Figure 1.3a / Figure 2.3)
-- =============================================================================
CREATE OR REPLACE VIEW vw_DailyAppointments AS
SELECT
    A.AppointmentID,
    A.AppointmentDate,
    A.AppointmentTime,
    P.FullName  AS PatientName,
    P.Phone     AS PatientPhone,
    D.FullName  AS DoctorName,
    Dp.DeptName AS Department,
    A.Status,
    A.Notes
FROM Appointment A
JOIN Patient    P  ON A.PatientID    = P.PatientID
JOIN Doctor     D  ON A.DoctorID     = D.DoctorID
JOIN Department Dp ON D.DepartmentID = Dp.DepartmentID;

-- =============================================================================
-- VIEW 2: vw_MonthlyRevenueByDept
-- Purpose: Powers the Monthly Revenue Dashboard (Figure 1.3b / Figure 2.4)
-- =============================================================================
CREATE OR REPLACE VIEW vw_MonthlyRevenueByDept AS
SELECT
    Dp.DeptName,
    DATE_FORMAT(I.IssueDate, '%Y-%m')   AS Month,
    COUNT(I.InvoiceID)                  AS InvoiceCount,
    SUM(I.TotalAmount)                  AS TotalRevenue,
    SUM(CASE
        WHEN I.PaymentStatus = 'Paid' THEN I.TotalAmount
        ELSE 0
    END)                                AS PaidRevenue,
    SUM(CASE
        WHEN I.PaymentStatus = 'Unpaid' THEN I.TotalAmount
        ELSE 0
    END)                                AS UnpaidRevenue
FROM Invoice I
JOIN Treatment   T  ON I.TreatmentID   = T.TreatmentID
JOIN Appointment A  ON T.AppointmentID = A.AppointmentID
JOIN Doctor      D  ON A.DoctorID      = D.DoctorID
JOIN Department  Dp ON D.DepartmentID  = Dp.DepartmentID
GROUP BY Dp.DeptName, Month;

-- =============================================================================
-- VIEW 3: vw_TopPerformingDoctors
-- Purpose: Powers the doctor ranking section of the dashboard
-- =============================================================================
CREATE OR REPLACE VIEW vw_TopPerformingDoctors AS
SELECT
    D.DoctorID,
    D.FullName             AS DoctorName,
    Dp.DeptName            AS Department,
    COUNT(A.AppointmentID) AS TotalAppointments,
    COALESCE(SUM(I.TotalAmount), 0) AS TotalRevenue,
    COALESCE(AVG(I.TotalAmount), 0) AS AvgPerVisit
FROM Doctor D
JOIN Department Dp ON D.DepartmentID = Dp.DepartmentID
LEFT JOIN Appointment A ON D.DoctorID = A.DoctorID
LEFT JOIN Treatment   T ON A.AppointmentID = T.AppointmentID
LEFT JOIN Invoice     I ON T.TreatmentID = I.TreatmentID
GROUP BY D.DoctorID, D.FullName, Dp.DeptName
ORDER BY TotalRevenue DESC;

-- =============================================================================
-- USAGE EXAMPLES
-- =============================================================================
-- View today's appointments
-- SELECT * FROM vw_DailyAppointments WHERE AppointmentDate = CURRENT_DATE;

-- Monthly revenue summary
-- SELECT * FROM vw_MonthlyRevenueByDept ORDER BY Month DESC, TotalRevenue DESC;

-- Top 5 doctors
-- SELECT * FROM vw_TopPerformingDoctors LIMIT 5;

-- =============================================================================
-- END OF FILE — 06_views.sql
-- =============================================================================
