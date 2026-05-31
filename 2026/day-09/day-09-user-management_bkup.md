# Day 09 Challenge

Task 1: Create Users

- create users(tokyo, berlin, professor, nairobi) and set password.

`sudo useradd -m tokyo`
`sudo useradd -m berlin`
`sudo useradd -m professor`
`sudo useradd -m nairobi`

![useradd](images/useradd.png)
![see user](images/see_users.png)

`sudo passwd tokyo`
`sudo passwd berlin`
`sudo passwd professor`

![password](images/password.png)

Task 2: Create Groups

- create the developers, admins and project-team  groups

'sudo groupadd developers'
'sudo groupadd admins'
'sudo groupadd project-team'

![groupadd](images/groupadd.png)
![see groups](images/see_groups.png)

Task 3: Assign users to group

- assign tokyo to developers.
`sudo gpasswd -a tokyo developers`
- assign berlin to both developers and admins
`sudo gpasswd -a berlin developers`
`sudo gpasswd -a berlin admin`
- assign professor to admins
`sudo gpasswd -a professor admins`

![assign groups](images/assign_groups1.png)
![assign groups](images/assign_groups2.png)

Task 4: Shared Directory

- set up a shared directory workspace for developers

1 - create a directory /opt/dev-project
`mkdir -p /opt/dev-project`
2 - change group ownership to developers
`chgrp developers /opt/dev-project`
3 - set permissions to 775 (rwxrwxr-x)
`chmod 755 /opt/dev-project`
4 -test file creation as tokyo and berlin
`sudo -u tokyo touch /opt/dev-project/tokyo_file.txt`
`sudo -u berlin touch /opt/dev-project/berlin_file.txt`

![shared directory](images/shared_directory.png)


Task 5: Team workspace

- setup a secondary workspace for new project-team

1 - create user nairobi with home directory(created in task 1)
2 - create group project-team
`sudo groupadd project-team`
3 - add nairobi and tokyo to project-team
`sudo usermod -aG project-team nairobi`
`sudo usermod -aG project-team tokyo`
4 - create the workspace directory
`sudo mkdir -p /opt/team-workspace`
5 - set group ownership and 755 permissions
`sudo chgrp project-team /opt/team-workspace`
`sudo chmod 755 /opt/team-workspace`
6 - test file creation as nairobi
`sudo -u nairobi touch /opt/team-workspace/nairobi_file.txt`

![team workspace](images/team_workspace.png)





OVERALL:


## Users & Groups Created
- **Users:** tokyo, berlin, professor, nairobi
- **Groups:** developers, admins, project-team

## Group Assignments
- `tokyo`: developers, project-team
- `berlin`: developers, admins
- `professor`: admins
- `nairobi`: project-team

## Directories Created
- `/opt/dev-project` -> Group: `developers`, Permissions: `775` (`rwxrwxr-x`)
- `/opt/team-workspace` -> Group: `project-team`, Permissions: `775` (`rwxrwxr-x`)

## Commands Used
- `useradd -m <username>`: Creates a user with a home directory.
- `passwd <username>`: Sets or updates user passwords.
- `groupadd <groupname>`: Creates a new user group.
- `usermod -aG <groups> <username>`: Appends a user to specified secondary groups.
- `chgrp <group> <path>`: Changes group ownership of a directory/file.
- `chmod <permissions> <path>`: Changes read/write/execute permissions.
- `sudo -u <username> <command>`: Executes a command simulating another user's context.

## What I Learned
1. **The Importance of `-aG`**: Always use `-a` (append) alongside `-G` with `usermod`, otherwise you risk accidentally removing the user from all their other existing supplementary groups.
2. **Shared Collaboration Permissions (`775`)**: Setting a directory to `775` allows members of the owning group to actively create and modify files in a shared space, while blocking unauthorized external users from changing them.
3. **Simulating Contexts with `sudo -u`**: Testing configuration files or permissions by switching contexts directly via `sudo -u` is much faster than continuously logging in and out of different SSH user profiles.
