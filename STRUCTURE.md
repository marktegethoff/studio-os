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

### The platform layer

`memory/` holds two kinds of doctrine: the **timeless** foundations (`design-foundations.md` — revised only to stay true) and the **current** platform contracts (`apple-platform.md` — dated, versioned "as of iOS 26", refreshed by the surveyor's sweep; `web-platform.md`/`android-platform.md` follow the same shape when those practices are installed). Design agents cite the contract by section; stack specialists carry the matching code doctrine behind the `stack:` seam. Canonical worked solutions live in `patterns/<stack>/` (lint R9; lifecycle in `patterns/README.md`) — agents consult before solving, and the surveyor's sweep harvests and re-verifies entries.

### Orchestration

Multi-agent skills are **graphs**: nodes (agents, gates, human decisions, routers, joins, tasks) and declared edges (sequence, conditional, fan-out/fan-in, bounded loops). Each graph-declaring skill carries one lint-validated ` ```graph ` block in its `SKILL.md` — the contract its prose steps and its `workflow.js` executor must match. The shared doctrine — grammar, human-node economics, adversarial rules, run state, the Auto-Mode Safety Contract — is Core method and lives in `memory/orchestration.md`. Linear and interview skills carry no graph block.

---

## Role — discipline agents, additive

Installed per the user's practice. Product-agnostic — every example is drawn from the public reference palette, never from one product.

**Engineering (6, extensible):** `architect` · `engineer` (stack-neutral base) · `swift-engineer` · `web-engineer` · `qa` · `specifier`
The engineer family is a base discipline (`engineer`) plus stack specialists that inherit it. `swift-engineer` covers all Apple platforms (the `platform` manifest key — `ios` | `macos` | `multiplatform` — selects within it). More are added per install at setup from `templates/engineer-specialist.template.md` (e.g. `android-engineer`, `backend-engineer`, `fullstack-engineer`, `data-engineer`, `ml-engineer`), each with its own references — the same personalization mechanism as the reference palette and display personas.

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
├── code/                  all product SOURCE under one root — subfolder per codebase
│   ├── ios/                 (e.g. the iOS app)
│   └── web/                 (e.g. web client; also design-system/, api/, …)
├── .claude/memory/        CONTEXT the studio reads   (input)
│   └── project-context.md   brand · invariants · primitives · purpose · code_root — the anchor
├── decisions/             the ledger — every choice + its rationale
├── specs/                 engineering handoff specs
├── design/                design artifacts (briefs, wireframes, motion specs, copy decks)
└── reviews/               gate verdicts (PM · CD · DE)
```

**Code lives in one repeatable place.** All product source sits under a single top-level **code root**, declared as `code_root` in `project-context.md` so the studio always knows where it is. The name adapts to the project type: `code/` with one subfolder per codebase (`code/ios/`, `code/web/`, `code/design-system/`) for a multi-codebase product; a plain `app/` is fine for a single-codebase app. The invariant is **one declared root**, never source scattered across the project root. The `organize` skill relocates existing codebases under the root when reconciling a project, handling tooling paths carefully (e.g. an Xcode project moving to `code/ios/`).

**Output folders are flat and type-named** at the root — each names itself, so there is no container folder to invent (`studio/`, `record/`, `output/` were all rejected for exactly that reason). Keep the set small and durable: a new top-level folder is earned only by a durable artifact category, never a one-off. The engine (agents, skills, kit, evals) is never copied in — it loads from the global plugin. The `organize` skill scaffolds this layout in a new project and reconciles an existing one.

---

## Distribution

- **Plugin:** this repo is a Claude Code plugin (`.claude-plugin/plugin.json`) distributed via the marketplace (`.claude-plugin/marketplace.json`). Install + update with native `/plugin` commands. Agents/skills are namespaced (`studio:designer`) — no collisions with a user's own.
- **Personal (edit-live):** run `claude --plugin-dir ~/Code/studio-os` so the source *is* the install — edits go live with `/reload-plugins`, and drift is structurally impossible.
- **Fallback:** `install.sh` copies into `~/.claude/` for non-plugin contexts.
