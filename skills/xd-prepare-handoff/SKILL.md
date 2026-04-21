---
description: Run the XD OS prototype-to-production handoff workflow. Takes a tested prototype to a complete engineering-ready package — all states, all flows, synthetic data, UAT scenarios, and a build spec with DS token translation. Use after a prototype has been validated and before engineering begins.
argument-hint: "<feature or component being handed off>"
---

Run the XD OS prototype-to-production handoff workflow.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Embedded XD OS Context

### Purpose

A tested prototype answers a question. It does not answer all the questions engineering will have. The gap between "enough to test" and "enough to build" is the work this workflow does.

The handoff workflow achieves completeness. It enumerates every state and flow that must be implemented — not just the ones that appeared in the prototype. It generates synthetic data that makes those states real. It produces UAT scenarios that verify the build matches the intent. It produces a build spec that translates design tokens to production components.

**Completeness is the constraint.** A handoff package where engineering must make judgment calls is not finished.

### Disciplines

**State Inventory Auditor:** Enumerates every state the component or feature must exist in. Runs against the prototype artifacts. Identifies gaps — states that were not designed because they weren't needed for testing, but must exist in production.

**Flow Completeness Auditor:** Enumerates every user flow — entry paths, exit paths, error paths, edge paths. The prototype may have covered only the happy path. Production requires all paths.

**Synthetic Data Generator:** Produces realistic content for each state. Ensures states that will be tested look real — not "User Name" and "Lorem ipsum," but content that reflects actual usage patterns.

**UAT Scenario Writer:** Produces test cases that verify the build matches the design intent. Each scenario is a specific user action with an expected outcome. Engineers use these to confirm implementation is correct.

**Specifier (Build Spec mode):** Produces the complete engineering handoff document. If this project has a design system with a DS companion, maps design tokens to production component names. Removes all ambiguity before engineering begins.

---

## Context

Feature or component: $ARGUMENTS

---

## Step 0 — Artifact loading

Load all relevant artifacts before proceeding. Read in order:

1. `project-context.md` (`.claude/memory/` first, fallback `memory/`) — product invariants, brand system, system boundaries
2. `user-profile.md` (`~/.claude/memory/`) — calibrate communication register
3. Design system context: `.claude/skills/design-system/SKILL.md` if it exists — load token vocabulary and component library
4. Prototype artifacts: look for prototype files, wireframes, or mockups for this feature
5. Prior spec artifacts: check for any existing specs that this handoff should extend or supersede
6. Prior test findings: load the `/xd-prototype` output for this feature if it exists — the test question, findings, and routing decision inform the completeness work

Report what was found. Flag missing artifacts:
- If no prototype exists: "No prototype artifacts found. `/xd-prototype` should run before `/xd-prepare-handoff`."
- If no design system context: "No design system skill found. Build spec will use design tokens without component mapping — note this gap."

---

## Steps 1A + 1B — Parallel: State inventory + Flow completeness

Run both in parallel. Both work against the same prototype artifacts.

### Step 1A — State inventory audit

Enumerate every state this component or feature must exist in for production.

**State categories to check:**
- **Default / Resting** — the state the user sees first
- **Loading** — while data is fetching or an action is processing
- **Empty** — no data, first use, zero results
- **Populated** — data present; enumerate variants if data volume affects layout
- **Active / Selected / Focused** — user has engaged with the element
- **Hover / Press** — mid-interaction states (web: hover; mobile: press)
- **Disabled** — interaction is not available; name the condition
- **Error** — something failed; enumerate error types separately if behavior differs
- **Success / Confirmation** — action completed
- **Partial / In-progress** — user has started but not finished
- **Overflow / Truncation** — what happens when content exceeds bounds

For each state:
- Name the state
- Note whether it was designed in the prototype (Y/N)
- Note whether the design exists (designed / needs design / intentionally omitted with reason)

**Flag every undesigned state.** Do not proceed past a state that needs design without naming it explicitly.

### Step 1B — Flow completeness audit

Enumerate every user flow for this feature.

**Flow categories to check:**
- **Primary flow** — the path a successful user takes; was this in the prototype?
- **Entry paths** — how does the user arrive at this feature? Enumerate all entry points.
- **Exit paths** — what can the user do when done? Where do they go?
- **Error recovery** — when an error occurs, what is the recovery path?
- **Edge paths** — first use, returning user with prior state, user with no data, user with maximum data
- **Abandonment** — user starts but does not complete; what state is preserved?

For each flow:
- Name the flow
- Note whether it was included in the prototype (Y/N)
- Note the current design status (designed / needs design / intentionally deferred with reason)

