---
description: Divergent brainstorm workflow. Takes a problem statement (not a solution) and produces 1–2 feature ideas ready for /xd-solve or /design. Runs full discipline team divergence across seven lenses and three constraint frames, facilitated reduction to 3–5 ideas, synthetic user desirability evaluation, user selection, and engineering feasibility. Use when exploring an opportunity space before committing to a direction.
argument-hint: "<problem statement or opportunity area>"
---

Divergent brainstorm for a product problem or opportunity.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Context Loading

Problem: $ARGUMENTS

Load project context on session start. Read in order:
1. `.claude/memory/project-context.md` (project-local) — Ethos, System Invariants, User Archetypes, Decision Log path
2. Fallback: `memory/project-context.md` (plugin root)

If neither exists, ask: "No project context found. Run `/xd-init` to set up XD OS for this project, or describe the product purpose, system invariants, and user archetypes before continuing."

Also check the project's decision log (path defined in project-context.md). If available, scan for prior decisions that constrain or have already addressed this problem space. Do not repeat work already done.

---

## XD OS Ethos (applied throughout)

Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.
Clarity over originality · Coherence over expression · Restraint over flourish.

Decision hierarchy: Structural correctness → Conceptual clarity → System coherence → Reduction of parts → Craft precision → Visual refinement. Novelty is never a factor.

---

## Step 0.5 — PM brief check

Before ideation begins: check for a validated product brief from the PM.

Look for `artifacts/product_brief_*.md` or equivalent in the project. If one exists for this problem, load it — the validated problem statement, customer context, and success definition it contains sharpen the ideation space and prevent generating solutions to the wrong problem.

If no brief exists, note it. Ideation can proceed — but flag it:
> **No PM brief found.** Ideation is running against an unvalidated problem. Results may need re-anchoring once the customer problem is defined. To run problem validation first: `pm [problem statement]`.

---

## Step 1 — Problem Gate

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

Capture this as **[PROBLEM]** — you will embed it in the outer agent prompt in Step 2.

---

## Step 2 — Divergence (outer background agent)

Spawn ONE outer background agent with `run_in_background: true`. This agent reads project context, orchestrates all 7 discipline lenses in parallel, compiles the raw idea list, and returns it. You receive one notification when divergence is complete.

Before spawning: substitute [PROBLEM] in the outer agent prompt with the one-sentence problem statement from Step 1.

**Outer agent**
Description: `"Divergence — 7 lenses"`
Prompt (substitute [PROBLEM] before sending):

===BEGIN OUTER AGENT PROMPT===

You are orchestrating a divergent product design brainstorm for a XD OS project.

First, read the project context file (try `.claude/memory/project-context.md` first, then `memory/project-context.md` as fallback). Extract: product purpose, core system invariants, and user archetypes. You will embed this as [PRODUCT PURPOSE] and [SYSTEM INVARIANTS] in the inner agent prompts below.

Problem: [PROBLEM]

Spawn all 7 discipline agents simultaneously in a SINGLE Agent tool call message, each with run_in_background: true. Do not run sequentially — wait for all to complete, then compile.

Three constraint frames (embed in each agent): Capture moment (user actively in the product, in motion) · Review moment (user returned, making sense of prior work) · Transition moment (something has shifted — project, decision, context).

Rules for all inner agents: 1–2 ideas maximum total across all frames. No feasibility evaluation. No cross-lens comparison. Output format: [Lens] Idea name: one sentence.

Agent 1 — Historian
Description: "Historian lens — product ideation"
Prompt: You are generating ideas from the Historian lens for a product design brainstorm. Product: [PRODUCT PURPOSE]. System invariants: [SYSTEM INVARIANTS]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What has been tried before in this product category or adjacent ones on this class of problem? What succeeded and survived? What failed and why? Apply surviving patterns to the current problem. Rules: no feasibility evaluation, no cross-lens comparison, 1–2 ideas max. Output: [Historian] Idea name: one sentence.

Agent 2 — Designer
Description: "Designer lens — product ideation"
Prompt: You are generating ideas from the Designer lens for a product design brainstorm. Product: [PRODUCT PURPOSE]. System invariants: [SYSTEM INVARIANTS]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What interaction patterns could address this problem? Think in states, transitions, affordances, user behaviors — not features. What does the user do differently if this problem is solved? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output: [Designer] Idea name: one sentence.

Agent 3 — Architect
Description: "Architect lens — product ideation"
Prompt: You are generating ideas from the Architect lens for a product design brainstorm. Product: [PRODUCT PURPOSE]. System invariants: [SYSTEM INVARIANTS]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What structural models could address this problem? Think in data relationships, system boundaries, layer model implications. What new structure, if it existed, would make this problem disappear? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output: [Architect] Idea name: one sentence.

Agent 4 — Scout
Description: "Scout lens — product ideation"
Prompt: You are generating ideas from the Scout lens for a product design brainstorm. Product: [PRODUCT PURPOSE]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What are analogous products in adjacent spaces doing that this product is not? What patterns from outside this category are relevant here? Import patterns from adjacent domains. Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output: [Scout] Idea name: one sentence.

Agent 5 — Marketer
Description: "Marketer lens — product ideation"
Prompt: You are generating ideas from the Marketer lens for a product design brainstorm. Product: [PRODUCT PURPOSE]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What ideas would create genuine pull — something users would seek out, choose over alternatives, or pay for? What solves a pain users already articulate, rather than one they don't know they have? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output: [Marketer] Idea name: one sentence.

Agent 6 — Writer
Description: "Writer lens — product ideation"
Prompt: You are generating ideas from the Writer lens for a product design brainstorm. Product: [PRODUCT PURPOSE]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What if the problem is fundamentally a language or framing problem? What does the vocabulary of the current experience communicate — and what should it communicate instead? What copy, label, or empty state, if rewritten, would reveal that the problem is solved? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output: [Writer] Idea name: one sentence.

