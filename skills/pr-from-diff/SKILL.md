---
name: pr-from-diff
description: Write a PR description a reviewer can approve fast. Use when opening any pull request.
when_to_use: opening a PR, "write the PR body", review prep
---
# PR from Diff
A reviewer should understand the change without reading every line. Structure:
- **What & why** — the problem and the approach, 2-3 sentences.
- **Changes** — bullet the meaningful ones (skip noise like formatting).
- **How to verify** — the exact steps/commands the reviewer runs to confirm it works.
- **Risks / out of scope** — what could break, what you deliberately didn't do.
- **Screenshots** for UI.
Flag any decision the reviewer should weigh in on. Keep the PR small — if the diff is huge, say what could be split out. No "fixes stuff".