---

> **⏸ PAUSE — Designer must fill gaps before completeness work continues.**
>
> State inventory and flow completeness audit are complete.
>
> **Undesigned states requiring design before handoff:**
> [List from Step 1A]
>
> **Undesigned flows requiring design before handoff:**
> [List from Step 1B]
>
> Design these states and flows, then reply to confirm they are complete. The handoff package cannot be produced without them.
>
> If any states or flows are **intentionally out of scope for this handoff**, name them explicitly and confirm — they will be documented as known gaps in the handoff package.

---

## Steps 2A + 2B — Parallel: Synthetic data + UAT scenarios

Run both in parallel after the designer has confirmed all states and flows are designed.

### Step 2A — Synthetic data

Produce realistic content for each state.

Realistic content is content that reflects actual usage — not placeholders. It must:
- Be the right length (short names and long names; short messages and long messages)
- Reflect realistic data distributions (not all items the same)
- Cover edge cases in content (special characters, numbers, empty strings where valid)
- Respect the product's voice and register

For each state that contains user-generated or system-generated content:
- Produce 2–3 realistic content variants
- Include at least one variant that tests layout at the boundaries (shortest plausible, longest plausible)
- Flag any state where content is dynamic and must be generated at runtime rather than specified statically

### Step 2B — UAT scenarios

Produce test cases that verify the build matches design intent.

Each UAT scenario is:
- A specific user action or condition
- An expected outcome that can be verified by observation
- A pass/fail criterion that does not require subjective judgment

Format for each scenario:
```
Scenario: [name]
Given: [starting state or condition]
When: [user action or system event]
Then: [specific observable outcome]
Pass if: [objective criterion]
Fail if: [objective criterion]
```

Cover:
- All primary flows
- All states with interactive transitions
- All error states and their recovery paths
- At least one edge case per major flow
- Accessibility: at least one scenario per interactive element verifying VoiceOver label and behavior

---

## Step 3 — Build spec (Specifier)

Apply the Specifier discipline in Build Spec mode.

Produce the complete engineering handoff document. This document must be sufficient for an engineer to implement the feature without asking a question.

**Build Spec mode additions (beyond standard spec format):**

If a design system skill exists at `.claude/skills/design-system/SKILL.md`:
- Map every design token in the spec to its production component name
- Flag tokens that exist in the DS companion but have no production component equivalent — engineering must build the component or use the closest equivalent
- Flag tokens that exist in production but are not in the DS companion — note the discrepancy for DS governance

**Required sections:**

1. **Overview** — feature name, where it appears, what it does
2. **States** — all states from the inventory (Step 1A), each fully specified
3. **Flows** — all flows from the completeness audit (Step 1B), each with screen/state transitions named
4. **Component mapping** — design token → production component (if DS companion exists)
5. **Dimensions** — spacing tokens, sizing, layout behavior
6. **Typography** — each text element with token names
7. **Colors** — each color with token names and dark mode variants
8. **Interactions** — gesture parameters, thresholds, tap zones
9. **Motion** — transitions, duration, easing, reduce-motion alternatives
10. **Accessibility** — VoiceOver labels, traits, reading order for every interactive element
11. **Known gaps** — states or flows documented as intentionally out of scope; engineering should not implement them without a spec revision
12. **Implementation notes** — platform constraints, non-obvious behavior, anything engineering will encounter that is not visible in the design

---

> **⏸ PAUSE — Design Director + PM sign-off required before engineering.**
>
> Handoff package is complete. Before this goes to engineering:
>
> **Design Director must confirm:**
> - All states are designed and specified
> - The spec is complete — no sections require engineering judgment
> - No known gaps are blockers (or blockers are explicitly deferred with a date)
>
> **PM must confirm:**
> - UAT scenarios cover the success conditions from the design brief
> - Known gaps are acceptable for this release
> - Engineering can begin
>
> Reply with **sign-off** or flag what must be resolved before handoff.

---

## Output

```
# Handoff Package: [Feature / Component]
Date: [today]
Validated prototype: [link or reference to prototype artifact]

## State inventory
[All states — designed / undesigned / intentionally omitted]

## Flow inventory
[All flows — designed / undesigned / intentionally deferred]

## Synthetic data
[Realistic content for each state]

## UAT scenarios
[Test cases — Given / When / Then / Pass if / Fail if]

## Build spec
[Complete engineering handoff document]

## Known gaps
[States and flows explicitly deferred — must not be implemented without a spec revision]

## Sign-off
Design Director: [confirmed / pending]
PM: [confirmed / pending]
```
