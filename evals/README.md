# Studio OS — Agent Evals

Behavioral evals for every agent in the roster. Each eval is a prompt + pass criteria + anti-patterns that tests whether an agent holds its discipline. Scenarios are **product-agnostic**; a consuming project may add its own product-specific evals alongside these.

---

## Coverage

All **35 agents + 28 skills** (23 active + 5 deprecated pending archive — simulate, luck, annotate, gather-feedback, scope) are covered across 9 files (all 35 agents named; `swift-engineer` (Evals 8–11) and `web-engineer` (Eval 13) each carry their own behavioral evals in `engineering-agents.eval.md` in addition to inheriting `engineer`'s base scenarios; `evals/lint-agnostic.sh` R5 remains the structural check that every `*-engineer.md` carry a `scaffold-commands` anchor):

| File | Covers |
|---|---|
| `leadership-agents.eval.md` | pm · strategist · critic · marketer · auditor · luck · surveyor |
| `cd.eval.md` | cd |
| `engineering-agents.eval.md` | architect · engineer · swift-engineer · web-engineer · de · qa |
| `design-agents.eval.md` | designer · choreographer · typesetter · writer · specifier · prototyper |
| `surface-agents.eval.md` | materialist · visual-designer · mark-maker · accessibility · heurist · design-validator · systematist |
| `discovery-agents.eval.md` | journey-mapper · user-researcher · brief-writer · metrics-definer · assumption-mapper |
| `analysis-agents.eval.md` | scout · competitive-analyst |
| `historian.eval.md` | historian |
| `skills.eval.md` | all 28 workflow skills (orchestration + graph-conformance evals; deprecated skills marked inline) |

### Coverage rule — no agent or skill ships without an eval

**Every agent and every skill must have eval coverage. Adding one without an eval is incomplete work.** When you add or substantially change an agent or skill:
1. Add or update its eval in the appropriate file above (agents → the matching group file; skills → `skills.eval.md`).
2. If it's a net-new discipline group, add a new `*-agents.eval.md` and list it here.
3. The lint (R12) performs the reconciliation: every `agents/*.md` needs a `## <Display Name> —` heading in an `evals/*.eval.md` (or be the singular `Agent:` of a file that has `## Eval` headings), and every `skills/*/` a `## <name>` heading in `skills.eval.md` — **an agent or skill with no eval fails**, on every lint run, not only at suite time.

This rule is mirrored in `CLAUDE.md` so it governs all contributors, and is enforced on every lint run (R12) and on the Phase 3 scheduled-eval cadence.

---

## Two ways to run

**1. Targeted run** — after changing a single agent file, run only that agent's evals (find it in the table above). Fast feedback loop.

**2. Full-suite run** — run **every** eval across **all** agents and produce **one consolidated package**: per-agent results, an overall verdict, and prioritized recommendations. Use this before a release, after a cross-cutting change (philosophy, design-foundations, a Named-Ban edit), and on the scheduled cadence (Phase 3 cron). The suite is one report, not eight.

### Full-suite procedure

0. **Structural lint** — run `evals/lint-agnostic.sh` (and `evals/lint-agnostic.sh --project <path>` for any consuming project under test). The lint enforces the seam invariants the agents/skills depend on (no product names, no stack-token leaks across files, specialist `scaffold-commands` anchors present, INCLUDED-BY-REFERENCE invariant) and the orchestration invariants from `memory/orchestration.md` (R7 graph-block validity, R7.b Six Functions coverage via `six-functions.map`, R7.c executor conformance, R7.d refutation-node conformance — every `refute*` node cites `${user_config.adversary_model}` in its SKILL.md, passes it to the executor as `adversaryModel`, and routes every refutation through `refute()` in its workflow.js, R8 auto-contract stub, R11 agent model & effort — each agent's frontmatter matches its row in the § Model and effort table, and no prose pins a model, R12 eval coverage — a heading per agent and per skill, per the Coverage rule above). FAILs block the suite.

1. For each eval file, run every eval: send the prompt(s) to the named agent, score each criterion PASS / PARTIAL / FAIL, flag any anti-pattern fired.
2. Roll up per agent: an agent PASSES only if all its evals pass. A single failed criterion fails that eval; a single failed eval fails that agent.
3. Roll up overall: the suite PASSES only if every agent passes.
4. Produce the consolidated report below — and, crucially, **evaluative recommendations**: for each failure, name the agent, the behavior that broke, and the specific fix (which section of the agent file to change). Rank recommendations by severity (gate agents and Named-Ban failures first).

### Consolidated report template

```
Studio OS — Full Eval Suite Run — [date]
Triggered by: [what changed]

ROSTER RESULT
  Core:        pm ✓ · cd ✓ · de ✓ · heurist ✓ · auditor ✓ · luck ✓ · competitive-analyst ✓ · surveyor ✓
  Engineering: architect ✓ · engineer ✓ · swift-engineer ✓ · web-engineer ✓ · qa ✓ · specifier ✓
  Design:      designer ✓ · visual-designer ✓ · choreographer ✓ · typesetter ✓ · materialist ✓ · mark-maker ✓ · writer ✓ · prototyper ✓ · accessibility ✓ · design-validator ✓ · critic ✓ · systematist ✓
  PM/Discovery: strategist ✓ · scout ✓ · historian ✓ · marketer ✓ · user-researcher ✓ · journey-mapper ✓ · brief-writer ✓ · metrics-definer ✓ · assumption-mapper ✓
  (✓ pass · ✗ fail · ◐ partial)

OVERALL: PASS / FAIL   (N/35 agents passing)

FAILURES (ranked by severity)
1. [agent] — [eval] — [criterion that failed] → fix: [specific section/edit]
2. ...

ANTI-PATTERNS FIRED (warnings)
- [agent] — [anti-pattern]

RECOMMENDATIONS
- [prioritized, specific, actionable]
```

---

## When to run

- **After any agent edit** — targeted run for that agent.
- **After a cross-cutting change** — full suite (philosophy, `design-foundations.md`, Named Bans, the reference palette, the Six Functions framework).
- **On cadence** — the Phase 3 cron runs the full suite and routes failures to the owning agent. Drift that the suite catches is a signal, not a surprise.

The suite is the quality floor's harness: the Slop Test (Phase 4) is built on top of a passing suite.

---

## Executable layer — `claude plugin eval`

The markdown evals above are the **behavioral contract**. `evals/cases/` is the **executable regression harness**, run by `claude plugin eval` (Claude Code ≥ 2.1.269): each case is a prompt plus graders, runs 3× with the plugin and 3× without, and reports the plugin's Δ.

It matters now because agents pin models and effort (the plugin's `memory/orchestration.md` § Model and effort) — a model rollout is exactly when behavior regresses. The cases cover **gate behavior** (the skill refuses a missing brief or a solution-as-problem) and the **refutation discipline** (the critic refutes with evidence, or says it cannot). Model routing — the adversary model and its fallback — has no executable case: it needs a refuter call that fails, which an empty-workspace case cannot induce; lint R7.d and R11 enforce it.

Measure a model or effort change with `claude plugin eval` before and after — run the suite on the old assignment, then the new, and keep only what the score difference pays for.

| Run | Command |
|---|---|
| Local, every case | `claude plugin eval .` |
| One case, cheaply | `claude plugin eval . --case <name> --runs 1 --ablation none` |
| CI | `claude plugin eval . --trust-plugin --json results.json --threshold 0.8 --model <pinned> --judge-model <pinned> --no-publish --max-cost-usd 20` |

A case is a directory: `prompt.md` (frontmatter + the prompt) and `graders/<name>.md` (frontmatter `type:`; an `llm` grader's body is its `PASS if …` / `FAIL if …` rubric).

**Rule:** a new gate or refutation discipline gets a case. `evals/results/` is gitignored.
