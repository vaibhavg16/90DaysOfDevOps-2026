# 🐚 Shell Scripting Cheat Sheet
> **Day 21 – Personal Quick-Reference Guide for DevOps Engineers**

---

## ⚡ Quick Reference Table

| Topic       | Key Syntax                      | Example                                    |
|-------------|---------------------------------|--------------------------------------------|
| Shebang     | `#!/bin/bash`                   | `#!/bin/bash`                              |
| Variable    | `VAR="value"`                   | `NAME="DevOps"`                            |
| Argument    | `$1`, `$2`, `$#`, `$@`          | `./script.sh arg1 arg2`                    |
| If          | `if [ cond ]; then ... fi`      | `if [ -f file ]; then echo OK; fi`         |
| For loop    | `for i in list; do ...; done`   | `for f in *.log; do echo "$f"; done`       |
| While loop  | `while cond; do ...; done`      | `while [ $x -lt 5 ]; do ...; done`         |
| Function    | `name() { ... }`                | `greet() { echo "Hi"; }`                   |
| Grep        | `grep pattern file`             | `grep -i "error" log.txt`                  |
| Awk         | `awk '{print $1}' file`         | `awk -F: '{print $1}' /etc/passwd`         |
| Sed         | `sed 's/old/new/g' file`        | `sed -i 's/foo/bar/g' config.txt`          |
| Cut         | `cut -d: -f1 file`              | `cut -d: -f1 /etc/passwd`                  |
| Sort        | `sort file`                     | `sort -nr file`                            |
| Uniq        | `uniq file`                     | `uniq -c file`                             |
| WC          | `wc -l file`                    | `wc -l *.log`                              |
| Head/Tail   | `head file`, `tail file`        | `tail -f app.log`                          |
| Read        | `read VAR`                      | `read -p "Name: " NAME`                    |
| Exit        | `exit 0`, `exit 1`              | `exit 1`                                   |
| Trap        | `trap 'fn' EXIT`                | `trap 'rm -f /tmp/lock' EXIT`              |
| Debug       | `set -x`                        | `bash -x script.sh`                        |

---

## Task 1: Basics

### 1. Shebang — `#!/bin/bash`

The **first line** of every script. Tells the OS which interpreter to use.
Without it, the script runs in the current shell — behavior may differ across environments.

```bash
#!/bin/bash           # Use Bash explicitly
#!/usr/bin/env bash   # Portable: finds bash from $PATH (preferred)
#!/bin/sh             # POSIX-compatible shell (fewer features)
```

---

### 2. Running a Script

```bash
chmod +x script.sh    # Make executable (only needed once)
./script.sh           # Run as executable
bash script.sh        # Run with bash directly (no chmod needed)
source script.sh      # Run in current shell (variables persist)
. script.sh           # Shorthand for source
```

---

### 3. Comments

```bash
# This is a single-line comment

echo "Hello"  # Inline comment — everything after # is ignored

: '
  This is a
  multi-line comment block
  using a no-op colon command
'
```

> **Note:** Bash has only **one true comment syntax: `#`**.
> Both `: '...'` and `<< COMMENT ... COMMENT` are workarounds, not real comments.

---

### 4. Variables — Declaring, Using, and Quoting

```bash
# Declaring (no spaces around =)
NAME="Alice"

# Using variables
echo $NAME          # Basic usage               → Alice
echo "$NAME"        # Quoted — safe (PREFERRED) → Alice
echo '$NAME'        # Single quotes — literal   → $NAME
echo "${NAME}s"     # Curly braces — delimiter  → Alices

# Command substitution
TODAY=$(date +%F)
FILES=$(ls *.sh)

# Read-only variable
readonly PI=3.14159

# Unset a variable
unset NAME
```

---

### 5. Reading User Input — `read`

