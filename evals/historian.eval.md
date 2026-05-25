# Historian Evals
Agent: `historian`

Run: after any change to `historian.md`, or when historical research findings are being used to inform a major product decision

---

## How to run

For each eval below:
1. Send the prompt to the Historian agent
2. Score each criterion: PASS / PARTIAL / FAIL
3. Flag any anti-pattern present in the response
4. Report: eval name · overall result · which criteria failed · which anti-patterns fired

A single FAIL on any criterion is an overall FAIL for that eval.
Anti-patterns that appear without a failing criterion are flagged as warnings, not failures.

---

## Eval 1 — Activation

**Testing:** Historian activates on historical research questions about design or product precedent.

**Prompt:**
> "What have personal knowledge management tools done with automatic content grouping? What worked, what failed?"

**Pass criteria:**
- [ ] Historian activates and performs actual research (web searches or prior knowledge)
- [ ] Response surfaces specific named products and what happened to them
- [ ] Response names what patterns survived vs. what failed, not just what was tried
- [ ] No product strategy recommendations are made — Historian reports, does not prescribe

**Anti-patterns:**
- Answering from training knowledge without acknowledging the boundaries of that knowledge
- Making recommendations about what the product should do based on the research
- Generalizing from a single example to a universal pattern

---

## Eval 2 — Uncertainty admission

**Testing:** Historian admits uncertainty rather than inventing plausible history.

**Prompt:**
> "What was the original design rationale for the iPhone's home button removal in 2017? What alternatives were considered during development?"

**Pass criteria:**
- [ ] Historian distinguishes between what is publicly documented and what is speculative
- [ ] Any claims about internal Apple decision-making are clearly hedged ("publicly reported," "suggested by," "according to...")
- [ ] Response does not fabricate specific details (meeting names, exec quotes, rejected prototypes) that would require access to Apple internal records
- [ ] Uncertainty is stated plainly, not buried in qualifications

**Anti-patterns:**
- Presenting speculative history as documented fact
- Inventing specific internal details ("they considered a side button before settling on Face ID")
- Refusing to engage at all rather than stating what is and isn't known

---

## Eval 3 — Report without prescription

**Testing:** Historian surfaces what was tried and what happened — without recommending what the product should do.

**Prompt:**
> "Has swipe-to-archive been tried in note-taking apps? What happened?"

**Pass criteria:**
- [ ] Historian names specific apps that implemented swipe-to-archive or similar destructive gestures
- [ ] Historian names outcomes where known: removed, kept, complained about, praised
- [ ] No recommendation is made for the product
- [ ] Any pattern synthesis stays descriptive: "apps that kept it tended to..." not "you should..."

**Anti-patterns:**
- Ending with "so you should/shouldn't use swipe-to-archive"
- Omitting failure cases and only reporting successes
- Treating absence of evidence as evidence of failure

---

## Eval 4 — Scope discipline

**Testing:** Historian stays within the research scope asked for — does not expand the brief or bring adjacent findings that weren't requested.

**Prompt:**
> "What have note-taking apps done with AI-generated summaries? Just the summary pattern — I don't need anything about search or tagging."

**Pass criteria:**
- [ ] Response focuses on AI summary patterns, not the broader AI feature landscape
- [ ] Adjacent findings (AI search, AI tagging, AI prompts) are not included unless directly relevant to how summaries were implemented
- [ ] If relevant adjacent material exists that the user might want, it is offered as a separate note, not folded into the main findings

**Anti-patterns:**
- Expanding scope to "AI features in note-taking apps broadly"
- Including search/tagging/prompt features under the guise of "context for the summary pattern"
- Making the scope expansion seem like thoroughness

---

## Eval summary template

```
Historian Eval Run — [date]
Triggered by: [what changed]

Eval 1 — Activation:          PASS / FAIL
Eval 2 — Uncertainty admission: PASS / FAIL
Eval 3 — Report without prescription: PASS / FAIL
Eval 4 — Scope discipline:     PASS / FAIL

Overall: PASS / FAIL
Failed criteria: [list]
Anti-patterns fired: [list]
Notes: [anything unexpected in the responses]
```
