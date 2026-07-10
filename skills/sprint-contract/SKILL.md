---
name: sprint-contract
description: Negotiate a pre-code contract between generator and evaluator personas that defines what "done" means before any code is written. Turns fuzzy specs into a testable target the evaluator can hold the generator to.
when_to_use: starting a coherent chunk of implementation work with an evaluator/reviewer in the loop, bridging a fuzzy spec to a testable target when planner output is ambiguous, rehydrating a session after a context reset and needing a fresh acceptance target
---

# Sprint Contract

The evaluator's leverage collapses when "done" is defined *after* the code exists. The generator ships something, the evaluator finds it plausible, the fuzzy spec silently reshapes to match what got built. Premature victory, dressed up.

Fix the timing: write the contract *before* the generator writes a line of code. The evaluator's job for the sprint is then mechanical — hold the artifact against the contract, no re-negotiation mid-flight.

Inspired by the planner/generator/evaluator split in Prithvi's March 2026 post on multi-agent harnesses.

## When to apply

- You're about to start a chunk of work (one feature, one refactor, one bug fix) with an evaluator or reviewer persona in the loop.
- The planner output or upstream spec is ambiguous — you can imagine two reasonable implementations that both "satisfy" it.
- A session just rehydrated from `shift-notes` / a progress file and needs a concrete acceptance target before it picks up the keyboard.

## Procedure

1. **Name the one deliverable.** One feature, one sentence, user-observable. If you can't say it in a sentence, the sprint is too big — split it, contract the first slice.
2. **Write the acceptance predicates.** 3-7 bullets, each one a check that either passes or fails. No "clean code", no "good UX" — write predicates a script or a browser click can decide.
3. **Name the runtime path.** How is this exercised end-to-end? Which URL, which CLI invocation, which button click? The evaluator will drive this exact path — no substitutes.
4. **List the out-of-scope items.** Two or three things the generator will be tempted to also fix. Written down = evaluator will reject them as scope creep, generator has an anchor when tempted.
5. **Sign it in the shift notes.** Paste the contract into `claude-progress.txt` (or equivalent) under a `## Sprint contract` header, with the sprint start timestamp. Both personas reference this exact text for the rest of the sprint.
6. **Then, and only then, write code.**

## Contract shape

```
## Sprint contract — <ISO timestamp>

Deliverable: <one sentence, user-observable>

Acceptance predicates:
- [ ] <predicate 1 — script-decidable>
- [ ] <predicate 2>
- [ ] <predicate 3>

Runtime path: <exact URL / CLI / click sequence the evaluator will drive>

Out of scope this sprint:
- <tempting adjacent fix>
- <tempting refactor>
```

## Anti-patterns

- **Predicates that are prose, not checks.** "Handles errors gracefully" is not a predicate. "Returns 400 with `{error: "missing_field"}` when `name` is absent" is.
- **Renegotiating mid-sprint.** If the generator hits a wall, it does not edit the contract to route around it. It surfaces the wall, the *planner* revises scope, a new contract gets signed. Evaluator leniency comes from mid-flight edits — block them structurally.
- **Contract written by the generator alone.** The generator will write predicates its planned code happens to satisfy. Have the evaluator draft or at least sign off before code starts.
- **No runtime path.** Without it, the evaluator falls back to reading unit tests — see [[broken-window-check]] for how that fails.
- **Skipping the out-of-scope list.** This is the cheapest anti-drift device you have. Skip it and you'll ship a "small refactor" that broke two other features.

## Rehydration case

Fresh session, no memory of the previous one. Read `shift-notes`, find the last signed contract with unchecked predicates. That is your target — no re-planning, no reinterpretation. Drive the runtime path, tick the predicates, ship. If the contract looks wrong on inspection, do not edit it; revert to the planner, get a new one signed.

## Cost

Two to five minutes of prose before code. In return: the evaluator has something to be strict about, the generator has an anchor against scope drift, and the next session inherits a testable target instead of a vibe.

## Related

- [[shift-notes]] — where the contract lives across sessions.
- [[broken-window-check]] — what the evaluator runs *against* the contract at session start.
- [[adversarial-verify]] — the end-of-sprint pass that decides whether every predicate actually holds.

## When NOT to apply

Trivial edits (typo fix, one-line config change, dependency bump) — the contract overhead exceeds the work. Solo runs with no evaluator persona in the loop — write yourself a one-line acceptance note instead and move on.