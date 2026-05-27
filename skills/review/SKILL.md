---
description: "Run a full Leadership Team review — PM, Design Director, and Distinguished Engineer — against an artifact. Produces a combined verdict with convergence notes and a single prioritized next action. If LT members produce conflicting positions on the same element, prompts to run a debate round. Use at meaningful gates: shipping a significant feature, handing a design to engineering, or any directional product decision."
argument-hint: "<artifact to review — spec, design, implementation, or combination>"
---

Run a full Leadership Team review against an artifact.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## What this skill does

Three senior gates review the artifact independently from their distinct mandates:

- **PM** — problem-solution fit: is this still solving the validated problem?
- **CD** — design quality: is this crafted well enough to ship?
- **DE** — implementation soundness: is this built correctly? *(only if implementation exists)*

Each delivers its own verdict with routing recommendations. The synthesis produces a combined verdict, surfaces convergences, and cascades to a single next action.

If two or more members produce conflicting positions on the same element — one passing, one blocking; or convergent flags with incompatible routing — the skill offers a debate round to force the decision into the open. The cascade rule (PM > CD > DE) handles unrelated drift; the debate round handles same-element disagreement.

This is a heavyweight review. Use it at gates that warrant all three perspectives. For incremental work, invoke the relevant LT member directly.

---

## Step 1 — Artifact classification and phase

Load project context: `.claude/memory/project-context.md`. If this file does not exist, read `CLAUDE.md` for product context instead.

Classify the artifact:
- **Problem brief or direction** — PM reviews. CD if design thinking is present. DE not applicable.
- **Design artifact** (interaction model, visual design, spec) — PM + CD review. DE not applicable unless spec is complete and implementation imminent.
- **Implementation** — all three review. PM checks for drift. CD checks design quality of the shipped surface. DE checks the code.
- **Combination** — determine which members apply to which components.

Determine the phase — this governs how each LT member calibrates:

- **Pre-ship** *(default)* — full ship gate. Verdicts carry full weight. SHIP means ready to merge / launch / hand off.
- **Checkpoint** — review used during active design or build. Verdicts frame as "ready to advance" rather than "ready to ship." Findings inform direction; no merge / launch / handoff occurs at this gate.
- **Post-ship audit** — reviewing live work. Findings carry an additional cost-of-change lens: name whether the fix is a targeted change or requires a breaking redesign.

If the phase is not stated and not clear from context, ask before proceeding.

Load the PM brief if one exists (`artifacts/product_brief_*.md` or equivalent in the project). Surface it to all agents as context.

State the classification, the phase, and which LT members will review before proceeding.

---

> **⏸ PAUSE — Confirm scope and phase.**
> Classification complete. Confirm which LT members should review and the phase (**pre-ship**, **checkpoint**, or **post-ship audit**), and provide any additional artifact context (file paths, spec location, relevant decisions).
> Reply **"confirmed"** or adjust.

---

## Step 2 — LT reviews (parallel background agents)

Spawn applicable LT agents simultaneously with `run_in_background: true`.

**Phase framing to include in every brief:** "The review phase is [PHASE]. Calibrate accordingly: pre-ship = full ship gate, verdicts carry full weight; checkpoint = frame verdicts as 'ready to advance' not 'ready to ship', findings inform direction; post-ship audit = name cost-of-change for any finding (targeted fix vs. breaking redesign)."

**PM agent** *(always)*
Brief: "You are the PM in an LT Review. Your mandate: evaluate whether the solution is still solving the validated problem. Check for drift from the PM brief (provided). Deliver your Four Moves assessment focused on problem-solution fit. Apply your Specialist Network — name any specialist that should be engaged to resolve a gap. Use the PM output format."

**CD agent** *(if design artifact exists)*
Brief: "You are the Design Director in an LT Review. Your mandate: evaluate design quality and deliver a SHIP / NO-SHIP verdict. Apply your Specialist Routing — name the specific specialist or skill for each issue. Do not route everything to `/design`; calibrate to scope. Use the CD output format."

**DE agent** *(if implementation exists)*
Brief: "You are the Distinguished Engineer in an LT Review. Your mandate: evaluate implementation soundness and deliver a SHIP / REVISE / REJECT verdict. Apply your Specialist Network — name the specialist for each required change. Use the DE Code Review output format."

Pass to each agent: artifact description, file paths, PM brief (if loaded), project context, and the phase framing.

Wait for all agents to complete. You will receive one notification per agent.

## Step 3 — Synthesis and conflict assessment

Synthesize all LT verdicts into one output. Do not repeat full verdicts — extract positions, find convergences, cascade to a single next action.

**Combined verdict logic:**
- **SHIP** — all applicable members pass
- **REVISE** — one or more requires a change; each routing recommendation stands
- **HOLD** — PM flags drift or missing brief; CD/DE verdicts noted but subordinate until PM resolves
- **REJECT** — structural problem requiring restart; name which member flagged it and why

**Cascade priority for next action:** PM > CD > DE. If PM flags drift, that is the only next action regardless of CD/DE verdicts — resolving drift may invalidate their findings entirely.

**Convergence:** When two or more members flag the same surface, name it explicitly. Convergence across mandates is a strong signal.

**Conflict assessment.** Check three signals:

