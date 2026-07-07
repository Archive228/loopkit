# Definition of Done

A shipped feature clears every line on this list. If a line can't be checked, the feature isn't done — it's *claiming* done.

## Behavior
- [ ] End-to-end path exercised by hand (or by an automated browser test), not just unit-tested.
- [ ] Happy path + at least two failure paths (bad input, downstream error) produce a sensible response.
- [ ] Loading, empty, error, and success states all render — see `loading-empty-error-states` skill.

## Tests
- [ ] At least one test that would fail if the feature were reverted.
- [ ] No existing test was weakened, skipped, or deleted to make CI green.
- [ ] Coverage of the changed lines is meaningful — see `coverage-gaps` skill.

## Interfaces
- [ ] Public API shape documented (or contract test added — see `contract-test` skill).
- [ ] Breaking changes have a migration note in the changelog.
- [ ] Error messages are actionable, not "something went wrong."

## Data
- [ ] Migrations are reversible and safe to run on a hot database.
- [ ] Indexes exist for any new query pattern — see `sql-review` skill.
- [ ] Secrets aren't in code or logs — see `secret-scan` skill.

## Delivery
- [ ] Commits are atomic and readable — see `clean-commits` skill.
- [ ] PR description answers *why*, not just *what* — see `pr-from-diff` skill.
- [ ] Rollback plan exists (revert commit, feature flag off, etc.).

## The verifier gate
Before marking done, run the adversarial-verify skill against the change. If the verifier finds even one item on this list unproven, the feature is *not* done.
