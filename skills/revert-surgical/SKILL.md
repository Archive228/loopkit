---
name: revert-surgical
description: Undo a bad change without nuking unrelated work. Use when a specific commit or change broke something.
when_to_use: "revert this", a bad deploy, one commit broke prod, undo without losing other work
---
# Surgical Revert
Don't `git reset --hard` away three good commits to undo one bad one.
- **Single commit** — `git revert <sha>` creates an inverse commit; history stays intact and shared-branch-safe.
- **One file from a commit** — `git checkout <good-sha> -- path/to/file`.
- **Hunk-level** — `git checkout -p` to revert specific changes, keep the rest.
- **A merge** — `git revert -m 1 <merge-sha>` (pick the mainline parent).
On a shared branch, always revert (forward), never rewrite history. Reproduce the breakage first so you revert the RIGHT thing, then verify the revert actually fixes it.
