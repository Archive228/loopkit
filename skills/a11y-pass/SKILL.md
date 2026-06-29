---
name: a11y-pass
description: Catch the accessibility failures that ship in almost every AI-built UI. Use after building any interactive component.
when_to_use: forms, buttons, modals, images, color choices, keyboard interaction
---
# Accessibility Pass
- **Keyboard** — every interactive element reachable and operable by Tab/Enter/Esc. Modals trap focus and restore it on close.
- **Labels** — every input has a real `<label>`; icon-only buttons have `aria-label`.
- **Images** — meaningful `alt`; decorative images `alt=""`.
- **Contrast** — text ≥ 4.5:1 (3:1 for large). Don't encode meaning in color alone.
- **Semantics** — real `<button>`/`<a>`, not a clickable `<div>`. Headings in order.
- **Focus** — visible focus ring. Never `outline: none` without a replacement.
Output: each failure with the element + the fix. Test it with Tab only, no mouse.
