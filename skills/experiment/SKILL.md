---
name: experiment
description: Run the experiment workflow for a hypothesis. Checks memory for prior results, frames the hypothesis precisely (IF/THEN/BECAUSE), designs the experiment, and evaluates across short/medium/long-term scenarios using the drum simulation model.
argument-hint: "<hypothesis to test>"
artifact: experiment-plan
---

Run the experiment workflow for a hypothesis.

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
Simulates entry accumulation over time.

Example scenarios: 10 entries/day for a year · sporadic entries over 5 years · project bursts with hundreds of entries

Evaluates: navigation at scale · retrieval quality · classification accuracy

Built-in scenarios: first_week · first_month · two_year_usage · research_project · travel_journal

---

## Context

Hypothesis: $ARGUMENTS

---

## Step 0 — PM brief check

If this hypothesis relates to a customer problem or product direction — what to build, who to build for, what behavior to change — check for a validated PM brief before designing the experiment.

Look for `specs/product_brief_*.md`. If one exists, load it. The brief sharpens what the experiment is trying to prove and prevents testing hypotheses that serve the wrong problem.

If no brief exists and this is a customer-facing hypothesis, note it:

> **No PM brief found.** This experiment is running against an unvalidated customer problem. Consider running `/pm` first. Results may need re-anchoring once the problem is defined.

If this is a technical, structural, or behavioral hypothesis — not a customer or product direction problem — skip this step and proceed.

---

## Step 1 — Memory check

Using project context loaded above, check for prior experiment results. If `specs/experiments/` exists, read all files there. If `.claude/memory/index.md` exists, read it. If this hypothesis has already been tested, report the prior result and stop. Do not re-run experiments with known conclusions.

If no memory exists, proceed to Step 2.

---

> **⏸ PAUSE (skipped in --auto) — Memory check complete.**
> Reply **"continue"** when ready.

---

## Steps 2–6 — Experiment

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

Render the artifact as HTML using the kit template.

1. Load `artifacts/templates/experiment-plan.html` as the structural shell.
2. Populate the artifact-specific fields: hypothesis (IF/THEN/BECAUSE), experiment design and scenarios, findings, conclusion (CONFIRMED / FALSIFIED / INCONCLUSIVE), consequences.
3. Write to `specs/experiment_<slug>.html` where slug is derived from the hypothesis (lowercase kebab-case, max 40 chars).
4. Surface a short markdown summary in conversation:
   - File path
   - One-sentence headline
   - Conclusion verdict and key consequences
5. Offer: "Run `/studio:annotate <file-path>` to attach the feedback harness."

If `--text` is in $ARGUMENTS, skip HTML emission and present the markdown summary as the full output.
