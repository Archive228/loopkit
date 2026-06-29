---
name: changelog-from-diff
description: Turn a set of commits or a diff into a clean, user-facing changelog entry. Use before a release or PR description.
when_to_use: cutting a release, writing release notes, summarizing a branch
---
# Changelog from Diff
Read the actual diff/commits, not the commit messages (they lie).
Group into: **Added · Changed · Fixed · Removed · Security** (skip empty groups).
Each line: user-facing impact, not implementation. "Fixed login failing for emails with uppercase characters" — not "fixed bug in user lookup".
- Lead with what the user notices. Bury internals.
- Call out breaking changes loudly, with the migration step.
- Link the PR/issue. No marketing fluff.
Output: markdown ready to paste. If a change has no user impact, leave it out.
