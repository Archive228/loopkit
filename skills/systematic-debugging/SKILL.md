---
name: systematic-debugging
description: Use for ANY bug, test failure, crash, or unexpected behavior. Forces
  reproduce-then-isolate before proposing a fix. Stops the agent from guessing.
when_to_use: a test fails, a crash, wrong output, "it worked yesterday", a flaky failure
---

# Systematic Debugging

The single most expensive agent failure: seeing an error and immediately generating a
"fix" based on the error type, without reading what actually happened. Don't.

## The loop

1. **Read the whole error.** The entire message and stack trace. A TypeError can mean a
   hundred different things — the trace tells you which one. Quote the exact line that throws.

2. **Reproduce it first.** If you can't reproduce it, you can't verify a fix. Write the
   smallest input that triggers it. "I think this fixes it" is gambling, not debugging.

3. **Form one hypothesis, name it.** "I think the value is null because the upstream call
   returns 204 with no body." State it before you touch anything.

4. **Change one thing. Test. Repeat.** If you change three things and it works, you don't
   know which one fixed it — and the other two may have added new bugs.

5. **Fix the root cause, not the symptom.** A null check that hides a null is not a fix.
   Find why it's null. The underlying bug will resurface differently if you only patch the crash.

## Stop conditions

- If 3 hypotheses fail, STOP and report: what you tried, what you saw, what you suspect.
  "I've tried X and Y, here's the output, I think it's Z but I'm not sure" beats 20 silent
  random attempts.
- Never add a workaround you don't understand.

## Output

End with: the root cause (one sentence), the minimal fix, and the test that now proves it.
