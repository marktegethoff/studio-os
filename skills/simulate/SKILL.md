---
name: simulate
description: "[DEPRECATED — retiring next release] Long-horizon behavior simulation. Models how the system behaves under edge cases and extended use across time."
argument-hint: "<scenario to simulate, e.g. two_year_usage>"
---

> **⚠️ DEPRECATED.** This skill retires next release (archived to `archive/skills/`). Its job — long-horizon failure discovery — is better served by `/studio:experiment` with a falsification condition plus the `assumption-mapper` agent's risk register. Use those instead.

Run the simulation workflow for a scenario.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from the plugin's `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `decisions/` by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. You provide the discipline.

---

## Drum Simulation Model
Simulates data accumulation over time.

Example scenarios: 10 entries/day for a year · sporadic entries over 5 years · project bursts with hundreds of entries

Evaluates:
- **Navigation at scale** — does it remain usable at scale?
- **Retrieval quality** — does quality degrade over time?
- **Classification accuracy** — does accuracy hold as corpus grows?
- **Surface feel** — does the surface remain calm and legible?

### Scenario Library
Built-in scenarios:
- **first_week** — early adoption, sparse entries, onboarding friction
- **first_month** — habit formation, initial thread detection, first threads
- **two_year_usage** — dense tape, hundreds of threads, archive accumulation
- **research_project** — burst capture over weeks, convergence-heavy
- **travel_journal** — time-compressed, location-varied, narrative entries

---

## Context

Scenario: $ARGUMENTS

---

## Steps 1–3 — Context loading

### Step 1 — Load scenario

If $ARGUMENTS matches a built-in scenario above, use that definition. If not, define the scenario precisely: time horizon, usage pattern, approximate entry volume.

### Step 2 — Apply drum model

Apply the drum simulation model (embedded above): simulate data accumulation and usage patterns over the scenario's time horizon.

### Step 3 — Invariant check

Apply the system invariants from project context loaded above. For each simulated behavior, confirm no invariant is violated under load or over time.

Also check: if `.claude/memory/index.md` exists in the project, read it for prior simulation results relevant to this scenario.

---

> **⏸ PAUSE (skipped in --auto) — Context loaded.**
> Reply **"continue"** when ready.

---

## Step 4 + Output — Simulation

### Step 4 — Run simulation

Evaluate across each dimension:

- **Navigation at scale** — holds / degrades / breaks
- **Retrieval quality** — holds / degrades / breaks
- **Classification accuracy** — holds / degrades / breaks
- **Surface feel** — holds / degrades / breaks

For each dimension, state your finding with a brief rationale.

---

## Output

```
# Simulation: [Scenario Name]
Date: [today]

## Scenario definition
[Time horizon, usage pattern, entry volume]

## Results by dimension
Navigation at scale: [holds / degrades / breaks] — [finding]
Retrieval quality: [holds / degrades / breaks] — [finding]
Classification: [holds / degrades / breaks] — [finding]
Surface feel: [holds / degrades / breaks] — [finding]

## Invariant status
[Any violations found, or "All invariants hold"]

## Recommendations
[Only if a dimension degrades or breaks — one recommendation per issue]
```
