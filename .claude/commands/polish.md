---
description: Run the batch quality pass over the current diff — simplify → reduce-nesting → kill-dead-code → a11y-pass → loading-empty-error-states → readme-audit.
argument-hint: "[--dry-run]"
allowed-tools: Read, Edit, Grep, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(ls:*)
---

# /polish — one-shot quality pass over the current diff

Apply six existing quality skills to the changes already in the working tree, in a fixed order, with a single summary at the end. No new features. No behavior changes beyond what each skill authorises.

## Scope

**This command applies to the CURRENT git diff only.** Run `git diff` first if you're unsure of scope. If the working tree is clean, stop and tell the user there is nothing to polish.

## Steps

1. Load the diff: `git diff HEAD` and `git status --short`. Fix on this set of changed files for the whole session; do not wander into untouched code.
2. Apply each skill below in order. For each: read the skill file from `skills/<name>/SKILL.md` (repo layout) or `.claude/skills/<name>/SKILL.md` (installed layout), walk its checklist against the diff, and apply the fixes it authorises. If the skill does not apply to this diff (e.g. `a11y-pass` on a backend-only change), record `skipped` with a one-line reason and move on.

   1. **simplify** — collapse indirection you don't need.
   2. **reduce-nesting** — early returns, guard clauses.
   3. **kill-dead-code** — prove unreachable, then delete.
   4. **a11y-pass** — semantics + keyboard + contrast (UI diffs only).
   5. **loading-empty-error-states** — all four states, not just happy path (async views only).
   6. **readme-audit** — cold-onboarding check (only if README or public interface changed).

3. Emit exactly ONE summary at the end, as a table:

   ```
   | skill                      | action_taken                          | verdict           |
   |----------------------------|---------------------------------------|-------------------|
   | simplify                   | <one line>                            | applied / skipped |
   | reduce-nesting             | <one line>                            | applied / skipped |
   | kill-dead-code             | <one line>                            | applied / skipped |
   | a11y-pass                  | <one line>                            | applied / skipped |
   | loading-empty-error-states | <one line>                            | applied / skipped |
   | readme-audit               | <one line>                            | applied / skipped |
   ```

## Never

- Add new features or fix bugs unrelated to the polish pass. If you spot a real bug, note it in the summary and stop — hand it back to the user, do not silently expand scope.
- Touch files outside the diff you loaded in step 1.
- Weaken or delete existing tests. If a test breaks after polishing, revert the offending polish edit — the test wins.
- Skip the summary. One diff, one table, one verdict per skill.

## Reminder

This command applies to the CURRENT git diff only. Run `git diff` first if you're unsure of scope.
