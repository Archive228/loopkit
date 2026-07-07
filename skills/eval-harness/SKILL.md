---
name: eval-harness
description: Build a repeatable eval loop that grades agent output with an LLM judge, so prompt/skill changes get scored against a baseline instead of eyeballed. Reuses loopkit's verifier subagent as the grader — do not build a new one.
when_to_use: tuning a prompt, changing a skill, comparing two models, regression-testing a workflow, "does this actually work better?"
---

# Eval Harness

Every prompt tweak in a long-running agent looks like an improvement in the moment. The only way to know is a graded run against fixed inputs. Loopkit already ships `.claude/agents/verifier.md` — that is your grader. Do not rebuild it.

## The three-stage loop

```
inputs.jsonl  →  runner  →  outputs.jsonl  →  verifier (per row)  →  verdicts.jsonl  →  diff vs baseline
```

Each stage writes to disk. No stage holds the whole run in context.

## Stage 1 — inputs.jsonl

One JSON object per row: `{"id": "case-01", "input": "...", "expected": "..."}`.

- 20-100 cases is enough for a signal. More is nice, not required.
- Include known-hard cases, edge cases, and a couple of trivial ones as sanity anchors.
- Freeze the file. Rev the eval with a suffix (`inputs-v2.jsonl`) when you change it. Never edit in place — you lose the baseline.

## Stage 2 — runner

A dumb loop: for each row, call the model with the current prompt/skill, capture output, write `{"id": ..., "output": ...}` to `outputs.jsonl`. No grading here — just capture.

- Same temperature every run (usually 0 for evals).
- Same seed / model version.
- Log the git SHA of the prompt/skill under test in the file header.

If the runner is smart it will bias the eval. Keep it dumb.

## Stage 3 — verifier

Fan out one subagent per row (see `subagent-fanout`). Each gets:
- The input.
- The expected output (or spec).
- The actual output.
- The verifier system prompt from `.claude/agents/verifier.md`.

Verifier returns strict JSON: `{"pass": bool, "why": "..."}`. Collect into `verdicts.jsonl`.

## Diff vs baseline

Two runs of the same eval on two prompt versions → compare pass rates per case. What matters:

- **Overall pass rate** — the headline.
- **Regressions** — cases that were green and went red. These block ship.
- **New passes** — cases that were red and went green. These justify ship.
- **Flappy cases** — inconsistent across reruns. Investigate; may be genuine model nondeterminism or a bad case.

A change that raises the mean but adds regressions is usually a loss — the new failures are cases you already knew worked.

## Red flags

- **Grader is the same model that produced the output, with the same prompt.** Self-grading is lenient. Use a different persona at minimum; ideally a different model tier.
- **Eval passes 100% on day one.** The cases are too easy, or the grader is a rubber stamp. Add adversarial cases.
- **Eval takes >30 minutes.** Fan out. A serial 100-case eval is a serial 100-case bottleneck.
- **Grader sees your prompt under test.** It will grade what you wanted, not what happened. Feed it only spec + input + output.
- **Baseline lost.** Without baseline, "improvement" is vibes. Commit `verdicts.jsonl` to git.

## When NOT to do this

- One-off script — build a checklist, not a harness.
- Prompt that changes daily and won't stabilize — evals need a fixed target.
- Task where "correct" isn't checkable (open-ended creative writing) — use human eval or a rubric-based grader, not pass/fail.

The verifier is already yours. The harness is 100 lines of glue around it.
