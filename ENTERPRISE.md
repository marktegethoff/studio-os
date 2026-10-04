# Studio OS — Enterprise Architecture

*Sprint: 2026-04-20. Decisions from a full-day architecture session covering distribution model, agent strategy, install UX, and personalization.*

---

## Context

Studio OS was designed as a single-developer system. This document defines the architecture for scaling to enterprise teams — 100+ designers and product managers working alongside engineers across multiple products and user personas.

The target audience is product managers and designers who are building directly alongside engineering counterparts. These are people using Claude Code as a primary tool but whose primary discipline is not software engineering.

---

## The Three-Tier Distribution Model

Every Studio OS installation operates across three concentric tiers. Each tier has a defined owner, enforcement model, and update mechanism.

```
┌─────────────────────────────────────────────────────┐
│  CORE                         (org-managed)          │
│  LT gates · Process skills · Org hooks               │
│  Distributed: managed plugin or install-core         │
├─────────────────────────────────────────────────────┤
│  ROLE                         (individual)           │
│  Discipline agents · Workflow skills                 │
│  Distributed: recommended menu, additive install     │
├─────────────────────────────────────────────────────┤
│  PRODUCT                      (team / repo)          │
│  project-context.md · Product hooks · Custom agents  │
│  Distributed: committed to product repo              │
└─────────────────────────────────────────────────────┘
```

### Core Tier

Org-enforced. Every team member receives this. Cannot be bypassed in managed mode.

**Agents (8):**

| Agent | Purpose |
|---|---|
| `pm` | Problem validation gate — upstream of all design |
| `cd` | Design ship/no-ship gate |
| `de` | Engineering merge gate |
| `heurist` | Usability evaluation |
| `auditor` | Documentation coherence |
| `luck` | Durability diagnostic for infrastructure decisions |
| `competitive-analyst` | Structured competitive teardown |
| `surveyor` | Trend research sweep → dated trends file |

**Skills (5):** `studio` · `discover` · `measure` · `review` · `solve`

**Hooks (5, org-enforced) — not built.** The plugin ships one hook, `deposit-reminder` (SessionEnd). The five below are the design.

| Hook | Event | Purpose |
|---|---|---|
| `problem-gate` | PreToolUse/Write | Blocks design output without a validated PM brief |
| `scope-creep` | PreToolUse/Write | Flags additions outside defined scope |
| `brand-gate` | PreToolUse/Bash | Verifies brand invariants before commit |
| `session-report` | Stop | Writes session summary to memory |
| `escalation-check` | Notification | Routes escalations to the correct LT member |

