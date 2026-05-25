# 🐧 Day 07 — Linux File System Hierarchy

> **Author:** Vaibhav Godse | **Challenge:** 90DaysOfDevOps 2026
> **Topic:** Understanding the Linux directory structure and what lives where

---

## Why This Matters for DevOps

In Linux, **everything is a file** — configs, logs, hardware devices, and even running processes.
Knowing where things live saves time during deployments, debugging, and incident response.

---

## 📁 The Linux File System Tree

```
/
├── boot/       → Kernel & boot files
├── bin/        → Essential user commands
├── sbin/       → Admin-only commands
├── etc/        → System configuration files
├── home/       → User home directories
├── root/       → Root user's home
├── usr/        → Installed applications & libraries
├── var/        → Logs, web content, databases (changing data)
├── tmp/        → Temporary files (wiped on reboot)
├── dev/        → Hardware device files
├── proc/       → Live kernel & process info
├── sys/        → Live hardware & kernel state
├── mnt/        → Manual mount points
└── media/      → Auto-mounted removable devices
```

---

## 1. Core System Folders

### `/boot` — Bootloader & Kernel
Holds everything Linux needs to start up — the kernel image, bootloader config (GRUB), and initramfs.

> ⚠️ **Never delete files from `/boot`.** Without it, the system will not start.

---

### `/bin` — Essential User Commands
Contains the basic CLI tools everyone needs — including in single-user (rescue/repair) mode.

```bash
ls    # lives at /bin/ls
cp    # lives at /bin/cp
echo  # lives at /bin/echo
```

> 💡 On modern systems (Ubuntu 22.04+), `/bin` is a symlink to `/usr/bin`.

---

### `/sbin` — System Administration Commands
Like `/bin`, but for root-level administrative tools.

```bash
reboot    # restart the system
fdisk     # disk partitioning
iptables  # firewall rules
```

> 💡 Regular users typically can't run these without `sudo`.

---

## 2. Configuration & User Space

### `/etc` — System Configuration Files
All system-wide configuration lives here as plain text files — easy to edit, easy to version control.

```bash
/etc/nginx/nginx.conf       # Nginx web server config
/etc/ssh/sshd_config        # SSH daemon config
/etc/passwd                 # User account info
/etc/hosts                  # Static hostname mappings
/etc/crontab                # Scheduled tasks
```

> 💡 **DevOps tip:** Always back up files in `/etc` before editing them:
> ```bash
> cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
> ```

---

### `/home` — User Home Directories
Each regular user gets their own personal folder here.

```
/home/vaibhav/     ← your personal space
/home/alice/
/home/bob/
```

Other users cannot access your home folder without permission. Stores your documents, dotfiles (`.bashrc`, `.ssh/`), and personal settings.

---

### `/root` — Root User's Home
The home directory for the `root` (superuser) account. Kept separate from `/home` for security — even if `/home` is on a separate disk or gets corrupted, the admin can still log in.

---

## 3. Programs, Applications & Variable Data

### `/usr` — Installed Applications & Libraries
When you install software (Git, Docker, Python), its files land here — not in `/bin`.

```
/usr/bin/          → executables (git, python3, docker)
/usr/lib/          → shared libraries
/usr/share/        → docs, icons, locale data
/usr/local/        → manually compiled/installed software
```

---

### `/var` — Variable / Changing Data
Contains files that grow or change while the system runs.

```
/var/log/           → system and application logs
/var/log/syslog     → general system log
/var/log/nginx/     → nginx access & error logs
/var/www/           → web server content
/var/lib/docker/    → Docker images and containers
```

> ⚠️ `/var` filling up (100% disk) is a common production incident — logs grow unchecked.
> Monitor disk with `df -h` and rotate logs with `logrotate`.

---

### `/tmp` — Temporary Files
Programs store short-lived data here. Linux **wipes this folder on every reboot**.

> 💡 Safe to use for scratch files during scripts, but never store anything important here.

---

## 4. Hardware & Kernel Interfaces

### `/dev` — Device Files
In Linux, hardware is exposed as files. You read/write hardware by reading/writing its device file.

```
/dev/sda       → first SATA/SSD hard disk
/dev/sda1      → first partition on that disk
/dev/tty       → terminal
/dev/null      → the "black hole" — discard anything written to it
/dev/zero      → produces infinite stream of null bytes
```

---

### `/proc` & `/sys` — Live System Information
Virtual filesystems — not real files on disk. The kernel writes live system state here.

```bash
cat /proc/cpuinfo        # CPU details
cat /proc/meminfo        # RAM details
cat /proc/uptime         # system uptime in seconds
ls /proc/1234/           # everything about process PID 1234
```

> 💡 `ps`, `top`, and `htop` all read from `/proc` behind the scenes.

---

### `/mnt` & `/media` — Mount Points

| Directory | Usage |
|-----------|-------|
| `/mnt` | Manual mount points — e.g., mounting a network share or extra disk |
| `/media` | Auto-mounted removable devices — USB drives, SD cards, DVDs |

```bash
# Mount an external disk manually
sudo mount /dev/sdb1 /mnt/external

# Access it
ls /mnt/external
```

---

## Quick Reference Table

| Directory | Contains | DevOps Relevance |
|-----------|----------|-----------------|
| `/boot` | Kernel, bootloader | Don't touch unless upgrading kernel |
| `/bin` | Core user commands | `ls`, `cp`, `echo`, `grep` |
| `/sbin` | Admin commands | `reboot`, `fdisk`, `iptables` |
| `/etc` | Config files | Edit to configure services |
| `/home` | User data | Developer workspaces, SSH keys |
| `/root` | Root's home | Admin files, scripts |
| `/usr` | Installed apps | Where `apt install` puts things |
| `/var` | Logs, web data | Monitor disk, check logs here |
| `/tmp` | Temp files | Wiped on reboot — nothing permanent |
| `/dev` | Device files | Disk management, `/dev/null` |
| `/proc` | Live process info | Read by `ps`, `top`, `cat /proc/meminfo` |
| `/sys` | Live hardware state | Kernel tuning, hardware info |
| `/mnt` | Manual mounts | Attach extra disks, NFS shares |
| `/media` | Auto-mounts | USB drives, removable media |

---

## Commands to Explore the Filesystem

```bash
# See the top-level structure
ls /

# Check disk usage per directory
du -sh /*  2>/dev/null

# Find where a command lives
which nginx
which python3

# See what's in /etc
ls /etc/ | head -20

# Check your own home directory
ls -la ~

# View live CPU info from /proc
cat /proc/cpuinfo | grep "model name" | head -2

# View memory info from /proc
cat /proc/meminfo | grep -E "MemTotal|MemAvailable"

# List block devices (disks)
lsblk
```

---

> **Bottom line:** The Linux filesystem is a map.
> The faster you can navigate it without thinking, the faster you troubleshoot in production. 🚀
