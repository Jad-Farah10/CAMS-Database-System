-- =============================================================================
-- CAMS — Stored Procedures & Triggers
-- File:        05_procedures_triggers.sql
-- Purpose:     Encapsulate business logic (booking, invoicing) and provide
--              automatic audit logging via triggers
-- Run after:   01_create_schema.sql + 02_insert_sample_data.sql
-- =============================================================================

USE CAMS_DB;

-- =============================================================================
-- STORED PROCEDURE 1: sp_BookAppointment
-- Purpose: Atomic appointment creation with conflict detection
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_BookAppointment;

DELIMITER $$

CREATE PROCEDURE sp_BookAppointment(
    IN p_PatientID INT,
    IN p_DoctorID  INT,
    IN p_Date      DATE,
    IN p_Time      TIME,
    IN p_Notes     TEXT
)
BEGIN
    DECLARE conflict_count INT DEFAULT 0;

    -- Check if the doctor is already booked at this slot
    SELECT COUNT(*) INTO conflict_count
    FROM Appointment
    WHERE DoctorID         = p_DoctorID
      AND AppointmentDate  = p_Date
      AND AppointmentTime  = p_Time
      AND Status           <> 'Cancelled';

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ERROR: Doctor is already booked at this time slot.';
    ELSE
        INSERT INTO Appointment (
            PatientID, DoctorID, AppointmentDate,
            AppointmentTime, Status, Notes
        )
        VALUES (
            p_PatientID, p_DoctorID, p_Date,
            p_Time, 'Scheduled', p_Notes
        );
    END IF;
END$$

DELIMITER ;

-- =============================================================================
-- STORED PROCEDURE 2: sp_GenerateInvoice
-- Purpose: Auto-create an invoice when a treatment is recorded
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_GenerateInvoice;

DELIMITER $$

CREATE PROCEDURE sp_GenerateInvoice(
    IN p_TreatmentID INT
)
BEGIN
    DECLARE v_PatientID INT;
    DECLARE v_Cost      DECIMAL(8,2);

    -- Retrieve patient and cost from treatment + appointment
    SELECT A.PatientID, T.Cost
        INTO v_PatientID, v_Cost
    FROM Treatment T
    JOIN Appointment A ON T.AppointmentID = A.AppointmentID
    WHERE T.TreatmentID = p_TreatmentID;

    -- Insert invoice
    INSERT INTO Invoice (
        PatientID, TreatmentID, TotalAmount, PaymentStatus
    )
    VALUES (
        v_PatientID, p_TreatmentID, v_Cost, 'Unpaid'
    );
END$$

DELIMITER ;

-- =============================================================================
-- TRIGGER: trg_AuditAppointmentChanges
-- Purpose: Automatically log every UPDATE on Appointment table
-- =============================================================================
DROP TRIGGER IF EXISTS trg_AuditAppointmentUpdate;
DROP TRIGGER IF EXISTS trg_AuditAppointmentDelete;

DELIMITER $$

CREATE TRIGGER trg_AuditAppointmentUpdate
AFTER UPDATE ON Appointment
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (TableName, Action, RecordID, ChangedBy)
    VALUES ('Appointment', 'UPDATE', OLD.AppointmentID, CURRENT_USER());
END$$

CREATE TRIGGER trg_AuditAppointmentDelete
AFTER DELETE ON Appointment
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (TableName, Action, RecordID, ChangedBy)
    VALUES ('Appointment', 'DELETE', OLD.AppointmentID, CURRENT_USER());
END$$

DELIMITER ;

-- =============================================================================
-- TEST: Verify procedures and triggers work
-- =============================================================================
-- Test 1: Try to book a slot that conflicts (should fail)
-- CALL sp_BookAppointment(1, 1, '2026-04-25', '09:00:00', 'Test conflict');

-- Test 2: Book a valid new appointment
-- CALL sp_BookAppointment(2, 3, '2026-04-26', '10:30:00', 'New booking test');

-- Test 3: Update an appointment to trigger audit
-- UPDATE Appointment SET Notes = 'Updated note' WHERE AppointmentID = 1;
-- SELECT * FROM AuditLog ORDER BY ChangedAt DESC LIMIT 5;

-- =============================================================================
-- END OF FILE — 05_procedures_triggers.sql
-- =============================================================================
