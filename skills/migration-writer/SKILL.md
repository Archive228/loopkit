---
name: migration-writer
description: Write safe, reversible database migrations for this repo's conventions. Use for any schema change.
when_to_use: add/alter a table, column, index, or constraint
---
# Migration Writer
1. Read the current schema first. Match the repo's migration tool and naming (`NNN_<verb>_<noun>`).
2. Write BOTH up and down. A migration you can't reverse is a migration you can't deploy safely.
3. **Live-safe**: on a hot table, adding a NOT NULL column with no default, or an index without CONCURRENTLY, takes a blocking lock. Split into steps: add nullable → backfill → add constraint.
4. Backfill large tables in batches, not one statement.
5. Never edit an already-merged migration — add a new one.
Test with a dry-run before committing. Output the migration + the exact deploy order.
