---
description: Run the critique workflow on an artifact. Spawns all nine design discipline specialists in parallel — Critic, Heurist, Accessibility, Visual Designer, Typesetter, Materialist, Writer, Choreographer, Mark Maker — and synthesizes their findings. If the findings exceed a tension threshold, prompts to run a debate round where each specialist responds to the others. Improvement-focused: surfaces what to fix, not whether to ship. For a ship gate, use /studio:review.
argument-hint: "<artifact to critique — design, spec, implementation, or combination>"
---

Run the critique workflow on an artifact.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## What this skill does

Nine design discipline specialists review the artifact independently in a silent first pass. If the findings cross a tension threshold, the skill offers a debate round — each specialist sees what the others found and responds: agreeing, pushing back, or building. In a real design studio, the argument is the mechanism that forces latent design decisions into the open.

No verdict is rendered. This is an improvement pass, not a ship gate. Use `/studio:review` when a ship decision is needed.

---

## Step 1 — Context load

Load project context: `.claude/memory/project-context.md`; if not found, check `memory/project-context.md`; if absent, read `CLAUDE.md` for product context.

Load the artifact. If file paths are provided, read them. If a description is provided, confirm you have enough context to proceed.

Determine the design phase — this governs how all nine specialists frame their findings:

- **Exploratory** — work is a sketch, direction, or early iteration. Structural and conceptual findings take priority. Craft details are noted but flagged as premature to resolve. The question is whether the direction is right.
- **In progress** — work is actively being designed. Full critique at design standard. Precision on craft is expected. Findings should be specific enough to act on.
- **Production** — work is live or pre-ship. Full critique at production standard. Every finding carries an additional lens: cost of change. Findings that require breaking redesigns are surfaced differently from targeted fixes. Accessibility, token compliance, and copy are held to shipping standard.

If the phase is not stated in the arguments or clear from context, ask before proceeding.

State what was loaded, the phase, and confirm the artifact before proceeding.

---

> **⏸ PAUSE — Confirm artifact and phase.**
> Context loaded. Confirm the artifact (or provide file paths / additional context) and the design phase: **exploratory**, **in progress**, or **production**.
> Reply **"confirmed"** or clarify.

---

## Step 2 — Round 1: Silent critique (parallel background agents)

Spawn all nine discipline specialists simultaneously with `run_in_background: true`.

Pass to each agent: the artifact description, file paths, project context (governing principle, invariants, brand), and the design phase.

**Phase framing to include in every brief:** "The design phase is [PHASE]. Calibrate accordingly: exploratory = structural/conceptual findings, deprioritize craft precision; in progress = full findings at design standard; production = full findings at shipping standard, and name the cost-of-change implication for any finding that requires a breaking redesign."

Every discipline fires. A specialist with nothing to flag in their domain says so briefly — they still show up.

---

**Critic**
Brief: "You are the Critic in a design critique (Round 1 — silent pass). Apply the Critic discipline. Evaluate against the project's governing principle and ethos from the provided context. For every element, ask: is this necessary? Is this in its simplest correct form? Does this add complexity without value? List everything that should be removed or simplified, with a one-sentence rationale for each. If nothing should be removed, say so."

**Heurist**
Brief: "You are the Heurist in a design critique (Round 1 — silent pass). Apply the Heurist discipline. Evaluate against canonical heuristics (Nielsen, Tognazzini), Apple HIG, and AI interaction guidelines where relevant. Name broken mental models, invisible friction, gesture dead-ends, and any AI behavior that erodes trust. Rate each finding P0–P3. If no violations, say so."

**Accessibility**
Brief: "You are the Accessibility specialist in a design critique (Round 1 — silent pass). Apply the Accessibility discipline. Evaluate against WCAG 2.1 AA. Calculate or estimate contrast ratios; name the specific ratio and the threshold it must meet. Verify tap target sizes against the 44pt minimum. Check screen reader labels and reduce-motion alternatives. Name the specific WCAG criterion for each finding. If no issues, say so."

