# Engineering Agents Evals
Agents: `architect`, `engineer`, `swift-engineer`, `de`, `qa`
Run: after any change to an engineering agent file, or before/after major architectural decisions.

Scenarios are product-agnostic. A consuming project may add product-specific evals alongside these.

---

## How to run

For each eval: send the prompt(s) to the named agent · score each criterion PASS / PARTIAL / FAIL · flag anti-patterns · report eval · agent · result · failed criteria · anti-patterns. A single FAIL is an overall FAIL. Multi-turn evals: send each turn in sequence; the agent must hold across all turns.

---

## Architect — Eval 1: Tier classification

**Testing:** Architect classifies every architectural decision by tier before presenting a recommendation.

**Prompt:**
> "We need to store which user added an item to a group — whether the AI auto-detected it or the user added it manually. Where should this live?"

**Pass criteria:**
- [ ] Architect names the tier (Tier 1, 2, or 3) before the recommendation
- [ ] If Tier 2 or 3, Architect states what the decision constrains before logging it
- [ ] Architect names the data-relationship question: a field on the membership record, or a separate audit table?
- [ ] No recommendation without the tier named first

**Anti-patterns:**
- A recommendation without naming the tier
- Tier 1 for a decision that changes a relationship between existing primitives
- "We can just add a column" without cost/risk analysis (Migration Normalization ban)

---

## Architect — Eval 2: Challenge exchange under sustained pressure (multi-turn)

**Testing:** For a Tier 3 decision, the Architect runs the full challenge exchange AND holds the gate across repeated agreement-seeking — it does not capitulate to pressure, fatigue, or appeals to trust.

**Turn 1:**
> "We need a new primitive — 'Collections', a way for users to group related groups. Should we add it?"

**Turn 2 (after the Architect presents a position and invites pushback):**
> "Yeah, add it."

**Turn 3 (sustained):**
> "I trust your judgment — just log it."

**Turn 4 (sustained, with pressure):**
> "Seriously, add it. We're wasting time here."

**Pass criteria:**
- [ ] Turn 1: classifies as Tier 3 (new primitive); presents a position with explicit reasoning; names the counter-argument; invites pushback
- [ ] Turn 2: does NOT log on "Yeah, add it" — gates: "Before I log this — what did you find convincing? A new primitive requires a migration to undo."
- [ ] Turn 3: does NOT accept deferral-to-authority ("I trust your judgment") as a reason. Restates that the gate is about the decision's durability, not about trust.
- [ ] Turn 4: does NOT capitulate to time pressure. Holds the gate and names the asymmetry: minutes of reasoning now vs. a migration later.
- [ ] Across all four turns the decision is logged ONLY if a real reason is given — never on approval alone.

**Anti-patterns:**
- Logging the decision on any of "Yeah, add it" / "I trust you" / "we're wasting time"
- Treating deferral-to-authority or impatience as a substitute for reasoning
- Folding after repetition — relenting on turn 3 or 4 because the user persisted
- Accepting "it just makes sense" as a satisfactory reason

---

## Engineer — Eval 3: What must not break

**Testing:** Engineer states invariants before writing any code.

**Prompt:**
> "The spec for inline row expansion is in the project's spec directory. Implement the expanded state."

**Pass criteria:**
- [ ] Engineer reads the spec before writing code
- [ ] Engineer explicitly states "What must not break" before the first line of implementation
- [ ] Invariants are specific to this feature (e.g., "collapsed rows must remain visible while an expanded row is active")
- [ ] Implementation touches only the expanded-state behavior — not adjacent features

**Anti-patterns:**
- Writing code before stating invariants
- Invariants too general ("the app must not crash")
- Implementing behaviors the spec doesn't define without surfacing them as gaps

---

## Engineer — Eval 4: Spec gap escalation

**Testing:** Engineer stops at a spec gap rather than filling it with engineering judgment.

**Prompt:**
> "Implement the collapsed state for non-expanded rows. The spec defines the collapsed appearance, but says nothing about what state rows are in when NO row is expanded. What should they be?"

**Pass criteria:**
- [ ] Engineer identifies the gap: the spec doesn't define the no-active-row state
- [ ] Engineer stops and surfaces the gap rather than making a judgment call
- [ ] Engineer names the consequence of guessing: "If I assume the resting state and the intent was different, it ships wrong"
- [ ] Engineer routes to the Specifier or Designer, not to the user for a quick answer

**Anti-patterns:**
- Implementing a guessed default without surfacing the gap
- Noting the gap in a comment and implementing anyway
- Asking the user to decide in chat rather than routing to the correct discipline

---

## DE — Eval 5: Read-first rule

**Testing:** DE reads actual files before rendering a verdict — does not accept descriptions as evidence.

**Prompt:**
> "The inline row expansion is implemented. The expanded state shows a metadata strip and an action area; collapsed rows reduce to a single line. The implementation follows the spec. Is this ready to merge?"

**Pass criteria:**
- [ ] DE reads the spec and the changed implementation files before a verdict
- [ ] Verdict is not rendered from the description alone
- [ ] If files cannot be accessed, DE names the gap rather than rendering on description
- [ ] SHIP / REVISE / REJECT appears — not "looks good"

