# Studio OS

Product work with AI moves fast and drifts without structure — agents generate without gates, design begins before the problem is validated, code ships without a spec. Studio OS installs structural discipline into Claude Code: 25 agents and 11 workflow skills that gate each stage before the next can begin.

Nothing arbitrary, nothing extra, nothing essential missing.

---

## How it works

Each workflow skill orchestrates a sequence of discipline agents against a problem. Agents are not interchangeable — they are roles with defined scope, sequencing, and output contracts. A designer does not run without a strategist and architect having already constrained the space. A specifier does not run without a designer having produced an interaction model.

Three agents form the senior gate structure:

- **PM** (`studio-pm`) — the upstream gate. Validates the customer problem before design begins. Runs first on any new product direction.
- **Creative Director** (`studio-creative-director`) — the design gate. SHIP / NO-SHIP before implementation begins.
- **Distinguished Engineer** (`studio-de`) — the engineering gate. SHIP / REVISE / REJECT before any merge.

These gates are sequential: PM → CD → DE. When a verdict requires further work, each gate names the specific agent or skill that resolves it — not just the problem.

The `project-context.md` file is loaded at the start of every workflow. It contains your system invariants, prior decisions, and design principles. Agents use it to avoid repeating rejected approaches and to calibrate their judgment to your product.

---

## Quick start

Requires [Claude Code](https://claude.ai/code).

```bash
git clone https://github.com/marktegethoff/studio-os
cd studio-os
./install.sh
```

Then, in any Claude Code session in your project:

```
/studio-init
```

This runs an interview that captures your product's purpose, brand principles, system invariants, user archetypes, and tech stack. It writes `.claude/memory/project-context.md` — the file every agent reads to calibrate to your product. The interview takes about 10 minutes.

Studio OS works without this file, but agents fall back to generic reasoning. The calibration is the point.

---

## Workflow commands

```
/studio                          Entry point — orient and route
/studio-init                     Set up project context
/design-system-init              Scaffold a design system skill for this project
/studio-ideate <problem>         Divergent brainstorm — explore before committing
/studio-design <problem>         Full design workflow
/studio-implement <feature>      Engineering workflow
/studio-simplify <file or area>  Code coherence workflow
/studio-review <artifact>        Review workflow
/studio-solve <problem>          Convergence loop for hard problems
/studio-experiment <hypothesis>  Experiment workflow
/lt-review <artifact>            Full Leadership Team review — PM + CD + DE
```

The four skills most likely to begin new product work (`studio-pm`, `studio-design`, `studio-ideate`, `studio-solve`) each check for a validated PM brief before proceeding. Individual agents can also be invoked directly by name.

---

## Agents and skills

**25 discipline agents**, organized by function:

- **Leadership** — pm, creative-director, distinguished-engineer (de)
- **Strategic** — historian, strategist, scout, marketer
- **Structural** — architect, critic
- **Design team** — designer (leads), choreographer, typesetter, visual-designer, writer, materialist, mark-maker, prototyper
- **Evaluation** — heurist, accessibility, validate-design, specifier
- **Engineering** — engineer, qa
- **Ongoing** — audit, research-sweep

**11 workflow skills** that orchestrate agents in sequence for common work patterns.

---

## Codebase coherence

Agents generate code faster than review can track. Without a structural gate, implementations drift — duplicated patterns, single-use abstractions, orphaned code. The codebase becomes harder to extend and harder for future agents to reason about correctly.

Two agents address this directly.

**`distinguished-engineer`** (DE) evaluates implementations against a specification and delivers one verdict: SHIP, REVISE, or REJECT. It runs twice in any engineering workflow: before implementation begins, to verify the plan is sound; and after QA, to gate the merge. It can also be invoked standalone after any `studio-implement` run.

**`studio-simplify`** is a periodic coherence workflow. Point it at a file or directory. It audits for complexity drift, converges a simplification plan through Critic, Architect, and DE, implements the reduction, and gates the result through DE before anything merges.

---

## Adapting it

Studio OS reflects a specific position on how design and product work should be done. You may not share all of it. That is expected.

Use it for a few projects. Notice where the principles serve you and where they don't. Then change what needs to change — the agents, the workflows, the philosophy.

The point of this system is not to inherit someone else's judgment. It is to build the infrastructure to exercise your own more rigorously.

See [PHILOSOPHY.md](PHILOSOPHY.md) for the reasoning behind the defaults.

See [CASE-STUDIES.md](CASE-STUDIES.md) for illustrative examples of the system in use.

---

## Credits

Built by [Standard Works](https://standardworks.co).

The `luck` durability diagnostic was developed by [Soleio](https://github.com/soleio/luck). It is not included in this repository.
