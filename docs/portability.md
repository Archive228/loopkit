# Portability - running the loopkit loop under other CLIs

`run.sh` calls one command per turn: read the plan, do the next step,
commit on green. The command is not hard-coded - it comes from the
`$LOOPKIT_CLI` environment variable and defaults to `claude -p`.

Swap `$LOOPKIT_CLI` and the same Plan / Act / Verify loop runs under
any CLI that accepts a prompt as an argument and writes to the working
tree. Skills live in `.claude/skills/` as plain `SKILL.md` files, so
any agent that reads that layout picks them up unchanged.

## Claude Code (default)

```bash
export LOOPKIT_CLI="claude -p"
./run.sh
```

Nothing to set - this is what `run.sh` uses when `$LOOPKIT_CLI` is
unset. The verifier subagent and hooks in `.claude/` are Claude-shaped
and light up automatically.

## Codex CLI

```bash
# https://github.com/openai/codex
export LOOPKIT_CLI="codex exec"
export OPENAI_API_KEY="sk-..."
./run.sh
```

`codex exec "<prompt>"` runs one non-interactive turn against the
working tree, the same shape as `claude -p`. Skills are read from
`.claude/skills/` if you symlink or copy them into `AGENTS.md`-visible
paths; otherwise reference them explicitly in `PROMPT.md`.

## Gemini CLI

```bash
# https://github.com/google-gemini/gemini-cli
export LOOPKIT_CLI="gemini -p"
export GEMINI_API_KEY="..."
./run.sh
```

`gemini -p "<prompt>"` is the non-interactive form. The verifier
subagent will not fire (Claude-only), so keep `run.sh`'s second call
(`/verify`) - Gemini will treat it as a plain instruction and run the
checks named in `.claude/agents/verifier.md`.

## Aider

```bash
# https://aider.chat
export LOOPKIT_CLI="aider --message"
export OPENAI_API_KEY="sk-..."   # or ANTHROPIC_API_KEY for --model sonnet
./run.sh
```

`aider --message "<prompt>"` runs one turn and auto-commits on
success, which lines up with loopkit's "commit on green" contract.
Point aider at the same files `PROMPT.md` references
(`aider --message "..." PROMPT.md IMPLEMENTATION_PLAN.md`) if you want
it in the context by default.

## Notes

- `run.sh` polls `IMPLEMENTATION_PLAN.md` for `STATUS: done` to exit -
  every CLI above just needs to write that line when work is
  complete.
- The Claude-shaped harness (`settings.json`, hooks, verifier
  subagent) is a no-op under other CLIs; the skills carry the value.
- If your CLI needs a different flag shape (e.g. `--prompt` instead
  of positional), wrap it: `export LOOPKIT_CLI="mycli --prompt"`.
