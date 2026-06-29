# loopkit

**The drop-in `.claude/` setup + skill library that makes your Claude agent actually finish.**

Most builders fight the loop. The loop is the easy part. The floor it runs on isn't set up.

`loopkit` is the floor: the 7 files that go under your loop, plus 20+ battle-tested skills your agent loads only when it needs them.

```bash
npx loopkit init
```

One command drops a working `.claude/` into any repo: standing context, a permission allowlist, a format-on-write hook, an adversarial verifier subagent, a skill library, MCP wiring, and a memory index — then a Plan→Act→Verify loop runner on top.

## Why

A loop without a harness is a faster way to ship bugs. The agent guesses; when it guesses it fabricates — invented files, invented commands, tests that pass nothing. The harness stops the guessing.

## What you get
- **7 harness files** — CLAUDE.md, settings.json, hooks, a verifier subagent, skills/, .mcp.json, memory.
- **20+ skills, 8 tracks** — debug · security · frontend · testing · refactor · docs · data · git/ops. Progressive load: only name+description enter context until the agent decides it's relevant.
- **run.sh** — fresh context each turn, state on disk, exits when the spec says done.

Full breakdown: **Loop and Harness engineering: 7 files, 5 steps** ← your article.

MIT. Built to be forked.
