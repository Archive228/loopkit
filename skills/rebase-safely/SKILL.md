---
name: rebase-safely
description: Rebase, squash, or rewrite history without losing work or breaking shared branches. Use before any history rewrite.
when_to_use: rebase, squash, "update my branch", interactive rebase, force-push
---
# Rebase Safely
1. **Backup first** — `git branch backup/<name>` before any rewrite. Free undo.
2. Rebase onto the latest base: `git fetch; git rebase origin/main`.
3. Resolve conflicts one commit at a time. Test after the rebase, not just that it "completed".
4. **Never rewrite shared history** — if others pulled the branch, rebasing it forces them into pain. Rewrite only your own un-pushed/un-shared commits.
5. Push with `--force-with-lease`, never bare `--force` (lease refuses if someone else pushed).
If anything goes sideways: `git reflog` finds the pre-rebase state; `git reset --hard backup/<name>` restores it.
