#!/usr/bin/env bash
# slack-notify.sh — Finn Loop merge-signal poster.
#
# Called by presets/finn-loop/review.md at the end of a successful review pass.
# Posts a rocket emoji (+ optional context line) to a Slack incoming webhook.
#
# OFF BY DEFAULT. This script refuses to run without LOOPKIT_SLACK_WEBHOOK set.
# That is intentional — Finn Loop's whole point is that outbound signalling is
# opt-in per operator, not auto-configured behind their back.
#
# Enable with:
#   export LOOPKIT_SLACK_WEBHOOK="https://hooks.slack.com/services/T00000/B00000/XXXX"
#
# Usage:
#   ./slack-notify.sh                    # posts just the rocket
#   ./slack-notify.sh "feat: login flow" # posts rocket + context line

set -euo pipefail

if [[ -z "${LOOPKIT_SLACK_WEBHOOK:-}" ]]; then
  echo "slack-notify: LOOPKIT_SLACK_WEBHOOK is not set — refusing to post." >&2
  echo "slack-notify: export the incoming-webhook URL to enable this integration." >&2
  exit 1
fi

CONTEXT="${1:-}"
if [[ -n "$CONTEXT" ]]; then
  PAYLOAD=$(printf '{"text":":rocket: %s"}' "$CONTEXT")
else
  PAYLOAD='{"text":":rocket:"}'
fi

# Fail-soft: log non-2xx but don't crash the review pass.
HTTP=$(curl -sS -o /tmp/slack-notify.out -w '%{http_code}' \
  -X POST -H 'Content-Type: application/json' \
  --data "$PAYLOAD" \
  "$LOOPKIT_SLACK_WEBHOOK" || echo "000")

if [[ "$HTTP" =~ ^2 ]]; then
  echo "slack-notify: posted rocket (HTTP $HTTP)"
  exit 0
else
  echo "slack-notify: webhook returned HTTP $HTTP — merge signal NOT delivered" >&2
  cat /tmp/slack-notify.out >&2 || true
  exit 2
fi
