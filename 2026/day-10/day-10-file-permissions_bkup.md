
Task 1: Create Files

# 1. Create empty file
touch devops.txt

# 2. Create notes.txt with content
echo "Learning Linux file permissions today!" > notes.txt

# 3. Create script.sh with content using vim (or echo for speed)
echo 'echo "Hello DevOps"' > script.sh

# Verify initial permissions
ls -l devops.txt notes.txt script.sh

![snapshot](images/task1.png)

Task 2: Read Files (10 minutes)

# 1. Read notes.txt
cat notes.txt

# 2. View script.sh in vim read-only mode
vim -R script.sh  # Type :q to exit

![snapshot](images/task2_1.png)

# 3. Display first 5 lines of /etc/passwd
head -n 5 /etc/passwd

# 4. Display last 5 lines of /etc/passwd
tail -n 5 /etc/passwd

![snapshot](images/task2.png)

Task 3 and 4: Understand and Modify Permissions.

Format: rwxrwxrwx (owner-group-others)
r = read (4), w = write (2), x = execute (1)
Check your files: ls -l devops.txt notes.txt script.sh

# 1. Make script.sh executable and run it
chmod +x script.sh
./script.sh

# 2. Set devops.txt to read-only (remove write permission for user, group, and others)
chmod a-w devops.txt

# 3. Set notes.txt to 640 (owner: rw-, group: r--, others: ---)
chmod 640 notes.txt

# 4. Create directory project/ with 755 permissions (drwxr-xr-x)
mkdir project
chmod 755 project

# Verify changes
ls -l

![snapshot](images/lsusers.png)

Task 4: Modify Permissions (20 minutes)

Make script.sh executable → run it with ./script.sh
Set devops.txt to read-only (remove write for all)
Set notes.txt to 640 (owner: rw, group: r, others: none)
Create directory project/ with permissions 755
Verify: ls -l after each change

![snapshot](images/task4.png)

Task 5: Test Permissions (10 minutes)

Try writing to a read-only file - what happens?
Try executing a file without execute permission
Document the error messages

![snapshot](images/task5.png)


What I Learned
- Absolute vs Symbolic Notation: Learned how to change permissions both via octal numbers (like 640) and characters (like +x, a-w).

- The Permission Triad: Understood how permissions split cleanly into three distinct groups: Owner, Group, and Others.

- Security Safeguards: Witnessed firsthand how the Linux kernel actively enforces file security rules by rejecting actions that violate defined permission bits.