```bash
read NAME                            # Read into variable
read -p "Enter your name: " NAME     # With inline prompt
read -s -p "Password: " PASS         # Silent input (passwords)
read -t 10 -p "Timeout in 10s: " VAL # With timeout (returns exit 1 on timeout)
read -a ARRAY                        # Read into array (split on spaces)
read LINE                            # Read a full line
```

| Flag   | Purpose                        |
|--------|--------------------------------|
| `-p`   | Inline prompt (no echo needed) |
| `-s`   | Silent — hides typed input     |
| `-t N` | Timeout after N seconds        |
| `-a`   | Store input into an array      |
| `-r`   | Raw mode — no backslash escape |

---

### 6. Command-Line Arguments

```bash
#!/bin/bash
# Usage: ./script.sh Vaibhav Godse

echo "$0"   # Script name         → ./script.sh
echo "$1"   # First argument      → Vaibhav
echo "$2"   # Second argument     → Godse
echo "$#"   # Total arg count     → 2
echo "$@"   # All args (separate) → Vaibhav Godse
echo "$*"   # All args (string)   → Vaibhav Godse
echo "$?"   # Last exit code      → 0
echo "$$"   # Current script PID  → 12345
```

---

## Task 2: Operators and Conditionals

### 1. String Comparisons

```bash
[[ "$A" == "$B" ]]      # Equal
[[ "$A" != "$B" ]]      # Not equal
[[ -z "$A" ]]           # True if A is EMPTY (zero length)
[[ -n "$A" ]]           # True if A is NOT empty
[[ "$A" < "$B" ]]       # Alphabetically less than
[[ "$A" > "$B" ]]       # Alphabetically greater than
[[ "$A" =~ ^[0-9]+$ ]]  # Regex match (Bash only)
```

---

### 2. Integer Comparisons

```bash
[ "$A" -eq "$B" ]   # Equal
[ "$A" -ne "$B" ]   # Not equal
[ "$A" -lt "$B" ]   # Less than
[ "$A" -gt "$B" ]   # Greater than
[ "$A" -le "$B" ]   # Less than or equal
[ "$A" -ge "$B" ]   # Greater than or equal

# Arithmetic context (cleaner for numbers)
(( A == B ))
(( A > B ))
(( A++ ))
```

---

### 3. File Test Operators

```bash
[ -f "$FILE" ]       # Exists and is a regular file
[ -d "$DIR" ]        # Exists and is a directory
[ -e "$PATH" ]       # Exists (file or directory)
[ -r "$FILE" ]       # Readable
[ -w "$FILE" ]       # Writable
[ -x "$FILE" ]       # Executable
[ -s "$FILE" ]       # Exists and is NOT empty (size > 0)
[ -L "$FILE" ]       # Is a symbolic link
[ -p "$FILE" ]       # Is a named pipe (FIFO)
[ "$F1" -nt "$F2" ]  # F1 is newer than F2
[ "$F1" -ot "$F2" ]  # F1 is older than F2
```

---

### 4. `if` / `elif` / `else` Syntax

```bash
#!/bin/bash
read -p "Enter number: " NUM

if [ "$NUM" -gt 100 ]; then
  echo "Large"
elif [ "$NUM" -gt 50 ]; then
  echo "Medium"
elif [ "$NUM" -gt 0 ]; then
  echo "Small"
else
  echo "Zero or negative"
fi

# One-liner (short-circuit)
[ -f "/etc/hosts" ] && echo "File exists" || echo "Not found"
```

---

### 5. Logical Operators — `&&`, `||`, `!`

```bash
# AND — both must be true
if [ "$AGE" -ge 18 ] && [ "$AGE" -le 65 ]; then
  echo "Working age"
fi

# OR — at least one must be true
if [ "$OS" == "Linux" ] || [ "$OS" == "Mac" ]; then
  echo "Unix-like"
fi

# NOT
if ! [ -f "$FILE" ]; then
  echo "File does not exist"
fi

# Combining with [[ ]]
if [[ "$USER" == "root" && "$HOME" == "/root" ]]; then
  echo "Root user at home"
fi
```

