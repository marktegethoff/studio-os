---
description: Divergent brainstorm workflow. Takes a problem statement (not a solution) and produces 1–2 feature ideas ready for /studio-solve or /studio-design. Runs full discipline team divergence across seven lenses and three constraint frames, facilitated reduction to 3–5 ideas, synthetic user desirability evaluation, user selection, and engineering feasibility. Use when exploring an opportunity space before committing to a direction.
argument-hint: "<problem statement or opportunity area>"
---

Divergent brainstorm for a product problem or opportunity.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for problem gate + context · [SONNET] for divergence, synthetic users, feasibility · [OPUS] for facilitated reduction (Creative Director) + DE verdict

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Problem: $ARGUMENTS

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — Ethos, System Invariants, User Archetypes, Decision Log path
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, ask: "No project context found. Run `/studio-init` to set up Studio OS for this project, or describe the product purpose, system invariants, and user archetypes before continuing."

Also check the project's decision log (path defined in project-context.md). If available, scan for prior decisions that constrain or have already addressed this problem space. Do not repeat work already done.

---

## Studio OS Ethos (applied throughout)

Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.
Clarity over originality · Coherence over expression · Restraint over flourish.

Decision hierarchy: Structural correctness → Conceptual clarity → System coherence → Reduction of parts → Craft precision → Visual refinement. Novelty is never a factor.

---

## [HAIKU] Step 1 — Problem Gate

Input: $ARGUMENTS

**Evaluate the input shape.**

If the input reads as a solution ("add X", "build Y", "make Z") — reject it.

Output this message to the user and stop:

> **Problem gate: reframe required.**
> This reads as a solution, not a problem.
> Restate what you're trying to solve: what are users unable to do, or doing poorly? What gap exists in the product? What opportunity are you sensing?
> The brainstorm begins once the input is problem-shaped.

If the input is a genuine problem statement or opportunity area, proceed.

**Prior work check.**
Scan the decision log for prior decisions that constrain or have already addressed this problem space. Note them. Do not repeat work already done.

State in one sentence: what is the core problem or opportunity? What does a good solution need to accomplish?

---

> **⏸ PAUSE — Model switch required.**
> Problem gate complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Step 2 — Divergence

Each discipline generates ideas from their specific lens across three constraint frames. Ideas should be genuinely distinct — not variations on the same approach. Constraint thinking about feasibility is prohibited at this stage.

Each discipline generates **1–2 ideas total** — use the frames as constraint lenses to sharpen thinking, not as multipliers. Quality over volume.

**Three constraint frames** — apply each discipline through all three moments:
- **Capture moment:** the user is actively in the product, doing something, in motion
- **Review moment:** the user has returned and is making sense of prior work
- **Transition moment:** something has shifted — a project, a decision, a context

---

**Historian lens**
What has been tried before in this product category or adjacent ones on this class of problem? What succeeded? What failed and why? What survived long enough to be worth learning from?
Apply the three frames: what pattern fits the capture moment? The review moment? The transition moment?
Generate ideas by applying surviving patterns to the current problem.

**Designer lens**
What interaction patterns could address this problem? Think in terms of states, transitions, affordances, and user behaviors — not features. What does the user do differently if this problem is solved?
Apply the three frames: what interaction belongs at capture? At review? At transition?
Generate ideas from the interaction space.

**Architect lens**
What structural models could address this problem? Think in terms of data relationships, system boundaries, and layer model implications. What new structure, if it existed, would make this problem disappear?
Apply the three frames: what structure would a capturing user need? A reviewing user? A user in transition?
Generate ideas from the structural space.

**Scout lens**
What are analogous products in adjacent spaces doing that this product is not? What patterns from outside this category are relevant here?
Apply the three frames: what do adjacent tools do well at the moment of capture? Of review? Of transition?
Generate ideas by importing patterns from adjacent domains.

**Marketer lens**
What ideas would create genuine pull — something users would seek out, choose over alternatives, or pay for? What solves a pain users already articulate, rather than one they don't know they have?
Apply the three frames: what would a user seek out at capture? At review? At transition?
Generate ideas from the demand and desirability space.

**Writer lens**
What if the problem is fundamentally a language or framing problem? What does the vocabulary of the current experience communicate — and what should it communicate instead? What copy, label, or empty state, if rewritten, would reveal that the problem is solved?
Apply the three frames: what words matter most at capture? At review? At transition?
Generate ideas from the language and meaning space.

**Choreographer lens**
What if the solution exists entirely in motion, gesture, or transition? What behavior — not surface — would solve this? What does the user feel, not read, that tells them the problem is gone?
Apply the three frames: what motion belongs at capture? At review? At transition?
Generate ideas from the gesture and behavior space.

---

**Output: raw idea list**
Compile all ideas generated above. Present them briefly — one sentence each, tagged with the lens that produced it. Do not evaluate yet. Target: 10–14 distinct ideas.

---

> **⏸ PAUSE — Model switch required.**
> Divergence complete. Switch to **[OPUS]** (`claude-opus-4-6`) for facilitated reduction.
> Reply **"continue"** when ready.

---

## [OPUS] Step 3 — Facilitated Reduction

The Creative Director chairs this step. Strategist and Critic participate.

Load user archetypes from project-context.md. These will be needed in Step 4.

**Strategist pass**
For each raw idea: does this strengthen the product's core purpose as defined in project-context.md? Does it improve long-term value for users, or does it add complexity for its own sake? Mark each: FITS / TENSIONS / OUTSIDE.

