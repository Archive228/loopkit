@../AGENTS.md

# Project: <name>
Stack: <language, framework, db>.
Layout: `src/` (code), `tests/`, `db/migrations/`.

## Commands
- `<run dev>` — local server
- `<run tests>` — test suite
- `<run lint>` — lint/format

## Conventions
- Match the existing code in the file you're editing. Read it before you write.
- One change, one purpose. No "while I was in there".

## Claude-specific

- Slash commands live in `.claude/commands/`. `/spec`, `/verify`, and `/loop` are the primary entry points.
- The `verifier` subagent (`.claude/agents/verifier.md`) is dispatched by `/verify` and can be reused as an eval grader.
- The SessionStart hook (`.claude/hooks/session-start`) injects the `using-loopkit` skill on startup, `/clear`, and compaction — so skill routing is loaded from turn 1.
- Cross-agent rules live in the imported `AGENTS.md` at repo root. Do not duplicate them here.

<!-- Keep under 300 lines. Prune weekly. Every paragraph is a tax on every turn. -->