**Visual Designer**
Brief: "You are the Visual Designer in a design critique (Round 1 — silent pass). Apply the Visual Designer discipline. Evaluate spacing, proportion, alignment, and visual weight distribution. State current values and target values — no directional language. Give the structural reason for each correction in one sentence. If no issues, say so."

**Typesetter**
Brief: "You are the Typesetter in a design critique (Round 1 — silent pass). Apply the Typesetter discipline. Evaluate the type system: scale, hierarchy, weight, and rhythm. Name the structural role each text level serves and whether it serves it. Use token names where the project's design system defines them — no raw pt/px values when tokens exist. If the artifact contains no typography, note it briefly."

**Materialist**
Brief: "You are the Materialist in a design critique (Round 1 — silent pass). Apply the Materialist discipline. Name the material language of the interface first — what material is this made of? Then evaluate individual surface decisions against that model. Name incoherence (mixed models) separately from surface-level corrections. If the artifact has no surface qualities to evaluate, note it briefly."

**Writer**
Brief: "You are the Writer in a design critique (Round 1 — silent pass). Apply the Writer discipline. Evaluate all language in the interface: microcopy, labels, empty states, system messages, VoiceOver strings. Identify copy that is vague, punishing, off-voice, or inconsistent. Quote the specific copy and state what is wrong with it. If the artifact contains no language, note it briefly."

**Choreographer**
Brief: "You are the Choreographer in a design critique (Round 1 — silent pass). Apply the Choreographer discipline. Evaluate motion and transitions: timing, easing, sequencing, rhythm. For each animation, name whether it is earned (communicates something the user would otherwise misunderstand) or gratuitous. If the artifact contains no motion, note it briefly."

**Mark Maker**
Brief: "You are the Mark Maker in a design critique (Round 1 — silent pass). Apply the Mark Maker discipline. Evaluate any marks present — wordmarks, symbols, icons, monograms — against reduction, legibility at minimum scale, and coherence with the brand system. If the artifact contains no marks, note it briefly."

---

Wait for all nine agents to complete. You will receive one notification per agent.

---

## Step 3 — Round 1 synthesis + tension assessment

Collect all nine findings. Produce the Round 1 output (format below).

Then assess the tension threshold. Check all three signals:

1. **Volume** — total distinct findings (disciplines with substantive findings, not "nothing to flag") exceeds 8
2. **Convergence** — 2 or more disciplines flag the same element or surface from different angles
3. **Critic tension** — Critic recommends removal of something another discipline recommends improving (implicit disagreement about whether the element should exist at all)

If any signal fires, the debate round is available. State which signal(s) fired and what tensions a second round would likely resolve.

---

## Round 1 output

```
# Critique: [Artifact Name] — Round 1
Date: [today]
Phase: [Exploratory / In Progress / Production]

## Convergences
[Elements flagged by two or more disciplines. If none, omit.]

---

## Critic
[Findings — or "Nothing to remove."]

## Heurist
[Findings with severity (P0–P3) — or "No violations found."]

## Accessibility
[Findings with WCAG criterion — or "No issues found."]

## Visual Designer
[Findings with current → target values — or "No issues found."]

## Typesetter
[Findings — or "No issues found."]

## Materialist
[Findings — or "No issues found." / "No surface qualities to evaluate."]

## Writer
[Findings — or "No issues found." / "No language present."]

## Choreographer
[Findings — or "No issues found." / "No motion present."]

## Mark Maker
[Findings — or "No issues found." / "No marks present."]

---

## Triage

**Address now:**
[P0 findings + blocking incoherence]

**Address before ship:**
[Craft corrections, copy, visual polish]

**Consider:**
[Judgment calls]
```

---

