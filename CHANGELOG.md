# Changelog

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
