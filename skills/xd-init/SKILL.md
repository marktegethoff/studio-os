---
description: Set up XD OS for a new project. Runs a three-phase interview — org context check, product interview, role calibration — then writes project-context.md and role-context.md to .claude/memory/. Re-runnable to update context when the project evolves.
argument-hint: "[optional: --update to refresh an existing context]"
---

Set up XD OS for this project.

Arguments: $ARGUMENTS

---

## Purpose

XD OS discipline agents load two context files to calibrate themselves:

- `project-context.md` — the product, its invariants, user archetypes, and engineering context. Shared across the team; often committed to the repo.
- `role-context.md` — your specific role on this project and how you're using XD OS here. Personal; lives in `.claude/memory/`, not committed.

Without these, agents fall back to generic reasoning. With both, they calibrate to the specific product *and* to you.

Run this once at the start of a new project. Re-run with `--update` when your role changes, or when the product direction, invariants, or system model changes significantly.

---

## Mode

If `--update` is in $ARGUMENTS:
- Load existing `project-context.md` and `role-context.md` first
- Show current values and ask what has changed
- Update only the sections that have changed — do not re-run the full interview

Otherwise: run the full three-phase interview.

---

## Phase 1 — Org context check

Before starting the product interview, check whether a shared project context already exists.

Check for:
1. `.claude/memory/project-context.md` — already set up for this project
2. `project-context.md` in `memory/` — plugin-level fallback

If `project-context.md` already exists:

> "A project context already exists for this project. Would you like to:
> 1. Use the existing context and skip to role calibration
> 2. Update the existing context (`--update` mode)
> 3. Start fresh (overwrites existing context)"

Wait for the user's choice:
- **Option 1:** Skip to Phase 3 — Role calibration.
- **Option 2:** Load existing context and run in `--update` mode.
- **Option 3:** Continue to Phase 2 with a fresh interview.

If no context exists, continue to Phase 2.

Also check: is there a global `~/.claude/memory/user-profile.md`? If yes, load it silently — it informs how to calibrate communication during the interview. Do not surface it to the user or comment on it.

---

## Phase 2 — Product interview

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
9. Who are the primary users? Describe 2–3 behavioral archetypes — not demographics, but usage patterns. (e.g., "Daily logger: writes 3–5 entries a day, uses threads heavily" vs. "Burst xd-writer: large volumes during projects, then quiet for weeks".)

---

### Section 5 — Tech Stack and Engineering Context

Ask:
10. What is the primary platform and tech stack? (e.g., Web / React / Postgres; iOS / SwiftUI; cross-platform / Flutter; backend / Go / Postgres.)
11. Where does the specification live? (e.g., `docs/specs/`, `docs/decisions/`, `specs/`.)
12. Where does the decision log live? (e.g., `decisions/`, `docs/decisions/`, `adr/`.)

---

### Section 6 — Research Scope

Ask:
13. What domains should the Scout and Research Sweep scan? (e.g., B2B SaaS tools, mobile design patterns, AI/LLM products, developer tooling, consumer social apps.)

---

### Section 7 — Design System

Ask:
14. Does a design system skill exist at `.claude/skills/design-system/`? If yes, agents will load it automatically. If not, run `/design-system-init` after setup to scaffold one.

---

### Writing project-context.md

After all Phase 2 sections are confirmed, write:

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

Confirm the write, then continue to Phase 3.

---

## Phase 3 — Role calibration

This phase captures your specific role on this project. It writes `role-context.md` — a project-level companion to your global `~/.claude/memory/user-profile.md`. Together they give agents full context: who you are + what you're doing here.

Ask one question at a time. This is a short interview — three questions.

---

**Question 1:**

> "What's your role on this project?"

Give examples to prompt specificity:

> Examples: product manager, UX designer, product designer, content designer, UX researcher, service designer, engineering lead, data scientist, full-stack engineer, iOS engineer, design lead, strategy lead.

Accept free-form answers. If the user names a role not in the example list, accept it as stated.

---

**Question 2:**

> "What will you primarily use XD OS for on this project?"

Give examples:

> Examples: planning and discovery (research synthesis, journey maps, briefs), design work (interaction models, specs), engineering implementation, measurement and analytics, strategy and direction, all of the above.

Accept free-form answers.

---

**Question 3:**

> "Is there anything about this project that XD OS should know about your specific context — your constraints, your team structure, or what you're responsible for?"

This is open-ended. A one-line answer is fine. If the user says nothing to add, accept it and move on.

---

### Writing role-context.md

After Phase 3 questions are confirmed, write:

```
.claude/memory/role-context.md
```

Use this structure:

```markdown
# Role Context
Project: [product name from project-context.md]
Last updated: [date]

## Role

**Title:** [role as stated]
**Primary contribution:** [what they're using XD OS for on this project]

## Project-specific context

[Answer to Question 3 — or "No additional context provided." if none]

---

## How to apply

Agents reading this file should:
- Frame outputs at the right level for this role (a PM needs different depth than an engineer)
- Emphasize the disciplines most relevant to this person's primary contribution
- Apply project-specific context when making suggestions or recommendations
```

---

## Post-write

After both files are written, confirm:

> "Setup complete. XD OS is calibrated to [product name] and your role as [role].
>
> Two context files written:
> - `.claude/memory/project-context.md` — product context (shareable with your team)
> - `.claude/memory/role-context.md` — your role on this project (personal, don't commit)
>
> Start with `/design <problem>`, `/xd-discovery <problem>`, or `/studio <goal>`."

If a design system skill does not yet exist at `.claude/skills/design-system/`, add:

> "No design system skill found. Run `/design-system-init` to scaffold one — it creates token file templates and a component directory ready to populate."

If `user-profile.md` was not found during Phase 1 context check, add:

> "No personal profile found. Run `xd setup --me` to create one — it helps XD OS calibrate its communication style and assumed knowledge across all your projects."
