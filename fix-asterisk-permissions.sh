#!/bin/bash

echo "===== Fixing Asterisk Permissions ====="

# --- Fix ASTERISK DB (CRITICAL) ---
echo "Fixing /var/lib/asterisk (astdb + runtime data)..."

chown -R asterisk:asterisk /var/lib/asterisk
chmod -R 775 /var/lib/asterisk

# Ensure astdb file has correct permissions
if [ -f /var/lib/asterisk/astdb.sqlite3 ]; then
    chmod 664 /var/lib/asterisk/astdb.sqlite3
    chown asterisk:asterisk /var/lib/asterisk/astdb.sqlite3
fi

# --- Fix LOGGING (CDR etc) ---
echo "Fixing /var/log/asterisk (logs + CDR)..."

mkdir -p /var/log/asterisk
mkdir -p /var/log/asterisk/cdr-csv

chown -R asterisk:asterisk /var/log/asterisk
chmod -R 775 /var/log/asterisk

# --- Optional: Fix spool (good practice) ---
echo "Fixing /var/spool/asterisk..."

mkdir -p /var/spool/asterisk
chown -R asterisk:asterisk /var/spool/asterisk
chmod -R 775 /var/spool/asterisk

# --- Show final permissions (debug) ---
echo "===== Verification ====="

ls -ld /var/lib/asterisk
ls -l /var/lib/asterisk/astdb.sqlite3 2>/dev/null
ls -ld /var/log/asterisk
ls -ld /var/log/asterisk/cdr-csv

echo "===== Permissions Fix Complete ====="

# --- Start Asterisk (for container use) ---
exec /usr/sbin/asterisk -vvvdddf -T -W -U asterisk -p