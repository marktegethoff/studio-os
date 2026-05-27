# Surface Agents Evals
Agents: `materialist`, `visual-designer`, `mark-maker`, `accessibility`, `heurist`, `design-validator`, `systematist`

Run: after any change to a surface agent file, or after significant design system updates

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

## Materialist — Eval 1: Material language before evaluation

**Testing:** Materialist names the material language of the interface before evaluating individual decisions.

**Prompt:**
> "A panel has a near-black background in dark mode; the content area sits one step lighter; the chrome bar matches the panel; a 1px low-contrast separator divides chrome from content. Does this feel right?"

**Pass criteria:**
- [ ] Materialist names the material language first: what material is this interface made of?
- [ ] The tonal separation model is identified as the design language (no shadows, warmer delta in dark mode)
- [ ] Specific findings reference the material logic: "this conflicts with the established model" not "it feels off"
- [ ] Light source is named or confirmed absent (appropriate for tonal model)

**Anti-patterns:**
- Evaluating the 1px separator without first naming the material model
- "It feels a bit flat" without naming what the flatness means in the material logic
- Recommending shadows on a tonal-separation system

---

## Materialist — Eval 2: Incoherence escalation

**Testing:** When the material model itself is incoherent, Materialist stops prescribing surface corrections and routes to the appropriate agent.

**Prompt:**
> "Some components use drop shadows to indicate elevation. Other components use tonal separation — lighter backgrounds for foreground elements. They're both in the same surface."

**Pass criteria:**
- [ ] Materialist identifies this as a material model incoherence, not a component-level error
- [ ] Materialist does not prescribe "fix the shadow on component X" — the model is the problem
- [ ] Materialist names what must be decided before surface corrections can be made
- [ ] Materialist routes to the appropriate agent (CD for design-level, Architect if structural)

**Anti-patterns:**
- Prescribing individual shadow/tonal corrections without naming the model conflict
- "Just remove the shadows from the card" as a resolution to a systemic incoherence

---

## Visual Designer — Eval 3: Value, not direction

**Testing:** Visual Designer states current value and target value — never directional language.

**Prompt:**
> "The list row bottom margin feels too tight, especially when the text wraps to two lines. Something about the spacing between rows isn't right."

**Pass criteria:**
- [ ] Visual Designer names the current value (or asks for it if not provided)
- [ ] Visual Designer names the target value (a specific spacing token, not "more space")
- [ ] No directional language: "more spacious," "a bit looser," "increased margin" without the value
- [ ] The structural reason is given in one sentence

**Anti-patterns:**
- "The bottom margin could use a bit more breathing room" — direction, not value
- "Consider increasing the padding" without naming the target value
- "It might benefit from more whitespace" — Visual Designer specifies; it does not suggest

---

## Mark Maker — Eval 4: Reduction test and brevity

**Testing:** Mark Maker applies the reduction test without announcing it, and delivers verdicts briefly.

**Prompt:**
> "The mark is a single period set in a bold grotesque, in one accent color. Does this mark hold?"

**Pass criteria:**
- [ ] Mark Maker evaluates against one-color, minimum scale, maximum reduction, negative space, and memory test
- [ ] Reduction test is not announced as a checklist — it is embedded in the evaluation
- [ ] If the mark holds, verdict is one sentence
- [ ] If the mark has issues, each issue is stated precisely in one or two sentences

**Anti-patterns:**
- "Let me walk you through the reduction test: Step 1..." — the test is not a ceremony
- Multi-paragraph approval ("This mark shows remarkable restraint and...")
- Ambiguity: "mostly holds" is not a verdict

---

## Heurist — Eval 5: Additive fix ban

**Testing:** Heurist does not recommend adding UI to solve a problem created by existing UI when removal is the correct fix.

**Prompt:**
> "Users can't find the filter selector — it's in a side panel reached by dragging from the left edge. Discoverability is low. We're thinking of adding a toolbar hint that says 'drag to filter.'"

**Pass criteria:**
- [ ] Heurist evaluates the discoverability problem against the heuristics (H6 — recognition vs. recall, H4 — conventions)
- [ ] Heurist evaluates whether the tooltip/hint addresses the root cause or papers over it
- [ ] Heurist names which heuristic is violated and what the failure mode is for the user
- [ ] If removal or redesign is the correct fix, Heurist says so — does not default to the additive fix

**Anti-patterns:**
- "Adding a hint label is a reasonable approach" without evaluating whether it solves the underlying problem
- Recommending the tooltip without evaluating whether the gesture model itself is the problem
- Severity inflation: rating a discoverability issue P0 to ensure it gets addressed

---

## Heurist — Eval 6: User error as design error

**Testing:** Heurist correctly frames user errors as design errors, not user education problems.

**Prompt:**
> "Users are accidentally archiving items when they swipe to see the inline action menu. They're swiping too far. We're thinking of adding a tutorial."

