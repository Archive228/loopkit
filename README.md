# loopkit

**A curated library of 22 battle-tested skills that make any coding agent ship cleaner code — and stop guessing.**

Drop them into `.claude/skills/` (or any agent that reads SKILL.md) and your agent loads each one only when it's relevant: debug systematically, review for security, design real UIs, write the failing test first, kill dead code, ship clean commits.

```bash
npx loopkit init
```

Compatible with **Claude Code · Cursor · Codex · Gemini CLI**. Built on the agent-engineering patterns Anthropic publishes ([Building Effective Agents](https://www.anthropic.com/research/building-effective-agents), Claude Code docs) — distilled into skills you can actually drop in.

## Why skills

A raw agent guesses. When it guesses, it fabricates — invented APIs, tests that pass nothing, "fixes" that rename the bug. A skill is a tight, reusable instruction set that loads only when its trigger matches, so the agent specializes instead of winging it — without paying for 40 skills' worth of tokens on every prompt.

## The library (22 skills, 8 tracks)

| track | skills |
|---|---|
| **debug** | systematic-debugging · bisect-regression |
| **security** | owasp-review · secret-scan · dependency-audit |
| **frontend** | design-system · a11y-pass |
| **testing** | write-failing-test-first · flaky-hunter · coverage-gaps |
| **refactor** | kill-dead-code · simplify |
| **docs** | changelog-from-diff · decision-record · readme-audit |
| **data** | sql-review · migration-writer · schema-diff |
| **git/ops** | clean-commits · pr-from-diff · rebase-safely |
| **review** | adversarial-verify (the 11 shortcuts agents take to fake "done") |

Each skill: a focused technique, not a tutorial. Read one, fork it, make it yours.

## Bonus: the harness

`init` also drops a minimal working `.claude/` (standing context, permission allowlist, format-on-write hook, a verifier subagent, MCP wiring, memory index) and a Plan→Act→Verify loop runner — the floor your skills run on. The full theory: **Loop and Harness engineering: 7 files, 5 steps**.

MIT. Built to be forked.
