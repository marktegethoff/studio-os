# Studio OS

*Standard Works · Studio OS*

Product work with AI drifts without structure — agents generate without gates, design begins before the problem is validated, code ships without a spec. Studio OS installs a design studio into Claude Code: **33 discipline agents** and a set of **workflow skills** that gate each stage before the next can begin.

Product-agnostic by design. Built for product and design teams working alongside engineering — useful for a solo practitioner, designed for a team.

Nothing arbitrary, nothing extra, nothing essential missing.

---

## How it works

Each workflow skill orchestrates a sequence of discipline agents against a problem. Agents are not interchangeable — they are roles with defined scope, sequencing, and output contracts. A designer does not run before a strategist and architect have constrained the space. A specifier does not run before a designer has produced an interaction model.

Three agents form the senior gate structure, run in sequence:

- **PM** (`pm`) — the problem gate. Validates the customer problem before design begins.
- **Creative Director** (`cd`) — the design gate. SHIP / NO-SHIP before implementation begins.
- **Distinguished Engineer** (`de`) — the engineering gate. SHIP / REVISE / REJECT before any merge.

When a verdict requires further work, each gate names the specific agent or skill that resolves it — not just the problem.

The studio is organized in three tiers — **Core** (universal craft + the Standard Works philosophy), **Role** (discipline agents), and **Product** (one product's context, which lives in your project, not here). See [STRUCTURE.md](STRUCTURE.md) for the full tier map and the 33-agent roster.

---

## Install

Studio OS is a Claude Code plugin.

**From the marketplace:**

```bash
claude plugin marketplace add marktegethoff/studio-os
claude plugin install studio-os@standard-works
```

Update any time with `claude plugin update studio-os`. Agents and skills are namespaced (`studio-os:designer`, `/studio-os:design`) so they never collide with your own.

**Develop / edit-live** (the source becomes the install — edits go live with `/reload-plugins`):

```bash
claude --plugin-dir /path/to/studio-os
```

**Fallback** (non-plugin contexts): `./install.sh` copies agents and skills into `~/.claude/`.

Then, in any project, set up product context:

```
/studio-os:init
```

This interviews you for your product's purpose, principles, invariants, and stack, and writes `.claude/memory/project-context.md` — the Product tier. Studio OS works without it, but agents fall back to generic reasoning. The calibration is the point.

---

## Workflow skills

```
/studio-os:studio        Entry point — orient and route
/studio-os:init          Set up project context
/studio-os:shape         Interview-driven brief shaping
/studio-os:discover      Problem framing and research
/studio-os:ideate        Divergent exploration before committing
/studio-os:design        Full design workflow
/studio-os:prototype     Get to a testable prototype fast
/studio-os:handoff       Prototype → production-ready package
/studio-os:implement     Engineering workflow
/studio-os:measure       Define and evaluate metrics
/studio-os:experiment    Experiment design and evaluation
/studio-os:simulate      Long-horizon behavior simulation
/studio-os:solve         Convergence loop for hard problems
/studio-os:review        Leadership-team review — PM + CD + DE
/studio-os:critique      Single-pass quality review
/studio-os:simplify      Codebase coherence workflow
/studio-os:scope         Scope a task tight enough to delegate
```

Discipline agents can also be invoked directly by name. Run `/studio-os:studio` to see what each produces.

Each workflow leaves behind artifacts the next session can read — briefs, journeys, interaction models, specs, metrics plans — each rendered as a well-designed HTML document with a built-in feedback harness.

---

## Adapting it

Studio OS reflects a specific position on how design and product work should be done — the Standard Works philosophy. You may not share all of it.

Use it for a few projects. Notice where the principles serve you and where they don't. Then change what needs to change — the agents, the workflows, the philosophy. The point of this system is not to inherit someone else's judgment. It is to build the infrastructure to exercise your own more rigorously.

See [PHILOSOPHY.md](PHILOSOPHY.md) for the reasoning behind the defaults, and [EXAMPLES.md](EXAMPLES.md) for the system in use.

---

## Credits

Built by [Mark Tegethoff](https://github.com/marktegethoff) at [Standard Works](https://standardworks.co).

The `luck` durability diagnostic was developed by [Soleio](https://github.com/soleio/luck).
