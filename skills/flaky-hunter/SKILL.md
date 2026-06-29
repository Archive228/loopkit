---
name: flaky-hunter
description: Diagnose and fix tests that pass sometimes and fail other times. Use when CI is red intermittently.
when_to_use: intermittent CI failure, "passes locally fails in CI", a flaky test
---
# Flaky Test Hunter
Run the suspect test 20x in a loop first — confirm it's actually flaky, not just broken.
Common causes, in order of likelihood:
1. **Time/order** — depends on test execution order or shared mutable state. Isolate it; run alone.
2. **Async race** — asserting before a promise/refetch resolves. Await the actual condition, not a sleep.
3. **Real network/clock/random** — mock them. Freeze time, seed RNG, stub the call.
4. **Resource leak** — a prior test left a connection/file/port open.
Fix the cause, not the symptom. `retry(3)` on a flaky test hides a real race that will bite in production. Quarantine only as a last resort, with a ticket.
