---
name: design-system
description: Make frontend output look intentional, not AI-generated. Use for any UI work — components, pages, layouts.
when_to_use: building UI, a component, a page, "make this look good"
---
# Design System
Default AI UI is gray, centered, and timid. Don't ship that.
- **Type** — one distinctive display face + one clean body face. Real scale (e.g. 12/14/16/20/28/40), not everything 16px.
- **Color** — one strong accent, a real neutral ramp, intentional contrast. No 5 competing brand colors.
- **Space** — a spacing scale (4/8/12/16/24/32...). Generous whitespace. Align to a grid.
- **Motion** — purposeful only: feedback on action, transitions on state. No decorative bounce.
- **Hierarchy** — one clear focal point per screen. Size, weight, and space do the work, not borders everywhere.
Before done: would a senior designer ship this, or does it look like a default Tailwind template? If the latter, push the contrast and the type.
