---
name: structured-output
description: Get JSON out of the model reliably. Prefer tool_use with a schema over prompted-JSON, validate on receive, retry on parse fail. Use when downstream code will parse the response.
when_to_use: extracting structured data, agent-to-agent handoff, verifier verdicts, anything a script has to json.loads
---

# Structured Output

Prompted JSON — "reply as JSON" in the system prompt — fails on ~2-8% of calls in the wild: stray prose before the object, trailing commas, unescaped quotes, code fences. That failure rate is fine for a demo and fatal for a loop that runs a thousand times.

## The hierarchy — use the strongest that fits

1. **Tool use with schema** (best) — declare a tool with a JSON Schema for its input. Force the model to call that tool. The API validates the arguments against the schema before you see them. Malformed JSON never leaves the model. Use this whenever the downstream is a real parser.

2. **JSON mode / `response_format`** (good) — where supported. Guarantees a valid JSON object at the top level; does not guarantee schema conformance. Cheap upgrade over prompted-JSON.

3. **Prompted JSON with strict rules** (fallback) — for models/tiers without tool use. Say "output ONLY the JSON object, no code fences, no prose", give an example, and validate on receive. Assume ~5% failure and handle it.

## The validate-and-retry pattern

```
call → parse → if fail: retry once with the parse error appended → parse → if fail: hard fail
```

- **One retry, not a loop.** If the model can't produce it in two tries, the schema is too complex or the prompt is wrong. Log and stop.
- **Feed the parse error back verbatim** on retry — the model will fix specific issues ("expected string at line 3") that it can't guess from a generic "please try again".
- **Never silently coerce.** If a required field is missing, fail loudly. Auto-defaults hide prompt bugs.

## Schema design — keep it flat

- **Flat objects beat nested.** Every level of nesting is another chance to hallucinate.
- **Enums over free strings.** `"severity": "high|medium|low"` not `"severity": "..."`.
- **Optional fields default to null explicitly** in the schema. Don't ask the model to "omit if unknown".
- **No `additionalProperties: true`** without a reason. If the model can add fields, it will, and they'll be inconsistent.

## When free JSON is acceptable

- Single scalar field, low-stakes (`{"answer": "yes"}`).
- Human-in-the-loop reviewing every output.
- Prototype throwaway.

Otherwise use tool_use.

## Red flags

- **Regex to extract JSON from a code fence.** You're one prompt tweak away from breakage. Use tool_use.
- **`json.loads` with a bare `try/except: pass`.** Silent failure — you'll be debugging a downstream nil for hours.
- **Schema is a wall of `oneOf`/`anyOf`.** Split into multiple tools and let the model choose which to call.
- **"Just add 'ONLY JSON' to the system prompt" in a hot loop.** Works 95% of the time. That's the problem.
- **Different structured output on retry with same input.** Set temperature to 0 for extraction tasks.

## Loopkit-adjacent

Loopkit's `adversarial-verify` output is `{"passes": bool, "failures": [...]}` — that is exactly the shape this skill formalizes. When you compose skills, keep every machine-consumed hop tool_use'd.
