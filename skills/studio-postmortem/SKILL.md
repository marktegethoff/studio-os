---
description: Production-feedback intake — turn a shipped failure or a wrong prediction into studio memory. Routes the lesson to a candidate Named Ban (a categorical prohibition) or a precedent (a reusable decision), so the same mistake isn't made twice. Run when something that shipped didn't work, or when a prediction proved wrong.
argument-hint: "<what shipped and how it failed>"
---

Turn a production failure into a learning the studio can't forget.

Arguments: $ARGUMENTS

The studio gets smarter only if shipped failures come back as memory. This skill is that intake: it takes a real failure and decides whether it becomes a **Named Ban** (a thing agents must categorically refuse) or a **precedent** (a recorded decision future work reasons from).

---

## When to run

- A shipped feature underperformed or caused harm.
- A prediction (an assumption, a metric target, a design bet) proved wrong.
- A pattern of small failures suggests a systemic cause.

---

## Steps

1. **State the failure plainly.** What shipped, what was expected, what actually happened. No blame — the failure is a system output.
2. **Find the root, not the symptom.** Ask why until you reach a decision or assumption that, if different, would have prevented it. (Pairs with the premortem discipline in `assumption-mapper`.)
3. **Classify the lesson:**
   - **Named Ban** — if the root is a *category of move* that should never be made again (e.g., "shipped engagement mechanics dressed as a feature"). Propose it in the Named Ban format: name · what it is · trigger. Route to the agent(s) whose discipline owns it (e.g., a design ban → cd/critic; an engineering ban → de).
   - **Precedent** — if the root is a *context-specific decision* future work should reason from (not forbid). Propose a `decision-record` entry: what was decided post-hoc, the reasoning, what it supersedes.
   - **Neither** — if it was genuinely unforeseeable and no rule would have caught it. Say so; do not manufacture a ban.
4. **Confirm + deposit.** The user approves. A Named Ban is added to the owning agent file (and its eval gets a case so the ban is tested). A precedent goes to the ledger.

---

## Output

```
## Postmortem — [what shipped]
Expected: [...]   ·   Actual: [...]
Root cause: [the decision/assumption beneath the symptom]

Classification: NAMED BAN / PRECEDENT / NEITHER
Proposed: [the ban (name · what · trigger) routed to <agent>, OR the precedent record, OR "no rule — unforeseeable"]
Eval: [the new ban case to add to <agent>'s eval, if a ban]
```

---

## Rules

- **Root, not symptom.** A ban on the symptom catches nothing; a ban on the category catches the class.
- **Don't over-ban.** Not every failure is a rule. "Unforeseeable" is a valid verdict — manufactured bans erode the weight of real ones.
- **A new Named Ban gets an eval case.** Per the coverage rule, the ban is only real once an eval can catch its violation.
- **Propose, don't auto-write.** The user confirms before the ban or precedent is deposited.
