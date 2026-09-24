#!/bin/bash

set -e

BASE_URL="https://raw.githubusercontent.com/rockberpro/git-code-review/main"

GITCONFIG_PATH="$HOME/.git-code-review.gitconfig"
START_PATH="$HOME/.git-code-review-start.sh"
END_PATH="$HOME/.git-code-review-end.sh"

curl -fsSL "$BASE_URL/git-code-review.gitconfig" -o "$GITCONFIG_PATH"
curl -fsSL "$BASE_URL/git-start-review.sh" -o "$START_PATH"
curl -fsSL "$BASE_URL/git-end-review.sh" -o "$END_PATH"
chmod +x "$START_PATH" "$END_PATH"

if ! git config --global --get-all include.path | grep -qF "$GITCONFIG_PATH"; then
    git config --global --add include.path "$GITCONFIG_PATH"
fi

echo "git-code-review installed: $GITCONFIG_PATH"
echo "Usage: git start-review <branch> / git end-review"
