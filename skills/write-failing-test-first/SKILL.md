---
name: write-failing-test-first
description: Before fixing any bug, write a test that reproduces it and watch it fail. Use for every bug fix.
when_to_use: fixing a bug, "make X work", a reported defect
---
# Write the Failing Test First
The only proof you fixed a bug is a test that failed before and passes after.
1. Write the smallest test that reproduces the reported behavior.
2. Run it. **Watch it fail** for the right reason (read the assertion, not just red).
3. Now fix the code.
4. Run the test. It passes. Run the FULL suite — you didn't break anything else.
If you can't write the test easily, the architecture is telling you something (tight coupling). Say so.
Never: fix first, test after (you'll write a test that passes regardless). Never: skip the watch-it-fail step.
