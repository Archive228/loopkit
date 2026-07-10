---
name: init-script-contract
description: Author idempotent init.sh under 120s plus sibling test.sh, stop.sh, reset.sh, serve.sh with fixed names the harness relies on.
when_to_use: scaffolding a new project the initializer agent will hand to future sessions, setup takes over 120s and needs splitting into init plus serve, every coding session burns tokens re-discovering how to bring up the dev server
---

# Init Script Contract

Every coding session in a multi-session project starts by bringing the dev server up. If the entry point is named differently each time, or takes four minutes, or prompts for input, you burn tokens and wall-clock on every single session. The fix is a fixed set of script names at the project root with a hard contract. The initializer agent writes them once; every downstream session relies on them.

The names are load-bearing — [[shift-notes]] and [[broken-window-check]] both refer to them by name. Do not invent your own.

## When to apply

- You are the initializer agent scaffolding a fresh project.
- You just discovered setup exceeds 120s and need to split cleanly.
- You are auditing an existing project whose sessions keep re-discovering how to launch the app.

## The five scripts

| Script | Contract |
|---|---|
| `init.sh` | Clean clone → dev server up on `localhost`. Idempotent. Under 120s. Zero prompts. |
| `serve.sh` | Start the dev server only. Written when `init.sh` cannot fit under 120s. |
| `test.sh` | Run the full test suite. Exit non-zero on any failure. |
| `stop.sh` | Cleanly kill the dev server. Sessions run this before exiting. |
| `reset.sh` | Wipe local DB and ephemeral state. Leave code untouched. Used by [[broken-window-check]]. |

## Procedure

1. **Pick the stack** the spec implies. Do not scaffold Docker, CI, or lint configs the spec does not require.
2. **Write `init.sh`** to run end-to-end from an empty clone. Pin every dependency (lockfile, `==`, `Pipfile.lock`). Answer every prompt non-interactively (`-y`, `--yes`, `DEBIAN_FRONTEND=noninteractive`).
3. **Time it.** Run `time ./init.sh` on a clean clone. If it exceeds 120s, split — move one-time setup into `init.sh` and server launch into `serve.sh`. Have `init.sh` call `serve.sh` at the end so single-command startup still works.
4. **Make it idempotent.** Run `./init.sh` twice back-to-back. If the second run errors or duplicates state, guard each step with existence checks (`if [ ! -d node_modules ]`, `createdb --if-not-exists`, etc.).
5. **Write `stop.sh`** to kill by PID file or port, not by process name grep. Grep kills sibling agents on shared sandboxes.
6. **Write `test.sh`** with a single end-to-end smoke test that proves `init.sh` produced a serving app. No feature tests — those belong to future sessions.
7. **Write `reset.sh`** to drop and recreate the DB, clear caches, wipe `/tmp` artifacts. Never touch tracked files.
8. **Verify from empty state.** `git clean -fdx && ./init.sh && ./test.sh && ./stop.sh`. Every script exits 0.

## Anti-patterns

- **Naming it `bootstrap.sh`, `setup.sh`, `dev.sh`.** Downstream sessions grep for the fixed names. A cute alias silently disables the harness.
- **Interactive prompts.** `yarn install` asking about peer deps, `createdb` asking for a password, `npm audit` waiting for input. Every prompt is a stall the session cannot answer.
- **Unpinned deps.** `npm install foo` without a lockfile means the next session gets a different transitive graph. See the Feb 2026 incident where an agent ran `npm update --save` and broke twelve sessions.
- **Killing the server with `pkill node`.** Kills every node process in the sandbox. Use a PID file written by `serve.sh`.
- **Letting `init.sh` create files outside the project directory.** Sandbox will reject it and the failure mode is opaque.
- **Skipping `reset.sh` because "the DB is fine".** [[broken-window-check]] needs it to isolate a bad commit from stale state.

## Red flags

- `init.sh` prints "Press Y to continue" anywhere in its output.
- Timing varies wildly run-to-run — some dep is fetched from the network on the hot path.
- Running `init.sh` twice leaves migrations doubled or ports bound.
- `stop.sh` exits 0 but `lsof -i :3000` still shows the server.

## When NOT to apply

Single-session scripts and one-shot demos. The contract exists to amortize setup cost across many sessions; a one-off run does not need it.

## Related

- [[shift-notes]] — the notes downstream sessions read after `init.sh` succeeds.
- [[broken-window-check]] — runs `init.sh` then `reset.sh` when reverting a bad feature.
- [[single-feature-per-session]] — the discipline this contract enables by keeping session startup cheap.

Inspiration: Prithvi's March 2026 planner/generator/evaluator write-up, where the fixed harness entry points let the evaluator persona re-verify any generator session from scratch without re-learning the launch procedure.