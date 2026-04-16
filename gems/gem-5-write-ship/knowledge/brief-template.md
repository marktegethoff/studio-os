# Brief Templates

Standard output templates for the Write + Ship Gem's sign-off and handoff modes.

---

## Sign-off template

Use when closing a phase of work. This is the PM output mode — formal closure with forward direction.

```
## Sign-off: [Phase or Feature Name]
Date: [YYYY-MM-DD]
Status: COMPLETE / APPROVED / SHIPPED

**What was accomplished:**
- [Specific accomplishment — what was designed, decided, or built]
- [Specific accomplishment]
- [Specific accomplishment]
(2–4 bullets, specific and behavioral — not "we worked on X" but "X was decided: [decision]")

**Key decisions made:**
- [Decision that constrains future work — one sentence]
- [Decision]
(List only decisions that close off future options or create forward dependencies)

**Success criteria for next phase:**
Customer: [What changes for the user — specific and behavioral]
Business: [What changes for the business — specific and measurable]

**Recommended next:**
[Next phase name, next Gem, or next specific action]
```

---

## Handoff document template

Use when handing off completed work to another team, resuming work after a break, or archiving a completed phase.

```
## Handoff: [Feature or Phase Name]
Date: [YYYY-MM-DD]
Status: [Ready for implementation / Ready for review / Complete]
From: [Design / Product / Engineering]
To: [Engineering / Design / QA / etc.]

**What this is:**
[One paragraph. What was designed or decided and why. Enough context that the recipient can start without a meeting.]

**What's included:**
- [Artifact 1 and where to find it]
- [Artifact 2 and where to find it]
(Spec, designs, prototype, brief — with locations)

**Key decisions:**
- [Decision]: [one sentence on what was decided and why]
- [Decision]: [one sentence]
(Decisions that the recipient must know to implement correctly)

**What's not included:**
- [What was explicitly deferred, and why]
(Explicit scope boundaries prevent scope creep in implementation)

**Dependencies:**
- [What this work depends on that may not be complete]
- [What work this blocks, if any]

**Open questions:**
- [Question that wasn't resolved — and who should resolve it]
(Questions that will come up during implementation and must be escalated, not guessed)

**Success criteria:**
Customer: [Specific behavioral outcome]
Business: [Specific measurable outcome]
```

---

## Prototype brief template

Use when commissioning or describing a prototype to be built.

```
## Prototype Brief: [Feature Name]
Date: [YYYY-MM-DD]
Fidelity: Concept / Interaction / Visual

**Question to answer:**
[One sentence. The prototype is useless unless it answers a specific question.]

**What to include:**
- [Specific flow or interaction]
- [Specific state]
(Only what is necessary to answer the question)

**What to exclude:**
- [Anything out of scope and why]
(Explicit exclusions prevent prototype scope creep)

**Evaluation criteria:**
[How to know if the prototype answered the question. What observable user behavior or reaction confirms or refutes the hypothesis?]

**Time constraint:**
[Maximum effort appropriate for this fidelity and question — prevent over-investment in a prototype that may be thrown away]
```

---

## Notes on sign-off framing

**"We shipped it" is not an outcome.** The sign-off must state what changed for the user or the business as a result.

**Be specific about decisions.** A decision log entry should be specific enough that someone returning after 3 months can understand what was decided and why — without needing to reconstruct the session.

**Forward direction is required.** A sign-off without a "recommended next" is incomplete. Every closed phase has a next phase.
