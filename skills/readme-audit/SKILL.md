---
name: readme-audit
description: Check whether a README actually lets a stranger run the project. Use on any repo's README before publishing.
when_to_use: publishing a repo, onboarding docs, "is the README good"
---
# README Audit
A README's only job: a stranger clones it and gets to "it works" without asking you.
Check, in order:
1. **One sentence** on what it is and who it's for — above the fold.
2. **Install** — copy-paste commands that actually work on a clean machine. Test them mentally step by step.
3. **Run / quickstart** — the smallest end-to-end example.
4. **Config** — required env vars, where secrets go.
5. **No rot** — does it reference files/commands/flags that still exist? Stale README is worse than none.
Cut: long philosophy, badges nobody reads, TODO sections. Output: the specific gaps + the fix.
