# Day 25 — Git Reset vs Revert & Branching Strategies

*devops-git-practice | #90DaysOfDevOps | #DevOpsKaJosh | #TrainWithShubham*

---

# Task 1: Git Reset — Hands-On

## Make 3 commits (A, B, C)

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Commit A change" >> app.py && git add app.py && git commit -m "Commit A"
[main e209576] Commit A
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Commit B change" >> app.py && git add app.py && git commit -m "Commit B"
[main 48cf849] Commit B
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Commit C change" >> app.py && git add app.py && git commit -m "Commit C"
[main 0b86d09] Commit C
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -3
0b86d09 (HEAD -> main) Commit C
48cf849 Commit B
e209576 Commit A
```

## `git reset --soft HEAD~1`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git reset --soft HEAD~1
vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -3
48cf849 (HEAD -> main) Commit B
e209576 Commit A
79e4442 (origin/main) updated git commands

vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   app.py
```

**What happened:** Commit C (`0b86d09`) disappeared from the log — `HEAD` and `main` now point at Commit B (`48cf849`). But `git status` shows the change from Commit C is **still staged** ("Changes to be committed"). Nothing was lost; it's just waiting to be committed again.

## Re-commit, then `git reset --mixed HEAD~1`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git commit -m "Commit C"
[main 8730a94] Commit C
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -3
8730a94 (HEAD -> main) Commit C
48cf849 Commit B
e209576 Commit A

vaibhav@Asus-Vivobook:~/devops-git-practice$ git reset --mixed HEAD~1
Unstaged changes after reset:
M       app.py

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -2
48cf849 (HEAD -> main) Commit B
e209576 Commit A

vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   app.py

no changes added to commit (use "git add" and/or "git commit -a")
```

**What happened:** Commit C (`8730a94`) is removed from the log again. This time Git explicitly says `Unstaged changes after reset` — the change to `app.py` is still there in the working directory, but it's no longer staged. You'd need `git add app.py` again before committing.

## Re-commit, then `git reset --hard HEAD~1`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git add app.py && git commit -m "Commit C"
[main 208d1db] Commit C
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ git reset --hard HEAD~1
HEAD is now at 48cf849 Commit B

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -2
48cf849 (HEAD -> main) Commit B
e209576 Commit A

vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
```

**What happened:** Commit C (`208d1db`) is removed from the log, and this time `git status` shows a **completely clean working tree** — the change is gone from staging *and* from the working directory. As far as the file system is concerned, Commit C never happened.

## Recovering with `git reflog`

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git reflog
48cf849 (HEAD -> main) HEAD@{0}: reset: moving to HEAD~1
208d1db HEAD@{1}: commit: Commit C
48cf849 (HEAD -> main) HEAD@{2}: reset: moving to HEAD~1
8730a94 HEAD@{3}: commit: Commit C
48cf849 (HEAD -> main) HEAD@{4}: reset: moving to HEAD~1
0b86d09 HEAD@{5}: commit: Commit C
48cf849 (HEAD -> main) HEAD@{6}: commit: Commit B
e209576 HEAD@{7}: commit: Commit A
...
```

`git reflog` shows every state `HEAD` has passed through — including the three different "Commit C" attempts (`0b86d09`, `8730a94`, `208d1db`) even after they were reset away. This proves nothing is truly deleted right away; it's just unreachable from the branch pointer until garbage collected.

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git reset --hard 208d1db
HEAD is now at 208d1db Commit C

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -3
208d1db (HEAD -> main) Commit C
48cf849 Commit B
e209576 Commit A

vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Your branch is ahead of 'origin/main' by 3 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
```

Using the hash found in `git reflog`, the "lost" Commit C was fully recovered — proving `reflog` really is the safety net for local hard resets.

## Notes — Task 1

**What is the difference between `--soft`, `--mixed`, and `--hard`?**

All three move the branch pointer back to an earlier commit — the difference is what happens to the **staging area** and **working directory**:

| Mode | Commit history | Staging area (index) | Working directory |
|---|---|---|---|
| `--soft` | Moved back | Changes kept **staged** | Unchanged (files keep the edits) |
| `--mixed` (default) | Moved back | Changes **unstaged** | Unchanged (files keep the edits) |
| `--hard` | Moved back | Changes **discarded** | Changes **discarded** — files reverted |

