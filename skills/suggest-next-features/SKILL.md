---
name: suggest-next-features
description: Read git log since initial scaffold + last 3 progress notes, draft feature additions to a SEPARATE suggestions file so feature_list.json stays immutable
when_to_use: feature_list.json has zero passes:false entries left OR the last 3 sessions added no new work and the spec has quietly expanded (user asked for something the list does not cover)
---

# suggest-next-features

The ledger runs dry. Either every `feature_list.json` entry has `passes: true`, or the last few sessions have been shuffling half-features and adding no new work because the spec grew and the list did not.

This skill drafts candidate additions — but to a **separate** file, `feature_list.suggestions.json`. `feature_list.json` is immutable except for the single `passes: false → true` flip that [[feature-list-json]] permits. Silently appending entries would break that contract and let a runaway session invent its own scope.

The suggestions file is a proposal. A human hand-merges chosen entries into `feature_list.json`; the rest are ignored or deleted. No agent, ever, edits `feature_list.json` directly from this skill.

## Trigger

Apply when **either** condition holds:

- `jq '[.[] | select(.passes==false)] | length' feature_list.json` returns `0`.
- The last 3 progress entries in `claude-progress.txt` show no new `passes: true` flips AND the user has referenced behavior not present in `feature_list.json`.

Do not apply just because the list looks short. 30 unfinished entries is not a trigger; 0 is.

## Procedure

1. `git log --pretty=format:'%h %s' "$(git log --grep='chore: initial scaffold' --format=%H | tail -1)"..HEAD` — every commit since the scaffold. This is what actually shipped, not what was claimed.
2. Read the last 3 "What's done" / "Notes for the next session" entries from `claude-progress.txt`. This is where recent scope creep leaks.
3. Read `feature_list.json` in full. You need to know what is already enumerated so you do not propose duplicates.
4. Compare (1)+(2) against (3). Look for:
   - Behavior the user asked for in recent sessions that has no matching entry.
   - Natural next steps implied by shipped features (a feature ships a POST endpoint but no list view for its results).
   - Categories the initial list under-covered (error states, empty states, mobile layout, keyboard shortcuts, offline behavior).
5. Draft 5–10 candidate entries in the same shape as `feature_list.json`. Every one starts `passes: false`. Order them roughly by priority.
6. Write the array to `feature_list.suggestions.json` at the project root. Overwrite any prior draft — this file is regenerable, not append-only.
7. Print a one-line summary per suggestion so the operator can scan without opening the file.
8. Stop. Do not touch `feature_list.json`. Do not commit `feature_list.suggestions.json` (it is a proposal, not project state).

## Output shape

`feature_list.suggestions.json` — same schema as `feature_list.json`:

```json
[
  {
    "category": "ux",
    "description": "Empty conversation list shows an onboarding CTA",
    "steps": [
      "Load app as a user with zero conversations",
      "Verify the sidebar shows a 'Start your first chat' CTA",
      "Click the CTA and land in a fresh conversation"
    ],
    "passes": false,
    "rationale": "Sessions 41/43 both hit the empty-list path and rendered a blank sidebar; no entry covers it."
  }
]
```

The `rationale` field is unique to the suggestions file — it justifies the proposal so the human merger can decide fast. Strip `rationale` before merging into `feature_list.json`.

## Anti-patterns

- **Never edit `feature_list.json` directly from this skill.** Not to append, not to reorder, not to add a comment. The immutability rule from [[feature-list-json]] wins.
- **Do not delete `feature_list.suggestions.json` on the next run.** Overwrite it — the operator may have partly consumed it, and a rewrite is clearer than a diff-merge.
- **Do not propose more than 10 at a time.** Long lists get skimmed, not read. If more are warranted, ship the top 10 and note the rest in `claude-progress.txt`.
- **Do not commit the suggestions file.** It is a proposal for the operator, not a source-of-truth artifact. Add `feature_list.suggestions.json` to `.gitignore` if the operator has not already.

## Related

- [[feature-list-json]] — the immutability contract this skill respects.
- [[shift-notes]] — where recent-scope-drift signals live.
- [[progress-reading-protocol]] — the fresh-session read this skill mirrors in reverse (reads history, writes forward proposals).
