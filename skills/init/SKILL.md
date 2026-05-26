---
description: Set up Studio OS for a new project. Runs a five-phase flow — org context check, product interview (which generates the engineer specialist on demand if one for your stack does not yet exist), role calibration, personalization, and the paired-scaffold execution that creates code/app + code/canvas + code/shared with the by-reference dependency wired. Writes project-context.md (with the engineering manifest) and role-context.md to .claude/memory/. Re-runnable with --update to refresh context, promote shape, or convert manual → complete.
argument-hint: "[optional: --update [--generator=xcodegen] to refresh / promote / convert]"
---

Set up Studio OS for this project.

Arguments: $ARGUMENTS

---

## Purpose

Studio OS discipline agents load two context files to calibrate themselves:

- `project-context.md` — the product, its invariants, user archetypes, and engineering context. Shared across the team; often committed to the repo.
- `role-context.md` — your specific role on this project and how you're using Studio OS here. Personal; lives in `.claude/memory/`, not committed.

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
5. What are the brand principles? (How the product should feel, behave, or be perceived. Aim for 3–7 principles. Examples: "speed as respect", "restraint treated as a feature", "calm is engineered".)

---

### Section 3 — System Model

Ask:
6. What are the core primitives — the fundamental objects your system works with? (e.g., Entry, Thread, Collection; or Document, Tag, Workspace.)
7. How do these primitives relate to each other? (Parent/child? Many-to-many? Sequential?)
8. What are the system invariants — the rules that must never be violated? (e.g., "chronology is never rewritten", "AI assists but never authors".)

---

### Section 4 — User Archetypes

Ask:
9. Who are the primary users? Describe 2–3 behavioral archetypes — not demographics, but usage patterns. (e.g., "Daily user: short, frequent sessions, relies on quick capture" vs. "Burst user: heavy use during projects, then quiet for weeks".)

---

### Section 5 — Tech Stack and Engineering Context

Ask:
10. What is the primary platform and tech stack? Use the canonical stack tag (e.g. `swift`, `web`, `android`, `react-native`, `flutter`, `backend`, `data`, `ml`, `fullstack`). The tag drives which engineer specialist is selected.
11. Where does the specification live? (e.g., `specs/`, `docs/specs/`, `docs/decisions/`.)
12. Where does the decision log live? (e.g., `decisions/`, `docs/decisions/`, `adr/`.)

After capturing the stack tag, **check for the matching specialist file** at `agents/<stack>-engineer.md`:

- If it exists (e.g. `swift-engineer`, `web-engineer`): record the tag and continue.
- If it does not exist, this is a **first-class specialist-generation moment**, not a fallback. Announce it explicitly:

> "There isn't a `<stack>-engineer` in the roster yet. I'll generate one from the specialist template now — it carries the universal engineering discipline and adds <stack>-specific depth. This will take a few short questions."

Then conduct the on-demand interview from `templates/engineer-specialist.template.md`:

