---
name: dependency-audit
description: Decide whether to add, keep, or remove a dependency. Use before adding any package.
when_to_use: adding a package, a bloated lockfile, a CVE alert, "do we need this dep"
---
# Dependency Audit
Before adding a package, ask:
1. **Can the stdlib do it?** No lodash for `Array.map`. No left-pad-tier packages.
2. **Is it already in the tree?** Don't add axios if the project uses fetch.
3. **Is it alive?** Last commit, open issues, maintainer responsiveness.
4. **Cost?** A 500KB dep to format a date isn't worth it. Check the install size and transitive deps.
5. **Security?** Known CVEs? Postinstall scripts?
When you do add one, justify it in the PR body. Never silently grow package.json. For existing deps: anything unused or one-function gets removed.
