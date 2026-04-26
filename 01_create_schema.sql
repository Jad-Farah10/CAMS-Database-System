-- =============================================================================
-- CAMS — MediCare Plus Clinic Appointment Management System
-- File:        01_create_schema.sql
-- Purpose:     Data Definition Language (DDL) — creates database & 6 tables
-- Author:      [Your Name]
-- Module:      Pearson BTEC HND — Database Design and Development (Unit 4)
-- Version:     1.0
-- Date:        April 2026
-- Engine:      MySQL 8.0 / InnoDB / utf8mb4
-- =============================================================================

-- Drop existing database if present (clean slate for re-runs)
DROP DATABASE IF EXISTS CAMS_DB;

-- Create the CAMS database with UTF-8 support for Arabic + English data
CREATE DATABASE CAMS_DB
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE CAMS_DB;

-- -----------------------------------------------------------------------------
-- TABLE 1: Department
-- -----------------------------------------------------------------------------
CREATE TABLE Department (
    DepartmentID  INT AUTO_INCREMENT PRIMARY KEY,
    DeptName      VARCHAR(50)  NOT NULL UNIQUE,
    Location      VARCHAR(100)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- TABLE 2: Doctor
-- -----------------------------------------------------------------------------
CREATE TABLE Doctor (
    DoctorID        INT AUTO_INCREMENT PRIMARY KEY,
    FullName        VARCHAR(100) NOT NULL,
    Specialization  VARCHAR(80)  NOT NULL,
    Phone           VARCHAR(15),
    Email           VARCHAR(100),
    DepartmentID    INT NOT NULL,
    CONSTRAINT fk_doctor_dept
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- TABLE 3: Patient
-- -----------------------------------------------------------------------------
CREATE TABLE Patient (
    PatientID         INT AUTO_INCREMENT PRIMARY KEY,
    FullName          VARCHAR(100) NOT NULL,
    DOB               DATE         NOT NULL,
    Gender            ENUM('M','F') NOT NULL,
    Phone             VARCHAR(15)  UNIQUE,
    Email             VARCHAR(100),
    Address           VARCHAR(200),
    RegistrationDate  DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- TABLE 4: Appointment
-- -----------------------------------------------------------------------------
CREATE TABLE Appointment (
    AppointmentID    INT AUTO_INCREMENT PRIMARY KEY,
    PatientID        INT  NOT NULL,
    DoctorID         INT  NOT NULL,
    AppointmentDate  DATE NOT NULL,
    AppointmentTime  TIME NOT NULL,
    Status           ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    Notes            TEXT,
    CONSTRAINT fk_appt_patient
        FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_appt_doctor
        FOREIGN KEY (DoctorID)  REFERENCES Doctor(DoctorID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_appt_date (AppointmentDate)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- TABLE 5: Treatment
-- -----------------------------------------------------------------------------
CREATE TABLE Treatment (
    TreatmentID    INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID  INT NOT NULL UNIQUE,
    Diagnosis      VARCHAR(255) NOT NULL,
    Prescription   TEXT,
    Cost           DECIMAL(8,2) NOT NULL CHECK (Cost >= 0),
    TreatmentDate  DATE NOT NULL,
    CONSTRAINT fk_treat_appt
        FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- TABLE 6: Invoice
-- -----------------------------------------------------------------------------
CREATE TABLE Invoice (
    InvoiceID      INT AUTO_INCREMENT PRIMARY KEY,
    PatientID      INT NOT NULL,
    TreatmentID    INT NOT NULL,
    TotalAmount    DECIMAL(8,2) NOT NULL CHECK (TotalAmount >= 0),
    PaymentStatus  ENUM('Paid','Unpaid','Partial') DEFAULT 'Unpaid',
    IssueDate      DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_inv_patient
        FOREIGN KEY (PatientID)   REFERENCES Patient(PatientID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_inv_treat
        FOREIGN KEY (TreatmentID) REFERENCES Treatment(TreatmentID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_inv_status (PaymentStatus)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- TABLE 7 (Audit): AuditLog — used by trigger in 05_procedures_triggers.sql
-- -----------------------------------------------------------------------------
CREATE TABLE AuditLog (
    LogID      INT AUTO_INCREMENT PRIMARY KEY,
    TableName  VARCHAR(50),
    Action     VARCHAR(20),
    RecordID   INT,
    ChangedBy  VARCHAR(50),
    ChangedAt  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =============================================================================
-- END OF FILE — 01_create_schema.sql
-- =============================================================================
