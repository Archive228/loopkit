---
name: model-routing
description: Split the Plan/Act/Verify loop across three model tiers — frontier planner, cheap executor, frontier judge — via env vars read by run.sh.
when_to_use: when a long unattended loop is being tuned for cost, or when you want a stronger judge than executor.
---

# Model routing

`run.sh` reads three optional env vars and threads them into each `claude` invocation as `--model`. All default to unset, in which case the CLI default model is used (behaviour unchanged from a bare run).

## The three knobs

- `CLAUDE_PLANNER_MODEL` — reserved for `/spec` workflows that draft PROMPT.md up front. Not read by the current `run.sh` loop, but claimed here so future planner passes bind to it.
- `CLAUDE_EXECUTOR_MODEL` — used on the "do the next step" call. This is the workhorse; it runs on every iteration. Pick something cheap and fast.
- `CLAUDE_JUDGE_MODEL` — used on the `/verify` call. Runs once per iteration to adversarially check the executor's diff. Pick a frontier model — a weak judge is worse than no judge.

## Recommended shape

```
planner  = frontier   (Opus-class, runs once at /spec time)
executor = cheap-fast (Haiku-class, runs every turn)
judge    = frontier   (Opus-class, runs every turn but on a small diff)
```

## Example

```bash
export CLAUDE_PLANNER_MODEL="claude-opus-4-7"
export CLAUDE_EXECUTOR_MODEL="claude-haiku-4-7"
export CLAUDE_JUDGE_MODEL="claude-opus-4-7"
./run.sh
```

## The Elvis Executor+Judge finding

A cheap executor paired with a frontier judge outperforms a frontier executor with no judge on long loops. The judge catches the executor's premature-victory claims that a mono-model run rationalises away when it runs out of context. Cost stays low because the judge only sees the diff, not the working history.
