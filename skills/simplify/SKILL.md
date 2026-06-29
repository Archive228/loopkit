---
name: simplify
description: Reduce a change to the minimum that solves the problem. Use when code is over-engineered or a diff is bloated.
when_to_use: over-abstraction, a 200-line diff for a small ask, premature generality
---
# Simplify
Over-engineering is the default failure mode. Cut it:
- **Premature abstraction** — a class/strategy/factory for one caller. Inline it. Abstract on the THIRD use, not the first.
- **Speculative config** — a parameter/flag/env var for something that never changes. Hardcode it until there's a real reason.
- **Dead flexibility** — an interface with one implementation, a generic with one type. Delete the indirection.
- **Defensive noise** — null checks on values that can't be null, try/except for errors that can't happen. Handle only real failure modes.
Test: can you justify every changed line by a direct connection to what was asked? If a line is there "while I was in there", revert it.
