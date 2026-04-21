---
description: Run the XD OS review workflow for an implementation or artifact. Checks philosophy, runs Critic and Heurist, verifies invariants, accessibility, and decision conflicts. Produces a SHIP / REVISE / REJECT verdict. For design artifacts, prefer design-director instead.
argument-hint: "<artifact or implementation to review>"
---

Run the XD OS review workflow for an implementation or artifact.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Artifact: $ARGUMENTS

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — Ethos, Brand Principles, Decision Hierarchy, System Invariants
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, proceed with the embedded XD OS ethos only.

---

## XD OS Ethos (applied throughout)

Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.
Clarity over originality · Coherence over expression · Restraint over flourish.

Decision hierarchy: Structural correctness → Conceptual clarity → System coherence → Reduction of parts → Craft precision → Visual refinement. Novelty is never a factor.

Calibration gate:
1. Is this necessary?
2. Is this the simplest correct solution?
3. Would removing something improve it?
4. Is this consistent with everything else?

---

## Steps 1–2 — Critique

### Step 1 — Philosophy check

Apply the ethos, brand principles, decision hierarchy, and calibration gate loaded from project-context.md.

State whether each gate passes. If any fails, identify specifically what fails and why.

### Step 2 — Critic (xd-critic)

Apply the Critic discipline: for each element, ask whether it is necessary, in its simplest correct form, and whether it adds complexity without value.

List everything that should be removed or simplified.

### Step 2.5 — Heurist (xd-heurist, conditional)

Run if the artifact includes an interactive surface. Skip for data models, service layer, or non-interactive changes.

Evaluate:
- Broken mental models — does this behave the way the user expects?
- Invisible friction — what will users attempt that the design does not support?
- Gesture dead-ends — are there states users can reach but not exit?
- AI behavior concerns (if applicable) — does any AI-driven element erode trust or attribution?

Flag violations with severity (P0–P3). P0 findings block ship.

## Steps 3–6 — Verification

### Step 3 — Invariant verification

Apply the system invariants loaded from project-context.md. Verify each is satisfied. Flag any violation precisely — which invariant, where, what the consequence is.

### Step 4 — Accessibility

Verify:
- WCAG AA contrast on all text (4.5:1 body, 3:1 UI elements)
- 44pt minimum touch targets on all interactive elements
- Screen reader labels present on all interactive elements

### Step 5 — Decision log check

If the project's decision log path is defined in project-context.md, scan it for relevant decisions. Confirm the artifact does not contradict any prior decision. Flag conflicts — do not silently accept them.

If no decision log is defined, skip this step.

---

### Step 6 — Commercial check (marketer)

Apply the Marketer discipline: commercial viability.

- Does this serve users who pay, or a segment that doesn't?
- Is the effort proportionate to the commercial return?
- Does it strengthen or weaken the product's market position?

State a commercial verdict. If the artifact passes philosophy but fails commercially — or vice versa — name the conflict explicitly. The tension is information, not a blocker.

## Output — Verdict

```
# Review: [Artifact Name]
Date: [today]

## Philosophy verdict
[PASS / FAIL — one sentence]

## Removals recommended
[List — or "None"]

## Usability
[PASS / list violations with severity (P0–P3) — or "Not applicable (non-interactive)"]

## Invariant status
[All hold / list violations]

## Accessibility
[PASS / list issues]

## Decision conflicts
[None / list conflicts]

## Commercial
[PASS / FAIL — one sentence]

## Overall verdict
[SHIP / REVISE / REJECT]
[One sentence rationale]
```

Report findings only. Do not make changes unless explicitly asked after the report.

For design artifacts (mockups, interaction models, visual work), prefer `design-director` instead — it applies master-level taste judgment in addition to structural review, and silently draws on the full specialist team: Choreographer, Typesetter, Visual Designer, Writer, Materialist, Mark Maker, Prototyper, and xd-heurist.
