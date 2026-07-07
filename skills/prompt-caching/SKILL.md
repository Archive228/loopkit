---
name: prompt-caching
description: Cache the parts of the prompt that don't change so a long-running loop stops paying full price on every turn. Use when the system prompt, tool defs, or reference docs are stable across many turns.
when_to_use: long session, repeated large context, cost climbing, system prompt >1024 tokens, unchanged tool definitions across turns
---

# Prompt Caching

Every turn of a Plan→Act→Verify loop resends the same system prompt, the same tool definitions, and (usually) the same reference docs. Without cache breakpoints you pay full input price on all of it, every turn. With them, cached reads cost ~10% of the write.

## Where to put breakpoints

Cache from the top of the prompt down. The cache is prefix-matched — a break in the middle invalidates everything after it.

1. **System prompt** — mark the end of it as a breakpoint if it's >1024 tokens (Sonnet/Opus) or >2048 (Haiku).
2. **Tool definitions** — cache immediately after, if the tool set is stable across the loop.
3. **Large stable docs** — repo map, style guide, spec — before any turn-specific user text.
4. **User message stem** — only if the same preamble repeats every turn.

Everything past the last breakpoint is billed fresh every turn. That's fine — that's where the changing content goes.

## TTL choice

- **5-minute cache** (default) — for tight loops where turns are seconds apart. Free to write.
- **1-hour cache** — for slow loops (human in the loop, background jobs). Write cost is higher; break-even is ~2 hits.

Pick 5m unless you know turns are minutes apart.

## Staleness rules — cache invalidation is silent

- **Any byte change** above the breakpoint invalidates the cache from that point.
- **Reordering** tools or messages counts as change.
- **Trailing whitespace** counts as change.
- **A different model version** counts as change.

If cost isn't dropping, log the cache-hit metric. Do not assume.

## When NOT to cache

- Prompt <1024 tokens — below the minimum block size, no savings.
- One-shot calls — no reuse, cache write is wasted.
- Highly dynamic system prompt (per-user templating) — cache misses will exceed hits.

## Red flags

- **Cost graph flat after adding breakpoints** — you're invalidating on every turn. Diff two consecutive requests byte-for-byte above the breakpoint.
- **Breakpoint after user message** — pointless; the user message changes every turn.
- **Four+ breakpoints** — max is four; extras are ignored silently.
- **Caching a prompt that gets edited mid-session** — one edit above the cut wipes all downstream savings.

## The math

Cache write ≈ 1.25× normal input. Cache read ≈ 0.1× normal input. So a stable 20K-token prefix hit N times: N=1 costs more than no-cache; N=2 breaks even; N=10 costs ~15% of no-cache. Long loops win big; short chats lose.

Cache is the single biggest cost lever on a long-running agent. Set it once at the start of the loop, verify hits, forget it.
