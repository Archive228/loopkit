---
name: decision-record
description: Capture an architectural decision so the next session (or engineer) knows WHY. Use after any non-obvious technical choice.
when_to_use: picked a library/pattern/schema, a tradeoff was made, a hard-to-reverse choice
---
# Decision Record (ADR)
Write a short file `docs/decisions/NNN-<slug>.md`:
- **Context** — what forced a decision. The constraints.
- **Options** — the 2-3 real candidates, one line each.
- **Decision** — what you picked, dated.
- **Why** — the tradeoff. What you gave up. "We picked Postgres over Mongo because we need real joins; we accept heavier ops."
- **Consequences** — what this now makes easy and hard.
Hard-to-reverse choices (schema, auth, data store) MUST get one. Future-you will ask "why on earth did we do this" — answer it now.
