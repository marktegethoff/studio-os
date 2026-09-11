# Changelog

## 1.6.0 — 2026-09-10

**The Artifact Standard: one page, fixes not sections.** A consuming project (Log•) produced two ~24 KB design/motion documents for a three-dot gutter glyph that contradicted each other on a deleted type and carried a wrong discriminator, while the ledger's 2–6 KB decisions never had the problem. Length was the exhaust of the review loop — each reviewer round added a section addressed to the next reviewer — and the documents ended up consistent with their reviewers and inconsistent with each other.

- **`CLAUDE.md` — Artifact Standard.** A design, motion, spec, or decision document is ≈60 lines: provenance · structure · states · what must not break · the device/acceptance check. Review rounds produce fixes, never sections. Cite, never restate. Verify every cited name against source. One document per subject. Wireframes only for what prose cannot carry.
- **`designer`:** one wireframe per surface (plus one per layout-changing transition), not one per state; verification performed, not narrated; alternatives get ≤5 lines; the challenge exchange stays in conversation and is never transcribed into the artifact; the artifact is one page.
- **`choreographer`:** a motion spec is one page — the per-motion block plus ≤10 lines of notes; mechanisms cited, never restated; reuse a token whose numbers are right; if the platform animates it (symbol replace, content transition), name the call and stop.
- **`specifier`:** complete is not long — every state named with its delta, values cited by token, citations verified.
- **`cd` / `de`:** "Fixes, not sections" — a required change edits a line, never adds a section; an artifact grown past a page through review is itself a REVISE finding.
- **Eval:** `design-agents.eval.md` Designer Eval 12 (One page) covers the standard on a Tier 3 prompt.

Graph-node compatibility: rules only — no frontmatter, artifact declarations, output-format blocks, or skill graph blocks changed; `lint-agnostic.sh` 0 FAIL.

## 1.5.2 — 2026-08-30

**The tier rule becomes enforceable.** 1.5.1 fixed the bare-path defect by hand; this release makes it structural, and in doing so found the half of the defect that 1.5.1 missed.

