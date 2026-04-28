# 👥 CAMS — User Manual

**Version:** 1.0
**Date:** April 2026
**Audience:** Receptionists, Doctors, Clinic Managers
**System:** MediCare Plus Clinic Appointment Management System

> *Welcome to CAMS! This manual is written for everyday users with basic computer skills. No technical background is needed.*

---

## 📋 Table of Contents

1. [Logging In](#1-logging-in)
2. [Registering a New Patient](#2-registering-a-new-patient)
3. [Booking an Appointment](#3-booking-an-appointment)
4. [Recording a Treatment](#4-recording-a-treatment-doctors-only)
5. [Generating a Daily Report](#5-generating-a-daily-report)
6. [Viewing the Monthly Dashboard](#6-viewing-the-monthly-dashboard)
7. [FAQ & Common Issues](#7-faq--common-issues)

---

## 1. Logging In

### Step-by-Step
1. Open the CAMS application from your desktop shortcut.
2. On the **Login** screen, enter your **Username** and **Password**.
3. Select your **Role** from the dropdown:
   - **Receptionist** — for registering patients & booking
   - **Doctor** — for recording treatments
   - **Manager** — for viewing reports
4. Click **🔐 LOG IN**.

### Forgot Password?
Click *"Forgot your password?"* and follow the email instructions.

> 📌 **Tip:** Use "Remember me on this device" only on private computers, never on shared workstations.

---

## 2. Registering a New Patient

> *Used by: Receptionist (UR-01)*

### Step-by-Step
1. From the home screen, click **"+ New Patient"**.
2. The **Patient Registration** form opens.
3. Fill in the following:
   - **Full Name** (required)
   - **Date of Birth** (use the calendar icon 📅)
   - **Gender** (Male / Female)
   - **Phone** (UAE format: 05X-XXX-XXXX)
   - **Email** (optional)
   - **Address**
4. The **Registration Date** is automatically filled in.
5. Click **💾 SAVE**.

### What Happens Next
A confirmation message appears: *"Patient registered successfully. ID: [number]"*. Make a note of the new Patient ID for the patient's reference card.

### ⚠️ Common Errors
- **"Phone already registered"** → This phone is in use; verify with the patient or use the existing record.
- **"Required field missing"** → Re-check fields marked with an asterisk (*).

---

## 3. Booking an Appointment

> *Used by: Receptionist (UR-02)*

### Step-by-Step
1. From the home screen, click **"📅 Book Appointment"**.
2. **Select the Patient:** Type the patient name or ID; the autocomplete will help you find the right person.
3. **Select the Doctor:**
   - Choose the **Department** first (e.g., General Medicine)
   - Then select a **Doctor** from the filtered list
4. **Choose Date & Time:**
   - Click the date picker 📅
   - Pick a **Time** from the dropdown (only available slots are shown)
5. **Add Notes** (optional — e.g., *"Routine check-up"*).
6. Click **✓ CONFIRM BOOKING**.

### What Happens Next
The system checks if the doctor is available at that time. If yes, the appointment is saved and a confirmation appears.

### ⚠️ Common Errors
- **"Doctor is already booked at this time slot"** → Choose a different time or doctor.

---

## 4. Recording a Treatment (Doctors only)

> *Used by: Doctor (UR-03)*

### Step-by-Step
1. From your home screen, find the **patient's appointment** in the list.
2. Click **"Record Treatment"** on that row.
3. Fill in:
   - **Diagnosis** (text)
   - **Prescription** (text)
   - **Cost** (in AED)
4. Click **💾 SAVE TREATMENT**.

### What Happens Next
- The appointment status automatically changes to **Completed**.
- An invoice is automatically generated (you'll see the InvoiceID).

---

## 5. Generating a Daily Report

> *Used by: Receptionist & Manager (UR-04)*

### Step-by-Step
1. From the home screen, go to **"📋 Reports"** → **"Daily Appointments"**.
2. Use the **Filter Bar** to narrow results:
   - **Date** (default: today)
   - **Department** (or "All")
   - **Doctor** (or "All")
   - **Status** (or "All")
3. Click **🔎 APPLY**.
4. The list displays all matching appointments with KPI cards at the top.

### Exporting
- Click **📥 EXCEL** to download as `.xlsx`
- Click **📄 PDF** to download as `.pdf`

---

## 6. Viewing the Monthly Dashboard

> *Used by: Manager (UR-04)*

### Step-by-Step
1. From the home screen, go to **"📊 Reports"** → **"Monthly Dashboard"**.
2. The dashboard displays:
   - **4 KPI cards** (Total Revenue, Paid, Unpaid, Patients)
   - **Bar chart** of revenue by department
   - **Donut chart** of payment status distribution
   - **Top performing doctors** ranked by revenue
3. Use the period selector at the top to change month.

---

## 7. FAQ & Common Issues

### Q: I cannot log in.
A: Verify Caps Lock is off; ensure you selected the correct role; contact your IT admin if the problem persists.

### Q: A patient record disappeared!
A: Patient records cannot be deleted by users. Try searching by phone or full name. If still missing, the audit log can recover deleted records — contact the DBA.

### Q: Why does the doctor list keep refreshing?
A: The list is filtered by department. If you change the department, the doctor list updates automatically — this is by design.

### Q: I made a typo. Can I edit?
A: Yes. Find the record in the list view and click **"Edit"** (pencil icon ✏️). All edits are tracked in the AuditLog automatically.

### Q: Reports are slow to generate.
A: Reports for date ranges over 90 days may take a few seconds. Use narrower date ranges for faster results.

---

## 📞 Need More Help?

- **In-app help:** Press `F1` on any screen for context help.
- **Phone support:** ext. 1010 (during clinic hours)
- **Email:** support@medicareplus.ae

---

*Thank you for using CAMS! Your feedback helps us improve.* 💙