Agent 7 — Choreographer
Description: "Choreographer lens — product ideation"
Prompt: You are generating ideas from the Choreographer lens for a product design brainstorm. Product: [PRODUCT PURPOSE]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What if the solution exists entirely in motion, gesture, or transition? What behavior — not surface — would solve this? What does the user feel, not read, that tells them the problem is gone? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output: [Choreographer] Idea name: one sentence.

After all 7 agents complete — compile. Merge all outputs into a single raw idea list. One line per idea, preserving lens tag. Do not evaluate, filter, or reorder. Target: 10–14 distinct ideas. Return the compiled list as your complete output.

===END OUTER AGENT PROMPT===

When the outer agent completes and returns the compiled list, proceed to Step 3.

---

## Step 3 — Facilitated Reduction (xd-design-director)

The Design Director chairs this step. Strategist and Critic participate.

Load user archetypes from project-context.md. These will be needed in Step 4.

**Strategist pass**
For each raw idea: does this strengthen the product's core purpose as defined in project-context.md? Does it improve long-term value for users, or does it add complexity for its own sake? Mark each: FITS / TENSIONS / OUTSIDE.

Eliminate any idea marked OUTSIDE. Flag TENSIONS ideas for Critic scrutiny.

**Critic pass**
Of the remaining ideas: what is redundant (two ideas solving the same problem)? What is decorative (adds surface without structural value)? What is premature (solves a problem this product doesn't have yet)?
Eliminate aggressively. Be ruthless — weak ideas waste the user's time.

**Design Director — selection to 3–5**
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

## Step 4 — Synthetic User Desirability

Evaluate the surviving ideas against the user archetypes defined in project-context.md.

For each archetype, apply their lens to each idea:
- Which archetype(s) would find this most desirable?
- Does this address a problem they actually have, or one we're projecting?
- How would they describe it to someone else?

**Output: desirability signal per idea**
Three sentences per idea, no more: (1) which archetype it lands with and why, (2) whether the problem is real for them or projected, (3) how they would describe it to someone else. Keep output comparable across all ideas.

Note any ideas that don't land with any archetype — they may need reframing or elimination.

---

## Step 5 — Your Selection

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

## Step 6 — Feasibility Pass (outer background agent)

Spawn ONE outer background agent with `run_in_background: true`. This agent runs all 3 evaluators for all selected ideas in parallel and returns compiled per-idea feasibility data. You receive one notification when complete.

Before spawning: substitute [IDEA LIST] with each selected idea (name + concept sentence, one per line), and [SYSTEM INVARIANTS] with the core system invariants from project-context.md.

**Outer agent**
Description: `"Feasibility pass"`
Prompt (substitute [IDEA LIST] and [SYSTEM INVARIANTS] before sending):

===BEGIN OUTER AGENT PROMPT===

You are orchestrating an engineering feasibility pass for product feature ideas.

Selected ideas:
[IDEA LIST]
(Format: Idea Name — one sentence concept)

System invariants: [SYSTEM INVARIANTS]

For each selected idea, spawn 3 evaluator agents. If multiple ideas are selected, spawn ALL agents for ALL ideas in a SINGLE Agent tool call message with run_in_background: true. Do not sequence by idea.

Engineer agent (per idea):
Description: "Engineer feasibility — [IDEA NAME]"
Prompt: You are evaluating implementation feasibility of a feature idea. Idea: [IDEA NAME] — [IDEA CONCEPT]. Assess: What complexity does this introduce? What already exists in the codebase that could support this? What would need to be built from scratch? Are there platform constraints (tech stack, dependencies, APIs) that affect viability? State: LOW / MEDIUM / HIGH implementation complexity, then one sentence of rationale. Output: Implementation complexity: [LOW/MEDIUM/HIGH] — [one sentence]

QA agent (per idea):
Description: "QA feasibility — [IDEA NAME]"
Prompt: You are evaluating QA and invariant risk of a feature idea. System invariants: [SYSTEM INVARIANTS]. Idea: [IDEA NAME] — [IDEA CONCEPT]. Assess: What must not break if this is implemented? What existing behavior is at risk? What edge cases need coverage? State 2–3 specific invariants to protect. Output: What must not break: [2–3 invariants, one per line]

Heurist agent (per idea):
Description: "Heurist feasibility — [IDEA NAME]"
Prompt: You are evaluating usability and interaction friction of a feature idea. Idea: [IDEA NAME] — [IDEA CONCEPT]. Assess: Does the interaction model implied by this idea have friction? Where would users get confused or stuck? Does it match mental models users already have? If underspecified, flag explicitly. Output: Heuristic concerns: [specific concern, or "None identified"]

After all agents complete — compile per idea:

[Idea Name]
Implementation complexity: [LOW/MEDIUM/HIGH] — [one sentence]
What must not break: [2–3 invariants]
Heuristic concerns: [or "None identified"]

Return the compiled feasibility data for all ideas as your complete output.

===END OUTER AGENT PROMPT===

When the outer agent completes and returns the compiled feasibility data, proceed to Step 7.

## Step 7 — DE Verdict (de)

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
[/xd-solve if the core concept needs convergence first]
[/design if the interaction model is ready to be designed]
[Prototype in your design tool if PROTOTYPE verdict — build before writing production code]

### Deferred ideas
[Any ideas with DEFER verdict and what would need to change to reconsider]
```

If no ideas clear feasibility, report honestly. Do not force a recommendation. State what the ideation revealed about the problem and what would need to be different for ideas to clear.
