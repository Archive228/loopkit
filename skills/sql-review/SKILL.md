---
name: sql-review
description: Review SQL and ORM queries for correctness, safety, and performance before they ship.
when_to_use: new query, a migration, an N+1 suspicion, a slow endpoint
---
# SQL Review
- **Injection** — parameterized, always. No string interpolation into SQL.
- **N+1** — a query inside a loop? Replace with a join or a batched IN.
- **Missing index** — does the WHERE/JOIN/ORDER BY hit an indexed column? If not, the table scan will surface at scale.
- **Unbounded** — SELECT with no LIMIT on a growing table; a JOIN that fans out rows.
- **Transactions** — multi-write operations wrapped so a partial failure can't corrupt state.
- **Migrations** — reversible (up AND down), and safe on a live table (no blocking lock on a hot table at peak).
Output: each issue with the line and the rewrite. Show the EXPLAIN if performance is the concern.
