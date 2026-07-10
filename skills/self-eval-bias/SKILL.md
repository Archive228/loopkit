---
name: self-eval-bias
description: Detect and interrupt the pattern where an agent confidently praises work it just produced instead of reviewing it critically. Same-context grading is not review — it's rationalization.
when_to_use: about to grade or accept output produced in the same context that generated it, reviewer verdict is high-confidence positive with no cited concrete evidence, deciding whether to spawn a separate reviewer persona vs self-review
---

# Self-Eval Bias

An agent that just produced a plan, a diff, or a report cannot fairly grade it in the same context. The reasoning that justified writing it is still loaded — every doubt was already resolved in favor of shipping. Asked to review, the same context reliably returns "looks good, ship it." This is not review. It is rationalization wearing a review's uniform.

The pattern shows up hardest in planner/generator/evaluator architectures where the evaluator drifts toward leniency over long runs — the prompts it reads fill up with the generator's reasoning, and skepticism erodes. (See Prithvi's March 2026 post on the three-agent harness: https://blog.anthropic.com/three-agent-harness-march-2026.)

## When to apply

- You just wrote code, a plan, or a claim, and the next step is "confirm it's correct".
- A reviewer verdict comes back positive with no cited line numbers, no failing case explored, no counter-example attempted.
- You're about to mark a feature `passes: true`, close an issue, or hand off to the next session.
- The evaluator persona in a multi-agent loop has agreed with the last N generator outputs in a row.

## Procedure

1. **Notice the same-context tell.** If the review verdict lands in under three sentences and contains "looks correct", "this should work", or "no issues found" without a cited artifact — treat the verdict as unwritten.
2. **Force a fresh persona.** Drop the generation context. Open a new subagent, or at minimum re-prompt with only the artifact (diff, plan, output) and the acceptance criteria — no reasoning trail, no self-justification.
3. **Demand concrete evidence, not verdicts.** The reviewer must cite: the file:line it inspected, the input it ran, the observed output, and the criterion it matched against. "LGTM" without these is a null review — discard it.
4. **Adversarially probe.** Ask the reviewer for the strongest case where the artifact fails. If it can't produce one, the review didn't happen — the reviewer just agreed.
5. **Run the artifact.** For code, exercise it end-to-end (see [[broken-window-check]]). For a plan, walk the first two steps concretely. Same-context confidence collapses fast against a runtime.
6. **Rotate the reviewer periodically.** In long multi-agent loops, re-prompt the evaluator from scratch every ~5 sprints — leniency drift compounds silently.

## Anti-patterns

- **Self-review in the same turn.** "Let me double-check my work" followed by immediate approval. The doubt has to cost something to be real.
- **Praise as evidence.** "This is a clean, well-structured implementation" is a vibe, not a finding. Findings cite lines.
- **Positive verdict, empty failure_scenario.** If the reviewer can't describe what a failure would look like, they didn't look for one.
- **Rubber-stamping across a run.** N consecutive "approved" verdicts from the same evaluator without a single rejection is a red flag, not a track record.
- **Fixing the criterion instead of the artifact.** Reviewer notices a gap, then edits the spec to say the gap is out of scope. The gap is in the artifact. Fix that.

## When NOT to apply

- The output is trivial and cheap to redo if wrong (a one-line rename, a config toggle).
- A separate reviewer with a fresh context already ran and cited concrete evidence — the check has been done, don't loop on it.

## Related

- [[broken-window-check]] — the runtime-driven version of "don't trust the last claim".
- [[adversarial-verify]] — the structural form of "find the strongest failure case".
- [[shift-notes]] — where you record what the fresh-persona review actually found.