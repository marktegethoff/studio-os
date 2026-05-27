---
description: Run the simplification workflow on a file, directory, or code area. Audits for complexity drift, converges on a simplification plan via Critic + Architect + Distinguished Engineer, then implements. Distinguished Engineer gates both the plan and the final result. Use after a feature ships, when code feels suspect, or on a periodic coherence pass.
argument-hint: "<file, directory, or description of code area to simplify>"
---

Run the simplification workflow.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS, suppress all PAUSE checkpoints and proceed with reasonable defaults. State any decisions made on the user's behalf in the final output's "Auto-mode decisions" section. Use for overnight runs, scheduled invocations, or agent-orchestrated workflows.

### Auto-mode safety contract (non-negotiable)

Before performing any action in `--auto` mode, the orchestrator MUST verify:

1. **Not on the main branch.** If `git rev-parse --abbrev-ref HEAD` returns `main` (or the repo's primary branch), the orchestrator MUST create a new branch named `auto/<skill>-<timestamp>` and switch to it before any writes. Prefer a `git worktree` if multiple `--auto` skills may run in parallel.
2. **No push.** The orchestrator MUST NOT run `git push`, `git push --force`, `gh pr create`, or any remote-affecting command. All work stays local on the auto branch.
3. **No tag.** The orchestrator MUST NOT run `release.sh` or `git tag` in `--auto` mode. Tagging is a deliberate human act after review.
4. **No merge.** The orchestrator MUST NOT merge the auto branch into main or any other branch.
5. **Commit allowed; bounded.** Commits to the auto branch are permitted (and encouraged — they create a reviewable checkpoint history). Each commit is one logical change with a clear message.
6. **Final summary required.** The Output of every `--auto` run MUST include a "Branch" line naming the auto branch, a "Diff size" line (files changed, lines added/removed), and the exact `git checkout <branch>` + `git diff main...<branch>` commands the human can run to review in the morning.

If any of conditions 1–4 cannot be satisfied (e.g., dirty tree, no git repo), the orchestrator MUST refuse to proceed and surface the blocking condition in the output. **Never bypass a guard to make a run succeed.**

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

> **⏸ PAUSE (skipped in --auto) — Context loaded.**
> Reply **"continue"** when ready.

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

> **⏸ PAUSE (skipped in --auto) — Audit loop pass complete.**
> Reply **"continue"** when ready.

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

> **⏸ PAUSE (skipped in --auto) — Plan requires revision.**
> Reply **"continue"** when ready.

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

> **⏸ PAUSE (skipped in --auto) — Implementation and QA complete.**
> Reply **"continue"** when ready.

---

## Step 9 — Distinguished Engineer: Code Review

Apply the Distinguished Engineer discipline (Code Review mode).

Read the spec, the simplification plan, and the actual changed files.
Render a final verdict: **SHIP / REVISE / REJECT**.

- **SHIP:** The simplification is complete. State what was achieved.
- **REVISE:** Name what must change before merging. Changes return to [SONNET] for the iOS Engineer.
- **REJECT:** The implementation does not reflect the plan or introduces new problems. State what must be done before this can proceed.

---

## Output

When SHIP is reached, report:
- What was simplified (specific files and changes)
- What was removed and why
- What must not break (verified by QA)
- Any open risks or follow-on work identified
