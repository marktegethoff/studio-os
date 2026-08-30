---
description: "Testable prototype from a validated interaction model. Produces a runnable prototype and a prototype brief."
argument-hint: "<what you're trying to learn or validate>"
---

Run the testable prototype workflow.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from the plugin's `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

Auto-mode defaults for the surviving human nodes:

- `question` node: proceed with the stated test question if it is specific, falsifiable, and actionable; otherwise stop — a prototype against an unscopeable question is waste.
- `readiness` node: treat the build-criteria match check as the verdict (matches → ready; partial/extra → one revision pass).

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand, and the **Engineering** block (`stack`, and `prototype`: the project's prototype environment — where experiments live, and how to build and snapshot them). Load once; do not re-read mid-session.
2. If the project declares its prototype environment in `CLAUDE.md` instead, read that section for tooling, location, and conventions.
3. If this work involves a prior decision, load the relevant file from the project's decision ledger (`decisions/`) by name.
4. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. You provide the discipline.

---

## Purpose

A prototype exists to answer a question. Not to demonstrate polish. Not to show stakeholders what the product will look like. To answer a specific question about user behavior, interaction feasibility, or design direction — cheaply and quickly.

The prototype workflow enforces this discipline. It scopes the test question before any design work begins. It produces build criteria and test criteria in parallel, from the same confirmed scope. It gates on prototype review before testing begins.

**Speed-to-testable is the constraint.** The prototype includes only what is required to answer the test question. Everything else is deferred. A prototype that covers more than its test question is over-built.

### Disciplines

**Designer:** Defines the minimum prototype structure required to answer the test question. Works from confirmed scope. Produces build criteria: which states, which flows, which interactions must be present.

**PM:** Validates the test question before any design work begins. This is the quality gate between scope and execution. A poorly scoped test question produces learning that cannot be acted on.

**QA / Test Criteria:** Defines how the test will be evaluated — what the prototype must do in testing to produce usable learning. Runs in parallel with build criteria.

**Findings Router:** After testing, routes findings to the appropriate discipline. Findings that confirm the design → specifier. Findings that challenge the design → Designer for revision. Findings that challenge the problem framing → PM + Brief Writer.

---

## Graph

This skill's topology. The prose steps below are the executable instructions; this block is the contract they must match (see the plugin's `memory/orchestration.md`). Where the Workflow tool is available, execute segments via `workflow.js`; the graph is the contract either way.

```graph
skill: prototype
cost: low — one blind pair (designer build criteria ∥ qa test criteria)
nodes:
  context     task:load project context + prior artifacts
  scope       agent:pm
  question    human decides:prototype-question
  build       agent:designer owner:build-criteria
  test        agent:qa owner:test-criteria
  criteria    join
  build-task  task:build the prototype in the project's prototype environment
  review      task:render the Review Surface via /studio:feedback
  readiness   human decides:readiness
  routing     router(confirmed|challenged|ambiguous|question-wrong)
  emit        task:output summary + routing recommendation
edges:
  context -> scope -> question
  question -> {build, test}
  {build, test} -> criteria
  criteria -> build-task -> review -> readiness
  readiness -> build-task   loop max:1
  readiness -> scope   loop max:1
  routing -> emit
  readiness -> routing
```

The criteria pair is **blind** — both derive from the same confirmed test question, never from each other's unfinished output; the `criteria` join waits for both and reports a failed member by node id. A REVISE readiness verdict re-enters the build at most once; a REJECT rescopes at most once — further failures mean the question was wrong, which is the `routing` router's business, not another loop.

## Context

What to validate: $ARGUMENTS

---

## Step 0 — Context loading

Project context was loaded above. Check for existing artifacts:
- Prior brief or discovery output for this area
- Existing design specs or wireframes
- Prior prototype iterations (if this is a revision, note what was tested and what was learned)

State what was found as a status line (`context` node) and proceed. The `scope` node then applies the PM discipline to validate the test question before any design work — a poorly scoped question produces learning that cannot be acted on.

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

> **⏸ PAUSE (skipped in --auto) — Test question.** *(`question` node — decides: prototype-question)*
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

