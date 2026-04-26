-- =============================================================================
-- CAMS — SQL Queries (DQL)
-- File:        04_queries.sql
-- Purpose:     Demonstration queries covering retrieval, joins, aggregation,
--              sub-queries, HAVING, and ranking
-- =============================================================================

USE CAMS_DB;

-- =============================================================================
-- Q1: Simple retrieval — list all female patients
-- =============================================================================
SELECT
    PatientID,
    FullName,
    DOB,
    Phone
FROM Patient
WHERE Gender = 'F'
ORDER BY FullName;

-- =============================================================================
-- Q2: Inner join — list today's completed appointments
-- =============================================================================
SELECT
    A.AppointmentID,
    P.FullName  AS Patient,
    D.FullName  AS Doctor,
    A.AppointmentTime,
    A.Status
FROM Appointment A
INNER JOIN Patient P ON A.PatientID = P.PatientID
INNER JOIN Doctor  D ON A.DoctorID  = D.DoctorID
WHERE A.AppointmentDate = '2026-04-25'
  AND A.Status          = 'Completed'
ORDER BY A.AppointmentTime;

-- =============================================================================
-- Q3: Aggregate with GROUP BY — total revenue per department
-- =============================================================================
SELECT
    Dp.DeptName,
    COUNT(I.InvoiceID)  AS InvoiceCount,
    SUM(I.TotalAmount)  AS Revenue,
    AVG(I.TotalAmount)  AS AvgInvoice
FROM Invoice I
JOIN Treatment   T ON I.TreatmentID  = T.TreatmentID
JOIN Appointment A ON T.AppointmentID = A.AppointmentID
JOIN Doctor      D ON A.DoctorID      = D.DoctorID
JOIN Department Dp ON D.DepartmentID  = Dp.DepartmentID
GROUP BY Dp.DeptName
ORDER BY Revenue DESC;

-- =============================================================================
-- Q4: Sub-query — patients who have spent more than the average
-- =============================================================================
SELECT
    FullName,
    TotalSpent
FROM (
    SELECT
        P.PatientID,
        P.FullName,
        SUM(I.TotalAmount) AS TotalSpent
    FROM Patient P
    JOIN Invoice I ON P.PatientID = I.PatientID
    GROUP BY P.PatientID, P.FullName
) AS T
WHERE TotalSpent > (SELECT AVG(TotalAmount) FROM Invoice)
ORDER BY TotalSpent DESC;

-- =============================================================================
-- Q5: HAVING clause — doctors with more than one appointment today
-- =============================================================================
SELECT
    D.FullName,
    COUNT(A.AppointmentID) AS ApptCount
FROM Doctor D
JOIN Appointment A ON D.DoctorID = A.DoctorID
WHERE A.AppointmentDate = '2026-04-25'
GROUP BY D.FullName
HAVING COUNT(A.AppointmentID) > 1
ORDER BY ApptCount DESC;

-- =============================================================================
-- Q6: Outstanding payments report
-- =============================================================================
SELECT
    P.FullName    AS Patient,
    I.InvoiceID,
    I.TotalAmount,
    I.IssueDate,
    DATEDIFF(CURRENT_DATE, I.IssueDate) AS DaysOutstanding
FROM Invoice I
JOIN Patient P ON I.PatientID = P.PatientID
WHERE I.PaymentStatus = 'Unpaid'
ORDER BY DaysOutstanding DESC;

-- =============================================================================
-- Q7 (BONUS): Ranking — top 5 doctors by revenue
-- =============================================================================
SELECT
    D.FullName       AS Doctor,
    Dp.DeptName      AS Department,
    COUNT(A.AppointmentID) AS Appointments,
    SUM(I.TotalAmount)     AS TotalRevenue
FROM Doctor D
JOIN Department Dp ON D.DepartmentID = Dp.DepartmentID
LEFT JOIN Appointment A ON D.DoctorID = A.DoctorID
LEFT JOIN Treatment T ON A.AppointmentID = T.AppointmentID
LEFT JOIN Invoice I ON T.TreatmentID = I.TreatmentID
GROUP BY D.FullName, Dp.DeptName
ORDER BY TotalRevenue DESC
LIMIT 5;

-- =============================================================================
-- END OF FILE — 04_queries.sql
-- =============================================================================
