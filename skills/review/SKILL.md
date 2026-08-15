---
description: "Leadership team review — PM, CD, and DE gate verdicts in sequence. Produces an LT review (HTML) with combined and member verdicts."
argument-hint: "<artifact to review — spec, design, implementation, or combination>"
artifact: lt-review
---

Run a full Leadership Team review against an artifact.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

Auto-mode default for the `tiebreak` node: resolve via the cascade rule (PM > CD > DE); overruled positions enter the dissent ledger. State this in the "Auto-mode decisions" section.

---

## What this skill does

Three senior gates review the artifact independently from their distinct mandates:

- **PM** — problem-solution fit: is this still solving the validated problem?
- **CD** — design quality: is this crafted well enough to ship?
- **DE** — implementation soundness: is this built correctly? *(only if implementation exists)*

Each delivers its own verdict with routing recommendations. The synthesis produces a combined verdict, surfaces convergences, and cascades to a single next action.

If two or more members produce conflicting positions on the same element — one passing, one blocking; or convergent flags with incompatible routing — the skill offers a debate round to force the decision into the open. The cascade rule (PM > CD > DE) handles unrelated drift; the debate round handles same-element disagreement.

This is a heavyweight review. Use it at gates that warrant all three perspectives. For incremental work, invoke the relevant LT member directly.

## Graph

This skill's topology. The prose steps below are the executable instructions; this block is the contract they must match (see `memory/orchestration.md`). Where the Workflow tool is available, execute via `workflow.js`; the graph is the contract either way.

```graph
skill: review
cost: medium — up to two fan-outs of 3 LT agents plus up to 2 refutation passes (debate and refutation conditional)
nodes:
  scope      gate:artifact-classified-and-phase-confirmed
  fan        task:brief the applicable LT members from shared inputs only
  pm         agent:pm
  cd         agent:cd
  de         agent:de
  verdicts   join
  conflict   router(conflicts|aligned)
  debate     task:re-run applicable LT members with each other's Round 1 verdicts, blind to each other's responses
  tiebreak   human decides:break-the-leadership-tie
  refute-cd  agent:critic
  refute-de  agent:qa
  final      task:final verdict — combined verdict, dissent ledger, refutation outcomes
  emit       task:render lt-review HTML
edges:
  scope -> fan
  fan -> {pm, cd, de}
  {pm, cd, de} -> verdicts
  verdicts -> conflict
  conflict -> debate   if:conflicts
  conflict -> refute-cd   if:aligned-and-cd-ship
  conflict -> refute-de   if:aligned-and-de-ship
  conflict -> final   if:aligned
  debate -> tiebreak   if:still-split
  debate -> refute-cd   if:resolved-and-cd-ship
  debate -> refute-de   if:resolved-and-de-ship
  debate -> final   if:resolved
  tiebreak -> final
  refute-cd -> final
  refute-de -> final
  final -> emit
```

The debate round and each refutation run at most once — bounded by structure, not a counter. The Round 1 fan-out is **blind**: members never see each other's unfinished output. A human tiebreak outranks refutation — once the human rules, the verdict goes to `final` directly. Dissent is preserved through `verdicts` and `final` as a dissent ledger — never averaged away (see Consensus Laundering, `memory/anti-patterns.md`).

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

State the classification, the phase, and which LT members will review as a status line (`scope` node) and proceed. If the phase or classification is genuinely unclear from the arguments and context, ask — that is a clarification, not a checkpoint. Do not pause for confirmation.

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

Pass to each agent: artifact description, file paths, PM brief (if loaded), project context, and the phase framing. The fan-out is **blind** — each member is briefed from these shared inputs only, never from another member's unfinished output.

Wait for all agents to complete. You will receive one notification per agent.

The `verdicts` join waits for **all** applicable members. If an agent fails, report it by node id with the inputs it was given and note its mandate as missing — never silently synthesize around the hole (see Failure reporting, `memory/orchestration.md`).

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

The `conflict` router is mechanical: if any signal fires, run the debate round (Step 4) — state which signal(s) fired and the specific element(s) in conflict as a status line, then proceed; no pause. If no signal fires, proceed to the refutation check (Step 4.5).

---

## Step 4 — Debate round (parallel background agents)

*Run only when the `conflict` router fires. Runs at most once.*

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

If the debate resolves the conflict, proceed to Step 4.5. If the members remain split on the same element after the debate, escalate to the human (`tiebreak` node — decides: break the leadership tie):

> **⏸ PAUSE (skipped in --auto) — Leadership tie.**
> [Name the element, each member's post-debate position, and what ruling each way would mean — enough context to decide without scrolling back.]
> Rule on the tie, or reply **"cascade"** to apply the default precedence (PM > CD > DE).

A human ruling goes directly to the final synthesis — it outranks refutation. Overruled positions enter the dissent ledger.

---

## Step 4.5 — Refutation (conditional, bounded)

A SHIP verdict must survive one adversarial pass before it stands (see Adversarial doctrine, `memory/orchestration.md`). Runs at most once per gate; skipped entirely when a human tiebreak has already ruled.

- **If CD's standing verdict is SHIP** (`refute-cd` node): spawn the **critic** with: "The Design Director has ruled SHIP on this artifact. Your task is to refute that verdict — make the strongest case against shipping, not a second opinion. Name specific defects: what is unresolved, unearned, or incoherent. If you cannot build a credible case, say so plainly."
- **If DE's standing verdict is SHIP** (`refute-de` node): spawn **qa** with the same framing against the implementation — strongest case against merging: untested invariants, missing regression coverage, boundary failures.

If a refutation fails (no credible case), the SHIP stands — record "Refutation: failed — SHIP stands" in the output. If it succeeds, downgrade that member's verdict to REVISE with the named defects as routing items — the refutation cannot stall shipping further; it sends work back once, with specifics.

---

## Step 5 — Final synthesis (`final` node)

Produce the final output. Track the state of positions across both rounds (or the single round, when no debate ran — omit the hardened/changed sections in that case and carry the Round 1 positions forward with the refutation and dissent sections).

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

**Refutation:**
[Outcome of each refutation pass that ran: "failed — SHIP stands" or "succeeded — downgraded to REVISE: <named defects>". Omit if none ran.]

**Tiebreak:**
[The human ruling, if one was made. Omit otherwise.]

**Dissent ledger:**
[Every overruled or unresolved position: which member disagreed, with what, and why it was overruled (cascade, tiebreak, or debate). A verdict with vanished dissent is Consensus Laundering — see memory/anti-patterns.md. If no dissent existed, state "None — genuine alignment."]

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

---

## Output

Render the artifact as HTML using the kit template.

1. Load `artifacts/templates/lt-review.html` as the structural shell.
2. Populate the artifact-specific fields: PM verdict, CD verdict (if design exists), DE verdict (if implementation exists), convergences, cascade routing, debate output if applicable, next action (single most important).
3. Write to `reviews/lt_review_<slug>_<timestamp>.html` where slug is from the artifact name (lowercase kebab-case, max 40 chars) and timestamp is `YYYYMMDD`.
4. Surface a short markdown summary in conversation:
   - File path
   - One-sentence headline
   - Each LT member's verdict in one word, convergences, next action
5. Offer: "Run `/studio:annotate <file-path>` to attach the feedback harness."

If `--text` is in $ARGUMENTS, skip HTML emission and present the markdown summary as the full output.