1. **Split verdict on same element** — one member passes an element another blocks. Not orthogonal concerns — direct disagreement about the same surface.
2. **Convergent flags with incompatible routing** — two members flag the same element but propose mutually exclusive fixes (one says remove, the other says rework).
3. **Dependent verdicts** — one member's PASS depends on resolving what another sees as a blocker, but they have not engaged with each other's reasoning.

If any signal fires, the debate round is available. The cascade rule alone silences these conflicts rather than resolving them.

---

## Round 1 output format

```
## LT Review: [Artifact Name] — Round 1
Date: [today]
Phase: [Pre-ship / Checkpoint / Post-ship audit]

**Combined verdict:** SHIP / REVISE / HOLD / REJECT

---

**PM:** [2–3 sentences. Problem-solution fit verdict. READY or HOLD.]
**CD:** [2–3 sentences. Design quality verdict. SHIP or NO-SHIP. Omit if not applicable.]
**DE:** [2–3 sentences. Implementation verdict. SHIP / REVISE / REJECT. Omit if not applicable.]

---

**Convergences:**
[Where two or more members flag the same issue. If none, omit this section.]

---

**Routing:**
[Each required change with the specialist or skill that resolves it, in cascade priority order. PM issues first, then CD, then DE. Format: Issue → Specialist/Skill → then what.]

---

**Next action:**
[Single most important thing. Names who does it. One sentence. PM issues take priority over all others.]
```

---

> **⏸ PAUSE — Conflict threshold [MET / NOT MET].**
>
> *If threshold NOT MET:* Round 1 is complete. Reply **"done"** to close, or ask follow-up questions.
>
> *If threshold MET:* [State which signal(s) fired. Name the specific element(s) in conflict and what the disagreement is — e.g., "CD says SHIP on the secondary action; PM says HOLD because it serves a problem outside the validated scope. The disagreement is about whether the action belongs at all."] A debate round will have each LT member respond to the others' positions.
> Reply **"debate"** to run it, or **"done"** to close with Round 1.

---

## Step 4 — Debate round (parallel background agents)

*Run only if the user replies "debate."*

Spawn all applicable LT members again simultaneously with `run_in_background: true`.

Pass to each agent: the artifact, project context, phase, AND the full Round 1 verdicts and routing from all LT members.

---

**PM (debate)**
Brief: "You are the PM in an LT Review (Round 2 — debate). You have the Round 1 verdicts from all LT members. Your task: respond to the other positions. Where CD or DE recommends action on something you flagged as out of scope, restate whether the action serves the validated problem or extends it. Where another member's blocker depends on a problem you have not validated, name that. Where their concern reveals a problem in your validation that you missed, acknowledge it. Keep each response to two sentences."

**CD (debate)**
Brief: "You are the Design Director in an LT Review (Round 2 — debate). You have the Round 1 verdicts from all LT members. Your task: respond to the other positions. Where PM flags drift that affects design intent, state whether the design assumes a different problem than the one PM validated. Where DE's implementation concern reveals a craft consequence (e.g., a constraint that would degrade the design), name it. Where another member proposes a change that would compromise design integrity, state precisely what would break. Keep each response to two sentences."

**DE (debate)**
Brief: "You are the Distinguished Engineer in an LT Review (Round 2 — debate). You have the Round 1 verdicts from all LT members. Your task: respond to the other positions. Where PM or CD proposes a change with implementation consequence (cost, durability, invariant impact), name it precisely. Where another member's blocker masks a deeper engineering issue, surface it. Where you can support a proposed change that you previously called REVISE/REJECT, state what would change your verdict. Keep each response to two sentences."

---

Wait for all members to complete.

---

## Step 5 — Final synthesis

Produce the final output. Track the state of positions across both rounds.

```
## LT Review: [Artifact Name] — Final
Date: [today]
Phase: [Pre-ship / Checkpoint / Post-ship audit]

**Combined verdict:** SHIP / REVISE / HOLD / REJECT

---

## What hardened
[Positions that survived challenge or were strengthened. These carry the most weight.]

## What changed
[Positions that were revised, qualified, or reversed through the debate.]

## Unresolved tensions
[Points where LT members remain in genuine disagreement. These are unresolved decisions — name what each tension requires the team (or a higher decision-maker) to decide. Phrase each as a question.]

---

**PM (final):** [Updated position if changed; otherwise "Unchanged."]
**CD (final):** [Updated position if changed; otherwise "Unchanged."]
**DE (final):** [Updated position if changed; otherwise "Unchanged."]

---

**Convergences:**
[Where two or more members flag the same issue, post-debate.]

---

**Routing:**
[Updated routing in cascade priority. Mark items as (revised) or (confirmed) where they changed from Round 1.]

---

**Next action:**
[Single most important thing. If unresolved tensions remain, the next action may be a decision rather than work — name the decision and who must make it.]
```

---

## Rules

**Cascade rule.** If PM flags drift, the next action is PM resolution only. Do not list CD or DE next actions until PM passes — they may become irrelevant.

**Debate rule.** The debate round runs only when LT members produce conflicting positions on the same element. It does not run for orthogonal concerns — the cascade rule handles those.

**Scope rule.** Route to the smallest intervention that resolves the issue. A single craft correction goes to the named specialist, not `/design`.

**Convergence rule.** Name convergences explicitly. Two members flagging the same thing is a stronger signal than either alone.

**Applicability rule.** Do not invoke a member who has no artifact to review. PM always reviews. CD reviews if design exists. DE reviews if implementation exists.
