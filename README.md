# loopkit

**A curated library of 33 battle-tested skills that make any coding agent ship cleaner code — and stop guessing.**

Drop them into `.claude/skills/` (or any agent that reads SKILL.md) and your agent loads each one only when it's relevant: debug systematically, review for security, design real UIs, run agents in a lean loop, write the failing test first, ship clean commits.

```bash
npx claude-loopkit init
```

That's the whole install. Existing files are kept by default — pass `--force` to overwrite, `--dry-run` to preview.

Compatible with **Claude Code · Cursor · Codex · Gemini CLI**. Built on the agent-engineering patterns Anthropic publishes ([Building Effective Agents](https://www.anthropic.com/research/building-effective-agents), Claude Code docs) — distilled into skills you can actually drop in.

## What `init` writes

Into your current directory:

- `.claude/CLAUDE.md` — 60-line standing context
- `.claude/settings.json` — permission allowlist + format-on-write hook
- `.claude/agents/verifier.md` — adversarial verifier subagent
- `.claude/skills/` — the 33 skill files (load only on trigger)
- `.mcp.json` — MCP server wiring
- `MEMORY.md` — cross-session memory index
- `run.sh` — Plan→Act→Verify loop runner

## Why skills

A raw agent guesses. When it guesses, it fabricates — invented APIs, tests that pass nothing, "fixes" that rename the bug. A skill is a tight, reusable instruction set that loads only when its trigger matches, so the agent specializes instead of winging it — without paying for every skill's tokens on every prompt.

## The library (33 skills, 9 tracks)

| track | skills |
|---|---|
| **agent/llm** | context-budget · spec-first · tool-restraint · subagent-fanout |
| **debug** | systematic-debugging · read-the-trace · bisect-regression |
| **security** | owasp-review · authz-check · input-validation · secret-scan · dependency-audit |
| **frontend** | design-system · a11y-pass · loading-empty-error-states |
| **testing** | write-failing-test-first · flaky-hunter · coverage-gaps · contract-test |
| **refactor** | kill-dead-code · simplify · reduce-nesting |
| **docs** | changelog-from-diff · decision-record · readme-audit |
| **data** | sql-review · migration-writer · schema-diff |
| **git/ops** | clean-commits · pr-from-diff · rebase-safely · revert-surgical |
| **review** | adversarial-verify (the 11 shortcuts agents take to fake "done") |

Each skill: a focused technique, not a tutorial. Read one, fork it, make it yours.

## Bonus: the harness

`init` also drops a minimal working `.claude/` (standing context, permission allowlist, format-on-write hook, a verifier subagent, MCP wiring, memory index) and a Plan→Act→Verify loop runner — the floor your skills run on. Full theory: **Loop and Harness engineering: 7 files, 5 steps**.

MIT. Built to be forked.
