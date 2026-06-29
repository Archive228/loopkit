---
name: tool-restraint
description: Don't over-equip an agent with tools/MCP servers. More tools = more ways to fail and a higher cognitive load. Use when wiring tools or an agent underperforms.
when_to_use: adding MCP servers, an agent with many tools, "give it access to everything"
---
# Tool Restraint
Loading an agent with 14 MCP servers "just in case" makes it slower and dumber, not more capable — tool-use agents hit sharp capability cliffs as cognitive load rises.
- Enable **only** the servers the current work actually uses. Remove the rest.
- Prefer official servers for credentialed tools; never install five speculatively.
- Each tool's description eats context on every turn — fewer, sharper tools beat a junk drawer.
- Before adding a write-scoped server, add a hook that logs every call.
If the agent picks the wrong tool or thrashes, the fix is usually fewer tools with clearer descriptions, not a smarter model.
