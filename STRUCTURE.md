# Studio OS — Structure

Studio OS is a single Claude Code plugin organized in three tiers. The tier boundary **is** the portability seam: **Core** and **Role** are universal and distributable; **Product** is the swappable project layer. Swap the Product layer and the same studio serves a different product.

```
Standard Works · Studio OS
├── CORE      universal craft + method + the Standard Works philosophy   (distributable)
├── ROLE      discipline agents, installed per practice                  (distributable)
└── PRODUCT   one product's context — lives in each project, not here    (swappable)
```

The agent→tier mapping below is authoritative (per-agent `tier:` frontmatter is added during the Phase 1 agent pass). Physically, all agents live flat in `agents/` so plugin discovery and the personal `--plugin-dir` install stay simple; the tier is metadata, not a directory.

---

## Core — universal, always present

The Standard Works philosophy (`PHILOSOPHY.md`), universal method (`memory/design-foundations.md`, decision tiers, the Scene Test), the senior gates, and cross-cutting agents. Adopting Studio OS means adopting Core.

**Agents (8):** `pm` · `cd` · `de` · `heurist` · `auditor` · `luck` · `competitive-analyst` · `surveyor`

The gate sequence is **PM → CD → DE**: problem gate, design gate, engineering gate.

---

## Role — discipline agents, additive

Installed per the user's practice. Product-agnostic — every example is drawn from the public reference palette, never from one product.

**Engineering (6, extensible):** `architect` · `engineer` (stack-neutral base) · `ios-engineer` · `web-engineer` · `qa` · `specifier`
The engineer family is a base discipline (`engineer`) plus stack specialists that inherit it. More are added per install at setup from `templates/engineer-specialist.template.md` (e.g. `backend-engineer`, `android-engineer`, `fullstack-engineer`, `data-engineer`, `ml-engineer`), each with its own references — the same personalization mechanism as the reference palette and display personas.

**Design (12):** `designer` · `visual-designer` · `choreographer` · `typesetter` · `materialist` · `mark-maker` · `writer` · `prototyper` · `accessibility` · `design-validator` · `critic` · `systematist`

**PM & Discovery (9):** `strategist` · `scout` · `historian` · `marketer` · `user-researcher` · `journey-mapper` · `brief-writer` · `metrics-definer` · `assumption-mapper`

**Total active roster: 35 shipped** (8 Core + 27 Role), extensible — engineer specialists are added per install.

---

## Product — project-specific, not in this repo

Everything that belongs to one product: brand principles, named surface examples, design tokens, domain vocabulary, system invariants, the decision ledger. This tier lives in each consuming project under `.claude/memory/` (e.g. `project-context.md`) plus the project's own studio docs — **never** in Core or Role.

Core/Role carry zero product references. A product is loaded at session start via the project layer; replacing it re-points the entire studio at a new product.

### Canonical project layout

A project that adopts Studio OS holds two kinds of project-specific material — the context the studio *reads* and the output it *produces* — and none of the engine:

```
<project>/
├── app/                   the product's SOURCE — the single code root (default `app/`; see code_root below)
├── .claude/memory/        CONTEXT the studio reads   (input)
│   └── project-context.md   brand · invariants · primitives · purpose · code_root — the anchor
├── decisions/             the ledger — every choice + its rationale
├── specs/                 engineering handoff specs
├── design/                design artifacts (briefs, wireframes, motion specs, copy decks)
└── reviews/               gate verdicts (PM · CD · DE)
```

**Code lives in one repeatable place.** All product source sits under a single top-level **code root**, default `app/`, recorded as `code_root:` in `project-context.md` so the studio always knows where the code is. Greenfield projects use `app/`. A project whose ecosystem fixes its own layout (e.g. an Xcode project rooted at `Log/`) keeps that native folder and simply declares it as `code_root` — the contract is "one declared root," not a forced rename that would break tooling. Either way the code is in a known, single place, never scattered beside the studio folders.

**Output folders are flat and type-named** at the root — each names itself, so there is no container folder to invent (`studio/`, `record/`, `output/` were all rejected for exactly that reason). Keep the set small and durable: a new top-level folder is earned only by a durable artifact category, never a one-off. The engine (agents, skills, kit, evals) is never copied in — it loads from the global plugin. The `organize` skill scaffolds this layout in a new project and reconciles an existing one.

---

## Distribution

- **Plugin:** this repo is a Claude Code plugin (`.claude-plugin/plugin.json`) distributed via the marketplace (`.claude-plugin/marketplace.json`). Install + update with native `/plugin` commands. Agents/skills are namespaced (`studio:designer`) — no collisions with a user's own.
- **Personal (edit-live):** run `claude --plugin-dir ~/Code/studio-os` so the source *is* the install — edits go live with `/reload-plugins`, and drift is structurally impossible.
- **Fallback:** `install.sh` copies into `~/.claude/` for non-plugin contexts.
