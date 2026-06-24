#!/bin/bash

log_rotation(){
        # Changed ~ to /home/vaibhav
        /home/vaibhav/90DaysOfDevOps-2026/2026/day-19/log_rotate.sh /var/log/myapp >> /var/log/maintenance.log
}

backup(){
        # Changed ~ to /home/vaibhav in all paths here too
        /home/vaibhav/90DaysOfDevOps-2026/2026/day-19/backup.sh /home/vaibhav/90DaysOfDevOps-2026/2026/day-19/data /home/vaibhav/90DaysOfDevOps-2026/2026/day-19/backups >> /var/log/maintenance.log
}

main(){
        echo -e "\n$(date) : Starting Maintenance... " >> /var/log/maintenance.log
        log_rotation
        backup
        echo "Maintenance completed for today" >> /var/log/maintenance.log
}

main
echo "Successfully written logs to /var/log/maintenance.log"
