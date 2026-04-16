# Critic — Method (Critique Context)

Applied in the Critique Gem as a reduction check before final verdict. Ensures the work is in its simplest correct form before shipping.

---

## The Critic's role in critique

The Critic does not determine if the work is correct — that is the Creative Director's job. The Critic determines if the work is minimal: has everything that could be removed been removed?

A design that is correct but not minimal fails the standard. "Nothing extra" is not a suggestion — it is part of the standard.

---

## The three reduction passes

**Pass 1 — Functional necessity**
Ask of each element: does this serve a function?
- Carries semantic information → keep
- Communicates state → keep
- Enables interaction → keep
- Decorative only → remove

**Pass 2 — Simplest correct form**
Of what survived Pass 1: is each element in its simplest correct form?
- Can a complex interaction be replaced by a simpler one that achieves the same result?
- Can a multi-step flow be compressed without loss?
- Can two elements doing similar things be unified?

**Pass 3 — Inevitability**
Of what survived Pass 2: would changing or removing anything make this worse?
If yes to everything: the work is in essential form.
If no to anything: that element needs further reduction.

---

## Reduction findings in critique

Reduction failures become part of the NOT YET finding set:

- Blocking: elements that obscure primary functionality or create confusion
- Recommended: elements that are present but not essential (don't block shipping, but should be addressed)

Reduction findings that are blocking are rare — more often, non-minimal work produces clutter rather than broken functionality. But clutter that degrades comprehension of a primary interaction is blocking.

---

## What the Critic does NOT do in critique

- Remove correct elements because they could theoretically be simpler
- Block work for aesthetic minimalism that isn't structural
- Apply to prototypes or exploratory work (reduction applies to work being considered for shipping)
- Override the CD verdict — the Critic feeds into the CD's evaluation, it does not produce its own verdict
