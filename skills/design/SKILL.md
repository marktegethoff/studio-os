---
description: "Full design workflow — brief through interaction model. Produces wireframes, state inventory, and a validated interaction model."
argument-hint: "<problem or feature to design>"
artifacts: [design-brief, state-inventory, component-spec]
---

Run the full design workflow for a problem or feature.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

Auto-mode defaults for the surviving human nodes:

- `direction` node: adopt the Designer's recommended option; state this in the "Auto-mode decisions" section.
- `proto-gate` node: build and verify the prototype on the auto branch; never write production source files in the same run.

**Minimum team (the Six Functions — see CLAUDE.md).** A design artifact is never produced by fewer than the six required functions. This workflow's graph covers all six — framing/structure, generation, craft (Phase A), reduction, usability/accessibility, and **the Gate (CD)** as the `ship` node, applied via the `cd` agent or `/studio:review` before emission. The **Designer owns the deliverable** (the interaction model); the other disciplines inform it.

## Graph

This skill's topology. The prose steps below are the executable instructions; this block is the contract they must match (see `memory/orchestration.md`). Where the Workflow tool is available, execute segments via `workflow.js`; the graph is the contract either way.

```graph
skill: design
cost: high — one blind fan-out of up to 3 craft agents plus conditional writer; full nine-discipline pass
nodes:
  brief          gate:product-brief-exists
  phase          router(exploratory|in-progress|refinement)
  philosophy     gate:philosophy-and-calibration
  historian      agent:historian
  constraints    task:note constraints from the decision ledger
  strategist     agent:strategist
  marketer       agent:marketer
  architect      agent:architect
  critic         agent:critic
  designer       agent:designer owner:interaction-model
  direction      human decides:direction
  typesetter     agent:typesetter
  choreographer  agent:choreographer
  materialist    agent:materialist
  writer         agent:writer
  visual         agent:visual-designer join
  heurist        agent:heurist
  proto-gate     human decides:prototype-before-production-writes
  accessibility  agent:accessibility
  specifier      agent:specifier owner:spec
  slop           gate:slop — seven markers of /studio:studio-slop
  ship           gate:cd — via the cd agent or /studio:review
  emit           task:render phase-appropriate HTML
edges:
  brief -> phase -> philosophy -> historian -> constraints -> strategist
  strategist -> marketer   if:commercial
  strategist -> architect
  marketer -> architect
  architect -> critic -> designer -> direction
  direction -> {typesetter, choreographer, materialist}   if:surface-work
  typesetter -> writer   if:new-copy
  {typesetter, choreographer, materialist} -> visual
  writer -> visual
  visual -> heurist
  heurist -> designer   loop max:1
  heurist -> proto-gate
  proto-gate -> accessibility -> specifier -> slop -> ship -> emit
  phase -> critic   if:refinement
  heurist -> emit   if:exploratory
```

The Phase A fan-out is **blind**: typesetter, choreographer, and materialist never see each other's unfinished output. The writer joins `visual` by its own edge (its input dependency on the typesetter is the `typesetter -> writer` conditional, not group membership). The heurist may return work to the designer at most once (`loop max:1`). Dissent surfaced by any discipline travels to the `ship` gate — never averaged away (see Consensus Laundering, `memory/anti-patterns.md`).

---

## Project Context

Read project context at session start, in order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from the project's decision ledger by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. This skill provides the discipline. If no project context is found, proceed with general design principles and state this clearly.

---

## Disciplines

**Historian:** What similar systems existed? What patterns endured? What mistakes to avoid?
**Strategist:** Does this strengthen the product's core value? Does it improve long-term user value?
**Architect:** Data model, system boundaries, scalability, integration points.
**Critic:** Remove unnecessary features, simplify flows, eliminate decoration.
**Designer:** Interaction model (states + transitions), visual hierarchy, 2–3 options max.
**Accessibility:** WCAG AA contrast, 44pt touch targets, screen reader labels.

---

## Context

Problem: $ARGUMENTS

---

## Step 0 — Brief check

Before design begins: check for a validated product brief for this problem.

