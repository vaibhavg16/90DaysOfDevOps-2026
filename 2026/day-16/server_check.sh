#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status of the $SERVICE? (y/n): " choice

if [ "$choice" = "y" ]; then
	systemctl status "$SERVICE" --no-pager | egrep "Active:|Loaded:"
	if systemctl is-active --quiet "$SERVICE"; then
		echo "$SERVICE is active"
	else
		echo "$SERVICE is not active"
	fi
elif [ "$choice" = "n" ]; then
	echo "skipped."
else
	echo "Invalid choice. please enter y or n."
fi
