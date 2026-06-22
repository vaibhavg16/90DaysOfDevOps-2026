#!/bin/bash

check_disk() {
	echo "---Disk Usage---"
	df -h /
}

check_memory() {
	echo "---Memory Usage---"
	free -f
}

check_disk
echo ""
check_memory

