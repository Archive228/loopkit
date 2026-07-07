---
name: using-loopkit
description: Use when starting any conversation in a loopkit-enabled project - establishes how to find and use loopkit's 41 skills, requiring skill invocation before ANY response including clarifying questions.
---

# Using Loopkit

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a loopkit skill applies to what you are doing, INVOKE it.

IF A SKILL APPLIES, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This overrides "just answer quickly" instincts. Not negotiable.
</EXTREMELY-IMPORTANT>

## The Rule

**Invoke relevant skills BEFORE any response or action** — including clarifying questions, exploring the codebase, or reading files. If it turns out wrong for the situation, drop it.

Then announce "Using [skill] to [purpose]" and follow the skill exactly. If it has a checklist, create a todo per item.

## Where the skills live

Skills are files at `.claude/skills/<name>/SKILL.md`. Each has YAML frontmatter with `name` and `description` (the description is a trigger phrase, not a summary). Load a skill by reading its SKILL.md when its trigger matches your task.

## Skill routing (41 skills, 10 tracks)

| Task shape | First skill |
|---|---|
| "Fix this bug" / test failing / crash | `systematic-debugging`, then `read-the-trace` |
| "It broke between two commits" | `bisect-regression` |
| "Flaky test" | `flaky-hunter` |
| "Add a feature" / write anything new | `spec-first`, then `write-failing-test-first` |
| "Refactor" / dead code / deep nesting | `kill-dead-code`, `simplify`, `reduce-nesting` |
| About to claim done / commit / open PR | `adversarial-verify` + `verification-before-completion` |
| Review a diff | `adversarial-verify`, `pr-from-diff` |
| Frontend / UI work | `design-system`, `a11y-pass`, `loading-empty-error-states` |
| Security touch | `owasp-review`, `authz-check`, `input-validation`, `secret-scan`, `dependency-audit` |
| Data / SQL / migrations | `sql-review`, `migration-writer`, `schema-diff` |
| Docs / changelog / README | `changelog-from-diff`, `decision-record`, `readme-audit` |
| Git ops | `clean-commits`, `pr-from-diff`, `rebase-safely`, `revert-surgical` |
| Test suite gaps | `coverage-gaps`, `contract-test` |
| Running out of context | `context-budget`, `tool-restraint` |
| Parallel work | `subagent-fanout` |

Full list: `ls .claude/skills/`.

## Red Flags — STOP and check for a skill

| Thought | Reality |
|---|---|
| "This is just a simple question" | Questions are tasks. Check first. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I remember this skill" | Skills evolve. Read the current SKILL.md. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "Tests pass, we're good" | `verification-before-completion` says: run the exact command, read the output, then claim. |

## Priority when multiple skills apply

Process skills first (spec-first, systematic-debugging, brainstorming), then implementation skills (design-system, sql-review, etc.), then finishers (adversarial-verify, verification-before-completion, clean-commits).

- "Let's build X" → `spec-first` → `write-failing-test-first` → domain skills → `adversarial-verify`.
- "Fix bug Y" → `systematic-debugging` → `read-the-trace` → fix → `verification-before-completion`.

## User instructions win

CLAUDE.md, AGENTS.md, and direct user requests override loopkit skills. Only skip a skill workflow when the user has explicitly said to.