---

### 6. Case Statements — `case ... esac`

```bash
#!/bin/bash
read -p "Day (Mon-Sun): " DAY

case "$DAY" in
  Mon|Tue|Wed|Thu|Fri)
    echo "Weekday"
    ;;
  Sat|Sun)
    echo "Weekend"
    ;;
  *)
    echo "Invalid day"
    ;;
esac

# Case with glob patterns
case "$FILE" in
  *.txt)  echo "Text file"    ;;
  *.sh)   echo "Shell script" ;;
  *.log)  echo "Log file"     ;;
  *.tar*) echo "Archive"      ;;
  *)      echo "Unknown type" ;;
esac
```

---

## Task 3: Loops

### 1. `for` Loop — List-Based and C-Style

```bash
# List-based
for NAME in Alice Bob Charlie; do
  echo "Hello, $NAME"
done

# Range {start..end}
for i in {1..5}; do
  echo "Count: $i"
done

# Range with step {start..end..step}
for i in {0..20..5}; do
  echo "$i"       # 0 5 10 15 20
done

# C-style: (( initializer; condition; increment ))
for (( i=0; i<10; i++ )); do
  echo "i = $i"
done

# Iterating an array
FRUITS=("apple" "banana" "cherry")
for fruit in "${FRUITS[@]}"; do
  echo "$fruit"
done
```

---

### 2. `while` Loop

```bash
# Basic
COUNT=1
while [ "$COUNT" -le 5 ]; do
  echo "Count: $COUNT"
  (( COUNT++ ))
done

# Infinite loop with break
while true; do
  read -p "Enter 'quit' to exit: " INPUT
  [ "$INPUT" == "quit" ] && break
  echo "You said: $INPUT"
done
```

---

### 3. `until` Loop

Runs **until** condition becomes true (opposite of `while`).

```bash
COUNT=1
until [ "$COUNT" -gt 5 ]; do
  echo "Count: $COUNT"
  (( COUNT++ ))
done
```

---

### 4. Loop Control — `break` and `continue`

```bash
for i in {1..10}; do
  [ "$i" -eq 3 ] && continue   # Skip iteration 3
  [ "$i" -eq 7 ] && break      # Stop loop at 7
  echo "$i"
done
# Output: 1 2 4 5 6
```

---

### 5. Looping Over Files — `for file in *.log`

```bash
# All .log files in current directory
for file in *.log; do
  echo "Processing: $file"
  wc -l "$file"
done

# Safely handle no matches with nullglob
shopt -s nullglob        # If no *.log exists, loop body is skipped entirely
for file in *.log; do
  echo "$file"
done
```

> **`shopt -s nullglob`:** Changes Bash's default behavior — if a wildcard like `*.log`
> finds no matches, the pattern is removed instead of passed as a raw string.

---

### 6. Looping Over Command Output — `while read line`

```bash
# Read a file line by line
# IFS= prevents stripping of leading/trailing whitespace
while IFS= read -r line; do
  echo "Line: $line"
done < /etc/passwd

# From command output (via pipe)
df -h | tail -n +2 | while IFS= read -r line; do
  echo "Filesystem: $line"
done

# Process substitution — avoids subshell (variables persist after loop)
while IFS= read -r line; do
  echo "$line"
done < <(find . -name "*.sh")
```

---

## Task 4: Functions

### 1. Defining and Calling a Function

```bash
#!/bin/bash

# Style 1: POSIX-compatible (preferred)
greet() {
  echo "Hello, World!"
}

# Style 2: Bash-specific keyword
function greet {
  echo "Hello, World!"
}

# Calling the function (must be defined before the call)
greet
```

---

### 2. Passing Arguments to Functions

```bash
greet_user() {
  local NAME="$1"
  local ROLE="$2"
  echo "Hello, $NAME! You are a $ROLE."
}

greet_user "Alice" "DevOps Engineer"
# Output: Hello, Alice! You are a DevOps Engineer.
```