Look for a brief in these locations (in order):
1. `specs/product_brief_*.md` (the canonical brief location)
2. Any brief path specified in `CLAUDE.md`

If a matching brief exists, load it — the problem statement, success definition, and key unknowns it contains govern what the design must solve.

If no brief exists and this represents a new product direction (not a refinement of an existing shipped surface), surface this before continuing:

> **Product brief missing.** Design is most effective when the problem has been validated. Consider running `/shape` before this workflow to define who has the problem, why it matters, and what success looks like. To proceed without a brief, confirm explicitly.

If the user confirms to proceed, continue. Design against a clear problem statement from the arguments — but note the absence of a validated brief.

---

## Step 0.5 — Phase determination

Determine the design phase — this governs which steps run and at what depth:

- **Exploratory** — output is a direction, not a finished design. Runs Philosophy → Historian → Strategist → Architect → Designer (with options) → Critic. Heurist runs lightly. Sub-team (Phase A/B), Accessibility, and Specifier are deferred. The goal is to converge on a direction worth designing in full.
- **In progress** *(default)* — full nine-step pass. Every discipline runs at design standard. This is what the skill does when no phase is specified.
- **Refinement** — design exists; refine specific aspects. Skip Philosophy / Historian / Strategist / Architect (assumed done). Start at Critic or Designer (state which). Run sub-team and Heurist on the refined surface. Accessibility and Specifier at production weight.

If the phase is not stated in the arguments and not clear from context, ask before proceeding. Default is **in progress**.

State the phase before proceeding to Step 1. Apply phase gates at the major step boundaries below.

---

## Steps 1–3 — Context loading

**Phase gate:** If phase is **refinement**, skip to Step 6 (Critic) or Step 7 (Designer) — state which, and which prior outputs you are building on. Philosophy/Historian/Strategist/Architect are assumed complete.

### Step 1 — Philosophy validation

Apply the project context loaded above (ethos, principles, decision hierarchy, invariants).

Apply the calibration gate: Is this necessary? Is this the simplest correct solution? Would removing something improve it?

If the problem statement fails the gate, say so and stop.

Also check: load relevant decision files from `decisions/` by name based on what constrains this problem. Do not scan the full directory. Do not repeat previously rejected approaches.

### Step 2 — Historian

Apply the Historian discipline (embedded above).

Answer:
- What similar systems existed?
- What patterns endured?
- What mistakes must be avoided?

### Step 3 — Note constraints

State any prior decisions from the ledger (if available) that constrain this problem. Do not repeat rejected approaches.

State "Context loaded (`philosophy` → `constraints` nodes complete)" as a status line and proceed — no pause. Context loading is a report, not a decision.

---

## Steps 4–9 — Design work

### Step 4 — Strategist

Apply the Strategist discipline (embedded above).

Answer:
- Does this strengthen the product's core value?
- Does it improve long-term user value?

If the answer to either is no, state why and reduce scope before continuing.

### Step 4.5 — Marketer (if `--commercial` in arguments)

If the arguments include `--commercial`, apply the Marketer discipline.

- Does this differentiate the product or close a table-stakes gap?
- Does it serve paying users or improve conversion?
- Is this an acquisition or retention feature — and is that the right priority right now?
- Is the commercial timing right?

State the commercial position in 3–4 sentences. If it conflicts with the Strategist's verdict, name the tension — do not resolve it silently. Continue to Step 5 regardless; commercial concerns are input to the Architect, not a hard gate.

---

### Step 5 — Architect

Apply the Architect discipline (embedded above).

Define:
- Data model changes (if any)
- System boundaries
- Integration points

### Step 6 — Critic

Apply the Critic discipline (embedded above).

Remove:
- Unnecessary features
- Redundant flows
- Decorative elements

State what was removed and why.

### Step 7 — Designer

Apply the Designer discipline (embedded above).

Produce:
- Interaction model (states and transitions)
- Visual hierarchy
- No more than 3 layout options; recommend one

Apply the decision hierarchy to resolve trade-offs. Novelty is never a factor.

---