This matched exactly what was observed: `--soft` left the change staged and ready to commit immediately; `--mixed` unstaged it but kept the file edit; `--hard` wiped it from the working tree entirely, leaving a clean `git status`.

**Which one is destructive and why?**
`--hard` is destructive because it discards changes from the working directory as well as the index. If those changes exist nowhere else, the only way back is `git reflog` plus `git reset --hard <hash>` (as demonstrated above) — and that only works until the old commit gets garbage collected.

**When would you use each one?**
- `--soft`: to "undo" a commit but immediately redo/combine it — e.g., merging the last commit with new changes into one commit.
- `--mixed`: to undo a commit and its staging, but keep the file edits so they can be re-reviewed or re-staged differently before committing again.
- `--hard`: to throw away a commit and its changes entirely — e.g., an experiment that turned out to be completely wrong.

**Should you ever use `git reset` on commits that are already pushed?**
No, not on a shared branch. `reset` moves the branch pointer backward, which rewrites history when force-pushed — this note's `git log` already shows `Your branch is ahead of 'origin/main'` throughout, meaning these commits were still local and safe to reset. If a teammate had already pulled the reset-away commits, their history would diverge from yours and force a messy re-sync. For anything already pushed/shared, use `git revert` instead (Task 2).

---

# Task 2: Git Revert — Hands-On

## Make 3 commits (X, Y, Z)

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Commit X change" >> app.py && git add app.py && git commit -m "Commit X"
[main 5eccb19] Commit X
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Commit Y change" >> app.py && git add app.py && git commit -m "Commit Y"
[main 7e3b7d2] Commit Y
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ echo "# Commit Z change" >> app.py && git add app.py && git commit -m "Commit Z"
[main accf102] Commit Z
 1 file changed, 1 insertion(+)

vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -3
accf102 (HEAD -> main) Commit Z
7e3b7d2 Commit Y
5eccb19 Commit X
```

## Revert commit Y (the middle one) — conflict, since Z was appended after Y's line

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git revert 7e3b7d2
Auto-merging app.py
CONFLICT (content): Merge conflict in app.py
error: could not revert 7e3b7d2... Commit Y
hint: After resolving the conflicts, mark them with
hint: "git add/rm <pathspec>", then run
hint: "git revert --continue".
hint: You can instead skip this commit with "git revert --skip".
hint: To abort and get back to the state before "git revert",
hint: run "git revert --abort".

vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Your branch is ahead of 'origin/main' by 6 commits.

You are currently reverting commit 7e3b7d2.
  (fix conflicts and run "git revert --continue")
  (use "git revert --skip" to skip this patch)
  (use "git revert --abort" to cancel the revert operation)

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
        both modified:   app.py

no changes added to commit (use "git add" and/or "git commit -a")
```

**Why it conflicted:** Commit Z was appended right after Commit Y's line in `app.py`. Reverting Y means removing a line that Z's content now sits next to — Git can't automatically tell which lines survive, so it stops and asks for a manual decision.

### Resolving the conflict

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ vim app.py

vaibhav@Asus-Vivobook:~/devops-git-practice$ git revert 7e3b7d2
error: Reverting is not possible because you have unmerged files.
hint: Fix them up in the work tree, and then use 'git add/rm <file>'
hint: as appropriate to mark resolution and make a commit.
fatal: revert failed
```
*(Note: once a revert is already in progress with a conflict, you continue it with `git revert --continue` — running `git revert <hash>` again isn't the right next step, as Git points out here.)*

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git revert --continue
U       app.py
error: Committing is not possible because you have unmerged files.
hint: Fix them up in the work tree, and then use 'git add/rm <file>'
hint: as appropriate to mark resolution and make a commit.
fatal: Exiting because of an unresolved conflict.
```
*(The file still had unresolved markers at this point — needed `git add` first.)*

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ vim app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git add app.py
vaibhav@Asus-Vivobook:~/devops-git-practice$ git revert --continue
[main e9027d1] Revert "Commit Y"
 1 file changed, 6 deletions(-)

