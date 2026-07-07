---
name: shift-notes
description: Write and read the between-session handoff file so a fresh agent with no memory can pick up where the last one stopped without re-deriving context. Structured prose, not JSON — the model writes prose better.
when_to_use: end of any session in a multi-session project, start of the next one; pairs with broken-window-check and feature-list state files
---

# Shift Notes

The hard problem in long-running agents is not doing work in one session — it's bridging the context gap between sessions. Every fresh agent starts with zero memory. If it has to reconstruct project state from the code, it burns 5-10 minutes and a chunk of context before writing a line. If it has a well-shaped handoff file, that drops to 30-60 seconds.

That handoff file is `claude-progress.txt` (or equivalent). Prose, not JSON. The model writes prose more naturally, and the read is cheap.

## The format — write into this shape

```
# Project: <name>
# Last updated: <ISO timestamp> by session <id>

## What's done
- <feature> [feature-list index: N]
- ...

## What's in progress
- <feature> [feature-list index: N]
  Status: <one paragraph — what works, what doesn't>
  Files touched this session: <list>
  Known open issues: <list>

## What's next (recommended)
- <feature> [feature-list index: N]
  Reason: <why this one>

## Notes for the next session
<free-form prose: gotchas, flaky tests, environment quirks>
```

Enforced softly by the prompt, not by validation. Free text is the point — the notes section is where the previous shift warns the next one about the thing that isn't captured anywhere else.

## Writing the notes — at end of session

- **Move the completed feature** from "in progress" to "done".
- **Recommend the next feature** in "what's next" with a one-line reason (unblocks-N, low-risk, prerequisite-for-M).
- **Notes-for-next-session** is the highest-leverage field. Use it for: flaky tests you hit, dependencies that surprised you, spec ambiguities you resolved one way (so the next agent doesn't re-litigate), env vars that need to be set.
- **Do not delete "done" entries.** They're audit trail. If the section gets long, that's a signal to compact the whole notes file at v0.2 milestones, not to prune mid-project.

## Reading the notes — at start of session

- Read the whole file. It's small.
- **If shift notes and git log disagree, trust the git log.** The notes can be truncated by a crashed session; the log can't. This is a load-bearing rule.
- Cross-reference "what's done" against the feature list. If the notes claim done but the feature list says not-done, run `broken-window-check`.
- Pick work from "what's next" unless it's stale (a new session already picked it).

## Red flags

- **Notes rewritten every session from scratch.** Lose history, lose audit trail. Append and edit in place, don't overwrite.
- **"What's done" section grows unboundedly.** Fine up to ~40 entries. Past that, compact by feature milestone.
- **Ambiguous "in progress" prose.** The next session will misread "the button is wired but the state doesn't refresh" as "done" if you write "button works". Be precise about what fails.
- **Notes drift out of sync with the feature list.** Feature list is source of truth for pass/fail state; notes are the prose gloss. When they disagree, the list wins.
- **JSON handoff file.** Tried and abandoned — the model wrote shorter, less useful notes when forced into JSON. Prose wins for prose.

## What NOT to put in the notes

- Full file contents. Reference paths, not blobs.
- Chain-of-thought for the session. Compact it into a status line.
- Anything that belongs in the feature list (pass/fail state) or in git (what changed).

## Pairs with

- `broken-window-check` — reads the "what's done" list to know what to smoke-test.
- `spec-first` — the spec is the contract; the notes are the ledger against it.
- `context-budget` — the notes are the compact recap the context-budget skill wants.

The shift-notes file is the memory of the project. Treat it as load-bearing.