13a. Name 2–4 reference figures or sources that define craft on this stack (the specialist's intellectual lineage — the method and what the field learned, not just the output).
13b. Name the one or two boundaries this specialist must not blur (e.g. server vs. client state for web; main-thread vs. background for mobile; schema vs. query for data).
13c. Capture the Scaffold Blueprint inputs (Layout, Sharing Mechanism, Resource Handling, Scaffold Commands) — the four sections required by spec §B of the paired-scaffold capability. The template's Android worked example shows the contract held across a mechanically different sharing mechanism (Gradle project-inclusion); use it as a reference when the stack you're generating uses a third-instance mechanism.

Generate `agents/<stack>-engineer.md` from the template with the answers, then register it in `STRUCTURE.md` (engineering roster line) and `evals/engineering-agents.eval.md` (the coverage rule: no agent ships without an eval). Confirm with the user that the specialist is ready, then continue.

**Why this is first-class, not a fallback.** Demand surfaces a stack → on-demand generation serves it → real runs validate it → validated ones graduate to the default bundle. The marketplace itself is the validation pipeline; visibility at this moment is what makes growth honest.

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

The manifest below is parsed by every skill that touches code. Missing
keys are an error — re-run `/studio:init --update` to fix. The contract
block is required; the scaffold block records one-time state set by the
scaffold flow (Phase 5).

```yaml
# contract block — every skill reads
stack: [canonical stack tag, e.g. swift | web | android | react-native | flutter | backend | data | ml | fullstack]
code_root: [repo-relative path; default: code/ — declare . only if the project predates the canonical layout]
shared_module_name: [the IMPORT name, e.g. AppDesignSystem or @project/design-system; omit for app-only]
sharing_mechanism: [spm-local | pnpm-workspace | npm-workspace | yarn-workspace | gradle-project; omit for app-only]
platform: [Apple stacks only: ios | macos | multiplatform]
package_manager: [Web stacks only: pnpm | npm | yarn]
canvas_framework: [Web stacks only: storybook | ladle]
spec_path: [path; default: specs/]
decisions_path: [path; default: decisions/]

# scaffold block — one-time state, written by Phase 5
scaffold_state: [none | manual | complete]
generation_tool: [xcodegen | none]
```

Stack-specific keys (`platform`, `package_manager`, `canvas_framework`) are
omitted when not applicable to the declared `stack`.

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

> "What will you primarily use Studio OS for on this project?"

Give examples:

> Examples: planning and discovery (research synthesis, journey maps, briefs), design work (interaction models, specs), engineering implementation, measurement and analytics, strategy and direction, all of the above.

Accept free-form answers.

---

**Question 3:**

> "Is there anything about this project that Studio OS should know about your specific context — your constraints, your team structure, or what you're responsible for?"

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
**Primary contribution:** [what they're using Studio OS for on this project]

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

## Phase 4 — Personalization (optional)

After context and role are set, offer to personalize the studio to this user/product. Each step is optional — offer it, accept "skip," and move on. These use the same mechanism: ship a curated default, let each install extend it.

### Step A — Reference palette

> "Studio OS ships a curated reference palette agents draw on (in `design-references.md`). Want to add your own? Name products whose design you admire (positive) and ones to design away from (anti-references). For each: product → the one-line lesson → stance."

Append the user's entries to `.claude/memory/design-references.md` (create from the shipped default if absent). Do not replace the defaults — extend them. Cite the *method and what the field learned*, never just the output.

### Step B — Display personas

> "Each agent has a stable handle (e.g. `cd`) and a display name it speaks under (Creative Director). You can give any agent a persona name — by default drawn from its own intellectual lineage (CD → Rams, DE → Knuth/Hopper, PM → Christensen, Critic → Rams, Historian → ...). Want to set personas, use the lineage defaults, or skip?"

If the user opts in, write a map of handle → persona to `.claude/memory/agent-personas.md`. The canonical handle never changes (routing depends on it); the persona is cosmetic — what the agent calls itself.

### Step C — Additional engineering specialists

> "The engineer family ships a stack-neutral base plus `swift-engineer`
> (all Apple platforms) and `web-engineer`. Your primary stack's specialist
> was already generated in Phase 2 if it didn't exist yet. Add a specialist
> for *another* stack you'll work with on this project (e.g. backend,
> android, fullstack, data, ml)? Otherwise skip."

For each additional specialist: same on-demand generation procedure as
Phase 2 Section 5 — ask the stack, the 2–4 reference figures/sources (its
lineage), the one or two boundaries it must not blur, and the Scaffold
Blueprint inputs (Layout, Sharing Mechanism, Resource Handling, Scaffold
Commands). Generate `agents/<stack>-engineer.md` from
`templates/engineer-specialist.template.md`, register in `STRUCTURE.md`
and `evals/engineering-agents.eval.md`.

### Step D — Brand identity (for the studio's rendered surfaces)

The Artifact Kit (`artifacts/kit/studio.css`) and the skills that render HTML (artifacts, the `gather-feedback` review surface, the `annotate` overlay) ship with the **Standard Works** identity by default — Neue Haas Grotesk, black on warm white, monochrome. If the user runs their own studio brand, let them put it in:

> "The studio's rendered surfaces use the Standard Works visual brand by default. Do you have your own studio brand to use instead? If so I'll capture it; otherwise we keep Standard Works."

If the user has a brand, capture:
- **Type** — a font source (a Typekit/Adobe Fonts or Google Fonts `@import`/link, or a local `@font-face`) and the family names for display, text, and mono.
- **Color** — background, text, rule/border, and a single muted accent (the studio palette stays restrained — "color is earned").

Write these as a `:root` override to `.claude/memory/brand.css` and have artifacts load it **after** `studio.css` (it overrides the kit's CSS variables — fonts and `--accent`/palette — without touching the component classes). Default, if the user has no brand: Standard Works, unchanged. This is the same configurable pattern as the palette, personas, and engineering specialists — ship a default, let each install put in its own.

---

## Phase 5 — Scaffold Execution

This phase creates the paired workspace — `code/app` + `code/canvas` +
`code/shared` (the by-reference module) — per the paired-scaffold
capability spec. Each step is gated on the previous; failure leaves the
project in a clean prior state, never silently advances. The full spec
lives at `specs/paired-scaffold-capability.md`.

### Pre-flight (Step 0)

Read `.claude/memory/project-context.md`'s `## Engineering Context`
manifest. If `scaffold_state` is already present:

> "A scaffold is already present (`scaffold_state: <state>`). Would you like to:
> 1. Use the existing scaffold and skip Phase 5
> 2. Promote the shape (e.g. `app-only → triple`) via `/studio:init --update`
> 3. Convert from `manual → complete` via `/studio:init --update --generator=xcodegen` (Swift only)"

Wait for the user's choice. Otherwise continue to Step 1.

### Step 1 — Declare stack (specialist matched in Phase 2)

The stack tag was already captured and the specialist was generated (if
absent) during Phase 2 Section 5. Read the tag from the manifest and
load `agents/<stack>-engineer.md`. From the specialist, read the
**Scaffold Blueprint** section — Layout, Sharing Mechanism, Resource
Handling, and the `scaffold-commands` block (the unambiguous parse anchor
per spec §B). This is the blueprint Phase 5 executes.

### Step 2 — Declare shape

Ask:

> "Does this project have a shared front-end module that spans multiple
> surfaces (e.g. a design system, a shared component library)? Will you
> prototype this project in a canvas (Storybook for web; a Canvas Xcode
> project for Swift)?"

Map the answer:

- both → `triple` (the default for a multi-surface project with prototyping)
- canvas only, no SHARED → `collapse` (no design system, or it's external)
- neither → `app-only`

If `triple`, in the same exchange, ask:

> "What is the shared module's import name? (e.g. `AppDesignSystem` for
> Swift, `@project/design-system` for web.)"

Record as `shared_module_name` in the manifest. For Swift the package
name equals the import name; for web the package name is the full string
including the scope.

### Step 3 — Create and initialize

Create the role directories from the specialist's Layout section:

- `<code_root>/app/` — always.
- `<code_root>/canvas/` — when shape is `triple` or `collapse`.
- `<code_root>/shared/` — when shape is `triple`.

Initialize the shared module per the specialist's blueprint:

- **Swift:** write `<code_root>/shared/Package.swift` declaring the
  `<shared_module_name>` library target. Create `Sources/<shared_module_name>/`,
  `Sources/<shared_module_name>/Resources/`, and a stub `index` file (an
  empty Swift file documenting the package's role).
- **Web:** write `<code_root>/shared/package.json` with `name:
  <shared_module_name>`, an `exports` field stub, and the workspace
  metadata. Write the root `<code_root>/package.json` declaring
  `workspaces: ["app", "canvas", "shared"]` (or `pnpm-workspace.yaml`
  when `package_manager: pnpm`).
- **Other stacks (on-demand specialists):** follow the Layout section of
  the just-generated specialist; the contract holds across mechanisms.

### Step 4 — Wire the by-reference dependency

This is the load-bearing step — the INCLUDED-BY-REFERENCE invariant is
encoded here. The exact form depends on the sharing mechanism:

- **Web (`pnpm-workspace` / `npm-workspace` / `yarn-workspace`):**
  - Write `app/package.json` and `canvas/package.json` each declaring
    `"<shared_module_name>": "workspace:*"` in dependencies.
  - Run the package manager's install command from `code_root`
    (e.g. `pnpm install`). Symlinks complete the wiring.
- **Swift (`spm-local`):**
  - **Default path** (`generation_tool: xcodegen`): write
    `code/app/project.yml` and `code/canvas/project.yml` each declaring
    the package `path: ../shared` and the `<shared_module_name>`
    dependency on the main target. Execute the specialist's `generate`
    `scaffold-commands` entry in both directories.
  - **Escape hatch** (`generation_tool: none`, manual path): offer the
    user the choice when the declarative generator isn't desired. Set
    `scaffold_state: manual`, `generation_tool: none`, and emit:

    > "Add a local Swift Package dependency on `../shared` to:
    > 1. `code/app/<App>.xcodeproj`
    > 2. `code/canvas/<App>Canvas.xcodeproj`
    >
    > Reply `done` when the dependency is in place."

    On reply, re-run Step 6 (verify).
- **Other stacks:** follow the Sharing Mechanism section of the
  specialist (e.g. Gradle's `include(":shared")` +
  `implementation(project(":shared"))` for Android).

### Step 5 — Write the manifest

Update `.claude/memory/project-context.md`'s `## Engineering Context`
section with the contract block + scaffold block per spec §A:

```yaml
stack: <from Phase 2>
code_root: <default: code/, or . if legacy>
shared_module_name: <if triple; the import name>
sharing_mechanism: <one of: spm-local | pnpm-workspace | npm-workspace | yarn-workspace | gradle-project>
platform: <Apple only: ios | macos | multiplatform>
package_manager: <web only: pnpm | npm | yarn>
canvas_framework: <web only: storybook | ladle>
spec_path: <default: specs/>
decisions_path: <default: decisions/>

scaffold_state: <set after Step 6: complete on success; manual on escape hatch; none if not yet scaffolded>
generation_tool: <xcodegen | none>
```

### Step 6 — Verify

Run the verify-build commands derived from the specialist's
`scaffold-commands` block:

- **Web:** `<package_manager> --filter canvas dev` resolves the shared
  import; `<package_manager> --filter app build` exits 0.
- **Swift:** `swift build --package-path code/shared` exits 0;
  `xcodebuild -project code/app/<App>.xcodeproj -scheme <App> build`
  exits 0.

On success: set `scaffold_state: complete` in the manifest.

On failure: report the failing command + its first 20 lines of error
output + the path to the file most likely involved. Leave
`scaffold_state` at its prior value (do not silently mark complete).
Common failure recovery is `/studio:init --update`.

---

## --update mode (Phase 5 transitions)

`/studio:init --update` covers two cases per spec §D and §E:

- **Shape promotion** (§E):
  - `app-only → collapse` — add canvas; create `code/canvas/`; wire it.
  - `app-only → triple` — add canvas + shared; create both; wire both;
    ask for `shared_module_name` if not yet set.
  - `collapse → triple` — add shared; create `code/shared/`; offer to
    move any front-end primitives currently in `app` to `shared` with
    per-file confirmation; wire both dependencies.
  - Shape demotion is **not supported** — demotion is a discipline
    question, not a scaffold question.
- **Manual → complete conversion** (§D, Swift only):
  - `--update --generator=xcodegen` reads the hand-wired dependency
    from `.pbxproj`, writes equivalent `project.yml` files for `app`
    and `canvas`, runs `xcodegen generate`, runs Step 6 verify, sets
    `scaffold_state: complete` + `generation_tool: xcodegen`.

After either transition, re-run Step 5 (manifest update) and Step 6
(verify).

---

## Post-write

After context, role, personalization, and scaffold are all complete,
confirm:

> "Setup complete. Studio OS is calibrated to [product name] and your role as [role].
>
> Written:
> - `.claude/memory/project-context.md` — product context + engineering manifest (shareable with your team)
> - `.claude/memory/role-context.md` — your role on this project (personal, don't commit)
> - `code/app/`, `code/canvas/`, `code/shared/` — the paired scaffold ([shape: triple | collapse | app-only])
>
> Start with `/studio:studio <goal>` to orient, or jump in with `/studio:design <problem>` or `/studio:discover <problem>`. Run `/studio:studio` any time to see the roles, gates, and what each workflow produces."

If Phase 5 was skipped (existing scaffold) or shape is `app-only`, omit
the `code/` lines from the summary.

If a design system skill does not yet exist at `.claude/skills/design-system/`, add:

> "No design system skill found. Run `/design-system-init` to scaffold one — it creates token file templates and a component directory ready to populate."

If `user-profile.md` was not found during Phase 1 context check, add:

> "No personal profile found. Create one at `~/.claude/memory/user-profile.md` — it helps Studio OS calibrate its communication style and assumed knowledge across all your projects."
