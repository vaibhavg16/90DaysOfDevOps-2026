# Git Hands-On Practice 


# Task 1: Git Merge — Hands-On

## Step 1: Create `feature-login` and add commits

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout -b feature-login
Switched to a new branch 'feature-login'

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "login" >> app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git add app.py && git commit -m "Add login function"
[feature-login 79883c3] Add login function
 1 file changed, 1 insertion(+)
 create mode 100644 app.py

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "def validate();" >> app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git add app.py && git commit -m "Add validate function"
[feature-login b93435d] Add validate function
 1 file changed, 1 insertion(+)
```

## Step 2: Switch to `main` and view history before merging

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline --graph --all
* b93435d (feature-login) Add validate function
* 79883c3 Add login function
*   c1b8473 (HEAD -> main, origin/main) final file
|\
| * 91913d2 Reorder git reset command entry in documentation
| * 6a26d0c Add additional line to git-commands.md
* | 52f4635 final file
|/
| * 1ff8e38 (origin/feature-1, feature-1) Added hello.txt on feature-1
|/
* 440b0fb Edited
```

**Reading the graph:** `feature-login`'s commits sit directly on top of `main` — `main` hasn't moved since the branch was created, so Git can do a **fast-forward merge**.

## Step 3: Merge `feature-login` → Fast-Forward

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git merge feature-login
Updating c1b8473..b93435d
Fast-forward
 app.py | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 app.py
```

**Key word: `Fast-forward`** — Git simply moved the `main` pointer forward to `b93435d`. No merge commit was created.

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline --graph --all
* b93435d (HEAD -> main, feature-login) Add validate function
* 79883c3 Add login function
*   c1b8473 (origin/main) final file
...
```

Both `main` and `feature-login` now point to the same commit. History stays a straight line — no diamond, no merge commit.

## Step 4: Create `feature-signup` — and also commit on `main`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout -b feature-signup
Switched to a new branch 'feature-signup'

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "def confirm_email(): pass" >> app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git add app.py && git commit -m "Add confirm email function"
[feature-signup 8cf6be2] Add confirm email function
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 2 commits.

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# security patch applied" >> app.py && git add app.py && git commit -m "Add security patch on main"
[main a93e5a7] Add security patch on main
 1 file changed, 1 insertion(+)
```

### Diverged history

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline --graph --all
* a93e5a7 (HEAD -> main) Add security patch on main
| * 8cf6be2 (feature-signup) Add confirm email function
|/
* b93435d (feature-login) Add validate function
* 79883c3 Add login function
...
```

Both branches now have new commits since they diverged — Git **cannot fast-forward**. It must create a merge commit.

## Step 5: Merge `feature-signup` → Merge Conflict!

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git merge feature-signup
Auto-merging app.py
CONFLICT (content): Merge conflict in app.py
Automatic merge failed; fix conflicts and then commit the result.
```

### Conflict markers

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ cat app.py
login
def validate();
<<<<<<< HEAD
# security patch applied
=======
def confirm_email(): pass
>>>>>>> feature-signup
```

```
<<<<<<< HEAD
# security patch applied        ← YOUR version (main)
=======                         ← divider
def confirm_email(): pass       ← INCOMING version (feature-signup)
>>>>>>> feature-signup
```

### Resolving

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ vim app.py
```
*(deleted the conflict markers, kept both lines)*

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ cat app.py
login
def validate();

# security patch applied
```

### Completing the merge

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git add app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git commit -m "Resolve merge conflict in app.py"
[main 8bdeb75] Resolve merge conflict in app.py

vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Your branch is ahead of 'origin/main' by 5 commits.
nothing to commit, working tree clean
```

## Notes — Task 1

**What is a fast-forward merge?**
Happens when the branch being merged has commits sitting directly on top of the target branch (target hasn't moved since branching). Git just slides the branch pointer forward — no merge commit, no history diamond.

```
Before:  main → A → B
                      \
               feature → C → D

