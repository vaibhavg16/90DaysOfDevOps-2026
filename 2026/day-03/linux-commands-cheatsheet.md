Linux Commands Cheatsheet

----------------------------
Process Management Commands:
----------------------------

1. ps(Process Status): Provides a snapshot of currently active processes.

Flags:
    a : Selects all processes running on any terminal.
    u : Displays user-oriented format (CPU, memory, user ownership).
    x : Includes processes without a controlling terminal (like background daemons).
    -e : Selects all processes on the system.
    -o : Limits output to custom-defined columns.

2. top (Table of Processes): Displays a real-time, dynamic view of running processes, sorted by CPU usage by default.

Flags:
    -d [seconds] : Delay time between screen updates.
    -u [username] : Filters the view to a specific user's processes.
    -p [PID] : Tracks only a specific Process ID.
    -b : Runs in batch mode (non-interactive, ideal for logging).
    -n [number] : Number of iterations before exiting (used with -b).

3. htop (Interactive Process Viewer): An enhanced, color-coded, and user-friendly version of top that allows scrolling and killing processes directly from the UI.

Flags:
    -d [tenths of seconds] : Set the update interval.
    -u [username] : Display only the processes of a specified user.
    -p [PIDs] : Monitor only the specified PIDs (comma-separated).

4. pstree (Process Tree): Shows running processes as a tree structure, visually demonstrating parent-child relationships.

Flags:
    -p : Show PIDs alongside the process names.
    -a : Show command-line arguments for each running process.
    -h : Highlight the current process and its ancestors.

5. pgrep (Process Grep): Searches for processes based on name or other attributes and returns their PIDs.

Flags:
    -l : List the process name along with its PID.
    -a : List the full command-line arguments along with the PID.
    -u [username] : Restrict matches to processes owned by a specific user.

6. pidof (PID of a program): Finds the exact process ID of a running program by its exact name.

Flags:
    -s : Single shot; returns only one PID even if multiple instances exist.
    -x : Returns PIDs of shells running named scripts.

--------------------------
Linux File System commands
--------------------------

1. pwd (Print Working Directory): Displays the absolute path of the current working directory.

Flags:
    -P : Prints the physical directory structure, avoiding symbolic links.

2. cd (Change Directory): Changes the current shell working directory.

3. ls (List): Lists directory contents.

Flags:
    -l : Uses a long listing format (shows permissions, owner, size, and modification date).
    -a : Includes hidden files (those starting with a dot .).
    -h : Human-readable format.
    -r : arrange in order by name.
    -t : Sorts files by modification time, newest first.

4. mkdir (Make Directory): Creates one or more directories.

Flags:
    -p : Parent flag; creates nested parent directories automatically if they don't exist without throwing an error.
    -m : Sets the file mode (permissions) for the directory at creation time.

5. rmdir (Remove Empty Directory): Removes empty directories from the file system.

Flags:
    -p : Removes the directory and its ancestors if they also become empty as a result.

6. touch (Update Timestamp / Create File): Creates an empty file instantly, or updates the access/modification timestamps of an existing file.

7. cp (Copy): Copies files or directories from a source to a destination.

Flags:
    -r or -R : Recursive copy (required when copying directories and their contents).

Examples:

cp config.env config.env.bak — Create a quick backup copy of a configuration file.
cp -r /app/src /app/dist — Copy the entire src directory structure into a new folder named dist.

8. mv (Move / Rename): Moves files or directories to a different location, or renames them if the path remains the same.

Flags:
    -i : Interactive mode; prompts before overwriting an existing file at the destination.
    -n : No-clobber; prevents overwriting any existing files.

9. rm (Remove): Deletes files or directories.

Flags:
    -r : Recursive; deletes directories and all their underlying contents.
    -f : Force; ignores nonexistent files and never prompts for confirmation.

10. cat (Concatenate and Display): Reads files sequentially and writes them to standard output (prints them to the screen).

Flags:
    -n : Number lines; displays line numbers along the left margin.

11. head & tail (Output File Extremities): head shows the beginning lines of a file; tail shows the ending lines.

12. grep (Global Regular Expression Print): Searches text files for patterns matching a regular expression.

Flags:
    -i : Case-insensitive matching.
    -r : Recursive search through all files in a directory tree.
    -n : Prints the line number where the match was located.

13. find (Search for Files): Searches the file system hierarchy for files and directories based on real-time criteria like name, size, type, or age.

Flags/Expressions:
    -name : Search by filename (supports wildcards).
    -type : Limit results to specific types (e.g., f for files, d for directories).

--------------------------
Networking troubleshooting
--------------------------

1. ping (Packet Internet Groper): Check connectivity & delay 

2. traceroute / tracert (Trace Route): Tracks and displays the hop-by-hop path that network packets take to reach a destination, showing the response time of each intermediary router.

3. ifconfig / ip / ipconfig (Interface Configuration): Examine or adjust IP settings.

4. arp (Address Resolution Protocol): Displays and manipulates the local ARP cache, which maps Layer 3 network IP addresses to Layer 2 physical MAC addresses.

5. netstat (Network Statistics): Shows active network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.

6. nslookup(name server Lookup): Interrogates DNS servers to resolve domain names to IP addresses or vice versa, and queries specific domain records.

7. nmap (Network Mapper): An advanced network security scanner used for network discovery, target auditing, and open port vulnerability mapping.

8. whoami / hostname / systeminfo (System Identity Suite): Discovers running security credentials, node host configuration titles, and full operating environment architecture specs.

whoami — Discover the active user identity.

hostname — Output the precise system designation label registered on the local network.

9.  tcpdump / wireshark (Network Packet Analyzers): Captures, parses, and logs raw data packet streams passing through a chosen system network adapter interface layer for deep diagnostics.
