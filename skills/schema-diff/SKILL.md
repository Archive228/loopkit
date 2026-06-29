---
name: schema-diff
description: Compare two schema states and surface the risky changes. Use before applying migrations or after a model change.
when_to_use: reviewing a migration, "what changed in the schema", pre-deploy check
---
# Schema Diff
Diff old vs new schema. Flag by risk:
- **Destructive** (high): dropped column/table, narrowed type, new NOT NULL on existing rows, dropped index a query relies on.
- **Locking** (high at scale): index without CONCURRENTLY, type change that rewrites the table.
- **Safe**: new nullable column, new table, new index CONCURRENTLY.
For each destructive change: is data lost? is it reversible? is there a backfill? Output a risk-ranked list and a go/no-go with the safe rollout order.
