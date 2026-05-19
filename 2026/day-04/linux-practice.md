# Process Management · Service Inspection · Log Analysis

-----------------
1. Process Checks
-----------------
Command 1 — Top CPU-consuming processes

ps aux --sort=-%cpu | head -15

![ps aux output](images/ps_aux_cpu.png)

Command 2 — Top memory-consuming processes

ps aux --sort=-%mem | head -10

![ps aux output](images/ps_aux_mem.png)

Command 3 — List processes with pgrep

pgrep -a -u root | head -10

![pgrep output](images/pgrep.png)

Command 4 — Check for zombie processes

ps aux | awk '$8 =="Z" {print "ZOMBIE:", $0}'

![ps aux output](images/ps_aux_zombie.png)

-----------------
2. Service Checks
-----------------

Command 5 — List all running services

systemctl list-units --type=service --state=running 

![systemctl list-units](images/systemctl1.png)

Command 6 — Inspect a specific service (SSH example)

systemctl status ssh

![systemctl list-units](images/systemctl2.png)

Command 7 — Check service status via init.d

service --status-all

![systemctl list-units](images/service.png)

-------------
3. Log Checks
-------------

Command 8 — Check kernel/boot logs with dmesg

dmesg | tail -20

![ps aux output](images/dmesg.png)

Command 9 — View service logs with journalctl

journnalctl -u ssh --since "1 hour ago" --no-pager



Command 10 — Tail a log file

tail -n 40 /var/log/syslog

![tail](images/tail.png)

----------------------------
4. Mini Troubleshooting Flow
----------------------------

Scenario: "My application seems slow / server feels unresponsive"

Step 1 — Check system load

uptime

![uptime](images/uptime.png)

Step 2 — Check memory

free -h

![free](images/free.png)

Step 3 — Check disk usage

du -h
![disk usage](images/du.png)

Step 4 — Find which process is eating resources

ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10

![ps aux output](images/ps_aux.png)

Step 5 — Check if the service is running

systemctl status nginx

![ssh nginx](images/nginx.png)

Step 6 — Check recent logs for errors

journalctl -u nginx --since "10 minutes ago" | grep -i error

![journalctl no error](images/noerror.png)

