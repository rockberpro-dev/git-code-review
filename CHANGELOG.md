# Changelog

## [0.1.0] - 2026-09-24

### Added

- `git start-review <branch>` and `git end-review` aliases, installed via a gitconfig `[include]`
- Default branch detection (`origin/HEAD`, falling back to `origin/main` / `origin/master`)
- Guards: uncommitted changes, detached HEAD, review already in progress, HEAD moved during the review
- Edits made during the review are carried back to the original branch as uncommitted changes
- `setup.sh` (curl) and `setup-local.sh` installers
