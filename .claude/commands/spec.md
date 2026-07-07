---
description: Write the goal spec (PROMPT.md) before implementing. Loads the loopkit spec-first skill.
argument-hint: "[--force]"
allowed-tools: Read, Write, Bash(ls:*)
---

# /spec — write the goal spec before you act

Without an external contract, the agent drifts after ~3 iterations and the failure looks like progress (code written, tests pass, wrong goal solved).

## Steps

1. If `PROMPT.md` exists and `--force` was NOT passed, stop and print:
   > `PROMPT.md` already exists. Re-run with `/spec --force` to overwrite, or edit the file directly.
2. Load the `spec-first` skill by reading `skills/spec-first/SKILL.md` (repo layout) or `.claude/skills/spec-first/SKILL.md` (installed layout).
3. Write `PROMPT.md` from `templates/PROMPT.md`, filling in from the user's latest turn:
   - **Goal** — one sentence, user-observable outcome.
   - **Done when** — concrete, testable conditions. Include the exact command that must go green.
   - **Never touch** — files and areas off-limits.
   - **Stop if** — abort conditions (scope creep, passing test starts failing, more than N files change outside scope).
4. Write `IMPLEMENTATION_PLAN.md` from `templates/IMPLEMENTATION_PLAN.md` with `STATUS: not-started` on line 1 (the exact string `run.sh` greps for).
5. Print both file paths and STOP. Do not implement in the same turn.

## Refuse if

- The user's request is too vague to write "Done when" concretely. Ask 1–3 clarifying questions and stop.
- The task is a one-line refactor or a typo fix. `/spec` is for tasks with more than 2 steps.

## Never

- Skip `PROMPT.md` because the task "seems small".
- Edit `PROMPT.md` after acting to match what you shipped. That is drift, not spec.
- Start writing code in the same turn as `/spec`. The user reviews first.
