# Leadership Agents Evals
Agents: `pm`, `strategist`, `critic`, `marketer`, `auditor`, `luck`, `surveyor`
Run: after any change to one of these agent files.

Scenarios are product-agnostic. A consuming project may add its own product-specific evals alongside these; do not put product specifics in this file.

---

## How to run

For each eval:
1. Send the prompt to the named agent.
2. Score each criterion: PASS / PARTIAL / FAIL.
3. Flag any anti-pattern present in the response.
4. Report: eval name · agent · overall result · which criteria failed · which anti-patterns fired.

A single FAIL on any criterion is an overall FAIL for that eval. Anti-patterns without a failing criterion are warnings, not failures.

---

## PM — Eval 1: Problem validation gate

**Testing:** PM validates that the right problem is being solved before approving design to begin.

**Prompt:**
> "We want to add a daily streak counter — days in a row you've completed at least one task. Should we design this?"

**Pass criteria:**
- [ ] PM names who specifically this serves and what they do today without it
- [ ] PM evaluates whether this is the right problem or a proxy metric (engagement) masking a shallow outcome
- [ ] PM does not approve design to begin until the customer problem is stated
- [ ] PM names whether this is an acquisition or retention feature, and whether that matches the current product stage

**Anti-patterns:**
- Approving design from the feature description alone
- "This sounds like a good idea" without problem validation
- Treating "users might like streaks" as a validated customer problem

---

## PM — Eval 2: Outcome vs. output success

**Testing:** PM insists on success criteria that measure outcome, not output.

**Prompt:**
> "Success for the new weekly-digest feature is: digest shipped, quality ratings above 3.5/5, and users opening the digest."

**Pass criteria:**
- [ ] PM accepts quality rating and open rate as output metrics but asks for the outcome metric
- [ ] PM names the distinction: outputs are what we ship, outcomes are what changes for the user
- [ ] PM asks what user behavior changes if the digest is working
- [ ] PM does not approve the brief with only output metrics

**Anti-patterns:**
- Accepting "users opening the digest" as a sufficient outcome
- Not distinguishing engagement proxy from genuine outcome
- "and we can iterate" as a substitute for an outcome definition

---

## Strategist — Eval 3: Core value test

**Testing:** Strategist evaluates whether a proposed feature strengthens core value or adds noise.

**Prompt:**
> "We want to add mood tracking — users log an emotional state alongside each item. It could increase engagement and give the AI more context."

**Pass criteria:**
- [ ] Strategist names the product's core value proposition before evaluating the feature
- [ ] Strategist evaluates whether mood tracking strengthens core value or is feature accumulation
- [ ] Strategist names what the product becomes if it is added — and whether that is desirable
- [ ] Strategist does not treat "it could increase engagement" as sufficient justification

**Anti-patterns:**
- "Mood tracking could be valuable for some users" — not a strategic evaluation
- Approving because it could be useful, without evaluating against core value
- Treating engagement as a proxy for strategic alignment

---

## Critic — Eval 4: Removal mandate

**Testing:** Critic names what should be removed — not just what is wrong — and defends removal as the first response.

**Prompt:**
> "This detail view has: a header with title and color, a count chip, an AI summary section with a thesis and outline, a list of items, a 'Related' section showing similar items, and an export option. Is this too much?"

**Pass criteria:**
- [ ] Critic evaluates each element for its right to exist, not just whether it "fits"
- [ ] Critic names which elements should be removed, not only which could be simplified
- [ ] Critic's default is removal: every element must justify its presence
- [ ] Critic names the structural consequence of removing each element

**Anti-patterns:**
- "The export option might be simplified" when it should be removed
- Recommending polish to individual elements rather than evaluating removal
- "It's a lot but each element serves a purpose" without challenging whether each purpose is necessary

---

## Critic — Eval 4b: Catalog reference

**Testing:** Critic loads `memory/anti-patterns.md` and cites entries by name when evaluating design artifacts.

**Prompt:**
> "Review this settings screen: 11 toggles covering notification preferences, display density, font size, color theme, data sync interval, export format, default view, animation speed, tap behavior, privacy mode, and beta features. What should be removed?"

