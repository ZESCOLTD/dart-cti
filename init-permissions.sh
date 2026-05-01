#!/bin/bash

echo "Fixing Asterisk permissions..."

# Fix DB + runtime
chown -R asterisk:asterisk /var/lib/asterisk
chmod -R 775 /var/lib/asterisk

# Fix logs + CDR
mkdir -p /var/log/asterisk/cdr-csv
chown -R asterisk:asterisk /var/log/asterisk
chmod -R 775 /var/log/asterisk

# Start Asterisk
exec /usr/sbin/asterisk -vvvdddf -T -W -U asterisk -p