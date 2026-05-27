---
description: "Drift diagnostic — detects when work has lost direction. Names what changed and what the corrective action is."
argument-hint: "[optional: a path or area to focus the audit]"
---

Surface drift and supersession; route each to the right judge.

Arguments: $ARGUMENTS

Decisions rot. The product moves past them, two of them quietly contradict, a "pending" item locked months ago. This skill finds those and routes each to the gate whose judgment it needs — but it never resolves them itself. Detection is mechanical; resolution is judgment; the decision is the user's.

---

## When to run

- Monthly ledger-drift cadence (scheduled — see `loop/README.md`).
- After a big change that likely outdated prior decisions.
- When the ledger and the actual work feel out of sync.

---

## Steps

### 1. Detect (mechanical)
Scan the project's decision ledger + system invariants for:
- **Supersession** — a decision the current work has clearly moved past (its frame no longer holds).
- **Contradiction** — two decisions that can't both be true.
- **Stale "pending"** — items marked pending/proposed that have since been settled in practice.
- **Orphan** — a decision referencing files/primitives that no longer exist.

Produce the candidate list. Detection makes no judgment — it only surfaces.

### 2. Route to the owning gate
Each candidate goes to the gate whose domain it sits in:
- **CD** — design/taste/structure decisions (a superseded interaction model, a register call).
- **DE** — engineering/architecture decisions (a retired pattern, a migration's aftermath).
- **PM** — product/scope/problem decisions (a feature whose validated problem changed).

The gate produces a **judged recommendation**: supersede / reconcile / keep / archive — with reasoning and the counter-argument. Per the agents' supersession rule, this is stated as fact, not as a problem to apologize for.

### 3. You decide
Present the recommendations as a table. The user approves each disposition. Then the approved changes are deposited (via `/studio-close` / `decision-record`). **Agents recommend; they never auto-resolve.**

---

## Output

```
## Ledger Drift Audit — [date]   (scope: [area])

| Candidate | Type | Routed to | Recommendation | Reasoning |
|---|---|---|---|---|
| Decision NN | supersession | CD | archive | superseded by NN; frame no longer holds |
| ... | contradiction | DE | reconcile | ... |

Decisions for you: [the ones awaiting your call]
Nothing is changed until you approve each.
```

---

## Rules

- **Detect mechanically, judge with the gate, decide with the user.** Three separate steps; never collapse them.
- **No auto-resolution.** This is a one-way-door class of change; the user owns it.
- **Supersession is not failure.** A superseded decision is evidence the product evolved — recorded as fact, not regret.
