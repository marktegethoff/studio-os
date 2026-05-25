---
description: Divergent brainstorm workflow. Takes a problem statement (not a solution) and produces 1–2 feature ideas ready for /solve or /design. Runs full design team divergence via parallel agents across seven lenses and three constraint frames, facilitated reduction to 3–5 ideas, synthetic user desirability, user selection, and parallel engineering feasibility. Use when exploring an opportunity space before committing to a direction.
argument-hint: "<problem statement or opportunity area>"
---

Divergent brainstorm for a product problem or opportunity.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for problem gate + context · [SONNET] for compilation, synthetic users, feasibility synthesis · [OPUS] for facilitated reduction (Creative Director) + DE verdict
**Parallel agents:** Step 2 and Step 6 each use an outer background agent. Inner parallelism is managed within the outer agent — you receive one notification per phase, not one per inner agent.

**Six Functions (see CLAUDE.md).** Ideas produced here feed `/studio:design`, where the six functions apply in full. Ideation's own divergence already spans multiple lenses; it does not itself produce a final design artifact, so it is not held to the six-function floor — but it must hand off a problem framed well enough that design can satisfy them.

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Project Context

Read project context in this order:

1. Read `studio_os/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `studio_os/ledger/decisions/` by name. Do not scan the full directory.
3. If `studio_os/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. You provide the discipline.

**When project context is loaded:** extract a concise PROJECT_CONTEXT string — product name, core concept, key invariants, layer model (if defined), and tech stack. You will embed this verbatim into inner agent prompts. This is how sub-agents receive project context they cannot load themselves.

---

## Disciplines
**Historian:** What similar systems existed? What patterns endured? What mistakes to avoid?
**Designer:** Interaction model, visual hierarchy, how things behave.
**Architect:** Data model, system boundaries, scalability, integration points.
**Scout:** Adjacent product space — what are analogous tools doing?
**Marketer:** Commercial demand — what will users find, choose, pay for?
**Writer:** Language and meaning first — sees problems as vocabulary, framing, or copy problems.
**Choreographer:** Motion and transitions — sees solutions that exist in gesture or behavior space.
**Strategist:** Does this strengthen the product's core value? Long-term user value?
**Critic:** Remove unnecessary ideas. Elimination is a form of design.
**Creative Director:** Quality bar and taste. Chairs the facilitated reduction.
**Engineer:** Implementation complexity and feasibility.
**QA:** What must not break.
**Heurist:** Interaction concerns, mental model friction.
**DE (Distinguished Engineer):** Structural risk. Final feasibility verdict.

---

## [HAIKU] Step 0.5 — PM brief check

Before ideation begins: check for a validated product brief.

Look for briefs in `studio_os/artifacts/product_brief_*.md` or the brief path defined in CLAUDE.md. If one exists for this problem, load it — the validated problem statement, customer context, and success definition it contains sharpen the ideation space and prevent generating solutions to the wrong problem.

If no brief exists, note it. Ideation can proceed — but flag it:
> **No PM brief found.** Ideation is running against an unvalidated problem. Results may need re-anchoring once the customer problem is defined. To run problem validation first: `/pm [problem statement]`.

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
If `studio_os/ledger/decisions/` exists, read it to identify any prior decisions that constrain or have already addressed this problem space. Note them. Do not repeat work already done.

State in one sentence: what is the core problem or opportunity? What does a good solution need to accomplish?

Capture this as **[PROBLEM]** — you will embed it verbatim into the outer agent prompt in Step 2.

---

> **⏸ PAUSE — Model switch required.**
> Problem gate complete. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET] Step 2 — Divergence (outer background agent)

Spawn ONE outer background agent with `run_in_background: true`. This agent orchestrates all 7 discipline lenses internally, compiles the raw idea list, and returns it. You will receive one notification when divergence is complete.

Before spawning: replace [PROBLEM] with the exact one-sentence problem statement from Step 1, and replace [PROJECT_CONTEXT] with the PROJECT_CONTEXT string extracted from project context above.

**Outer agent**
Description: `"Divergence — 7 lenses"`
Prompt (substitute [PROBLEM] and [PROJECT_CONTEXT] before sending):

===BEGIN OUTER AGENT PROMPT===

You are orchestrating a divergent product design brainstorm.

Product context: [PROJECT_CONTEXT]

Problem: [PROBLEM]

Spawn all 7 discipline agents simultaneously in a SINGLE Agent tool call message, each with run_in_background: true. Do not run them sequentially — wait for all to complete, then compile.

Three constraint frames (embed in each agent prompt): Capture moment (user actively writing, thinking in motion) · Review moment (user returned, making sense of prior entries) · Transition moment (project ending, decision being made, something has shifted).

