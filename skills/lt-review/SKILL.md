---
description: Run a full Leadership Team review — PM, Design Director, and Distinguished Engineer — against a completed artifact. Produces a combined verdict with convergence notes and a single prioritized next action. Use at meaningful gates: shipping a significant feature, handing a design to engineering, or any directional product decision.
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

This is a heavyweight review. Use it at gates that warrant all three perspectives. For incremental work, invoke the relevant LT member directly.

---

## Step 1 — Artifact classification

Load project context: `.claude/memory/project-context.md` (fallback: `memory/project-context.md`).

Classify the artifact:
- **Problem brief or direction** — PM reviews. CD if design thinking is present. DE not applicable.
- **Design artifact** (interaction model, visual design, spec) — PM + CD review. DE not applicable unless spec is complete and implementation imminent.
- **Implementation** — all three review. PM checks for drift. CD checks design quality of the shipped surface. DE checks the code.
- **Combination** — determine which members apply to which components.

Load the PM brief if one exists (`artifacts/product_brief_*.md` or equivalent in the project). Surface it to all agents as context.

State the classification and which LT members will review before proceeding.

---

> **⏸ PAUSE — Confirm scope.**
> Classification complete. Confirm which LT members should review, and provide any additional artifact context (file paths, spec location, relevant decisions).
> Reply **"confirmed"** or adjust scope.

---

## Step 2 — LT reviews (parallel background agents)

Spawn applicable LT agents simultaneously with `run_in_background: true`.

**PM agent** *(always)*
Brief: "You are the PM in an LT Review. Your mandate: evaluate whether the solution is still solving the validated problem. Check for drift from the PM brief (provided). Deliver your Four Moves assessment focused on problem-solution fit. Apply your Specialist Network — name any specialist that should be engaged to resolve a gap. Use the PM output format."

**CD agent** *(if design artifact exists)*
Brief: "You are the Design Director in an LT Review. Your mandate: evaluate design quality and deliver a SHIP / NO-SHIP verdict. Apply your Specialist Routing — name the specific specialist or skill for each issue. Do not route everything to `/design`; calibrate to scope. Use the CD output format."

**DE agent** *(if implementation exists)*
Brief: "You are the Distinguished Engineer in an LT Review. Your mandate: evaluate implementation soundness and deliver a SHIP / REVISE / REJECT verdict. Apply your Specialist Network — name the specialist for each required change. Use the DE Code Review output format."

Pass to each agent: artifact description, file paths, PM brief (if loaded), project context.

Wait for all agents to complete. You will receive one notification per agent.

## Step 3 — Synthesis

Synthesize all LT verdicts into one output. Do not repeat full verdicts — extract positions, find convergences, cascade to a single next action.

**Combined verdict logic:**
- **SHIP** — all applicable members pass
- **REVISE** — one or more requires a change; each routing recommendation stands
- **HOLD** — PM flags drift or missing brief; CD/DE verdicts noted but subordinate until PM resolves
- **REJECT** — structural problem requiring restart; name which member flagged it and why

**Cascade priority for next action:** PM > CD > DE. If PM flags drift, that is the only next action regardless of CD/DE verdicts — resolving drift may invalidate their findings entirely.

**Convergence:** When two or more members flag the same surface, name it explicitly. Convergence across mandates is a strong signal.

---

## Output format

```
## LT Review: [Artifact Name]
Date: [today]

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

## Rules

**Cascade rule.** If PM flags drift, the next action is PM resolution only. Do not list CD or DE next actions until PM passes — they may become irrelevant.

**Scope rule.** Route to the smallest intervention that resolves the issue. A single craft correction goes to the named specialist, not `/design`.

**Convergence rule.** Name convergences explicitly. Two members flagging the same thing is a stronger signal than either alone.

**Applicability rule.** Do not invoke a member who has no artifact to review. PM always reviews. CD reviews if design exists. DE reviews if implementation exists.
