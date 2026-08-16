---
description: "Convergence loop for hard problems. Iterates perspectives until a recommendation emerges; stops when the argument is settled."
argument-hint: "<hard problem to solve>"
---

Find the essential, categorically right solution to a hard problem.

Arguments: $ARGUMENTS

**Six Functions (see CLAUDE.md).** The solution this loop converges on is a design artifact — it must satisfy all six functions. The graph enforces all six: framing (Architect/context), generation (Design), craft (the conditional sub-team fan-out), reduction (Critic), usability (the Accessibility check on the exit path), and the Gate (CD's verdict, refuted once before it stands).

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

Auto-mode defaults for the surviving human nodes:

- `framing` node: proceed with the one-sentence framing and stated constraints; note them in the "Auto-mode decisions" section.
- `exit-path` node: take the unresolved report's own recommendation (Defer / Escalate / Reframe).

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `decisions/` by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. This skill provides the discipline.

### Disciplines (apply inline)
**Architect:** Data model, system boundaries, scalability, integration points.
**Designer:** Interaction model (states + transitions), visual hierarchy, 2–3 options max, recommend one.
**Critic:** Remove unnecessary features, simplify flows, eliminate decoration. Removal is a form of design.

### Calibration Gate
All five must be YES / YES / YES / NO / YES to exit:
1. Is this necessary?
2. Is this coherent?
3. Is this the simplest correct solution?
4. Would removing something improve it?
5. Is this consistent with everything else in the system?

---

Problem: $ARGUMENTS

---

## Graph

This skill's topology — the repo's canonical bounded evaluator-optimizer. The prose steps below are the executable instructions; this block is the contract they must match (see `memory/orchestration.md`). Where the Workflow tool is available, execute segments via `workflow.js`; the graph is the contract either way.

```graph
skill: solve
cost: medium — sequential convergence loop, max 3 iterations; conditional craft fan-out per iteration
nodes:
  pm-brief      gate:validated-brief-for-product-direction-problems
  framing       human decides:problem-framing-and-constraints
  historian     agent:historian
  architect     agent:architect
  designer      agent:designer owner:solution
  typesetter    agent:typesetter
  choreographer agent:choreographer
  writer        agent:writer
  visual        agent:visual-designer
  craft-join    join
  critic        agent:critic
  marketer      agent:marketer
  cd            agent:cd
  verdict       router(inevitable|not-yet|structurally-wrong|iterations-exhausted)
  refute        agent:critic
  accessibility agent:accessibility
  exit-path     human decides:exit-path
  slop          gate:slop — seven markers of /studio:studio-slop
  emit          task:record the solution or the honest unresolved report
edges:
  pm-brief -> framing -> historian -> architect -> designer
  designer -> {typesetter, choreographer, writer, visual}   if:surface-work
  {typesetter, choreographer, writer, visual} -> craft-join
  designer -> critic   if:no-surface-work
  craft-join -> critic
  critic -> marketer -> cd -> verdict
  verdict -> architect   loop max:3
  verdict -> refute   if:inevitable
  verdict -> exit-path   if:iterations-exhausted
  verdict -> emit   if:structurally-wrong
  refute -> designer   loop max:1
  refute -> accessibility   if:verdict-stands
  accessibility -> slop -> emit
  exit-path -> emit
```

The `verdict -> architect` edge is the NOT YET re-entry, bounded to three iterations total. An INEVITABLE verdict must survive one refutation pass (`refute` — the critic argues the strongest case *against* inevitability; at most one return to the designer) before the accessibility check, the slop gate, and emission. Only the sub-team disciplines the solution requires are spawned; the fan-out is **blind**. Dissents — including a marketer commercial objection the CD overrules — are preserved to the output, never averaged away (see Consensus Laundering, `memory/anti-patterns.md`).

## What this command does

This is a convergence loop, not a single design pass.

Each iteration applies the studio disciplines, evaluates the output against the calibration gate, and either exits with an inevitable solution or identifies exactly what is still wrong and re-enters with that diagnosis as the constraint.

The loop exits when nothing can be removed, clarified, aligned further, or simplified. Not when a solution is acceptable — when it is **inevitable**.

Maximum iterations: 3. If the gate does not pass by iteration 3, the command reports honestly: what remains unresolved, why, and what would need to change for it to pass.

---

## Step 0 — PM brief check

If this is a product direction problem — what to build, who to build for, or what outcome to target — check for a validated PM brief before the loop begins.

Look for `specs/product_brief_*.md`. If one exists for this problem, load it. A validated brief constrains the solution space and makes the convergence loop more precise.

If no brief exists and this is a product direction problem, surface it:

> **Product brief missing.** You are about to run a convergence loop against an unvalidated problem. Consider running `/pm` first to define who has the problem, why it matters, and what success looks like. To proceed without a brief, confirm explicitly.

If this is a structural, architectural, or systems problem — not a customer or product direction problem — skip this step and proceed.

---

## [HAIKU] Before iteration 1 — Context loading

**Check prior work.**
If `decisions/` exists (or the ledger path defined in CLAUDE.md), read the decision files. Has this problem been solved before? Do not repeat work already done.

**Frame the problem precisely.**
State the problem in one sentence. If it cannot be stated in one sentence, it is not ready for solving — decompose it first. Name the tension: what two valid things are in conflict, and why resolving one makes the other harder?

**State the constraints.**
List every constraint that applies: embedded invariants, prior ledger decisions (if available), design laws. These are not negotiable during the loop. If a constraint needs to be challenged, surface it explicitly before the loop begins.

---

> **⏸ PAUSE (skipped in --auto) — Framing.** *(`framing` node — decides: problem-framing-and-constraints)*
> [State the one-sentence problem, the named tension, and every constraint. The framing guards the entire loop — a wrong framing converges on the wrong solution three times.]
> Confirm the framing and constraints, tighten them, or reframe before the loop begins.

---

## Iteration structure

Each iteration follows this sequence on [SONNET], then pauses for [OPUS] judgment.

### 1. Historian pass
What has been tried before on this class of problem? What survived? What failed and why?
Do not invent precedent. Do not generalize. Cite specific examples.

This pass runs once — in iteration 1 only. Do not repeat the Historian pass in iterations 2 and 3.

### 2. Design pass
Apply the Architect and Designer disciplines (embedded above).
Produce the simplest structure that satisfies the stated constraints.
Maximum 2 directions. Recommend one. State why.

If the solution involves a surface (interaction model, visual hierarchy, motion, copy): after the design pass, apply the relevant sub-team disciplines inline — Choreographer for motion, Typesetter for type hierarchy, Writer for language, Visual Designer for visual execution. Do not invoke all four by default; apply only those the solution requires.

### 3. Critic pass — escalating by iteration

Apply the Critic discipline (embedded above).

**Iteration 1:** Remove everything unnecessary. What is left?
**Iteration 2:** Of what remains, what is still not the simplest correct form? Remove again.
**Iteration 3:** Of what remains after two reductions — is every element inevitable? If anything could be different without loss, it is not yet right.

The critic's standard escalates each iteration. By iteration 3, the question is not "is this good?" It is: "would removing or changing anything make this worse?"

---

### 3.5 — Marketer check

Apply the Marketer discipline: commercial pressure test.

The convergence loop produces solutions that are philosophically inevitable. Before the Creative Director evaluates, the Marketer asks whether the solution is also commercially viable.

- Does this solution create something users will find, choose, and pay for?
- Does it differentiate the product or close a table-stakes gap that matters to the market?
- Is the complexity it introduces proportionate to the commercial return?

This is not a veto — the loop continues regardless. But if the solution fails commercially, name it explicitly. A philosophically inevitable solution that no one will use is not yet a solution. The Creative Director's verdict must account for both dimensions.

---

State "Iteration N work complete (`designer` → `marketer` nodes)" as a status line and proceed to the Creative Director evaluation — no pause. Iteration progress is a report, not a decision.

---

### 4. Creative Director evaluation

Apply the embedded ethos and decision hierarchy.

State a verdict: INEVITABLE / NOT YET / STRUCTURALLY WRONG.

- **INEVITABLE:** nothing can be removed, clarified, aligned further, or simplified. Exit the loop. Record the solution.
- **NOT YET:** something remains that is not in its essential form. Name it precisely. State what is wrong and what would make it right. Re-enter the loop.
- **STRUCTURALLY WRONG:** the current direction cannot converge. The problem framing or a constraint is incorrect. Stop. Reframe before continuing.

### 5. Calibration gate

Apply the embedded calibration gate. Answer each question explicitly (YES / NO). All five must pass. Any failure: identify which failed, why, and what must change.

### 6. Refutation (`refute` node — runs only on INEVITABLE, at most once)

An INEVITABLE verdict must survive one adversarial pass before it stands (see Adversarial doctrine, `memory/orchestration.md`). The Critic argues the strongest case **against** inevitability — not a second opinion: what could still be removed, what constraint was quietly relaxed, what alternative was dismissed without being priced. If the refutation succeeds, the verdict downgrades to NOT YET with the named defects (one bounded return to the Designer — it cannot stall the loop further). If it fails, record "Refutation: failed — INEVITABLE stands" and proceed to the exit path: an Accessibility check at production weight (`accessibility` node) if the solution involves a surface, then the slop gate (`slop` node — run the seven markers of /studio:studio-slop against the solution artifact; quote and fix anything that fires) before emission.

---

## Between iterations

If the gate does not pass and iterations remain, state "Verdict: NOT YET — re-entering (iteration N of 3)" as a status line and re-enter — no pause.

State explicitly before re-entering:
- What the previous iteration produced
- What was wrong with it (one sentence per flaw)
- What the next iteration is trying to resolve
- What constraints were tightened

Do not carry forward elements that failed the gate. Each iteration should be a reduction of the prior, not a variation.

---

## Exit: Inevitable Solution

When the calibration gate passes:

```
## Solution: [Problem Name]
Date: [today]
Iterations: [N]

### The essential form
[State the solution. Nothing more than what is necessary to implement it.]

### Why this and not the alternatives
[One sentence per alternative that was considered and rejected. Name what was wrong.]

### What this constrains going forward
[What future decisions does this close off? What does this require?]

### Ledger entry required
[Yes/No — does this decision need to be recorded?]
```

If a ledger entry is required and a ledger path exists (check CLAUDE.md or `decisions/`), write it there before ending the session.

---

## Exit: Unresolved at iteration 3

> **⏸ PAUSE (skipped in --auto) — Exit path.** *(`exit-path` node — decides: exit-path)*
> [Present what was reached, what remains wrong, and what would need to change.]
> Choose: **Defer** (park it, record why) · **Escalate** (a constraint must be challenged — name whose call it is) · **Reframe** (the problem statement is wrong — restate it and re-run).

```
## Unresolved: [Problem Name]
Date: [today]

### What was reached
[The best form found, even if not yet inevitable]

### What remains wrong
[Exactly what is still not in essential form, and why]

### What would need to change
[The specific condition that would allow this to resolve]

### Recommendation
[Defer / Escalate / Reframe — with one sentence rationale]
```

Do not declare a solution when one has not been found. An honest unresolved report is more valuable than a false inevitable.
