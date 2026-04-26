# 🏥 CAMS — MediCare Plus Clinic Appointment Management System

[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-Academic-green.svg)](#)
[![Module](https://img.shields.io/badge/Module-Database%20Design%20%26%20Development-orange.svg)](#)
[![Grade Target](https://img.shields.io/badge/Target-Distinction-red.svg)](#)

A fully-functional relational database system designed and developed for **MediCare Plus Clinic**, a medium-sized outpatient clinic in Sharjah, UAE. The system replaces fragmented paper records and Excel spreadsheets with a centralised, normalised, and secure MySQL database that supports patient registration, doctor scheduling, appointment booking, treatment recording, invoicing, and management reporting.

> **Academic Context:** This project is the end-of-semester deliverable for **Unit 4 — Database Design and Development** within the Pearson BTEC HND (Cybersecurity) curriculum.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [System Architecture](#-system-architecture)
- [Repository Structure](#-repository-structure)
- [Database Schema](#-database-schema)
- [Installation & Setup](#-installation--setup)
- [SQL Files](#-sql-files)
- [Key Features](#-key-features)
- [Screenshots](#-screenshots)
- [Documentation](#-documentation)
- [Author](#-author)
- [References](#-references)

---

## 🎯 Project Overview

The **CAMS** database addresses five recurring problems identified at MediCare Plus Clinic:

| # | Problem | CAMS Solution |
|---|---------|---------------|
| 1 | Duplicate patient records | UNIQUE constraint on `Patient.Phone` + central database |
| 2 | Inconsistent data values | ENUM types + foreign keys enforce referential integrity |
| 3 | Limited reporting capability | Pre-built views (`vw_DailyAppointments`, `vw_MonthlyRevenueByDept`) |
| 4 | Poor data security | Role-based access (Receptionist / Doctor / Manager) |
| 5 | Slow retrieval | Indexed columns on `AppointmentDate`, `Phone`, `PaymentStatus` |

---

## 🏗 System Architecture

The CAMS database consists of **six interrelated tables**, normalised up to **Third Normal Form (3NF)**:

```
Department (1) ──── (∞) Doctor (1) ──── (∞) Appointment (1) ──── (1) Treatment (1) ──── (1) Invoice
                                                  ▲                                          ▲
                                                  │                                          │
                                              Patient (1) ──────────────────── (∞)──────────┘
```

**Engine:** InnoDB (ACID-compliant + Foreign Key support)
**Charset:** utf8mb4 (Arabic + English)

---

## 📁 Repository Structure

```
CAMS-Database-System/
├── README.md                       ← You are here
├── LICENSE
├── .gitignore
│
├── sql/                            ← All SQL scripts (run in order)
│   ├── 01_create_schema.sql        ← DDL: database + 6 tables + audit log
│   ├── 02_insert_sample_data.sql   ← DML: realistic test data
│   ├── 03_users_and_privileges.sql ← Role-based access control (3 users)
│   ├── 04_queries.sql              ← 7 demonstration queries
│   ├── 05_procedures_triggers.sql  ← Stored procedures + audit triggers
│   └── 06_views.sql                ← 3 reusable views for reporting
│
├── docs/                           ← Project documentation
│   ├── ERD.md                      ← Entity Relationship Diagram explained
│   └── Test-Plan.md                ← Test cases and results (Task 3)
│
└── screenshots/                    ← Workbench & output screenshots
    ├── 01_tables_populated.png
    ├── 02_patient_form.png
    ├── 03_daily_report.png
    └── 04_monthly_dashboard.png
```

---

## 🗂 Database Schema

### Entity Summary

| Entity | Records | Primary Key | Foreign Keys |
|--------|---------|-------------|--------------|
| **Department** | 3 | DepartmentID | — |
| **Doctor** | 4 | DoctorID | DepartmentID → Department |
| **Patient** | 5 | PatientID | — |
| **Appointment** | 6 | AppointmentID | PatientID, DoctorID |
| **Treatment** | 3 | TreatmentID | AppointmentID (UNIQUE) |
| **Invoice** | 3 | InvoiceID | PatientID, TreatmentID |
| **AuditLog** | dynamic | LogID | — |

### Cardinalities

| Relationship | Cardinality |
|--------------|-------------|
| Department → Doctor | 1 : N |
| Doctor → Appointment | 1 : N |
| Patient → Appointment | 1 : N |
| Appointment → Treatment | 1 : 1 |
| Treatment → Invoice | 1 : 1 |
| Patient → Invoice | 1 : N |

---

## ⚙️ Installation & Setup

### Prerequisites
- **MySQL Server 8.0+**
- **MySQL Workbench 8.0** (recommended) or any SQL client
- ~50 MB free disk space

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/CAMS-Database-System.git
cd CAMS-Database-System

# 2. Connect to MySQL as root
mysql -u root -p

# 3. Execute scripts in order
SOURCE sql/01_create_schema.sql;
SOURCE sql/02_insert_sample_data.sql;
SOURCE sql/03_users_and_privileges.sql;
SOURCE sql/05_procedures_triggers.sql;
SOURCE sql/06_views.sql;

# 4. Test queries
SOURCE sql/04_queries.sql;
```

### Verification

After setup, run:
```sql
USE CAMS_DB;
SHOW TABLES;
SELECT * FROM vw_DailyAppointments WHERE AppointmentDate = '2026-04-25';
```

You should see the 6 main tables + `AuditLog` and the 3 views.

---

## 📜 SQL Files

| File | Lines | Description |
|------|-------|-------------|
| [`01_create_schema.sql`](sql/01_create_schema.sql) | ~120 | Creates `CAMS_DB` and all 7 tables with PK/FK/CHECK constraints |
| [`02_insert_sample_data.sql`](sql/02_insert_sample_data.sql) | ~70 | Inserts realistic sample data covering edge cases |
| [`03_users_and_privileges.sql`](sql/03_users_and_privileges.sql) | ~70 | Creates 3 role-based MySQL users with granular GRANT statements |
| [`04_queries.sql`](sql/04_queries.sql) | ~120 | Demonstrates SELECT, JOIN, GROUP BY, HAVING, sub-queries, ranking |
| [`05_procedures_triggers.sql`](sql/05_procedures_triggers.sql) | ~120 | Stored procedures (`sp_BookAppointment`, `sp_GenerateInvoice`) + audit triggers |
| [`06_views.sql`](sql/06_views.sql) | ~80 | Reusable views for daily reports & monthly dashboards |

---

## ✨ Key Features

### 🔒 Data Integrity
- ✅ Primary keys on every entity
- ✅ Foreign keys with `ON UPDATE CASCADE / ON DELETE RESTRICT`
- ✅ CHECK constraints (`Cost >= 0`, `TotalAmount >= 0`)
- ✅ ENUM types for `Gender`, `Status`, `PaymentStatus`
- ✅ UNIQUE constraint on `Patient.Phone`

### 🛡 Security
- ✅ Role-based access control (RBAC) for 3 user roles
- ✅ Strong password policy (`Recep@2026`, `Doc@2026`, `Mgr@2026`)
- ✅ Audit logging via triggers — tracks every UPDATE/DELETE on appointments
- ✅ No `GRANT ALL` — principle of least privilege applied

### ⚡ Performance
- ✅ Indexes on `AppointmentDate`, `Phone`, `PaymentStatus`
- ✅ InnoDB engine for transactional consistency
- ✅ Views pre-compute reporting joins

### 🧠 Advanced Features
- ✅ Stored procedures with conflict detection (`sp_BookAppointment`)
- ✅ Auto-invoice generation (`sp_GenerateInvoice`)
- ✅ Audit trail (`AuditLog` table + triggers)

---

## 📸 Screenshots

> Screenshots are stored in the `screenshots/` folder and referenced inside the academic report.

| File | Description |
|------|-------------|
| `01_tables_populated.png` | MySQL Workbench schema view confirming all tables created |
| `02_patient_form.png` | Implemented Patient Registration form |
| `03_daily_report.png` | Generated Daily Appointment Report |
| `04_monthly_dashboard.png` | Generated Monthly Revenue Dashboard |

---

## 📚 Documentation

- **[ERD Diagram](docs/ERD.md)** — Visual schema representation in Crow's Foot notation
- **[Test Plan](docs/Test-Plan.md)** — Comprehensive test cases and results (Task 3 deliverable)

---

## 👤 Author

**Jad George Farah**
*Second-year HND Cybersecurity student*
Pearson BTEC HND — Unit 4: Database Design and Development
Submission: May 2026

---

## 📖 References

- Churcher, C. (2012) *Beginning Database Design: From Novice to Professional*. 2nd edn. Apress.
- Connolly, T. and Begg, C. (2014) *Database Systems: A Practical Approach to Design, Implementation and Management*. 6th edn. Pearson.
- Kroemke, D. and Auer, D. (2012) *Database Concepts: International Edition*. 6th edn. Pearson.

---

## 📄 License

This project is for **academic purposes only** as part of the Pearson BTEC HND curriculum. Not licensed for commercial use.

---

⭐ **If you found this project helpful for your own studies, please consider giving it a star!**