After FF: main → A → B → C → D
```

**When does Git create a merge commit instead?**
When both branches have new commits since they diverged. Git can't just move the pointer — it creates a commit with **two parents**, one from each branch, shown as a diamond (`|\` and `|/`) in `git log --graph`.

**What is a merge conflict?**
Happens when both branches edited the *same line* of the *same file* differently. Git inserts `<<<<<<<`, `=======`, `>>>>>>>` markers and pauses. To resolve: edit the file, remove all markers, `git add <file>`, then `git commit`.

---

# Task 2: Git Rebase — Hands-On

## Step 1: Create `feature-dashboard` and add a commit

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout -b feature-dashboard
Switched to a new branch 'feature-dashboard'

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "def dashboard(): pass" >> app.py && git add . && git commit -m "Add dashboard"
[feature-dashboard 94a49bf] Add dashboard
 1 file changed, 1 insertion(+)
```

## Step 2: Go back to `main` and add a new commit there

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 5 commits.

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# changelog" > CHANGELOG.md && git add . && git commit -m "Add changelog"
[main a9e1993] Add changelog
 1 file changed, 1 insertion(+)
 create mode 100644 CHANGELOG.md
```

## Step 3: Diverged history BEFORE rebase

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline --graph --all
* a9e1993 (HEAD -> main) Add changelog
| * 94a49bf (feature-dashboard) Add dashboard
|/
*   8bdeb75 Resolve merge conflict in app.py
...
```

```
* a9e1993  ← main moved ahead (Add changelog)
| * 94a49bf  ← feature-dashboard has its own commit (Add dashboard)
|/
* 8bdeb75  ← common ancestor
```

Same situation as the Task 1 conflict — this time we resolve divergence with **rebase**.

## Step 4: Switch to `feature-dashboard` and rebase onto `main`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout feature-dashboard
Switched to branch 'feature-dashboard'

vaibhav@Asus-Vivobook:~/devops-git-practice$ git rebase main
Successfully rebased and updated refs/heads/feature-dashboard.
```

No conflict — different files changed (`app.py` vs `CHANGELOG.md`), so Git replayed the commit cleanly.

## Step 5: History AFTER rebase

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline --graph --all
* 3695fe0 (HEAD -> feature-dashboard) Add dashboard
* a9e1993 (main) Add changelog
*   8bdeb75 Resolve merge conflict in app.py
|\
| * 8cf6be2 (feature-signup) Add confirm email function
* | a93e5a7 Add security patch on main
|/
* b93435d (feature-login) Add validate function
* 79883c3 Add login function
...
```

```
* 3695fe0 (feature-dashboard) Add dashboard    ← replayed ON TOP of main
* a9e1993 (main) Add changelog
* 8bdeb75 common ancestor
```

## Before vs After — Key Difference

**BEFORE (diverged):**
```
* a9e1993  (main)              Add changelog
| * 94a49bf  (feature-dashboard) Add dashboard
|/
* 8bdeb75  common ancestor
```

**AFTER (straight line):**
```
* 3695fe0  (feature-dashboard) Add dashboard    ← moved here
* a9e1993  (main)              Add changelog
* 8bdeb75  common ancestor
```

Commit hash changed: `94a49bf` → `3695fe0` — same change, brand new identity.

## Compare: Merge vs Rebase

**If merged instead:**
```
*   xxxxxxx (main) Merge feature-dashboard into main   ← extra merge commit
|\
| * 94a49bf Add dashboard
* | a9e1993 Add changelog
|/
* 8bdeb75 common ancestor
```

**With rebase:**
```
* 3695fe0 Add dashboard    ← no merge commit, just replayed on top
* a9e1993 Add changelog
* 8bdeb75 common ancestor
```

Rebase = clean straight line. Merge = diamond with a merge commit.

## Notes — Task 2

