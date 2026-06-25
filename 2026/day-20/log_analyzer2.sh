#!/bin/bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# log_analyzer.sh — Analyzes a server log file and generates
#                   a daily summary report
#
# Usage: ./log_analyzer.sh <path-to-log-file>
# ═══════════════════════════════════════════════════════════════

# ─── Color codes for terminal output ───────────────────────────
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Report file name with today's date ────────────────────────
# date +%Y-%m-%d produces: 2026-06-24
DATE=$(date +%Y-%m-%d)
REPORT="log_report_${DATE}.txt"

# ══════════════════════════════════════════════════════════════
# TASK 1: Input Validation
# ══════════════════════════════════════════════════════════════

# $# = number of arguments passed; must be exactly 1
if [ $# -ne 1 ]; then
    echo -e "${RED}Error: No log file provided.${RESET}"
    echo "Usage: ./log_analyzer.sh <path-to-log-file>"
    exit 1
fi

LOG_FILE="$1"

# -f checks: does this path exist AND is it a regular file?
if [ ! -f "$LOG_FILE" ]; then
    echo -e "${RED}Error: File '$LOG_FILE' does not exist.${RESET}"
    exit 1
fi

echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════╗"
echo "║       LOG ANALYZER & REPORTER        ║"
echo "╚══════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "${GREEN}Log file  : $LOG_FILE${RESET}"
echo -e "${GREEN}Report    : $REPORT${RESET}"
echo -e "${GREEN}Date      : $DATE${RESET}"
echo ""

# ══════════════════════════════════════════════════════════════
# TASK 2: Count total lines and error count
# ══════════════════════════════════════════════════════════════

# wc -l = count lines in the file
TOTAL_LINES=$(wc -l < "$LOG_FILE")

# grep -c = count lines that match the pattern (don't print the lines, just the number)
# -E = extended regex so we can use | (OR) to match ERROR or Failed in one command
ERROR_COUNT=$(grep -cE "ERROR|Failed" "$LOG_FILE" || true)
# Note: || true prevents set -e from stopping the script if grep finds 0 matches
# (grep exits with code 1 when nothing is found)

echo -e "${BOLD}--- Basic Stats ---${RESET}"
echo "Total lines processed : $TOTAL_LINES"
echo -e "Total errors found    : ${RED}$ERROR_COUNT${RESET}"
echo ""

# ══════════════════════════════════════════════════════════════
# TASK 3: Critical Events
# ══════════════════════════════════════════════════════════════

echo -e "${BOLD}${RED}--- Critical Events ---${RESET}"

# grep -n = print matching lines WITH their line numbers
# Format output: "Line 30: <the full log line>"
CRITICAL_LINES=$(grep -n "CRITICAL" "$LOG_FILE" || true)

if [ -z "$CRITICAL_LINES" ]; then
    # -z checks if the string is empty (no CRITICAL lines found)
    echo "No critical events found."
else
    # sed = stream editor
    # 's/^\([0-9]*\):/Line \1:/' means:
    #   - ^ = start of line
    #   - \([0-9]*\) = capture the line number digits
    #   - : = the colon grep -n puts after the number
    #   - Replace with: "Line <captured-number>:"
    echo "$CRITICAL_LINES" | sed 's/^\([0-9]*\):/Line \1:/'
fi
echo ""

# ══════════════════════════════════════════════════════════════
# TASK 4: Top 5 Error Messages
# ══════════════════════════════════════════════════════════════

echo -e "${BOLD}${YELLOW}--- Top 5 Error Messages ---${RESET}"

# Pipeline breakdown:
# 1. grep "ERROR"              → extract only lines containing ERROR
# 2. awk '{$1=$2=$3=""; ...}' → erase first 3 fields (date, time, level like "ERROR")
#                                leaving just the message text
#    sub(/^[[:space:]]+/, "") → strip leading spaces left by erasing those fields
# 3. sort                     → sort all messages alphabetically (needed before uniq)
# 4. uniq -c                  → count consecutive duplicate lines; prepends the count
# 5. sort -rn                 → sort numerically in reverse (highest count first)
# 6. head -5                  → keep only top 5
grep "ERROR" "$LOG_FILE" \
    | awk '{$1=$2=$3=""; sub(/^[[:space:]]+/, ""); print}' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -5 \
    | while read count message; do
        # Format each line with count right-aligned and message
        printf "%-5s %s\n" "$count" "$message"
    done

echo ""

# ══════════════════════════════════════════════════════════════
# TASK 5: Generate Summary Report File
# ══════════════════════════════════════════════════════════════

echo -e "${BOLD}--- Generating Report: $REPORT ---${RESET}"

# Everything from here to EOF goes into the report file
# Using a heredoc (cat << EOF ... EOF) to write multi-line content
cat > "$REPORT" << EOF
═══════════════════════════════════════════════════════════
              LOG ANALYSIS SUMMARY REPORT
═══════════════════════════════════════════════════════════
Date of Analysis  : $DATE
Log File          : $LOG_FILE
═══════════════════════════════════════════════════════════

─── Basic Stats ────────────────────────────────────────────
Total lines processed : $TOTAL_LINES
Total errors found    : $ERROR_COUNT

─── Top 5 Error Messages ───────────────────────────────────
EOF

# Append the top 5 errors into the report
grep "ERROR" "$LOG_FILE" \
    | awk '{$1=$2=$3=""; sub(/^[[:space:]]+/, ""); print}' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -5 \
    | while read count message; do
        printf "  %-5s %s\n" "$count" "$message"
    done >> "$REPORT"

# Append critical events section
cat >> "$REPORT" << EOF

─── Critical Events ────────────────────────────────────────
EOF

if [ -z "$CRITICAL_LINES" ]; then
    echo "  No critical events found." >> "$REPORT"
else
    echo "$CRITICAL_LINES" \
        | sed 's/^\([0-9]*\):/  Line \1:/' >> "$REPORT"
fi

cat >> "$REPORT" << EOF

═══════════════════════════════════════════════════════════
                     END OF REPORT
═══════════════════════════════════════════════════════════
EOF

echo -e "${GREEN}Report saved to: $REPORT${RESET}"
echo ""

# ══════════════════════════════════════════════════════════════
# TASK 6 (Optional): Archive processed log file
# ══════════════════════════════════════════════════════════════

# -d checks if directory exists
if [ ! -d "archive" ]; then
    mkdir archive    # create archive/ directory if it doesn't exist
fi

# mv = move file to archive directory
mv "$LOG_FILE" archive/

echo -e "${GREEN}Log file archived to: archive/$(basename "$LOG_FILE")${RESET}"
echo ""
echo -e "${BOLD}${GREEN}Analysis complete.${RESET}"
