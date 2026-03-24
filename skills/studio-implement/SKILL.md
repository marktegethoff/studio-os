---
description: Run the Studio OS engineering workflow for a feature or task. Verifies specification exists, checks invariants, then implements via Engineer and QA disciplines. Engineering must not begin until a specification exists — this workflow enforces that gate.
argument-hint: "<feature or task to implement>"
---

Run the Studio OS engineering workflow for a feature or task.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for spec and invariant checks · [SONNET] for implementation

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Feature: $ARGUMENTS

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — System Invariants, System Model, Engineering Context (spec path)
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, ask: "No project context found. Run `studio-init` to set up Studio OS for this project, or provide the system invariants before continuing."

---

## [HAIKU] Steps 1–2 — Pre-flight checks

### Step 1 — Verify specification

Check the spec path defined in project-context.md under Engineering Context. If no spec path is defined, ask the user where specifications live.

If no specification exists for this feature, stop. State: "Engineering must not begin until a specification exists." Ask the user to run `studio-design` first.

### Step 1.5 — Verify engineering handoff

Check whether the specification includes a complete engineering handoff — all component states, design token names, motion parameters, and accessibility strings.

If the handoff is incomplete or absent, flag it before proceeding:
> "Specifier output not found in the spec. The Engineer will need to make visual judgment calls. Either provide the complete spec or run the Specifier discipline first."

Do not block engineering if the user acknowledges and accepts the risk. But name the gap explicitly.

### Step 2 — Invariant check

Apply the system invariants loaded from project-context.md.

For the feature being implemented, confirm it does not violate any invariant. If any invariant is violated, stop and state which one.

---

> **⏸ PAUSE — Model switch required.**
> Steps 1–2 complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Steps 3–5 — Implementation

### Step 3 — State "What must not break"

Before writing any code, list the behaviors that must remain correct after this change. Be specific: file paths, functions, user-visible behaviors.

### Step 4 — Engineering

Apply the Engineer discipline.

Each step touches one behavior. Verify before proceeding. Follow the project's conventions for tests and previews as defined in project-context.md.

### Step 5 — QA

For each behavior changed:
- Verify invariants from project-context.md hold
- Check regression against "What must not break" list
- Define test scenarios: primary path, edge cases, failure modes

---

## Output

Report:
- What was implemented
- What tests or previews cover it
- What must not break (verified)
- Any open risks
