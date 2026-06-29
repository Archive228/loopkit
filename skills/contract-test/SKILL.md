---
name: contract-test
description: Test the boundary between two systems by the contract, not the implementation. Use for APIs, integrations, and shared interfaces.
when_to_use: an API endpoint, a service integration, a webhook, a shared schema
---
# Contract Test
Test what the two sides AGREED on, so either can change internals without breaking the other.
- Assert the **shape**: required fields, types, status codes, error format — not internal logic.
- Cover the contract's edges: missing optional fields, the documented error responses, pagination bounds, versioning.
- For consumers: test against the real contract (recorded/real responses), not a mock you wrote to match your assumptions — that mock drifts and lies.
- One source of truth for the schema; both sides validate against it.
A green unit test with a wrong mock is worse than no test. Pin the contract.
