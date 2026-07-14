---
description: "Finn Loop: draft spec, wait for human ACK before /build fires."
argument-hint: "[--force]"
allowed-tools: Read, Write, Bash(ls:*)
---

# /spec (Finn Loop variant) — draft, then STOP

Base `/spec` writes `PROMPT.md` and expects the same session to keep going. The Finn Loop variant splits those two beats: this command drafts the spec into **`SPEC-PENDING.md`** and exits the loop, exactly like `hitl-escalate` does with `BLOCKED.md`. `/build` will refuse to run until a human writes `SPEC-APPROVED.md`.

## Steps

1. If `SPEC-PENDING.md` exists and `--force` was NOT passed, stop and print:
   > `SPEC-PENDING.md` already exists (awaiting human ACK). Re-run with `/spec --force` to overwrite, or `touch SPEC-APPROVED.md` to advance.
2. If `SPEC-APPROVED.md` exists, stop and print:
   > A spec is already approved. Delete `SPEC-APPROVED.md` and `SPEC-PENDING.md` before drafting a new one.
3. Load the `spec-first` skill by reading `skills/spec-first/SKILL.md` (repo layout) or `.claude/skills/spec-first/SKILL.md` (installed layout).
4. Write `SPEC-PENDING.md` filled in from the user's latest turn. Use the same four sections base `/spec` uses:
   - **Goal** — one sentence, user-observable outcome.
   - **Done when** — concrete, testable conditions. Include the exact command that must go green.
   - **Never touch** — files and areas off-limits.
   - **Stop if** — abort conditions.
5. Print the file path plus this exact unblock instruction:
   > Draft written to `SPEC-PENDING.md`. Review it. When ready to build, run:
   > `mv SPEC-PENDING.md SPEC-APPROVED.md`
   > `/build` will refuse to run until that file exists.
6. **STOP the loop.** `run.sh` treats the presence of `SPEC-PENDING.md` (without a sibling `SPEC-APPROVED.md`) exactly like `BLOCKED.md`: exit code 2, no further iterations.

## Refuse if

- The request is too vague to write "Done when" concretely. Ask 1–3 clarifying questions and stop — do not write a vague `SPEC-PENDING.md`.
- The task is a one-line refactor or typo fix. Finn Loop is overhead for anything under 3 steps; use base `/spec` or just edit.

## Never

- Skip the ACK. `SPEC-PENDING.md` without a sibling `SPEC-APPROVED.md` is a hard gate.
- Write to `PROMPT.md` from this command. Finn Loop uses `SPEC-PENDING.md` / `SPEC-APPROVED.md`; the base loop uses `PROMPT.md`. Do not mix.
- Edit `SPEC-APPROVED.md` after the human ACKs it. That is drift, not spec.
- Start writing code in the same turn. The whole point is the human beat between draft and build.

## Pairs with

- `hitl-escalate` — same exit-code-2 loop-halt mechanism, different trigger.
- `spec-first` — the underlying skill this command wraps.
