---
description: Activate XD OS and orient the user. Routes to the appropriate workflow or discipline based on what the user is working on or what artifact they need. Use as the entry point when unsure which workflow to invoke or what can be produced.
argument-hint: "[optional: initial intent, problem statement, or artifact type]"
---

Activate XD OS and orient the user.

Arguments: $ARGUMENTS

---

## XD OS

A structured multi-discipline reasoning system for design and product work.

**Ethos:** Work must feel inevitable. Nothing arbitrary. Nothing extra. Nothing essential missing.

---

## What XD OS produces

XD OS is organized around artifacts — specific outputs that move work forward. When someone asks for a deliverable, route to the discipline or workflow that produces it.

### Discovery and research artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Research synthesis | Patterns from interviews, usability sessions, feedback logs | `xd-user-researcher` |
| Journey map | User stages, friction points, moments that matter | `xd-journey-mapper` |
| Assumption register | Ranked assumptions + binding assumption + validation paths | `assumption-mapper` |
| Design brief | Validated problem, success conditions, constraints, out of scope | `brief-writer` |
| Measurement plan | Lagging indicator, leading indicators, counter-metrics, instrumentation | `metrics-definer` |

Full discovery sequence (research → map → assumptions → brief): `/xd-discovery`

### Strategy and market artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Market signal briefing | 5 findings filtered against current product positions | `xd-scout` |
| Competitive teardown | Feature matrix, UX patterns, positioning map, gaps | `competitive-analyst` |
| Historical precedent | What similar systems existed, what endured, what failed | `xd-historian` |
| Strategic evaluation | Pass/fail verdict across four instrument tests | `xd-strategist` |
| Commercial evaluation | Market differentiation, monetization fit, timing | `marketer` |

### Design and interaction artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Interaction model | States, transitions, gestures, visual hierarchy | `designer` (via `/design`) |
| Wireframe / layout description | Structural description precise enough for implementation | `designer` |
| User flow / screen flow | Stage-by-stage flow with entry/exit paths | `designer` |
| Visual execution spec | Spacing tokens, proportion relationships, alignment decisions, composition rationale | `xd-visual-designer` |
| Icon execution | Sizing, weight, legibility at target sizes — and icon library coherence | `xd-visual-designer` |
| High-fidelity spec | All states, tokens, spacing, typography, motion, accessibility | `xd-specifier` |
| Type system | Scale, hierarchy, weight, rhythm, string length constraints | `xd-typesetter` |
| Motion specification | Timing, easing, sequencing — only what's earned | `xd-choreographer` |
| Copy and microcopy | Labels, empty states, system messages, VoiceOver strings | `xd-writer` |
| Material evaluation | Surface finish, depth, weight, tactility | `xd-materialist` |
| Prototype strategy | Spec vs. prototype decision, minimum fidelity scoping | `designer` |

Full design sequence (strategy → structure → design → accessibility → spec): `/design`

### Structural artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Data model | Structures, ownership, lifecycle, invariants | `xd-architect` |
| Information architecture | Content organization, navigation model, labeling, site map | `xd-architect` |
| System boundary definition | What each component owns, delegates, observes | `xd-architect` |
| Simplification plan | What to remove, why, in what order | `xd-critic` |
| Design system audit | Pattern proliferation, token drift, coverage gaps | `xd-design-systems` |

### Evaluation artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Usability findings | Friction, broken mental models, gesture dead-ends | `xd-heurist` |
| Accessibility audit | WCAG AA contrast, touch targets, VoiceOver, motion | `xd-accessibility` |
| Design system compliance | Mockup checked against token and type spec | `xd-validate-design` |
| Ship/no-ship verdict (design) | 10-dimension critique + verdict | `xd-design-director` |
| Ship/no-ship verdict (code) | Code quality judgment + merge readiness | `de` |
| Documentation coherence | Contradictions, orphaned files, superseded content | `audit` |

Full review sequence: `/xd-review`

### Engineering artifacts

| Artifact | Produces | How to invoke |
|---|---|---|
| Engineering handoff spec | Complete spec for implementation, no ambiguity | `xd-specifier` |
| Implementation | Working SwiftUI code from a confirmed spec | `xd-ios` |
| Test scenarios | Boundary cases, regression checks, invariant verification | `qa` |

Full engineering sequence (spec check → invariants → implement → QA): `/xd-implement`

---

## Workflows

Workflows sequence multiple disciplines in order:

- `/xd-discovery` — User Researcher → Journey Mapper → Assumption Mapper → PM gate → Brief Writer
- `/design` — Philosophy → Historian → Strategist → Architect → Critic → Designer → Sub-team → Accessibility → Specifier
- `/xd-measure` — Metrics Definer → PM gate → Architect (instrumentation feasibility)
- `/xd-implement` — Spec check → Invariants → Engineer → QA
- `/xd-solve` — Convergence loop (max 3 iterations) until inevitable
- `/xd-review` — Critic → Invariants → Accessibility → Decisions → Verdict
- `/xd-experiment` — Memory check → Hypothesis → Design → Evaluation
- `/xd-ideate` — Divergent exploration → Facilitated reduction → Engineering feasibility
- `/xd-simplify` — Complexity audit → Simplification plan → DE gate → Implementation
- `/lt-review` — PM + Design Director + Distinguished Engineer combined verdict

---

## Routing

If $ARGUMENTS is empty:

Greet briefly. Ask:

> What are you working on — or what do you need to produce?

Listen, then route:

- Artifact type named (e.g., "I need a journey map", "wireframes for this flow") → look up the artifact in the tables above and route to the correct discipline or workflow
- Design problem or new feature → suggest `/design <problem>`
- Problem unclear, user behavior uncertain → suggest `/xd-discovery <problem area>`
- "What if" hypothesis → suggest `/xd-experiment <hypothesis>`
- Need to measure success → suggest `/xd-measure <feature>`
- Ready to implement → suggest `/xd-implement <feature>`
- Reviewing work → suggest `/xd-review <artifact>`
- Hard problem, no obvious answer → suggest `/xd-solve <problem>`
- First time using XD OS → suggest `/xd-init`
- Specific discipline named → invoke it directly

If $ARGUMENTS is not empty, treat it as initial intent and route directly without asking.

Keep greeting to one sentence. Ask one question. Do not list all commands unprompted.
