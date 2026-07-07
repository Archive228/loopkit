# AGENTS.md — loopkit loop contract

This repo runs long-lived agent sessions. Every session shares one contract:
**Plan → Act → Verify**, single-feature per session, clean state at the end.

This file is the cross-agent voice (Claude Code, Cursor, Codex CLI, Gemini CLI, Amp).
Claude-specific extras live in `.claude/CLAUDE.md`, which imports this file via `@../AGENTS.md`.

## The three-step loop

Every session, in order:

1. **Plan.** Read `PROMPT.md` (goal), `IMPLEMENTATION_PLAN.md` (state), and `git log --oneline -20` (history). If the last session claimed a feature done, smoke-test it before picking new work.
2. **Act.** Implement exactly one feature. Not two. Not "one and a small one".
3. **Verify.** Run `/verify` (adversarial pass against the diff) BEFORE claiming done or committing. Non-zero from `/verify` blocks the commit.

If `IMPLEMENTATION_PLAN.md` and the git log disagree, trust the git log. Git is append-only; the plan is rewritten each turn.

## Single-feature rule

One feature per session. Sessions that pack multiple features ship them all half-done — we have measured this. The next session takes the next feature. There is no reward for finishing more in one session; there is a real cost to leaving things half-done.

## Clean-state contract (end of every session)

- All code committed to git. Prefer `scripts/committer "<msg>" <files>` — it refuses `.` and empty messages.
- No uncommitted changes in the working tree.
- `IMPLEMENTATION_PLAN.md` updated: what was done, what is next, known open issues.
- Dev server killed (`./stop.sh` if the project has one).
- A feature is only "done" after end-to-end verification (`/verify`), not after unit tests alone.

## Skills vs rules

- **Skills** (`skills/*/SKILL.md`) — invoked on demand by trigger phrases in their `description`. Read the skill's SKILL.md before acting on a matching task.
- **Rules** (`.claude/rules/*.md`) — auto-loaded when a file path matches. Silent guardrails, not opt-in.

Full skill routing table: `skills/using-loopkit/SKILL.md` (repo layout) or `.claude/skills/using-loopkit/SKILL.md` (installed layout).

## Slash-command entry points

- `/spec` — write `PROMPT.md` before implementing. Refuses to run if `PROMPT.md` exists without `--force`.
- `/verify` — adversarial pass against the current diff. Non-zero exit blocks completion claims.
- `/loop` — describe or run the Plan → Act → Verify cycle.

## Never

- Weaken or delete a test to make red go green. If a test is wrong, fix the test in its own commit with justification.
- Mark work done without running `/verify`.
- Edit a merged migration. Migrations are additive-only.
- Add a dependency without justifying it in the commit body.
- Run `npm update`, `pip install -U`, or equivalents unless the feature is literally "upgrade dependencies".
- Push to `main` from an agent session. Humans push.

## Verify before you commit

The maker's-head reviewer always agrees with itself. `/verify` is a separate, hostile pass. Every code change goes through it. See `skills/adversarial-verify/SKILL.md` for the 11 shortcuts that fake "done".

## When user instructions and this file disagree

User instructions win. This file is the default when the user has not said otherwise.