> **⏸ PAUSE (skipped in --auto) — Direction.** *(`direction` node — decides: direction)*
> [Present the 2–3 options with the recommendation and its one-sentence rationale. This is the taste decision only the human can make; craft investment follows the choice.]
> Pick an option, or reply **"recommended"** to take the recommendation.

---

### Step 7.5 — Design sub-team (conditional, parallel)

**Phase gate:** If phase is **exploratory**, skip the sub-team entirely. Craft refinement is premature when the direction itself is still being established. Note this in the output and proceed to Step 7.7 (Heurist, light pass).

Skip entirely if the outcome is a data model or system change with no new surface work.

First, determine which disciplines apply to this surface. Then run in two phases:

**Phase A — outer background agent** (if any Phase A disciplines apply):

First determine which disciplines apply: Typesetter (new text elements or typographic level), Choreographer (state transitions involving motion), Materialist (new depth, elevation, shadows, or surface finish). If none apply, skip Phase A entirely and proceed to Phase B.

Spawn ONE outer background agent with `run_in_background: true`. The outer agent spawns all applicable inner discipline agents simultaneously, waits for all to complete, and returns compiled Phase A output. You receive one notification when Phase A is complete.

Outer agent description: `"Design sub-team Phase A — [surface name]"`
Outer agent prompt: Include the Designer's relevant outputs, then spawn all applicable inner agents in a SINGLE Agent tool call message with run_in_background: true. Compile all outputs and return.

Inner agents to spawn (include only those that apply):

- Typesetter — Description: "Typesetter — [surface name]". Prompt: Give it the Designer's visual hierarchy output. Task: produce a type system specification — scale, roles, string length constraints.

- Choreographer — Description: "Choreographer — [surface name]". Prompt: Give it the Designer's transition descriptions. Task: apply the motion test (what does the user misunderstand without this?), remove what fails, specify what remains with timing and easing.

- Materialist — Description: "Materialist — [surface name]". Prompt: Give it the Designer's surface description. Task: evaluate whether material choices are intentional and coherent.

When Phase A outer agent completes, proceed to Phase B.

**Phase B — run sequentially after Phase A:**

- **Writer** — if the surface introduces new copy: labels, empty states, system messages, instructions, paywall text, or VoiceOver strings. Run Writer after Typesetter completes — pass Typesetter's string length constraints into the Writer prompt. If Typesetter did not run, Writer may spawn immediately alongside Phase A.

- **Visual Designer** — always runs last, after all Phase A and Phase B agents complete (the `visual` join). Evaluate spacing, proportion, alignment, and visual weight distribution across the full surface using all sub-team outputs. Prescribe specific corrections. Skip only if zero sub-team disciplines were invoked.

The Phase A fan-out is **blind** — each craft agent is briefed from the Designer's outputs only, never from another sub-team member's unfinished work. The `visual` join waits for **all** spawned members; if one fails, report it by node id with the inputs it was given and note its discipline as missing — never silently synthesize around the hole (see Failure reporting, `memory/orchestration.md`).

### Step 7.7 — Heurist (conditional)

Run if the surface involves user interaction. Skip for data model or system-only changes with no new surface work.

**Phase gate:** If phase is **exploratory**, Heurist runs lightly — flag structural usability concerns (broken mental models, gesture dead-ends) only. Defer detailed friction analysis until the direction is committed.

Evaluate the interaction model produced by the Designer (and refined by the sub-team) for:
- Broken mental models — does this behave the way the user expects?
- Invisible friction — what will users attempt that the design does not support?
- Gesture dead-ends — are there states users can reach but not exit?
- AI behavior concerns (if applicable) — does any AI-driven element erode trust or attribution?

Findings at this step may require returning to the Designer — **at most once** (`heurist -> designer, loop max:1`). If so, state precisely what must change; after the Designer's revision, proceed regardless — remaining concerns travel to the `ship` gate as named dissents rather than looping again.

---

