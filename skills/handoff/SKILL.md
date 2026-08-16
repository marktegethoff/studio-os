---
description: "Prototype to production-ready package. Produces a state inventory and component spec from a validated prototype."
argument-hint: "<feature or component being handed off>"
artifact: state-inventory
---

Run the Studio OS prototype-to-production handoff workflow.

Arguments: $ARGUMENTS

**Six Functions (see CLAUDE.md).** A handoff packages an already-validated design. Confirm the six functions were satisfied upstream (in `/studio:design`) before producing the build spec — flag any function that was skipped (especially usability/accessibility and the CD gate) as a gap to close before engineering begins, not after.

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

Auto-mode defaults for the surviving human nodes:

- `gaps` node: do not invent designs for undesigned states — document every gap as a known gap and proceed; the package ships with the gap list.
- `signoff` node: gate verdicts stand; flagged blockers are recorded as blockers, not waived.

---

## Embedded Studio OS Context

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

## Graph

This skill's topology. The prose steps below are the executable instructions; this block is the contract they must match (see `memory/orchestration.md`). Where the Workflow tool is available, execute segments via `workflow.js`; the graph is the contract either way.

```graph
skill: handoff
cost: medium — two paired blind fan-outs plus completeness, reduction, and gate chain
nodes:
  artifacts     task:load prototype, design-system context, prior specs and findings
  states        agent:designer owner:state-inventory
  flows         agent:journey-mapper owner:flow-inventory
  gaps-join     join
  gaps          human decides:gap-closure-or-scope
  data          agent:writer owner:synthetic-data
  uat           agent:qa owner:uat-scenarios
  package-join  join
  critic        agent:critic
  spec          agent:specifier owner:build-spec
  accessibility agent:accessibility
  slop          gate:slop — seven markers of /studio:studio-slop
  cd-gate       gate:cd — design completeness sign-off
  pm-gate       gate:pm — UAT-vs-brief and release-gap sign-off
  signoff       human decides:blocker-acceptance
  emit          task:render state-inventory HTML
edges:
  artifacts -> {states, flows}
  {states, flows} -> gaps-join
  gaps-join -> gaps   if:undesigned-gaps
  gaps-join -> {data, uat}   if:complete
  gaps -> {data, uat}
  {data, uat} -> package-join
  package-join -> critic -> spec -> accessibility -> slop -> cd-gate -> pm-gate
  pm-gate -> signoff   if:blockers-flagged
  pm-gate -> emit   if:clean
  signoff -> emit
```

Both paired fan-outs are **blind** — the two auditors (and later the data/UAT pair) work from the same shared artifacts, never from each other's unfinished output. Joins wait for both members; a failed member is reported by node id, never silently synthesized around. The `critic` node is the reduction function this workflow previously lacked: the package is pressure-tested — anything not earned is removed — before it is specified. The CD and PM gates are structural; the human is pulled in (`signoff`) only when a gate flags blockers. Dissents preserved throughout (see Consensus Laundering, `memory/anti-patterns.md`).

## Context

Feature or component: $ARGUMENTS

---

## Step 0 — Artifact loading

Load all relevant artifacts before proceeding. Read in order:

1. `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session. If this file does not exist, read `CLAUDE.md` for product context instead.
2. `user-profile.md` (`~/.claude/memory/`) — calibrate communication register
3. Design system context: `.claude/skills/design-system/SKILL.md` if it exists — load token vocabulary and component library
4. Prototype artifacts: look for prototype files, wireframes, or mockups for this feature
5. Prior spec artifacts: check for any existing specs that this handoff should extend or supersede
6. Prior test findings: load the `/prototype` output for this feature if it exists — the test question, findings, and routing decision inform the completeness work

Report what was found. Flag missing artifacts:
- If no prototype exists: "No prototype artifacts found. `/prototype` should run before `/handoff`."
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

If the audits surface no undesigned states or flows, state "Completeness audits clean (`gaps-join`)" as a status line and proceed directly to Steps 2A + 2B — no pause.

> **⏸ PAUSE (skipped in --auto) — Gap closure.** *(`gaps` node — decides: gap-closure-or-scope; fires only when gaps exist)*
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

## Step 2.5 — Reduction (`critic` node)

Before the package is specified, the Critic pressure-tests it: which enumerated states are not earned (a state that cannot occur in practice is inventory bloat), which flows duplicate one another, which UAT scenarios test the same thing twice? Remove what is not earned, with a one-sentence rationale per removal. A handoff package accumulates by default; this is the reduction function. Preserve disagreement — if an auditor's inclusion argument stands against the removal, record it as a dissent rather than silently keeping or cutting.

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

## Step 3.5 — Accessibility, slop gate, and sign-off gates

1. **Accessibility (`accessibility` node):** the accessibility agent verifies the spec's accessibility section — VoiceOver labels, traits, reading order for every interactive element — and the UAT accessibility scenarios. Findings are spec revisions, not notes.
2. **Slop gate (`slop` node):** run the seven markers of `/studio:studio-slop` against the package. Quote and fix anything that fires. One status line.
3. **CD gate (`cd-gate` node):** the `cd` agent confirms all states are designed and specified, the spec requires no engineering judgment, and no known gap is an undeferred blocker.
4. **PM gate (`pm-gate` node):** the `pm` agent confirms UAT scenarios cover the brief's success conditions and the known gaps are acceptable for this release.

If both gates pass clean, proceed to Output — no pause. If either gate flags blockers (`signoff` node — decides: blocker-acceptance):

> **⏸ PAUSE (skipped in --auto) — Gate blockers.**
> [Name each blocker, which gate flagged it, and what resolving vs. deferring it means.]
> Resolve, defer with a date, or accept each blocker explicitly.

---

## Output

Render the artifact as HTML using the kit template.

1. Load `artifacts/templates/state-inventory.html` as the structural shell.
2. Populate the artifact-specific fields: state inventory (all states — designed / undesigned / intentionally omitted), flow inventory, synthetic data, UAT scenarios (Given / When / Then / Pass if / Fail if), build spec, known gaps, sign-off status.
3. Write to `design/handoff_<slug>.html` where slug is derived from the feature or component name (lowercase kebab-case, max 40 chars).
4. Surface a short markdown summary in conversation:
   - File path
   - One-sentence headline
   - State count, flow count, any known gaps flagged
5. Offer: "Run `/studio:annotate <file-path>` to attach the feedback harness."

If `--text` is in $ARGUMENTS, skip HTML emission and present the markdown summary as the full output.
