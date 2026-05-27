---
description: "Close a studio session cleanly. Summarizes decisions made, artifacts produced, and the clear next action."
argument-hint: "[optional: a one-line summary of the session]"
---

Deposit the session's learnings so the studio compounds.

Arguments: $ARGUMENTS

A studio that doesn't deposit forgets. This skill is the deposit step: at session end it routes what was learned to the right durable home. It writes nothing the user hasn't confirmed — it proposes deposits and the user approves.

---

## When to run

- At the end of a working session (manually).
- Fired by the session-end deposit hook (`hooks/hooks.json`, on `Stop`/`SessionEnd`) as a reminder — the hook surfaces the prompt; this skill does the work.

---

## What it deposits (in order)

### 1. Preferences — craft & process learnings
Did this session reveal a craft or process learning that should outlive it (a corrected approach, a validated judgment call, a recurring preference)? If so, propose an entry for `.claude/memory/design-preferences.md` (studio-wide craft) — lead with the rule, then *why* and *how to apply*. Confirm before writing.

### 2. Ledger — decisions made
Were any decisions made that govern future work (a locked direction, a supersession, a new invariant)? Propose a decision record (use the `decision-record` artifact template) for the project's decision ledger — tier, reasoning, the counter-argument, what it supersedes. Confirm before writing.

### 3. Eval delta — agent/skill changes
Were any agents or skills changed this session? List them and flag that their evals must pass before the change is considered done (coverage rule). If a new agent/skill was added without an eval, name it as a gap to close now.

### 4. Migrations — pending structural work
Did anything surface that requires a migration, a data change, or a structural follow-up that isn't done yet? Record it as a pending item with enough context to resume cold (do not leave it only in conversation).

### 5. Postmortem candidates
Did a shipped thing fail, or a prediction prove wrong? Route it to `/studio-postmortem` to consider whether it should become a Named Ban or a precedent.

---

## Output

A short deposit summary:

```
## Session Deposit — [date]
Summary: [one line]

Preferences:   [entry proposed / none]
Ledger:        [decision NN proposed / none]
Eval delta:    [agents/skills changed → evals to run / none]
Migrations:    [pending item recorded / none]
Postmortem:    [routed / none]

Nothing is written without your confirmation.
```

---

## Rules

- **Propose, don't auto-write.** Every deposit is confirmed by the user first (two-way doors stay reversible; the user owns the record).
- **Cold-resumable.** A migration or pending item must carry enough context to pick up in a fresh session — never "see conversation."
- **Coverage.** A changed agent/skill without a passing eval is an open gap, surfaced here.
