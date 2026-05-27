# Auto Run State

**Branch:** `auto/v1-2-0-html-first-1779851872`
**Plan:** `/Users/marktegethoff/.claude/plans/atomic-munching-kahan.md`
**Started:** 2026-05-26

## Completed phases

- ✓ Phase A.1 — Added lint R6 (kit reference enforcement) — commit `Phase A.1: add lint R6`
- ✓ Phase A.2 — Wrote 5 new artifact templates (critique-report, lt-review, task-brief, ideation-output, experiment-plan) — commit `Phase A.2: add 5 new artifact templates`

## Pending phases

- [ ] Phase A.3 — Update kit README with new templates + R6 statement
- [ ] Phase A.4 — Template proposal mechanism (artifacts/proposals/ directory + schema)
- [ ] Phase B — HTML emission for 10 skills (shape, scope, discover, design, critique, review, measure, ideate, handoff, experiment)
- [ ] Phase C — Model-switch cleanup + auto mode safety contract
- [ ] Phase D — Agent-level artifact production discipline (13 artifact-owning agents)
- [ ] Phase E — Evals + CHANGELOG (no tag, no push, no merge per safety contract)
- [ ] Final — Write AUTO_RUN_SUMMARY.md, delete this state file

## Resume instructions (for the new session)

After relaunching Claude Code with `--dangerously-skip-permissions`:

```
Resume the auto run. Branch: auto/v1-2-0-html-first-1779851872. Plan: /Users/marktegethoff/.claude/plans/atomic-munching-kahan.md. Pick up at Phase A.3. The safety contract still applies (no push, no tag, no merge to main).
```

## Safety contract reminders

Even with `--dangerously-skip-permissions` active, the auto-mode safety contract from the plan still applies:

1. **Never on main.** All work continues on `auto/v1-2-0-html-first-1779851872`.
2. **Never push.** No `git push`.
3. **Never tag.** No `release.sh`, no `git tag`.
4. **Never merge.** Do not merge to main.
5. **Commit per subsection.** Each Phase X.Y gets its own commit with message `Phase X.Y: <description>`.
6. **Final summary required.** Write `AUTO_RUN_SUMMARY.md` before completion; delete this state file.

If anything goes wrong, the rollback is:
```
git checkout main && git branch -D auto/v1-2-0-html-first-1779851872
```
