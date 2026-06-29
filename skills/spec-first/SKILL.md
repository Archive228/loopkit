---
name: spec-first
description: Write the goal spec on disk before the agent acts, so it can't drift. Use before any multi-step task.
when_to_use: a task with more than 2 steps, a long-running job, "build X", agent drifting
---
# Spec First
Without an external contract, the agent drifts after ~3 iterations — and the failure looks like progress (code written, tests pass, wrong goal solved).
Write `PROMPT.md` BEFORE acting:
- **Goal** — one sentence.
- **Done when** — concrete, checkable conditions. "Test suite green: <cmd>".
- **Never touch** — files/areas off-limits.
- **Stop if** — more than N files outside scope change; a passing test starts failing.
The agent re-reads this file every iteration. State (what's done) goes in a separate `IMPLEMENTATION_PLAN.md` it updates in place. If you can't write "done when" concretely, the task isn't ready — clarify before coding.
