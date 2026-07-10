---
name: planner-spec-expand
description: Expand a 1-4 sentence product brief into a full spec with a design language, acceptance surface, and an ordered feature list.
when_to_use: Bootstrapping a project from a one-liner prompt before any generator agent runs, re-planning after scope creep changes the target, producing the input document that feature-list-json will be seeded from
---

# Planner Spec Expand

A one-line brief ("build a claude.ai clone", "a habit tracker with streaks") is not enough surface for a coding agent to make good decisions from. It has no design language, no acceptance criteria, no ordering. The generator ends up inventing scope mid-session and shipping incoherent slices.

The planner's job is to expand the brief into a spec dense enough that every downstream decision — what feature to pick, what "done" looks like, what the button should say — has an answer already written down. See Prithvi's post on planner/generator/evaluator separation for the underlying architecture: https://www.prithvirajrk.com/blog/three-agent-harness.

## When to apply

- The user handed you a brief under ~200 words and expects a real product.
- You're about to seed [[feature-list-json]] and the brief has no orderable features yet.
- Scope drifted mid-project and the original spec no longer describes the target — rewrite, don't patch.

## Procedure — expand in this order

Do the sections in order. Later sections depend on earlier ones being locked.

1. **Restate the brief in one paragraph.** In your own words, what is being built and for whom. If you can't write this cleanly, ask the user before continuing — the brief is under-specified.
2. **Pick a design language.** One sentence each on: visual tone (minimal / dense / playful), typography stance (one sans / serif+sans / mono accents), color posture (monochrome + one accent / two-color / full palette), density (airy / compact). This locks a thousand later micro-decisions.
3. **Enumerate the acceptance surface.** For each user-observable capability, write one sentence of user-observable behavior AND the concrete steps a human would take to verify it. This is the shape [[feature-list-json]] wants — write it in that shape now.
4. **Order the features.** Sort by dependency: nothing appears before what it depends on. Ties broken by "what does the user see first when they open the app." The top of the list must be runnable-alone.
5. **Name the out-of-scope.** One short list of things the brief could imply but you are explicitly not building. Prevents the generator from wandering.
6. **Write the smoke path.** The single user journey that proves the product exists — 3-6 steps end-to-end. This becomes the initializer's smoke test.

## Checklist before you hand off

- Every feature has `description` + `steps` in the shape [[feature-list-json]] expects.
- The first 3 features can be built in order with no forward dependency.
- Design language fits on one screen — if it's a page, you over-specified.
- Out-of-scope list is non-empty. If everything is in scope, you didn't plan, you transcribed.
- Smoke path touches the core value prop, not auth or settings.

## Anti-patterns

- **Padding the feature list to look thorough.** 40 real features beats 200 fake ones. The generator will build all of them.
- **Designing the schema.** That's the generator's job. You describe user-observable behavior; the generator picks the data model.
- **Writing prose where you should write steps.** "User can manage conversations" is not a feature. "Clicking the trash icon on a sidebar item deletes that conversation and removes it from the sidebar" is.
- **Leaving priority implicit.** If two features tie, break the tie now. The generator will not.

## When NOT to apply

Skip this for briefs already specified to acceptance-criteria depth, or for single-feature edits to an existing project — use [[shift-notes]] and pick from the existing [[feature-list-json]] instead.

Related: [[feature-list-json]], [[shift-notes]], [[broken-window-check]].