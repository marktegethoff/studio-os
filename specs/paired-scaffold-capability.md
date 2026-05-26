# Paired-Scaffold Capability — Engineering Spec

**Owner:** specifier
**References:** [`../design/paired-scaffold-capability.md`](../design/paired-scaffold-capability.md) (design, gate-cleared)
**Status:** Implementation-ready. Out-of-scope items listed in §J.
**Date:** 2026-05-26

This document encodes the design into the schemas, anchors, rule definitions, and execution sequences required to build the capability. The five spec-level refinements DE flagged at re-review are folded into the relevant sections (§A, §B, §C, §D, §E).

---

## A · Manifest schema

The manifest is written by `init` to `project-context.md` under a top-level heading `## Engineering Context`. Format: YAML inside a fenced ` ```yaml ` block, or front-matter-style key/value lines — implementer's choice, parsed identically by skills.

### Contract block (every skill reads; missing key = error → "run `/studio:init --update`")

```yaml
stack: <string>
  # Canonical identifier. Built-in: "swift" | "web" | "android" | "react-native" | "flutter".
  # Custom values valid only if a matching specialist exists in agents/<value>-engineer.md.

code_root: <path>
  # Repo-relative path to the code root. Default: "code/".

shared_module_name: <string>
  # The IMPORT name (e.g. "AppDesignSystem", "@project/design-system").
  # Package name is DERIVED:
  #   - Swift:  identical to import name.
  #   - Web:    identical to import name (npm package names ARE the import string).
  #   - Android: lower_snake_case of import name.

sharing_mechanism: <enum>
  # "spm-local" | "pnpm-workspace" | "npm-workspace" | "yarn-workspace" | "gradle-project"

platform: <enum>
  # Apple stacks only. "ios" | "macos" | "multiplatform"

package_manager: <enum>
  # Web stacks only. "pnpm" | "npm" | "yarn"

canvas_framework: <enum>
  # Web stacks only. "storybook" | "ladle"

spec_path: <path>     # default: "specs/"
decisions_path: <path> # default: "decisions/"
```

### Scaffold block (one-time state)

```yaml
scaffold_state: <enum>
  # "none"     — pre-init; no scaffold exists.
  # "manual"   — escape-hatch path: scaffold exists; SHARED dependency wired by hand; no project.yml.
  #              Invariants (R3, included-by-reference) STILL enforced against hand-authored wiring.
  # "complete" — generated path: project.yml is the source; verify-build passed.

generation_tool: <enum>
  # "xcodegen" — default for Swift; project.yml is source, .xcodeproj is generated.
  # "none"     — manual path OR non-Swift stack.
  # NOTE: "none" disables the *generator-spec* checks (no project.yml lint),
  #       NOT the *by-reference* invariant check, which runs regardless.
