---
name: reduce-nesting
description: Flatten deeply nested conditionals into readable, early-return code. Use on any function with 3+ levels of indentation.
when_to_use: arrow-shaped code, 3+ nested ifs, a function that's hard to follow
---
# Reduce Nesting
Deep nesting hides bugs in the branches you didn't read.
- **Guard clauses** — handle the invalid/edge cases first and return early. The happy path drops to the left margin.
- **Invert conditions** — `if (!valid) return;` instead of wrapping the whole body in `if (valid) {...}`.
- **Extract** — a nested block doing one thing becomes a named function.
- **Replace flag-then-branch** — return the result directly instead of setting a variable to return later.
Target: no function deeper than 2-3 levels. If you still need more, the function is doing too much — split it.
