---
name: context-budget
description: Keep the agent's context lean so accuracy doesn't collapse. Use on long sessions, big files, or when the agent starts hallucinating.
when_to_use: long session, huge file dump, agent forgetting earlier steps, accuracy dropping
---
# Context Budget
More context is not better. Past a threshold, accuracy falls off a cliff (context rot).
- **Don't dump whole files** — read the relevant function/section, not the 2000-line module.
- **Summarize, don't accumulate** — replace a 200K-token transcript with a 4K recap of the load-bearing facts.
- **Drop dead context** — once a sub-task is done, its detail leaves the window. Keep the decision, drop the trace.
- **State on disk, not in context** — progress goes to a file the next turn re-reads, not into an ever-growing prompt.
A bloated standing context (CLAUDE.md) taxes every single turn. Trim weekly. If the agent is confidently wrong, suspect the context before the model.
