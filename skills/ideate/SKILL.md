---
description: "Divergent directions before committing. Produces an ideation output (HTML) with named directions, each with a forcing tradeoff."
argument-hint: "<problem statement or opportunity area>"
artifact: ideation-output
---

Divergent brainstorm for a product problem or opportunity.

Arguments: $ARGUMENTS

**Parallel agents:** Step 2 and Step 6 each use an outer background agent. Inner parallelism is managed within the outer agent — you receive one notification per phase, not one per inner agent. The outer agent is an execution detail; the graph below declares the logical fan-out.

**Six Functions (see CLAUDE.md).** Ideate is an artifact-producing workflow and is governed by the six-function floor (`evals/six-functions.map`). The graph covers all six: framing (architect, strategist), generation (designer), craft (writer, choreographer), reduction (critic), usability (heurist), and the Gate (cd — the ship verdict rendered on the final directions before the artifact renders).

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

Auto-mode defaults for the surviving human nodes:

- `confirm` node: proceed with the gate-passing problem statement as framed. A solution-shaped input still stops the run — that is the `problem` gate, not the pause.
- `select` node: take the Creative Director's recommended 2–3 ideas from the reduction; state this in the "Auto-mode decisions" section.
- `pick` node: take the DE-cleared ideas (PROTOTYPE or INVESTIGATE, max 2); if all ideas are DEFER, stop and surface the diagnosis.

---

## Graph

This skill's topology. The prose steps below are the executable instructions; this block is the contract they must match (see `memory/orchestration.md`). Where the Workflow tool is available, execute via `workflow.js`; the graph is the contract either way.

```graph
skill: ideate
cost: high — one blind fan-out of 7 lens agents, one blind fan-out of 3 evaluators × selected ideas
nodes:
  context        task:project context + PM brief check
  problem        gate:problem-shaped — refuse solutions-in-disguise
  confirm        human decides:problem-framing
  fan            task:brief the seven lenses from shared inputs only
  historian      agent:historian
  designer       agent:designer
  architect      agent:architect
  scout          agent:scout
  marketer       agent:marketer
  writer         agent:writer
  choreographer  agent:choreographer
  ideas          join
  strategist     agent:strategist
  critic         agent:critic
  reduce         agent:cd owner:idea-cards
  desirability   task:synthetic-user desirability signal per surviving idea
  select         human decides:path
  feas-fan       task:brief the three evaluators per selected idea from shared inputs only
  engineer       agent:engineer
  qa             agent:qa
  heurist        agent:heurist
  feasibility    join
  verdict        agent:de owner:feasibility-verdicts
  pick           human decides:direction
  ship-gate      gate:cd — verdict on the final 1–2 directions
  slop           gate:slop — seven markers of /studio:studio-slop
  emit           task:render ideation-output HTML
edges:
  context -> problem
  problem -> confirm
  confirm -> fan
  fan -> {historian, designer, architect, scout, marketer, writer, choreographer}
  {historian, designer, architect, scout, marketer, writer, choreographer} -> ideas
  ideas -> strategist -> critic -> reduce -> desirability -> select
  select -> feas-fan
  feas-fan -> {engineer, qa, heurist}
  {engineer, qa, heurist} -> feasibility
  feasibility -> verdict
  verdict -> pick   if:any-cleared
  pick -> ship-gate -> slop -> emit
```

Both fan-outs are **blind**: members are briefed from the shared inputs only and never see each other's unfinished output — that independence is what produces genuine disagreement. The `ideas` and `feasibility` joins preserve dissent: where lenses or evaluators conflict, the conflict travels forward named, never averaged away (see Consensus Laundering, `memory/anti-patterns.md`). The evaluator fan-out runs the three evaluator nodes once per selected idea. If all ideas are DEFER at `verdict`, the run stops with a diagnosis — there is no edge onward.

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `decisions/` by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

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
**Creative Director:** Quality bar and taste. Chairs the facilitated reduction and renders the ship verdict.
**Engineer:** Implementation complexity and feasibility.
**QA:** What must not break.
**Heurist:** Interaction concerns, mental model friction.
**DE (Distinguished Engineer):** Structural risk. Final feasibility verdict.

---

## Step 0.5 — PM brief check (`context` node)

Before ideation begins: check for a validated product brief.

Look for briefs in `specs/product_brief_*.md` or the brief path defined in CLAUDE.md. If one exists for this problem, load it — the validated problem statement, customer context, and success definition it contains sharpen the ideation space and prevent generating solutions to the wrong problem.

