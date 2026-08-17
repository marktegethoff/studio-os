---
description: "Codebase coherence pass. Identifies duplication, dead code, and naming drift; produces a simplification plan before touching code."
argument-hint: "<file, directory, or description of code area to simplify>"
---

Run the simplification workflow.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `decisions/` by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. You provide the discipline.

---

## Ethos
The simplest correct solution. Every abstraction earned. Every line load-bearing.
Remove first. The question is not "does this work?" — it is "does this need to exist?"

## Code Standard
- Three similar lines > premature helper
- No error handling for scenarios that cannot happen
- No abstractions for hypothetical future requirements
- Previews (or stack-equivalent: stories, fixtures) required on all view files
- Each change touches one behavior; verify before proceeding

---

## Subject

$ARGUMENTS

---

## Step 1 — Context Load

Read in order:
1. The spec file for this area, if one exists — check `specs/` or the spec path defined in CLAUDE.md. If none exists, note it — the simplification will proceed without a contract baseline.
2. `CLAUDE.md` — the gotchas section defines known patterns that must not be violated.
3. The files in scope (or the files in the named directory). Read before auditing.

State what was loaded and confirm the scope before proceeding.

---

State "Context loaded" as a status line and proceed — a report, not a decision (see human-node economics, `memory/orchestration.md`).

---

## Steps 2–5

Maximum iterations: 3. Loop exits when the Distinguished Engineer's Plan Review returns PROCEED.

---

### Step 2 — Code Audit

Scan the files in scope for the following five categories. For each finding, name the file, the specific code, and which category it falls into.

**Duplication** — patterns repeated vs. established conventions in nearby files or across the codebase. Not incidental similarity — structural duplication of logic that already exists somewhere and could be reused.

**Single-use abstractions** — helpers, protocols, or types defined for one caller only. These are premature extractions; the call site should inline them.

**Orphaned code** — functions, methods, computed properties, or files with no reachable callers. Code that was left behind after a refactor or never connected.

**Convention drift** — patterns that deviate from established conventions in `CLAUDE.md` gotchas, the project's established file patterns, or prior spec implementations. Inconsistency that will confuse a future agent or engineer.

**Scope creep** — code introduced beyond what any spec in `specs/` authorized. Features or behaviors not traceable to a decision.

Produce an audit report: one section per category, each finding specific and actionable.

---

### Step 3 — Critic Pass

Of the audit findings, determine what should actually be simplified vs. what must stay.

**Remove:** What is unambiguously unnecessary — orphaned code, single-use abstractions with no justification, exact duplicates.

**Evaluate:** What requires judgment — convention drift that may be intentional, complexity that may be load-bearing, scope that may have been approved verbally.

**Leave:** What is more complex than it looks but is correct — name why each item is being left.

Produce a simplification plan: a specific list of changes, each with the file, the change, and the rationale.

---

### Step 4 — Architect Pass

Evaluate the simplification plan from an architectural perspective.

For each proposed change:
- Does the simplified structure remain coherent with the data model and established patterns?
- Does the proposed change introduce any new coupling that shouldn't exist?
- Does removing this abstraction push complexity somewhere worse?

State which changes are architecturally sound, which need revision, and which should be dropped. Revise the simplification plan accordingly.

---

State "Audit pass complete" as a status line and proceed.

---

### Step 5 — Distinguished Engineer: Plan Review

Apply the Distinguished Engineer discipline (Plan Review mode).

Read the simplification plan produced in Steps 3–4.
Read the actual files in scope before rendering a verdict.
State the verdict: **PROCEED / REVISE PLAN / REJECT**.

- **PROCEED:** Exit the loop. Move to implementation.
- **REVISE PLAN:** Name exactly what must change. Switch back to [SONNET] for another loop iteration. State what the next iteration must resolve.
- **REJECT:** The simplification direction is structurally wrong. Stop. State what reframing is required before this can proceed.

If REVISE PLAN and iterations remain:

State "DE verdict: REVISE PLAN — re-entering (iteration N)" as a status line and re-enter — the loop is DE-driven and bounded; no pause.

State explicitly before re-entering the loop:
- What the previous iteration produced
- What was wrong with it (one sentence per flaw)
- What the next iteration must resolve

---

## Step 6 — Engineer: Implement

Apply the engineer specialist for the project's stack. Read the stack declared in `project-context.md`; if a specialist exists (e.g., `swift-engineer`, `web-engineer`), use it. If none is declared, use the base `engineer`.

Before writing any code:
1. State "What must not break" — specific behaviors, file paths, user-visible outcomes.
2. Confirm no system invariant is violated by the simplification.
3. Check for escalation triggers: new primitives, relationship changes, data migrations, invariant modifications.

Implement the converged simplification plan. Each change touches one behavior. Verify before proceeding to the next.

---

## Step 7 — Simplify Review

Review the changed code for reuse, quality, and efficiency. Apply the `simplify` skill to the changed files.

Identify any remaining issues not caught during implementation: naming inconsistencies, remaining complexity that can be collapsed, anything introduced by the implementation that wasn't in the plan.

Fix any issues found before QA.

---

## Step 8 — QA

Apply the QA Engineer discipline.

For each behavior simplified:
1. **Test scenarios** — what must be tested; cover primary path, edge cases, failure modes.
2. **Regression checks** — what existing behavior could break; verify it did not.
3. **Invariant verification** — confirm each system invariant holds after the simplification.

Report:
- Verified — what was tested and passed
- Found — failures, regressions, or invariant violations
- Requires fix — what must be resolved before continuing
- Unverified — what could not be verified and why

Do not proceed to Distinguished Engineer Code Review if any invariant fails.

---

State "Implementation and QA complete" as a status line and proceed to the DE Code Review — the review is the gate, not the pause.

---

## Step 9 — Distinguished Engineer: Code Review

Apply the Distinguished Engineer discipline (Code Review mode).

Read the spec, the simplification plan, and the actual changed files.
Render a final verdict: **SHIP / REVISE / REJECT**.

- **SHIP:** The simplification is complete. State what was achieved.
- **REVISE:** Name what must change before merging. Changes return to the project's engineer specialist.
- **REJECT:** The implementation does not reflect the plan or introduces new problems. State what must be done before this can proceed.

---

## Output

When SHIP is reached, report:
- What was simplified (specific files and changes)
- What was removed and why
- What must not break (verified by QA)
- Any open risks or follow-on work identified