**Pass criteria:**
- [ ] Heurist names this as a design error: the affordance is ambiguous, the committed-state threshold is wrong, or the action is not reversible enough
- [ ] No recommendation that users be educated out of the problem ("onboarding would help")
- [ ] The structural fix is named: threshold, velocity, reversibility, or gesture model
- [ ] Severity reflects actual user impact

**Anti-patterns:**
- "Users need to learn the swipe threshold" — this is the user-education failure mode
- "An onboarding tooltip would help" — this is the Additive Fix ban
- Framing accidental archiving as a user issue rather than a design issue

---

## Accessibility — Eval 7: WCAG 2.1 AA violation identification

**Testing:** Accessibility calculates actual contrast ratios and tap target sizes against WCAG 2.1 AA thresholds — not just flags "low contrast" without specifics.

**Prompt:**
> "A card component uses #888888 text on a #FAFAFA background. The action button inside the card has a tap target of 28×28pt. Dark mode inverts to #777777 text on #1A1A1A. Is this accessible?"

**Pass criteria:**
- [ ] Accessibility calculates or estimates contrast ratios — does not say "low contrast may be an issue" without the ratio
- [ ] Identifies light mode text (#888888 on #FAFAFA) as failing AA for normal text (needs 4.5:1; ratio is ~3.7:1)
- [ ] Identifies the 28×28pt tap target as failing WCAG 2.5.5 (minimum 44×44pt)
- [ ] Evaluates dark mode (#777777 on #1A1A1A) independently — does not assume light mode result carries over
- [ ] Each finding names the specific WCAG criterion violated and a concrete remediation

**Anti-patterns:**
- "Low contrast may be an issue" without calculating or estimating the ratio
- "Consider increasing the tap target size" without naming the 44pt minimum
- Treating dark mode as automatically passing because it wasn't listed as a problem
- Listing WCAG criterion numbers without applying them to the specific values given

---

## Design Validator — Eval 8: Token mismatch reporting

**Testing:** Design Validator identifies token mismatches between mockup values and the design system spec, and reports without prescribing the fix.

**Prompt:**
> "The header uses `#1C1C1E` for the title text in dark mode. The design system defines the primary text token for dark mode as `#FFFFFF` with a fallback of `#F2F2F7`. The mockup also uses 16pt for body copy, but the design system specifies body-default as 17pt. Run a design system validation."

**Pass criteria:**
- [ ] Design Validator identifies the color mismatch: mockup value #1C1C1E does not match the token (#FFFFFF / #F2F2F7)
- [ ] Design Validator identifies the type size mismatch: 16pt where the body-default token is 17pt
- [ ] Reports findings only — does not prescribe "change to #FFFFFF"
- [ ] Names which token is violated, not just that something is wrong

**Anti-patterns:**
- "The text color looks dark for dark mode" — names the observation but not the token violation
- Prescribing "change this to #FFFFFF" rather than naming the token and the discrepancy
- Combining find and fix in one step (reports prescriptions, not findings)
- Missing the type size violation while catching the color violation

---

## Systematist — Eval 9: Drift over preference

**Testing:** Systematist audits a design system for measurable drift (token bypass, pattern proliferation, naming incoherence) — not aesthetic preference — and identifies the decision required to reduce count.

**Prompt:**
> "Our codebase has three button components — PrimaryButton, ActionButton, and CTAButton — that look nearly identical. Spacing values are sometimes raw numbers, sometimes tokens. Is our design system healthy?"

**Pass criteria:**
- [ ] Systematist names pattern proliferation: three components doing one job is a defect, and surfaces the decision required (one of these three should be canonical)
- [ ] Systematist names token drift: raw values bypassing tokens, and that the fix is to route them through the token system
- [ ] Findings are measurable (counts of duplicates, instances of raw values), not aesthetic ("the buttons feel inconsistent")
- [ ] Identifies that the component count must reduce — does not propose a fourth "unified" button as the solution

**Anti-patterns:**
- "The buttons could look more consistent" — preference, not a drift finding
- Proposing a new component to unify the three (adds a fourth; Pattern Proliferation)
- Renaming without consolidating (relabeling drift instead of removing it)
- Treating raw spacing values as acceptable "for now" without naming the debt

---

## Eval summary template

```
Surface Agents Eval Run — [date]
Triggered by: [what changed]

Materialist Eval 1 — Material language:         PASS / FAIL
Materialist Eval 2 — Incoherence escalation:    PASS / FAIL
Visual Designer Eval 3 — Value not direction:   PASS / FAIL
Mark Maker Eval 4 — Reduction and brevity:      PASS / FAIL
Heurist Eval 5 — Additive fix ban:              PASS / FAIL
Heurist Eval 6 — User error as design error:    PASS / FAIL
Accessibility Eval 7 — WCAG AA violations:      PASS / FAIL
Design Validator Eval 8 — Token mismatch:       PASS / FAIL
Systematist Eval 9 — Drift over preference:     PASS / FAIL

Overall: PASS / FAIL
Failed criteria: [list]
Anti-patterns fired: [list]
```
