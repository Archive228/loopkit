---
description: "Finn Loop: final polish pass + adversarial verify, then post to configured channel."
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash(git:*), Bash(cat:*), Bash(ls:*), Bash(bash:*)
---

# /review (Finn Loop) — polish, verify, then signal merge

The last beat of Finn Loop. It fires `/polish` (loopkit upgrade #3 — reuse / simplify / efficiency / altitude cleanups, no bug hunting), then `/verify` (the adversarial pass), then posts a rocket emoji to your configured channel so a human knows the change is ready to merge.

## Steps

1. **Gate.** If `SPEC-APPROVED.md` does not exist, stop and print:
   > No approved spec in this tree. `/review` is the third beat of Finn Loop — run `/spec` then `/build` first.
   Exit non-zero.
2. **Polish.** Invoke `/polish` (loopkit upgrade #3). It reviews the current diff for reuse, simplification, efficiency, and altitude cleanups and applies the fixes. Quality only — it is NOT a bug hunt; `/verify` handles that.
   - If `/polish` is not installed in this project (base loopkit only, no upgrade #3), fall back to reading `skills/simplify/SKILL.md` and applying its checklist manually against `git diff HEAD`.
3. **Verify.** Invoke `/verify` (base loopkit `.claude/commands/verify.md`). Adversarial pass against the polished diff. Non-zero from `/verify` blocks the merge signal.
   - If `/verify` fails, do NOT post the rocket. Print the failure list from `/verify` and stop.
4. **Commit the polish.** If `/polish` made changes, commit them via `scripts/committer "chore: polish pass" <files>`.
5. **Signal merge.** Post the rocket emoji to the configured channel:
   - If `LOOPKIT_SLACK_WEBHOOK` is set, run `presets/finn-loop/integrations/slack-notify.sh` (or `.claude/integrations/slack-notify.sh` in installed layout).
   - If no channel is configured, print the rocket to stdout and note that no channel is wired up:
     > 🚀 Ready to merge. (No `LOOPKIT_SLACK_WEBHOOK` configured — set it to auto-post.)
6. **Clear the spec files.** Move both `SPEC-APPROVED.md` and any leftover `SPEC-PENDING.md` into `.finn-loop-history/<ISO-timestamp>/` so the next `/spec` starts clean. Do NOT delete them — history is cheap.
7. **Stop.** The human owns the actual merge click.

## The merge signal

The rocket emoji is the whole protocol. A human sees 🚀 in the configured channel, opens the PR / branch, hits merge. Do not automate the merge itself — that's the human-in-the-loop guarantee Finn Loop exists to preserve.

## Never

- Post the rocket if `/verify` failed. The rocket means "human-mergeable"; a failing verify is not that.
- Skip `/polish` because "the diff is small". Small diffs are exactly where reuse-cleanups get missed.
- Merge the PR from this command. Ever. Merge is a human beat.
- Overwrite `SPEC-APPROVED.md` with a new spec. That belongs to `/spec` on the next cycle.

## Pairs with

- `presets/finn-loop/build.md` — the upstream step that produced the diff being reviewed.
- `.claude/commands/verify.md` — the base loopkit adversarial pass.
- `skills/simplify/SKILL.md` — the fallback when `/polish` (upgrade #3) is not installed.
