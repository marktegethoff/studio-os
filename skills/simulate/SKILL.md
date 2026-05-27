---
name: simulate
description: Run the simulation workflow for a scenario. Evaluates long-term system behavior across navigation at scale, retrieval quality, classification accuracy, and surface feel using the drum simulation model. Use to stress-test features or answer usage-scale questions.
argument-hint: "<scenario to simulate, e.g. two_year_usage>"
---

Run the simulation workflow for a scenario.

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
