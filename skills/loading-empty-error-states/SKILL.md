---
name: loading-empty-error-states
description: Design the three states every data UI forgets. Use for any component that fetches or lists data.
when_to_use: a list, a fetch, a dashboard, anything async in the UI
---
# Loading / Empty / Error States
AI-built UIs handle the happy path and crash on the other three. Design all four:
- **Loading** — skeletons that match the final layout (not a centered spinner that shifts everything).
- **Empty** — a real first-run state: what it is, and the one action to fill it. Not a blank box.
- **Error** — what failed, in human terms, plus a retry. Never a raw stack trace or silent nothing.
- **Partial** — slow/streaming data, optimistic updates that can roll back.
For each fetch in the diff, confirm all four exist. The empty and error states are where products feel broken.
