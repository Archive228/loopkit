# Red Flags

15 patterns the adversarial-verify skill looks for. Any single hit is enough to reject a "done" claim.

## The eleven shortcuts

1. **Assert-true test** — a test file exists but its assertions are trivially true (`assert True`, `expect(1).toBe(1)`). Nothing is actually checked.
2. **Skipped test** — `xit`, `it.skip`, `@pytest.mark.skip` added around the failing case. CI is green because the test doesn't run.
3. **Try/except swallow** — an exception is caught and silently ignored. The failure is now invisible.
4. **Mock the thing you were testing** — the code under test is mocked away and the mock is asserted against.
5. **Route wired but unreachable** — the handler exists but the router doesn't include it, or a middleware short-circuits it. Unit tests pass; the endpoint 404s in production.
6. **Config not persisted** — the feature works in the running process but the config change isn't in the committed config file.
7. **Renamed the bug** — a symptom was suppressed (caught error, hidden UI, filter added) but the root cause remains.
8. **"Fixed" by disabling the check** — a linter rule, type check, or test suite was disabled instead of fixed.
9. **Path-dependent success** — the feature works only in the exact state the developer left the repo in; a fresh clone or restart breaks it.
10. **Half-committed** — new files staged but not tracked, or old files modified but not staged. Reviewer sees an incomplete diff.
11. **Documentation lie** — README claims the feature works while the code path is stubbed.

## The four environmental tells

12. **`init.sh` no longer works** — a step of the setup broke and the fix lives only in the developer's shell history.
13. **Dev-server-only success** — the feature works in dev because of a dev-only shim, and prod behavior isn't validated.
14. **Compiler-happy != behavior-correct** — types check, tests pass, feature doesn't do the thing.
15. **"It compiled, therefore it works"** — the closing move of a session where the agent ran out of context and rationalized.

## Verifier protocol

For each red flag: state the observation, cite the line or file, and either (a) fix it before flipping the task to done, or (b) revert the offending commit. Do not negotiate with red flags. See `adversarial-verify` skill.
