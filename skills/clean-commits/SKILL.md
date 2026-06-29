---
name: clean-commits
description: Turn messy WIP into clean, atomic commits with messages that explain why. Use before opening a PR.
when_to_use: before a PR, messy history, "squash this", commit message help
---
# Clean Commits
- **Atomic** — one logical change per commit. Refactor and behavior change go in separate commits.
- **Message** — subject says WHAT in imperative ("Fix null pointer in user lookup"), body says WHY. "Fix bug" is useless.
- **Specific** — "Fix login failing when email has uppercase chars" tells the next person exactly what happened.
- Reorder/squash WIP and "fix typo" commits into the real changes (`git rebase -i`).
- Never mix an unrelated fix into a feature commit.
A good history is a debugging tool: `git bisect` and `git blame` only work if commits are atomic and messages explain intent.
