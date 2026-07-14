# Finn Loop preset

An opinionated arrangement of loopkit's core skills for **async, human-gated** shipping. Named after the async-first cadence Finn Hackett has been evangelising: the agent does the *thinking* on its own clock, then blocks on a human ACK before it does the *doing*.

## The loop

```
/spec  →  SPEC-PENDING.md  →  (human ACKs by touching SPEC-APPROVED.md)
  →  /build  →  diff  →  /review  →  rocket emoji on the configured channel  →  merge
```

Four beats, and the middle two are gated. `/spec` writes and *stops*. `/build` refuses to run until it sees `SPEC-APPROVED.md`. `/review` runs `/polish` then `/verify` then posts a rocket emoji to your channel; a human sees the rocket, opens the PR, hits merge.

## Why this is a preset, not the core loop

Base loopkit is `/spec` → implement → `/verify`, single-session, synchronous. That is the 49-skill floor and it will stay that way. Finn Loop is one arrangement on top:

- It splits *spec-writing* and *building* across two sessions with a human ACK between them.
- It adds a merge-signalling step (`/review`) that talks to an outside channel (Linear, Slack, whatever).
- It ships two integration hooks (Linear MCP, Slack webhook) — both **OFF by default**.

If you want synchronous solo shipping, use base loopkit. If you want async human-gated shipping, install Finn Loop on top.

## Install

```
loopkit install --preset finn-loop
```

That copies the four command files into `.claude/commands/` and drops the integrations placeholders into `.claude/integrations/`. Nothing turns on until you edit the placeholders.

## Turning integrations on

- **Slack rocket-emoji ping**: `export LOOPKIT_SLACK_WEBHOOK=<your incoming-webhook URL>`. `integrations/slack-notify.sh` refuses without it.
- **Linear MCP**: uncomment the block in `integrations/linear-mcp.json` and fill in your workspace + API key.

## Companion presets (planned)

`presets/three-agent/` (planner + generator + evaluator) and `presets/executor-judge/` (do → judge → do → judge) are the other two arrangements on the roadmap. Same 49-skill floor, different beats.