---

### 3. Return Values — `return` vs `echo`

```bash
# return — sets exit code only (0–255), used for pass/fail
is_even() {
  (( $1 % 2 == 0 )) && return 0 || return 1
}
is_even 4 && echo "Even" || echo "Odd"

# echo — returns actual string data (capture with $())
get_hostname() {
  echo "$(hostname)"
}
HOST=$(get_hostname)
echo "Running on: $HOST"

# Global variable (avoid when possible)
RESULT=""
calculate() {
  RESULT=$(( $1 + $2 ))
}
calculate 10 20
echo "Sum: $RESULT"   # Output: Sum: 30
```

---

### 4. Local Variables — `local`

```bash
counter() {
  local COUNT=0           # Scoped to this function only
  COUNT=$(( COUNT + 1 ))
  echo "Inside: $COUNT"   # Output: Inside: 1
}

COUNT=100                 # Global variable
counter
echo "Outside: $COUNT"    # Output: Outside: 100 (unchanged)
```

---

### Practical Function — Logger

```bash
log() {
  local LEVEL="$1"
  local MSG="$2"
  echo "[$(date '+%F %T')] [$LEVEL] $MSG"
}

log "INFO"  "Script started"
log "WARN"  "Disk usage above 80%"
log "ERROR" "File not found"
```

---

## Task 5: Text Processing Commands

### 1. `grep` — Search Patterns

```bash
grep "error" app.log              # Basic search
grep -i "error" app.log           # Case-insensitive
grep -r "TODO" ./src/             # Recursive search
grep -n "error" app.log           # Show line numbers
grep -c "error" app.log           # Count matching lines
grep -v "DEBUG" app.log           # Invert match (exclude pattern)
grep -l "error" *.log             # List filenames with match only
grep -E "error|warn|crit" app.log # Extended regex (alternation)
grep -w "fail" app.log            # Whole word match only
grep -A 3 "error" app.log         # 3 lines After each match
grep -B 2 "error" app.log         # 2 lines Before each match
grep -C 2 "error" app.log         # 2 lines Context (before + after)
```

---

### 2. `awk` — Column Processing

```bash
awk '{print $1}' file                          # Print first column
awk '{print $1, $3}' file                      # Print columns 1 and 3
awk -F: '{print $1}' /etc/passwd               # Colon field separator
awk -F, '{print $2}' data.csv                  # CSV second column
awk 'NR==5' file                               # Print line 5 only
awk 'NR>=2 && NR<=5' file                      # Print lines 2–5
awk '{sum += $1} END {print sum}' nums.txt     # Sum a column
awk 'length($0) > 80' file                     # Lines longer than 80 chars
awk '$3 > 1000 {print $1, $3}' file            # Filter by field value
awk 'BEGIN {print "Start"} {print} END {print "End"}' file
awk '/error/ {count++} END {print count}' app.log  # Count error lines
```

---

### 3. `sed` — Stream Editor

```bash
sed 's/old/new/' file             # Replace first occurrence per line
sed 's/old/new/g' file            # Replace ALL occurrences
sed 's/old/new/gi' file           # Case-insensitive replace all
sed -i 's/foo/bar/g' config.txt   # In-place edit (modifies file)
sed -i.bak 's/foo/bar/g' file     # In-place with .bak backup
sed '5d' file                     # Delete line 5
sed '/pattern/d' file             # Delete lines matching pattern
sed -n '5,10p' file               # Print only lines 5–10
sed -n '/start/,/end/p' file      # Print between two patterns
sed 's/^/PREFIX: /' file          # Add prefix to every line
sed 's/$/ SUFFIX/' file           # Add suffix to every line
sed '/^$/d' file                  # Remove blank lines
```

---

### 4. `cut` — Extract Columns

