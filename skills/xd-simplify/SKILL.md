---
description: Run the XD OS simplification workflow on a file, directory, or code area. Audits for complexity drift (duplication, orphaned code, single-use abstractions, convention drift), converges on a simplification plan via Critic + Architect + Distinguished Engineer, then implements and verifies. Distinguished Engineer gates both the plan and the final result before merge.
argument-hint: "<file, directory, or description of code area to simplify>"
---

Run the XD OS simplification workflow.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for context loading · [SONNET] for audit + critic + architect + implementation · [OPUS] for Distinguished Engineer (both passes)

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Embedded XD OS Context

### Ethos
The simplest correct solution. Every abstraction earned. Every line load-bearing.
Remove first. The question is not "does this work?" — it is "does this need to exist?"

### Code Standard
- Three similar lines > premature helper
- No error handling for scenarios that cannot happen
- No abstractions for hypothetical future requirements
- Each change touches one behavior; verify before proceeding

---

## Context Loading

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — System Invariants, System Model, Engineering Context (spec path)
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, ask: "No project context found. What are the system invariants and where do specs live?"

---

## Subject

$ARGUMENTS

---

## [HAIKU] Step 1 — Context Load

Read in order:
1. The spec file for this area, if one exists. Check the spec path from project-context.md.
   If none exists, note it — the simplification will proceed without a contract baseline.
2. `CLAUDE.md` if present — the gotchas section defines known patterns that must not be violated.
3. The files in scope. Read before auditing.

State what was loaded and confirm the scope before proceeding.

---

> **⏸ PAUSE — Model switch required.**
> Context loaded. Switch to **[SONNET]** (`claude-sonnet-4-6`) to begin the audit loop.
> Reply **"continue"** when ready.

---

## [Loop — SONNET + OPUS] Steps 2–5

Maximum iterations: 3. Loop exits when the Distinguished Engineer's Plan Review returns PROCEED.

---

### [SONNET] Step 2 — Code Audit

Scan the files in scope for the following five categories. For each finding, name the file, the specific code, and which category it falls into.

**Duplication** — patterns repeated vs. established conventions in nearby files or across the codebase. Not incidental similarity — structural duplication of logic that already exists somewhere and could be reused.

**Single-use abstractions** — helpers, protocols, or types defined for one caller only. These are premature extractions; the call site should inline them.

**Orphaned code** — functions, methods, or files with no reachable callers. Code that was left behind after a refactor or never connected.

**Convention drift** — patterns that deviate from established conventions in `CLAUDE.md`, the project's established file patterns, or prior spec implementations. Inconsistency that will confuse a future engineer or agent.

**Scope creep** — code introduced beyond what any spec authorized. Features or behaviors not traceable to a decision.

Produce an audit report: one section per category, each finding specific and actionable.

---

### [SONNET] Step 3 — Critic Pass

Of the audit findings, determine what should actually be simplified vs. what must stay.

**Remove:** What is unambiguously unnecessary — orphaned code, single-use abstractions with no justification, exact duplicates.

**Evaluate:** What requires judgment — convention drift that may be intentional, complexity that may be load-bearing, scope that may have been approved verbally.

**Leave:** What is more complex than it looks but is correct — name why each item is being left.

Produce a simplification plan: a specific list of changes, each with the file, the change, and the rationale.

---

### [SONNET] Step 4 — Architect Pass

Evaluate the simplification plan from an architectural perspective.

For each proposed change:
- Does the simplified structure remain coherent with the data model and established patterns?
- Does the proposed change introduce any new coupling that shouldn't exist?
- Does removing this abstraction push complexity somewhere worse?

State which changes are architecturally sound, which need revision, and which should be dropped. Revise the simplification plan accordingly.

---

> **⏸ PAUSE — Model switch required.**
> Audit loop pass complete. Switch to **[OPUS]** (`claude-opus-4-6`) for Distinguished Engineer Plan Review.
> Reply **"continue"** when ready.

---

### [OPUS] Step 5 — Distinguished Engineer: Plan Review

Apply the Distinguished Engineer discipline (Plan Review mode).

Read the simplification plan produced in Steps 3–4.
Read the actual files in scope before rendering a verdict.
State the verdict: **PROCEED / REVISE PLAN / REJECT**.

- **PROCEED:** Exit the loop. Move to implementation.
- **REVISE PLAN:** Name exactly what must change. Switch back to [SONNET] for another loop iteration. State what the next iteration must resolve.
- **REJECT:** The simplification direction is structurally wrong. Stop. State what reframing is required before this can proceed.

If REVISE PLAN and iterations remain:

> **⏸ PAUSE — Model switch required.**
> Plan requires revision. Switch back to **[SONNET]** (`claude-sonnet-4-6`) to revise.
> Reply **"continue"** when ready.

State explicitly before re-entering the loop:
- What the previous iteration produced
- What was wrong with it (one sentence per flaw)
- What the next iteration must resolve

---

## [SONNET] Step 6 — Engineer: Implement

Apply the Engineer discipline.

Before writing any code:
1. State "What must not break" — specific behaviors, file paths, user-visible outcomes.
2. Confirm no system invariant from project-context.md is violated by the simplification.
3. Check for escalation triggers: new primitives, relationship changes, data migrations, invariant modifications.

Implement the converged simplification plan. Each change touches one behavior. Verify before proceeding to the next.

---

## [SONNET] Step 7 — Simplify Review

Review the changed code for reuse, quality, and efficiency. Apply the `simplify` skill if available.

Identify any remaining issues not caught during implementation: naming inconsistencies, remaining complexity that can be collapsed, anything introduced by the implementation that wasn't in the plan.

Fix any issues found before QA.

---

## [SONNET] Step 8 — QA

For each behavior simplified:
1. **Test scenarios** — what must be tested; cover primary path, edge cases, failure modes.
2. **Regression checks** — what existing behavior could break; verify it did not.
3. **Invariant verification** — confirm each system invariant from project-context.md holds after the simplification.

Report:
- Verified — what was tested and passed
- Found — failures, regressions, or invariant violations
- Requires fix — what must be resolved before continuing
- Unverified — what could not be verified and why

Do not proceed to Distinguished Engineer Code Review if any invariant fails.

---

> **⏸ PAUSE — Model switch required.**
> Implementation and QA complete. Switch to **[OPUS]** (`claude-opus-4-6`) for Distinguished Engineer Code Review.
> Reply **"continue"** when ready.

---

## [OPUS] Step 9 — Distinguished Engineer: Code Review

Apply the Distinguished Engineer discipline (Code Review mode).

Read the spec, the simplification plan, and the actual changed files.
Render a final verdict: **SHIP / REVISE / REJECT**.

- **SHIP:** The simplification is complete. State what was achieved.
- **REVISE:** Name what must change before merging. Changes return to [SONNET] for the Engineer.
- **REJECT:** The implementation does not reflect the plan or introduces new problems. State what must be done before this can proceed.

---

## Output

When SHIP is reached, report:
- What was simplified (specific files and changes)
- What was removed and why
- What must not break (verified by QA)
- Any open risks or follow-on work identified