**Distribution:**
- Enterprise: Claude Code managed plugin + `allowManagedHooksOnly` in managed settings
- Non-managed: `./install.sh` installs Core first, then prompts for Role selection. Hooks function identically; no technical enforcement. See [Non-Managed Mode](#non-managed-mode).

### Role Tier

Individual. Installed via a recommended menu, not enforced packages. Additive — install more disciplines at any time. Re-runnable without penalty.

Three sets: **Design**, **PM & Discovery**, **Engineering**. The agents in each set are listed in [STRUCTURE.md](STRUCTURE.md), the authoritative agent → tier mapping.

| Set | Skills |
|---|---|
| Design | `design` · `ideate` · `simulate` · `prototype` |
| PM & Discovery | `experiment` · `ideate` · `discover` · `measure` |
| Engineering | `implement` · `simplify` |

**Name collision rule:** Core agent names are reserved. The Role menu never presents a Core agent. The install script guards against any Role package file overwriting a Core agent by name — warn and abort if attempted.

### Product Tier

Per-team, per-repo. Committed to the product repository's `.claude/` directory. Inherited by every team member on clone.

**Contents:**
- `.claude/memory/project-context.md` — written by `/studio:init`; product identity, user archetypes, system invariants, design principles, tech stack, active decisions
- `.claude/memory/role-context.md` — written by `/studio:init` (role calibration phase); user's discipline and experience level for per-project calibration
- Product `CLAUDE.md` — product-specific always-on rules; extends org CLAUDE.md, does not replace it
- `.claude/settings.json` — product hooks (`canvas-gate`, `branch-guard`; not built)
- Optional product-specific agents — must use namespaced names (e.g., `acme-regulatory-reviewer`) to prevent collision with Core and Role names

---

## Install UX

*Not built. The shipped install is the plugin (`/plugin`), with `install.sh` as a copy-only fallback. Project setup ships as `/studio:init`. The commands, menus, and profile interview here and in Personal Profile and Onboarding Flow are the design.*

### Commands

```
studio setup          — first-time install: Core + role selection + personal profile
studio add            — add a discipline after initial setup
studio update         — update installed collaborators to latest versions
studio setup --me     — update your personal profile
```

### First-install menu

```
Studio OS
────────────────────────────────
Setting up your AI collaborators.

Always included: PM · Creative Director · Distinguished Engineer
                 Heurist · Audit · Luck · Competitive Analyst · Surveyor

What's your primary discipline?

  [D] Design
  [P] Product
  [E] Engineering
  [A] All disciplines
  [M] Let me choose
```

### Add disciplines (studio add)

```
Studio OS
────────────────────────────────
Installed: Design (12 collaborators)

Add a discipline:
  [P] Product     — Researcher, Journey Mapper, Brief Writer...
  [E] Engineering — Engineer, QA, Architect, Specifier...
  [M] Choose individually

────────────────────────────────
  [U] Update installed collaborators to latest
```

The horizontal rule separates expanding (add a discipline) from maintaining (update existing). A user who wants to add engineering agents after initial setup runs `studio add` — one command, additive, no reconfiguration.

### Non-managed mode

For teams on Claude Code Pro or Teams (not enterprise managed):

```
Studio OS is ready.

Your settings aren't locked — anyone on the team with Claude Code
access can view or change them. If your team needs enforced
settings, this is done through Claude Code's enterprise controls.
```

Hooks function identically in non-managed mode. The only difference: a determined user could edit `settings.json` to remove them. For teams that have chosen to adopt Studio OS, this is an acceptable behavioral constraint rather than a technical one. Enterprise licensing enables `allowManagedHooksOnly` for full enforcement.

---

## Personal Profile

Runs during `studio setup` immediately after discipline selection. Three questions. Skippable at any point.

### The interview

```
About you
---------

What kind of [Design] do you do?

  1  UX Designer
  2  Product Designer
  3  Service Designer
  4  Content Designer / Content Strategist
  5  UX Researcher
  6  Design Systems Designer
  7  Other — type it

Enter a number, or type your own role:
```

```
What are your strongest skills? (Select all that apply, or press Enter to skip)

  1  Visual design          5  Content and copy
  2  Interaction design     6  Service design / journey mapping
  3  User research          7  Data and analytics
  4  Systems thinking       8  Strategy and vision

Enter numbers separated by spaces (e.g. 1 3 5):
```

```
Where are you in your practice?

  1  Early career — building the craft
  2  Mid-level — established practice, growing scope
  3  Senior — independent, shaping direction
  4  Lead / Principal — setting direction, mentoring others

Enter a number:
```

The role list in question 1 adapts to the discipline selected in the prior step.

### Confirmation

```
Got it.

  Role:        Product Designer
  Skills:      Interaction design, Systems thinking, Strategy and vision
  Experience:  Senior

Agents will use this to calibrate how they work with you. You can update it any time with:

  studio setup --me

Continuing setup...
```

### Skip path

Type `S` at any question:

```
Skipped. Agents will work without a personal profile — you can add one later with:

  studio setup --me
```

### Profile file

Written to `~/.claude/memory/user-profile.md`. Global — persists across all projects and sessions.

```markdown
# User Profile
Last updated: [date]

## Role
Product Designer

## Skills
Interaction design, Systems thinking, Strategy and vision

## Experience
Senior — independent, shaping direction
```

Skipped fields are omitted entirely. No placeholder text, no empty headings.

### Agent instruction

Added to the Memory Architecture section of every agent definition, loading before project context:

```
`user-profile.md` — role, skills, and experience level; calibrate language, assumed knowledge, and framing to match (~/.claude/memory/ only)
```

"Calibrate language, assumed knowledge, and framing" — not "adjust tone." A UX researcher doesn't need research methods explained. A content designer should be met with language-system framing. A junior designer gets scaffolding a principal doesn't need.

---

## Onboarding Flow — New Team Member

```
1. IT push (enterprise)   → managed settings applied; Core plugin installed; allowManagedHooksOnly set
   — or —
   Manual (non-managed)   → user runs: ./install.sh → Core installed automatically

2. Role selection         → menu shown; user selects discipline(s); Role agents installed

3. Personal profile       → three questions; writes ~/.claude/memory/user-profile.md

4. Repo clone             → product .claude/ directory present; product hooks active

5. /studio:init          → runs product interview; writes project-context.md + role-context.md

Done. All three tiers active. Agents calibrated to product and role.
```

Total setup time: under 15 minutes.

---

## CLAUDE.md Placement Rule

One sentence, added to the Studio OS Integration section of every project CLAUDE.md:

> CLAUDE.md carries always-on rules. Skills carry on-demand workflows. Agents carry single-discipline expertise. Never place workflow logic in CLAUDE.md.

---

## Implementation Sequence

| Step | Work | Dependencies | Status |
|---|---|---|---|
| 1 | Redesign install script — `studio setup`, role menu, Core name guard | None | Not built |
| 2 | Author the 7 new agents (`competitive-analyst`, `systematist`, `user-researcher`, `journey-mapper`, `brief-writer`, `metrics-definer`, `assumption-mapper`) | None | Built |
| 3 | Author `discover` + `measure` skills | Step 2 (agents must exist) | Built |
| 4 | Add personal profile interview to `studio setup` | Step 1 | Not built |
| 5 | Project setup — three-phase interview, role-context.md output | Steps 1–2 | Built as `/studio:init` |
| 6 | Delete 12 duplicate single-discipline skill wrappers | None | Built — `skills/` holds none |
| 7 | Add CLAUDE.md placement rule to template | None | Not built — the rule lives in this repo's CLAUDE.md only |

Open work: steps 1, 4 and 7. Step 4 follows step 1; step 7 is independent.
