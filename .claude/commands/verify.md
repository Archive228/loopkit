---
description: Run adversarial verification on the current diff before claiming done. Loads the loopkit adversarial-verify skill and dispatches the verifier subagent.
argument-hint: "[--summary]"
allowed-tools: Read, Grep, Bash(git diff:*), Bash(git status:*), Bash(git log:*)
---

# /verify — adversarial verification pass

Assume the diff is broken. Prove it isn't.

## Steps

1. Load the goal spec:
   - Read `PROMPT.md` if it exists. If it does not, read `IMPLEMENTATION_PLAN.md`.
   - If neither exists, stop and tell the user to run `/spec` first. Do not verify against an absent contract.
2. Load the current diff:
   - `git diff HEAD` — uncommitted changes.
   - `git log --oneline -5` — recent context.
3. Invoke the `adversarial-verify` skill by reading `skills/adversarial-verify/SKILL.md` (repo layout) or `.claude/skills/adversarial-verify/SKILL.md` (installed layout). Walk the 11 shortcut checklist verbatim against the diff, plus the 4 environmental tells in `docs/checklists/red-flags.md`.
4. Dispatch the `verifier` subagent (`.claude/agents/verifier.md`) for a second, cold-context pass on the same diff.
5. Return a single JSON verdict, and nothing else:

   ```
   {"passes": bool, "failures": [{"file": str, "line": int, "shortcut": str, "why": str}]}
   ```

6. If `passes` is false: do NOT commit, do NOT mark the task done, print the failure list, and stop.

## Never

- Propose fixes in this pass. Verification is separate from repair — mixing them lets the model rationalize.
- Run application code. Read-only tools only.
- Be polite. Politeness is how "fake done" ships.
- Skip the shortcut checklist because "the diff is small".

## Exit contract

Non-zero exit on any failure. The `run.sh` loop treats non-zero as "not done" and re-runs the next turn.
