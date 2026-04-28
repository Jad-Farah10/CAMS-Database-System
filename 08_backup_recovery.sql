-- =============================================================================
-- CAMS — Backup, Recovery, and Maintenance Scripts
-- File:        08_backup_recovery.sql
-- Purpose:     Operational scripts for long-term system health
-- Audience:    Database Administrator (DBA)
-- =============================================================================

-- =============================================================================
-- SECTION A: DAILY BACKUP SCRIPT (run from shell, not MySQL)
-- =============================================================================
-- Save as: /usr/local/bin/cams_backup.sh
-- Schedule: 0 2 * * * /usr/local/bin/cams_backup.sh   (cron at 02:00 daily)
-- =============================================================================

/*
#!/bin/bash
# CAMS Daily Backup Script
# Author: [Your Name]
# Date:   April 2026

BACKUP_DIR="/var/backups/cams"
RETENTION_DAYS=30
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$BACKUP_DIR/backup.log"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Perform backup with full transactional consistency
mysqldump -u backup_user -p"$BACKUP_PASS" CAMS_DB \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --add-drop-database \
    --databases CAMS_DB \
    > "$BACKUP_DIR/cams_$TIMESTAMP.sql" 2>> "$LOG_FILE"

# Compress the backup
gzip "$BACKUP_DIR/cams_$TIMESTAMP.sql"

# Remove backups older than retention period
find "$BACKUP_DIR" -name "cams_*.sql.gz" -mtime +$RETENTION_DAYS -delete

# Log success
echo "[$(date)] Backup completed: cams_$TIMESTAMP.sql.gz" >> "$LOG_FILE"
*/

-- =============================================================================
-- SECTION B: RECOVERY PROCEDURE (run from shell)
-- =============================================================================

/*
# To recover from a specific backup:
gunzip /var/backups/cams/cams_20260427_020000.sql.gz
mysql -u root -p < /var/backups/cams/cams_20260427_020000.sql

# To verify the recovery:
mysql -u root -p -e "USE CAMS_DB; \
    SELECT TABLE_NAME, TABLE_ROWS FROM information_schema.TABLES \
    WHERE TABLE_SCHEMA='CAMS_DB';"
*/

-- =============================================================================
-- SECTION C: INDEX MAINTENANCE (run quarterly within MySQL)
-- =============================================================================

USE CAMS_DB;

-- Optimize all tables to defragment indexes after high-volume operations
OPTIMIZE TABLE Patient;
OPTIMIZE TABLE Appointment;
OPTIMIZE TABLE Treatment;
OPTIMIZE TABLE Invoice;
OPTIMIZE TABLE Doctor;
OPTIMIZE TABLE Department;
OPTIMIZE TABLE AuditLog;

-- Analyze table statistics for the query optimizer
ANALYZE TABLE Patient;
ANALYZE TABLE Appointment;
ANALYZE TABLE Treatment;
ANALYZE TABLE Invoice;

-- =============================================================================
-- SECTION D: BACKUP USER PRIVILEGES (run once during setup)
-- =============================================================================

-- Create dedicated backup user with minimum privileges
CREATE USER IF NOT EXISTS 'backup_user'@'localhost' 
    IDENTIFIED BY 'BackupSecure@2026';

GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER 
    ON CAMS_DB.* TO 'backup_user'@'localhost';

GRANT PROCESS, REPLICATION CLIENT 
    ON *.* TO 'backup_user'@'localhost';

FLUSH PRIVILEGES;

-- =============================================================================
-- SECTION E: HEALTH-CHECK QUERIES (run daily)
-- =============================================================================

-- Check 1: Overall database health
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    DATA_LENGTH / 1024 / 1024 AS DataSizeMB,
    INDEX_LENGTH / 1024 / 1024 AS IndexSizeMB,
    UPDATE_TIME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'CAMS_DB'
ORDER BY TABLE_ROWS DESC;

-- Check 2: Identify any orphan records (FK violations that bypassed validation)
SELECT 'Orphan Appointments' AS Issue, COUNT(*) AS Count
FROM Appointment A
LEFT JOIN Patient P ON A.PatientID = P.PatientID
WHERE P.PatientID IS NULL
UNION ALL
SELECT 'Orphan Invoices', COUNT(*)
FROM Invoice I
LEFT JOIN Treatment T ON I.TreatmentID = T.TreatmentID
WHERE T.TreatmentID IS NULL;

-- Check 3: AuditLog growth (for archival decisions)
SELECT 
    DATE(ChangedAt) AS Day,
    COUNT(*) AS Operations
FROM AuditLog
WHERE ChangedAt >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY DATE(ChangedAt)
ORDER BY Day DESC;

-- =============================================================================
-- END OF FILE — 08_backup_recovery.sql
-- =============================================================================
