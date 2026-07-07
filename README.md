# loopkit

**Battle-tested skills + a working harness for coding agents.** Drop-in `.claude/` for any project. 33 skills that load only when relevant — so your agent specializes instead of guessing.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![Skills](https://img.shields.io/badge/skills-33-black.svg)](#the-library)
[![Compatible](https://img.shields.io/badge/agents-Claude%20Code%20%C2%B7%20Cursor%20%C2%B7%20Codex%20%C2%B7%20Gemini-black.svg)](#compatibility)
[![skills.sh](https://img.shields.io/badge/skills.sh-Archive228%2Floopkit-green.svg)](https://www.skills.sh/)

Straight from my `.claude/` directory. No new methodology to learn — just the mini-instructions I actually reach for.

## Install

Pick one. All three drop the same files into your current project.

```bash
# via skills.sh (recommended — works with any agent that reads SKILL.md)
npx skills add Archive228/loopkit

# via curl (no Node required)
curl -fsSL https://raw.githubusercontent.com/Archive228/loopkit/main/install.sh | bash

# via git (if you want to fork first)
git clone https://github.com/Archive228/loopkit && cp -r loopkit/.claude your-project/
```

30 seconds to first skill firing. Existing files are kept; pass `FORCE=1` to overwrite.

## The loop

Every skill fires inside this shape. The harness (bundled) enforces it.

```
  PLAN ──▶  ACT  ──▶  VERIFY
    ▲                    │
    └────── revise ──────┘
```

- **PLAN** — spec-first, context-budget, tool-restraint load here
- **ACT** — the domain skills load here (debug, security, testing, refactor, …)
- **VERIFY** — adversarial-verify + the verifier subagent close the loop

If a skill doesn't help the loop advance, it isn't in loopkit.

## The library

33 skills across 9 tracks. Each one: name → what it does → when it fires.

### agent/llm — how the agent behaves
- **context-budget** — trim the working set → *before large reads or long sessions*
- **spec-first** — write the contract before code → *any new feature or endpoint*
- **tool-restraint** — pick the smallest tool that fits → *avoids Bash-for-everything drift*
- **subagent-fanout** — parallelize independent probes → *research/audit tasks*

### debug
- **systematic-debugging** — hypothesis → test → narrow → *any bug you can't one-shot*
- **read-the-trace** — extract the actual failure from noise → *stack traces, CI logs*
- **bisect-regression** — git-bisect discipline → *"it worked yesterday"*

### security
- **owasp-review** — top-10 pass on a diff → *before merging user-facing changes*
- **authz-check** — verify every route enforces its policy → *auth surface changes*
- **input-validation** — validate at the edge → *any handler taking external data*
- **secret-scan** — catch keys before commit → *pre-push, PR review*
- **dependency-audit** — CVE + license triage → *lockfile changes*

### frontend
- **design-system** — reuse tokens, don't invent them → *any UI change*
- **a11y-pass** — semantics + keyboard + contrast → *before shipping a screen*
- **loading-empty-error-states** — all four states, not just happy path → *any async view*

### testing
- **write-failing-test-first** — red before green → *behavior changes, bug fixes*
- **flaky-hunter** — reproduce, isolate, quarantine → *intermittent CI reds*
- **coverage-gaps** — find behavior with no test → *before declaring "done"*
- **contract-test** — pin the API shape → *service boundaries*

### refactor
- **kill-dead-code** — prove unreachable, then delete → *cleanup passes*
- **simplify** — collapse indirection you don't need → *code review, "too clever"*
- **reduce-nesting** — early returns, guard clauses → *reading fatigue*

### docs
- **changelog-from-diff** — human-readable release notes → *tagging a version*
- **decision-record** — ADR for the "why" → *architectural choices*
- **readme-audit** — check onboarding path from cold → *before public share*

### data
- **sql-review** — indexes, N+1, plan → *any non-trivial query*
- **migration-writer** — reversible, zero-downtime → *schema changes*
- **schema-diff** — compare shapes, catch drift → *env sync*

### git/ops
- **clean-commits** — atomic, message-first → *before PR*
- **pr-from-diff** — summary the reviewer will actually read → *opening a PR*
- **rebase-safely** — no lost commits → *history cleanup*
- **revert-surgical** — undo only the offending change → *bad merges*

### review
- **adversarial-verify** — the 11 shortcuts agents take to fake "done" → *before flipping any task to complete*

## The harness (bundled)

The installer also drops the floor these skills stand on:

- `.claude/CLAUDE.md` — 60-line standing context
- `.claude/settings.json` — permission allowlist + format-on-write hook
- `.claude/agents/verifier.md` — adversarial verifier subagent
- `.mcp.json` — MCP server wiring
- `MEMORY.md` — cross-session memory index
- `run.sh` — Plan→Act→Verify loop runner

Full theory: **[Loop and Harness engineering: 7 files, 5 steps](./docs/effective-harnesses-v03.md)**.

## vs other skill packs

|  | loopkit | [obra/superpowers](https://github.com/obra/superpowers) | [mattpocock/skills](https://github.com/mattpocock/skills) | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
|---|---|---|---|---|
| Ships a harness (settings, verifier, loop runner) | **yes** | no | no | no |
| Skills load only on trigger (YAML frontmatter) | yes | yes | yes | yes |
| Methodology commitment required | **none** | Prime Radiant | GSD-adjacent | 6-phase lifecycle |
| Skill count | 33 | ~40 | ~19 | ~24 |
| Compatible with non-Claude agents | yes | Claude-first | multi | multi |
| Install size | tiny | medium | medium | medium |

Full breakdown: [docs/vs-others.md](./docs/vs-others.md).

## Reference checklists (loaded on demand)

Skills stay short. When one needs a longer reference, it points at `docs/checklists/`:

- [Definition of Done](./docs/checklists/definition-of-done.md) — what "shipped" actually means
- [Red Flags](./docs/checklists/red-flags.md) — 15 patterns the verifier looks for
- [Rationalizations](./docs/checklists/rationalizations.md) — excuses agents give and their rebuttals

## Compatibility

Works with anything that reads `SKILL.md`: **Claude Code · Cursor · Codex · Gemini CLI · Windsurf · Copilot**. Every skill file is a plain markdown doc with a YAML header — nothing agent-specific inside.

## Positioning

loopkit is deliberately not a methodology. Approaches like BMAD, Spec-Kit, and full lifecycle skill packs try to help by owning the process — but they take away the control that makes agents useful in your codebase. loopkit gives you the mini-skills and a floor to stand on. Everything else is yours to shape.

Follow the build: [@archive on X](https://x.com/archive) · article: *Loop and Harness engineering*.

MIT. Built to be forked.
