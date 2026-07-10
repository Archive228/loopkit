<div align="center">

```
   ▄█        ▄██████▄   ▄██████▄     ▄███████▄  ▄█   ▄█▄  ▄█      ███
  ███       ███    ███ ███    ███   ███    ███ ███ ▄███▀ ███  ▀█████████▄
  ███       ███    ███ ███    ███   ███    ███ ███▐██▀   ███▌    ▀███▀▀██
  ███       ███    ███ ███    ███   ███    ███ ▄█████▀   ███▌     ███   ▀
  ███       ███    ███ ███    ███ ▀█████████▀ ▀▀█████▄   ███▌     ███
  ███       ███    ███ ███    ███   ███         ███▐██▄  ███      ███
  ███▌    ▄ ███    ███ ███    ███   ███         ███ ▀███▄███      ███
  █████▄▄██  ▀██████▀   ▀██████▀   ▄████▀       ███   ▀█▀ █▀     ▄████▀
```

**A drop-in `.claude/` harness + 49 battle-tested skills for coding agents.**

Plan → Act → Verify, enforced by files on disk. Ships the floor, keeps out of your way.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![Skills](https://img.shields.io/badge/skills-49-black.svg)](#the-library)
[![Tracks](https://img.shields.io/badge/tracks-10-black.svg)](#the-library)
[![Compatible](https://img.shields.io/badge/agents-Claude%20Code%20%C2%B7%20Cursor%20%C2%B7%20Codex%20%C2%B7%20Gemini-black.svg)](#compatibility)
[![skills.sh](https://img.shields.io/badge/skills.sh-Archive228%2Floopkit-green.svg)](https://www.skills.sh/)

</div>

---

## 30-second quickstart

```bash
# 1. drop the harness into your project (safe: skips existing files)
curl -fsSL https://raw.githubusercontent.com/Archive228/loopkit/main/install.sh | bash

# 2. open Claude Code / Cursor / Codex in the same directory
claude

# 3. write a one-line spec, then let the loop drive
echo "STATUS: not-started" > IMPLEMENTATION_PLAN.md
./run.sh
```

That's it. Skills load only when a task triggers them. The verifier subagent closes the loop.

> Existing files are kept by default. Pass `FORCE=1` to overwrite, or `BACKUP=1` to snapshot your current `.claude/` to `.claude.bak-<timestamp>/` before writing.

---

## What loopkit is (and isn't)

Straight from my own `.claude/` directory. This is the loadout I actually reach for — not a methodology, not a lifecycle, not a framework.

**loopkit is:**
- A working harness: settings, hooks, verifier subagent, loop runner. Files on disk, no runtime.
- 49 small skills that load only when relevant, so the agent specializes instead of guessing.
- Cross-agent. Every skill is a plain markdown doc with a YAML header — nothing Claude-specific inside the skill body.

**loopkit isn't:**
- A new methodology to learn. No BMAD, no Prime Radiant, no 6-phase lifecycle. If a skill doesn't help the loop advance, it isn't here.
- A wrapper CLI. No daemon, no server, no runtime state. `run.sh` is 8 lines.
- A vendor lock-in. Fork it, gut it, keep the three skills you like. MIT.

---

## The loop

Every skill fires inside this shape. The harness enforces it.

```
  PLAN ──▶  ACT  ──▶  VERIFY
    ▲                    │
    └────── revise ──────┘
```

- **PLAN** — `spec-first`, `context-budget`, `tool-restraint`, `planner-spec-expand`, `sprint-contract` load here.
- **ACT** — domain skills load here (debug, security, testing, refactor, docs, data, git-ops).
- **VERIFY** — `adversarial-verify` + `evaluator-calibration` + the verifier subagent close the loop before anything ships.

Full theory: **[Loop and Harness engineering: 7 files, 5 steps](./docs/effective-harnesses-v03.md)**.

---

## File-by-file: what you get

```
your-project/
├── .claude/
│   ├── CLAUDE.md          # 60-line standing context (edit for your stack)
│   ├── settings.json      # permission allowlist + format-on-write hook
│   ├── agents/
│   │   └── verifier.md    # adversarial verifier subagent (Haiku, JSON-out)
│   ├── hooks/             # session-start bootstrap
│   └── skills/            # 49 skills, symlinked or copied
├── .mcp.json              # MCP server wiring (github, context7)
├── MEMORY.md              # cross-session memory index (keep terse)
└── run.sh                 # Plan → Act → Verify loop runner
```

Every file below is opinionated on purpose. Change what doesn't fit; the loop still works.

### `.claude/CLAUDE.md` — standing context
60 lines, no more. The tax on every turn. Stack, layout, commands, conventions, the three things the agent must never do. Prune weekly.

### `.claude/settings.json` — permissions + hooks
Allowlist for read-only Bash and Read; deny-list for `rm -rf` and force-push. `PostToolUse` hook runs Prettier on every Edit/Write so the diff stays reviewable.

### `.claude/agents/verifier.md` — the adversarial subagent
Runs on Haiku. Reads the diff assuming it's broken. Checks the 11 "fake done" shortcuts (see `skills/adversarial-verify`). Returns JSON. Does not propose fixes, does not run code, does not be polite. This is the load-bearing piece.

### `.claude/hooks/` — session-start bootstrap
Fires when the agent opens the project. Reminds it of the loop shape and points at `CLAUDE.md`. Zero runtime cost.

### `.claude/skills/` — the 49-skill library
Each skill: YAML frontmatter with `name` + `description`, a short body, no runtime dependencies. Loads only when its trigger fires. See the full list below.

### `.mcp.json` — MCP wiring
GitHub + Context7 by default. Add your own; the harness doesn't care.

### `MEMORY.md` — cross-session index
Preferences, decisions, feedback you keep re-applying. Prune every session or it becomes rot.

### `run.sh` — the loop runner
8 lines. Reads `PROMPT.md` + `IMPLEMENTATION_PLAN.md`, does one step, verifies, loops until `STATUS: done`. Fresh context each turn; state lives on disk.

---

## The library

**49 skills across 10 tracks.** Each one: name → what it does → when it fires.

### agent/llm — how the agent behaves
- **context-budget** — trim the working set → *before large reads or long sessions*
- **spec-first** — write the contract before code → *any new feature or endpoint*
- **tool-restraint** — pick the smallest tool that fits → *avoids Bash-for-everything drift*
- **subagent-fanout** — parallelize independent probes → *research/audit tasks*

### loop & harness — long-running, multi-session, multi-agent discipline
- **planner-spec-expand** — 1–4 sentence brief → full ambitious spec with design language and ordered feature list → *starting a fresh project or major feature*
- **sprint-contract** — negotiate "done" as script-decidable predicates before code → *entering an implementation sprint with an evaluator in the loop*
- **feature-list-json** — enumerate every feature as strict JSON, `passes:false`, editable-passes-only → *multi-session builds*
- **init-script-contract** — idempotent `init.sh` + `test.sh`/`stop.sh`/`reset.sh` siblings, under 120s → *setting up a repo for multi-session agent work*
- **progress-reading-protocol** — fixed 6-step session-open ritual (pwd → progress → git log → feature-count → init → smoke-test) → *any session bootstrapping into an existing project*
- **self-eval-bias** — interrupt confidently-praise-my-own-work drift → *when an agent is about to declare success on its own output*
- **evaluator-calibration** — few-shot the reviewer persona with rubric anchors to keep skepticism from drifting lenient → *before a long autonomous run with a reviewer agent*
- **harness-stripping** — remove one harness component at a time and measure impact, on every model release → *when a new model lands, before piling on more scaffolding*

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
- **verification-before-completion** — run the exact command, read the output, then claim → *before any "done" claim*

---

## Reference checklists (loaded on demand)

Skills stay short. When one needs a longer reference, it points here:

- [Definition of Done](./docs/checklists/definition-of-done.md) — what "shipped" actually means
- [Red Flags](./docs/checklists/red-flags.md) — 15 patterns the verifier looks for
- [Rationalizations](./docs/checklists/rationalizations.md) — excuses agents give and their rebuttals

---

## Install

Pick one. All three drop the same files into your current project.

```bash
# via curl (no Node required, recommended)
curl -fsSL https://raw.githubusercontent.com/Archive228/loopkit/main/install.sh | bash

# via skills.sh (works with any agent that reads SKILL.md)
npx skills add Archive228/loopkit

# via git (if you want to fork first)
git clone https://github.com/Archive228/loopkit
cp -r loopkit/.claude your-project/
```

**Options for the curl installer:**

| Env var | Effect |
|---|---|
| `FORCE=1` | Overwrite existing files instead of skipping |
| `BACKUP=1` | Snapshot existing `.claude/` to `.claude.bak-<timestamp>/` before writing |
| `DEST=/path` | Install into a specific directory instead of `$PWD` |
| `LOOPKIT_REF=<branch>` | Install from a specific branch/tag (default `main`) |

The installer prints every write, verifies the `claude` CLI is on your PATH afterward, and exits non-zero if anything critical failed.

---

## Compatibility

Works with anything that reads `SKILL.md`:

**Claude Code · Cursor · Codex · Gemini CLI · Windsurf · GitHub Copilot CLI**

Every skill file is a plain markdown doc with a YAML header. Nothing agent-specific inside the body. If your agent reads `.claude/skills/`, `~/.claude/skills/`, or a `SKILL.md` file, loopkit fits.

The bundled harness (`settings.json`, hooks, verifier subagent) is Claude-Code-shaped. Cursor/Codex/Gemini users can ignore the harness and use just the skills — or port the three harness files (they're small).

---

## vs other skill packs

|  | loopkit | [obra/superpowers](https://github.com/obra/superpowers) | [mattpocock/skills](https://github.com/mattpocock/skills) | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
|---|---|---|---|---|
| Ships a harness (settings, verifier, loop runner) | **yes** | no | no | no |
| Skills load only on trigger (YAML frontmatter) | yes | yes | yes | yes |
| Methodology commitment required | **none** | Prime Radiant | GSD-adjacent | 6-phase lifecycle |
| Skill count | 49 | ~40 | ~19 | ~24 |
| Compatible with non-Claude agents | yes | Claude-first | multi | multi |
| Install size | tiny | medium | medium | medium |

Full breakdown: [docs/vs-others.md](./docs/vs-others.md).

---

## Positioning

loopkit is deliberately not a methodology. Approaches like BMAD, Spec-Kit, and full lifecycle skill packs try to help by owning the process — but they take away the control that makes agents useful in your codebase. loopkit gives you the mini-skills and a floor to stand on. Everything else is yours to shape.

The two failure modes long-running agents actually hit (doing too much at once; premature victory) are structural, not skill-shaped. `run.sh` + the verifier subagent are the structural answer. The skills just make each turn cheaper. The new **loop & harness** track (planner-spec-expand, sprint-contract, evaluator-calibration, harness-stripping, and friends) operationalizes the multi-session discipline described in the companion article.

---

## Contributing

PRs welcome. The bar:

1. **Skills stay small.** One page, one trigger, one purpose. If it needs 200 lines it belongs in `docs/checklists/`.
2. **Every skill has YAML frontmatter** — `name`, `description`. Nothing else is required; nothing else should be added without a reason.
3. **No new methodologies.** loopkit doesn't ship lifecycles, phases, or ceremonies. Add a skill, not a framework.
4. **Match the existing file when editing.** Read it before you write.

Adding a skill:

```bash
# 1. copy the template (once available in template/SKILL.md)
cp template/SKILL.md skills/my-new-skill/SKILL.md

# 2. write it
$EDITOR skills/my-new-skill/SKILL.md

# 3. validate the frontmatter shape
./scripts/validate-skills

# 4. open a PR
```

Full contribution guide: [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## License

MIT. Built to be forked. Follow the build: [@archive on X](https://x.com/archive) · article: *Loop and Harness engineering*.
