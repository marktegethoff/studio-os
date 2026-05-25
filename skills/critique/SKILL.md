---
description: Run the review workflow for an implementation or artifact. Checks philosophy, runs Critic and Heurist, verifies invariants, accessibility, and ledger conflicts. Produces a SHIP / REVISE / REJECT verdict. For design artifacts, prefer the creative-director agent instead.
argument-hint: "<artifact or implementation to review>"
---

Run the review workflow for an implementation or artifact.

Arguments: $ARGUMENTS

**Model requirements:** [SONNET] for critique · [HAIKU] for checklist verification · [SONNET] for verdict

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Project Context

Read project context in this order:

1. Read `studio_os/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `studio_os/ledger/decisions/` by name. Do not scan the full directory.
3. If `studio_os/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. This skill provides the discipline.

### Calibration Gate
1. Is this necessary?
2. Is this the simplest correct solution?
3. Would removing something improve it?
4. Is this consistent with everything else?

---

## Context

Artifact: $ARGUMENTS

---

## [SONNET] Steps 1–2 — Critique

### Step 1 — Philosophy check

Apply the project ethos, brand principles, decision hierarchy, and calibration gate from project context loaded above.

State whether each gate passes. If any fails, identify specifically what fails and why.

### Step 2 — Critic

Apply the Critic discipline: for each element, ask whether it is necessary, in its simplest correct form, and whether it adds complexity without value.

List everything that should be removed or simplified.

### Step 2.5 — Heurist (conditional)

Run if the artifact includes an interactive surface. Skip for data models, service layer, or non-interactive changes.

Evaluate:
- Broken mental models — does this behave the way the user expects?
- Invisible friction — what will users attempt that the design does not support?
- Gesture dead-ends — are there states users can reach but not exit?
- AI behavior concerns (if applicable) — does any AI-driven element erode trust or attribution?

Flag violations with severity (P0–P3). P0 findings block ship.

---

> **⏸ PAUSE — Model switch required.**
> Steps 1–2.5 complete. Switch to **[HAIKU]** (`claude-haiku-4-5-20251001`) before continuing.
> Reply **"continue"** when ready.

---

## [HAIKU] Steps 3–6 — Verification

### Step 3 — Invariant verification

Apply the system invariants from project context loaded above. Verify each is satisfied. Flag any violation precisely — which invariant, where, what the consequence is.

### Step 4 — Accessibility

Verify:
- WCAG AA contrast on all text (4.5:1 body, 3:1 UI elements)
- 44pt minimum touch targets on all interactive elements
- Screen reader labels present on all interactive elements

### Step 5 — Ledger check

If `studio_os/ledger/decisions/` exists, load relevant decision files by name based on what the artifact touches. Do not scan the full directory. Confirm the artifact does not contradict any prior decision. Flag conflicts — do not silently accept them. If no ledger exists, skip this step.

---

### Step 6 — Commercial check

Apply the Marketer discipline: commercial viability.

- Does this serve users who pay, or a segment that doesn't?
- Is the effort proportionate to the commercial return?
- Does it strengthen or weaken the product's market position?

State a commercial verdict. If the artifact passes philosophy but fails commercially — or vice versa — name the conflict explicitly. The tension is information, not a blocker.

---

> **⏸ PAUSE — Model switch required.**
> Steps 3–6 complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Output — Verdict

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
[None / list conflicts with ledger entries]

## Commercial
[PASS / FAIL — one sentence]

## Overall verdict
[SHIP / REVISE / REJECT]
[One sentence rationale]
```

Report findings only. Do not make changes unless explicitly asked after the report.

For design artifacts (mockups, interaction models, visual work), prefer the `creative-director` agent instead — it applies master-level taste judgment in addition to structural review, and silently draws on the full specialist team: Choreographer, Typesetter, Visual Designer, Writer, Materialist, Mark Maker, Prototyper, and Heurist.