Rules for all inner agents: 1–2 ideas maximum total across all frames. Do not evaluate feasibility. Do not compare to other lenses. Output format: [Lens] Idea name: one sentence describing the idea.

Agent 1 — Historian
Description: "Historian lens — product ideation"
Prompt: You are generating ideas from the Historian lens for a product brainstorm. Product context: [PROJECT_CONTEXT]. Problem: [PROBLEM]. Three constraint frames — use to sharpen thinking, not as separate tasks. Generate 1–2 ideas total: Capture moment (user actively writing) / Review moment (user returned, making sense) / Transition moment (project ending, decision being made). Your lens: What has been tried before in analogous tools on this class of problem? What succeeded and survived? What failed and why? Apply surviving patterns to the current problem. Rules: no feasibility evaluation, no cross-lens comparison, 1–2 ideas maximum. Output — one line per idea: [Historian] Idea name: one sentence describing the idea.

Agent 2 — Designer
Description: "Designer lens — product ideation"
Prompt: You are generating ideas from the Designer lens for a product brainstorm. Product context: [PROJECT_CONTEXT]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What interaction patterns could address this problem? Think in terms of states, transitions, affordances, and user behaviors — not features. What does the user do differently if this problem is solved? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output — one line per idea: [Designer] Idea name: one sentence describing the idea.

Agent 3 — Architect
Description: "Architect lens — product ideation"
Prompt: You are generating ideas from the Architect lens for a product brainstorm. Product context: [PROJECT_CONTEXT]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What structural models could address this problem? Think in terms of data relationships, system boundaries, and layer model implications. What new structure, if it existed, would make this problem disappear? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output — one line per idea: [Architect] Idea name: one sentence describing the idea.

Agent 4 — Scout
Description: "Scout lens — product ideation"
Prompt: You are generating ideas from the Scout lens for a product brainstorm. Product context: [PROJECT_CONTEXT]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What are analogous products in adjacent spaces doing that this product is not? What patterns from outside the category are relevant here? Import patterns from adjacent domains. Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output — one line per idea: [Scout] Idea name: one sentence describing the idea.

Agent 5 — Marketer
Description: "Marketer lens — product ideation"
Prompt: You are generating ideas from the Marketer lens for a product brainstorm. Product context: [PROJECT_CONTEXT]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What ideas would create genuine pull — something users would seek out, choose over alternatives, or pay for? What solves a pain users already articulate, rather than one they don't know they have? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output — one line per idea: [Marketer] Idea name: one sentence describing the idea.

Agent 6 — Writer
Description: "Writer lens — product ideation"
Prompt: You are generating ideas from the Writer lens for a product brainstorm. Product context: [PROJECT_CONTEXT]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What if this problem is fundamentally a language or framing problem? What does the vocabulary of the current experience communicate — and what should it communicate instead? What copy, label, or empty state, if rewritten, would reveal that the problem is solved? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output — one line per idea: [Writer] Idea name: one sentence describing the idea.

Agent 7 — Choreographer
Description: "Choreographer lens — product ideation"
Prompt: You are generating ideas from the Choreographer lens for a product brainstorm. Product context: [PROJECT_CONTEXT]. Problem: [PROBLEM]. Three constraint frames (1–2 ideas total): Capture / Review / Transition. Your lens: What if the solution exists entirely in motion, gesture, or transition? What behavior — not surface — would solve this? What does the user feel, not read, that tells them the problem is gone? Rules: no feasibility, no cross-lens comparison, 1–2 ideas max. Output — one line per idea: [Choreographer] Idea name: one sentence describing the idea.

After all 7 agents complete — compile. Merge all outputs into a single raw idea list. One line per idea, preserving the lens tag. Do not evaluate, filter, or reorder. Target: 10–14 distinct ideas. Return the compiled list as your complete output.

===END OUTER AGENT PROMPT===

When the outer agent completes and returns the compiled list, proceed to Step 3.

---

> **⏸ PAUSE — Model switch required.**
> Divergence complete. Switch to **[OPUS]** (`claude-opus-4-6`) for facilitated reduction.
> Reply **"continue"** when ready.

---

## [OPUS] Step 3 — Facilitated Reduction

The Creative Director chairs this step. Strategist and Critic participate.

**Strategist pass**
For each raw idea: does this strengthen the product's core value proposition? Does it improve long-term value for users, or does it add complexity for its own sake? Mark each: FITS / TENSIONS / OUTSIDE.

Eliminate any idea marked OUTSIDE. Flag TENSIONS ideas for Critic scrutiny.

