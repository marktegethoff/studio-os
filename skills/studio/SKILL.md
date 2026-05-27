---
description: "Entry point — orient, route, and show what each skill and agent produces. Run at the start of any session."
argument-hint: "[optional: initial intent, problem statement, or artifact type]"
---

Activate Studio OS and orient the user.

Arguments: $ARGUMENTS

---

## Studio OS

A structured multi-discipline reasoning system for design and product work.

**Ethos:** Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.

---

## What Studio OS produces

Studio OS is organized around artifacts — specific outputs that move work forward. When someone asks for a deliverable, route to the discipline or workflow that produces it.

### Discovery and research artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Research synthesis | Patterns from interviews, usability sessions, feedback logs | `user-researcher` |
| Journey map | User stages, friction points, moments that matter | `journey-mapper` |
| Assumption register | Ranked assumptions + binding assumption + validation paths | `assumption-mapper` |
| Design brief | Validated problem, success conditions, constraints, out of scope | `brief-writer` |
| Measurement plan | Lagging indicator, leading indicators, counter-metrics, instrumentation | `metrics-definer` |

Full discovery sequence (research → map → assumptions → brief): `/discover`

### Strategy and market artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Market signal briefing | 5 findings filtered against current product positions | `scout` |
| Competitive teardown | Feature matrix, UX patterns, positioning map, gaps | `competitive-analyst` |
| Historical precedent | What similar systems existed, what endured, what failed | `historian` |
| Strategic evaluation | Pass/fail verdict across four instrument tests | `strategist` |
| Commercial evaluation | Market differentiation, monetization fit, timing | `marketer` |

### Design and interaction artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Interaction model | States, transitions, gestures, visual hierarchy | `designer` (via `/design`) |
| Wireframe / layout description | Structural description precise enough for implementation | `designer` |
| User flow / screen flow | Stage-by-stage flow with entry/exit paths | `designer` |
| Visual execution spec | Spacing tokens, proportion relationships, alignment decisions, composition rationale | `visual-designer` |
| Icon execution | Sizing, weight, legibility at target sizes — and icon library coherence | `visual-designer` |
| High-fidelity spec | All states, tokens, spacing, typography, motion, accessibility | `specifier` |
| Type system | Scale, hierarchy, weight, rhythm, string length constraints | `typesetter` |
| Motion specification | Timing, easing, sequencing — only what's earned | `choreographer` |
| Copy and microcopy | Labels, empty states, system messages, VoiceOver strings | `writer` |
| Material evaluation | Surface finish, depth, weight, tactility | `materialist` |
| Prototype strategy | Spec vs. prototype decision, minimum fidelity scoping | `designer` |

Full design sequence (strategy → structure → design → accessibility → spec): `/design`

### Structural artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Data model | Structures, ownership, lifecycle, invariants | `architect` |
| Information architecture | Content organization, navigation model, labeling, site map | `architect` |
| System boundary definition | What each component owns, delegates, observes | `architect` |
| Simplification plan | What to remove, why, in what order | `critic` |
| Design system audit | Pattern proliferation, token drift, coverage gaps | `design-systems-governance` |

### Evaluation artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Usability findings | Friction, broken mental models, gesture dead-ends | `heurist` |
| Accessibility audit | WCAG AA contrast, touch targets, VoiceOver, motion | `accessibility` |
| Design system compliance | Mockup checked against token and type spec | `design-validator` |
| Ship/no-ship verdict (design) | 10-dimension critique + verdict | `cd` |
| Ship/no-ship verdict (code) | Code quality judgment + merge readiness | `de` |
| Documentation coherence | Contradictions, orphaned files, superseded content | `auditor` |

Full review sequence: `/critique`

### Engineering artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Engineering handoff spec | Complete spec for implementation, no ambiguity | `specifier` |
| Implementation | Working code from a confirmed spec | `engineer` |
| Test scenarios | Boundary cases, regression checks, invariant verification | `qa` |

Full engineering sequence (spec check → invariants → implement → QA): `/implement`

---

## Workflows

Workflows sequence multiple disciplines in order:

- `/discover` — User Researcher → Journey Mapper → Assumption Mapper → PM gate → Brief Writer
- `/design` — Philosophy → Historian → Strategist → Architect → Critic → Designer → Sub-team → Accessibility → Specifier
- `/measure` — Metrics Definer → PM gate → Architect (instrumentation feasibility)
- `/implement` — Spec check → Invariants → Engineer → QA
- `/solve` — Convergence loop (max 3 iterations) until inevitable
- `/critique` — Critic → Invariants → Accessibility → Decisions → Verdict
- `/experiment` — Memory check → Hypothesis → Design → Evaluation
- `/ideate` — Divergent exploration → Facilitated reduction → Engineering feasibility
- `/simplify` — Complexity audit → Simplification plan → DE gate → Implementation
- `/review` — PM + Design Director + Distinguished Engineer combined verdict

---

## Routing

If $ARGUMENTS is empty, **orient the user**: render the compact menu below, then ask the routing question. Always show the menu — never reply with only a greeting.

> **Studio OS** — a multi-discipline studio for design and product work. Pick a path:
>
> **Workflows** (sequence multiple disciplines):
> - `/discover` — research → journey → assumptions → brief
> - `/design` — full design pass (strategy → structure → design → accessibility → spec)
> - `/measure` — metrics + instrumentation feasibility
> - `/implement` — spec check → invariants → build → QA
> - `/critique` — review → ship/no-ship verdict
> - `/solve` — convergence loop for a hard problem
> - `/review` — PM + CD + DE combined verdict
> - also: `/experiment` · `/ideate` · `/simplify`
>
> Or name an **artifact** (journey map, wireframe, motion spec, data model, copy deck, accessibility audit…) or a **discipline** (designer, architect, critic, cd, de…) and I'll route you.
>
> **What are you working on — or what do you need to produce?**

Then route on the reply:

- Artifact type named (e.g. "I need a journey map", "wireframes for this flow") → look it up in the tables above and route to the correct discipline or workflow
- Design problem or new feature → suggest `/design <problem>`
- Problem unclear, user behavior uncertain → suggest `/discover <problem area>`
- "What if" hypothesis → suggest `/experiment <hypothesis>`
- Need to measure success → suggest `/measure <feature>`
- Ready to implement → suggest `/implement <feature>`
- Reviewing work → suggest `/critique <artifact>`
- Hard problem, no obvious answer → suggest `/solve <problem>`
- Specific discipline named → invoke it directly

If $ARGUMENTS is not empty, treat it as initial intent and route directly — skip the menu and the question.
