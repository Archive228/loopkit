---
name: bisect-regression
description: Find the exact commit that introduced a bug. Use when something worked before and broke, and you don't know which change did it.
when_to_use: "it worked last week", a regression, unclear which commit broke it
---
# Bisect the Regression
1. Find a known-good commit and a known-bad one. Confirm both by actually checking out and testing.
2. `git bisect start; git bisect bad <bad>; git bisect good <good>`.
3. At each step, run the SMALLEST test that distinguishes good from bad. Mark `git bisect good/bad`.
4. When git names the first bad commit, read its diff. The bug is in those lines — don't guess elsewhere.
5. `git bisect reset`. Report: the commit, the line, the one-sentence cause.
Automate it: `git bisect run ./repro.sh` if you have a script that exits non-zero on the bug.