**Critic pass**
Of the remaining ideas: what is redundant (two ideas solving the same problem)? What is decorative (adds surface without structural value)? What is premature (solves a problem the product doesn't have yet)?
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

Evaluate the surviving ideas against synthetic user personas.

**Loading personas:** If user personas are defined in CLAUDE.md or in a project artifacts file (e.g., `studio_os/artifacts/personas*.md`), load and use them. Otherwise, generate 3 concise personas from the problem statement — one power user deeply invested in the core workflow, one casual user who engages episodically, and one user at a transition point (e.g., returning after time away, or discovering the product anew). Name each briefly and capture their primary goal in one sentence.

**Output: desirability signal per idea**
Three sentences per idea, no more: (1) which persona it lands with and why, (2) whether the problem is real for them or projected, (3) how they would describe it to someone else. Keep output comparable across all ideas.

Note any ideas that don't land with any persona — flag for elimination consideration.

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

## [SONNET] Step 6 — Feasibility Pass (outer background agent)

Spawn ONE outer background agent with `run_in_background: true`. This agent runs all 3 evaluators (iOS Engineer, QA, Heurist) for all selected ideas in parallel and returns compiled per-idea feasibility data. You will receive one notification when complete.

Before spawning: replace [IDEA LIST] with each selected idea (name + concept sentence, one per line), and replace [PROJECT_CONTEXT] with the PROJECT_CONTEXT string extracted from project context above.

**Outer agent**
Description: `"Feasibility pass"`
Prompt (substitute [IDEA LIST] and [PROJECT_CONTEXT] before sending):

===BEGIN OUTER AGENT PROMPT===

You are orchestrating an engineering feasibility pass for product feature ideas.

Product context: [PROJECT_CONTEXT]

Selected ideas:
[IDEA LIST]
(Format: Idea Name — one sentence concept)

For each selected idea, spawn 3 evaluator agents. If multiple ideas are selected, spawn ALL agents for ALL ideas in a SINGLE Agent tool call message with run_in_background: true. Do not sequence by idea.

Engineer agent (per idea):
Description: "Engineer feasibility — [IDEA NAME]"
Prompt: You are evaluating the implementation feasibility of a feature idea. Product context: [PROJECT_CONTEXT]. Idea: [IDEA NAME] — [IDEA CONCEPT]. Assess: What implementation complexity does this introduce? What already exists in the codebase that could support this? What would need to be built from scratch? Are there platform or architectural constraints that affect viability? State: LOW / MEDIUM / HIGH implementation complexity, then one sentence of rationale. Output: Complexity: [LOW/MEDIUM/HIGH] — [one sentence]

QA agent (per idea):
Description: "QA feasibility — [IDEA NAME]"
Prompt: You are evaluating the QA and invariant risk of a feature idea. Product context: [PROJECT_CONTEXT]. Idea: [IDEA NAME] — [IDEA CONCEPT]. Assess: What must not break if this is implemented? What existing behavior is at risk? What edge cases need test coverage? State 2–3 specific invariants to protect, drawn from the product context invariants. Output: What must not break: [2–3 invariants, one per line]

Heurist agent (per idea):
Description: "Heurist feasibility — [IDEA NAME]"
Prompt: You are evaluating the usability and interaction friction of a feature idea. Product context: [PROJECT_CONTEXT]. Idea: [IDEA NAME] — [IDEA CONCEPT]. Assess: Does the interaction model implied by this idea have friction? Where would users get confused or stuck? Does it match the mental models the product establishes? If underspecified, flag explicitly. Output: Heuristic concerns: [specific concern, or "None identified"]

After all agents complete — compile per idea:

[Idea Name]
Complexity: [LOW/MEDIUM/HIGH] — [one sentence]
What must not break: [2–3 invariants]
Heuristic concerns: [or "None identified"]

Return the compiled feasibility data for all ideas as your complete output.

===END OUTER AGENT PROMPT===

When the outer agent completes and returns the compiled feasibility data, proceed to Step 7.

---

> **⏸ PAUSE — Model switch required.**
> Feasibility data collected. Switch to **[OPUS]** (`claude-opus-4-6`) for DE verdict.
> Reply **"continue"** when ready.

---

## [OPUS] Step 7 — DE Verdict

The Distinguished Engineer evaluates each selected idea against the feasibility data.

For each idea, deliver a verdict:

**PROTOTYPE** — feasibility is low-risk, interaction model is clear, this should be built in Canvas immediately.

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
[/solve if the core concept needs convergence first]
[/design if the interaction model is ready to be designed]
[/prototype if PROTOTYPE verdict — build in the prototype environment immediately]

### Deferred ideas
[Any ideas with DEFER verdict and what would need to change to reconsider]
```

If no ideas clear feasibility, report honestly. Do not force a recommendation. State what the ideation revealed about the problem and what would need to be different for ideas to clear.