```

### Derived (never stored, computed at use)

- `app_path` = `{code_root}/app`
- `canvas_path` = `{code_root}/canvas` (omit when shape = app-only)
- `shared_path` = `{code_root}/shared` (omit when shape = app-only or shape = collapse)
- Commands: read from the specialist's `Scaffold Commands` anchor (§B), parameterized by derived paths + `shared_module_name`.

---

## B · Specialist `Scaffold Commands` anchor contract

Each engineer specialist file MUST contain exactly one fenced block matching the anchor contract below. This is the single source for that stack's commands; skills parse it, never grep the surrounding prose.

````markdown
## Scaffold Blueprint (<stack>)

### Layout

<directory tree showing app / canvas / shared and their contents for this stack>

### Sharing Mechanism

<one paragraph: what SHARED is for this stack; the by-reference edge; how PRODUCTION and CANVAS each include it; why this prevents forks>

### Resource Handling

<one paragraph: where assets live in SHARED; how both targets access them identically; e.g. Bundle.module for Swift, package exports for web>

### Scaffold Commands

```scaffold-commands
generate:    <command>           # produce the project artifact (e.g. `xcodegen generate`); no-op for web
install:     <command>           # wire the by-reference dep (e.g. `xcodegen generate`, `pnpm install`)
build:       <command>           # PRODUCTION build
test:        <command>           # PRODUCTION tests
prototype:   <command>           # launch CANVAS (e.g. `open <canvas>.xcodeproj`, `pnpm --filter canvas dev`)
shared_test: <command>           # test SHARED in isolation
```
````

**Parse contract:**

- The fenced block uses the language tag `scaffold-commands`.
- Each line is `<key>:` followed by whitespace and the command string. Lines may use `\` continuations.
- Keys are an enum: `generate`, `install`, `build`, `test`, `prototype`, `shared_test`. Absent key = command not supported for that shape (e.g. `prototype` omitted in app-only).
- Curly-brace placeholders are substituted at use: `{code_root}`, `{app_path}`, `{canvas_path}`, `{shared_path}`, `{shared_module_name}`, `{platform}`, `{package_manager}`, `{canvas_framework}`.

**Lint enforcement** (R5 in §C): the specialist file MUST contain exactly one `scaffold-commands` block; absent / duplicate / malformed = FAIL.

---

## C · Lint rules

`evals/lint-agnostic.sh`, invoked by the eval-suite runner per the coverage rule. Five rules, in order; all rules run on every invocation.

### R1 — Product-name grep

- **Scope:** `agents/**` + `skills/**` (plugin engine only).
- **Deny list:** maintained at `evals/product-tokens.deny`, append-on-onboarding. Seed values: `Log`, `Log Canvas`, `LogApp`, `studio_os/`.
- **Match:** plain-text substring; case-sensitive.
- **Verdict:** **FAIL** on any match. Report file:line of the match.

### R2 — Stack-token placement by frontmatter (bidirectional)

- **Scope:** `agents/**` + `skills/**`.
- **Allow list:** maintained at `evals/stack-tokens.allow`, keyed by stack tag.
  - `swift`: `SwiftUI`, `xcodebuild`, `swift build`, `SPM`, `Bundle.module`, `xcodeproj`, `UIKit`, `AppKit`, `XcodeGen`, `Package.swift`
  - `web`: `React`, `Next.js`, `pnpm`, `npm`, `Storybook`, `Ladle`, `TypeScript`, `DOM`, `package.json`, `tsconfig`
  - (Future stacks add their own keyed list when their specialist ships.)
- **Rule:**
  - A file with `stack: <X>` in YAML frontmatter MAY contain tokens from the `X` allow-list.
  - A file with no `stack:` frontmatter MUST NOT contain any token from any stack allow-list.
  - A file with `stack: X` MUST NOT contain tokens from a *different* stack's allow-list (cross-stack contamination).
- **Scope precision** *(DE re-review catch #3 — prose only, not code or quoted output):*
  - Before grep, strip ` ``` ... ``` ` fenced code blocks.
  - Strip lines beginning with `> ` (quoted output).
  - Strip inline backtick spans `` `…` `` (code references).
  - Remaining text is the lint surface.
- **Verdict:** **FAIL** on violation. Report the offending token + file:line + the rule limb violated.

### R3 — No-fork / drift check

- **Scope:** invoked against a consuming project's `{canvas_path}` and `{shared_path}` (read from manifest). Implementation note: R3 is a *project-level* check; the suite runner invokes it during a project-aware run (e.g. as part of the Log reconciliation validation in §H).
- **Checks:**
  - **Content duplication.** For each `.swift` / `.ts` / `.tsx` / `.kt` file at `{canvas_path}`, compute a content hash with imports stripped and whitespace normalized; if any file at `{shared_path}` produces the same hash, FAIL with both paths.
  - **`#filePath` resource loading.** When `sharing_mechanism: spm-local`, FAIL on any occurrence of `#filePath` used to resolve resources outside `Bundle.module` (regex: `#filePath` token appearing within 200 chars of a font / resource API call — `CTFontManagerRegisterFontsForURL`, `UIImage(contentsOfFile:)`, etc.).
- **Runs regardless of `scaffold_state`.** Manual path forgoes generation, not enforcement *(DE re-review catch #1)*.
- **Verdict:** **FAIL** on match.

### R4 — Skills do not hardcode paths

- **Scope:** `skills/**`.
- **Rule:** literal file paths (matching `(\.{0,2}/)?[a-zA-Z0-9_-]+(/[a-zA-Z0-9_-]+)+` outside fenced code) that are not formatted as manifest-key references `{code_root}`, `{app_path}`, `{shared_path}`, `{shared_module_name}`, etc., are suspect.
- **Exemptions:** paths referencing plugin-internal structure (e.g. `skills/<other-skill>/SKILL.md`) are allowed. Paths under `evals/`, `templates/`, `memory/` referenced by the skill itself are allowed.
- **Product-name paths** (any literal path containing a denied product token from R1) escalate to FAIL via R1.
- **Verdict:** **WARN** on bare literal paths (not exempt, not product-tokened). Tracked for cleanup; does not block.

### R5 — Specialist `Scaffold Commands` anchor present

- **Scope:** `agents/*-engineer.md` (any file matching the engineer-family suffix).
- **Rule:** the file MUST contain exactly one fenced block with language tag `scaffold-commands`. The block MUST parse per §B (key/value lines, enumerated keys). Required keys: `generate`, `install`, `build`, `test` (omissions allowed only for unsupported shapes — `prototype` and `shared_test` may be absent in stacks where they don't apply).
- **Verdict:** **FAIL** on absent / duplicate / malformed.

### Included-by-reference enforcement

The invariant the design exists to protect — runs as a project-level check, **regardless of `scaffold_state`** *(DE re-review catch #4)*:

- `sharing_mechanism: spm-local` + `generation_tool: xcodegen`: parse `project.yml` for `app` and `canvas`; FAIL if the `../shared` package dependency is absent OR expressed as a registry URL.
- `sharing_mechanism: spm-local` + `generation_tool: none` (manual): parse `.pbxproj` for an `XCLocalSwiftPackageReference` pointing at `../shared`; FAIL if absent or if a registry-based `XCRemoteSwiftPackageReference` is used instead.
- `sharing_mechanism: pnpm-workspace` (and `npm-workspace` / `yarn-workspace`): parse root `package.json` for `workspaces` containing `shared` AND `app` / `canvas`; parse `app/package.json` + `canvas/package.json` for the workspace package dependency declared via `*` or `workspace:*`; FAIL on a registry version specifier (`^x.y.z`).
- `sharing_mechanism: gradle-project` *(future)*: parse `settings.gradle` for `include(":shared")` and the module's `build.gradle` for `implementation(project(":shared"))`; FAIL on a published-artifact dependency.

---

## D · `scaffold_state` semantics + transitions

**States:**

- `none` — pre-init; no scaffold exists yet.
- `manual` — escape-hatch path: scaffold exists; SHARED dependency was wired by hand; no `project.yml`. Invariants (R3 + included-by-reference) still enforced against the hand-authored wiring.
- `complete` — generated path: scaffold exists; `project.yml` is the declarative source; init Step 6 verify-build has passed.

**Transitions** (`init` writes; `init --update` mutates):

- `none → manual` — user selected the escape hatch in init Step 4.
- `none → complete` — generated path, verify-build passed.
- `manual → complete` — `/studio:init --update --generator=xcodegen` runs the generation conversion: write `project.yml` (deriving the dependency declaration from the hand-authored `.pbxproj`), regenerate `.xcodeproj`, verify-build, update state.

**Not supported:**

- `complete → manual` — once on the generated path, regressing to manual is not encoded.
- `complete → none` — uninstall flow is out of scope here.

---

## E · Shape transitions

**Shapes:** `app-only` · `collapse` · `triple`.

**Supported promotions** via `/studio:init --update`:

- `app-only → collapse` — add canvas. Creates `code/canvas`, wires it, writes `canvas_path` derivation context.
- `app-only → triple` — add canvas + shared. Creates both, wires both, writes `shared_*` keys.
- `collapse → triple` — add shared. Creates `code/shared`; offers to move any front-end primitives currently in `app` to `shared` (with explicit per-file confirmation); wires both dependencies.

**Not supported:** demotion (`triple → collapse`, `triple → app-only`, etc.). Demotion is a discipline question, not a scaffold question; init does not encode it.

---

## F · `init` skill changes

`skills/init/SKILL.md` gains a new top-level section: `## Scaffold Execution`, placed after the existing Phase D personalization. The six steps from design §5 map to:

```
init.scaffold:
  step 0  pre-flight
            Check project-context.md ## Engineering Context for `scaffold_state`.
            If present, surface existing rather than re-run; offer --update mode.
  step 1  declare stack
            Ask: "What is the primary platform and stack for this project?"
            Match the answer to `agents/<answer>-engineer.md`.
            If no specialist exists, offer:
              "I'll generate a specialist for <stack> from the template now."
            Generate from templates/engineer-specialist.template.md and continue.
  step 2  declare shape
            Ask: "Does this project have a shared front-end module that spans
                  multiple surfaces? Will you prototype this in a canvas?"
            Map to triple / collapse / app-only.
            If triple, in the same exchange:
              "What is the shared module's import name (e.g. AppDesignSystem,
               @project/design-system)?"
  step 3  create + initialize
            Create code/app, code/canvas (if not app-only), code/shared (if triple).
            Initialize the shared module per the specialist blueprint:
              Swift: write code/shared/Package.swift declaring the library target.
              Web:   write code/shared/package.json + code/package.json with workspaces.
  step 4  wire by-reference dep
            Web:   `pnpm install` from code/; symlinks complete the wiring.
            Swift: default — write project.yml for app + canvas with the local
                   `../shared` package declaration, then `xcodegen generate`.
                   Escape hatch — set scaffold_state: manual, generation_tool: none,
                   and emit:
                     "Add a local Swift Package dependency on ../shared to:
                       1. code/app/<App>.xcodeproj
                       2. code/canvas/<App>Canvas.xcodeproj
                     Reply 'done' when the dependency is in place."
                   On reply, re-run verify-build (Step 6).
  step 5  write manifest
            Write the contract block + scaffold block (§A) to
            project-context.md under ## Engineering Context.
            Set scaffold_state per the path taken in Step 4
            ("complete" only after Step 6 passes; otherwise "manual" or remain "none").
  step 6  verify
            Web:   `pnpm --filter canvas dev` resolves the shared import; `pnpm --filter app build` exits 0.
            Swift: `swift build --package-path code/shared` exits 0;
                   `xcodebuild -project ... build` for app exits 0.
            On success: flip scaffold_state → complete.
            On failure: report the failing step, leave scaffold_state at its prior value,
                        do not silently mark complete.
```

`/studio:init --update` mode covers shape promotion (§E) and `manual → complete` conversion (§D). It re-runs Step 5 (manifest update) and Step 6 (verify-build) at the end.

---

## G · XcodeGen integration (Swift default path)

`project.yml` is the declarative source; `.xcodeproj` is generated and gitignored.

**Schema** (per Xcode project — `app` and `canvas` each have one):

```yaml
name: AppName
options:
  bundleIdPrefix: <derived from project>
settings:
  base:
    SWIFT_VERSION: "5"
targets:
  AppName:
    type: application
    platform: ios   # from manifest.platform; "macos" for macOS, "macOS iOS" for multiplatform
    deploymentTarget: <derived per platform>
    sources: [Sources]
    dependencies:
      - package: AppDesignSystem   # ← shared_module_name
packages:
  AppDesignSystem:
    path: ../shared                # ← the BY-REFERENCE dependency the lint enforces
```

**`init` invocation:**

- Step 4 writes `code/app/project.yml` + `code/canvas/project.yml` per the schema above (templated from the specialist blueprint).
- Step 4 then invokes `xcodegen generate` in each project directory.
- The included-by-reference check (in §C) parses `project.yml` for the `path:` value under `packages:` and FAILS on any registry URL (`url:`).

**`.gitignore` additions** (init writes):

```
*.xcodeproj
```

(Limited to the `code/app/` and `code/canvas/` paths via a leading directory anchor in practice; the exact stanza is in the specialist's Resource Handling section.)

**XcodeGen as a dev dependency:** init records `xcodegen` as required tooling in a project README section (or a `tools.txt` per project convention) — *not* in the manifest. The manifest records the *choice* (`generation_tool: xcodegen`); the install of the tool is the project's responsibility.

---

## H · Log reconciliation sequence (the validation run)

This is the first proof obligation. The capability is not validated until this sequence completes and the eval suite passes against Log.

**Ordered migration steps:**

1. **Restructure `design-system/`:**
   - HTML documentation site → `design/` (the canonical flat-layout home for design artifacts in a consuming project).
   - `design-system/` becomes the SHARED Swift Package root.
   - Write `design-system/Package.swift` declaring an `AppDesignSystem` library target with resources at `Sources/AppDesignSystem/Resources/`.

2. **Move sources into the package:**
   - Move font files into `design-system/Sources/AppDesignSystem/Resources/Fonts/`.
   - Move token definitions into `design-system/Sources/AppDesignSystem/Tokens/`.
   - Move reusable components currently shared by both targets into `design-system/Sources/AppDesignSystem/Components/`.

3. **Replace the production tokens fork:**
   - Delete `Log/Log/Utilities/DesignTokens.swift`.
   - Replace each usage with `import AppDesignSystem`.

4. **Replace the canvas tokens fork (the diagnosed violation):**
   - Delete `Log Canvas/Log Canvas/DesignSystem/DesignTokens.swift` (the file with `// Synced: 2026-04-26 from Log/Log/Utilities/DesignTokens.swift`).
   - Replace each usage with `import AppDesignSystem`.

5. **Replace the `#filePath` font loader:**
   - Delete `Log Canvas/Log Canvas/DesignSystem/CanvasFonts.swift`.
   - Add a `Fonts.register()` entry point in the SHARED package that uses `Bundle.module` exclusively.
   - Both `Log/Log/LogApp.swift` and `Log Canvas/Log Canvas/Log_CanvasApp.swift` call `Fonts.register()` at app launch.

6. **Write `project.yml` for both Xcode projects:**
   - `Log/project.yml` (or `code/app/project.yml` if the layout is also migrated) declaring the `../design-system` package and the `AppDesignSystem` dependency on the `Log` target.
   - `Log Canvas/project.yml` declaring the same package and dependency on the `Log Canvas` target.

7. **Adopt XcodeGen as dev tooling:**
   - Install via `brew install xcodegen` (recorded in the repo README).
   - Run `xcodegen generate` in both project directories.

8. **`.gitignore` updates:**
   - `Log.xcodeproj/` and `Log Canvas.xcodeproj/` added to `.gitignore`.
   - `project.yml`, `Package.swift`, and `design-system/Sources/**` committed.

9. **Build verification:**
   - `swift build --package-path design-system` exits 0.
   - `xcodebuild -project Log.xcodeproj -scheme Log build` exits 0.
   - `xcodebuild -project "Log Canvas.xcodeproj" -scheme "Log Canvas" build` exits 0.
   - Existing snapshot test suite passes (regression check on the tokens migration).

10. **Manifest write:**
    - `LogApp/.claude/memory/project-context.md` gains `## Engineering Context` with:
      ```yaml
      stack: swift
      platform: ios
      code_root: .                  # Log's code is at repo root; non-canonical layout
      shared_module_name: AppDesignSystem
      sharing_mechanism: spm-local
      generation_tool: xcodegen
      scaffold_state: complete
      spec_path: specs/             # or the project's existing equivalent
      decisions_path: decisions/
      ```
    - Note the `code_root: .` divergence: Log predates the canonical `code/` root. Either: (a) accept the legacy layout and let the manifest declare it (the manifest is the source of truth — this is fine); (b) defer code-root migration to a separate cleanup. **Recommend (a)** — the manifest already accommodates this; no need to move source.

11. **Run the eval suite against Log:**
    - R1 (product names) — N/A for the consuming project, but ensures no cross-contamination.
    - R3 (no-fork) — must report no canvas↔shared duplicates and no `#filePath` resource loading. Pass = validation closed.
    - Included-by-reference — must report `../design-system` as a path-based dependency in both `project.yml` files.

**Estimated scope:** ~3 dozen files touched + one team-wide tooling change (XcodeGen install). Bounded and one-time. If the migration surfaces any invariant the contract cannot express, treat it as feedback into the contract — do not patch around in Log *(DE re-review risk note)*.

---

## I · Accessibility / VoiceOver / Motion

**N/A.** This is infrastructure (`init` skill, specialist agents, lint, manifest schema). No UI, no user-visible strings beyond CLI prompts.

CLI prompt principles (Heurist's developer-UX lens, applied):

- Every prompt declares its default in `[brackets]`.
- Ambiguous answers are re-asked, not silently coerced.
- Generation steps that take >2 seconds emit a single progress line.
- Failures surface the failing command + file:line + a recovery instruction (`/studio:init --update`).
- No silent fallbacks — when `init` cannot find a specialist for the declared stack, it announces "I'll generate one from the template" before proceeding.

---

## J · Out of scope (carried to `/implement`)

This spec defines WHAT. The implementation tasks the eventual `/studio:implement` pass executes:

- **Build `evals/lint-agnostic.sh`** per §C. Includes seeding `evals/product-tokens.deny` and `evals/stack-tokens.allow`.
- **Write `swift-engineer.md`** per §B's anchor contract. Promotes the Log canvas methodology (canvas-from-real-components, Experiments/Archive structure, snapshot testing convention) — de-Logged ("for any Swift project") — into the specialist body. Replaces `agents/ios-engineer.md`.
- **Write `web-engineer.md`** per §B's anchor contract. The current 4.1 KB stub becomes a complete specialist. **Validate via one end-to-end web scaffold run before public launch (launch-blocking).**
- **Update `skills/init/SKILL.md`** per §F.
- **Update `templates/engineer-specialist.template.md`** per §B + the Android worked example (Gradle project-inclusion as the third sharing-mechanism instance).
- **Execute the Log reconciliation** per §H.
- **Run the eval suite end-to-end** per backlog item #2 (existing TODO; this design lands the lint half of it).
- **Rename `agents/ios-engineer.md` → `agents/swift-engineer.md`** and update STRUCTURE.md's roster table.
- **Surface on-demand specialist generation as a visible, first-class `init` moment** — copy in init Step 1 must communicate it as capability, not fallback.

---

## Cross-references

- Design: [`../design/paired-scaffold-capability.md`](../design/paired-scaffold-capability.md)
- Plugin structure: [`../STRUCTURE.md`](../STRUCTURE.md)
- Backlog: [`../BACKLOG.md`](../BACKLOG.md) — items #1, #2, #11 land via this work
