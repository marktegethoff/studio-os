# Changelog

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