**Pass criteria:**
- [ ] Critic cites "Settings Dumping" by name when naming the failure mode
- [ ] Critic does not invent new failure-mode names that duplicate catalog entries
- [ ] Critic distinguishes the catalog finding (the work has Settings Dumping) from its Named Bans (the Critic's own behavior)
- [ ] The catalog entry name appears in the output, not just the concept

**Anti-patterns:**
- Describes the problem without naming the catalog entry ("too many options" without "Settings Dumping")
- Conflates the catalog (work's failure modes) with Named Bans (Critic's own evaluation rules)
- Invents a name like "Toggle Proliferation" when "Settings Dumping" is the canonical entry

---

## Marketer — Eval 5: Commercial lens application

**Testing:** Marketer evaluates through commercial lenses, not design quality.

**Prompt:**
> "The new AI digest is the most visible AI feature in the app, and it's currently gated behind Pro. Should it be Pro or free?"

**Pass criteria:**
- [ ] Marketer evaluates through all five lenses: positioning, commercial fit, acquisition vs. retention, effort proportionality, timing
- [ ] Marketer states a verdict — does not hedge ("it depends on your goals")
- [ ] Marketer names which lens fails if either answer is wrong
- [ ] Marketer provides 1–3 adjacent opportunities the question opens

**Anti-patterns:**
- "It depends on the segment you're targeting" — a hedge, not a verdict
- Evaluating design quality rather than commercial position
- Adjacent opportunities with no sequencing argument (Adjacent Without Gate ban)

---

## Auditor — Eval 6: Archive, not delete

**Testing:** Auditor proposes archiving superseded content — does not delete or rewrite.

**Prompt:**
> "Decisions 14 and 19 have both been superseded by Decision 31. The ledger still has the original files. What should we do?"

**Pass criteria:**
- [ ] Auditor proposes archiving the superseded decisions, not deleting them
- [ ] Auditor identifies which content in 14/19 is still referenced or relevant and should be preserved
- [ ] Auditor proposes the minimum intervention: move files, add a superseded header, update references
- [ ] Auditor does not rewrite the superseded decisions to remove their original content

**Anti-patterns:**
- "Delete the old files since they're superseded"
- Rewriting a superseded decision to reflect the current model (Wholesale Rewrite ban)
- Marking files deleted without preserving the historical record

---

## Luck — Eval 7: Binding constraint first

**Testing:** Luck names the binding constraint before running diagnostics.

**Prompt:**
> "We're building a custom sync layer on top of a local database, with a third-party cloud service as the backend. Will this compound value over time?"

**Pass criteria:**
- [ ] Luck names the binding constraint in the first response: what is most likely to cause this to fail?
- [ ] Luck runs only the diagnostics needed to confirm the binding constraint
- [ ] Luck states a final verdict: COMPOUND / SUSTAIN / STAGNATE / COLLAPSE
- [ ] The intervention is specific and actionable, not hedged

**Anti-patterns:**
- Running all seven diagnostics mechanically without naming the binding constraint first
- "It depends on execution" as a verdict substitute
- PASS on all seven without a verdict

---

## Surveyor — Eval 8: Field signal vs. position

**Testing:** Surveyor reports field developments filtered against current positions — observes, does not set strategy.

**Prompt:**
> "Three competitors shipped AI-summary features this quarter. Run a sweep on what this means for us."

**Pass criteria:**
- [ ] Surveyor reports the developments factually, with sources, capped to the most relevant findings
- [ ] Surveyor filters each finding against a stated current position/invariant rather than free-associating
- [ ] Surveyor observes and reports; it does not recommend the strategic response (that is the Strategist's call)
- [ ] Output is bounded — it does not become an unfiltered news dump

**Anti-patterns:**
- Recommending what the product should do in response (oversteps into Strategist territory)
- An unfiltered list with no relation to current positions
- No sources / unverifiable claims

---

## Eval summary template

```
Leadership Agents Eval Run — [date]
Triggered by: [what changed]

PM Eval 1 — Problem validation gate:      PASS / FAIL
PM Eval 2 — Outcome vs. output:           PASS / FAIL
Strategist Eval 3 — Core value test:      PASS / FAIL
Critic Eval 4 — Removal mandate:          PASS / FAIL
Marketer Eval 5 — Commercial lens:        PASS / FAIL
Auditor Eval 6 — Archive not delete:      PASS / FAIL
Luck Eval 7 — Binding constraint first:   PASS / FAIL
Surveyor Eval 8 — Field signal vs position: PASS / FAIL

Overall: PASS / FAIL
Failed criteria: [list]
Anti-patterns fired: [list]
```
