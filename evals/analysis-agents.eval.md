# Analysis Agents Evals
Agents: `scout`, `competitive-analyst`

Run: after any change to `scout.md` or `competitive-analyst.md`

---

## How to run

For each eval below:
1. Send the prompt to the named agent
2. Score each criterion: PASS / PARTIAL / FAIL
3. Flag any anti-pattern present in the response
4. Report: eval name · agent · overall result · which criteria failed · which anti-patterns fired

A single FAIL on any criterion is an overall FAIL for that eval.
Anti-patterns that appear without a failing criterion are flagged as warnings, not failures.

---

## Scout — Eval 1: Filtered output

**Testing:** Scout returns findings filtered against stated studio positions — not raw market signal.

**Prompt:**
> "Scout the field — are any note-taking apps challenging the append-only model? We're committed to append-only entries with amendments; I want to know if that's becoming unusual."

**Pass criteria:**
- [ ] Scout performs actual research (web searches) — does not answer from training knowledge
- [ ] Findings are specifically filtered against the append-only position
- [ ] Maximum 5 findings returned — not an exhaustive survey
- [ ] Each finding names the specific product, the specific change, and why it tensions (or confirms) the append-only position
- [ ] No product strategy recommendation is made ("you should reconsider append-only")

**Anti-patterns:**
- Returning 10+ findings without prioritization
- Reporting general trends about PKM evolution not related to edit models
- Recommending that the product reconsider its position based on findings
- Treating "many apps allow editing" as a single finding (Signal Inflation)

---

## Scout — Eval 2: Position confirmation ban

**Testing:** Scout does not selectively surface only findings that confirm existing the product positions.

**Prompt:**
> "What's the field doing with on-device AI for note-taking? We're using on-device models locally."

**Pass criteria:**
- [ ] Scout surfaces at least one finding that could challenge or complicate the on-device approach (cloud advantage, latency tradeoffs, competitor capability gaps)
- [ ] Findings are not all validating — at least one creates productive tension with existing decisions
- [ ] Scout's framing does not editorialize toward confirming the on-device choice ("this confirms your direction")

**Anti-patterns:**
- Only reporting findings that validate the current on-device models approach
- Burying challenging findings at the end after three confirming ones
- "This confirms that on-device is the right call" — Scout does not evaluate, it reports

---

## Competitive Analyst — Eval 3: Map, not list

**Testing:** Competitive Analyst produces a structured competitive landscape, not a feature inventory.

**Prompt:**
> "Run a competitive teardown on how productivity apps handle AI-powered summarization before I write the brief."

**Pass criteria:**
- [ ] Response is structured as a comparative map — categories, patterns, positions — not an app-by-app feature list
- [ ] 3–5 competitors analyzed, not all apps in the category
- [ ] Response names what has converged into table stakes vs. what remains differentiated
- [ ] Response names at least one gap in the competitive landscape
- [ ] No recommendation is made for what the product should do

**Anti-patterns:**
- "App A has X. App B has Y. App C has Z." — a list, not a map
- Analyzing 8+ competitors at the cost of structural depth
- Omitting the table-stakes vs. differentiation distinction
- "Based on this, you should build..." — Competitive Analyst maps; Strategist evaluates

---

## Competitive Analyst — Eval 4: Table stakes discipline

**Testing:** Competitive Analyst correctly distinguishes table-stakes closure from genuine differentiation.

**Prompt:**
> "Is our approach to AI-detected grouping of related items actually differentiated, or have we reinvented what everyone already does?"

**Pass criteria:**
- [ ] Response names which aspects of the item-grouping approach are table stakes (automatic grouping of similar notes is common)
- [ ] Response names which aspects, if any, represent genuine differentiation
- [ ] The distinction is stated plainly — not hedged
- [ ] If the answer is "you've reinvented the standard," Competitive Analyst says so directly

**Anti-patterns:**
- Calling something differentiated because it has a different name
- Inflating table stakes into differentiation to avoid an uncomfortable answer
- Failing to distinguish "we do it differently" from "we do something different"

---

## Eval summary template

```
Analysis Agents Eval Run — [date]
Triggered by: [what changed]

Scout Eval 1 — Filtered output:      PASS / FAIL
Scout Eval 2 — Position confirmation ban: PASS / FAIL
Competitive Analyst Eval 3 — Map not list: PASS / FAIL
Competitive Analyst Eval 4 — Table stakes: PASS / FAIL

Overall: PASS / FAIL
Failed criteria: [list]
Anti-patterns fired: [list]
Notes: [anything unexpected in the responses]
```
