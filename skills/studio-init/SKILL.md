---
description: Set up Studio OS for a new project. Runs an interview wizard that captures product purpose, brand principles, system invariants, user archetypes, and tech stack. Writes project-context.md to .claude/memory/. Re-runnable to update context when the project evolves.
argument-hint: "[optional: --update to refresh an existing context]"
---

Set up Studio OS for this project.

Arguments: $ARGUMENTS

---

## Purpose

Studio OS discipline agents load `project-context.md` to calibrate themselves to the specific product, brand, and constraints of this project. Without it, agents fall back to generic reasoning.

This skill interviews you to capture that context and writes it to `.claude/memory/project-context.md`.

Run this once at the start of a new project. Re-run with `--update` when the product direction, invariants, or system model changes significantly.

---

## Mode

If `--update` is in $ARGUMENTS: load the existing `.claude/memory/project-context.md` first, then run only the sections that have changed. Show the current value and ask whether to update.

Otherwise: run the full interview.

---

## Interview Sequence

Work through these sections in order. Ask one question at a time. Summarize what you've captured after each section and ask for confirmation before moving to the next.

---

### Section 1 — Product Identity

Ask:
1. What is the product name?
2. What is the product in one sentence — what does it do and for whom?
3. What is the product's core concept or organizing idea? (The thing that makes all other decisions obvious.)

---

### Section 2 — Ethos and Principles

Ask:
4. Does this studio have a named ethos or operating philosophy? (e.g., a studio name, a set of principles, a named approach to design.)
5. What are the brand principles? (How the product should feel, behave, or be perceived. Aim for 3–7 principles. Examples: "stillness over performance", "the mechanism and the tape".)

---

### Section 3 — System Model

Ask:
6. What are the core primitives — the fundamental objects your system works with? (e.g., Entry, Thread, Collection; or Document, Tag, Workspace.)
7. How do these primitives relate to each other? (Parent/child? Many-to-many? Sequential?)
8. What are the system invariants — the rules that must never be violated? (e.g., "chronology is never rewritten", "AI assists but never authors".)

---

### Section 4 — User Archetypes

Ask:
9. Who are the primary users? Describe 2–3 behavioral archetypes — not demographics, but usage patterns. (e.g., "Daily logger: writes 3–5 entries a day, uses threads heavily" vs. "Burst writer: large volumes during projects, then quiet for weeks".)

---

### Section 5 — Tech Stack and Engineering Context

Ask:
10. What is the primary platform and tech stack? (e.g., iOS / SwiftUI / GRDB; Web / React / Postgres; cross-platform / Flutter.)
11. Where does the specification live? (e.g., `docs/specs/`, `studio_os/artifacts/`.)
12. Where does the decision log live? (e.g., `decisions/`, `studio_os/ledger/decisions/`.)

---

### Section 6 — Research Scope

Ask:
13. What domains should the Scout and Research Sweep scan? (e.g., PKM tools, iOS design patterns, on-device AI, personal productivity apps.)

---

### Section 7 — Design System

Ask:
14. Does a design system skill exist at `.claude/skills/design-system/`? If yes, agents will load it automatically. If not, run `/design-system-init` after setup to scaffold one.

---

## Writing

After all sections are confirmed, write the file:

```
.claude/memory/project-context.md
```

Use this structure:

```markdown
# Project Context
Last updated: [date]

## Product Identity

**Name:** [product name]
**Purpose:** [one-sentence description]
**Core concept:** [organizing idea]

---

## Ethos

[Studio ethos or named approach]

---

## Brand Principles

1. [Principle]
2. [Principle]
...

---

## Decision Hierarchy

1. Structural correctness
2. Conceptual clarity
3. System coherence
4. Reduction of parts
5. Craft precision
6. Visual refinement

Novelty is never a deciding factor.

---

## System Model

### Primitives

**[Primitive]** — [definition]
**[Primitive]** — [definition]

### Relationships

[Describe how primitives relate]

### System Invariants

- [Invariant]
- [Invariant]
...

---

## User Archetypes

**[Archetype name]:** [behavioral description]
**[Archetype name]:** [behavioral description]

---

## Engineering Context

**Platform:** [platform and stack]
**Spec path:** [path]
**Decision log:** [path]

---

## Research Scope

Domains: [list]

---

## Design System

Skill location: `.claude/skills/design-system/` (present / not yet initialized)
```

---

## Post-write

After writing, confirm:

> "Project context written to `.claude/memory/project-context.md`. Studio OS disciplines will now calibrate to [product name].
>
> Run `studio` to start working, or `studio-design <problem>` to begin a design session."

If a design system skill does not yet exist at `.claude/skills/design-system/`, suggest:

> "No design system skill found. Run `/design-system-init` to scaffold one — it will create the token file templates and component directory ready to populate."
