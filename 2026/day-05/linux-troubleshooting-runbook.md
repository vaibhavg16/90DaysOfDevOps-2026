# Linux Troubleshooting Runbook – sshd

## Target service / process
Service: sshd (OpenSSH server)
Reason: Core remote access service; easy to validate via network and logs.

## 1. Environment basics

### Command 1 - Kernel and system info 
`uname -a`

- Purpose: Show kernel name, version, architecture.
- Output: `Linux Asus-Vivobook 6.6.87.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun  5 18:30:46 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux`
- Observation: This output confirms that I'm running a 64-bit Linux environment inside Windows (via WSL2) on an ASUS Vivobook, utilizing a Microsoft-built Linux Kernel (version 6.6.87.2) compiled on June 5, 2025. 

### Command 2 - OS version
`cat /etc/os-release`

- Output: 
`PRETTY_NAME="Ubuntu 24.04.4 LTS"`
`NAME="Ubuntu"`
`VERSION_ID="24.04"`
`VERSION="24.04.4 LTS (Noble Numbat)"`
`VERSION_CODENAME=noble`
`ID=ubuntu`
`ID_LIKE=debian`

- Purpose: Show Linux distribution and version.
- Observation: This output confirms I'm running Ubuntu 24.04.4 LTS (Noble Numbat), a long-term support Linux distribution built on Debian family.

## 2. Filesystem Sanity Check

### Command 1 - Create temp directory & Copy file and list contents.

`mkdir -p /tmp/runbook-demo && cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo`

- Purpose: Creates a directory /tmp/runbook-demo if it doesn’t exist. & Copy file and list contents.
- Observation: Directory creation and file duplication succeeded seamlessly. /tmp is writable, and basic I/O operations are operational.

## 3. CPU & Memory Snapshot

### Command 1 - Live CPU & memory overview.

`htop`

- Purpose: Shows real-time CPU, memory, load average, and top processes.

### Command 2 – Service-specific CPU & Memory overview.

`free -h`

- Purpose: Checking overall system resources and isolating the specific footprint of our target service.

### Command 3 – Service-specific CPU & memory

`pgrep sshd`

- Purpose: To get PID of sshd

### Command 4 - CPU and memory percentage for sshd.

`ps -o pid,pcpu,pmem,comm -p <PID>`

- Purpose: Gives an exact CPU/memory footprint for your service instead of global system averages.

## 4. Disk & I/O snapshot

### Command 1 - Disk usage

`df -h`

- Purpose: Shows filesystem disk usage with human-readable sizes. Check / and /var (or wherever your logs/services live).

### Command 2 - Log directory size

`du -sh /var/log`

- Purpose: On /var/log, it shows total size of logs. Ensures logs aren’t exploding and filling disks.

## 5. Network snapshot

### Command 1 – Listening ports and service status

`sudo ss -tulpn | grep ssh`
(If ss not available, use netstat -tulpn)

- Purpose: Confirms sshd is listening on expected port (usually 22) and no port conflict.

### Command 2 – Connectivity check

`curl -v telnet://localhost:22` OR `nc -zv localhost 22`

- Purpose: checks if port 22 is open.

## 5. Logs reviewed

### Command 1 - Recent service logs via journalctl

`journalctl -u ssh -n 50` OR `journalctl -u sshd -n 50`

- Purpose: Shows recent restarts, failures, auth issues, or configuration errors.


### Command 2 – Log file tail

`tail -n 50 /var/log/auth.log`

- Purpose: Shows last 50 lines from the auth log, which includes SSH login attempts.


## Quick review

- ssh service running normally with low CPU usage
- Disk and logs size is healthy
- Network port 22 is open and serving connections.
- No errors in logs.

## If this worsens

- Check logs again
- Check CPU usage/Disk usage
- Restart service
- Check if port is used by other service

