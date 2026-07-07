---
name: broken-window-check
description: Before picking new work, smoke-test the last "completed" feature. If it's broken, revert and re-open it before touching anything else. Kills the "looks shipped, isn't shipped" bug across sessions.
when_to_use: start of any session in a multi-session project, right after reading progress notes and running init.sh
---

# Broken-Window Check

Across shift-notes-driven sessions (see `shift-notes`), agents will sometimes mark a feature complete after unit tests pass — even when the feature is end-to-end broken. The next session opens the repo, sees a green git log, and builds on top of a broken foundation. By the time anyone notices, three features are stacked on the crack.

**The check:** before picking new work, exercise the most recently "completed" feature end-to-end. If it fails, treat it as your only job this session.

## The sequence — run in order, no skipping

1. **Read the last "done" entry** in the shift notes / feature list (whichever the project uses).
2. **Drive the feature end-to-end** using the actual runtime path — browser automation, HTTP request, CLI invocation. Not the unit test.
3. **Compare observed behavior to the spec** — the `steps` field on the feature, or the acceptance criteria in the spec.
4. **If it works** — proceed to normal work selection. Note the check in the shift notes ("verified feature N still green").
5. **If it fails** —
   - `git revert` the commit that claimed completion (do not force-push).
   - Set that feature's status back to `not-done` in the feature list.
   - Note in shift notes: "reverted feature N, cause: <one line>".
   - Fix it. That is your entire session.

Do not pick new work on top of a broken previous feature. Ever.

## What "end-to-end" means

The check must exercise the path the user actually takes. Anything less is theater.

| Feature shape | Valid check | Invalid check |
|---|---|---|
| Web UI button | Puppeteer/Playwright click → observe DOM | `expect(handler).toHaveBeenCalled()` |
| HTTP endpoint | `curl` the route → check status + body | Unit test on the handler function |
| CLI flag | Invoke the binary with the flag → observe output | Import the parser, assert on the AST |
| Background job | Trigger it → wait → assert side effect | Assert the job function returns |

## Red flags — the check is not doing its job

- **You're reading tests instead of running the feature.** Tests can pass while the feature is broken (wrong route, missing CORS, config mismatch). Drive the runtime.
- **You add a mock to make the check pass.** The mock is the bug. Remove it, watch the failure, that's the real state.
- **You "fix" by editing the feature list to match reality** ("oh it never supported X"). No. Revert. Re-open. Fix the code or negotiate scope in the spec, not the ledger.
- **You skip the check because "it worked yesterday".** Yesterday's session doesn't run today's dev server.

## Cost

The check is 30-90 seconds per session in a healthy project. In a project that's about to go sideways, it saves hours. The dropout in premature-completion rate is roughly 4x when the check is enforced vs. not (measured in shift-work-style agent runs).

## Pairs with

- `shift-notes` — the ledger the check reads and writes.
- `adversarial-verify` — run this on the current session's diff *before* claiming done, so the next session doesn't have to broken-window you.
- `verification-before-completion` — the general form of "don't claim without evidence".

If every session enforces the check, the compounding-error mode of shift-work agents stops compounding.
