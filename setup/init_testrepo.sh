#!/usr/bin/env bash
set -euo pipefail

cd /workspace/testrepo
git init
git config user.email "test@example.com"
git config user.name "Test User"

# ---------------------------------------------------------------------------
# .changelog.yml config (read by the script under test)
# ---------------------------------------------------------------------------
cat > .changelog.yml << 'YMLEOF'
repo_name: MyApp
include_hash: true
type_map:
  feat: Added
  fix: Fixed
  refactor: Changed
  perf: Changed
  docs: Changed
  deprecate: Deprecated
  remove: Removed
  security: Security
ignored_types:
  - chore
  - ci
  - build
  - test
YMLEOF

# ---------------------------------------------------------------------------
# v0.1.0 range
# ---------------------------------------------------------------------------
git add .changelog.yml
GIT_COMMITTER_DATE="2023-12-01T10:00:00" GIT_AUTHOR_DATE="2023-12-01T10:00:00" \
    git commit -m "feat: initial setup"
GIT_COMMITTER_DATE="2023-12-05T10:00:00" GIT_AUTHOR_DATE="2023-12-05T10:00:00" \
    git commit --allow-empty -m "chore: setup project structure"
GIT_COMMITTER_DATE="2023-12-10T10:00:00" GIT_AUTHOR_DATE="2023-12-10T10:00:00" \
    git commit --allow-empty -m "ci: add GitHub Actions pipeline"
GIT_COMMITTER_DATE="2023-12-15T10:00:00" GIT_AUTHOR_DATE="2023-12-15T10:00:00" \
    git tag -a v0.1.0 -m "Release v0.1.0"

# ---------------------------------------------------------------------------
# v0.2.0 range
# ---------------------------------------------------------------------------
GIT_COMMITTER_DATE="2024-01-05T10:00:00" GIT_AUTHOR_DATE="2024-01-05T10:00:00" \
    git commit --allow-empty -m "feat: add login page"
GIT_COMMITTER_DATE="2024-01-10T10:00:00" GIT_AUTHOR_DATE="2024-01-10T10:00:00" \
    git commit --allow-empty -m "fix: correct null pointer in auth"
GIT_COMMITTER_DATE="2024-01-12T10:00:00" GIT_AUTHOR_DATE="2024-01-12T10:00:00" \
    git commit --allow-empty -m "chore: update dependencies"
GIT_COMMITTER_DATE="2024-01-15T10:00:00" GIT_AUTHOR_DATE="2024-01-15T10:00:00" \
    git commit --allow-empty -m "WIP"
GIT_COMMITTER_DATE="2024-01-20T10:00:00" GIT_AUTHOR_DATE="2024-01-20T10:00:00" \
    git tag -a v0.2.0 -m "Release v0.2.0"

# ---------------------------------------------------------------------------
# v1.0.0 range
# ---------------------------------------------------------------------------
GIT_COMMITTER_DATE="2024-02-01T10:00:00" GIT_AUTHOR_DATE="2024-02-01T10:00:00" \
    git commit --allow-empty -m "feat(auth): add OAuth login"
GIT_COMMITTER_DATE="2024-02-10T10:00:00" GIT_AUTHOR_DATE="2024-02-10T10:00:00" \
    git commit --allow-empty -m "refactor: restructure auth module"
GIT_COMMITTER_DATE="2024-02-15T10:00:00" GIT_AUTHOR_DATE="2024-02-15T10:00:00" \
    git commit --allow-empty -m "perf: optimize query performance"
GIT_COMMITTER_DATE="2024-02-18T10:00:00" GIT_AUTHOR_DATE="2024-02-18T10:00:00" \
    git commit --allow-empty -m "ci: update CI pipeline"
GIT_COMMITTER_DATE="2024-03-15T10:00:00" GIT_AUTHOR_DATE="2024-03-15T10:00:00" \
    git tag -a v1.0.0 -m "Release v1.0.0"

# ---------------------------------------------------------------------------
# v1.1.0 range — BREAKING CHANGE footer + colon in message body
# ---------------------------------------------------------------------------
GIT_COMMITTER_DATE="2024-04-01T10:00:00" GIT_AUTHOR_DATE="2024-04-01T10:00:00" \
    git commit --allow-empty -m "$(printf 'fix: handle url: parsing edge case\n\nThis fixes how the parser handles URLs with colons in them.\nAlso fixes edge cases with double colons.')"
GIT_COMMITTER_DATE="2024-04-10T10:00:00" GIT_AUTHOR_DATE="2024-04-10T10:00:00" \
    git commit --allow-empty -m "$(printf 'feat: migrate config format\n\nUpdates the internal config representation.\n\nBREAKING CHANGE: The config file format has changed. Old .config files must be migrated using the migration script.')"
GIT_COMMITTER_DATE="2024-05-01T10:00:00" GIT_AUTHOR_DATE="2024-05-01T10:00:00" \
    git commit --allow-empty -m "chore: bump dev dependencies"
GIT_COMMITTER_DATE="2024-05-15T10:00:00" GIT_AUTHOR_DATE="2024-05-15T10:00:00" \
    git checkout -b feature/dashboard
GIT_COMMITTER_DATE="2024-05-16T10:00:00" GIT_AUTHOR_DATE="2024-05-16T10:00:00" \
    git commit --allow-empty -m "feat: add dashboard widget"
git checkout master
GIT_COMMITTER_DATE="2024-05-20T10:00:00" GIT_AUTHOR_DATE="2024-05-20T10:00:00" \
    git merge feature/dashboard --no-ff -m "Merge branch 'feature/dashboard'"
GIT_COMMITTER_DATE="2024-06-01T10:00:00" GIT_AUTHOR_DATE="2024-06-01T10:00:00" \
    git tag -a v1.1.0 -m "Release v1.1.0"

# ---------------------------------------------------------------------------
# Unreleased — feat! breaking change
# ---------------------------------------------------------------------------
GIT_COMMITTER_DATE="2024-07-01T10:00:00" GIT_AUTHOR_DATE="2024-07-01T10:00:00" \
    git commit --allow-empty -m "feat!: remove legacy auth endpoint"
GIT_COMMITTER_DATE="2024-07-10T10:00:00" GIT_AUTHOR_DATE="2024-07-10T10:00:00" \
    git commit --allow-empty -m "feat: add new dashboard analytics"
GIT_COMMITTER_DATE="2024-07-15T10:00:00" GIT_AUTHOR_DATE="2024-07-15T10:00:00" \
    git commit --allow-empty -m "fix: resolve race condition in session handler"
GIT_COMMITTER_DATE="2024-07-20T10:00:00" GIT_AUTHOR_DATE="2024-07-20T10:00:00" \
    git commit --allow-empty -m "chore: update lock file"
GIT_COMMITTER_DATE="2024-07-25T10:00:00" GIT_AUTHOR_DATE="2024-07-25T10:00:00" \
    git commit --allow-empty -m "WIP: experimenting with new auth flow"

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
echo "=== Tags ==="
git tag -l
echo "=== Log ==="
git log --oneline
