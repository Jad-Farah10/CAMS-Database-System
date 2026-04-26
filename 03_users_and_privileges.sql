-- =============================================================================
-- CAMS — User Accounts & Role-Based Access Control
-- File:        03_users_and_privileges.sql
-- Purpose:     Create three role-based users with granular GRANT privileges
-- Run after:   01_create_schema.sql
-- =============================================================================

USE CAMS_DB;

-- -----------------------------------------------------------------------------
-- ROLE 1: Receptionist
-- Permissions: Manage patients & appointments, read-only on doctors/departments
-- -----------------------------------------------------------------------------
DROP USER IF EXISTS 'receptionist_user'@'localhost';
CREATE USER 'receptionist_user'@'localhost' IDENTIFIED BY 'Recep@2026';

GRANT SELECT, INSERT, UPDATE
    ON CAMS_DB.Patient
    TO 'receptionist_user'@'localhost';

GRANT SELECT, INSERT, UPDATE
    ON CAMS_DB.Appointment
    TO 'receptionist_user'@'localhost';

GRANT SELECT
    ON CAMS_DB.Doctor
    TO 'receptionist_user'@'localhost';

GRANT SELECT
    ON CAMS_DB.Department
    TO 'receptionist_user'@'localhost';

-- -----------------------------------------------------------------------------
-- ROLE 2: Doctor
-- Permissions: Read patient/appointment data, write treatments
-- -----------------------------------------------------------------------------
DROP USER IF EXISTS 'doctor_user'@'localhost';
CREATE USER 'doctor_user'@'localhost' IDENTIFIED BY 'Doc@2026';

GRANT SELECT
    ON CAMS_DB.Patient
    TO 'doctor_user'@'localhost';

GRANT SELECT
    ON CAMS_DB.Appointment
    TO 'doctor_user'@'localhost';

GRANT SELECT, INSERT, UPDATE
    ON CAMS_DB.Treatment
    TO 'doctor_user'@'localhost';

-- -----------------------------------------------------------------------------
-- ROLE 3: Manager
-- Permissions: Read-only on entire database (for reporting)
-- -----------------------------------------------------------------------------
DROP USER IF EXISTS 'manager_user'@'localhost';
CREATE USER 'manager_user'@'localhost' IDENTIFIED BY 'Mgr@2026';

GRANT SELECT ON CAMS_DB.* TO 'manager_user'@'localhost';

-- -----------------------------------------------------------------------------
-- Apply privileges immediately
-- -----------------------------------------------------------------------------
FLUSH PRIVILEGES;

-- =============================================================================
-- VERIFICATION: Show grants for each user
-- =============================================================================
SHOW GRANTS FOR 'receptionist_user'@'localhost';
SHOW GRANTS FOR 'doctor_user'@'localhost';
SHOW GRANTS FOR 'manager_user'@'localhost';

-- =============================================================================
-- END OF FILE — 03_users_and_privileges.sql
-- =============================================================================