```bash
cut -d: -f1 /etc/passwd           # Field 1, colon delimiter
cut -d, -f2,4 data.csv            # Fields 2 and 4, CSV
cut -c1-10 file                   # Characters 1–10
cut -d' ' -f1 file                # First word, space delimiter
cut -d$'\t' -f3 tsv_file          # Tab-delimited, field 3
```

---

### 5. `sort` — Sort Lines

```bash
sort file                         # Alphabetical (ascending)
sort -r file                      # Reverse order
sort -n file                      # Numerical sort
sort -rn file                     # Numerical, descending
sort -k2 file                     # Sort by column 2
sort -t: -k3 -n /etc/passwd       # Sort by UID (field 3, : delim)
sort -u file                      # Sort and remove duplicates
sort file | uniq                  # Explicit deduplication
```

---

### 6. `uniq` — Deduplicate

```bash
uniq file                         # Remove consecutive duplicates
sort file | uniq                  # Deduplicate (sort first!)
uniq -c file                      # Count occurrences
sort file | uniq -d               # Show only duplicated lines
sort file | uniq -u               # Show only unique lines
```

---

### 7. `tr` — Translate / Delete Characters

```bash
echo "hello" | tr 'a-z' 'A-Z'    # Uppercase
echo "HELLO" | tr 'A-Z' 'a-z'    # Lowercase
echo "hello world" | tr ' ' '_'  # Replace spaces with underscores
echo "abc123" | tr -d '0-9'       # Delete all digits
echo "aabbcc" | tr -s 'a-z'       # Squeeze repeated characters
cat file | tr -d '\r'             # Remove Windows CRLF endings
echo "a:b:c" | tr ':' '\n'        # Replace : with newlines
```

---

### 8. `wc` — Word / Line / Char Count

```bash
wc -l file                        # Line count
wc -w file                        # Word count
wc -c file                        # Byte count
wc -m file                        # Character count
wc file                           # All: lines, words, bytes
wc -l *.log                       # Line counts for all .log files
cat file | wc -l                  # Pipe usage
```

---

### 9. `head` / `tail` — First / Last N Lines

```bash
head file                         # First 10 lines (default)
head -n 20 file                   # First 20 lines
head -c 100 file                  # First 100 bytes

tail file                         # Last 10 lines
tail -n 50 file                   # Last 50 lines
tail -f /var/log/syslog           # Follow mode (live updates)
tail -F /var/log/app.log          # Follow + reopen if log rotated
tail -n +5 file                   # Skip first 4 lines, print rest
```

---

## Task 6: Useful Patterns and One-Liners

```bash
# 1. Find and delete files older than 30 days
find /var/log -name "*.log" -mtime +30 -delete

# 2. Count total lines across all .log files
find . -name "*.log" | xargs wc -l | tail -1

# 3. Replace a string across multiple files (in-place)
find . -name "*.conf" -exec sed -i 's/localhost/prod-server/g' {} \;
grep -rl "localhost" . | xargs sed -i 's/localhost/prod-server/g'

# 4. Check if a service is running, restart if not
systemctl is-active --quiet nginx || systemctl restart nginx

# 5. Monitor disk usage and alert if above 80%
df -h | awk 'NR>1 {gsub(/%/,"",$5); if($5+0 > 80) print "ALERT: "$6" at "$5"%"}'

# 6. Parse a CSV and print specific fields
awk -F',' '{print $1, $3}' data.csv

# 7. Tail a log and filter for errors in real time
tail -f /var/log/app.log | grep --line-buffered -i "error\|warn\|crit"

# 8. Extract and rank IP addresses from a log file
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' access.log | sort | uniq -c | sort -rn

# 9. Get top 10 most frequent lines in a log
sort access.log | uniq -c | sort -rn | head -10

# 10. Kill all processes matching a name
pkill -f "python app.py"
ps aux | grep "app.py" | grep -v grep | awk '{print $2}' | xargs kill

# 11. Archive and compress logs with a date stamp
tar -czf "logs_$(date +%F).tar.gz" /var/log/app/*.log

# 12. Download a file and verify checksum
curl -sO https://example.com/file.tar.gz && md5sum -c file.tar.gz.md5

# 13. Recursively find files larger than 100MB
find / -type f -size +100M 2>/dev/null

# 14. Show all open listening ports
ss -tlnp           # Modern (preferred)
netstat -tlnp      # Legacy

# 15. Parse JSON from command line
curl -s https://api.example.com/data | jq '.users[].name'
grep -o '"name":"[^"]*"' response.json | cut -d'"' -f4   # without jq
```

