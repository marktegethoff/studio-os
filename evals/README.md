# Studio OS — Agent Evals

Behavioral evals for every agent in the roster. Each eval is a prompt + pass criteria + anti-patterns that tests whether an agent holds its discipline. Scenarios are **product-agnostic**; a consuming project may add its own product-specific evals alongside these.

---

## Coverage

All 33 agents are covered across 8 files:

| File | Agents |
|---|---|
| `leadership-agents.eval.md` | pm · strategist · critic · marketer · auditor · luck · surveyor |
| `cd.eval.md` | cd |
| `engineering-agents.eval.md` | architect · engineer · de · qa |
| `design-agents.eval.md` | designer · choreographer · typesetter · writer · specifier · prototyper |
| `surface-agents.eval.md` | materialist · visual-designer · mark-maker · accessibility · heurist · design-validator · systematist |
| `discovery-agents.eval.md` | journey-mapper · user-researcher · brief-writer · metrics-definer · assumption-mapper |
| `analysis-agents.eval.md` | scout · competitive-analyst |
| `historian.eval.md` | historian |

---

## Two ways to run

**1. Targeted run** — after changing a single agent file, run only that agent's evals (find it in the table above). Fast feedback loop.

**2. Full-suite run** — run **every** eval across **all** agents and produce **one consolidated package**: per-agent results, an overall verdict, and prioritized recommendations. Use this before a release, after a cross-cutting change (philosophy, design-foundations, a Named-Ban edit), and on the scheduled cadence (Phase 3 cron). The suite is one report, not eight.

### Full-suite procedure

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
  Engineering: architect ✓ · engineer ✓ · qa ✓ · specifier ✓
  Design:      designer ✓ · visual-designer ✓ · choreographer ✓ · typesetter ✓ · materialist ✓ · mark-maker ✓ · writer ✓ · prototyper ✓ · accessibility ✓ · design-validator ✓ · critic ✓ · systematist ✓
  PM/Discovery: strategist ✓ · scout ✓ · historian ✓ · marketer ✓ · user-researcher ✓ · journey-mapper ✓ · brief-writer ✓ · metrics-definer ✓ · assumption-mapper ✓
  (✓ pass · ✗ fail · ◐ partial)

OVERALL: PASS / FAIL   (N/33 agents passing)

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
