# XD OS — Enterprise Architecture

*Sprint: 2026-04-20. Decisions from a full-day architecture session covering distribution model, agent strategy, install UX, and personalization.*

---

## Context

XD OS was designed as a single-developer system. This document defines the architecture for scaling to enterprise teams — 100+ designers and product managers working alongside engineers across multiple products and user personas.

The target audience is product managers and designers who are building directly alongside engineering counterparts. These are people using Claude Code as a primary tool but whose primary discipline is not software engineering.

---

## The Three-Tier Distribution Model

Every XD OS installation operates across three concentric tiers. Each tier has a defined owner, enforcement model, and update mechanism.

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

**Agents (7):**

| Agent | Model | Purpose |
|---|---|---|
| `pm` | Opus | Problem validation gate — upstream of all design |
| `design-director` | Opus | Design ship/no-ship gate |
| `de` | Opus | Engineering merge gate |
| `xd-heurist` | Opus | Usability evaluation |
| `audit` | Sonnet | Documentation coherence |
| `luck` | Sonnet | Durability diagnostic for infrastructure decisions |
| `competitive-analyst` | Sonnet | Structured competitive teardown |

**Skills (6):** `studio` · `lt-review` · `xd-discovery` · `xd-measure` · `xd-review` · `xd-solve`

**Hooks (5, org-enforced):**

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

**Design set (12 agents):**
`designer` · `xd-strategist` · `xd-historian` · `xd-critic` · `xd-accessibility` · `xd-validate-design` · `xd-typesetter` · `xd-choreographer` · `xd-materialist` · `xd-visual-designer` · `xd-writer` · `xd-design-systems`

Skills: `design` · `xd-ideate` · `xd-simulate` · `validate-design` · `xd-prototype`

**PM set (10 agents):**
`xd-strategist` · `xd-scout` · `xd-historian` · `marketer` · `xd-critic` · `xd-user-researcher` · `xd-journey-mapper` · `brief-writer` · `metrics-definer` · `assumption-mapper`

Skills: `xd-experiment` · `xd-ideate` · `xd-discovery` · `xd-measure`

**Engineering set (5 agents):**
`engineer` · `qa` · `xd-architect` · `xd-specifier` · `xd-research-sweep`

Skills: `xd-implement` · `xd-simplify` · `xd-architect`

*Note: Strategist and Historian appear in both Design and PM sets — identical files, same path, no conflict.*

**Name collision rule:** Core agent names are reserved. The Role menu never presents a Core agent. The install script guards against any Role package file overwriting a Core agent by name — warn and abort if attempted.

### Product Tier

Per-team, per-repo. Committed to the product repository's `.claude/` directory. Inherited by every team member on clone.

**Contents:**
- `.claude/memory/project-context.md` — written by `xd project`; product identity, user archetypes, system invariants, design principles, tech stack, active decisions
- `.claude/memory/role-context.md` — written by `xd project --role`; user's discipline and experience level for per-project calibration
- Product `CLAUDE.md` — product-specific always-on rules; extends org CLAUDE.md, does not replace it
- `.claude/settings.json` — product hooks (`canvas-gate`, `branch-guard`)
- Optional product-specific agents — must use namespaced names (e.g., `acme-regulatory-reviewer`) to prevent collision with Core and Role names

---

## New Agents (v2 additions)

Seven new agents identified in this sprint. None exist yet — these are to be authored.

### Core additions

**`competitive-analyst`** (Sonnet)
Structured competitive teardown on demand. Takes a problem space and 3–5 named competitors. Produces: feature coverage matrix, UX pattern analysis, positioning map, gap identification. Distinct from Scout (which surfaces ongoing market signal). Scout gives awareness; Competitive Analyst gives the structured map PMs and designers use for positioning decisions.

### Design Role additions

**`xd-design-systems`** (Sonnet)
Cross-product design system health. Audits pattern proliferation, token drift, component naming inconsistency. Evaluates whether the design system is growing coherently or fragmenting. Distinct from Validate Design (which checks a single mockup against spec). This evaluates the health of the system itself. Load-bearing at multi-product scale.

### PM Role additions

**`xd-user-researcher`** (Sonnet)
Synthesizes qualitative research — interview transcripts, usability test results, feedback sessions — into product-relevant patterns. Maps findings to feature decisions. Does not conduct research; synthesizes records of research already done. The most-used PM workflow with no current home in XD OS.

**`xd-journey-mapper`** (Sonnet)
Maps the user's end-to-end journey before any surface design begins. Surfaces entry points, context switches, adjacent moments, and friction points. Produces a journey artifact that constrains and focuses the Designer's scope. Fills the seam between PM problem validation and Designer interaction modeling.

