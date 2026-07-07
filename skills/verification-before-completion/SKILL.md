---
name: verification-before-completion
description: Use before claiming work is complete, fixed, or passing — before committing, opening a PR, or handing off. Requires running the verification command in THIS turn and reading its output before any success claim.
---

# Verification Before Completion

Claiming work done without fresh verification is dishonesty, not efficiency. `adversarial-verify` is the *what*; this skill is the *when* — the gate you pass through right before any completion claim.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you have not run the verification command in this message, you cannot claim it passes. Not "should", not "probably", not "based on the diff".

## The gate function

Before writing "done" / "fixed" / "green" / "ready to merge" — even in your own head:

1. **Identify** — what exact command proves this claim?
2. **Run** — execute it fresh, complete, in this turn.
3. **Read** — full output, check exit code, count failures.
4. **Verify** — does the output actually confirm the claim?
5. **Only then** — make the claim, with the evidence attached.

Skip any step = you are lying to the user, not verifying.

## Common false claims → what they actually need

| Claim | Requires | Not sufficient |
|---|---|---|
| Tests pass | Fresh test run, exit 0, 0 failures | "should pass", previous run, "logic looks right" |
| Linter clean | Linter output, 0 errors | Partial check, extrapolating from unrelated files |
| Build succeeds | Build command, exit 0 | Linter passing, editor squiggles gone |
| Bug fixed | Reproduce original symptom, watch it not happen | Code changed, "assumed" fixed |
| Regression test works | Red → green cycle verified (revert fix, watch test fail, restore, watch pass) | Test passes once |
| Agent/subagent completed | Read the VCS diff, verify claimed changes exist | Agent's own "success" report |
| Spec satisfied | Line-by-line checklist against the plan | "Tests pass, phase complete" |

## Red flags — you are about to claim without verifying

- Words like "should", "probably", "seems to", "looks good"
- Satisfaction language ("Great!", "Perfect!", "Done!") before running the command
- About to commit / push / open PR without a verification block in this turn
- Trusting a subagent's own success report
- "Just this once" thinking, or "I'm tired, close enough"
- Partial verification (linter passed, so build must)

## Rationalization prevention

| Excuse | Reality |
|---|---|
| "Should work now" | RUN it. |
| "I'm confident" | Confidence ≠ evidence. |
| "Linter passed" | Linter ≠ compiler ≠ tests. |
| "The agent said success" | Read the diff yourself. |
| "Partial check is enough" | Partial proves nothing about the whole. |
| "Different words, so rule doesn't apply" | Spirit over letter. |

## Patterns

**Tests**
- Run the test command. See `34/34 pass`. Then say "all tests pass".
- Never: "should pass now".

**Regression tests (real red-green)**
- Write test → run (pass) → revert fix → run (MUST FAIL) → restore fix → run (pass).
- Never: "I've added a regression test" without the red-green cycle.

**Build**
- Run the build. See exit 0. Then say "build passes".
- Never: "linter passed, build should too".

**Agent delegation**
- Subagent reports success → check the VCS diff → verify the claimed change is actually there → report actual state.
- Never: paste the agent's report and treat it as truth.

## When this fires

Always, before:
- Any variation of success / completion / fixed / passing / green
- Committing, opening a PR, marking a task done, handing off
- Moving to the next task
- Any positive statement about the work's state

## Pair with

- `adversarial-verify` — the 11 shortcuts agents take to fake "done"; run through the list, then run through this gate.
- `clean-commits` — clean commits require verified content.
- The `verifier` subagent — dispatch it; then verify its report against the diff (per the "Agent delegation" pattern above).

## The bottom line

Run the command. Read the output. THEN claim the result. Non-negotiable.
