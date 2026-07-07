# loopkit vs other skill packs

Written in July 2026 after mining the top three loadout repos. This document is honest — where another pack beats loopkit, it says so. Use it to choose the tool for your loop, not to score points.

## TL;DR

- **loopkit** — you want mini-skills + a working harness, no methodology commitment, drop-in.
- **obra/superpowers** — you want Prime Radiant's spec-first + TDD philosophy end-to-end, and you code in Claude Code.
- **mattpocock/skills** — you want Matt's specific engineering opinions (grill-with-docs, triage) and are OK adopting his flow.
- **addyosmani/agent-skills** — you want a 6-phase lifecycle (`/spec` → `/plan` → `/build` → `/test` → `/review` → `/ship`) with slash-command muscle memory.

They all share the same base: YAML-frontmatter skills that load on trigger. The differences are shape and floor.

## Feature matrix

| Feature | loopkit | superpowers | mattpocock | osmani |
|---|:---:|:---:|:---:|:---:|
| Skills load on trigger (SKILL.md YAML) | yes | yes | yes | yes |
| Ships a harness (`.claude/settings.json`, hooks, verifier subagent) | **yes** | partial | no | no |
| Loop runner (`run.sh` Plan→Act→Verify) | **yes** | no | no | no |
| Adversarial verifier subagent | **yes** | via TDD | via code-review | via `/review` |
| Methodology imposed | **none** | Prime Radiant | GSD-adjacent | 6-phase lifecycle |
| Slash-command shortcuts | no | some | many | 8 lifecycle cmds |
| Reference checklists (on-demand) | yes | no | some | yes (7) |
| Compatible with non-Claude agents | yes | Claude-first | multi | multi |
| Comparison doc against peers | yes (this) | no | no | yes |
| Skill count | 33 | ~40 | ~19 | ~24 |
| Reads as "personal loadout" | yes | no | yes | yes |

## Where each pack wins

### loopkit
- Only pack that bundles the *harness* (settings.json + verifier subagent + loop runner) as part of the install. Everyone else assumes you already have a working `.claude/`.
- No methodology tax. You keep your workflow; skills specialize the agent, they don't own it.
- Adversarial-verify skill is unique — an explicit list of the 11 shortcuts agents take to fake "done".

### obra/superpowers
- Deepest TDD enforcement in the ecosystem. Prime Radiant methodology is opinionated and coherent.
- The 10-agent integration story is real: plugs into far more than Claude Code out of the box.

### mattpocock/skills
- `grill-with-docs` and `grilling` are unique — a genuine interviewing-your-domain interaction pattern nobody else has.
- Cleanest User-invoked vs Model-invoked separation. Sharpest skill hierarchy.
- Backed by newsletter + audience. If Matt updates it, it stays updated.

### addyosmani/agent-skills
- Best lifecycle diagram. The `/spec` → `/plan` → `/build` → `/test` → `/review` → `/ship` mental model is memorable.
- 7 reference checklists (Definition of Done, Security, Perf, A11y, Observability, Testing Patterns, Orchestration) — the deepest supplementary layer.
- Anti-rationalization tables inside every skill. Concrete rebuttals to "I'll add tests later."

## Where each pack loses

### loopkit
- No slash-command shortcuts. If you want `/build auto` UX, look at Osmani.
- Solo maintainer. If continuity matters more than freshness, Anthropic's canonical skills are the safer bet.

### obra/superpowers
- Prime Radiant is a commitment. If you don't want the whole methodology, the skills are less useful in isolation.
- Assumes you're using the full stack — the pieces are less drop-in than they look.

### mattpocock/skills
- Deeply Matt-flavored. His triage state machine, his PRD synthesis. Great if you buy his taste, friction if you don't.
- Newsletter integration is genuine but adds a signup surface some teams won't want.

### addyosmani/agent-skills
- Heaviest floor. The 6-phase lifecycle is powerful but adds ceremony to small changes.
- Slash-commands are agent-specific — reduces cross-agent portability.

## Cross-pack composability

Skills are markdown files with YAML headers. Nothing stops you from mixing:

```bash
npx skills add Archive228/loopkit          # base + harness
npx skills add mattpocock/skills/grilling  # Matt's interview loop
npx skills add addyosmani/agent-skills/checklists  # reference layer
```

The trigger system means loading extras is nearly free — they only fire when their frontmatter matches. Mixing is the expected mode.
