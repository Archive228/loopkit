---
name: using-loopkit
description: Use when starting any conversation in a loopkit-enabled project - establishes how to find and use loopkit's 49 skills, requiring skill invocation before ANY response including clarifying questions.
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

## Skill routing (49 skills, 10 tracks)

| Task shape | First skill |
|---|---|
| "Fix this bug" / test failing / crash | `systematic-debugging`, then `read-the-trace` |
| "It broke between two commits" | `bisect-regression` |
| "Flaky test" | `flaky-hunter` |
| "Add a feature" / write anything new | `spec-first`, then `write-failing-test-first` |
| "Refactor" / dead code / deep nesting | `kill-dead-code`, `simplify`, `reduce-nesting` |
| About to claim done / commit / open PR | `adversarial-verify` + `verification-before-completion` + `self-eval-bias` |
| Review a diff | `adversarial-verify`, `pr-from-diff` |
| Frontend / UI work | `design-system`, `a11y-pass`, `loading-empty-error-states` |
| Security touch | `owasp-review`, `authz-check`, `input-validation`, `secret-scan`, `dependency-audit` |
| Data / SQL / migrations | `sql-review`, `migration-writer`, `schema-diff` |
| Docs / changelog / README | `changelog-from-diff`, `decision-record`, `readme-audit` |
| Git ops | `clean-commits`, `pr-from-diff`, `rebase-safely`, `revert-surgical` |
| Test suite gaps | `coverage-gaps`, `contract-test` |
| Running out of context | `context-budget`, `tool-restraint` |
| Parallel work | `subagent-fanout` |
| Starting a fresh project / major feature | `planner-spec-expand`, then `feature-list-json`, then `init-script-contract` |
| Bootstrapping into an existing multi-session project | `progress-reading-protocol` |
| Entering an implementation sprint | `sprint-contract` |
| Calibrating a reviewer / evaluator | `evaluator-calibration` |
| New Claude/Sonnet/Opus model landed | `harness-stripping` |

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
| "I'll do both features while I'm in here" | `single-feature-discipline` says: one per session. Never two. |
| "The reviewer will let this slide" | `self-eval-bias` says: assume it will confidently praise. Calibrate first. |

## Priority when multiple skills apply

Process skills first (spec-first, systematic-debugging, planner-spec-expand, sprint-contract), then implementation skills (design-system, sql-review, etc.), then finishers (adversarial-verify, verification-before-completion, self-eval-bias, clean-commits).

- "Let's build X" → `planner-spec-expand` → `feature-list-json` → `sprint-contract` → domain skills → `adversarial-verify`.
- "Fix bug Y" → `systematic-debugging` → `read-the-trace` → fix → `verification-before-completion`.
- "Session open in existing project" → `progress-reading-protocol` → `sprint-contract` → work.

## Skill release convention

Every new skill in loopkit ships as a folder with four required files. No exceptions — a skill without these is a draft, not a release.

```
skills/<skill-name>/
  SKILL.md            # the skill itself (frontmatter + procedure)
  POST.md             # ~200-word X-thread-shaped explainer
  evidence/
    before.md         # verbatim transcript WITHOUT the skill loaded
    after.md          # same prompt WITH the skill loaded
```

- `SKILL.md` — routed on its frontmatter `description`. Body under ~150 lines.
- `POST.md` — the announcement thread. Copy from `template/POST.md`, fill in every placeholder before publishing.
- `evidence/before.md` + `evidence/after.md` — one real task, both transcripts. The before/after pair is the receipt that the skill actually changes behaviour. If you cannot produce it, the skill is not ready; land it as a draft and merge once the evidence is real.

Bootstrap a new skill by copying `template/` verbatim:

```
cp -r template skills/<skill-name>
```

Then edit SKILL.md, write POST.md, and capture the before/after pair.

## User instructions win

CLAUDE.md, AGENTS.md, and direct user requests override loopkit skills. Only skip a skill workflow when the user has explicitly said to.
