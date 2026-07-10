---
name: harness-stripping
description: Systematically remove one harness component at a time and measure impact, killing scaffolding that no longer earns its complexity.
when_to_use: auditing a harness after a model upgrade to see what workarounds are now obsolete, a component encodes an assumption about model weakness worth re-testing, or the harness has grown organically and you suspect dead/redundant machinery
---

# Harness Stripping

Every harness component was added to compensate for a specific model failure. Models improve. Components don't retire themselves. The scaffolding that saved you on Sonnet 4.5 may be dead weight — or actively harmful — on Opus 4.6. Strip it deliberately, one piece at a time, and let evals tell you what still earns its keep.

Inspired by Prithvi's March 2026 harness post on evaluator-generator separation and the general "re-test your assumptions each model bump" discipline.

## When to apply

- A model upgrade just landed and your harness was tuned for the previous generation.
- A component's justification is "we added this because the model used to do X" — and you haven't checked whether it still does X.
- The harness has accreted over months and nobody remembers what half the machinery is for.
- Cost or latency is climbing and you suspect redundant belt-and-suspenders layers.

## Procedure

1. **Inventory the components.** List every distinct piece of scaffolding: prompt sections, tool wrappers, post-hoc validators, retry loops, evaluator personas, structured-output enforcers, sandbox rules. One row per component. Note the failure mode each was added to prevent.

2. **Rank by suspicion.** Put the components most likely to be obsolete at the top: anything added before the last two model bumps, anything targeting a failure mode you haven't seen recently, anything whose original justification is now folklore.

3. **Pick a baseline eval.** You need a repeatable metric before you touch anything. Reuse an existing eval set if you have one; otherwise pick 20–60 tasks representative of production work. Record baseline score, cost, and wall-clock.

4. **Strip one component.** Only one. Comment it out or gate it behind a flag — don't delete yet. Re-run the eval.

5. **Compare against baseline.**
   - Score within noise, cost/latency down → the component is dead weight. Delete.
   - Score drops measurably → the component still earns its complexity. Restore and note *what failure mode* returned.
   - Score *improves* → the component was actively harmful. Delete and investigate why (often: over-constraining a now-capable model).

6. **Commit the delta.** Land the strip (or the restore-with-notes) as its own commit. Do not batch multiple strips into one change — you lose the ability to attribute the score movement.

7. **Repeat for the next component.** Re-establish baseline from the *new* state each round, not the original. Compounding strips have compounding effects.

## Anti-patterns

- **Stripping two components at once** — you can't tell which one mattered. Halve the signal, double the confusion.
- **Skipping the eval "because it's obviously safe to remove"** — the harness accreted for reasons. Some are still real. Measure.
- **Deleting instead of gating on the first pass** — you will want to A/B mid-review. Flag first, delete after the eval confirms.
- **Trusting anecdotes over the eval** — "it feels better without it" is how load-bearing components get removed. If the eval doesn't show it, it isn't there.
- **Stripping components that guard safety, sandboxing, or cost caps** — those aren't compensating for model weakness. Leave them.
- **Doing this on prod traffic** — run against an eval set, not real users. The failure modes you're re-probing are exactly the ones that hurt users.

## What to strip first

Highest yield in practice:

- Structured-output enforcers layered on top of models that now emit valid JSON natively.
- Multi-step "plan then execute" wrappers on tasks the model now one-shots.
- Retry loops around tool calls that no longer flake.
- Evaluator personas whose critiques the generator now anticipates on its own.
- Verbose "remember to do X" prompt sections where X is now default behavior.

## When NOT to apply

Don't strip mid-project on a live long-running run — you'll perturb sessions in flight. Do it between projects, or on a forked branch. Also skip if you don't have an eval you trust; stripping without measurement is guessing.

## Related

- [[shift-notes]] — record which components were stripped and when, so the next audit doesn't re-strip and re-restore the same piece.
- [[adversarial-verify]] — the evaluator-generator pattern that may itself be a strip candidate on newer models.
- [[broken-window-check]] — if you strip a component and the eval regresses in a specific way, that's your new broken window to hunt.