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

**Agents (8):** `pm` · `cd` · `de` · `heurist` · `audit` · `luck` · `competitive-analyst` · `sweep`

The gate sequence is **PM → CD → DE**: problem gate, design gate, engineering gate.

---

## Role — discipline agents, additive

Installed per the user's practice. Product-agnostic — every example is drawn from the public reference palette, never from one product.

**Engineering (4):** `architect` · `engineer` · `qa` · `specifier`

**Design (12):** `designer` · `visual-designer` · `choreographer` · `typesetter` · `materialist` · `mark-maker` · `writer` · `prototyper` · `accessibility` · `validate-design` · `critic` · `design-systems`

**PM & Discovery (9):** `strategist` · `scout` · `historian` · `marketer` · `user-researcher` · `journey-mapper` · `brief-writer` · `metrics-definer` · `assumption-mapper`

**Total active roster: 33** (8 Core + 25 Role).

---

## Product — project-specific, not in this repo

Everything that belongs to one product: brand principles, named surface examples, design tokens, domain vocabulary, system invariants, the decision ledger. This tier lives in each consuming project under `.claude/memory/` (e.g. `project-context.md`) plus the project's own studio docs — **never** in Core or Role.

Core/Role carry zero product references. A product is loaded at session start via the project layer; replacing it re-points the entire studio at a new product.

---

## Distribution

- **Plugin:** this repo is a Claude Code plugin (`.claude-plugin/plugin.json`) distributed via the marketplace (`.claude-plugin/marketplace.json`). Install + update with native `/plugin` commands. Agents/skills are namespaced (`studio-os:designer`) — no collisions with a user's own.
- **Personal (edit-live):** run `claude --plugin-dir ~/Code/studio-os` so the source *is* the install — edits go live with `/reload-plugins`, and drift is structurally impossible.
- **Fallback:** `install.sh` copies into `~/.claude/` for non-plugin contexts.
