---
description: Run the XD OS testable prototype workflow. Scopes the test question, establishes minimum fidelity, defines build and test criteria in parallel, and routes findings. Speed-to-testable is the constraint — not polish. Use when you need to learn something fast before committing to build.
argument-hint: "<what you're trying to learn or validate>"
---

Run the XD OS testable prototype workflow.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Embedded XD OS Context

### Purpose

A prototype exists to answer a question. Not to demonstrate polish. Not to show stakeholders what the product will look like. To answer a specific question about user behavior, interaction feasibility, or design direction — cheaply and quickly.

The prototype workflow enforces this discipline. It scopes the test question before any design work begins. It produces build criteria and test criteria in parallel, from the same confirmed scope. It gates on prototype review before testing begins.

**Speed-to-testable is the constraint.** The prototype includes only what is required to answer the test question. Everything else is deferred. A prototype that covers more than its test question is over-built.

### Disciplines

**Designer:** Defines the minimum prototype structure required to answer the test question. Works from confirmed scope. Produces build criteria: which states, which flows, which interactions must be present.

**PM:** Validates the test question before any design work begins. This is the quality gate between scope and execution. A poorly scoped test question produces learning that cannot be acted on.

**XD QA / Test Criteria:** Defines how the test will be evaluated — what the prototype must do in testing to produce usable learning. Runs in parallel with build criteria.

**Findings Router:** After testing, routes findings to the appropriate discipline. Findings that confirm the design → xd-specifier. Findings that challenge the design → Designer for revision. Findings that challenge the problem framing → PM + Brief Writer.

---

## Context

What to validate: $ARGUMENTS

---

## Step 0 — Context loading

Load project context. Read in order:
1. `studio_os/project-context.md`; if not found, check `.claude/memory/project-context.md` or `memory/project-context.md`; if absent, read `CLAUDE.md` for product context — product invariants, user archetypes, any prior decisions relevant to this area
2. `user-profile.md` (`~/.claude/memory/`) — calibrate communication register

Check for existing artifacts:
- Prior brief or discovery output for this area
- Existing design specs or wireframes
- Prior prototype iterations (if this is a revision, note what was tested and what was learned)

Report what was found before proceeding.

---

## Step 1 — Scope

Define the test question precisely.

The test question is the single question this prototype must answer. It is:
- **Specific:** names a user, a behavior, and a context
- **Falsifiable:** the prototype can answer it yes or no
- **Actionable:** the answer changes what we build

Format: "We need to know whether [specific user] will [specific behavior] when [specific context or condition]."

One test question per prototype. If there are two questions, there are two prototypes.

Name the **failure mode:** if the prototype answers no, what does that mean for the design direction? If the answer would change nothing, the test question is wrong.

---

> **⏸ PAUSE — Test question confirmation required.**
>
> Before build and test criteria are written, the test question must be confirmed.
>
> Review:
> - **Test question:** [stated above]
> - **Failure mode:** [what a "no" answer means]
>
> Reply to **confirm**, **revise the question**, or **stop** (if the question cannot be scoped to a single falsifiable claim).

---

## Steps 2A + 2B — Parallel: Build criteria + Test criteria

Run both in parallel. They derive from the same confirmed test question.

### Step 2A — Build criteria (Designer)

Define the minimum prototype required to answer the test question.

**What must be present:**
- States: enumerate only the states required for the test. Happy path only unless edge behavior is the test question.
- Flows: enumerate only the flows the user must traverse in testing. Untested flows are not built.
- Interactions: enumerate only the interactions required for the test. Static mockups are preferred over interactive prototypes unless interaction is the test question.
- Copy: indicate where copy is required for the test (user must read it to respond) vs. where placeholder is sufficient.

**What must not be present:**
- Name anything a designer might build by instinct that is not required by the test question. Call it out explicitly as deferred.

**Fidelity recommendation:** [Lo-fi / Mid-fi / Hi-fi] — name the minimum fidelity required to answer this question, with reasoning.

### Step 2B — Test criteria (QA)

Define how the test will be evaluated.

**Success signal:** what user behavior, response, or statement would confirm the design direction? Be specific — not "user finds it intuitive" but "user completes [task] without asking a question or pausing more than [n] seconds."

**Failure signal:** what user behavior, response, or statement would indicate the design must change? Be specific.

**Ambiguous signal:** what results would be inconclusive? Name the conditions that would require a second prototype iteration rather than a build decision.

**Sample:** minimum number of sessions required to trust the finding. Name whether this is a validation test (need 5+) or a directional signal (2–3 sessions sufficient).

**Test format:** [Moderated usability / Unmoderated click-through / Prototype walkthrough / Expert review] — recommend the minimum format that produces usable learning.

---

> **⏸ PAUSE — Prototype review before testing.**
>
> Before the prototype goes to users, confirm:
>
> 1. Does the built prototype include everything in the build criteria?
> 2. Does it include anything not in the build criteria? (If yes: remove it.)
> 3. Is the test criteria accessible to whoever is running the test?
>
> Reply to **confirm the prototype is ready**, or flag what needs adjustment.

---

## Step 3 — Findings routing

After testing is complete, route findings based on outcome.

**If the test question is answered affirmatively (design direction confirmed):**
→ Route to `xd-specifier` for All States / All Flows completeness work before engineering handoff.
→ Recommend: `/xd-prepare-handoff [feature area]`

**If the test question is answered negatively (design direction challenged):**
→ Route to `Designer` for revision.
→ Name specifically what in the design must change based on the failure signal.
→ A revised prototype may be needed before `/xd-prepare-handoff`.

**If findings are ambiguous:**
→ Name which aspect of the test criteria produced ambiguity.
→ Recommend whether a second prototype iteration is warranted or whether the ambiguity can be resolved through design judgment alone.
→ Do not route to `/xd-prepare-handoff` until the test question has a usable answer.

**If the prototype reveals the test question was wrong:**
→ Route back to Step 1 with the revised framing.
→ Note: this is not a failure. A prototype that corrects the question is doing its job.

---

## Output summary

```
# Prototype: [What is being tested]
Date: [today]

## Test question
[Single falsifiable question]

## Failure mode
[What a "no" answer means for the design direction]

## Build criteria
[Minimum states, flows, interactions, copy required]
[Fidelity: Lo-fi / Mid-fi / Hi-fi — with reasoning]

## Test criteria
[Success signal]
[Failure signal]
[Ambiguous signal]
[Sample size + test format]

## Findings
[After testing: outcome + routing decision]

## Next step
[Confirmed → /xd-prepare-handoff | Revised → back to Designer | Ambiguous → [specific next action]]
```
