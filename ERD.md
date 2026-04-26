# 🔗 Entity Relationship Diagram — CAMS Database

This document explains the conceptual data model of the CAMS database in Crow's Foot notation.

---

## 📊 ERD Overview

The CAMS schema contains **six core entities** plus an **AuditLog** table:

```
                ┌─────────────┐
                │  Department │
                │─────────────│
                │ DepartmentID│ (PK)
                │ DeptName    │
                │ Location    │
                └──────┬──────┘
                       │ 1
                       │
                       │ N
                ┌──────┴──────┐
                │   Doctor    │
                │─────────────│
                │ DoctorID    │ (PK)
                │ FullName    │
                │ Specialization│
                │ Phone, Email│
                │ DepartmentID│ (FK)
                └──────┬──────┘
                       │ 1
                       │
                       │ N
   ┌────────────┐   ┌──┴───────────┐
   │  Patient   │ N │ Appointment  │
   │────────────│───│──────────────│
   │ PatientID  │ 1 │ AppointmentID│ (PK)
   │ FullName   │   │ PatientID    │ (FK)
   │ DOB,Gender │   │ DoctorID     │ (FK)
   │ Phone,Email│   │ Date,Time    │
   │ Address    │   │ Status,Notes │
   └─────┬──────┘   └──────┬───────┘
         │                 │ 1
         │                 │
         │ 1               │ 1
         │                 │
         │             ┌───┴────────┐
         │             │ Treatment  │
         │             │────────────│
         │             │ TreatmentID│ (PK)
         │             │ AppointmentID│ (FK,UNIQUE)
         │             │ Diagnosis  │
         │             │ Cost,Date  │
         │             └─────┬──────┘
         │                   │ 1
         │ N                 │ 1
         │                   │
         └──────►┌───────────┴─┐
                 │   Invoice   │
                 │─────────────│
                 │ InvoiceID   │ (PK)
                 │ PatientID   │ (FK)
                 │ TreatmentID │ (FK)
                 │ TotalAmount │
                 │ PaymentStatus│
                 │ IssueDate   │
                 └─────────────┘
```

---

## 🔑 Cardinality Rules

| Relationship | Cardinality | Read As |
|--------------|-------------|---------|
| **Department → Doctor** | 1 : N | One department employs many doctors |
| **Doctor → Appointment** | 1 : N | One doctor conducts many appointments |
| **Patient → Appointment** | 1 : N | One patient books many appointments |
| **Appointment → Treatment** | 1 : 1 | Each appointment results in at most one treatment |
| **Treatment → Invoice** | 1 : 1 | Each treatment is billed in exactly one invoice |
| **Patient → Invoice** | 1 : N | One patient can receive many invoices over time |

---

## 📐 Normalisation

The schema is normalised to **Third Normal Form (3NF)**:

| Form | Rule | Action Taken |
|------|------|--------------|
| **1NF** | Atomic values, no repeating groups | Each row holds a single appointment |
| **2NF** | No partial dependencies | Patient/Doctor split into own tables |
| **3NF** | No transitive dependencies | DepartmentName moved out of Doctor into a Department table |

---

## 🏗 Data Types Summary

| Attribute | Type | Constraint |
|-----------|------|------------|
| `*ID` (all PKs) | INT AUTO_INCREMENT | NOT NULL |
| `FullName` | VARCHAR(100) | NOT NULL |
| `DOB`, `*Date` | DATE | NOT NULL |
| `*Time` | TIME | NOT NULL |
| `Gender` | ENUM('M','F') | NOT NULL |
| `Status` | ENUM('Scheduled','Completed','Cancelled') | DEFAULT 'Scheduled' |
| `PaymentStatus` | ENUM('Paid','Unpaid','Partial') | DEFAULT 'Unpaid' |
| `Cost`, `TotalAmount` | DECIMAL(8,2) | CHECK ≥ 0 |
| `Phone` | VARCHAR(15) | UNIQUE (Patient) |
| `Email` | VARCHAR(100) | optional |

---

## 🛡 Integrity Constraints

### Referential Integrity
- All FKs use `ON UPDATE CASCADE` (parent ID changes propagate)
- All FKs use `ON DELETE RESTRICT` (cannot delete parent if children exist)

### Domain Integrity
- ENUM types limit `Gender`, `Status`, `PaymentStatus` to valid values
- CHECK constraints enforce non-negative monetary amounts

### Entity Integrity
- All tables have a single-column `AUTO_INCREMENT` PRIMARY KEY
- `Patient.Phone` is UNIQUE to prevent duplicate registrations
- `Treatment.AppointmentID` is UNIQUE to enforce 1:1 with Appointment

---

## 📝 References

- Churcher, C. (2012) *Beginning Database Design: From Novice to Professional*. Apress, Chapter 4.
- Connolly, T. and Begg, C. (2014) *Database Systems: A Practical Approach*. 6th edn. Pearson.