Run both in parallel (blind pair — each derives from the same confirmed test question, never from the other's unfinished output). The `criteria` join waits for both; report a failed member by node id per the plugin's `memory/orchestration.md`.

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

**Verification artifacts:** produce whatever the project's prototype environment defines (snapshot tests, previews, or a click-through) so the prototype is reviewable — following the `prototype` setup declared in project-context: where experiments live, how to snapshot them, and which helper to use. These artifacts feed the `/studio:feedback` Review Surface.

### Step 2B — Test criteria (QA)

Define how the test will be evaluated.

**Success signal:** what user behavior, response, or statement would confirm the design direction? Be specific — not "user finds it intuitive" but "user completes [task] without asking a question or pausing more than [n] seconds."

**Failure signal:** what user behavior, response, or statement would indicate the design must change? Be specific.

**Ambiguous signal:** what results would be inconclusive? Name the conditions that would require a second prototype iteration rather than a build decision.

**Sample:** minimum number of sessions required to trust the finding. Name whether this is a validation test (need 5+) or a directional signal (2–3 sessions sufficient).

**Test format:** [Moderated usability / Unmoderated click-through / Prototype walkthrough / Expert review] — recommend the minimum format that produces usable learning.

---

## Step 2.5 — Visual review (auto-fire `/studio:feedback`, `review` node)

After the prototype is built, before testing begins, render the Review Surface for visual review. This replaces the text-only "is the prototype ready" check with the designed HTML review.

Ask the user:

> "Prototype built. **Render review surface?** Default: yes — opens a designed HTML review in your browser with snapshots (when available), summary, and structured questions covering: does the build match the criteria, does it include anything extra to remove, is it ready for testing.
>
> Reply **'skip'** to confirm readiness in chat instead. Reply **anything else** (or just 'continue') to render the review."

Wait for the user's response.

**If user replies 'skip':**

Run the text-only check:

> Before the prototype goes to users, confirm:
>
> 1. Does the built prototype include everything in the build criteria?
> 2. Does it include anything not in the build criteria? (If yes: remove it.)
> 3. Is the test criteria accessible to whoever is running the test?
>
> Reply to **confirm the prototype is ready**, or flag what needs adjustment.

**If user replies anything else (default path):**

Read the `feedback` skill (`skills/feedback/SKILL.md`, surface mode) and follow its steps. Pass the prototype context (test question, build criteria, fidelity, files produced) into the manifest construction. Use this question set in the manifest:

1. *Does the build match the build criteria?* (choice: matches / partial / extra) — corresponds to readiness check #1 and #2 combined
2. *Is the test criteria accessible to whoever runs the test?* (text)
3. *(Always-present catch-all is appended automatically)*

After the feedback surface parses the response block, treat its disposition as the readiness verdict:

- **APPROVE** → prototype is ready; proceed to Step 3 (Findings routing)
- **REVISE** → apply notes from answers, re-run Step 2.5 once revisions are made
- **REJECT** → prototype is not ready; stop and rescope (return to Step 1)

---

> **⏸ PAUSE (skipped in --auto) — Readiness.** *(`readiness` node — decides: readiness)*
> Disposition (Approve / Revise / Reject) drives the next step. Revise re-enters the build at most once; Reject rescopes at most once.

---

## Step 3 — Findings routing

After testing is complete, route findings based on outcome.

**If the test question is answered affirmatively (design direction confirmed):**
→ Route to `specifier` for All States / All Flows completeness work before engineering handoff.
→ Recommend: `/handoff [feature area]`

**If the test question is answered negatively (design direction challenged):**
→ Route to `Designer` for revision.
→ Name specifically what in the design must change based on the failure signal.
→ A revised prototype may be needed before `/handoff`.

**If findings are ambiguous:**
→ Name which aspect of the test criteria produced ambiguity.
→ Recommend whether a second prototype iteration is warranted or whether the ambiguity can be resolved through design judgment alone.
→ Do not route to `/handoff` until the test question has a usable answer.

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
[Confirmed → /handoff | Revised → back to Designer | Ambiguous → [specific next action]]
```
