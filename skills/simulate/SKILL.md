---
name: simulate
description: Run the simulation workflow for a scenario. Evaluates long-term system behavior across timeline navigation, search retrieval, classification accuracy, and instrument feel using the drum simulation model. Use to stress-test features or answer usage-scale questions.
argument-hint: "<scenario to simulate, e.g. two_year_usage>"
---

Run the simulation workflow for a scenario.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for context loading · [SONNET] for simulation and output

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Project Context

Read project context in this order:

1. Read `studio_os/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `studio_os/ledger/decisions/` by name. Do not scan the full directory.
3. If `studio_os/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. You provide the discipline.

---

## Drum Simulation Model
Simulates entry accumulation over time.

Example scenarios: 10 entries/day for a year · sporadic entries over 5 years · project bursts with hundreds of entries

Evaluates:
- **Timeline navigation** — does it remain usable at scale?
- **Search retrieval** — does quality degrade over time?
- **Archivist classification** — does accuracy hold as corpus grows?
- **Instrument feel** — does the surface remain calm and legible?

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

## [HAIKU] Steps 1–3 — Context loading

### Step 1 — Load scenario

If $ARGUMENTS matches a built-in scenario above, use that definition. If not, define the scenario precisely: time horizon, usage pattern, approximate entry volume.

### Step 2 — Apply drum model

Apply the drum simulation model (embedded above): simulate entry accumulation and usage patterns over the scenario's time horizon.

### Step 3 — Invariant check

Apply the system invariants from project context loaded above. For each simulated behavior, confirm no invariant is violated under load or over time.

Also check: if `studio_os/memory_index/index.md` exists in the project, read it for prior simulation results relevant to this scenario.

---

> **⏸ PAUSE — Model switch required.**
> Context loaded. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Step 4 + Output — Simulation

### Step 4 — Run simulation

Evaluate across each dimension:

- **Timeline navigation** — holds / degrades / breaks
- **Search retrieval** — holds / degrades / breaks
- **Archivist classification** — holds / degrades / breaks
- **Instrument feel** — holds / degrades / breaks

For each dimension, state your finding with a brief rationale.

---

## Output

```
# Simulation: [Scenario Name]
Date: [today]

## Scenario definition
[Time horizon, usage pattern, entry volume]

## Results by dimension
Timeline navigation: [holds / degrades / breaks] — [finding]
Search retrieval: [holds / degrades / breaks] — [finding]
Classification: [holds / degrades / breaks] — [finding]
Instrument feel: [holds / degrades / breaks] — [finding]

## Invariant status
[Any violations found, or "All invariants hold"]

## Recommendations
[Only if a dimension degrades or breaks — one recommendation per issue]
```
