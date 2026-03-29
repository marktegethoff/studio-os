---
description: Run the full Studio OS design workflow for a problem or feature. Activates Context → Historian → Strategist → Architect → Critic → Designer → Choreographer → Writer → Visual Designer → Heurist → Accessibility → Specifier in sequence. Produces a complete engineering-ready spec. Use when designing new features, interaction models, or resolving design problems.
argument-hint: "<problem or feature to design>"
---

Run the full Studio OS design workflow for a problem or feature.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for context loading · [SONNET] for design work

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Problem: $ARGUMENTS

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — Brand Principles, System Invariants, System Model, Decision Hierarchy
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, ask: "No project context found. Run `studio-init` to set up Studio OS for this project, or describe the product purpose and invariants before continuing."

Also check the project's decision log (path defined in project-context.md). If available, scan for prior decisions that constrain this problem. Do not repeat rejected approaches.

---

## Studio OS Ethos (applied throughout)

Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.
Clarity over originality · Coherence over expression · Restraint over flourish.

Decision hierarchy: Structural correctness → Conceptual clarity → System coherence → Reduction of parts → Craft precision → Visual refinement. Novelty is never a factor.

---

## [HAIKU] Steps 1–3 — Context loading

### Step 1 — Philosophy validation

Apply the ethos, brand principles, and decision hierarchy loaded from project-context.md.

Apply the calibration gate: Is this necessary? Is this the simplest correct solution? Would removing something improve it?

If the problem statement fails the gate, say so and stop.

### Step 2 — Historian

Answer:
- What similar systems existed?
- What patterns endured?
- What mistakes must be avoided?

Cite specific precedent. Do not generalize.

### Step 3 — Note constraints

State any prior decisions from the decision log (if available) that constrain this problem. Do not repeat rejected approaches.

---

> **⏸ PAUSE — Model switch required.**
> Steps 1–3 complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Steps 4–13 — Design work

### Step 4 — Strategist

Answer:
- Does this strengthen the product as defined in project-context.md?
- Does it improve long-term value for the user?

If the answer to either is no, state why and reduce scope before continuing.

### Step 4.5 — Marketer (if `--commercial` in arguments)

If the arguments include `--commercial`, apply the Marketer discipline.

- Does this differentiate the product or close a table-stakes gap that matters to the market?
- Does it serve the users who pay?
- Is this an acquisition or retention feature — and is that the right priority right now?
- Is the commercial timing right?

State the commercial position in 3–4 sentences. If it conflicts with the Strategist's verdict, name the tension — do not resolve it silently. Continue to Step 5 regardless; commercial concerns are input to the Architect, not a hard gate.

---

### Step 5 — Architect

Define:
- Data model changes (if any)
- System boundaries
- Integration points

Flag any violation of system invariants loaded from project-context.md. Do not proceed past a violation.

### Step 6 — Critic

Remove:
- Unnecessary features
- Redundant flows
- Decorative elements

State what was removed and why.

### Step 7 — Designer

Produce:
- Interaction model (states and transitions)
- Visual hierarchy
- No more than 3 layout options; recommend one

Apply the decision hierarchy to resolve trade-offs. Novelty is never a factor.

### Step 8 — Choreographer

For each transition defined in Step 7, evaluate whether motion is earned or should be removed. Specify timing (duration token), easing (curve), and spring values where applicable. State the reduce-motion alternative.

If Step 7 defined no transitions, skip this step and say so.

### Step 9 — Writer

Produce copy for every state this surface can be in:
- Active / default state labels
- Empty state message and action label (if any)
- Loading / pending state text (if any)
- Error state message
- Disabled state label (if applicable)

### Step 10 — Visual Designer

For the surface defined in Steps 5–7, specify:
- Color token assignments (which token for each element)
- Spacing token assignments (row heights, gaps, padding)
- Typography token assignments (register, size, weight for each text element)
- Surface token assignments (corner radius, stroke, opacity states)

Flag any value with no token: "No token for [value] — define or accept the debt."

### Step 11 — Heurist (conditional)

Run if the surface involves user interaction. Skip for data model or system-only changes with no new surface work.

Evaluate the interaction model produced by the Designer (and refined by Steps 8–10) for:
- Broken mental models — does this behave the way the user expects?
- Invisible friction — what will users attempt that the design does not support?
- Gesture dead-ends — are there states users can reach but not exit?
- AI behavior concerns (if applicable) — does any AI-driven element erode trust or attribution?

Findings at this step may require returning to the Designer. If so, state precisely what must change before proceeding to Step 12.

### Step 12 — Accessibility

Verify:
- WCAG AA contrast against Step 10 token assignments
- 44pt minimum touch targets on all interactive elements
- Screen reader labels for all interactive and informational elements (use Step 9 Writer output for VoiceOver strings)
- Reduce-motion alternative confirmed for any animation from Step 8

### Step 13 — Specifier

Produce the engineering handoff document:
- Every state named and described
- Every token named (no raw values)
- Every accessibility label written
- Every interaction parameter measured (duration, spring, threshold)
- Every gap flagged: "No token for [value]" or "No accessibility label specified for [element]"

A spec that leaves decisions to the engineer is not finished. If this is exploratory design only, skip but note: "Specifier not run — spec required before studio-implement."

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

## Motion
[Transition specs by token name — or "No motion: [reason]"]

## Copy
[All state copy — active, empty, loading, error, disabled]

## Token assignments
[Color, spacing, typography, surface tokens for each element]

## Accessibility
[Contrast results, touch targets, VoiceOver labels, reduce-motion notes]

## What was removed
[List with rationale]

## Open questions
[Only genuine blockers — omit if none]
```

If the project's decision log path is defined in project-context.md, offer to write this to the appropriate artifacts directory.
