---
description: Run the full Studio OS design workflow for a problem or feature. Activates Philosophy → Historian → Strategist → Architect → Critic → Designer → Heurist → Accessibility → Specifier in sequence. Use when designing new features, interaction models, or resolving design problems.
argument-hint: "<problem or feature to design>"
---

Run the full Studio OS design workflow for a problem or feature.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for context loading · [SONNET] for design work

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Embedded Studio OS Context

### Ethos
Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.
Clarity over originality · Coherence over expression · Restraint over flourish.

### Brand Principles
Load from `project-context.md`. If not available, ask the user to state 3–5 principles before continuing.

### Decision Hierarchy
Evaluate decisions in this order:
1. Structural correctness
2. Conceptual clarity
3. System coherence
4. Reduction of parts
5. Craft precision
6. Visual refinement

Novelty is never a deciding factor.

### System Invariants
Load from `project-context.md`. If not available, ask the user to state the non-negotiable constraints before continuing.

### System Model
Load from `project-context.md`. If not available, ask the user to describe the core data model and key entities before continuing.

### Disciplines
**Historian:** What similar systems existed? What patterns endured? What mistakes to avoid?
**Strategist:** Does this strengthen the clarity instrument? Does it improve long-term value?
**Architect:** Data model, system boundaries, scalability, integration points.
**Critic:** Remove unnecessary features, simplify flows, eliminate decoration.
**Designer:** Interaction model (states + transitions), visual hierarchy, 2–3 options max.
**Accessibility:** WCAG AA contrast, 44pt touch targets, screen reader labels.

---

## Context

Problem: $ARGUMENTS

---

## [HAIKU] Steps 1–3 — Context loading

### Step 1 — Philosophy validation

Apply the embedded ethos, brand principles, and decision hierarchy above.

Apply the calibration gate: Is this necessary? Is this the simplest correct solution? Would removing something improve it?

If the problem statement fails the gate, say so and stop.

Also check the project's decision log (path defined in `project-context.md`). If available, scan for prior decisions that constrain this problem. Do not repeat rejected approaches.

### Step 2 — Historian

Apply the Historian discipline (embedded above).

Answer:
- What similar systems existed?
- What patterns endured?
- What mistakes must be avoided?

### Step 3 — Note constraints

State any prior decisions from the ledger (if available) that constrain this problem. Do not repeat rejected approaches.

---

> **⏸ PAUSE — Model switch required.**
> Steps 1–3 complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Steps 4–9 — Design work

### Step 4 — Strategist

Apply the Strategist discipline (embedded above).

Answer:
- Does this strengthen the product's core purpose as defined in project-context.md?
- Does it improve long-term value for users?

If the answer to either is no, state why and reduce scope before continuing.

### Step 4.5 — Marketer (if `--commercial` in arguments)

If the arguments include `--commercial`, apply the Marketer discipline.

- Does this differentiate the product or close a table-stakes gap?
- Does it serve the users who pay?
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

### Step 7.5 — Design sub-team (conditional, parallel)

Skip entirely if the outcome is a data model or system change with no new surface work.

First, determine which disciplines apply to this surface. Then run in two phases:

**Phase A — outer background agent** (if any Phase A disciplines apply):

First determine which disciplines apply: Typesetter (new text elements or typographic level), Choreographer (state transitions involving motion), Materialist (new depth, elevation, shadows, or surface finish). If none apply, skip Phase A entirely and proceed to Phase B.

Spawn ONE outer background agent with `run_in_background: true`. The outer agent spawns all applicable inner discipline agents simultaneously, waits for all to complete, and returns compiled Phase A output. You receive one notification when Phase A is complete.

Outer agent description: `"Design sub-team Phase A — [surface name]"`
Outer agent prompt: Include the Designer's relevant outputs, then spawn all applicable inner agents in a SINGLE Agent tool call message with run_in_background: true. Compile all outputs and return.

Inner agents to spawn (include only those that apply):

- Typesetter — Description: "Typesetter — [surface name]". Give it the Designer's visual hierarchy output. Task: produce a type system specification — scale, roles, string length constraints.

- Choreographer — Description: "Choreographer — [surface name]". Give it the Designer's transition descriptions. Task: apply the motion test (what does the user misunderstand without this?), remove what fails, specify what remains with timing and easing.

- Materialist — Description: "Materialist — [surface name]". Give it the Designer's surface description. Task: evaluate whether material choices are intentional and coherent.

When Phase A outer agent completes, proceed to Phase B.

**Phase B — run sequentially after Phase A:**

- **Writer** — if the surface introduces new copy: labels, empty states, system messages, instructions, paywall text, or VoiceOver strings. Run Writer after Typesetter completes — pass Typesetter's string length constraints into the Writer prompt. If Typesetter did not run, Writer may spawn immediately alongside Phase A.

- **Visual Designer** — always runs last, after all Phase A and Phase B agents complete. Evaluate spacing, proportion, alignment, and visual weight distribution across the full surface using all sub-team outputs. Prescribe specific corrections. Skip only if zero sub-team disciplines were invoked.

### Step 7.7 — Heurist (conditional)

Run if the surface involves user interaction. Skip for data model or system-only changes with no new surface work.

Evaluate the interaction model produced by the Designer (and refined by the sub-team) for:
- Broken mental models — does this behave the way the user expects?
- Invisible friction — what will users attempt that the design does not support?
- Gesture dead-ends — are there states users can reach but not exit?
- AI behavior concerns (if applicable) — does any AI-driven element erode trust or attribution?

Findings at this step may require returning to the Designer. If so, state precisely what must change before proceeding to Accessibility.

---

> **⏸ PAUSE — Prototype required.**
> Design is complete. Before accessibility review or specifier output:
>
> 1. Build a prototype in your team's design tool (Figma, your canvas project, or equivalent).
> 2. Verify the design renders correctly across relevant states and appearance modes.
> 3. If the design needs adjustment, iterate in the prototype. Do not write to production files.
>
> **Do not write production code until the prototype is confirmed.**
>
> Reply **"prototype confirmed"** when ready to proceed to Accessibility + Specifier.

---

### Step 8 — Accessibility

Apply the Accessibility discipline (embedded above).

Verify:
- WCAG AA contrast
- 44pt minimum touch targets
- Screen reader labeling (use Writer output for VoiceOver strings if Writer ran)

### Step 9 — Specifier

If this design will proceed to engineering, produce a complete engineering handoff specification:
- All component states (default + every variant)
- Dimensions and spacing using design token names, not raw values
- Typography using token names
- Color tokens with dark mode variants
- Motion/transition parameters (from Choreographer output if applicable)
- Accessibility: VoiceOver labels, traits, reading order

If this is exploratory design only (no immediate engineering handoff), skip this step but note explicitly: "Specifier not run — spec required before studio-implement."

---

## Output

Present the design artifact in the response using this structure:

```
# Design: [Problem Name]
Date: [today]

## Decision
[One sentence: what was decided]

## Structure
[Data model or system changes]

## Interaction model
[States, transitions, gestures]

## Design sub-team notes
[Typesetter / Choreographer / Writer / Materialist / Visual Designer outputs — omit if none ran]

## What was removed
[List with rationale]

## Open questions
[Only genuine blockers — omit if none]
```

If the project has a design artifacts directory (defined in `project-context.md`), offer to write the design artifact there.
