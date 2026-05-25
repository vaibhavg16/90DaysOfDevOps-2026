Part 01: Linux File System Hierarchy

1. The Core System Folders

/boot: Contains essential files needed to start your computer, like the linux kernal. If you delete this folder, your computer will not restart.

/bin: Contains the basic, everyday command line tools that everyone needs to use (even in single-user repair mode). This is where commands like ls, cd, cp, and echo actually live as executable files.

/sbin: Similar to /bin, but these are administrative tools meant for system administrator (root). It contains commands like reboot, fdisk (disk partitioning), and iptables (firewall setup). 

2. Configuration & User Space

/etc: Contains system configuration files. Want to change network settings, user passwords, or Nginx configurations? They all live inside text files here.

/home: Every normal user gets their own personal folder here to store documents, downloads, and personal settings (e.g., /home/vaibhav). Other users cannot look into your home folder without permission.

/root:  Personal home directory for the "Root" user (the ultimate system administrator). It is kept completely separate from normal user homes in /home for security reasons.

3. Storage, Programs, & Variables

/usr (Installed Programs / User Applications): This contains the vast majority of user programs, libraries, and source code. For example, when you install a tool like Git, Docker, or Python, its executables end up in /usr/bin/ instead of the core system's /bin/.

/var (The Variable Folder / Changing Data): Contains files that are constantly growing or changing in size while the system runs. This is where system log files live (/var/log), as well as web server contents (/var/www) and database files.

/tmp (The Scratchpad / Temporary Files): A folder where programs can store temporary data they only need for a short time. Linux typically wipes this folder completely clean every time your computer reboots.

4. Hardware & System Memory

/dev (The Hardware Drawer / Devices): In Linux, "Everything is a file." Your physical hardware components are represented as files here. Your first hard drive is usually /dev/sda, your audio card is here, and even a plugged-in USB drive shows up here.

/proc & /sys (The Live Brain Readout): These folders contain real-time information about your running system.

/mnt & /media (The Plug-In Stations): When you plug in an external hard drive, SD card, or mount a network file share, Linux links that device inside one of these folders so you can click or cd into it to view the files.


Part 02: Scenario-Based Practice


Scenario 1 — Service Not Starting.


Step 1: Check if service is running or failed

`systemctl status myapp`: This is ALWAYS the first command. It tells you if the service is active, failed, inactive, or activating — and shows the last 10 log lines right there. Look for the red dot and "failed" or "start-pre failed". Look for Active: failed (Result: exit-code) or Active: activating (auto-restart)

STEP 2: Read the full service logs

`journalctl -u nginx -n 50 --no-pager` OR `journalctl -u nginx --since "today" --no-pager`: Step 1 shows only 10 lines. The real error is often higher up — config file not found, port already in use, permission denied on a socket. These commands show 50 lines or everything from today.

STEP 3: Check if service is enabled on boot

`systemctl is-enabled nginx.service': If output is "disabled" — the service was never set to auto-start. It runs manually but dies after reboot. This is the most common cause of "worked before reboot" issues in production. If disabled: run → sudo systemctl enable nginx.service.

STEP 4: Check for port conflicts
`
`ss -tulnp | grep 80`: If myapp tries to bind to port 80 but another process is already on it, nginx will fail to start. This command shows what's already listening on each port and which process owns it.

STEP 5 — FIX: Try to start and watch live

`sudo systemctl start nginx.service` And `journalctl -u nginx.service -f`: Start the service, then immediately follow the logs live with -f. You'll see the exact moment it fails and the exact error message in real time.

Scenario 2 — High CPU

Step 1: Get instant system overview

`uptime`: Shows load average for last 1, 5, 15 minutes. If load > number of CPU cores (check with nproc), the system is genuinely overloaded. This confirms whether it's a real problem before you dive deeper.

STEP 2: Find the CPU hog — snapshot

`ps aux --sort=-%cpu | head -10`: Sorts all running processes by CPU usage descending. The top line after the header = your biggest CPU consumer. Note the PID (column 2) and COMMAND (last column). This is a snapshot — not live.

STEP 3: Watch CPU usage live

'top' And 'top -o %CPU' :top shows a live updating view. Processes are already sorted by CPU. Press 'P' to sort by CPU, 'M' for memory, 'q' to quit. Use -o %CPU to start already sorted by CPU. Note the PID of the top process. In top: press 'k' → enter PID → enter 9 to kill a process without exiting

STEP 4: Inspect the specific process

`ps aux | grep <PID>` And `ls -l /proc/<PID>/exe`: Once you have the PID from step 2 or 3, grep it to see full details. The /proc/PID/exe symlink shows the exact binary file being executed — useful when the command name alone is unclear.

STEP 5: Check which service owns it

`systemctl status <PID>` And `cat /proc/<PID>/status`: systemctl can take a PID and tell you which service unit it belongs to. This connects the runaway process back to the service — so you know whether to restart nginx, docker, or a custom app.
Check memory too: ps aux --sort=-%mem | head -10 — sometimes it's RAM exhaustion causing CPU thrashing, not a true CPU issue.

Scenario 3 — Service Logs

Step 1: Confirm service is managed by systemd

`systemctl status nginx.service` : Before jumping to logs, confirm the service exists and is systemd-managed. The "Loaded:" line shows the service file path. If it shows a .service file → journalctl is where all logs are.

Step 2: View last 50 lines of logs

`journalctl -u nginx.service -n 50 --no-pager`: -u nginx.service = filter for nginx.service only | -n 50 = last 50 lines | --no-pager = print directly without opening less. This is what you share with a developer asking "what does the log say?"

Step 3: Filter logs by time

`journalctl -u docker --since "1 hour ago" --no-pager`
`journalctl -u docker --since "today" --no-pager`
`journalctl -u docker --since "2026-05-26 10:00:00"`

Scenario 4 — Permission Denied

Step 1: Check current permissions

`ls -l /home/user/backup.sh`
`ls -l`: shows the permission string. Read it left to right: file type (first char) + owner perms (3 chars) + group perms (3 chars) + others perms (3 chars).
-rw-r--r-- means: regular file | owner can read+write | group can read | others can read | NOBODY can execute (no x anywhere)

Step 2: Understanding permission string

`-rw-r--r--` ← no x = not executable
rw- = owner: read + write
r-- = group: read only
r-- = others: read only

Step 3: Add execute permission

`chmod +x /home/user/backup.sh` `chmod 755 /home/user/backup.sh`: chmod +x adds execute permission for everyone (owner + group + others). chmod 755 is more explicit: 7=rwx for owner, 5=r-x for group, 5=r-x for others. For scripts, 755 is the standard.
chmod 777 gives everyone full rwx including write — NEVER use on production scripts. Anyone could modify the script.

Step 4: Verify the change.

`ls -l /home/user/backup.sh': Run ls -l again. Now you should see -rwxr-xr-x — notice the x in all three sections. The file is now executable by everyone. The x is what was missing before.
Before: -rw-r--r-- | After chmod +x: -rwxr-xr-x

Step 5: Run the script
`./backup.sh` And `bash /home/user/backup.sh`: ./backup.sh runs it as an executable using the shebang (#!/bin/bash) at the top of the script. If you still get errors, try bash backup.sh — this bypasses execute permission and runs it directly through bash interpreter. Good for debugging.


What if still "Permission denied" after chmod?

`ls -la /home/user/`
`whoami`
`sudo chmod +x /home/user/backup.sh`

Check who owns the file (ls -la) and who you are (whoami). If the file is owned by root but you're logged in as vaibhav, you need sudo to change permissions. The directory itself may also need execute permission for you to access files inside it.