vaibhav@Asus-Vivobook:~/devops-git-practice$ git status
On branch main
Your branch is ahead of 'origin/main' by 7 commits.

nothing to commit, working tree clean
```

## Check `git log` — is commit Y still in the history?

```bash
vaibhav@Asus-Vivobook:~/devops-git-practice$ git log --oneline -3
e9027d1 (HEAD -> main) Revert "Commit Y"
accf102 Commit Z
7e3b7d2 Commit Y
```

**Yes** — `7e3b7d2 Commit Y` is still fully visible in the log. `git revert` didn't erase it; it added a brand-new commit (`e9027d1`, "Revert 'Commit Y'") on top that undoes Y's change. History moves forward, nothing is rewritten.

## Notes — Task 2

**How is `git revert` different from `git reset`?**
- `git reset` moves the branch pointer backward, effectively removing commits from the branch's reachable history (and can discard their changes entirely with `--hard`), as seen throughout Task 1.
- `git revert` never moves the pointer or removes anything — it adds a **new commit** that applies the inverse of a target commit's changes, as seen with `e9027d1` sitting on top of `accf102` and `7e3b7d2`.

**Why is revert considered safer than reset for shared branches?**
Because it never rewrites existing history — it only appends a new commit. Anyone who already has commit Y (`7e3b7d2`) in their local repo is unaffected; they simply pull the new revert commit (`e9027d1`) like any normal commit. No force-push, no diverging histories.

**When would you use revert vs reset?**
- Use **revert** for anything already pushed/shared, or whenever a clear audit trail matters ("Revert 'Commit Y'" documents exactly what was undone and why).
- Use **reset** only on local, unpushed commits — exactly the situation in Task 1, where `git status` kept confirming the repo was only "ahead of origin/main," never behind or diverged.

---

# Task 3: Reset vs Revert — Summary

| | `git reset` | `git revert` |
|---|---|---|
| **What it does** | Moves the current branch pointer to an earlier commit (optionally changing the staging area / working directory too, depending on `--soft` / `--mixed` / `--hard`) | Creates a new commit that applies the inverse of a target commit's changes |
| **Removes commit from history?** | Yes — the commit becomes unreachable from the branch (recoverable short-term via `git reflog`, as shown in Task 1) | No — the original commit stays in the log; a new "revert" commit is added on top (as shown in Task 2) |
| **Safe for shared/pushed branches?** | No — rewrites history; breaks other people's local copies if force-pushed | Yes — only adds a new commit, never rewrites anything |
| **When to use** | Cleaning up **local, unpushed** commits — undo a mistake before sharing, or restage/redo work | Undoing a change that's **already shared/pushed** — safely, with a clear audit trail |

---

# Task 4: Branching Strategies

## GitFlow

**How it works:** A structured model with several long-lived and short-lived branch types:
- `main`/`master` — always reflects production-ready code
- `develop` — integration branch where features come together
- `feature/*` — branched from `develop`, merged back into `develop`
- `release/*` — branched from `develop` when preparing a release; only bug fixes go here; merged into both `main` and `develop`
- `hotfix/*` — branched from `main` for urgent production fixes; merged into both `main` and `develop`

**Diagram (text-based):**
```
main       ─────●───────────────────●───────────  (tags: v1.0, v1.1)
                 \                 /  \
release           \      ●───●───●     \
                    \    /             \
develop      ●───●───●───●───●───●──────●───●
             \       \           /      /
feature-A     ●───●───●          /      /
                                 /      /
feature-B                ●──────●      /
                                       /
hotfix                          ●────●   (branched from main, merged to main + develop)
```

**When/where it's used:** Projects with scheduled, versioned releases and a need for strict release stabilization — e.g., enterprise software, packaged/installed software with formal release cycles (not continuously deployed web apps).

**Pros:**
- Clear separation between in-progress work, release-candidate stabilization, and production
- Supports maintaining multiple production versions and hotfixes in parallel
- Very structured — good for teams with formal QA/release processes

**Cons:**
- Complex — many branch types and merge directions to keep track of
- Slower to get changes into production (multiple integration stages)
- Overkill for small teams or products practicing continuous deployment
- More frequent, larger merges = more potential for conflicts

## GitHub Flow

**How it works:** A much simpler model:
- `main` is always deployable
- Every change is made on a short-lived `feature/*` branch off `main`
- Open a pull request early for discussion/review
- Once approved and tests pass, merge into `main`
- Deploy immediately (or automatically) after merging to `main`

**Diagram:**
```
main       ●───────●───────────●───────●──────►  (always deployable)
            \      /  \        /       /
feature-A    ●────●    \      /       /
                        \    /       /
feature-B                ●──●       /
                                    /
feature-C                    ●────●
```

**When/where it's used:** Web applications and services using continuous delivery/deployment — most modern SaaS products, and it's the default flow for many GitHub-hosted open source projects.

**Pros:**
- Simple, easy to learn and explain
- Fast feedback loop — code reaches production quickly
- Works very well with CI/CD pipelines and pull-request-based review

**Cons:**
- No built-in mechanism for maintaining multiple release versions in parallel
- Requires strong automated testing/CI discipline, since `main` must always be deployable
- Less suited to products that ship versioned releases on a schedule (e.g., desktop software, libraries with SemVer releases)

## Trunk-Based Development

**How it works:** All developers commit directly to a single shared branch (the "trunk", usually `main`) very frequently, or use extremely short-lived feature branches (living hours, not days) that are merged back quickly. Incomplete features are hidden behind feature flags rather than long-lived branches. Releases are often cut from the trunk itself (sometimes via short-lived release branches for stabilization only).

**Diagram:**
```
main (trunk) ●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─►   (near-constant small commits)
                  \ /   \ /     \ /
           short-lived branches (merged within hours)
```

**When/where it's used:** High-velocity teams practicing continuous integration/deployment at scale — e.g., Google, Facebook/Meta internally, and many large open-source infra projects. Kubernetes, for example, largely follows a trunk-based approach: contributors work in short-lived feature branches on personal forks, PRs are typically squashed into `main`, and versioned `release-x.y` branches are cut from `main` late in the cycle purely for release stabilization, with fixes cherry-picked/backported into them.

**Pros:**
- Minimizes merge conflicts (small, frequent integrations rather than big-bang merges)
- Encourages strong CI, automated testing, and feature-flag discipline
- Very fast flow of changes into the shared codebase

**Cons:**
- Requires mature CI/CD and testing culture — riskier without it (broken trunk affects everyone immediately)
- Feature flags add code complexity that has to be managed and eventually cleaned up
- Less natural isolation for large, disruptive changes that take a long time to complete

## Answers

**Which strategy would you use for a startup shipping fast?**
**GitHub Flow.** It's simple, keeps `main` always deployable, and pairs naturally with CI/CD — ideal when the priority is shipping features to users quickly without heavyweight process overhead.

**Which strategy would you use for a large team with scheduled releases?**
**GitFlow.** The `develop`/`release`/`hotfix` structure gives the control needed to stabilize a release, support multiple versions in production, and coordinate many contributors around a fixed release calendar.

**Which one does your favorite open-source project use?**
Kubernetes uses a strategy closest to **trunk-based development**: contributors work on short-lived feature branches (on forks), PRs are reviewed and typically squash-merged into `main`, and numbered `release-1.x` branches are cut from `main` late in the cycle for stabilization, receiving cherry-picked backport fixes rather than ongoing feature work. This fits its scale (thousands of contributors) while still supporting multiple maintained release lines.

---

# Task 5: Git Commands Reference Update

`git-commands.md` has been updated separately in this repo to consolidate everything from Days 22–25, including:
- Setup & Config
- Basic Workflow (add, commit, status, log, diff)
- Branching (`branch`, `checkout`, `switch`)
- Remote (`push`, `pull`, `fetch`, `clone`, fork)
- Merging & Rebasing
- Stash & Cherry Pick
- **Reset & Revert** (new section — `--soft` / `--mixed` / `--hard`, `git revert`, and `git reflog` as the recovery safety net)

See `git-commands.md` in the repo root for the full reference.

---

*Day 25 – Git Reset vs Revert & Branching Strategies | #90DaysOfDevOps | #DevOpsKaJosh | #TrainWithShubham*
