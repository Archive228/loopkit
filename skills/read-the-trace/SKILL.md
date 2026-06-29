---
name: read-the-trace
description: Extract the actual cause from a stack trace instead of pattern-matching the error type. Use on any crash or exception.
when_to_use: a stack trace, an exception, "TypeError/NullPointer/undefined", a crash log
---
# Read the Trace
LLMs love to see "TypeError" and generate a generic fix without reading the trace. Don't.
- Find the **deepest frame in YOUR code** — not the library frame at the top. That's where the bad value entered.
- Read the actual values: what was null/undefined/wrong-type, and where it came from.
- Trace it one level up: why was that value bad? The root is usually 1-2 frames above the throw.
- Reproduce with that exact input before fixing.
A TypeError can mean a hundred things. The trace tells you which one — read all of it, including the "caused by".
