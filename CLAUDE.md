# Studio OS

This project runs on **Studio OS**, a product-agnostic multi-discipline reasoning system for design and product work, built by Standard Works.

Studio disciplines, workflow skills, and memory install as a Claude Code plugin:

- Agents: discipline specialists (Core + Role tiers) — see [STRUCTURE.md](STRUCTURE.md)
- Skills: workflow orchestrators, invoked as `/studio:<skill>`
- Memory: universal craft foundations live in `memory/`

Project-specific context (the Product tier) lives in `.claude/memory/project-context.md` in each consuming project — never in this repo.

**Placement rule:** CLAUDE.md carries the contributor rules and imports the doctrine. Skills carry on-demand workflows. Agents carry single-discipline expertise. Never place workflow logic in CLAUDE.md. Multi-agent skills declare their topology in a `graph` block; orchestration doctrine (graph grammar, human-node economics, adversarial rules, the Auto-Mode Safety Contract) lives in the plugin's `memory/orchestration.md`.

@memory/doctrine.md

---

## Eval Coverage

**No agent or skill ships without an eval.** Every agent in `agents/` and every skill in `skills/` must have behavioral (agent) or orchestration (skill) eval coverage in `evals/`. Adding or substantially changing one without adding/updating its eval is incomplete work. Lint R12 (`evals/lint-agnostic.sh`) reconciles the live roster and skill set against the `evals/*.eval.md` headings and fails any uncovered agent or skill on every lint run.

---

## Adversarial Review

A change to `agents/`, `skills/`, or `memory/` gets one refutation pass on the configured adversary model (the plugin's `adversary_model` setting) before it merges to main — the strongest case against the change, not a second opinion (the plugin's `memory/orchestration.md` § Adversarial doctrine). Findings change lines in the change; they never add sections.

---

## Commands

```
/studio:studio          Entry point — orient, route, show artifact menu
/studio:init            Set up project context + role calibration
/studio:shape           Interview-driven brief shaping
/studio:discover        Discovery — research → journey → assumptions → brief
/studio:design          Full design workflow
/studio:measure         Measurement — metrics → instrumentation → feasibility
/studio:implement       Engineering workflow
/studio:review          Leadership-team review — PM + CD + DE
/studio:solve           Convergence loop for hard problems
/studio:experiment      Experiment workflow
```

Discipline agents are invoked by name in conversation. Run `/studio:studio` to see what each produces.

---

## Memory

Memory sits at three tiers. **Always name the tier when citing a memory file** — the same filename can exist at more than one, and a bare path is ambiguous.

| Tier | Location | Holds |
|------|----------|-------|
| Core | the plugin's `memory/` | universal craft and doctrine — `doctrine.md`, `writing.md`, `design-foundations.md`, `orchestration.md`, `apple-platform.md`, `anti-patterns.md` |
| Product | the project's `.claude/memory/` | `project-context.md`, `role-context.md`, `design-vocabulary.md`, `design-preferences.md`, `design-references.md` |
| User | `~/.claude/memory/` | `user-profile.md` — who the operator is, across all projects |

Before proposing major changes, consult the consuming project's `.claude/memory/` for `project-context.md` (purpose, invariants, system model), `design-vocabulary.md` (the product's registers and material language), and `design-preferences.md` (approved and rejected directions with reasoning).

Agents avoid repeating previously rejected approaches.