**`brief-writer`** (Sonnet)
Produces structured design briefs as the handoff artifact between discovery and design. Output: validated problem, user, success conditions, constraints, out-of-scope. This brief gates `design`. Distinct from Writer (which handles UI copy); Brief Writer handles the strategic handoff document.

**`metrics-definer`** (Sonnet)
Defines success metrics before implementation begins — leading indicators, lagging indicators, instrumentation requirements, baseline and target values. Works upstream of engineering. Output is an acceptance condition committed alongside the spec, not a post-launch analytics request.

**`assumption-mapper`** (Sonnet)
Surfaces build assumptions, user assumptions, and technical assumptions before the team invests engineering cycles. Assigns risk levels. Identifies the single assumption whose failure would make the feature worthless. Outputs a risk register. Strategist evaluates whether to proceed; Assumption Mapper surfaces what the Strategist needs.

---

## New Skills (v2 additions)

**`xd-discovery`**
The upstream workflow that precedes `design`. Currently absent — discovery is informal and unstructured.

Sequence: User Researcher (synthesize research) → Journey Mapper (map full context) → Assumption Mapper (surface risks) → PM gate (validate the brief) → Brief Writer (produce handoff artifact)

Output: a completed brief, ready to pass directly into `design`.

**`xd-measure`**
Success metrics defined before implementation begins, not retrofitted after.

Sequence: Metrics Definer (define success conditions) → PM gate (validate against the validated problem) → Architect (confirm instrumentation is feasible in the current data model)

Output: a measurement plan committed alongside the spec.

---

## Install UX

### Commands

```
studio setup          — first-time install: Core + role selection + personal profile
studio add            — add a discipline after initial setup
studio update         — update installed collaborators to latest versions
studio project        — set up a new project (replaces xd-init)
studio setup --me     — update your personal profile
```

### First-install menu

```
XD OS
────────────────────────────────
Setting up your AI collaborators.

Always included: PM · Design Director · Distinguished Engineer
                 Heurist · Audit · Luck · Competitive Analyst

What's your primary discipline?

  [D] Design
  [P] Product
  [E] Engineering
  [A] All disciplines
  [M] Let me choose
```

### Add disciplines (studio add)

```
XD OS
────────────────────────────────
Installed: Design (12 collaborators)

Add a discipline:
  [P] Product     — Researcher, Journey Mapper, Brief Writer...
  [E] Engineering — Engineer, QA, Architect, Specifier...
  [M] Choose individually

────────────────────────────────
  [U] Update installed collaborators to latest
```

The horizontal rule separates expanding (add a discipline) from maintaining (update existing). A user who wants to add engineering agents after initial setup runs `xd add` — one command, additive, no reconfiguration.

### Non-managed mode

For teams on Claude Code Pro or Teams (not enterprise managed):

```
XD OS is ready.

Your settings aren't locked — anyone on the team with Claude Code
access can view or change them. If your team needs enforced
settings, this is done through Claude Code's enterprise controls.
```

Hooks function identically in non-managed mode. The only difference: a determined user could edit `settings.json` to remove them. For teams that have chosen to adopt XD OS, this is an acceptable behavioral constraint rather than a technical one. Enterprise licensing enables `allowManagedHooksOnly` for full enforcement.

---

## Personal Profile

Runs during `xd setup` immediately after discipline selection. Three questions. Skippable at any point.

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

5. studio project         → runs product interview; writes project-context.md + role-context.md

Done. All three tiers active. Agents calibrated to product and role.
```

Total setup time: under 15 minutes.

---

## CLAUDE.md Placement Rule

One sentence, added to the XD OS Integration section of every project CLAUDE.md:

> CLAUDE.md carries always-on rules. Skills carry on-demand workflows. Agents carry single-discipline expertise. Never place workflow logic in CLAUDE.md.

---

## Implementation Sequence

| Step | Work | Dependencies |
|---|---|---|
| 1 | Redesign install script — `xd setup`, role menu, Core name guard | None |
| 2 | Author 7 new agents | None (parallel with step 1) |
| 3 | Author `xd-discovery` + `xd-measure` skills | Step 2 (agents must exist) |
| 4 | Add personal profile interview to `xd setup` | Step 1 |
| 5 | Update `xd project` — three-phase interview, role-context.md output | Steps 1–2 |
| 6 | Delete 12 duplicate single-discipline skill wrappers | None |
| 7 | Add CLAUDE.md placement rule to template | None |

Steps 1 and 2 can begin immediately in parallel. Step 6 and 7 are independent cleanup tasks.
