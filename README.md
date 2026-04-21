# XD OS

Product work with AI drifts without structure — agents generate without gates, design begins before the problem is validated, code ships without a spec. XD OS installs structural discipline into Claude Code: 30 discipline agents and 13 workflow skills that gate each stage before the next can begin.

Built for product and design teams working alongside engineering. Useful for a solo designer; designed for a team.

Nothing arbitrary, nothing extra, nothing essential missing.

---

## How it works

Each workflow skill orchestrates a sequence of discipline agents against a problem. Agents are not interchangeable — they are roles with defined scope, sequencing, and output contracts. A designer does not run without a strategist and architect having constrained the space. A specifier does not run without a designer having produced an interaction model.

Three agents form the senior gate structure:

- **PM** (`pm`) — the upstream gate. Validates the customer problem before design begins. Runs first on any new product direction.
- **Design Director** (`xd-design-director`) — the design gate. SHIP / NO-SHIP before implementation begins.
- **Distinguished Engineer** (`de`) — the engineering gate. SHIP / REVISE / REJECT before any merge.

These gates are sequential: PM → Design Director → DE. When a verdict requires further work, each gate names the specific agent or skill that resolves it — not just the problem.

Two context files calibrate agents to your specific work:

- **`project-context.md`** — written once per product via `/xd-init`. Contains your system invariants, prior decisions, and design principles. Agents read this to avoid repeating rejected approaches and to apply your team's standards.
- **`user-profile.md`** — written during `./xd setup`. Contains your role, skills, and experience level. Agents use this to calibrate how they work with you.

---

## Quick start

