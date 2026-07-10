---
name: evaluator-calibration
description: Calibrate a reviewer persona with few-shot rubric examples so skepticism stays consistent and doesn't drift lenient over long runs.
when_to_use: standing up an evaluator/critic agent for a multi-agent harness, noticing evaluator scores drift upward across many iterations, grading skill/PR/diff output with an LLM and wanting reproducible verdicts
---

# Evaluator Calibration

An evaluator agent that reads the generator's reasoning drifts lenient. The generator explains why the code is good; the evaluator, priming on that prose, starts nodding along. By sprint 8 the "skeptical critic" is a rubber stamp. Prithvi flagged this in the March 2026 planner/generator/evaluator writeup — evaluator leniency is the failure mode of the three-agent harness.

The fix is not "tell the evaluator to be stricter." That works for one iteration. The fix is **anchoring the rubric with concrete pass/fail examples the evaluator re-reads every invocation**, and **re-prompting from scratch on a fixed cadence** so drift can't accumulate.

## When to apply

- You're building a critic/evaluator/judge agent in a multi-agent loop.
- You're using an LLM as a grader for skills, PRs, diffs, or agent output.
- You've noticed pass rates creeping up while output quality hasn't changed — or worse, dropped.
- You want two runs of the same evaluator on the same artifact to return the same verdict.

## Procedure

1. **Write the rubric as a scored checklist, not prose.** Each criterion gets a name, a one-line definition, and a binary or 1-3 score. Prose rubrics ("evaluate whether the code is well-designed") drift; checklists don't.

2. **Anchor every criterion with 2 concrete examples — one pass, one fail.** Real examples from prior runs, not invented ones. The evaluator reads these every invocation. This is the calibration; without it you're just prompting hope.

3. **Forbid reading the generator's reasoning before scoring.** The evaluator sees the artifact (code, diff, output) and the rubric. It does not see the generator's "here's why this is good" prose. Score first, then optionally read the reasoning to write the critique.

4. **Require the evaluator to quote the artifact in every verdict.** "Fails criterion 3 because <quoted line>" — not "fails criterion 3." Quoting forces grounding and makes the verdict auditable.

5. **Re-prompt from scratch every N iterations.** Empirically N=5 works. Kill the evaluator's context, reload the system prompt + rubric + examples fresh. Do not compact; compaction preserves the drift.

6. **Log verdict distributions.** Track pass rate per criterion per sprint. A criterion that goes from 40% pass to 90% pass without a spec change is drift, not improvement.

7. **Spot-check with a held-out fail.** Every ~10 sprints, feed the evaluator an artifact from your example set that you know fails. If it passes, the calibration has decayed — regenerate the example set from recent real runs.

## Anti-patterns

- **"Be skeptical" in the system prompt with no examples.** Words don't calibrate. Examples calibrate.
- **Letting the evaluator read the planner's plan.** Same drift mechanism as reading the generator's reasoning — priming on intent softens the critique.
- **One shared context across many gradings.** Each grading should start from a clean rubric read. Batch-grading in one context is where leniency compounds fastest.
- **Invented examples.** Fake pass/fail examples don't anchor to the artifact distribution the evaluator actually sees. Pull from real runs.
- **Scoring on a 1-10 scale.** The evaluator will cluster at 7. Use binary or 1-3.

## Related

- [[adversarial-verify]] — the single-shot form; evaluator-calibration is the standing-agent form.
- [[shift-notes]] — evaluator verdicts belong in the ledger so drift is visible session-over-session.
- [[broken-window-check]] — a mechanical version of "don't trust the last verdict"; pairs well when the evaluator is the thing being distrusted.

## When NOT to apply

Single-shot grading with a fresh context every call — there's no drift to prevent, and the examples are overhead. Also skip for tasks under ~1 hour where the evaluator only runs 2-3 times.