---
description: Run the Studio OS experiment workflow for a hypothesis. Checks memory for prior results, frames the hypothesis precisely (IF/THEN/BECAUSE), designs the experiment, and evaluates across short/medium/long-term scenarios.
argument-hint: "<hypothesis to test>"
---

Run the Studio OS experiment workflow for a hypothesis.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for memory check · [SONNET] for experiment design and evaluation

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Hypothesis: $ARGUMENTS

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — Ethos, Decision Hierarchy, System Invariants
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, proceed with the embedded Studio OS context only.

---

## Studio OS Ethos (applied throughout)

Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.
Clarity over originality · Coherence over expression · Restraint over flourish.

Decision hierarchy: Structural correctness → Conceptual clarity → System coherence → Reduction of parts → Craft precision → Visual refinement. Novelty is never a factor.

---

## [HAIKU] Step 0 — PM brief check

If this hypothesis relates to a customer problem or product direction — what to build, who to build for, what behavior to change — check for a validated PM brief before designing the experiment.

Look for `artifacts/product_brief_*.md` or equivalent in the project. If one exists, load it. The brief sharpens what the experiment is trying to prove and prevents testing hypotheses that serve the wrong problem.

If no brief exists and this is a customer-facing hypothesis, note it:

> **No PM brief found.** This experiment is running against an unvalidated customer problem. Consider running `studio-pm` first. Results may need re-anchoring once the problem is defined.

If this is a technical, structural, or behavioral hypothesis — not a customer or product direction problem — skip this step and proceed.

---

## [HAIKU] Step 1 — Memory check

Check the project's decision log path (defined in project-context.md). Has this hypothesis already been tested? If yes, report the prior result and stop. Do not re-run experiments with known conclusions.

If no decision log is defined, proceed to Step 2.

---

> **⏸ PAUSE — Model switch required.**
> Memory check complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Steps 2–6 — Experiment

### Step 2 — Philosophy check

Apply the ethos and decision hierarchy loaded from project-context.md.

Is the hypothesis worth testing? Does it risk violating the ethos or system invariants? State your position before proceeding.

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
- What scenarios to test (define from the product's usage patterns — use archetypes from project-context.md if available, or construct scenarios that represent early use, sustained use, and stressed use)
- What invariants must hold regardless of outcome

### Step 5 — Run evaluation

Evaluate the hypothesis across:
- **Short-term** — first days or week of use
- **Medium-term** — first month of sustained use
- **Long-term** — one to two years of accumulated use

For each time horizon: what does the user experience? What does the system state look like? Does the hypothesis hold, degrade, or fail?

### Step 6 — Conclude

State one of:
- **CONFIRMED** — evidence supports the hypothesis
- **FALSIFIED** — evidence contradicts the hypothesis
- **INCONCLUSIVE** — insufficient signal

State the conclusion in one sentence. State what changes (if any) follow from it.

---

## Output

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

If the project's decision log path is defined in project-context.md, offer to write this to the appropriate artifacts directory.