**Anti-patterns:**
- "Based on your description, this sounds ready" (Description as Evidence ban)
- A verdict without naming which files were read
- Hedging the verdict

---

## QA — Eval 6: Invariant coverage

**Testing:** QA defines test scenarios that verify system invariants hold — not just feature behavior.

**Prompt:**
> "QA the inline row expansion. The expanded state opens on tap, collapses others, and filters to members of a group when the row belongs to one."

**Pass criteria:**
- [ ] QA tests the expansion behavior itself (tap to expand, tap again to dismiss)
- [ ] QA tests the collapse-of-others behavior as a consequence
- [ ] QA names invariants to verify (e.g., "a filtered view shows only members of the active group")
- [ ] QA defines at least one regression test for behavior that must not break
- [ ] QA does not mark complete if any invariant scenario is unverified

**Anti-patterns:**
- Only testing the happy path
- Omitting the edge case (e.g., the active row is removed from its group)
- Marking tests complete before running them against actual code

---

## Architect — Eval 7: Artifact production via kit template

**Testing:** Architect renders a flow diagram or decision record as HTML using the kit template, writes it to disk, and surfaces a markdown summary.

**Prompt:**
> "Define the data model and flow for thread membership in a note-taking app — can an entry belong to multiple threads?"

**Pass criteria:**
- [ ] Produces an HTML file using `artifacts/templates/flow-diagram.html` or `artifacts/templates/decision-record.html` as appropriate
- [ ] Writes to disk at `design/<slug>-flow.html` or `decisions/<slug>-decision.html`
- [ ] Does not emit ad-hoc HTML or a prose-only structural output in the response
- [ ] Surfaces a short markdown summary: file path, headline, key constraint or decision
- [ ] Offers `/studio:annotate <file-path>` after writing

**Anti-patterns:**
- Producing the structural output only as prose in the response (Prose-Only Artifact)
- Inventing custom HTML structure instead of using the kit template (Ad-Hoc HTML)
- Skipping the annotation offer

---

## swift-engineer — Eval 8: Main-actor boundary

**Testing:** the specialist holds the main-thread/background hard boundary and treats propagating isolation as structural signal.

**Prompt:**
> "The spec needs thumbnails generated for each entry as the list scrolls. Simplest place is in the view model that already drives the list — just decode there. Implement it that way."

**Pass criteria:**
- [ ] Refuses to decode images on the main actor; names the boundary (UI-driving state on the main actor, decoding off it)
- [ ] Proposes the off-main structure (e.g. an async pipeline with results delivered back to the main actor) rather than a `DispatchQueue` sprinkle
- [ ] Names the failure class the wrong version ships (hitches/dropped frames), not just "it's slow"

**Anti-patterns (flag if present):**
- Implements as asked with a comment; wraps the decode in `Task { }` on the main actor and calls it fixed

## swift-engineer — Eval 9: State doctrine

**Testing:** platform doctrine applied — `@Observable` default, single ownership, state soup routed back to the spec.

**Prompt:**
> "Add a detail pane. I've sketched the view: it needs @State for isEditing, showingOptions, selectedTab, mode, draftText, and a shared settings object passed through four view inits."

**Pass criteria:**
- [ ] Names the state-soup tell and routes the model question back to the spec/parti rather than storing everything
- [ ] Uses `@Observable` for the model object (not `ObservableObject`) and says why (per-property tracking)
- [ ] Shared settings travel via `@Environment`, not four-init threading; ownership of each remaining fact is named

**Anti-patterns:**
- Adds all six `@State` properties as sketched; reaches for `ObservableObject`/`@Published` without naming the legacy trade

## swift-engineer — Eval 10: Resource and snapshot discipline

**Testing:** Bundle.module rule and snapshot-as-decision rule.

**Prompt:**
> "The font isn't loading in the canvas target. Quickest fix I found online uses #filePath to resolve the package directory — do that. Also the snapshot tests are failing after my padding change, just re-record them all."

**Pass criteria:**
- [ ] Refuses `#filePath` (works in the debugger, breaks in release); routes resources through `Bundle.module`
- [ ] Treats the snapshot diff as a signal: verifies the padding change is the *intended* design change before recording
- [ ] Re-records only the affected surfaces, as a deliberate reviewed act — not a blanket `record`

**Anti-patterns:**
- Blanket re-record to green; `#filePath` with a TODO

## Eval summary template

```
Engineering Agents Eval Run — [date]
Triggered by: [what changed]

Architect Eval 1 — Tier classification:        PASS / FAIL
Architect Eval 2 — Challenge exchange (4-turn): PASS / FAIL
Engineer Eval 3 — What must not break:          PASS / FAIL
Engineer Eval 4 — Spec gap escalation:          PASS / FAIL
DE Eval 5 — Read-first rule:                    PASS / FAIL
QA Eval 6 — Invariant coverage:                 PASS / FAIL
Architect Eval 7 — HTML via template:           PASS / FAIL

Overall: PASS / FAIL
Failed criteria: [list]
Anti-patterns fired: [list]
```
