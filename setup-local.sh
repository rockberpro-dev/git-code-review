#!/bin/bash

set -e

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GITCONFIG_PATH="$HOME/.git-code-review.gitconfig"
START_PATH="$HOME/.git-code-review-start.sh"
END_PATH="$HOME/.git-code-review-end.sh"

cp "$SRC_DIR/git-code-review.gitconfig" "$GITCONFIG_PATH"
cp "$SRC_DIR/git-start-review.sh" "$START_PATH"
cp "$SRC_DIR/git-end-review.sh" "$END_PATH"
chmod +x "$START_PATH" "$END_PATH"

if ! git config --global --get-all include.path | grep -qF "$GITCONFIG_PATH"; then
    git config --global --add include.path "$GITCONFIG_PATH"
fi

echo "git-code-review installed: $GITCONFIG_PATH"
echo "Usage: git start-review <branch> / git end-review"
