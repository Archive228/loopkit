---
name: hitl-escalate
description: Escalate blocked runs to a human via configured channel or fallback to BLOCKED.md and exit the loop. Use when the loop hits an ambiguous spec, a missing credential, a destructive action needing approval, or 3+ consecutive verify failures on the same task.
when_to_use: the loop hit an ambiguous spec, a missing credential, a destructive action needing approval, or 3+ consecutive verify failures on same task
---

# Human-in-the-Loop Escalate

Long-running agent loops fail in a specific way when they meet a question they can't answer: they guess. The guess ships, the next session builds on it, and by the time a human looks the divergence is three commits deep. This skill is the release valve — when the agent is stuck, it stops and asks, cleanly, in a shape the human can act on.

## Trigger — escalate when any of these are true

- **Ambiguous spec.** `PROMPT.md` admits two implementations and the choice changes user-visible behavior.
- **Missing credential.** A required env var, API key, or config file is absent, and there is no sanctioned way for the agent to create one.
- **Destructive action needing approval.** Dropping a table, force-pushing, deleting user data, spending money, sending mail to real recipients.
- **3+ consecutive `/verify` failures on the same task.** The loop is thrashing. Stop and get a human eye before the fourth attempt.
- **External dependency down.** A third-party service the feature needs is unreachable and no offline path exists.

If none of the above hold, do not escalate. Guessing is bad; escalating on a solvable problem is also bad (it trains humans to ignore the channel).

## Primary action — call the human via the configured channel

Read `LOOPKIT_HITL_CHANNEL`. Supported values:

| Value | Shape |
|---|---|
| `telegram` | POST to `https://api.telegram.org/bot$LOOPKIT_HITL_TELEGRAM_TOKEN/sendMessage` with `chat_id=$LOOPKIT_HITL_TELEGRAM_CHAT`, `text=<question + repo + short context>`. |
| `slack` | POST JSON `{"text": "..."}` to `$LOOPKIT_HITL_SLACK_WEBHOOK` (incoming-webhook URL). |
| `dial` | Run `$LOOPKIT_HITL_DIAL_CMD` with the message on stdin. Whatever the operator wired up — SMS gateway, ntfy, phone call, pager. |
| `none` (or unset) | Skip the primary action. Go straight to fallback. |

Message body — always these five lines, in this order:

```
[loopkit] blocked in <repo-name> on <ISO timestamp>
Q: <one-line question>
Context: <one-line what you were doing>
Attempted: <one-line what you tried>
Choices: <A | B | C>
```

Non-2xx from the channel is a soft failure. Log it, then fall through to the fallback so the loop still exits cleanly.

## Fallback — write BLOCKED.md and exit

Whether the primary succeeds or fails, always write `./BLOCKED.md` at the repo root with exactly four sections:

```markdown
# Blocked

## Question:
<one sentence, answerable with a short reply>

## Context:
<what feature, which file, which commit, why now — 3-6 lines>

## Attempted:
<bulleted list of what you tried and why each fell short>

## Choices:
- A) <option> — <consequence>
- B) <option> — <consequence>
- C) <option> — <consequence>
```

Then `exit 2`. The loop runner (`run.sh`) checks for `BLOCKED.md` at the head of each iteration and exits with code 2 if it exists — that stops the loop until a human clears it.

## Human unblocks

The human reads `BLOCKED.md`, edits `PROMPT.md` / drops the credential / approves the destructive step, then `rm BLOCKED.md` and restarts `run.sh`. The deleted `BLOCKED.md` is the unblock signal.

## Anti-patterns — do not do these

- **Do not fabricate an answer.** "I'll assume the user meant X" is how divergence starts. Assume nothing under ambiguity — escalate.
- **Do not loop endlessly.** After the third consecutive `/verify` failure on the same task, escalate. The fourth attempt is not going to succeed by the same reasoning that failed thrice.
- **Do not silently swallow the missing credential.** Do not commit a placeholder, do not disable the feature, do not "TODO" the auth. Ask.
- **Do not escalate for questions the repo already answers.** Read `AGENTS.md`, `PROMPT.md`, and the last three commits first. Escalation is expensive human attention — spend it on real ambiguity.
- **Do not skip writing `BLOCKED.md` because the primary channel succeeded.** The file is the loop's exit contract. Without it, `run.sh` keeps spinning.

## Pairs with

- `adversarial-verify` — the source of the 3-verify-failure trigger.
- `shift-notes` — after escalating, note the block in `IMPLEMENTATION_PLAN.md` so the next session (post-unblock) has full context.
- `spec-first` — an ambiguous `PROMPT.md` is a spec-first failure; the human's unblock should tighten the spec, not just answer the one-off.
