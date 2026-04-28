# 📘 CAMS — Technical Manual

**Version:** 1.0
**Date:** April 2026
**Audience:** Database Administrators, System Developers
**System:** MediCare Plus Clinic Appointment Management System

---

## 📋 Table of Contents

1. [System Overview](#1-system-overview)
2. [Architecture](#2-architecture)
3. [Schema Reference](#3-schema-reference)
4. [Stored Procedures Reference](#4-stored-procedures-reference)
5. [Triggers Reference](#5-triggers-reference)
6. [Views Reference](#6-views-reference)
7. [Security Model](#7-security-model)
8. [Backup & Recovery](#8-backup--recovery)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. System Overview

CAMS is a **MySQL 8.0** relational database supporting the operational and reporting needs of MediCare Plus Clinic. It manages six core entities (Department, Doctor, Patient, Appointment, Treatment, Invoice) plus an `AuditLog` table for change tracking.

| Property | Value |
|---|---|
| **DBMS** | MySQL Community Server 8.0.46 |
| **Engine** | InnoDB |
| **Charset** | utf8mb4 (Arabic + English) |
| **Tables** | 7 |
| **Views** | 3 |
| **Stored Procedures** | 2 |
| **Triggers** | 2 |

---

## 2. Architecture

```
┌────────────────┐       ┌─────────────────┐       ┌──────────────┐
│  Application   │ ─SQL─ │  MySQL Server   │ ───── │   Storage    │
│  Layer (UI)    │       │   (CAMS_DB)     │       │   (InnoDB)   │
└────────────────┘       └─────────────────┘       └──────────────┘
        ▲                         ▲
        │                         │
   3 user roles            Stored Procedures
   (Receptionist,          + Triggers
    Doctor, Manager)       (Server-side logic)
```

---

## 3. Schema Reference

See [`docs/ERD.md`](ERD.md) for visual schema, or [`sql/01_create_schema.sql`](../sql/01_create_schema.sql) for the complete DDL.

---

## 4. Stored Procedures Reference

### `sp_BookAppointment`
**Purpose:** Atomic appointment booking with conflict detection
**Parameters:** `(IN p_PatientID INT, IN p_DoctorID INT, IN p_Date DATE, IN p_Time TIME, IN p_Notes TEXT)`
**Errors:** Raises `SQLSTATE '45000'` (Error 1644) if conflict detected
**Example:**
```sql
CALL sp_BookAppointment(2, 3, '2026-05-05', '15:00:00', 'Vaccination');
```

### `sp_GenerateInvoice`
**Purpose:** Auto-generate an invoice from a completed treatment
**Parameters:** `(IN p_TreatmentID INT)`
**Example:**
```sql
CALL sp_GenerateInvoice(4);
```

---

## 5. Triggers Reference

### `trg_AuditAppointmentUpdate`
**Fires:** AFTER UPDATE on Appointment
**Action:** Inserts a record into `AuditLog`

### `trg_AuditAppointmentDelete`
**Fires:** AFTER DELETE on Appointment
**Action:** Inserts a record into `AuditLog`

---

## 6. Views Reference

| View | Purpose |
|---|---|
| `vw_DailyAppointments` | Powers the Daily Appointment Report |
| `vw_MonthlyRevenueByDept` | Powers the Monthly Revenue Dashboard |
| `vw_TopPerformingDoctors` | Doctor ranking analytics |

---

## 7. Security Model

Three role-based MySQL users defined in [`sql/03_users_and_privileges.sql`](../sql/03_users_and_privileges.sql):

| User | Role | Privileges |
|---|---|---|
| `receptionist_user` | Receptionist | INSERT/UPDATE on Patient & Appointment |
| `doctor_user` | Doctor | INSERT/UPDATE on Treatment, SELECT others |
| `manager_user` | Manager | SELECT only (entire DB) |

---

## 8. Backup & Recovery

See [`sql/08_backup_recovery.sql`](../sql/08_backup_recovery.sql) for full operational scripts.

**Schedule:** Daily at 02:00 via cron, 30-day retention.
**Recovery RTO target:** < 1 hour.

---

## 9. Troubleshooting

| Issue | Likely Cause | Resolution |
|---|---|---|
| `Error 1452: FK constraint fails` | Inserting child without parent | Verify PK exists in parent table |
| `Error 1644: Doctor already booked` | Slot conflict in `sp_BookAppointment` | Choose different time slot |
| `Error 1142: Command denied` | User lacks privilege | Use `manager_user` for read-only operations |
| Slow queries on Appointment | Missing index utilization | Run `EXPLAIN`; ensure `idx_appt_date` exists |

---

## 📞 Support Contact

- **DBA Email:** dba@medicareplus.ae
- **Issue Tracker:** [GitHub Issues](https://github.com/[your-username]/CAMS-Database-System/issues)
