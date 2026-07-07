# Rationalizations

Excuses agents (and humans) reach for when a discipline is inconvenient. Each has a rebuttal. Skills reference this file when the temptation is likely.

## "I'll add tests later"
**Rebuttal.** "Later" is a session that hasn't been paid for. If the test is important enough to write eventually, it's important enough to write before the code is called done — see `write-failing-test-first`.

## "This bug is too small for a systematic debug"
**Rebuttal.** Small bugs get one-shot patches that create new small bugs. Systematic debugging is the shortest path even for small bugs; the ceremony is minutes, the wrong patch is hours — see `systematic-debugging`.

## "The dependency upgrade fixes a warning, I should take it"
**Rebuttal.** Every upgrade is a change of behavior masquerading as hygiene. Take upgrades in their own commit, on their own session, when the task is "upgrade dependencies" — not as a side effect of a feature.

## "I'll refactor and add the feature in the same commit"
**Rebuttal.** Reviewers can't separate the two; regressions get blamed on the feature and the refactor gets ignored. Split the commits even if it costs you two extra minutes — see `clean-commits`.

## "The unit tests pass, so the feature works"
**Rebuttal.** Unit tests prove functions do what their tests say. They don't prove the route is wired, the CORS header is set, or the frontend actually calls the handler. End-to-end verify before flipping done — see `adversarial-verify` and Red Flag #5.

## "The plan is obvious, I'll skip spec-first"
**Rebuttal.** If the plan is obvious, spec-first costs one paragraph and catches the one assumption you were about to make. If the plan is *not* obvious, spec-first is what makes it obvious — see `spec-first`.

## "I have context now, let me do two features while I'm hot"
**Rebuttal.** Two half-done features is worse than one done feature. Sessions that pack extras ship them all half-done — see the incremental-progress rule in the harness doc.

## "I'll delete this test, it's flaky"
**Rebuttal.** Flaky tests are load-bearing tests behaving loudly. Deleting one loses the signal it was trying to send. Reproduce, isolate, quarantine — see `flaky-hunter`. Deleting is a last resort, not a first move.

## "The old code was doing X for a reason, but I don't see it"
**Rebuttal.** Chesterton's Fence. If you can't articulate why a piece of code exists, you can't safely delete it. Trace the reason first — see `kill-dead-code`.

## "I'll write the changelog before I ship"
**Rebuttal.** Changelogs written after the fact miss the *why*. Write the entry as you commit — see `changelog-from-diff`.
