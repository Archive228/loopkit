---
name: my-new-skill
description: One sentence that describes WHEN to invoke this skill. Write it as a trigger phrase, not a summary — include the words a user would say ("fix bug", "add feature", "review diff"). The agent routes on this field.
---

# My New Skill

<!--
Anthropic-shaped SKILL.md template. Copy this folder to skills/<your-name>/
and edit. Keep the body under ~150 lines — long bodies are a context tax on
every turn where this skill is loaded.

Recommended structure:
  1. One-paragraph statement of the failure mode this skill exists to prevent.
  2. A short checklist or numbered procedure the agent should follow.
  3. Red flags — the shortcuts an agent takes when it wants to skip this.
  4. Evidence — a required before/after pair proving the skill actually
     changes behaviour. Ships in the sibling evidence/ folder.
  5. (optional) `references/` sibling files with deeper material the skill
     lazy-loads only when needed.

Do not include:
  - Marketing copy.
  - Duplicates of other skills (link, do not copy).
  - Project-specific rules — those belong in .claude/rules/.

Frontmatter contract (validated by scripts/validate-skills + CI):
  - `name` — kebab-case, unique across the repo, matches the directory name.
  - `description` — one non-empty line, phrased as a trigger.
  - Anything else is optional and not currently enforced.
-->

Without this skill, the agent tends to <failure mode>. This skill enforces <the alternative>.

## Steps

1. <step>
2. <step>
3. <step>

## Red flags — STOP

| Thought | Reality |
|---|---|
| "I've done this before, I don't need the checklist" | Skills evolve; re-read the current SKILL.md. |
| "This case is simple" | Simple cases become complex mid-task. |
| "The user didn't ask for this rigor" | The user asked for a working result. Rigor is how you get one. |

## Evidence

Every skill ships with a real before/after pair proving it changes agent
behaviour on a concrete task. Without this, the skill is a claim, not a
tool.

- `evidence/before.md` — a verbatim snippet of what the agent does on a
  representative task WITHOUT this skill loaded. Include the prompt, the
  agent's response, and what went wrong (or what got skipped).
- `evidence/after.md` — the same prompt with this skill loaded. Show the
  changed behaviour and why it is better.

If you cannot produce a before/after pair, the skill is not ready to ship.
Land it as a draft in a branch, gather the evidence, then merge.

## References

- `references/<topic>.md` (only if needed; keep the body lightweight)
