---
name: owasp-review
description: Security-review a diff against the OWASP Top 10. Use before merging anything that touches auth, input handling, queries, or external calls.
when_to_use: new endpoint, auth/session change, user input, raw query, file upload, deserialization
---
# OWASP Review
Check the diff for each, with the exact line:
- **Injection** — any string-built SQL/shell/HTML. Demand parameterized queries / escaping.
- **Broken access control** — does it verify the user OWNS the resource, not just that they're logged in?
- **Auth** — secrets in code? tokens without expiry? password compare not constant-time?
- **SSRF** — user-controlled URL fetched server-side without an allowlist.
- **Sensitive data** — PII/secrets logged, returned in errors, or sent unencrypted.
- **Deserialization** — untrusted input into pickle/yaml.load/eval.
- **Dependency** — a new package with known CVEs or no maintenance.
Output: a list of {line, risk, fix}. If clean, say so explicitly. Never assume input is safe because "it comes from our frontend".
