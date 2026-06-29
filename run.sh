#!/usr/bin/env bash
# loopkit loop runner: fresh context each turn, state on disk
set -euo pipefail
while true; do
  claude -p "Read PROMPT.md and IMPLEMENTATION_PLAN.md. Do the next step. Commit on green."
  claude -p "/verify" || echo "verify failed, will retry"
  grep -q "^STATUS: done$" IMPLEMENTATION_PLAN.md && { echo "done"; break; }
  sleep 5
done
