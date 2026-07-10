---
name: feature-list-json
description: Enumerate every end-to-end feature as strict JSON entries with passes:false, editable-passes-only discipline, and priority order. The ledger fresh-context sessions read to know what's done, what's next, and what they're forbidden to touch.
when_to_use: initializer agent building the master feature list at scaffold time, coding agent flipping a single passes field after E2E verification, auditing that description/steps/tests fields were not silently edited
---

# feature_list.json

The ledger of every feature the product will eventually have. Fresh-context sessions read it to pick work; they flip exactly one boolean when done. JSON, not Markdown — the syntactic strictness is load-bearing. Prose gets edited freely; data gets edited carefully.

Format per entry:

```json
{
  "category": "functional",
  "description": "New chat button creates a fresh conversation",
  "steps": [
    "Navigate to main interface",
    "Click the 'New Chat' button",
    "Verify a new conversation is created",
    "Check that chat area shows welcome state",
    "Verify conversation appears in sidebar"
  ],
  "passes": false
}
```

Categories: `functional`, `ux`, `data`, `infra`. Order the array in implementation order — the top is the next thing to build.

## When to apply

- **Initializer agent** at scaffold time: produce the full list, every entry `passes: false`. Aim for breadth — 200 well-scoped entries beats 30 vague ones.
- **Coding agent** at end of session: after end-to-end verification, flip exactly one `passes` from `false` to `true`.
- **Any session** at start: `jq '[.[] | select(.passes==false)] | length'` to see remaining work; pick the topmost unblocked entry.

## Procedure — initializer

1. Enumerate every user-observable behavior the spec implies. Login, list rendering, empty states, error states, keyboard shortcuts, mobile layout — all of it.
2. Write each as one entry. `description` is one sentence, `steps` is a user's actual action sequence (not implementation notes).
3. Order the array so an agent walking top-to-bottom builds prerequisites before dependents.
4. Every `passes` starts `false`. No exceptions, not even for the smoke test.
5. Validate: `jq '. | length'` returns your count; `jq '[.[] | select(.passes==true)] | length'` returns 0.

## Procedure — coding agent

1. Read the file. Do not edit yet.
2. Pick the topmost entry with `passes: false` and satisfied prerequisites. If the top is blocked, drop to the deepest unblocked entry.
3. Implement. Test. Verify end-to-end via the runtime path (browser automation, HTTP, CLI) — not unit tests alone. See [[broken-window-check]] for what E2E means.
4. Only after E2E green: flip that single entry's `passes` to `true`.
5. Diff the file. The diff must be exactly one `false` → `true`. Nothing else.

## Anti-patterns

- **Editing `description`, `steps`, or `category`** — it is unacceptable to remove or edit these fields because it lets missing functionality slip past future sessions. The ledger is append-only in every field except `passes`.
- **Flipping `passes: true` on unit-test evidence** — unit tests pass while routes are misrouted, CORS is broken, or the button is unwired. Only end-to-end evidence flips the bit. See [[verification-before-completion]].
- **Flipping multiple entries in one session** — the single-feature-per-session rule (see [[one-feature-per-session]]) exists because packed sessions ship everything half-done. One flip per session.
- **Adding new entries mid-project without spec change** — if scope grew, note it in [[shift-notes]] and flag for a re-scope, don't quietly extend the ledger.
- **Deleting "obsolete" entries** — if a feature is no longer needed, leave it and mark it `passes: true` with a note, or negotiate removal explicitly. Silent deletion breaks priority counting.
- **Markdown or YAML instead of JSON** — measured in shift-work agent runs, JSON cuts spurious field edits ~7x vs. Markdown and premature-pass marking ~2x. The strictness does the work.

## Audit check

At session end, before committing:

```bash
git diff feature_list.json | grep -E '^[-+]' | grep -v 'passes'
```

If this prints anything other than the file header, you edited a forbidden field. Revert those hunks. Only `"passes": false` ↔ `"passes": true` lines are allowed to change.

## When NOT to apply

- Projects under ~20 features — the overhead of writing the list exceeds the benefit; a flat TODO in [[shift-notes]] is enough.
- Solo one-shot sessions with no handoff — the ledger's whole purpose is cross-session discipline.

## Related

- [[shift-notes]] — the prose companion; feature_list.json holds state, shift-notes holds context.
- [[broken-window-check]] — what "end-to-end verified" means before you flip a bit.
- [[one-feature-per-session]] — the rule that limits you to one flip per session.
- [[verification-before-completion]] — the general form of "no bit-flip without runtime evidence".