Eliminate any idea marked OUTSIDE. Flag TENSIONS ideas for Critic scrutiny.

**Critic pass**
Of the remaining ideas: what is redundant (two ideas solving the same problem)? What is decorative (adds surface without structural value)? What is premature (solves a problem this product doesn't have yet)?
Eliminate aggressively. Be ruthless — weak ideas waste the user's time.

**Creative Director — selection to 3–5**
From what survives: select the strongest 3–5 ideas. Fewer is acceptable if the quality bar isn't met — do not pad to reach 5. Apply taste. Ask for each:
- Is this conceptually distinct from the others?
- Is there something genuinely interesting here — a non-obvious angle?
- Would this feel inevitable if done well?

Eliminate the redundant, the obvious, and the forgettable.

**Format each surviving idea as an idea card:**

```
**[Name]**
Concept: [one sentence — what this is]
Differentiator: [what makes this non-obvious — why isn't this the first thing anyone would try?]
Risk: [the one thing most likely to kill this idea]
```

---

> **⏸ PAUSE — Model switch required.**
> Reduction complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) for synthetic user evaluation.
> Reply **"continue"** when ready.

---

## [SONNET] Step 4 — Synthetic User Desirability

Evaluate the surviving ideas against the user archetypes defined in project-context.md.

For each archetype, apply their lens to each idea:
- Which archetype(s) would find this most desirable?
- Does this address a problem they actually have, or one we're projecting?
- How would they describe it to someone else?

**Output: desirability signal per idea**
Three sentences per idea, no more: (1) which archetype it lands with and why, (2) whether the problem is real for them or projected, (3) how they would describe it to someone else. Keep output comparable across all ideas.

Note any ideas that don't land with any archetype — they may need reframing or elimination.

---

> **⏸ PAUSE — Model switch required.**
> Synthetic user evaluation complete. Switch to **[HAIKU]** (`claude-haiku-4-5-20251001`) for user selection presentation.
> Reply **"continue"** when ready.

---

## [HAIKU] Step 5 — Your Selection

Present the idea cards with desirability notes beneath each, in this format:

```
**[Name]**
Concept: [one sentence]
Differentiator: [one sentence]
Risk: [one sentence]

Desirability: [three sentences from Step 4]
```

Then output this to the user and stop:

> **Select 2–3 ideas to take to feasibility.**
> Which ideas interest you, and why? Your stated preference will shape how the feasibility pass evaluates them.

---

> **⏸ PAUSE — Your turn.**
> Waiting for your selection and preference before continuing.

---

## [SONNET] Step 6 — Feasibility Pass

Evaluate each selected idea in turn within this pass.

For each idea, apply:

**Engineer**
What complexity does this introduce? What already exists in the codebase that could support this? What would need to be built from scratch? Are there platform constraints (tech stack, dependencies, APIs) that affect viability?
State: LOW / MEDIUM / HIGH implementation complexity, with one sentence of rationale.

**QA**
What must not break if this is implemented? What existing behavior is at risk? What are the edge cases that would need coverage?
State 2–3 specific invariants to protect.

**Heurist**
Does the interaction model implied by this idea have friction? Where would users get confused or stuck? Does it match the mental models users already have?
State any concerns. If the interaction model is underspecified, flag it.

**Output per idea:**
```
**[Idea Name]**
Implementation complexity: [LOW / MEDIUM / HIGH] — [one sentence]
What must not break: [2–3 invariants]
Heuristic concerns: [or "None identified"]
```

---

> **⏸ PAUSE — Model switch required.**
> Feasibility data collected. Switch to **[OPUS]** (`claude-opus-4-6`) for DE verdict.
> Reply **"continue"** when ready.

---

## [OPUS] Step 7 — DE Verdict

The Distinguished Engineer evaluates each selected idea against the feasibility data.

For each idea, deliver a verdict:

**PROTOTYPE** — feasibility is low-risk, interaction model is clear, this should be prototyped immediately.

**INVESTIGATE** — promising but one or more unknowns must be resolved before prototyping. Name the specific question to answer.

**DEFER** — either complexity is disproportionate, invariants are at high risk, or the idea needs more definition before it can be evaluated. Name what must change.

**Output per idea:**
```
**[Idea Name]**
Verdict: PROTOTYPE / INVESTIGATE / DEFER
Rationale: [one sentence — the most important factor driving this verdict]
Next action: [the single specific action required before this moves forward]
```

If all selected ideas receive DEFER: state clearly whether (a) the problem statement needs reframing — the ideation explored the wrong space — or (b) Step 2 should re-enter with a modified constraint. Do not proceed to Exit in this case; surface the diagnosis and stop.

---

## Exit

Present the cleared ideas:

```
## Ideation Result: [Problem Statement]
Date: [today]

### Ideas cleared for next phase
[1–2 ideas with PROTOTYPE or INVESTIGATE verdict]
[Brief framing of what each idea is and why it cleared]

### Recommended next step
[/studio-solve if the core concept needs convergence first]
[/studio-design if the interaction model is ready to be designed]
[Prototype in your design tool if PROTOTYPE verdict — build before writing production code]

### Deferred ideas
[Any ideas with DEFER verdict and what would need to change to reconsider]
```

If no ideas clear feasibility, report honestly. Do not force a recommendation. State what the ideation revealed about the problem and what would need to be different for ideas to clear.
