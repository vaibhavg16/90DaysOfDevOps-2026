# 🐧 Day 07 — Linux File System Hierarchy & Scenario-Based Practice

> **Author:** Vaibhav Godse | **Challenge:** 90DaysOfDevOps 2026
> **Topics:** Linux FS Hierarchy · Service Troubleshooting · Process Monitoring · Log Analysis · File Permissions

---

## 📑 Table of Contents

- [Part 1: Linux File System Hierarchy](#part-1-linux-file-system-hierarchy)
- [Part 2: Scenario-Based Practice](#part-2-scenario-based-practice)
  - [Scenario 1 — Service Not Starting](#scenario-1--service-not-starting)
  - [Scenario 2 — High CPU Usage](#scenario-2--high-cpu-usage)
  - [Scenario 3 — Finding Service Logs](#scenario-3--finding-service-logs)
  - [Scenario 4 — Permission Denied](#scenario-4--permission-denied)
- [Key Takeaways](#-key-takeaways)

---

## Part 1: Linux File System Hierarchy

> In Linux, **everything is a file** — hardware, processes, configs, logs. Understanding where things live is essential for any DevOps engineer.

```
/
├── boot/     ← kernel & boot files
├── bin/      ← basic commands (ls, cp, echo)
├── sbin/     ← admin commands (reboot, iptables)
├── etc/      ← all configuration files
├── home/     ← user home directories
├── root/     ← root user's home
├── usr/      ← installed programs & libraries
├── var/      ← logs, web content, databases
├── tmp/      ← temporary files (cleared on reboot)
├── dev/      ← hardware devices as files
├── proc/     ← live kernel & process info
├── sys/      ← live hardware & driver info
├── mnt/      ← manually mounted filesystems
└── media/    ← auto-mounted removable drives
```

---

### 1. Core System Folders

| Directory | Purpose |
|-----------|---------|
| `/boot` | Kernel and bootloader files. Deleting this = system won't boot |
| `/bin` | Essential commands for all users — `ls`, `cd`, `cp`, `echo` |
| `/sbin` | Admin-only commands — `reboot`, `fdisk`, `iptables` |

---

### 2. Configuration & User Space

| Directory | Purpose |
|-----------|---------|
| `/etc` | All system config files — nginx, network, users, passwords |
| `/home` | Personal folder per user (e.g., `/home/vaibhav`) — private by default |
| `/root` | Home directory for the root user — separate from `/home` for security |

> 💡 `/etc` is where you spend most of your time as a DevOps engineer — nginx config, SSH config, cron jobs, network settings all live here.

---

### 3. Storage, Programs & Variables

| Directory | Purpose |
|-----------|---------|
| `/usr` | Installed programs and libraries (e.g., git, docker, python go here) |
| `/var` | Files that grow over time — logs (`/var/log`), web files (`/var/www`), databases |
| `/tmp` | Temporary scratch space — wiped clean on every reboot |

> ⚠️ Watch `/var` disk usage in production — logs and database files grow here silently. A full `/var` will crash your services.

---

### 4. Hardware & System Memory

| Directory | Purpose |
|-----------|---------|
| `/dev` | Hardware represented as files — `/dev/sda` = first hard disk, `/dev/null` = black hole |
| `/proc` | Live kernel data — process info, CPU, memory (not real files, generated on-the-fly) |
| `/sys` | Live hardware and driver info |
| `/mnt` | Mount point for manually mounted drives or network shares |
| `/media` | Auto-mounted removable devices — USB drives, SD cards |

---

## Part 2: Scenario-Based Practice

> **Approach:** Observe → Understand → Fix → Verify. Never jump to fixes before reading the logs.

---

## Scenario 1 — Service Not Starting

> **Problem:** A web app service called `myapp` (or `nginx`) failed to start after a server reboot.

**Troubleshooting flow:**
```
Check status → Read full logs → Check boot config → Check port conflict → Start & watch live
```

---

### Step 1 — Check service status

```bash
systemctl status nginx
```

> Always the first command. Shows state (active/failed/inactive) + last 10 log lines in one view.
> Look for `Active: failed (Result: exit-code)` or a red dot `●`.

---

### Step 2 — Read full service logs

```bash
journalctl -u nginx -n 50 --no-pager
journalctl -u nginx --since "today" --no-pager
```

| Flag | Meaning |
|------|---------|
| `-u nginx` | Filter logs for nginx.service only |
| `-n 50` | Show last 50 lines (status only shows 10) |
| `--no-pager` | Print directly — don't open in `less` |

> Common errors you'll find here: `bind: Address already in use` (port conflict) · `No such file or directory` (missing config) · `Permission denied` (wrong file ownership)

---

### Step 3 — Check if service is enabled on boot

```bash
systemctl is-enabled nginx.service
```

> If output is `disabled` — service was never configured to auto-start. Survives a manual start but **dies after every reboot**.

```bash
# Fix:
sudo systemctl enable nginx.service
```

---

### Step 4 — Check for port conflicts

```bash
ss -tulnp | grep 80
```

> If another process already holds port 80, nginx cannot bind to it and fails to start. This command shows every listening port and which process owns it.

---

### Step 5 — Start service and watch live

```bash
sudo systemctl start nginx.service
journalctl -u nginx.service -f
```

> Start the service, then immediately follow logs with `-f`. You'll see the exact error the moment it occurs.

---

## Scenario 2 — High CPU Usage

> **Problem:** Manager reports the server is slow. You SSH in — find the CPU hog.

**Troubleshooting flow:**
```
Check load → Snapshot CPU → Watch live → Inspect PID → Link to service
```

---

### Step 1 — Check system load

```bash
uptime
```

> Rule: load average should be ≤ `nproc` (number of CPU cores).
> Load `4.0` on a 1-core server = overloaded. Load `4.0` on an 8-core server = fine.

---

### Step 2 — Find the CPU hog (snapshot)

```bash
ps aux --sort=-%cpu | head -10
```

> Sorts all processes by CPU descending. Top line = biggest consumer. **Note the PID** (column 2).

---

### Step 3 — Watch CPU usage live

```bash
top
top -o %CPU
```

> Live updating view. Press `P` = sort by CPU · `M` = sort by memory · `q` = quit.
> **Tip:** In `top`, press `k` → enter PID → enter `9` to kill a process without exiting.

---

### Step 4 — Inspect the specific process

```bash
ps aux | grep <PID>
ls -l /proc/<PID>/exe
```

> `/proc/<PID>/exe` is a symlink to the exact binary being executed — useful when the process name alone is unclear.

---

### Step 5 — Link process to its service

```bash
systemctl status <PID>
cat /proc/<PID>/status
```

> `systemctl` can take a PID and tell you which service unit owns it — so you know whether to restart nginx, docker, or your custom app.

> ⚠️ Also check memory: `ps aux --sort=-%mem | head -10` — high swap usage can cause CPU thrashing that looks like a CPU issue but is actually RAM exhaustion.

---

## Scenario 3 — Finding Service Logs

> **Problem:** A developer asks — *"Where are the logs for the nginx service?"*

**Troubleshooting flow:**
```
Confirm systemd → View recent logs → Filter by time → Follow live → Search for errors
```

---

### Step 1 — Confirm service is systemd-managed

```bash
systemctl status nginx.service
```

> Check the `Loaded:` line — if it shows a `.service` file path, all logs are in `journald`.

---

### Step 2 — View last 50 lines

```bash
journalctl -u nginx.service -n 50 --no-pager
```

---

### Step 3 — Filter by time

```bash
journalctl -u nginx --since "1 hour ago" --no-pager
journalctl -u nginx --since "today" --no-pager
journalctl -u nginx --since "2026-05-26 10:00:00"
```

> Narrows logs to the window when the issue happened — avoids scrolling through thousands of lines.

---

### Step 4 — Follow logs live

```bash
journalctl -u nginx.service -f
```

> Streams new lines as they appear — exactly like `tail -f` but for systemd services. Use during deployments or restarts.

---

### Step 5 — Search for errors

```bash
journalctl -u nginx --since "today" | grep -i error
journalctl -p err --since "1 hour ago" --no-pager
```

> Second command shows ERROR-level messages across **all services** — great for a quick system-wide health check.

---

## Scenario 4 — Permission Denied

> **Problem:** Script at `/home/user/backup.sh` throws `Permission denied` when executed.

**Troubleshooting flow:**
```
Check permissions → Understand the string → chmod +x → Verify → Run
```

---

### Step 1 — Check current permissions

```bash
ls -l /home/user/backup.sh
```

**Output:**
```
-rw-r--r-- 1 vaibhav vaibhav 512 May 26 10:00 backup.sh
```

---

### Step 2 — Understand the permission string

```
- rw- r-- r--
│  │   │   └── others : read only
│  │   └─────  group  : read only
│  └─────────  owner  : read + write  (no x = not executable!)
└────────────  file type: regular file
```

> No `x` anywhere = the file cannot be executed. That's why you get "Permission denied".

---

### Step 3 — Add execute permission

```bash
chmod +x /home/user/backup.sh
# or more explicitly:
chmod 755 /home/user/backup.sh
```

| Command | What it sets |
|---------|-------------|
| `chmod +x` | Adds execute for owner + group + others |
| `chmod 755` | owner=`rwx`, group=`r-x`, others=`r-x` — standard for scripts |
| `chmod 777` | ⚠️ NEVER in production — gives everyone write access too |

---

### Step 4 — Verify the change

```bash
ls -l /home/user/backup.sh
```

```
Before:  -rw-r--r--   (no x)
After:   -rwxr-xr-x   ✅ (x added)
```

---

### Step 5 — Run the script

```bash
./backup.sh

# If still failing, bypass execute bit and run directly:
bash /home/user/backup.sh
```

> `bash backup.sh` bypasses the execute permission — useful for debugging shebang or syntax errors.

---

### Still getting "Permission denied" after chmod?

```bash
ls -la /home/user/     # check who owns the file
whoami                 # check who you are
sudo chmod +x /home/user/backup.sh   # use sudo if owned by root
```

> If the file is owned by `root` but you're logged in as `vaibhav`, you need `sudo` to change its permissions.

---

## 💡 Key Takeaways

| Scenario | Root Cause | First Command | Fix |
|----------|-----------|--------------|-----|
| Service not starting | disabled / port conflict / missing config | `systemctl status` | `journalctl -u <svc>` → identify → fix |
| High CPU | Runaway process or RAM exhaustion causing thrash | `uptime` + `ps aux --sort=-%cpu` | `systemctl status <PID>` → restart |
| Finding logs | All systemd services log to journald | `systemctl status <svc>` | `journalctl -u <svc> -f` |
| Permission denied | Missing execute bit (`x`) | `ls -l <file>` | `chmod +x <file>` |

---

> **The DevOps mindset:** Always **observe first, fix second**.
> Read the logs before touching anything — 90% of the time, the log tells you exactly what's wrong. 🚀