---

## Task 7: Error Handling and Debugging

### 1. Exit Codes — `$?`, `exit 0`, `exit 1`

Every command returns an exit code: **0 = success**, **non-zero = failure**.

```bash
#!/bin/bash
ls /etc/hosts
echo "Exit code: $?"        # 0 — success

ls /nonexistent
echo "Exit code: $?"        # 2 — failure

# Conventional exit codes
exit 0     # Success
exit 1     # General error
exit 2     # Misuse of shell command
exit 127   # Command not found

# Checking exit code with if
if ! cp source.txt dest.txt; then
  echo "Copy failed" >&2
  exit 1
fi

# Short-circuit style
mkdir /tmp/mydir && echo "Created!" || echo "Failed!"
```

| Code  | Meaning                 |
|-------|-------------------------|
| `0`   | Success                 |
| `1`   | General error           |
| `2`   | Misuse of shell command |
| `126` | Command not executable  |
| `127` | Command not found       |
| `130` | Terminated by Ctrl+C    |

---

### 2. `set -e` — Exit on Error

Without `set -e`, a script keeps running even after a command fails.
With `set -e`, the script **stops immediately** on the first error.

```bash
# Without set -e (dangerous)
#!/bin/bash
cp nonexistent.txt /tmp/         # fails silently
echo "This still runs!"          # still executes — BAD

# With set -e (safe)
#!/bin/bash
set -e
echo "Step 1: Starting..."
cp nonexistent.txt /tmp/         # script exits here
echo "Step 2: Never reached"

# Allow a known-failing command with || true
grep "pattern" file.txt || true  # won't kill the script
```

---

### 3. `set -u` — Treat Unset Variables as Error

Without `set -u`, unset variables silently expand to empty string — can cause destructive bugs.

```bash
# Without set -u (dangerous)
#!/bin/bash
DIR=""
rm -rf $DIR/    # expands to: rm -rf /  <- CATASTROPHIC

# With set -u (safe)
#!/bin/bash
set -u
echo "$UNDEFINED_VAR"   # Error: unbound variable — script exits

# Provide safe defaults with :-
NAME="${1:-Guest}"       # Use "Guest" if $1 is not provided
PORT="${PORT:-8080}"     # Use 8080 if $PORT is not set
```

---

### 4. `set -o pipefail` — Catch Errors in Pipes

By default, a pipeline's exit code is the **last command's** exit code only.
Earlier failures in the pipeline are silently swallowed.

```bash
# Without pipefail (misleading)
#!/bin/bash
set -e
grep "ghost" /etc/hosts | sort   # grep fails but sort succeeds
echo "Exit: $?"                  # 0 — looks fine, but grep failed!

# With pipefail (correct)
#!/bin/bash
set -e
set -o pipefail
grep "ghost" /etc/hosts | sort   # pipeline exit code = grep's exit code (1)
echo "This won't run"            # script already exited
```

---

### 5. `set -x` — Debug Mode (Trace Execution)

Prints **every command before executing it**, prefixed with `+`.

```bash
#!/bin/bash
set -x

NAME="Alice"
echo "Hello, $NAME"
ls /tmp | head -3
```

**Output:**
```
+ NAME=Alice
+ echo 'Hello, Alice'
Hello, Alice
+ ls /tmp
+ head -3
```

