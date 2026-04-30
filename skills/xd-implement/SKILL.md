---
description: Run the XD OS engineering workflow for a feature or task. Verifies specification exists, checks invariants, then implements via Engineer and QA disciplines. Engineering must not begin until a specification exists — this workflow enforces that gate.
argument-hint: "<feature or task to implement>"
---

Run the XD OS engineering workflow for a feature or task.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Feature: $ARGUMENTS

Load project context on session start. Read in order:
1. `studio_os/project-context.md`; if not found, check `.claude/memory/project-context.md` or `memory/project-context.md`; if absent, read `CLAUDE.md` for product context — System Invariants, System Model, Engineering Context (spec path)

If neither exists, ask: "No project context found. Run `xd-init` to set up XD OS for this project, or provide the system invariants before continuing."

---

## Steps 1–2 — Pre-flight checks

### Step 1 — Verify specification

Check the spec path defined in project-context.md under Engineering Context. If no spec path is defined, ask the user where specifications live.

If no specification exists for this feature, stop. State: "Engineering must not begin until a specification exists." Ask the user to run `design` first.

Spec quality check — before proceeding, confirm the spec:
- Names states (not just the happy path)
- Uses design system token names for color, spacing, and typography (no raw hex or pt values where tokens exist)
- Specifies accessibility labels for interactive elements
- Includes interaction parameters (durations, spring values) by token name

If the spec uses raw values where tokens exist, flag each one: "[element] uses [raw value] — should reference [token]. Resolve before implementing." Do not implement against a spec that requires the engineer to invent design decisions.

### Step 2 — Invariant check

Apply the system invariants loaded from project-context.md.

For the feature being implemented, confirm it does not violate any invariant. If any invariant is violated, stop and state which one.

## Steps 3–5 — Implementation

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
