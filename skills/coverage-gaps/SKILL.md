---
name: coverage-gaps
description: Find the untested code paths that actually matter, not just the coverage percentage. Use after adding tests.
when_to_use: "improve coverage", after writing tests, pre-merge quality check
---
# Coverage Gaps
Coverage % is a vanity metric. Hunt the gaps that bite:
- **Error paths** — the 500, the timeout, the empty/null input, the malformed payload. Almost always untested.
- **Boundaries** — 0, 1, max, off-by-one, empty collection.
- **Branches** — every `if/else` and `catch` exercised, not just the happy line.
- **Concurrency / order** — anything stateful tested in isolation AND in sequence.
Skip tests that assert a constructor sets a property — worthless. Test behavior, not implementation. Output: the 3-5 highest-risk untested paths, ranked by blast radius, with the test to add.
