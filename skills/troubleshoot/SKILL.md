---
description: "Converge multiple engineering lenses on a hairy technical problem — a performance wall, an architecture fork, a gnarly cross-stack bug, a build-vs-buy call. The engineering counterpart to /solve: runs a bounded convergence loop through the Architect, the relevant stack engineers, and the Distinguished Engineer until the right technical approach is inevitable. Use when a technical problem has no obvious right answer or prior attempts haven't converged."
argument-hint: "<the technical problem to solve>"
---

Converge on the right technical approach to a hard problem.

Arguments: $ARGUMENTS

This is the engineering sibling of `/solve` (which is design-flavored). Where `/solve` runs Historian → Design → Critic → CD, this runs **Architect → stack engineers → Distinguished Engineer**. The gate is the DE, not the CD.

When you reach a PAUSE block: stop, output the pause text, and wait for the user before continuing.

---

## When to use

- A performance or scale wall with no obvious fix.
- An architecture fork (which data model / sync model / boundary?) where each option has real cost.
- A gnarly bug that crosses layers or stacks and resists the single-engineer view.
- A build-vs-buy / build-vs-defer technical decision (pairs with `luck` for durability).

Not for: routine implementation (use `/implement`), a spec'd feature (use `/implement`), or a design problem (use `/solve`).

---

## Lenses convened

Convene at least the three that make a technical decision sound; add stack engineers by the problem's surface:

- **Architect** — structure, boundaries, data model, the system-level consequence of each option.
- **Stack engineer(s)** — the relevant specialist(s) from the engineer family (`swift-engineer`, `web-engineer`, or a setup-added specialist) for what is actually feasible and idiomatic on this stack. More than one when the problem crosses stacks.
- **Distinguished Engineer** — the gate: simplicity, durability, what compounds vs. what becomes debt. Renders the verdict.
- *Optional:* `luck` for 2+ year durability calls · `qa` for "how would we even verify this" · `specifier` when the output must become an implementable spec.

---

## Project Context

Read at start: `.claude/memory/project-context.md` (stack, invariants, prior technical decisions) → else `CLAUDE.md`. Load any prior decision/spec named in the problem. State clearly if no context is found.

---

## Convergence loop (max 3 iterations)

1. **Frame** — restate the problem as the actual technical question, not the symptom. Name the constraints (stack, invariants, time, reversibility) and what "solved" means.
2. **Diverge** — Architect + stack engineers produce candidate approaches. Each candidate: how it works, its cost, what it constrains downstream, how reversible it is.
3. **Pressure-test** — the DE attacks each candidate for hidden complexity, debt, and invariant violations. The Architect flags any that require a primitive/relationship/migration the team hasn't decided.
4. **Converge** — reduce to the approach that is simplest-correct and most durable. If two survive, name the single condition that decides between them.
5. **DE verdict** — PROCEED (with the chosen approach) / NEEDS A DECISION (a named open question blocks) / REJECT (none are sound; reframe).

Stop at convergence or after 3 iterations. If 3 iterations don't converge, say so plainly and name what's missing (a constraint, a measurement, a decision the user must make) — do not force a false answer.

---

## Output Format

```
## Technical Solve: [problem]

**The real question:** [the technical question beneath the symptom]
**Constraints:** [stack · invariants · reversibility · time]
**"Solved" means:** [the bar]

### Candidates considered
1. [approach] — how it works · cost · what it constrains · reversibility
2. ...

### Recommended approach
[The chosen approach and why it is simplest-correct and most durable.]
**Deciding factor:** [if two were close, the one condition that chose]
**Risks / what to watch:** […]

**DE verdict:** PROCEED / NEEDS A DECISION / REJECT — [one line]
**Next:** [implement via /implement with a spec · or the decision the user must make first]
```

---

The deliverable is a technical decision with its reasoning, owned by the Distinguished Engineer's verdict. It does not write production code — it decides the approach; `/implement` builds it.
