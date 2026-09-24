#!/usr/bin/env bash
# git end-review
#
# Discards the review and returns to the branch it was started from,
# carrying over any edits made during the review as uncommitted changes.
set -e
state="$(git rev-parse --git-path review-origin)"
[ -f "$state" ] || { echo "No review in progress." >&2; exit 1; }
{ read -r origin; read -r reviewed; read -r base; } < "$state"
head="$(git rev-parse HEAD)"
if [ "$head" != "$base" ]; then
    # With HEAD off the base, the tree is no longer reviewed + edits
    echo "HEAD was moved during the review; edits will not be carried over." >&2
    echo "To recover the previous state: git branch <name> $head" >&2
    # -f: after a reset, files from the reviewed branch become untracked and block the switch
    git switch -f "$origin"
    rm "$state"
    exit 1
fi
# Reviewer edits = working tree vs reviewed commit (staged or not)
patch="$(git rev-parse --git-path review-edits.patch)"
git diff --binary "$reviewed" > "$patch"
git switch --discard-changes "$origin"
rm "$state"
[ -s "$patch" ] || { rm "$patch"; exit 0; }
if git apply --3way "$patch"; then
    git reset -q
    rm "$patch"
    echo "Review edits applied to $origin (uncommitted)."
else
    echo "Review edits conflict on $origin; resolve the markers. Copy at $patch" >&2
    exit 1
fi
