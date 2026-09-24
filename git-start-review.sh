#!/usr/bin/env bash
# git start-review <branch>
#
# Checks out <branch> detached and stages all of its changes against the
# default branch, so the editor's Source Control panel shows the whole
# merge request as a single diff. Finish with: git end-review
set -e
: "${1:?Usage: git start-review <branch>}"
state="$(git rev-parse --git-path review-origin)"
[ ! -f "$state" ] || { echo "A review is already in progress; finish it with: git end-review" >&2; exit 1; }
origin="$(git branch --show-current)"
: "${origin:?Run from a branch (HEAD is detached)}"
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
    echo "You have uncommitted changes; commit or stash them before the review." >&2
    exit 1
fi
git fetch origin
# Default branch of the remote (origin/HEAD), falling back to main/master
default="$(git symbolic-ref -q --short refs/remotes/origin/HEAD || true)"
for candidate in origin/main origin/master; do
    [ -n "$default" ] && break
    git rev-parse -q --verify "$candidate^{commit}" >/dev/null && default="$candidate"
done
: "${default:?Could not find the default branch; run: git remote set-head origin --auto}"
# Local-only branch (not pushed yet) falls back to the local ref
ref="origin/$1"
git rev-parse -q --verify "$ref^{commit}" >/dev/null || ref="$1"
git switch --detach "$ref"
reviewed="$(git rev-parse HEAD)"
git reset --soft "$(git merge-base "$default" HEAD)"
printf '%s\n%s\n%s\n' "$origin" "$reviewed" "$(git rev-parse HEAD)" > "$state"
echo "Reviewing $1 against $default. To finish: git end-review"
