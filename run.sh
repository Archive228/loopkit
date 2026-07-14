#!/usr/bin/env bash
# loopkit loop runner: fresh context each turn, state on disk
#
# CLI selection:
#   LOOPKIT_CLI   command that takes a prompt as its final argument.
#                 Defaults to "claude -p". Swap for other agents, e.g.
#                   LOOPKIT_CLI="codex exec"
#                   LOOPKIT_CLI="gemini -p"
#                   LOOPKIT_CLI="aider --message"
#                 See docs/portability.md.
#
# Model routing env vars (Claude-only; ignored when LOOPKIT_CLI is set):
#   CLAUDE_PLANNER_MODEL   reserved for /spec workflows (not used in this loop)
#   CLAUDE_EXECUTOR_MODEL  --model for the "do the next step" call
#   CLAUDE_JUDGE_MODEL     --model for the "/verify" call
# See skills/model-routing/SKILL.md for the three-tier pattern.
set -euo pipefail

EXEC_ARGS=()
JUDGE_ARGS=()
if [ -z "${LOOPKIT_CLI:-}" ]; then
  [ -n "${CLAUDE_EXECUTOR_MODEL:-}" ] && EXEC_ARGS+=(--model "$CLAUDE_EXECUTOR_MODEL")
  [ -n "${CLAUDE_JUDGE_MODEL:-}" ] && JUDGE_ARGS+=(--model "$CLAUDE_JUDGE_MODEL")
fi

CLI="${LOOPKIT_CLI:-claude -p}"

while true; do
  $CLI "${EXEC_ARGS[@]}" "Read PROMPT.md and IMPLEMENTATION_PLAN.md. Do the next step. Commit on green."
  $CLI "${JUDGE_ARGS[@]}" "/verify" || echo "verify failed, will retry"
  grep -q "^STATUS: done$" IMPLEMENTATION_PLAN.md && { echo "done"; break; }
  sleep 5
done
