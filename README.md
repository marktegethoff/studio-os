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

## Three-tier distribution model

XD OS is organized into three tiers, each owned by a different level of the organization.

**Core** — installed for everyone, org-managed. These agents cannot be overridden by role packages. Includes PM, Design Director, Distinguished Engineer, Heurist, Audit, and Competitive Analyst.

**Role** — installed per discipline at setup time. Design, Product, and Engineering each have a curated set of agents and skills. Team members install what their work requires; they don't carry agents irrelevant to their role.

**Product** — per-repo context. The `project-context.md` and `role-context.md` files produced by `/xd-init` and project team interviews. This is where your product's specific decisions, constraints, and principles live.

In a team setting: org admins manage Core, individuals choose their Role package, and project leads run `/xd-init` to produce Product context.

---

## Agents at a glance

**Core (installed for everyone)**
`pm` · `xd-design-director` · `de` · `xd-heurist` · `xd-audit` · `competitive-analyst`

**Design role**
`xd-designer` · `xd-typesetter` · `xd-choreographer` · `xd-visual-designer` · `xd-writer` · `xd-materialist` · `xd-critic` · `xd-strategist` · `xd-historian` · `xd-accessibility` · `xd-validate-design` · `xd-specifier` · `xd-design-systems` · `xd-scout` · `xd-user-researcher`

**Product role**
`brief-writer` · `assumption-mapper` · `xd-journey-mapper` · `metrics-definer` · `xd-research-sweep` · `marketer` · `xd-critic` · `xd-historian` · `xd-strategist` · `xd-user-researcher` · `xd-scout`

**Engineering role**
`engineer` · `qa` · `xd-architect` · `xd-specifier` · `xd-research-sweep`

Agents shared across roles (critic, historian, strategist, and others) are installed once regardless of how many roles a user has.

---

## Workflow skills

```
/xd               Entry point — orient and route
/xd-init          Set up project context
/xd-design        Full design workflow
/xd-discovery     Problem framing and research
/xd-ideate        Divergent exploration before committing
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

---

## What XD OS produces

Each workflow leaves behind artifacts that the next session can read. Over time these accumulate into a precise record of your product's design logic.

| Workflow | Artifacts produced |
|---|---|
| `/xd-init` | `project-context.md`, `role-context.md` |
| `/xd-discovery` | Problem brief, assumptions map, research synthesis |
| `/xd-design` | Interaction model, copy, engineering spec |
| `/xd-ideate` | Divergence output, facilitated reduction, feasibility verdicts |
| `/xd-implement` | Implemented feature, DE verdict, QA results |
| `/xd-simplify` | Audit findings, simplification plan, DE-reviewed code |
| `/xd-experiment` | Hypothesis, test design, measurement plan |
| `/xd-measure` | Metrics definitions, instrumentation spec |
| `/lt-review` | PM + Design Director + DE verdicts on a single artifact |

---

## Codebase coherence

Agents generate code faster than review can track. Without a structural gate, implementations drift — duplicated patterns, single-use abstractions, orphaned code. Two agents address this directly.

**`de`** evaluates implementations against a specification and delivers one verdict: SHIP, REVISE, or REJECT. It runs twice in any engineering workflow: before implementation begins, to verify the plan is sound; and after QA, to gate the merge.

**`/xd-simplify`** is a periodic coherence workflow. Point it at a file or directory. It audits for complexity drift, converges a simplification plan through Critic, Architect, and DE, implements the reduction, and gates the result through DE before anything merges.

---

## Adapting it

XD OS reflects a specific position on how design and product work should be done. You may not share all of it.

Use it for a few projects. Notice where the principles serve you and where they don't. Then change what needs to change — the agents, the workflows, the philosophy.

The point of this system is not to inherit someone else's judgment. It is to build the infrastructure to exercise your own more rigorously.

See [PHILOSOPHY.md](PHILOSOPHY.md) for the reasoning behind the defaults.

See [CASE-STUDIES.md](CASE-STUDIES.md) for illustrative examples of the system in use.

---

## Credits

Built by [Standard Works](https://standardworks.co).

The `luck` durability diagnostic was developed by [Soleio](https://github.com/soleio/luck). It is not included in this repository.