**What does rebase actually do to your commits?**
Rebase picks up commits from the feature branch and **replays them one by one on top of the new base**. Internally:
1. Git finds the common ancestor (`8bdeb75`)
2. Saves `Add dashboard` (`94a49bf`) as a patch
3. Moves `feature-dashboard` to point at `main`'s latest commit
4. Replays the patch, creating a **brand new commit** (`3695fe0`)
5. The old commit `94a49bf` becomes orphaned/unreachable

The change is identical, but the hash changes because the parent changed. **Rebase rewrites history.**

**How is the history different from a merge?**

| | Merge | Rebase |
|---|---|---|
| History shape | Diamond — branches split and rejoin | Straight line |
| Extra commit | Yes — merge commit with 2 parents | No |
| Original commits preserved | Yes — same hashes | No — new hashes |
| Easier to read | No — messy with many branches | Yes — clean linear history |
| Shows true history | Yes | No — rewrites what happened |

**Why should you NEVER rebase commits already pushed and shared with others?**
Rebase changes commit hashes (`94a49bf` → `3695fe0`). If a teammate already pulled the old commit and you force-push the rewritten one, Git sees two completely different histories. When they push/pull next, they get duplicate commits, conflicts, and confusion. **Rule:** only rebase commits that exist solely on your local machine and have never been pushed to a shared branch.

**When would you use rebase vs merge?**

*Use rebase when:*
- Cleaning up your local feature branch before opening a PR
- You want a clean linear history
- Commits are still local, unpushed
- Bringing your branch up to date with `main` without a merge commit

*Use merge when:*
- Integrating a completed feature into `main`/a shared branch
- You want to preserve the exact record of divergence
- Others may have the same branch
- The branch is already pushed to GitHub

> **Simple rule:** Rebase to clean up your own work before sharing it. Merge to combine work once it's shared.

---

# Task 3: Squash Commit vs Merge Commit

> **Note:** This task hasn't been run in the terminal yet. Steps below are the commands to execute; run them in your `devops-git-practice` repo and paste the actual output back in to complete this section with real logs.

## Step 1: Create `feature-profile`, add small commits

```bash
git checkout main
git checkout -b feature-profile

echo "def profile(): pass" >> app.py && git add app.py && git commit -m "Add profile function"
echo "# typo fix" >> app.py && git add app.py && git commit -m "Fix typo"
echo "# formatting" >> app.py && git add app.py && git commit -m "Fix formatting"
echo "# add docstring" >> app.py && git add app.py && git commit -m "Add docstring"
echo "# final tweak" >> app.py && git add app.py && git commit -m "Final tweak"
```

## Step 2: Squash-merge into `main`

```bash
git checkout main
git merge --squash feature-profile
git status          # shows staged changes, no commit yet
git commit -m "Add profile feature (squashed)"
```

`--squash` takes all commits from `feature-profile` and stages their combined changes on `main`, **without** creating a merge commit or preserving individual commit history — you then make one manual commit yourself.

## Step 3: Check `git log`

```bash
git log --oneline --graph --all
```

Expect to see **only one new commit** on `main` ("Add profile feature (squashed)") — the 5 small commits from `feature-profile` do not appear individually in `main`'s history (they still exist on the `feature-profile` branch ref itself, just not merged in as separate commits).

## Step 4: Create `feature-settings`, regular merge

```bash
git checkout main
git checkout -b feature-settings

echo "def save_settings(): pass" >> app.py && git add app.py && git commit -m "Add save settings function"
echo "def load_settings(): pass" >> app.py && git add app.py && git commit -m "Add load settings function"

git checkout main
git merge feature-settings
```

## Step 5: Compare

```bash
git log --oneline --graph --all
```

With a regular merge, both individual commits ("Add save settings function", "Add load settings function") appear in `main`'s history, plus a merge commit if `main` had diverged in the meantime.

## Notes — Task 3

**What does squash merging do?**
It takes all the commits on a branch and combines their changes into a single new commit on the target branch. The individual commit history of the branch is collapsed — `main` gets one clean commit instead of many small ones.

