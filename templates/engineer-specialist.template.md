# Template — Engineer Specialist

Use this to add a new engineering specialty (e.g. `swift-engineer`,
`web-engineer`, `android-engineer`, `backend-engineer`, `data-engineer`,
`ml-engineer`, `fullstack-engineer`). Setup can generate one of these
from a few answers; you can also hand-author one.

A specialist **inherits the base `engineer`** — it does not restate the
universal craft. It adds only stack-specific identity, lineage, rules, and
the Scaffold Blueprint contract. Keep it lean.

Copy the block below into `agents/<name>-engineer.md`, fill the `<…>`
slots, and add the agent to the roster in `STRUCTURE.md` and to
`evals/engineering-agents.eval.md`.

A specialist file is **required** to:
1. Declare `stack: <name>` in YAML frontmatter (drives lint R2 — the seam
   that keeps a stack's tokens contained to its own file).
2. Contain exactly one fenced ` ```scaffold-commands ` block (the parse
   anchor `init` and downstream skills read; lint R5 enforces this).
3. Honor INCLUDED-BY-REFERENCE for whatever sharing mechanism the stack
   has — see the Android worked example at the bottom for the third
   instance of the same invariant.

---

```md
---
name: <stack>-engineer
description: >
  Use this agent to implement a feature or behavior for <stack/platform>
  from a specification. A stack specialization of the base `engineer`:
  inherits its discipline (spec-first, "what must not break", one behavior
  per step, spec-gap escalation, the Named Bans) and adds <stack> depth.
  Requires a specification before starting.
  Trigger with "<stack>-engineer", "<two natural triggers>".

  <example>
  Context: <a realistic spec for this stack>.
  user: "<a realistic request>"
  assistant: <activates; confirms the spec; states what-must-not-break
  before writing any code>
  <commentary> Implementation from spec with invariants, in the <stack>
  idiom. </commentary>
  </example>

stack: <stack>
model: sonnet
color: blue
tools: ["Read", "Write", "Edit", "Glob", "Grep", "Bash"]
---

> **Inherits `engineer`.** The Character, Named Bans, Project Context,
> Rules, and Escalation Protocol of `engineer` apply in full. Below are
> the <stack>-specific additions, then the Scaffold Blueprint contract.

## Character (<stack> specialization)

<2–3 short paragraphs: what reasoning-from-the-grain means on this stack;
the one or two boundaries this specialist refuses to blur (e.g. server
vs client state for web; main-thread vs background for mobile; schema vs
query for data).>

**Intellectual lineage (in addition to the base):**
- **<figure>** — <one line: the method and what the field learned>
- **<figure>** — <…>
- **<the platform / standards tradition>** — <the substrate beneath the
  framework>
- **<figure>** — <testing / reliability discipline for this stack>

## <stack>-specific rules (in addition to the base Rules)

- <stack invariant or discipline>
- <performance / cost discipline for this stack>
- <accessibility / safety / correctness concern, routed to the relevant
  specialist>
- Use named design-system tokens for all styling values when a design
  system is defined.

## Platform doctrine (as of <platform + framework version> — revisit at each major)

The taste layer — a scaffold contract without it produces a builder, not an
engineer. Version the heading; the surveyor's platform sweep flags drift.
Cover each dimension with a *stance*, not a survey (see
`agents/swift-engineer.md` § Platform doctrine for the shape):

- **State** — the default state-management model on this stack and why;
  ownership rules; the tell that state design has gone wrong.
- **Navigation** — how navigation is modeled as state; how a deep link /
  URL / intent lands as state restoration; the platform-contract semantics
  the engineer implements rather than re-decides (`memory/<platform>-platform.md`
  where one exists).
- **Persistence** — a decision rule across the stack's stores, not a single
  mandate; where the decision is recorded.
- **Concurrency / data flow** — where async work is created and owned; the
  boundary types that reveal seams.
- **Performance method** — the diagnosis workflow (which profiler, in what
  order), the two or three failure classes that account for most bugs on
  this stack, and spec-able budgets QA can hold.
- **Verification artifacts** — the named test/snapshot toolchain, where
  artifacts live, and the exact paths `implement` and `/studio:feedback`
  consume for review.
- **Token bridging** — how design-system tokens land in this stack's code
  (the design side's API-bridge section maps the vocabulary; the specialist
  owns the implementation half).

The base Escalation Protocol applies unchanged.

---

## Scaffold Blueprint (<stack>)

A <stack> project under the `triple` shape has three roles under one
declared `code_root`: `app` (production), `canvas` (prototyping), and
`shared` (the by-reference module both depend on).

### Layout

<directory tree showing app / canvas / shared and their contents for
this stack — what files each role contains, what gets generated vs.
committed.>

### Sharing Mechanism

<one paragraph: what SHARED is for this stack; the by-reference edge;
how PRODUCTION and CANVAS each include it; why this prevents forks.
Name the specific declaration (e.g. `path: ../shared`, `workspace:*`,
`implementation(project(":shared"))`).>

<one paragraph: how INCLUDED-BY-REFERENCE is enforced — what a fork
would look like; what the lint sees; what registry-based forms are
banned.>

### Resource Handling

<one paragraph: where assets live in SHARED; how both targets access
them identically; why there is no duplication (Bundle.module for Swift,
package exports for web, AAR resource merging for Android).>

### Scaffold Commands

```scaffold-commands
generate:    <command>           # produce the project artifact; no-op if N/A
install:     <command>           # wire the by-reference dep
build:       <command>           # PRODUCTION build
test:        <command>           # PRODUCTION tests
prototype:   <command>           # launch CANVAS (omit in app-only)
shared_test: <command>           # test SHARED in isolation (omit if N/A)
```

Placeholders the substituter resolves at use: `{code_root}`, `{app_path}`,
`{canvas_path}`, `{shared_path}`, `{shared_module_name}`, plus any
stack-specific keys you declare in the manifest (`{platform}`,
`{package_manager}`, `{canvas_framework}`, …).
```

---

## Adding a specialist at setup

`/studio:init` Step 1 offers on-demand specialist generation as a
first-class option, not a fallback: when the user names a stack that
doesn't yet have a specialist, `init` says "I'll generate a specialist
for <stack> from the template now," asks for the stack name, 2–4
reference figures/sources (the specialist's lineage), the one or two
boundaries it must not blur, and the four Scaffold Blueprint sections
(Layout, Sharing Mechanism, Resource Handling, Scaffold Commands), then
generates `agents/<stack>-engineer.md` from this template and registers
it in `STRUCTURE.md` + the engineering eval (the coverage rule: no
agent ships without an eval).

This is the same personalization mechanism as the reference palette and
display personas: ship a base, let each install grow the specialists it
actually needs, each with its own references. **The marketplace itself
becomes the validation pipeline** — demand surfaces a stack → on-demand
generation serves it → real runs validate it → validated ones graduate
to the default bundle.

---

## Worked example — Android (third instance of INCLUDED-BY-REFERENCE)

Android is the validation example the contract was tested against, not
a shipped specialist. Gradle's project-inclusion is mechanically
different from local-path SPM and workspace packages, and the contract
must hold across all three.

### Layout

```
{code_root}/
├── settings.gradle.kts            # declares include(":app"), include(":canvas"), include(":shared")
├── app/
│   ├── build.gradle.kts           # implementation(project(":shared"))
│   └── src/main/                  # production code
├── canvas/                        # debug app target: previews + showcase screens
│   ├── build.gradle.kts           # implementation(project(":shared"))
│   └── src/main/
└── shared/                        # the SHARED module — Android library
    ├── build.gradle.kts           # plugin: com.android.library
    └── src/main/
        ├── kotlin/...             # components, tokens
        └── res/                   # resources (fonts, drawables, values)
```

### Sharing Mechanism

`shared/` is an Android library module declared in `settings.gradle.kts`
via `include(":shared")`. `app` and `canvas` each declare
`implementation(project(":shared"))` in their `build.gradle.kts`. Gradle's
build graph resolves the project edge; the library AAR is rebuilt on
change and consumed in place. The by-reference dependency is a project
coordinate, not a published version.

INCLUDED-BY-REFERENCE: a forked component in `canvas/` or `app/` violates
NO-FORK (R3). A published-artifact dependency on the shared library
(`implementation("com.org.shared:design-system:1.0.0")` instead of
`project(":shared")`) violates included-by-reference and is a FAIL.

### Resource Handling

Resources (fonts, drawables, colors, dimens) live in
`shared/src/main/res/`. Gradle's resource merger gives `app` and
`canvas` identical access at compile time. No per-target copies, no
asset duplication, no `assets/` workarounds. The merged resource ID
namespace is what both targets bind against.

### Scaffold Commands (illustrative)

```scaffold-commands
generate:    true
install:     ./gradlew :shared:assembleDebug
build:       ./gradlew :app:assembleDebug
test:        ./gradlew :app:testDebugUnitTest
prototype:   ./gradlew :canvas:installDebug
shared_test: ./gradlew :shared:testDebugUnitTest
```

**The invariant unchanged across all three instances.** Local-path
package (Swift), workspace package (web), and project-inclusion (Gradle)
are three mechanically different ways to express *the same* dependency
shape: one module, two consumers, no copies, no published versions. The
contract is one idea; the stack instances are three.
