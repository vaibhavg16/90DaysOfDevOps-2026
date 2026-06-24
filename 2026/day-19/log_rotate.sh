#!/bin/bash

set -euo pipefail

# ---------------Check argument provided---------------

if [ $# -eq 0 ]; then
	echo "Usage: .log_rotate.sh <log-directory>"
	exit 1
fi

LOG_DIR="$1"

# ---------------Check directory exists---------------

if [ ! -d "$LOG_DIR" ]; then
    echo "ERROR: Directory '$LOG_DIR' does not exist."
    exit 1
fi

echo "Starting log rotation for: $LOG_DIR"
echo "Date: $(date)"
echo ""



compressed=0

while IFS= read -r -d '' file; do
	gzip "$file"
	compressed=$((compressed + 1))
done < <(find "$LOG_DIR" -name "*.log" -mtime +7 -print0)

deleted=0

while IFS= read -r -d '' file; do
	rm $file
	deleted=$((deleted + 1))
done < <(find "$LOG_DIR" -name "*.gz" -mtime +30 -print0)


echo ""
echo "─── Summary ──────────────────────"
echo "Files compressed : $compressed"
echo "Files deleted    : $deleted"
echo "Log rotation complete."