**When would you use squash merge vs regular merge?**
- **Squash merge:** when a feature branch has messy, incremental WIP commits (typo fixes, "wip", "oops") that aren't meaningful individually — you want `main`'s history to show one clean, well-described commit per feature.
- **Regular merge:** when the individual commits are meaningful and you want to preserve the full development history, or when working with a team that relies on detailed commit-level history (e.g., for blame/bisect purposes).

**What is the trade-off of squashing?**
You lose the granular commit history — if you ever need to `git bisect` to find which specific small change introduced a bug, or `git blame` to trace exact intent of a particular line change, that detail is gone (it's collapsed into one commit). It's a trade-off between a clean, readable `main` history versus preserving full development traceability.

---

# Task 4: Git Stash — Hands-On

## Step 1–2: Make changes, try to switch branches (should fail)

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout main
error: Your local changes to the following files would be overwritten by checkout:
        app.py
Please commit your changes or stash them before you switch branches.
Aborting
```

This proves you can't switch branches with uncommitted changes in the way.

## Step 3: Stash the work-in-progress

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash push -m "WIP: current app.py changes"
Saved working directory and index state On main: WIP: current app.py changes
```

## Step 4: Switch branch, do work, switch back

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 10 commits.
```

## Step 5: Apply stashed changes with `git stash pop`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash pop
On branch main
Changes not staged for commit:
        modified:   app.py
no changes added to commit (use "git add" and/or "git commit -a")
Dropped refs/stash@{0} (28ea81aed323a8bf3abd7abbc5001f77bf630a40)
```

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Changes not staged for commit:
        modified:   app.py
```

## Step 6: Stash multiple times, list all

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Change 1" >> app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash push -m "WIP: change 1"
Saved working directory and index state On main: WIP: change 1

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Change 2" >> app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash push -m "WIP: change 2"
Saved working directory and index state On main: WIP: change 2

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Change 3" >> app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash push -m "WIP: change 3"
Saved working directory and index state On main: WIP: change 3

vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash list
stash@{0}: On main: WIP: change 3
stash@{1}: On main: WIP: change 2
stash@{2}: On main: WIP: change 1
stash@{3}: On main: WIP: payment feature work
```

## Step 7: Apply a specific stash from the list

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash apply stash@{2}
On branch main
Changes not staged for commit:
        modified:   app.py
```

Trying to pop a *different* stash while changes are still uncommitted correctly fails:

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash pop stash@{1}
error: Your local changes to the following files would be overwritten by merge:
        app.py
Please commit your changes or stash them before you merge.
Aborting
The stash entry is kept in case you need it again.
```

So stash the current state first, then pop the target cleanly:

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash push -m "WIP: current app.py changes"
Saved working directory and index state On main: WIP: current app.py changes

vaibhav@Asus-Vivobook:~/devops-git-practice$ git stash pop stash@{1}
On branch main
Changes not staged for commit:
        modified:   app.py
Dropped stash@{1} (f0a193b4fc7490eb271f11615b147794ece06258)
```

## Notes — Task 4

**What is the difference between `git stash pop` and `git stash apply`?**
- `git stash apply` restores the stashed changes but **keeps the stash in the list** — useful if you might want to apply the same stash again (e.g., to another branch too).
- `git stash pop` restores the changes **and deletes that stash entry** — a one-time "apply and remove" in a single step.
- Rule of thumb: use `apply` when you want to reuse the stash later or test it safely; use `pop` when you're confident you only need it once.

**When would you use stash in a real-world workflow?**
You're mid-way through a feature (uncommitted, not ready to commit) when an urgent bug report comes in on another branch. Instead of making a messy WIP commit just to switch branches, you `git stash` your current work, switch branches, fix the bug, commit and push it, switch back, and `git stash pop` to pick up exactly where you left off — keeping commit history clean and WIP work safely parked.

---

# Task 5: Cherry Picking

## Step 1: Create `feature-hotfix`, make 3 commits

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout main && git checkout -b feature-hotfix
Already on 'main'
Your branch is ahead of 'origin/main' by 11 commits.
Switched to a new branch 'feature-hotfix'

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Hotfix: fix login bug" >> app.py && git add app.py && git commit -m "Fix login bug"
[feature-hotfix e54a15f] Fix login bug
 1 file changed, 2 insertions(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Hotfix: fix dashboard crash" >> app.py && git add app.py && git commit -m "Fix dashboard crash"
[feature-hotfix 865f4f6] Fix dashboard crash
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Hotfix: fix settings save issue" >> app.py && git add app.py && git commit -m "Fix settings save issue"
[feature-hotfix 7858eae] Fix settings save issue
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -3
7858eae (HEAD -> feature-hotfix) Fix settings save issue
865f4f6 Fix dashboard crash
e54a15f Fix login bug
```

## Step 2: Switch to `main`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 11 commits.
```

## Step 3: Cherry-pick only the second commit (`865f4f6` — "Fix dashboard crash")

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git cherry-pick 865f4f6
Auto-merging app.py
CONFLICT (content): Merge conflict in app.py
error: could not apply 865f4f6... Fix dashboard crash
hint: After resolving the conflicts, mark them with
hint: "git add/rm <pathspec>", then run
hint: "git cherry-pick --continue".
hint: You can instead skip this commit with "git cherry-pick --skip".
hint: To abort and get back to the state before "git cherry-pick",
hint: run "git cherry-pick --abort".
```

### Resolving the conflict

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ cat app.py
...
# First WIP change
<<<<<<< HEAD
=======
# Change 3
# Hotfix: fix login bug
# Hotfix: fix dashboard crash
>>>>>>> 865f4f6 (Fix dashboard crash)
```

This conflict happened because `main` had diverged from `feature-hotfix` (extra WIP/stash content on `main`) in ways that overlapped with the lines the cherry-picked commit touched.

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ vim app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git add app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git cherry-pick --continue
[main f3c072e] Fix dashboard crash
 Date: Wed Jul 1 13:35:26 2026 +0000
 1 file changed, 3 insertions(+), 16 deletions(-)
```

## Step 4: Verify with `git log`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -5
f3c072e (HEAD -> main) Fix dashboard crash
770a25c Apply stashed change and resolve conflict in app.py
eb2839a (feature-settings) Add load settings function
a0c143f Add save settings function
9a76d6e Add settings page
```

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ cat app.py
...
# Change 3
# Hotfix: fix login bug
# Hotfix: fix dashboard crash
```

Confirmed: only the "Fix dashboard crash" commit was applied to `main` — the cherry-pick got a **new hash** (`f3c072e`, not the original `865f4f6`), and neither "Fix login bug" nor "Fix settings save issue" appear on `main`.

## Notes — Task 5

**What does cherry-pick do?**
`git cherry-pick <commit-hash>` takes the changes from a single specific commit on one branch and applies them as a new commit on the current branch — without bringing over any other commits from the source branch.

**When would you use cherry-pick in a real project?**
- Pulling a critical bug fix from a feature branch onto `main`/a release branch before the whole feature is ready
- Backporting a fix to an older release branch without pulling in unrelated newer changes
- Recovering one useful commit from a branch that's otherwise being abandoned
- Applying a hotfix independently to multiple branches (e.g., `main` and a `hotfix` branch)

**What can go wrong with cherry-picking?**
- **Duplicate commits/history confusion:** cherry-pick creates a new commit hash, so if the original branch is later merged too, the same change can appear twice
- **Merge conflicts:** if the target branch has diverged (as seen above), the cherry-picked commit's context may not line up cleanly, requiring manual resolution
- **Missing dependencies:** if the picked commit depends on earlier commits in the source branch you didn't pick, it may not apply correctly or the code may not work
- **Losing traceability:** without good commit messages, it can be unclear later why a change exists on a branch if it's not obvious it was cherry-picked
