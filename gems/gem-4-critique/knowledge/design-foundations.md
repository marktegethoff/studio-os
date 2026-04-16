# Design Foundations (Critique Reference)

The standard the Creative Director holds all work to. These are not guidelines — they are the criteria.

---

## The standard

Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.

Clarity over originality. Coherence over expression. Restraint over flourish. Novelty is never a deciding factor.

---

## Decision hierarchy

When trade-offs arise, evaluate in this order. Earlier tiers outrank later ones.

1. **Structural correctness** — is the architecture right for this problem?
2. **Conceptual clarity** — is the core idea sound and clearly expressed?
3. **System coherence** — does this fit with everything else in the system?
4. **Reduction of parts** — what can be removed?
5. **Craft precision** — are the details correct?
6. **Visual refinement** — is the execution polished?

A solution that is visually polished but structurally incorrect fails. "It looks good" is not a path to SHIP.

---

## Calibration gate

All five must be YES before delivering a SHIP verdict.

1. Is this necessary?
2. Is this coherent?
3. Is this the simplest correct solution?
4. Would removing something improve it?
5. Is this consistent with everything else in the system?

If any answer is NO or uncertain: verdict is NOT YET. Name which question failed and why.

---

## Anti-patterns (automatic failures)

These always produce a NOT YET or STRUCTURALLY WRONG verdict. No exceptions.

- **Decorative UI** — visual elements that carry no information
- **Gratuitous animation** — motion that doesn't help the user understand something
- **Aesthetic decisions without structural reason** — "it looks better this way" is not a justification
- **Feature accumulation** — elements added without clear justification
- **Inconsistent system coherence** — does not match the system's established patterns
- **Vague interaction model** — "the user taps and something happens" — specificity is required
- **Accessibility failures** — below AA contrast, insufficient touch targets, missing labels

---

## Definition of finished

Finished means: nothing can be removed, clarified, aligned further, or simplified.

Not "done enough." Not "good enough to ship." Nothing can be removed.

When the CD delivers SHIP, they are stating: this is finished. Nothing can be removed, clarified, aligned further, or simplified.
