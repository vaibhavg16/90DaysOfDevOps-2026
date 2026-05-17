-----------------------------------------
🏛️ Core Components of Linux Architecture
-----------------------------------------

1. Hardware: The physical execution layer consisting of the CPU, RAM, storage blocks (SSD/HDD), and network interface cards (NICs).

2. Kernel: It is heart of linux operating system. It operates in Kernel Space and holds absolute privilege over hardware abstraction, process scheduling, memory allocation, and device communication. It translates high-level software requests into low-level machine instructions.

3. System Libraries: Special standardized collections of pre-written functions. They provide the necessary application programming interfaces (APIs) that user-space software utilizes to safely trigger systemic system calls (syscalls) to the kernel.

4. Shell: The command-line interpreter interface. It accepts user-inputted strings (commands), syntactically parses them, translates them into system call instructions, and passes them to the kernel.

5. System Utilities: Specialized single-purpose software binaries (like ls, grep, cp) operating in User Space that allow administrators to interact with the file system, manage user privileges, and configure environment variables.

6. GUI (Graphical User Interface): Graphical user interface for visual interaction.

-------------------------------
🔄 Process Management in Linux
-------------------------------
A Process is an active, isolated instance of an executable program loaded into the system's volatile memory (RAM). When a binary or script is called—such as ping google.com—the kernel allocates a unique identity identifier known as a PID (Process ID) alongside dedicated memory blocks.

Administrators trace, monitor, and profile these execution blocks using systemic tracking tools like ps, top, or htop.

The 4 Crucial Process States:

1. Running / Runnable (R): The process is either currently occupying CPU cycles executing instruction sets, or sits directly in the CPU scheduling queue waiting for its allocated time slice.

2. Sleeping (S / D): The process is paused, waiting for an external event, resource allocation, or an I/O operation to finish.

3. Interruptible Sleep (S): Can be woken up prematurely by system signals.

4. Uninterruptible Sleep (D): Directly blocked by critical hardware I/O operations and cannot be interrupted safely.

5. Stopped (T): The process lifecycle has been explicitly suspended by a control signal—most commonly SIGTSTP (triggered via Ctrl + Z in your terminal) or an administrative SIGSTOP.The process is frozen in memory and consumes zero CPU cycles until the kernel issues a SIGCONT (Continue) signal to resume it.

6. Zombie (Z): A dead or terminated process that has finished execution. However, its metadata entry remains allocated in the kernel's process table because its parent process hasn't successfully executed the wait() system call to read its exit status code.

--------------------------------------
What systemd does and why it matters?
--------------------------------------

⚡ What it does:
When you press the power button on your machine, the kernel starts up first, initializes your hardware, and then hands absolute control over to exactly one program. That program is systemd. It has a Process ID of 1 (PID 1), making it the parent or ancestor of every single process that runs on your server.

🚀 Why it matters:
Self-Healing: If a critical web server or container crashes in the middle of the night, systemd catches it and instantly restarts it automatically.

Universal Control (systemctl): It gives you a single command to start, stop, or check any application (e.g., sudo systemctl restart docker).

Clean Logging (journalctl): It forces all background applications to send their error and output logs to one central, searchable location.

Dependency Smart: It makes sure services start in the right order (for example, ensuring your Database boots up successfully before your Web App tries to connect to it).

-----------------------------------------
🛠️ 5 Core System Administration Commands
-----------------------------------------
1. cp & mv (The Organizers): Copies or moves files and folders.

2. mkdir & rm (The Creators & Destroyers): mkdir -p creates nested directories safely; rm -rf forcefully and recursively removes files or directories.

3. ls (The Directory Inspector): Lists directory contents. You will almost always use it as ls -la to show hidden files (like .env or .git) and file permissions.

4. cd & pwd (The Navigators): cd changes your working directory; pwd prints the absolute path of your current directory.

5. cat, less, & tail (The Log Viewers): cat dumps file contents; less allows interactive scrolling; tail -f streams the end of a file in real-time.

