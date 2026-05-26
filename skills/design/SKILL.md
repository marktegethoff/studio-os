---
description: Run the full design workflow for a problem or feature. Activates Philosophy → Historian → Strategist → Architect → Critic → Designer → Heurist → Accessibility → Specifier in sequence. Use when designing new features, interaction models, or resolving design problems.
argument-hint: "<problem or feature to design>"
---

Run the full design workflow for a problem or feature.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for context loading · [SONNET] for design work

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

**Minimum team (the Six Functions — see CLAUDE.md).** A design artifact is never produced by fewer than the six required functions. This workflow covers five of them — framing/structure, generation, craft (Phase A), reduction, and usability/accessibility. The sixth, **the Gate (CD)**, is applied before ship via the `cd` agent or `/studio:review`. The **Designer owns the deliverable** (the interaction model); the other disciplines inform it.

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

## [HAIKU] Step 0 — Brief check

Before design begins: check for a validated product brief for this problem.

Look for a brief in these locations (in order):
1. `specs/product_brief_*.md` (the canonical brief location)
2. Any brief path specified in `CLAUDE.md`

If a matching brief exists, load it — the problem statement, success definition, and key unknowns it contains govern what the design must solve.

If no brief exists and this represents a new product direction (not a refinement of an existing shipped surface), surface this before continuing:

> **Product brief missing.** Design is most effective when the problem has been validated. Consider running `/shape` before this workflow to define who has the problem, why it matters, and what success looks like. To proceed without a brief, confirm explicitly.

If the user confirms to proceed, continue. Design against a clear problem statement from the arguments — but note the absence of a validated brief.

---

## [HAIKU] Steps 1–3 — Context loading

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

---

> **⏸ PAUSE — Model switch required.**
> Steps 1–3 complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Steps 4–9 — Design work

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

### Step 7.5 — Design sub-team (conditional, parallel)

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
> 1. Build a prototype in the project's prototype environment — the `canvas/` target under the manifest's `code_root` (per the paired-scaffold capability). For projects without a canvas, fall back to whatever the project's `CLAUDE.md` specifies.
> 2. Verify the design at key states — especially light and dark mode for native.
> 3. If the design needs adjustment, iterate in the prototype. Do not write to production source files.
>
> **Do not write to production source files until the prototype confirms the design.**
>
> Reply **"prototype confirmed"** when the prototype is verified and ready to proceed to Accessibility + Specifier.

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

If this is exploratory design only (no immediate engineering handoff), skip this step but note explicitly: "Specifier not run — spec required before /implement."

---

## Step 9.5 — Review offer (optional, pre-engineering gate)

If the Specifier ran and the design is ready for engineering handoff, offer an LT review as a final gate.

Ask:

> "**Run an LT review before engineering begins?** PM + Design Director review the spec for problem-solution fit and design quality. Use for significant new surfaces or direction changes.
>
> Reply **'review'** to run it, **'skip'** to proceed to output."

**If user replies 'review':**

Read the `review` skill at `~/.claude/skills/review/SKILL.md` and follow its steps from Step 1, passing the design artifact (interaction model + spec) as context. DE does not apply — no implementation exists yet. After the review completes, return here and proceed to Output.

**If user replies 'skip'** (or the Specifier was skipped): proceed to Output.

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

If `specs/` exists, offer to write this to `specs/design.md`. Otherwise write to `docs/design/` or the project's artifact location specified in `CLAUDE.md`.