> **⏸ PAUSE — Tension threshold [MET / NOT MET].**
>
> *If threshold NOT MET:* Round 1 is complete. Reply **"done"** to close, or ask follow-up questions.
>
> *If threshold MET:* [State which signal(s) fired. Name 1–2 specific tensions a debate round would likely resolve — e.g., "Critic recommends removing the secondary action; Writer recommends rewriting it. A debate round would force the question of whether it should exist at all."] A debate round will have each specialist respond to the others' findings.
> Reply **"debate"** to run it, or **"done"** to close with Round 1.

---

## Step 4 — Round 2: Debate (parallel background agents)

*Run only if the user replies "debate."*

Spawn all nine discipline specialists again simultaneously with `run_in_background: true`.

Pass to each agent: the artifact, project context, design phase, AND the full Round 1 findings from all disciplines.

---

**Critic**
Brief: "You are the Critic in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where another discipline recommends improving something you flagged for removal, state your position clearly — removal or improvement are different paths and only one is correct. Where another finding reveals something you missed, acknowledge and extend it. Keep each response to two sentences."

**Heurist**
Brief: "You are the Heurist in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where a craft finding (typography, spacing, material) has a usability consequence the other specialist didn't name, name it. Where another finding contradicts your usability assessment, state why your read holds or where you concede. Keep each response to two sentences."

**Accessibility**
Brief: "You are the Accessibility specialist in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where a proposed improvement (visual, typographic, motion) would create or resolve an accessibility issue, name it. WCAG criteria are not negotiable — state that clearly where another discipline's fix would introduce a violation. Keep each response to two sentences."

**Visual Designer**
Brief: "You are the Visual Designer in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where a typographic, material, or motion finding has a spacing or proportion consequence, name the specific value impact. Where another finding proposes a change that introduces visual imbalance, state it with the specific value. Keep each response to two sentences."

**Typesetter**
Brief: "You are the Typesetter in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where a visual, material, or copy finding intersects with the type system, name the structural consequence. Where another discipline proposes a fix that would break the type hierarchy, state why. Keep each response to two sentences."

**Materialist**
Brief: "You are the Materialist in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where another discipline's finding implies a material decision that hasn't been named, name it. Where a proposed change would introduce material incoherence, state what model it violates. Keep each response to two sentences."

**Writer**
Brief: "You are the Writer in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where the Critic flags removal of a UI element that carries necessary language, make the case for whether the language can move or must go with the element. Where another finding would affect copy, name the copy consequence. Keep each response to two sentences."

**Choreographer**
Brief: "You are the Choreographer in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where a structural or material change would affect motion, name the motion consequence. Where a proposed removal would eliminate a transition that is doing necessary communicative work, state what that work is. Keep each response to two sentences."

**Mark Maker**
Brief: "You are the Mark Maker in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Your task: respond to the other findings. Where another finding would affect a mark's legibility, coherence, or brand integrity, state it precisely. Where a proposed change would improve or harm a mark's reduction, name it. Keep each response to two sentences."

---

Wait for all nine agents to complete.

---

## Step 5 — Final synthesis

Produce the final output. Track the state of each significant finding across both rounds.

```
# Critique: [Artifact Name] — Final
Date: [today]
Phase: [Exploratory / In Progress / Production]

## What hardened
[Findings that survived challenge or were strengthened by the debate. These are the most credible findings.]

## What changed
[Findings that were revised, qualified, or reversed through the debate.]

## Unresolved tensions
[Points where disciplines remain in genuine disagreement. These are unresolved design decisions — not findings, but decisions that need to be made before the work can proceed. Name what each tension requires the team to decide.]

---

## Full findings (updated)

[Repeat the per-discipline section format from Round 1, updated to reflect the debate. Mark changed findings with (revised). Mark hardened findings with (confirmed).]

---

## Triage

**Address now:**
[P0 findings + blocking incoherence + any unresolved tension that blocks downstream work]

**Address before ship:**
[Craft corrections, copy, visual polish]

**Consider:**
[Judgment calls]

**Decide (unresolved tensions):**
[Each tension as a decision question — one sentence each.]
```

Report findings only. Do not make changes unless explicitly asked after the report.