If no brief exists, note it. Ideation can proceed — but flag it:
> **No PM brief found.** Ideation is running against an unvalidated problem. Results may need re-anchoring once the customer problem is defined. To run problem validation first: `/pm [problem statement]`.

---

## Step 1 — Problem Gate (`problem` node)

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
If `decisions/` exists, read it to identify any prior decisions that constrain or have already addressed this problem space. Note them. Do not repeat work already done.

State in one sentence: what is the core problem or opportunity? What does a good solution need to accomplish?

Capture this as **[PROBLEM]** — you will embed it verbatim into the outer agent prompt in Step 2.

---

> **⏸ PAUSE (skipped in --auto) — Confirm the problem framing.** (`confirm` node — decides: problem-framing)
> [State the one-sentence problem statement and what a good solution needs to accomplish.]
> This framing guards the whole run — every lens, reduction, and verdict downstream inherits it.
> Reply **"continue"** to proceed with this framing, or restate it.

---

## Step 2 — Divergence (outer background agent)

Spawn ONE outer background agent with `run_in_background: true`. This agent orchestrates all 7 discipline lenses internally, compiles the raw idea list, and returns it. You will receive one notification when divergence is complete.

The lens fan-out is **blind**: each inner agent is briefed from [PROBLEM] and [PROJECT_CONTEXT] only and never sees another lens's output.

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

The `ideas` join waits for **all** seven lenses. If a lens agent fails, report it by node id with the inputs it was given and note its lens as missing in the output — never silently synthesize around the hole (see Failure reporting, `memory/orchestration.md`).

When the outer agent completes and returns the compiled list, state "`ideas` join complete — N ideas from 7 lenses" as a status line and proceed to Step 3. Do not pause.

---

## Step 3 — Facilitated Reduction (`strategist` → `critic` → `reduce` nodes)

The Creative Director chairs this step. Strategist and Critic participate.

**Strategist pass** (`strategist` node)
For each raw idea: does this strengthen the product's core value proposition? Does it improve long-term value for users, or does it add complexity for its own sake? Mark each: FITS / TENSIONS / OUTSIDE.

Eliminate any idea marked OUTSIDE. Flag TENSIONS ideas for Critic scrutiny.

