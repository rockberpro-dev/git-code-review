# Git Code Review: Guide

## Manual install

```bash
BASE=https://raw.githubusercontent.com/rockberpro-dev/git-code-review/main
curl -fsSL $BASE/git-code-review.gitconfig -o ~/.git-code-review.gitconfig
curl -fsSL $BASE/git-start-review.sh -o ~/.git-code-review-start.sh
curl -fsSL $BASE/git-end-review.sh   -o ~/.git-code-review-end.sh
chmod +x ~/.git-code-review-start.sh ~/.git-code-review-end.sh
git config --global --add include.path ~/.git-code-review.gitconfig
```

## Uninstall

```bash
git config --global --unset include.path ~/.git-code-review.gitconfig
rm ~/.git-code-review.gitconfig ~/.git-code-review-start.sh ~/.git-code-review-end.sh
```

---

Back to the [README](README.md).
