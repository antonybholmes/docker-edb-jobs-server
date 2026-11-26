# Cleanup script for temporary job files
# Ensures that files older than 30 days in
# /data/tmp are removed using systemd-tmpfiles

#!/bin/bash
set -euo pipefail

# --- Configuration ---
TARGET_DIR="/data/tmp"
RETENTION_DAYS="30d"
CONFIG_FILE="/etc/tmpfiles.d/job-tmp-cleanup.conf"

# 1. Ensure the directory exists (if not already mounted/created)
mkdir -p "$TARGET_DIR"

# 2. Write the systemd-tmpfiles rule
# 'e' cleans existing directories based on age without altering ownership/permissions
cat <<EOF > "$CONFIG_FILE"
e ${TARGET_DIR} - - - ${RETENTION_DAYS}
EOF

# 3. Validate the configuration and ensure the daily timer is active
systemd-tmpfiles --clean "$CONFIG_FILE"
systemctl enable --now systemd-tmpfiles-clean.timer

echo "Configured 30-day cleanup for ${TARGET_DIR} at ${CONFIG_FILE}."