---
description: Find the essential, categorically right solution to a hard problem. Runs a convergence loop (max 3 iterations) through Historian → Design → Critic → Design Director → Calibration Gate until the solution is inevitable. Use when previous attempts haven't converged or the problem has no obvious right answer.
argument-hint: "<hard problem to solve>"
---

Find the essential, categorically right solution to a hard problem.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Problem: $ARGUMENTS

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — Ethos, Decision Hierarchy, System Invariants, Decision Log path
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, proceed with the embedded XD OS context only, and ask: "What are the system invariants for this problem?"

---

## XD OS Context (applied throughout)

**Ethos:** Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.
Clarity over originality · Coherence over expression · Restraint over flourish.

**Decision hierarchy:** Structural correctness → Conceptual clarity → System coherence → Reduction of parts → Craft precision → Visual refinement. Novelty is never a deciding factor.

**Calibration gate** — all five must be YES to exit:
1. Is this necessary?
2. Is this coherent?
3. Is this the simplest correct solution?
4. Would removing something improve it?
5. Is this consistent with everything else in the system?

---

## What this command does

This is a convergence loop, not a single design pass.

Each iteration applies the studio disciplines, evaluates the output against the calibration gate, and either exits with an inevitable solution or identifies exactly what is still wrong and re-enters with that diagnosis as the constraint.

The loop exits when nothing can be removed, clarified, aligned further, or simplified. Not when a solution is acceptable — when it is **inevitable**.

Maximum iterations: 3. If the gate does not pass by iteration 3, the command reports honestly: what remains unresolved, why, and what would need to change for it to pass.

---

## Step 0 — PM brief check

If this is a product direction problem — what to build, who to build for, or what outcome to target — check for a validated PM brief before the loop begins.

Look for `artifacts/product_brief_*.md` or equivalent in the project. If one exists for this problem, load it. A validated brief constrains the solution space and makes the convergence loop more precise.

If no brief exists and this is a product direction problem, surface it:

> **Product brief missing.** You are about to run a convergence loop against an unvalidated problem. Consider running `pm` first to define who has the problem, why it matters, and what success looks like. To proceed without a brief, confirm explicitly.

If this is a structural, architectural, or systems problem — not a customer or product direction problem — skip this step and proceed.

---

## Before iteration 1 — Context loading

**Check prior work.**
If the project's decision log path is defined in project-context.md, scan it. Has this problem been solved before? If yes, what was the prior decision and why? Do not repeat work already done.

**Frame the problem precisely.**
State the problem in one sentence. If it cannot be stated in one sentence, it is not ready for solving — decompose it first. Name the tension: what two valid things are in conflict, and why resolving one makes the other harder?

**State the constraints.**
List every constraint that applies: system invariants loaded from project-context.md, prior decisions (if available), design laws. These are not negotiable during the loop. If a constraint needs to be challenged, surface it explicitly before the loop begins.

## Iteration structure

Each iteration follows this sequence, then pauses for Design Director (xd-design-director) judgment.

### 1. Historian pass (xd-historian)
What has been tried before on this class of problem? What survived? What failed and why?
Do not invent precedent. Do not generalize. Cite specific examples.

This pass runs once — in iteration 1 only. Do not repeat the Historian pass in iterations 2 and 3.

### 2. Design pass (xd-architect + xd-designer)
Apply the Architect and Designer disciplines.
Produce the simplest structure that satisfies the stated constraints.
Maximum 2 directions. Recommend one. State why.

If the solution involves a surface (interaction model, visual hierarchy, motion, or copy): after the structural design, apply the relevant craft disciplines inline:
- Choreographer: motion for any defined transitions — timing token, easing, spring, reduce-motion alternative
- Writer: copy for all surface states (active, empty, error, disabled)
- Visual Designer: token assignments for the surface — color, spacing, typography

Apply only those the solution requires. Do not invoke all three by default. A structural decision that has no surface does not need craft disciplines.

### 3. Critic pass (xd-critic) — escalating by iteration

**Iteration 1:** Remove everything unnecessary. What is left?
**Iteration 2:** Of what remains, what is still not the simplest correct form? Remove again.
**Iteration 3:** Of what remains after two reductions — is every element inevitable? If anything could be different without loss, it is not yet right.

The critic's standard escalates each iteration. By iteration 3, the question is not "is this good?" It is: "would removing or changing anything make this worse?"

### 3.5 — Marketer check (marketer)

Apply the Marketer discipline: commercial pressure test.

- Does this solution create something users will find, choose, and pay for?
- Does it differentiate the product or close a table-stakes gap that matters to the market?
- Is the complexity it introduces proportionate to the commercial return?

This is not a veto — the loop continues regardless. But if the solution fails commercially, name it explicitly. The Design Director's verdict must account for both dimensions.

### 4. Design Director evaluation (xd-design-director)

Apply the ethos and decision hierarchy from project-context.md (or embedded above).

State a verdict: INEVITABLE / NOT YET / STRUCTURALLY WRONG.

- **INEVITABLE:** nothing can be removed, clarified, aligned further, or simplified. Exit the loop.
- **NOT YET:** something remains that is not in its essential form. Name it precisely. State what is wrong and what would make it right. Re-enter the loop.
- **STRUCTURALLY WRONG:** the current direction cannot converge. The problem framing or a constraint is incorrect. Stop. Reframe before continuing.

### 5. Calibration gate

Answer each question explicitly (YES / NO). All five must pass. Any failure: identify which failed, why, and what must change.

---

## Between iterations

If the gate does not pass and iterations remain, state explicitly before re-entering:
- What the previous iteration produced
- What was wrong with it (one sentence per flaw)
- What the next iteration is trying to resolve
- What constraints were tightened

Do not carry forward elements that failed the gate. Each iteration should be a reduction of the prior, not a variation.

---

## Exit: Inevitable Solution

When the calibration gate passes:

```
## Solution: [Problem Name]
Date: [today]
Iterations: [N]

### The essential form
[State the solution. Nothing more than what is necessary to implement it.]

### Why this and not the alternatives
[One sentence per alternative considered and rejected. Name what was wrong.]

### What this constrains going forward
[What future decisions does this close off? What does this require?]

### Decision log entry required
[Yes/No — does this decision need to be recorded?]
```

If a decision log entry is required and the path is defined in project-context.md, write it before ending the session.

---

## Exit: Unresolved at iteration 3

```
## Unresolved: [Problem Name]
Date: [today]

### What was reached
[The best form found, even if not yet inevitable]

### What remains wrong
[Exactly what is still not in essential form, and why]

### What would need to change
[The specific condition that would allow this to resolve]

### Recommendation
[Defer / Escalate / Reframe — with one sentence rationale]
```

Do not declare a solution when one has not been found. An honest unresolved report is more valuable than a false inevitable.
