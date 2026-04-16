# Routing Guide

When work is NOT YET or STRUCTURALLY WRONG, route to the correct discipline or Gem. Routing must be specific — name which Gem and what question to bring to it.

---

## Failure type → Route

| Failure type | Route | What to bring |
|---|---|---|
| Wrong problem being solved | Problem Gem | State which problem is being solved vs. which should be solved |
| Problem is real but this isn't the right product for it | Problem Gem | The brief needs a business case rewrite |
| Wrong direction chosen from the idea space | Diverge Gem | State which direction was chosen and why it fails |
| Interaction model is incorrect | Design Gem | Name the interaction model failure and the correct alternative |
| Visual hierarchy breaks | Design Gem | Name which tiers are confused and what the correct hierarchy should be |
| Missing states | Design Gem | Name the missing states and what should happen in them |
| Accessibility failures | Design Gem | Name the specific failures (contrast ratio, touch target, etc.) |
| Motion is gratuitous or incorrect | Design Gem | Apply the motion test and name which animations fail it |
| Typography hierarchy broken | Design Gem | Name which levels are confused and what the correct roles should be |
| Implementation doesn't match spec | Write + Ship Gem (for spec clarification) or engineer (for fix) | Name the specific discrepancy |
| Spec is ambiguous | Write + Ship Gem | Name which spec section needs clarification and what the ambiguity is |
| Copy is vague, punishing, or off-voice | Write + Ship Gem | Name the specific strings and what is wrong with each |
| System coherence failure | Design Gem | Name what this fails to cohere with and how it should be aligned |

---

## Routing format

When routing, state:
1. What failed (one sentence, specific)
2. Where to go (Gem name)
3. What question to bring to that Gem (one sentence)

Example:
> "The interaction model assumes users will navigate by thread, but the current user base has not been exposed to threads yet — this is stage-mismatched. Return to the Problem Gem with the question: is this direction premature for the current stage, or should we design for the stage the user base will be at in 6 months?"

Do not route vaguely ("needs more design work"). Route to a specific Gem with a specific question.

---

## Cascade routing (multiple failures)

When work fails on multiple dimensions, route to the earliest Gem in the sequence:

Problem → Diverge → Design → Critique → Write + Ship

If work fails at the Problem level and the Design level: return to Problem first. Fixing the design without fixing the problem will produce correctly executed work against the wrong problem.

Exception: if the Problem and Design failures are independent (different aspects of the work), route to both simultaneously and note the independence.

---

## When to recommend a full restart

When work is STRUCTURALLY WRONG on multiple dimensions, or when the structural failure is at the conceptual level (the core idea is wrong), recommend a restart:

> "The direction is structurally wrong on two dimensions: the interaction model assumes behavior users don't have, and the data model requires writes that the system's append-only constraint prevents. These cannot be resolved by revision — the direction must be reconceived. Return to the Diverge Gem with the constraint that the new direction must work within an append-only model and must not require threading behavior from new users."

A restart recommendation names: what is wrong, why it cannot be revised, and what constraint the reconceived direction must satisfy.
