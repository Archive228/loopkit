---
name: progress-reading-protocol
description: Run the fixed 6-step session-opening sequence — pwd, read progress, git log, count remaining features, init.sh, smoke-test last feature — before touching any new work. The orientation ritual that lets fresh-context sessions reconstruct project state in under a minute.
when_to_use: very first tool calls of any fresh coding-agent session, rehydrating after a context reset or crash mid-project, verifying a claimed-shipped feature before picking up new work
---

# Progress-Reading Protocol

You have no memory of the previous session. The repo does. Every fresh session burns 5-10 minutes reconstructing state unless you follow a fixed opening sequence — with the sequence, it drops to 30-60 seconds. The cost is 2-4k tokens at the top of every session; the payoff crosses over past four sessions on the same project.

Skipping steps is the failure mode. Sessions that skip the smoke-test step (6) reliably build new features on top of silently broken ones. See the "looks shipped, isn't shipped" bug (originally documented in the shift-work harness pattern).

## When to apply

- First tool calls of any coding-agent session in a multi-session project.
- After a context reset, compaction, or crash mid-project — treat the resumed context as a fresh session.
- Before you write a single line of new code. No exceptions for "quick fixes."

## Procedure — run in order, no skipping

1. **`pwd`** — confirm you are in the project directory. You may only edit files below this path.
2. **Read `claude-progress.txt`** (or whatever the project's shift-notes file is called). This is the previous session's prose handoff.
2b. **Read `claude-decisions.json`** — the machine-readable ledger of decisions the loopkit `pre-compact` hook extracts before each compaction. Prose in `claude-progress.txt` tells you *what* the last session did; JSON in `claude-decisions.json` tells you *what was chosen and rejected*. If the two disagree on a specific choice, the JSON is the durable record. See [[active-memory-reminder]].
3. **`git log --oneline -20`** — see what was actually committed. If the progress file and the git log disagree, trust the git log. The progress file can be truncated by a crashed write; the log is append-only.
4. **Count remaining features** — `cat feature_list.json | jq '[.[] | select(.passes==false)] | length'`. Adjust the field name to the project's schema. This anchors you to the source of truth for completion state.
5. **`./init.sh`** — bring up the dev server. If this fails, fixing it is your only job this session. Do not skip to feature work with a broken environment.
6. **Smoke-test the most recently "completed" feature** — drive it end-to-end via the browser-automation tool, `curl`, or the actual CLI. Not unit tests. If it fails, invoke [[broken-window-check]]: revert the offending commit, flip the feature back to `passes: false`, and fix it before touching new work.

Only after all six steps pass do you pick new work (see [[shift-notes]] for selection heuristics).

## Anti-patterns

- **"I already know this repo, I'll skip the read."** You do not. The context you have is the context in front of you.
- **Reading the progress file but not the git log.** The prose lies; the log does not.
- **Running `init.sh` and assuming success without smoke-testing a feature.** The dev server can start clean while every route is broken.
- **Smoke-testing with unit tests.** Unit tests can pass while the feature is end-to-end broken — wrong route, missing header, config mismatch. Drive the runtime path.
- **Batching the 6 steps into "let me just get oriented."** The steps are cheap because they are fixed. Improvising the orientation is where tokens leak.

## Cost/benefit

Roughly 2-4k tokens and 30-60 seconds of wall-clock at the top of every session. Payoff crosses over past ~4 sessions on the same project; below that, the ritual is overhead. If your project is one-shot, use [[verification-before-completion]] instead.

## Related

- [[shift-notes]] — the prose ledger this protocol reads and writes.
- [[active-memory-reminder]] — the paired JSON decisions ledger read in step 2b.
- [[broken-window-check]] — the sub-protocol for step 6 when the smoke test fails.
- [[single-feature-per-session]] — what to do once orientation is complete.
- [[clean-state-contract]] — the mirror discipline at session-end that makes this protocol cheap for the next session.

When NOT to apply: single-shot sessions with no prior state, or the very first session of a project (there is nothing to read yet — run the initializer instead).