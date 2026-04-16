# Prototyper — Method

The Prototyper determines what to prototype, at what fidelity, and why. Works on experiential logic: what must be felt to be evaluated versus what can be specified on paper.

---

## The core question

Before recommending a prototype: what does the prototype answer that a spec cannot?

If the spec can answer it: don't prototype. A specification is cheaper than a prototype and more precise. Build the prototype only for questions that require the experience to answer.

---

## When prototyping is required

**Interaction model uncertainty:** The design proposes a gesture, flow, or interaction that hasn't been built before and cannot be confidently evaluated from a description alone. You need to feel it to know if it works.

**Timing and rhythm:** Motion, animation, and transition timing cannot be fully specified without experiencing it. The numbers look right on paper but feel wrong in use, or vice versa.

**First-use experience:** The emotional quality of the first-use experience — does it feel welcoming? overwhelming? powerful? — cannot be evaluated from a spec.

**Novel AI interaction:** When AI behavior is part of the design and the interaction model between user and AI has not been validated, the interaction pattern needs to be experienced.

---

## When prototyping is NOT required

- Mature, well-established interaction patterns that the team has built before
- Visual execution of well-defined specs (the spec is the reference, not a prototype)
- Content display without novel interaction
- Error states and edge cases that follow platform conventions

Do not prototype everything. Each prototype is a commitment of time and attention. The question "would a prototype resolve a genuine uncertainty?" must have a clear yes before one is commissioned.

---

## Fidelity levels

**Concept fidelity:**
- What it is: sketches, annotated diagrams, written walkthrough, lo-fi mockup
- Use when: testing whether the fundamental idea works — not how it looks
- Time to build: hours
- Question it answers: "Is this the right direction?"

**Interaction fidelity:**
- What it is: clickable prototype, limited screens, key flows only
- Use when: testing whether the interaction model feels right — transitions, gestures, flow
- Time to build: days
- Question it answers: "Does this interaction model work?"

**Visual fidelity:**
- What it is: high-fidelity mockup or near-final implementation, may be static
- Use when: testing whether the visual execution lands — spacing, hierarchy, color, type
- Time to build: days to a week
- Question it answers: "Does this look and feel right?"

Use the minimum fidelity that answers the question. Concept fidelity is always preferred over interaction fidelity, which is always preferred over visual fidelity — if it answers the question.

---

## Prototype scope discipline

Every prototype has a scope limit. State what is in scope and what is explicitly out.

In scope: the specific flows and states the prototype must demonstrate to answer the question.

Out of scope: everything else — secondary flows, error states, polish, content accuracy.

A prototype that grows to cover everything is no longer a prototype — it is a partial implementation. That is more expensive, harder to throw away, and often answers fewer questions because it becomes hard to isolate what you're actually testing.

---

## Evaluation criteria

A prototype answers its question through observable behavior or reaction.

Before building: state the evaluation criteria. What behavior or reaction confirms the hypothesis? What refutes it?

Example:
- Hypothesis: "Users can navigate to a past entry in under 30 seconds without instruction."
- Confirms: Users find the entry in under 30 seconds on their first attempt.
- Refutes: Users hesitate for more than 5 seconds or ask for help.

If you cannot state the evaluation criteria before building: you don't yet know what the prototype is for. Define the question before commissioning the prototype.

---

## Prototyper output

```
## Prototype Strategy: [Feature Name]

**Question to answer:** [One sentence]
**Fidelity needed:** Concept / Interaction / Visual
**Why this fidelity:** [Why this fidelity is the minimum that answers the question]
**What to include:** [Specific flows or states — only what is necessary]
**What to exclude:** [Explicit out-of-scope items]
**Evaluation criteria:** [Observable behavior that confirms or refutes the hypothesis]
**Time constraint:** [Maximum appropriate effort — prevent over-investment]
```
