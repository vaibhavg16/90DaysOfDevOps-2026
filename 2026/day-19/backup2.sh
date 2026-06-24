#!/bin/bash
set -euo pipefail

# ─── Check arguments ────────────────────────────────────────
if [ $# -ne 2 ]; then
    echo "Usage: ./backup.sh <source-directory> <backup-destination>"
    exit 1
fi

SOURCE="$1"
DEST="$2"

# ─── Check source exists ────────────────────────────────────
if [ ! -d "$SOURCE" ]; then
    echo "Error: Source directory '$SOURCE' does not exist."
    exit 1
fi

# ─── Create destination if it doesn't exist ─────────────────
mkdir -p "$DEST"

# ─── Create timestamped archive name ────────────────────────
TIMESTAMP=$(date +%Y-%m-%d)
ARCHIVE_NAME="backup-${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${DEST}/${ARCHIVE_NAME}"

echo "Starting backup..."
echo "Source      : $SOURCE"
echo "Destination : $DEST"
echo "Archive     : $ARCHIVE_NAME"
echo ""

# ─── Create the tar.gz archive ──────────────────────────────
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"

# ─── Verify archive was created ─────────────────────────────
if [ -f "$ARCHIVE_PATH" ]; then
    SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
    echo "Backup successful!"
    echo "Archive name : $ARCHIVE_NAME"
    echo "Archive size : $SIZE"
else
    echo "Error: Backup failed — archive not found."
    exit 1
fi

# ─── Delete backups older than 14 days ──────────────────────
echo ""
echo "Cleaning up old backups (older than 14 days)..."
deleted=0
while IFS= read -r -d '' file; do
    rm "$file"
    echo "Deleted old backup: $(basename "$file")"
    deleted=$((deleted + 1))
done < <(find "$DEST" -name "backup-*.tar.gz" -mtime +14 -print0)

if [ "$deleted" -eq 0 ]; then
    echo "No old backups to clean."
fi

echo ""
echo "Backup complete."