- **Lint R10** (`evals/lint-agnostic.sh`): every memory citation in `agents/` and `skills/` must name its tier — Core (the plugin's `memory/`), Product (`.claude/memory/`), or User (`~/.claude/memory/`). Lines carrying `.claude/memory/` are exempt: those are the deliberate fallback chains that degrade gracefully across project layouts.
- **13 violations R10 caught immediately.** The 1.5.1 pass qualified only the four Core files and left the Product tier bare — including the `design-preferences.md` and `design-references.md` citations in `cd`, `designer`, `scout`, `strategist` and `surveyor` that produced the original symptom. Also fixed: the surveyor's trend-file write path, the design-validator's design-system lookup, and `init`'s plugin-level `project-context.md` fallback.

**Release note.** `claude plugin update` keys on the version *number*, so content changed under an existing version never reaches the installed cache — the updater reports "already at the latest version" while serving the old copy. Any content change after a release needs a version bump, or an uninstall/reinstall, to propagate.

## 1.5.1 — 2026-08-30

**Memory citations name their tier.** A bare `memory/X.md` citation resolves only when the working directory is the plugin root — so it silently missed in every consuming project, and the plugin's own repo was the one place the defect was invisible. Found via a project whose `designer` had never written to `design-preferences.md`: the agent was not failing to write, it was aimed at a path the file has never occupied.

- **58 Core citations qualified** as `the plugin's memory/…` — `orchestration.md` (37), `apple-platform.md` (10), `anti-patterns.md` (10), `design-system.md` (1). Prose qualification over path syntax, generalizing the pattern `cd.md` already used: the reader is an LLM with search tools, and agents in particular have no anchor for a relative path, since their body is injected as a system prompt with no knowledge of its own file location.
- **Project-tier `design-foundations.md` renamed to `design-vocabulary.md`** at its three sites (`heurist`, `designer`, `cd`). One filename previously carried three meanings across three tiers — universal craft in the plugin, a home-tier copy, and the product's aesthetic registers in the project. The plugin's own prose already called the third "project aesthetic vocabulary"; the name now matches. Consuming projects rename their file to match.
- **CLAUDE.md Memory section** replaced with a three-tier table (Core / Product / User) and the governing rule: always name the tier, because the same filename can exist at more than one. It previously placed Core-tier `design-foundations.md` in the consuming project, contradicting line 9.
- **Seam fix**: `designer` and `heurist` described the project tier as holding an "instrument metaphor" — one consuming product's governing metaphor, named in a product-agnostic agent. Now "the product's governing metaphor", matching what `cd` already said. Present since `7d3e799`; invisible to R1, which greps for product *names* rather than concept leaks.
- **Left alone deliberately**: the `project-context.md` fallback chains (`.claude/memory/…; if not found, check memory/…; if absent, read CLAUDE.md`) are graceful degradation across project layouts, not strays; `evals/` lint matchers are substring-based and prefixing would break them.

## 1.5.0 — 2026-08-17

**Apple platform taste.** The studio's iOS judgment moves from lineage citations to operational doctrine, mirroring the stack seam that already works: one dated platform contract on the design side, deepened code doctrine behind the `stack:` seam, and evals that test both.

- **`memory/apple-platform.md`** (new): the Apple platform contract, versioned "as of iOS 26" and owned by the surveyor's sweep — platform-first principle (the tenant's language is developed within the platform's; departures are named decisions), navigation contract (a push is a place, a sheet is a task, a tab is a mode, detents are task weight), reserved gestures, layered-glass materials, the spring motion ladder with spatial/non-spatial doctrine, haptics & sound discipline (earned by mechanism, weight-paired to motion), SF Pro/Dynamic Type, semantic color, SF Symbols, earned platform surfaces (widget/Live Activity/App Intent tests), arrival craft (value before demand, permission sequencing, paywall honesty, review readiness), and a single API-bridge section mapping design vocabulary to Swift.
- **Design agents go platform-aware**, each citing the contract from its own discipline: heurist's Layer 2 is now an enumerated checklist (it was a four-sentence stub); the materialist starts from the platform's material system and evaluates tenant language as a named decision (its previous doctrine was silently opposed to Liquid Glass); the choreographer's specs are spring-shaped (response/damping) with spatial class and owned haptic pairing; the typesetter gains the system face and Dynamic Type survival; accessibility gains traits/rotor/custom actions, AX-size checks, Voice Control, and Inspector-verified audits; the designer treats container choice as navigation semantics; the marketer gains the earned-surface test and arrival/paywall honesty; the writer owns App Store copy and permission strings; the surveyor owns the contract's dated header.
- **`swift-engineer` platform doctrine** (versioned): `@Observable`-default state with ownership rules, navigation as state with deep links as restoration, a persistence decision rule, structured concurrency stances, a performance method (identity first, body cost, Instruments, spec-able budgets incl. the 8ms ProMotion frame), and a named snapshot toolchain (swift-snapshot-testing, pinned-simulator recording, `__Snapshots__` PNGs as the review-artifact paths `implement` promises).
- **Specialist template** gains a Platform doctrine section — every future stack specialist is prompted for state/navigation/persistence/concurrency doctrine, performance method, verification artifacts, and token bridging, not just scaffold wiring.
- **Evals**: `swift-engineer` gets behavioral evals of its own (main-actor boundary, state doctrine, resource/snapshot discipline — closing the family-discipline exemption); new platform-taste evals for heurist Layer 2, materialist platform-first, accessibility traits, choreographer spring specs, typesetter Dynamic Type.
- **`patterns/` — the solved-problems library** (new top-level, the code-side sibling of `artifacts/`): canonical, citable solutions with provenance so agents follow platform standards instead of re-deriving them. Seeded with eight Swift patterns — `liquid-glass-chrome` (what gets glass free, when custom chrome earns `glassEffect`, what never does), `sheet-with-detents`, `navigation-stack-path`, `observable-model`, `list-row-actions`, `dynamic-type-layout`, `commit-feedback`, `empty-state` — each a compilable snippet + the standard it follows + a `Verified:` date. Wired in: swift-engineer's consult-before-solving rule ("a re-solved solved problem is a defect"), `implement`'s specialist step, the surveyor's harvest/re-verify duty, the specialist template's pattern-library dimension, and lint R9 (entry structure).
- **Hygiene**: five stale "iOS Engineer" references fixed; `stack-tokens.allow` extended (which exposed and fixed GRDB seam leaks in architect/luck); `memory/design-system.md` gains platform units (pt), SF Symbols sourcing, and the missing Motion token section; the reference palette gains mechanism notes on its iOS rows and dated-entry convention.

## 1.4.0 — 2026-08-16

**Graph engineering.** Multi-agent workflows are now declared execution graphs, not prose conventions. The implicit topologies that already existed — critique's 9-wide fan-out, design's craft sub-team, solve's 3-iteration convergence — are transcribed into one canonical, lint-validated contract per skill, then mechanized.

- **Orchestration doctrine**: `memory/orchestration.md` (Core tier) — graph grammar (6 node types, 4 edge forms), human-node economics, adversarial doctrine, run-state node ledger, spend doctrine, executor/segment convention, and the Auto-Mode Safety Contract as the single source of truth (deduplicated from 16 skills to a 3-line stub each, ~430 lines removed).
- **8 graph-declaring skills**: critique, review, design, ideate, solve, handoff, prototype, discover each carry one ` ```graph ` block (the contract) plus a `workflow.js` executor mirroring it — deterministic fan-outs, joins, bounded loops, and structured-output gate verdicts where the Workflow tool exists; the prose path everywhere else. Skills that are linear or interview-driven stay graph-free by design.
- **Lint rules R7/R7.b/R7.c/R8** (`evals/lint-agnostic.sh`): graph-block validity (agents resolve, edges reference declared nodes, every loop bounded, fan-out members independent, every human node carries `decides:`), Six Functions coverage over artifact-producing graphs (driven by `evals/six-functions.map`) including a mandatory slop-gate node, executor conformance, and auto-contract stub presence.
- **Human judgment repositioned**: ~76 PAUSE blocks audited. Workflow pauses drop to 15 across the 8 graph skills — each surviving pause is a real decision (direction selection, spend, irreversibility boundary, contested gate) with a lintable `decides:` annotation; progress reports became status lines. Interview skills keep their conversational pauses.
- **Adversarial upgrades (anti-slop, structural)**: blind fan-outs (members never see each other's unfinished output); preserved dissent at joins with a dissent ledger in verdict artifacts (new anti-pattern: **Consensus Laundering**); a bounded refutation edge on every SHIP/INEVITABLE verdict (critic refutes CD, qa refutes DE — at most once, cannot stall shipping); the `/studio:studio-slop` seven markers as a gate node before emission in every artifact-producing graph. Ideate gains the CD ship gate and handoff gains the critic reduction pass — both closing real Six Functions gaps.
- **Retirements (27 → 23 active skills, deprecate → archive next release)**: `simulate` retired (job → `/studio:experiment` + assumption-mapper); `luck` skill folded into the `luck` agent; `annotate` + `gather-feedback` merged into **`/studio:feedback`** (`--overlay` / `--surface`); `scope` merged into **`/studio:shape --task`**. All carry deprecation redirects in the router; nothing hard-deleted.
- **Evals**: graph-conformance criteria for all 8 graph skills, new feedback/shape-task/refutation/dissent evals, coverage table reconciled (35 agents + 28 skills incl. 5 deprecated).

## 1.3.0 — 2026-05-27

- **`/studio:organize` skill:** scaffold and reconcile the canonical project layout. Scaffold mode creates `decisions/`, `specs/`, `design/`, `reviews/` and writes a decision record. Reconcile mode scans, classifies, and proposes artifact moves — proposes only in `--auto` mode, never executes unattended.
- **Anti-pattern catalog:** `memory/anti-patterns.md` — 10 named failure modes (Feature Accumulation, Settings Dumping, Dashboard Creep, Decoration Compensation, Modal Inflation, Empty State Neglect, Premature Skin, Explanation as Compensation, Navigation Debt, AI Attribution Collapse). `critic`, `cd`, and `studio-slop` updated to load and cite catalog entries by name.
- **Skill description trim:** all 26 skill `description` fields trimmed to ≤150 chars. Reduces Claude Code skill-listing budget consumption by ~57%.

## 1.2.0 — 2026-05-26

**HTML-first artifact delivery.** Every artifact-producing skill now writes a designed HTML file to disk rather than emitting markdown prose in conversation. Artifacts are first-class reviewable objects: named, pathed, and offered to the annotation chain immediately.

- **10 skills emit HTML artifacts**: shape, scope, discover, design, critique, review, measure, ideate, handoff, experiment — each mapped to a specific kit template and disk path. A `--text` flag is available on all ten to skip emission and return a markdown summary only.
- **5 new kit templates**: `critique-report.html`, `lt-review.html`, `task-brief.html`, `ideation-output.html`, `experiment-plan.html` — added to `artifacts/templates/` and catalogued in `artifacts/kit/README.md`.
- **R6 lint rule**: Every agent or skill file with an `artifact:` frontmatter key must reference its named template in the body. Enforced by `evals/lint-agnostic.sh`.
- **Template proposal mechanism**: Agent-proposed templates land in `artifacts/proposals/<slug>.md` pending human approval; the no-fit procedure and reuse-first discipline are documented in the kit README.
- **12 agents gain `## Artifact` sections**: journey-mapper, designer, user-researcher, writer, architect, brief-writer, metrics-definer, assumption-mapper, specifier, choreographer, competitive-analyst, heurist — each declares its template and disk path.
- **Auto mode (`--auto`)**: All 15 PAUSE-containing skills gain `## Auto Mode` sections with a 6-point safety contract. All PAUSEs are marked `(skipped in --auto)` and carry a checkpoint name.
- **Model-switch cleanup**: Removed `**Model requirements:**` lines and `[HAIKU]/[SONNET]/[OPUS]` section-header prefixes from 7 skills. The `implement` skill retains `[Det]`/`[Ag]` structural tags.
- **Eval coverage extended**: All five agent eval files gain artifact production eval entries (discovery-agents E6, design-agents E9, analysis-agents E5, engineering-agents E7, surface-agents E10). All 10 Phase B skills gain HTML artifact production criteria in `evals/skills.eval.md`.

## 1.1.1 — 2026-05-26

First full eval suite run (Backlog #2). Fixed every issue surfaced:

- **`cd`** — added Scope rule: engineering/implementation questions are routed to the Engineer, not verdicted.
- **`historian`** — added user-stated scope exclusion rule: excluded material is honored, never folded in as context.
- **`surveyor`** — added Unsourced Finding Named Ban: every finding requires a source; unsourced findings are dropped.
- **`typesetter`** — added Raw Value Slip Named Ban; output template now models token-name syntax.
- **`simplify` skill** — removed "iOS Engineer" stack-token; now routes to the project's declared specialist.
- **`annotate` skill** — added routing note: non-HTML artifacts use `gather-feedback` instead.
- **`surface-agents.eval.md`** — added eval scenarios for `accessibility` (WCAG AA violations) and `design-validator` (token mismatch), closing two coverage-rule gaps. Updated Systematist eval criterion to match agent's governance stance. Renumbered evals 7–9.

Full suite report: `evals/suite-run-2026-05-26.md`.

## 1.1.0 — 2026-05-26

- **Paired-scaffold capability.** `/studio:init` now scaffolds production
  + canvas + a shared module that both depend on by reference. Two
  invariants are enforced by a new structural lint: **INCLUDED-BY-REFERENCE**
  (the shared module is never copied or published) and **NO-FORK** (a
  component lives once).
- **Structural lint.** `evals/lint-agnostic.sh` — five rules (R1–R5) +
  the included-by-reference check. Bash 3.2-compatible; runs on stock
  macOS. Plugin-internal mode (R1, R2, R4, R5) plus `--project <path>`
  mode (R3, IBR) for consuming projects.
- **`swift-engineer`** replaces `ios-engineer`. One specialist covers
  every Apple platform — iOS, macOS, watchOS, tvOS, visionOS — via a
  `platform` manifest key, not separate agent variants.
- **`web-engineer` promoted** from a 4 KB stub to a full specialist with
  the same Scaffold Blueprint contract (Layout · Sharing Mechanism ·
  Resource Handling · Scaffold Commands).
- **Templates gain an Android worked example** as the third instance of
  INCLUDED-BY-REFERENCE (Gradle project-inclusion), proving the
  invariant holds unchanged across a mechanically different stack.
- **Init Phase 5** — six-step scaffold execution flow. On-demand engineer-
  specialist generation is a first-class moment, not a fallback: the
  marketplace itself becomes the validation pipeline.
- **35 agents** (was 33). De-contamination pass removed every
  product-token leak the new lint surfaces; the seam between Core/Role
  and Product holds.
- **First semver-tagged release.** Tagged `v1.1.0` per the new release
  discipline; consumers get the update via `claude plugin update`.

Validated against the Log project per the spec's reconciliation
sequence — production keeps its historical pixels exactly; canvas
renders identically to production for the first time.

## 1.0.x — 2026-04-16 to 2026-05-25

Initial public releases. Three-tier architecture (Core / Role / Product),
33 discipline agents, foundational workflow skills, designed-HTML artifact
kit with built-in feedback harness. Tagged under the prior
`studio--v1.0.1` convention.
