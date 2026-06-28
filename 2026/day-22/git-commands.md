# Git Commands Reference
> Updated daily as I learn new commands

---

## Setup & Config

| Command | What it does |
|---|---|
| `git --version` | Check installed Git version |
| `git config --global user.name "Name"` | Set your name for all commits |
| `git config --global user.email "email"` | Set your email for all commits |
| `git config --list` | View all current Git configuration |

## Basic Workflow

| Command | What it does |
|---|---|
| `git init` | Initialize a new Git repository in current folder |
| `git add <file>` | Stage a specific file for commit |
| `git add .` | Stage ALL changed files |
| `git commit -m "message"` | Save staged changes with a message |
| `git status` | Show current state of working directory and staging area |

## Viewing Changes

| Command | What it does |
|---|---|
| `git log` | Show full commit history |
| `git log --oneline` | Compact one-line commit history |
| `git diff` | Show changes not yet staged |
| `git diff --staged` | Show changes that are staged (ready to commit) |

## Branching

| Command | What it does |
|---|---|
| `git branch` | List all local branches |
| `git branch <name>` | Create a new branch |
| `git checkout <branch>` | Switch to a branch |
| `git checkout -b <name>` | Create and switch to a new branch |
| `git merge <branch>` | Merge a branch into the current one |
| `git branch -d <name>` | Delete a branch (safe — won't delete unmerged) |

## Remote Repositories

| Command | What it does |
|---|---|
| `git remote add origin <url>` | Connect local repo to a remote (GitHub) |
| `git remote -v` | View connected remote repositories |
| `git push origin main` | Push commits to the remote main branch |
| `git pull` | Fetch and merge changes from remote |
| `git clone <url>` | Copy a remote repository to your machine |
| `git fetch` | Download changes from remote but don't merge yet |

## Undoing Changes

| Command | What it does |
|---|---|
| `git restore <file>` | Discard changes in working directory (unstaged) |
| `git restore --staged <file>` | Unstage a file (remove from staging area) |
| `git revert <commit>` | Create a new commit that undoes a previous one (safe) |
| `git reset --soft HEAD~1` | Undo last commit, keep changes staged |
| `git reset --hard HEAD~1` | Undo last commit and discard all changes (DANGEROUS) |