**Critic pass** (`critic` node)
Of the remaining ideas: what is redundant (two ideas solving the same problem)? What is decorative (adds surface without structural value)? What is premature (solves a problem the product doesn't have yet)?
Eliminate aggressively. Be ruthless — weak ideas waste the user's time.

**Creative Director — selection to 3–5** (`reduce` node — owner of the idea cards)
From what survives: select the strongest 3–5 ideas. Fewer is acceptable if the quality bar isn't met — do not pad to reach 5. Apply taste. Ask for each:
- Is this conceptually distinct from the others?
- Is there something genuinely interesting here — a non-obvious angle?
- Would this feel inevitable if done well?

Eliminate the redundant, the obvious, and the forgettable. Where Strategist and Critic disagreed about an idea, keep the disagreement named on its card path — dissent travels forward; it is not averaged away.

Also mark which 2–3 of the survivors the Creative Director would take to feasibility — this is the auto-mode default for the `select` node.

**Format each surviving idea as an idea card:**

```
**[Name]**
Concept: [one sentence — what this is]
Differentiator: [what makes this non-obvious — why isn't this the first thing anyone would try?]
Risk: [the one thing most likely to kill this idea]
```

State "Reduction complete — N idea cards" as a status line and proceed. Do not pause.

---

## Step 4 — Synthetic User Desirability (`desirability` node)

Evaluate the surviving ideas against synthetic user personas.

**Loading personas:** If user personas are defined in CLAUDE.md or in a project artifacts file (e.g., `specs/personas*.md`), load and use them. Otherwise, generate 3 concise personas from the problem statement — one power user deeply invested in the core workflow, one casual user who engages episodically, and one user at a transition point (e.g., returning after time away, or discovering the product anew). Name each briefly and capture their primary goal in one sentence.

**Output: desirability signal per idea**
Three sentences per idea, no more: (1) which persona it lands with and why, (2) whether the problem is real for them or projected, (3) how they would describe it to someone else. Keep output comparable across all ideas.

Note any ideas that don't land with any persona — flag for elimination consideration.

State "Desirability signal complete" as a status line and proceed. Do not pause.

---

## Step 5 — Your Selection (`select` node)

Present the idea cards with desirability notes beneath each, in this format:

```
**[Name]**
Concept: [one sentence]
Differentiator: [one sentence]
Risk: [one sentence]

Desirability: [three sentences from Step 4]
```

---

> **⏸ PAUSE (skipped in --auto) — Select ideas for feasibility.** (`select` node — decides: path)
> Select 2–3 ideas to take to feasibility.
> Which ideas interest you, and why? Your stated preference will shape how the feasibility pass evaluates them.

---

## Step 6 — Feasibility Pass (outer background agent)

Spawn ONE outer background agent with `run_in_background: true`. This agent runs all 3 evaluators (Engineer, QA, Heurist) for all selected ideas in parallel and returns compiled per-idea feasibility data. You will receive one notification when complete.

The evaluator fan-out is **blind**: each evaluator is briefed from the selected ideas and [PROJECT_CONTEXT] only and never sees another evaluator's output.

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

The `feasibility` join waits for **all** evaluators across all selected ideas. If an evaluator agent fails, report it by node id with the inputs it was given and note its evaluation as missing in the output — never silently synthesize around the hole (see Failure reporting, `memory/orchestration.md`).

When the outer agent completes and returns the compiled feasibility data, state "`feasibility` join complete" as a status line and proceed to Step 7. Do not pause.

---

## Step 7 — DE Verdict (`verdict` node — owner of the feasibility verdicts)

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

If all selected ideas receive DEFER: state clearly whether (a) the problem statement needs reframing — the ideation explored the wrong space — or (b) Step 2 should re-enter with a modified constraint. Do not proceed further in this case; surface the diagnosis and stop.

---

## Step 8 — Direction Pick (`pick` node)

Present the cleared ideas (PROTOTYPE or INVESTIGATE) with their verdicts and desirability notes.

---

> **⏸ PAUSE (skipped in --auto) — Pick the final direction(s).** (`pick` node — decides: direction)
> Pick the 1–2 directions that ship in the ideation output.
> The Creative Director's gate and the artifact cover only what you pick; the rest is recorded as deferred.

---

## Step 9 — Creative Director Gate (`ship-gate` node)

The cd agent renders the final verdict on the picked 1–2 directions before the artifact ships — the sixth function, the Gate. For each direction, ask: is it conceptually inevitable, distinct from the other, and worth the next phase's spend? The verdict synthesizes the whole run — divergence, reduction, desirability, feasibility, DE verdict — and includes a dissent ledger: which lens or evaluator disagreed, with what, and why it was overruled.

- **SHIP** — the direction proceeds into the artifact.
- **NO-SHIP** — the run stops with named defects; state what must change before re-entry. The artifact does not ship on consensus or fatigue.

---

## Step 10 — Slop Gate (`slop` node)

Before rendering, run the seven markers of `/studio:studio-slop` against the assembled ideation output. Any marker that fires is fixed before emission — the quality floor is a structural property of the graph, not an opt-in pass.

---

## Exit

Present the shipped directions:

```
## Ideation Result: [Problem Statement]
Date: [today]

### Directions cleared to ship
[The 1–2 picked directions with SHIP verdict]
[Brief framing of what each direction is, why it cleared, and the CD's one-line verdict rationale]

### Recommended next step
[/solve if the core concept needs convergence first]
[/design if the interaction model is ready to be designed]
[/prototype if PROTOTYPE verdict — build in the prototype environment immediately]

### Deferred ideas
[Any ideas with DEFER verdict — or unpicked at Step 8 — and what would need to change to reconsider]
```

If no ideas clear feasibility, or the CD gate returns NO-SHIP, report honestly. Do not force a recommendation. State what the ideation revealed about the problem and what would need to be different for directions to clear.

---

## Output

Render the artifact as HTML using the kit template.

1. Load `artifacts/templates/ideation-output.html` as the structural shell.
2. Populate the artifact-specific fields: problem statement, shipped directions (1–2 with the CD verdict, desirability and feasibility summary), recommended next step, deferred ideas with conditions for reconsideration.
3. Write to `specs/ideation_<slug>.html` where slug is derived from the problem statement (lowercase kebab-case, max 40 chars).
4. Surface a short markdown summary in conversation:
   - File path
   - One-sentence headline
   - Shipped direction names and verdicts
5. Offer: "Run `/studio:annotate <file-path>` to attach the feedback harness."

If `--text` is in $ARGUMENTS, skip HTML emission and present the markdown summary as the full output.
