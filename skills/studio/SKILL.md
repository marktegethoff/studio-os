---
description: Activate Studio OS and orient the user. Routes to the appropriate workflow command based on what the user is working on. Use as the entry point when unsure which studio discipline or workflow to invoke.
argument-hint: "[optional: initial intent or problem statement]"
---

Activate Studio OS and orient the user.

Arguments: $ARGUMENTS

---

## Studio OS

A structured multi-discipline reasoning system for design and product work.

**Ethos:** Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.

**Available workflows:**
- `studio-design` — full design workflow (Context → Historian → Strategist → Architect → Critic → Designer → Sub-team → Accessibility → Specifier)
- `studio-implement` — engineering workflow (Spec check → Invariants → Engineer → QA)
- `studio-solve` — convergence loop for hard problems (max 3 iterations to inevitable)
- `studio-review` — review workflow (Critic → Invariants → Accessibility → Decisions → Verdict)
- `studio-experiment` — experiment workflow (Memory check → Hypothesis → Design → Evaluate)

**Available disciplines (activate directly):**

Strategic:
- `studio-scout` — external market signal, filtered to current positions
- `studio-historian` — precedent and pattern research
- `studio-strategist` — product and value evaluation
- `studio-marketer` — commercial viability and market position

Structural:
- `studio-architect` — system structure and data model
- `studio-critic` — complexity reduction

Design team:
- `studio-designer` — interaction model, states, transitions, visual hierarchy (leads the design team)
- `choreographer` — motion logic and transition specification
- `typesetter` — type systems, hierarchy, scale, rhythm
- `visual-designer` — spacing, proportion, alignment, visual execution
- `writer` — microcopy, empty states, voice, VoiceOver labels
- `materialist` — surface qualities, depth, tactility
- `mark-maker` — identity marks, symbols, logos
- `prototyper` — prototype strategy and fidelity scoping

Evaluation:
- `studio-creative-director` — master-level design critique and ship/no-ship judgment
- `studio-heurist` — usability friction and heuristic evaluation
- `studio-accessibility` — WCAG and inclusive design verification
- `studio-validate-design` — design system compliance audit
- `specifier` — engineering handoff documentation

Engineering:
- `studio-engineer` — implementation
- `studio-qa` — test coverage and invariant verification

Ongoing:
- `studio-audit` — documentation coherence audit
- `studio-research-sweep` — quarterly design trend research sweep
- `studio-scout` — market signal scan

Setup:
- `studio-init` — set up project context for this project

---

If $ARGUMENTS is empty:

Greet the user briefly. Ask:

> What are you working on?

Listen, then route:
- Design problem or new feature → suggest `studio-design <problem>`
- "What if" hypothesis → suggest `studio-experiment <hypothesis>`
- Ready to implement → suggest `studio-implement <feature>`
- Reviewing work → suggest `studio-review <artifact>`
- Hard problem, no obvious answer → suggest `studio-solve <problem>`
- First time using Studio OS → suggest `studio-init`
- Specific discipline → suggest the relevant discipline skill

If $ARGUMENTS is not empty, treat it as initial intent and route directly without asking.

Keep greeting to one sentence. Ask one question. Do not list all commands unprompted.
