#!/bin/bash

#set -euo pipefail

print_header(){
	echo "===================================="
        echo "$1"
	echo "===================================="
}


system_info() {
	print_header "System Info"
	echo "Hostname: $(hostname)"
	echo "OS      : $(uname -o)"
	echo "Kernal  : $(uname -r)"
	echo ""
}
uptime_info() {
	print_header "Uptime Info"
	uptime
	echo ""
}
disk_usage() {
	print_header "Top 5 disk usage"
	if ! du -h -x --max-depth=1 / 2>/dev/null | sort -rh | head -5; then
		echo "Warning: disk usage check failed, but continuing..."
        fi

	echo ""
}
memory_usage() {
	print_header "Memory Usage"
	free -h
	echo ""
}
top_processes() {
    print_header "Top 5 CPU Processes"
    ps aux --sort=-%cpu | head -6
    echo ""
}

main() {
echo "============ SYSTEM INFO REPORT ============="	
system_info
uptime_info
disk_usage
memory_usage
top_processes
echo "Report complete."
}

main
