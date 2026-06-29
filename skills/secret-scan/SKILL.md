---
name: secret-scan
description: Catch hardcoded secrets, keys, and tokens before they get committed. Use before any commit and on any file with credentials.
when_to_use: before commit, files with API keys, .env handling, config, connection strings
---
# Secret Scan
Grep the diff for: `api[_-]?key`, `secret`, `token`, `password`, `BEGIN PRIVATE KEY`, `AKIA[0-9A-Z]{16}`, `sk-`, `ghp_`, bearer values, and long base64/hex blobs.
For each hit: is it a real secret or a placeholder? Real secrets:
1. Must move to env / a secrets manager — never the repo.
2. If already committed, it is COMPROMISED. Rotate it, don't just delete the line.
3. Add the pattern to `.gitignore` / a pre-commit secret scanner.
Output: file:line of every real secret + the rotation step. A deleted secret in git history is still leaked.