```bash
# Enable/disable trace for a specific section only
set -x
DB_HOST="localhost"
psql -h "$DB_HOST" -U admin mydb
set +x                        # disable trace

# Run debug without modifying the script
bash -x script.sh             # trace execution
bash -v script.sh             # print lines as read
bash -n script.sh             # syntax check only (no execution)
```

---

### 6. `trap` — Run Cleanup on Exit

Intercepts **signals and exit events** to run cleanup code — even on crash or Ctrl+C.

```bash
# Syntax
trap 'command_or_function' SIGNAL
```

| Signal | Triggered When               |
|--------|------------------------------|
| `EXIT` | Any exit (normal or error)   |
| `INT`  | Ctrl+C                       |
| `TERM` | `kill` command               |
| `ERR`  | Any command returns non-zero |

```bash
# Basic cleanup on exit
#!/bin/bash
TMP_FILE=$(mktemp)
LOCK_FILE="/tmp/myscript.lock"

cleanup() {
  echo "Cleaning up..."
  rm -f "$TMP_FILE" "$LOCK_FILE"
}

trap cleanup EXIT          # runs on any exit
touch "$LOCK_FILE"
echo "Working..." > "$TMP_FILE"
cat "$TMP_FILE"
```

```bash
# Trap Ctrl+C (INT)
trap 'echo ""; echo "Interrupted! Exiting..."; exit 1' INT

# Trap ERR — report which line failed
trap 'echo "ERROR at line $LINENO"' ERR
```

---

### Recommended Production Script Header

```bash
#!/usr/bin/env bash
# Safety flags
set -euo pipefail

# Traps
trap 'echo "ERROR at line $LINENO -- exit code $?" >&2' ERR
trap 'rm -rf "$TMP_DIR"' EXIT

# Globals
TMP_DIR=$(mktemp -d)
SCRIPT_NAME=$(basename "$0")

# Logging helpers
log()  { echo "[$(date '+%F %T')] [INFO]  $*"; }
err()  { echo "[$(date '+%F %T')] [ERROR] $*" >&2; }
warn() { echo "[$(date '+%F %T')] [WARN]  $*"; }
```

| Flag              | Protection                              |
|-------------------|-----------------------------------------|
| `set -e`          | Stop immediately on any error           |
| `set -u`          | No silent empty/unset variables         |
| `set -o pipefail` | No hidden failures inside pipelines     |
| `trap ERR`        | Know exactly which line broke           |
| `trap EXIT`       | Always clean up temp files / lock files |

---

## Appendix A: Special Variables

| Variable        | Meaning                                     |
|-----------------|---------------------------------------------|
| `$0`            | Script name                                 |
| `$1` – `$9`     | Positional arguments                        |
| `$#`            | Number of arguments passed                  |
| `$@`            | All arguments (separate words)              |
| `$*`            | All arguments (single string)               |
| `$?`            | Exit code of last command                   |
| `$$`            | PID of current script                       |
| `$!`            | PID of last background process              |
| `$_`            | Last argument of previous command           |
| `$IFS`          | Internal field separator (space/tab/newline)|
| `$LINENO`       | Current line number in script               |
| `$RANDOM`       | Random integer between 0–32767              |
| `$SECONDS`      | Seconds elapsed since script started        |
| `$BASH_VERSION` | Bash version string                         |
| `$HOME`         | Home directory of current user              |
| `$PWD`          | Current working directory                   |
| `$OLDPWD`       | Previous working directory                  |
| `$PATH`         | Executable search path                      |

---

## Appendix B: Redirection Cheat Sheet

```bash
command > file           # Redirect stdout to file (overwrite)
command >> file          # Redirect stdout to file (append)
command < file           # Use file as stdin
command 2> file          # Redirect stderr to file
command 2>&1             # Redirect stderr to stdout
command &> file          # Redirect both stdout and stderr to file
command > /dev/null      # Discard stdout
command &> /dev/null     # Discard all output
command1 | command2      # Pipe stdout to next command
command1 |& command2     # Pipe stdout AND stderr (Bash 4+)
```

---

