---
name: authz-check
description: Verify that an endpoint checks ownership, not just authentication. Use on any handler that reads or mutates user data.
when_to_use: new/changed endpoint, "get user X's data", a mutation, an admin action
---
# Authz Check
The most common security hole: the code checks you're logged IN, but not that you OWN the thing.
- For every resource access: does it verify the current user is allowed THIS specific record? `WHERE id = ? AND owner_id = current_user` — not just `WHERE id = ?`.
- IDOR test: swap the ID in the request to another user's. Does it leak/allow?
- Admin/privileged actions: is the role checked server-side, every time, not just hidden in the UI?
- Default deny: new endpoints should require explicit authorization, not be open by oversight.
Output each handler that authenticates but doesn't authorize, with the missing check.
