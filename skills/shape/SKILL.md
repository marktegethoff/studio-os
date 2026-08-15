---
description: "Interview-driven brief shaping. Produces a design brief (HTML) from a structured problem interview."
argument-hint: "<rough problem area or feature idea>"
artifact: design-brief
---

Run the brief shaping workflow.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `decisions/` by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. This skill provides the discipline.

---

## Purpose

A brief exists to answer one question before design begins: are we solving the right problem for the right person?

This skill interviews you. It does not fill out a form. It asks one question at a time and waits for your answer before proceeding. It stops when the problem can be stated in one sentence with clear success conditions.

**Output:** a locked brief written to `specs/product_brief_<slug>.md` (or the path defined in CLAUDE.md). The brief is the constraint that makes `/design` precise.

---

## Disciplines

**PM:** Validates problem clarity — who specifically, what they do today, why now, success conditions, out of scope.

**Strategist:** Evaluates strategic fit — does this strengthen the product's core value, or drift toward feature accumulation?

**Brief Writer:** Structures the validated problem into a locked brief format.

---

## Context

Problem area: $ARGUMENTS

---

## Step 0 — Check for prior brief

Before beginning: look for an existing brief in `specs/product_brief_*.md` (or the path defined in CLAUDE.md).

If one exists for this problem area: surface it.

> "A brief already exists for this area: `[path]`. Do you want to revise it, or start fresh?"

Wait for the user's response. If revising, load the existing brief and proceed from the question where clarity broke down. If fresh, continue to Step 1.

If none exists, continue to Step 1.

---

## Step 1 — PM: Who has this problem?

Apply the PM discipline.

Ask one question:

> "Who specifically has this problem? Not 'users' — which users, in what context, with what frequency? Describe the person who would feel this most acutely."

---

> **⏸ PAUSE (skipped in --auto) — Who has this problem?**
> Describe the specific user, context, and frequency. If you're not sure yet, describe who you *think* has it — we'll sharpen from there.

---

## Step 2 — PM: What do they do today?

Apply the PM discipline.

Reflect what you heard in Step 1. Then ask:

> "What does that person do today instead? What's their current workaround or behavior when they hit this problem?"

---

> **⏸ PAUSE (skipped in --auto) — Current behavior.**
> What does the user do today when they encounter this problem? What's the workaround?

---

## Step 3 — PM: What changes if we solve it?

Apply the PM discipline.

Reflect what you heard. Then ask:

> "If we solve this well, what changes for that person the day after we ship? Not features — outcomes. What does their life or workflow look like differently?"

---

> **⏸ PAUSE (skipped in --auto) — Outcome.**
> What changes for the user if this works? Describe the outcome, not the feature.

---

## Step 4 — PM: What's out of scope?

Apply the PM discipline.

Reflect the emerging problem statement. Then ask:

> "What does this brief *not* cover? What are you explicitly setting aside — even if it's related and real?"

---

> **⏸ PAUSE (skipped in --auto) — Out of scope.**
> What is this brief explicitly not covering? Name at least one adjacent thing you're deferring.

---

## Step 5 — PM: Draft the problem statement

Apply the PM discipline.

Using the answers from Steps 1–4, draft a one-sentence problem statement:

> "Based on what you've told me, here's the problem statement: [one sentence in this form: *[User type] who [context] cannot [do X] because [constraint], which means [consequence].*]
>
> Does this capture it? If not, what's wrong?"

---

> **⏸ PAUSE (skipped in --auto) — Problem statement.**
> Confirm, revise, or redirect. We don't move to the Strategist gate until the problem statement is right.

---

## Step 6 — Strategist gate

Apply the Strategist discipline.

Evaluate the validated problem statement against the product context loaded above:

1. Does this strengthen the product's core value as defined in project context?
2. Does it improve long-term value for the specific user named?
3. Does it drift toward feature accumulation or introduce a new product category?

State a verdict:

- **PASS** — proceed to Brief Writer
- **TENSION** — proceed, but name the tension explicitly in the brief
- **FAIL** — stop. Name what must change for this problem to belong in the product. Do not write a brief for a problem that fails the Strategist gate.

---

> **⏸ PAUSE (skipped in --auto) — Strategist verdict.**
> [If PASS or TENSION]: confirm to proceed to the brief.
> [If FAIL]: address the Strategist's concern or stop.

---

## Step 7 — Brief Writer

Apply the Brief Writer discipline.

Produce the brief:

```markdown
# Product Brief: [Problem Name]
Date: [today]
Status: LOCKED

## Problem statement
[One sentence]

## Who has it
[Specific user segment — behavioral description, context, frequency]

## What they do today
[Current behavior or workaround — specific, not general]

## Success conditions
[Observable outcomes — not features. What changes for the user?]

## Out of scope
[What this brief explicitly does not cover]

## Key unknowns
[Genuine blockers to design — not hypothetical risks. Each unknown should have a minimum path to resolve it.]
```

Present the brief. Ask:

> "Does this brief represent the problem correctly? Any corrections before I lock it?"

---

> **⏸ PAUSE (skipped in --auto) — Brief review.**
> Confirm the brief is correct. Reply **"lock it"** to write the file, or make corrections.

---

## Step 8 — Lock and write

On confirmation:

1. Determine the slug from the problem name (lowercase, hyphens, no spaces).
2. Render the brief as HTML using the kit template (per Output section below) and write to `specs/product_brief_<slug>.html`.
3. Confirm the write:

> "Brief locked: `specs/product_brief_<slug>.html`
>
> **Recommended next:** `/design [problem name]` — the brief is the constraint."

---

## Rules

**One question rule.** Ask one question per PAUSE. Do not bundle questions. The conversation is the discovery process.

**Reflection rule.** Before each new question, reflect what you heard in the prior answer — in one sentence. This confirms understanding and builds the user's confidence that they're being heard.

**Problem-first rule.** The brief must name a problem, not a feature. "We need a search bar" is not a brief. "People who've been using the product for months feel like their thinking has disappeared into a pile they can't see into" is the shape of a brief.

**Outcome rule.** Success conditions must describe what changes for the user, not what ships. "We add X feature" is not a success condition.

**Strategist gate rule.** A brief that fails the Strategist gate is not written. Surface the conflict and stop. The PM identifies the problem; the Strategist confirms it belongs in the product.

**Approval gate rule.** The brief is not locked until the user explicitly confirms. Do not write the file until Step 8 confirmation.

---

## Output

Render the artifact as HTML using the kit template.

1. Load `artifacts/templates/design-brief.html` as the structural shell.
2. Populate the artifact-specific fields: problem statement, user, today's behavior, success conditions, out of scope, constraints, open questions.
3. Write to `specs/product_brief_<slug>.html` where slug is derived from the problem name (lowercase kebab-case, max 40 chars).
4. Surface a short markdown summary in conversation:
   - File path
   - One-sentence problem statement
   - Success conditions and key constraints
5. Offer: "Run `/studio:annotate <file-path>` to attach the feedback harness."

If `--text` is in $ARGUMENTS, skip HTML emission and present the markdown summary as the full output.