Requires [Claude Code](https://claude.ai/code).

```bash
git clone https://github.com/marktegethoff/xd-os
cd xd-os
./xd setup
```

`./xd setup` asks for your primary discipline (Design, Product, Engineering, or All), installs the relevant agents and skills, then asks three questions to build your personal profile.

Then, in any Claude Code session in your project:

```
/xd-init
```

This runs an interview that captures your product's purpose, brand principles, system invariants, user archetypes, and tech stack. It writes `.claude/memory/project-context.md`. The interview takes about 10 minutes.

XD OS works without this file, but agents fall back to generic reasoning. The calibration is the point.

---

## Agents

Core agents are installed for everyone. Role packages add discipline-specific agents at setup. In team settings: org admins manage Core, individuals choose their Role package, and project leads run `/xd-init` to produce Product context.

**Core**

| Agent | Output |
|---|---|
| `pm` | Product brief — READY or HOLD with specific blockers |
| `xd-design-director` | SHIP / NO-SHIP verdict on a design artifact |
| `de` | SHIP / REVISE / REJECT verdict on a plan or implementation |
| `xd-heurist` | Heuristic evaluation with P0–P3 severity findings |
| `xd-audit` | Documentation contradiction map and archive proposals |
| `competitive-analyst` | Feature coverage matrix, UX pattern analysis, gap identification |

**Design role** — `./xd setup [D]` or `[A]`

| Agent | Output |
|---|---|
| `xd-designer` | Interaction model and state map |
| `xd-specifier` | Engineering handoff spec — all states, tokens, interactions |
| `xd-typesetter` | Type system definition or audit |
| `xd-choreographer` | Motion spec — timing, easing, sequencing |
| `xd-visual-designer` | Spacing, proportion, and alignment corrections |
| `xd-materialist` | Surface quality evaluation — depth, weight, texture |
| `xd-writer` | Copy — labels, empty states, error messages, microcopy |
| `xd-critic` | Reduction list — what to remove and why |
| `xd-strategist` | BELONGS / DOES NOT BELONG / BELONGS IF verdict |
| `xd-historian` | Precedent report — cited tools, dates, and failure modes |
| `xd-accessibility` | WCAG AA audit findings with remediation |
| `xd-validate-design` | Design system compliance findings |
| `mark-maker` | Mark, symbol, and icon evaluation |
| `xd-user-researcher` | Research synthesis |
| `xd-scout` ⁺ | Market signal briefing, max 5 findings |

**Product role** — `./xd setup [P]` or `[A]`

| Agent | Output |
|---|---|
| `brief-writer` | Structured problem brief |
| `assumption-mapper` | Assumption map with confidence ratings |
| `xd-journey-mapper` | Journey map with pain points and opportunities |
| `metrics-definer` | Metric definitions — outcome, input, and output |
| `marketer` | Commercial viability evaluation |
| `xd-critic` | *(shared)* Reduction list |
| `xd-historian` | *(shared)* Precedent report |
| `xd-strategist` | *(shared)* BELONGS / DOES NOT BELONG / BELONGS IF verdict |
| `xd-user-researcher` | *(shared)* Research synthesis |
| `xd-research-sweep` ⁺ | Trend report — field developments vs. current positions |
| `xd-scout` ⁺ | *(shared)* Market signal briefing |

**Engineering role** — `./xd setup [E]` or `[A]`

| Agent | Output |
|---|---|
| `xd-engineer` | Implemented feature |
| `xd-qa` | Test scenarios and invariant verification |
| `xd-architect` | Data model, system boundaries, and integration contracts |
| `xd-specifier` | *(shared)* Engineering handoff spec |
| `xd-research-sweep` ⁺ | *(shared)* Trend report |

⁺ Requires WebSearch. Skipped automatically in `--no-web` environments.

Agents shared across roles are installed once.

---

## Workflow skills

```
/xd               Entry point — orient and route
/xd-init          Set up project context
/xd-design        Full design workflow
/xd-discovery     Problem framing and research
/xd-ideate        Divergent exploration before committing
/xd-prototype     Get to a testable prototype fast
/xd-prepare-handoff   Prototype to production-ready handoff package
/xd-implement     Engineering workflow
/xd-simplify      Codebase coherence workflow
/xd-review        Review an artifact
/xd-solve         Convergence loop for hard problems
/xd-experiment    Experiment design and evaluation
/xd-measure       Define and evaluate metrics
/lt-review        Full Leadership Team review — PM + Design Director + DE
/design-system-init   Scaffold a design system skill for this project
```

The skills most likely to begin new product work (`/xd-design`, `/xd-ideate`, `/xd-solve`, `/xd-discovery`) each check for a validated PM brief before proceeding. Individual agents can also be invoked directly by name.

Each workflow leaves behind artifacts that the next session can read:

| Workflow | Artifacts produced |
|---|---|
| `/xd-init` | `project-context.md`, `role-context.md` |
| `/xd-discovery` | Problem brief, assumptions map, research synthesis |
| `/xd-design` | Interaction model, copy, engineering spec |
| `/xd-ideate` | Divergence output, facilitated reduction, feasibility verdicts |
| `/xd-prototype` | Test question, build criteria, test criteria, findings routing |
| `/xd-prepare-handoff` | All states + flows, synthetic data, UAT scenarios, build spec |
| `/xd-implement` | Implemented feature, DE verdict, QA results |
| `/xd-simplify` | Audit findings, simplification plan, DE-reviewed code |
| `/xd-experiment` | Hypothesis, test design, measurement plan |
| `/xd-measure` | Metrics definitions, instrumentation spec |
| `/lt-review` | PM + Design Director + DE verdicts on a single artifact |

---

## Adapting it

XD OS reflects a specific position on how design and product work should be done. You may not share all of it.

Use it for a few projects. Notice where the principles serve you and where they don't. Then change what needs to change — the agents, the workflows, the philosophy.

The point of this system is not to inherit someone else's judgment. It is to build the infrastructure to exercise your own more rigorously.

See [PHILOSOPHY.md](PHILOSOPHY.md) for the reasoning behind the defaults.

See [EXAMPLES.md](EXAMPLES.md) for illustrative examples of the system in use.

---

## Credits

Built by [Mark Tegethoff](https://github.com/marktegethoff).

The `luck` durability diagnostic was developed by [Soleio](https://github.com/soleio/luck). It is not included in this repository.
