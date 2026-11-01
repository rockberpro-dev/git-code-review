<p align="center">
  <img src="resources/img/magnifying-class.png" alt="Git Code Review" width="120">
</p>

<h1 align="center">Git Code Review</h1>

<p align="center">Review a branch as a single staged diff in your editor, instead of the web UI.</p>

## Install

**Linux / macOS / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/rockberpro-dev/git-code-review/main/setup.sh | bash
```

**From a local clone:**

```bash
./setup-local.sh
```

The setup copies two scripts to `~/` and adds an `[include]` entry to `~/.gitconfig` with the `start-review` and `end-review` aliases. Your existing config stays untouched. You can read the full source ([setup.sh](setup.sh), [setup-local.sh](setup-local.sh)) before running it, or follow the [manual install](GUIDE.md#manual-install).

## Usage

```bash
git start-review feature/new-index   # the whole MR shows up as one staged diff
# ... browse, jump to definitions, run the tests, fix things ...
git end-review                       # back where you were, fixes kept as uncommitted changes
```

Works with any editor that shows staged changes (VS Code's **Source Control** panel, JetBrains, `git diff --cached`).

## Before you start

Fetch and switch to the branch under review, with a clean working tree. If you fix something during the review, the fix lands on that branch, ready to commit:

```bash
git fetch origin
git switch <branch>
git pull
git start-review <branch>
```

## What it does

`git start-review <branch>`

1. Refuses to run with uncommitted changes (modified or staged), from a detached HEAD, or while another review is in progress.
2. Fetches `origin` and finds the default branch (`origin/HEAD`, falling back to `origin/main` or `origin/master`).
3. Checks out `origin/<branch>` detached, without creating a local branch. If the branch was not pushed yet, uses the local one.
4. Moves HEAD back to where the branch forked from the default branch (`git reset --soft` + `git merge-base`). Files don't change: all of the branch's commits become a single staged change.
5. Saves the original branch, the reviewed commit and the merge-base in `.git/review-origin`.

`git end-review`

Discards the review and returns to the branch it was started from. Edits made during the review (working tree vs reviewed commit) are reapplied there as uncommitted changes. If reapplying conflicts, the file is left with conflict markers and a copy of the edits is kept in `.git/review-edits.patch`.

If HEAD was moved during the review (`reset`, `checkout`, a commit), edits are not carried over: it returns to the original branch and prints the commit HEAD was on, so you can recover it with `git branch`.

Nothing from the author is lost: their commits are still on `origin/<branch>`, and the review can be reopened at any time.

## Why the merge-base?

`git merge-base` finds the last commit shared by the default branch and the branch under review, i.e. where it forked:

```
          o---o---o   branch
         /
o---o---X---o---o     main
```

Going back to `X` shows only the branch's changes. Going back to the tip of `main` would show its newer commits as if the branch had reverted them.

## Caveats

- New files created during the review stay in the working tree as untracked; check with `git status`.
- Since the scripts live in `~/`, they keep working even when the branch under review is older than any project-level tooling.

---

[GUIDE.md](GUIDE.md) · [setup.sh](setup.sh) · [setup-local.sh](setup-local.sh) · [git-code-review.gitconfig](git-code-review.gitconfig) · [git-start-review.sh](git-start-review.sh) · [git-end-review.sh](git-end-review.sh)
