---
description: "Finn Loop: build a spec approved by human. Refuses to run without SPEC-APPROVED.md."
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash(git:*), Bash(ls:*), Bash(cat:*)
---

# /build (Finn Loop) — Plan → Act → Verify, gated on human ACK

This is a thin wrapper around the loopkit Plan / Act / Verify loop. The only thing it adds is a **hard gate at step 0**: it refuses to run unless the human has ACKed the spec by creating `SPEC-APPROVED.md`.

## Step 0 — the gate

1. If `SPEC-APPROVED.md` does not exist:
   - If `SPEC-PENDING.md` exists, stop and print:
     > Spec is pending human ACK. Run `mv SPEC-PENDING.md SPEC-APPROVED.md` when ready, then re-run `/build`.
   - Otherwise stop and print:
     > No approved spec. Run `/spec <task>` first, then ACK it with `mv SPEC-PENDING.md SPEC-APPROVED.md`.
   - Exit non-zero either way. Do not proceed.
2. Read `SPEC-APPROVED.md`. Treat it as the goal spec — same shape as base loopkit's `PROMPT.md` (Goal / Done when / Never touch / Stop if).

## Step 1 — Plan (base loopkit)

Follow the standard loopkit Plan step from `AGENTS.md`:

- Read `IMPLEMENTATION_PLAN.md` if it exists (state from prior sessions).
- `git log --oneline -20`.
- If the last session claimed a feature done, smoke-test it before picking new work (see `skills/broken-window-check/SKILL.md`).

## Step 2 — Act (base loopkit)

- Implement **exactly one feature**. Not two. The single-feature rule from base loopkit still applies inside Finn Loop.
- Follow every rule that already applies to base loopkit sessions: no `npm update`, no test deletion, no dependency additions without justification, no migration edits.

## Step 3 — Verify (base loopkit)

- Run `/verify` (the base loopkit adversarial pass). Non-zero from `/verify` blocks completion.
- If `/verify` fails 3× on the same task, load `hitl-escalate` and write `BLOCKED.md`. Do NOT keep looping.

## Step 4 — Hand off to /review

- Commit via `scripts/committer "<msg>" <files>` (base loopkit convention — refuses `.` and empty messages).
- Update `IMPLEMENTATION_PLAN.md` with what was done and what is next.
- Do NOT delete `SPEC-APPROVED.md` yet. `/review` needs it.
- Print:
  > Build complete. Next: `/review` to run polish + verify and post the merge signal.

## Never

- Run without `SPEC-APPROVED.md`. The gate is the whole point of Finn Loop.
- Bundle multiple features into one `/build` — the single-feature rule from base loopkit still applies.
- Move `SPEC-APPROVED.md` back to pending. If the spec is wrong, delete both spec files and start over with `/spec`.

## Pairs with

- `presets/finn-loop/spec.md` — the upstream gate that produced `SPEC-APPROVED.md`.
- `presets/finn-loop/review.md` — the downstream polish + verify + merge-signal step.
- `.claude/commands/verify.md` — the base loopkit adversarial pass this command delegates to.
