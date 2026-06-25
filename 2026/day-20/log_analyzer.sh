#!/bin/bash

# TASK 1: Input Validation

usage(){

    		echo "Error: No log file provided."
    		echo "Usage: ./log_analyzer.sh <path-to-log-file>"
    		exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

fname=$1

check(){
	# -f checks: does this path exist AND is it a regular file?
	if [ ! -f "$fname" ]; then
    		echo "Error: File '$fname' does not exist."
    		exit 1
	fi
}

# TASK 2: Count total lines and error count

err_count(){

TOTAL_LINES=$(wc -l < "$fname")
echo "---------Total Error Counts-------------"
# grep -c = count lines, -E = extended regex so we can use | (OR) to match ERROR or Failed in one command, -i: Case-insensitive
ERROR_COUNT=$(grep -icE "ERROR|Failed" "$fname" || true)
# Note: || true prevents set -e from stopping the script if grep finds 0 matches
# (grep exits with code 1 when nothing is found)

echo "Total lines processed : $TOTAL_LINES"
echo "Total errors found    : $ERROR_COUNT"
echo ""
}

# TASK 3: Critical Events

critical_events(){
        echo "--------Critical Events-------------"
	CRITICAL_LINES=$(grep -n "CRITICAL" "$fname" || true)

	if [ -z "$CRITICAL_LINES" ]; then
    	# -z checks if the string is empty (no CRITICAL lines found)
    		echo "No critical events found."
	else
    		echo "$CRITICAL_LINES" | sed 's/^\([0-9]*\):/Line \1:/'
	fi
		echo ""
}

# TASK 4: Top 5 Error Messages

top_5(){
echo "----------Top 5 Error Messages-------------"
grep "ERROR" $fname | awk '{$1=$2=$3=$NF=""; print}' | sort | uniq -c | sort -nr | head -5
}


total_lines(){
	echo -e "\n==========TOTAL LINES PROCESSED=========="
        wc -l < $fname
}

# TASK 5: Summary Report

report(){
	
	report="log_report_$(date +%Y-%m-%d-%H-%M).txt"
	
	{
		echo "Date of Analysis: $(date '+%Y-%m-%d Time: %H:%M')"
		echo "Name of Log File: $fname"
		total_lines 
		top_5
		err_count
		critical_events
	} >> $report
}

#TASK 6(Optional): Archive Processed Logs

move(){
	mkdir -p archive
	mv "$report" archive
	echo -e "\nCreated report file $report and moved it to archive folder."
}

check
err_count
critical_events
top_5
report
move
