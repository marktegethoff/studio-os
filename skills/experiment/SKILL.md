---
name: experiment
description: Run the experiment workflow for a hypothesis. Checks memory for prior results, frames the hypothesis precisely (IF/THEN/BECAUSE), designs the experiment, and evaluates across short/medium/long-term scenarios using the drum simulation model.
argument-hint: "<hypothesis to test>"
---

Run the experiment workflow for a hypothesis.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for memory check · [SONNET] for experiment design and evaluation

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `decisions/` by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. You provide the discipline.

---

## Drum Simulation Model
Simulates entry accumulation over time.

Example scenarios: 10 entries/day for a year · sporadic entries over 5 years · project bursts with hundreds of entries

Evaluates: navigation at scale · retrieval quality · classification accuracy

Built-in scenarios: first_week · first_month · two_year_usage · research_project · travel_journal

---

## Context

Hypothesis: $ARGUMENTS

---

## [HAIKU] Step 0 — PM brief check

If this hypothesis relates to a customer problem or product direction — what to build, who to build for, what behavior to change — check for a validated PM brief before designing the experiment.

Look for `specs/product_brief_*.md`. If one exists, load it. The brief sharpens what the experiment is trying to prove and prevents testing hypotheses that serve the wrong problem.

If no brief exists and this is a customer-facing hypothesis, note it:

> **No PM brief found.** This experiment is running against an unvalidated customer problem. Consider running `/pm` first. Results may need re-anchoring once the problem is defined.

If this is a technical, structural, or behavioral hypothesis — not a customer or product direction problem — skip this step and proceed.

---

## [HAIKU] Step 1 — Memory check

Using project context loaded above, check for prior experiment results. If `specs/experiments/` exists, read all files there. If `.claude/memory/index.md` exists, read it. If this hypothesis has already been tested, report the prior result and stop. Do not re-run experiments with known conclusions.

If no memory exists, proceed to Step 2.

---

> **⏸ PAUSE — Model switch required.**
> Memory check complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Steps 2–6 — Experiment

### Step 2 — Philosophy check

Apply the project ethos and decision hierarchy from project context loaded above.

Is the hypothesis worth testing? Does it risk violating the ethos or decision hierarchy? State your position before proceeding.

### Step 3 — Frame the hypothesis precisely

Restate the hypothesis in this form:

```
IF [condition]
THEN [expected outcome]
BECAUSE [reasoning]
```

If the hypothesis cannot be framed this way, it is not ready for experimentation. Stop and ask for clarification.

### Step 4 — Design the experiment

Define:
- What would confirm the hypothesis
- What would falsify it
- What scenarios to test (use built-in scenarios: first_week, first_month, two_year_usage, research_project, travel_journal)
- What invariants must hold regardless of outcome

### Step 5 — Run evaluation

Apply the drum simulation model (embedded above).

Evaluate the hypothesis across short-term (first week), medium-term (first month), and long-term (two-year usage) scenarios.

### Step 6 — Conclude

State one of:
- CONFIRMED — evidence supports the hypothesis
- FALSIFIED — evidence contradicts the hypothesis
- INCONCLUSIVE — insufficient signal

State the conclusion in one sentence. State what changes (if any) follow from it.

---

## Output

Present the result in the response using this structure:

```
# Experiment: [Hypothesis Name]
Date: [today]

## Hypothesis
IF [condition] THEN [outcome] BECAUSE [reasoning]

## Experiment design
[What confirms / falsifies / scenarios tested]

## Findings
[Evidence summary]

## Conclusion
[CONFIRMED / FALSIFIED / INCONCLUSIVE]
[One sentence]

## Consequences
[What changes, if anything — or "No changes required"]
```

If `specs/experiments/` exists in the project, offer to write this to `specs/experiments/[hypothesis-slug].md`. Otherwise offer to write to the project's artifact location specified in CLAUDE.md.
