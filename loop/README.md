# The Compounding Loop

The studio gets better only if every session deposits what it learned and the system periodically reconciles itself. This is the machinery that turns one-off work into compounding value. **Judgment is instrumented, never replaced** — every automated step ends in a recommendation the user decides on.

```
   work ─▶ deposit ─▶ accumulate ─▶ reconcile ─▶ better work
            (close)     (memory)      (drift/sweep/evals)
```

## 1. Deposit — every session

- **Hook:** `hooks/hooks.json` fires `deposit-reminder.sh` on `SessionEnd` — a nudge to deposit before learnings are lost.
- **Skill:** `/studio-close` does the deposit (preferences · ledger · eval deltas · migrations · postmortem candidates). It proposes; the user confirms. Nothing auto-writes.

## 2. Reconcile — on a cadence

Scheduled so drift is a signal, not a surprise. Schedule these with the harness's scheduler (e.g. `/schedule`) or any cron; each is a skill run:

| Cadence | Job | Skill | Output |
|---|---|---|---|
| Weekly / per-release | Full eval suite | run `evals/` (see `evals/README.md`) | one consolidated report; failures routed to owning agents |
| Monthly | Ledger-drift audit | `/studio-drift` | drift/supersession candidates → CD/DE/PM judged recommendations → you decide |
| Quarterly | Research sweep | `surveyor` (research sweep) | dated trend file; tensions against current positions |

A scheduled run produces a recommendation set; the user approves dispositions. No scheduled job mutates the studio on its own.

## 3. Graduation queue — reviewed, not auto-promoted

Two streams feed a queue that is reviewed on the monthly cadence (see `loop/graduation-queue.md`):

- **Adjacent pitches** — the Marketer's "what about X?" ideas (Apple Watch, CarPlay…) parked, not lost.
- **Open migrations** — structural follow-ups recorded by `/studio-close` that aren't done yet.

Review = decide each: promote (into a brief / a task), defer (keep with a re-look date), or drop (with a reason). Nothing graduates automatically.

## 4. Postmortem intake — when something ships wrong

`/studio-postmortem` routes a shipped failure or a wrong prediction to a candidate **Named Ban** (agents must refuse the category) or a **precedent** (a recorded decision). A new Named Ban gets an eval case so the ban is testable. The user confirms before either is deposited.

---

**The invariant across all of it:** detection and proposal are automated; **resolution is judged by the right gate; the decision is the user's.** Agents recommend, never auto-resolve.