> **⏸ PAUSE (skipped in --auto) — Prototype required.**
>
> *If phase is **exploratory**:* skip the prototype gate, Accessibility, and Specifier. Proceed directly to Output. The artifact is a direction; prototype and spec come when the direction is committed and the work moves to **in progress**.
>
> *If phase is **in progress** or **refinement**:* design is complete. Before accessibility review or specifier output:
>
> 1. Build a prototype in the project's prototype environment — the `canvas/` target under the manifest's `code_root` (per the paired-scaffold capability). For projects without a canvas, fall back to whatever the project's `CLAUDE.md` specifies.
> 2. Verify the design at key states — especially light and dark mode for native.
> 3. If the design needs adjustment, iterate in the prototype. Do not write to production source files.
>
> **Do not write to production source files until the prototype confirms the design.**
>
> Reply **"prototype confirmed"** when the prototype is verified and ready to proceed to Accessibility + Specifier.

---

### Step 8 — Accessibility

**Phase gate:** If phase is **exploratory**, skip — Accessibility runs at production weight, not against directional sketches. Note: "Accessibility deferred — exploratory phase."

Apply the Accessibility discipline (embedded above).

Verify:
- WCAG AA contrast
- 44pt minimum touch targets
- Screen reader labeling (use Writer output for VoiceOver strings if Writer ran)

### Step 9 — Specifier

**Phase gate:** If phase is **exploratory**, skip — the artifact is a direction, not a spec. Note in output: "Specifier deferred — exploratory phase. Run /studio:design in **in progress** mode once direction is committed."

If this design will proceed to engineering, produce a complete engineering handoff specification:
- All component states (default + every variant)
- Dimensions and spacing using design token names, not raw values
- Typography using token names
- Color tokens with dark mode variants
- Motion/transition parameters (from Choreographer output if applicable)
- Accessibility: VoiceOver labels, traits, reading order

If this is exploratory design only (no immediate engineering handoff), skip this step but note explicitly: "Specifier not run — spec required before /implement."

---

## Step 9.2 — Slop gate (`slop` node)

Before emission, run the seven markers of `/studio:studio-slop` against the artifact content. Quote the evidence for any marker that fires and fix it before proceeding. The quality floor is a structural property of this graph, not an opt-in skill. State the result as one status line ("Slop gate: clean" or "Slop gate: N markers fired — fixed").

## Step 9.5 — Ship gate (`ship` node — the sixth function)

The design does not emit without the Gate. Two forms, scaled to the work:

- **Default:** invoke the `cd` agent on the finished artifact (interaction model + spec) for a SHIP / NO-SHIP verdict with named dissents from the run (heurist concerns, critic removals overruled, sub-team conflicts) presented to it. A NO-SHIP routes the named defects back to the owning discipline before emission.
- **Significant new surfaces or direction changes:** run the full `/studio:review` instead — read the `review` skill and follow its steps from Step 1, passing the design artifact as context. DE does not apply — no implementation exists yet. After the review completes, return here.

Record the verdict and the dissent ledger in the output. *(Exploratory phase: the ship gate is deferred with Accessibility and Specifier — a direction is not a shippable artifact.)*

---

## Output

Render the artifact as HTML using the kit template, chosen by phase.

**Exploratory phase** — template: `design-brief`:
1. Load `artifacts/templates/design-brief.html` as the structural shell.
2. Populate: direction decision, structure, interaction model, what was removed, deferred items, open questions.
3. Write to `specs/direction_<slug>.html` where slug is from the problem name (lowercase kebab-case, max 40 chars).

**In progress / Refinement phase** — templates: `state-inventory` (primary) + `component-spec` (if Specifier ran):
1. Load `artifacts/templates/state-inventory.html` as the structural shell.
2. Populate: all states and transitions, interaction model, sub-team craft notes (Typesetter / Choreographer / Writer / Materialist / Visual Designer — omit if none ran), what was removed, open questions.
3. If Specifier ran, also write `artifacts/templates/component-spec.html` to `design/<slug>-spec.html`.
4. Write to `design/<slug>.html` where slug is from the problem name.

For all phases:
4. Surface a short markdown summary in conversation:
   - File path(s)
   - One-sentence decision or direction
   - Key removals and open questions
5. Offer: "Run `/studio:annotate <file-path>` to attach the feedback harness."

If `--text` is in $ARGUMENTS, skip HTML emission and present the markdown summary as the full output.
