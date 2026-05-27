# The Artifact Kit

Every studio artifact is a **well-designed HTML document in the studio visual language, with a built-in review harness.** Not raw markdown, not a wall of text — a designed page the human can read, mark up, and return as agent-friendly feedback in one paste. This kit is what every artifact inherits, so no agent restyles from scratch.

## Two parts

1. **`studio.css`** — the shared stylesheet, carrying the **Standard Works identity** (the studio's own brand — not any product's): Neue Haas Grotesk (refined grotesk sans) via Typekit with a Helvetica Neue fallback, black on warm white, Courier for technical labels, monochrome with at most a single earned accent (`--accent`), generous margins, no decoration. Source of truth: `~/Standard Works/Apps/Standard-Works/brand-system.html`. A *product* that needs its artifacts themed to its own brand overrides `--accent`/fonts; by default everything carries Standard Works. Link it; don't reinvent it.
2. **The annotation harness** — the click-to-annotate overlay from the `annotate` skill. It injects a review bar, click-to-pin comments, brief-derived questions, a disposition (Approve/Revise/Reject), and a copy-to-Claude output block. Run `/annotate <artifact>.html` (optionally `--brief <brief>`) to attach it. The source artifact is never modified — `annotate` writes `<name>.annotated.html`.

## Building an artifact

```html
<!DOCTYPE html><html lang="en"><head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Artifact] — [subject]</title>
  <link rel="stylesheet" href="../kit/studio.css">
  <!-- optional: a studio/product brand override (fonts + --accent/palette), captured at /studio:init Step D -->
  <!-- <link rel="stylesheet" href="../../.claude/memory/brand.css"> -->
</head><body>
  <div class="wrap">
    <header class="header">
      <span class="eyebrow">Studio OS · [artifact type]</span>
      <h1>[Title]<span style="color:var(--accent)">.</span></h1>
      <p class="header-sub">[one-line framing]</p>
    </header>
    <!-- sections using .section / .callout / .itemlist / .dcard / .tier / table / pre.ascii -->
  </div>
</body></html>
```

Use the component classes from `studio.css` (`.callout`, `.itemlist`/`.item`, `.dcard`, `.tier`, `.compare`, `table`, `pre.ascii`, `.tag`, `.pill`). ASCII wireframes go in `pre.ascii` — styled and monospaced, never raw.

## The artifact catalog

Templates live in `artifacts/templates/`. Each is owned by the agent that produces it.

| Artifact | Owner | Gates / feeds |
|---|---|---|
| User journey | journey-mapper | constrains Designer scope |
| ASCII wireframe | designer | structure before code |
| User narrative | user-researcher / writer | pairs with the Scene Test |
| Flow diagram | architect / designer | states + transitions |
| Design brief | brief-writer | **gates `/design`** |
| Metrics plan | metrics-definer | committed with the spec |
| Risk register | assumption-mapper | names the binding assumption |
| Component spec sheet | specifier | removes implementation guessing |
| State inventory | designer / specifier | prevents happy-path-only specs |
| Motion spec | choreographer | timing/easing + reduce-motion |
| Copy deck | writer | all strings, reviewable as language |
| Competitive teardown | competitive-analyst | read before a brief |
| Heuristic report | heurist | P0–P3 findings |
| Decision record | architect / any | an HTML view over a ledger entry |
| Critique report | cd | nine-discipline findings; triage |
| Leadership review | pm / cd / de | **gates ship / merge** |
| Task brief | pm / architect | **gates `/implement`** |
| Ideation output | strategist / designer | feeds `/shape` brief |
| Experiment plan | metrics-definer | feeds validation |

## Proposing a new template

The kit's value depends on no ad-hoc HTML drift. Agents retain the judgment to recognize when an existing template doesn't fit — but they **do not invent HTML** and **do not modify the source kit**. The resolution is structural: agents **propose**; humans **approve**.

**Proposal location:** `artifacts/proposals/<slug>.md` — one markdown file per proposal. Reviewed periodically; approved proposals graduate to `artifacts/templates/<slug>.html`.

**No-fit procedure (for agents and skills):**

1. Do not emit ad-hoc HTML. Do not modify the source kit.
2. Write a proposal to `artifacts/proposals/<slug>.md` using the schema below.
3. In `--auto` mode: render in the closest existing template (degraded but consistent), note the degradation in the markdown summary, and reference the proposal file.
4. In interactive mode: pause and surface the proposal for human review before continuing.

**Reuse-first discipline.** A proposal must justify reuse in the "Reuse hypothesis" field. A template that serves only one artifact is usually a sign the artifact is wrongly framed, not that a new template is needed. The proposal review applies this judgment.

**Proposal schema:**

```markdown
---
proposed_template: <kebab-case-slug>
proposed_by: <skill or agent name>
date: <YYYY-MM-DD>
status: proposed | approved | rejected
---

## What this template would carry
[1–3 sentences: artifact name, what it communicates, intended owner.]

## Why existing templates don't fit
[Name the closest existing template(s) and exactly what they fail to express.]

## Required fields
[Bulleted list of structural fields the template must support.]

## Instrument or Document?
[Per artifacts/kit/README.md interactivity rule. If Instrument, name the controls and what value they change.]

## HTML sketch
[Skeleton HTML using kit component classes. Not final — a structural draft.]

## Reuse hypothesis
[Where else this template would be reused. A template that serves only one artifact is a candidate for inlining, not a new template.]
```

**Lint note:** R6 does not enforce proposals — proposals are advisory and human-reviewed. However, a skill cannot ship an `artifact:` frontmatter key pointing at a proposed-but-not-approved template; the proposal must graduate to `artifacts/templates/` first.

## Interactivity — controls where they're earned

An artifact carries interactive UI controls **when manipulating it is the point** — never as decoration (that would violate the studio's own anti-gratuitous rule). Two kinds of artifact:

- **Instruments** — the reviewer needs to *tweak and feel* the thing. These ship live controls:
  - `motion-spec` — duration/easing/distance/delay sliders + a live preview; the controls drive the spec values.
  - `component-spec` — a state switcher that renders each state live.
  - `ascii-wireframe`, `flow-diagram` — state/path toggles (extendable per surface).
  - `copy-deck` — strings are editable in place with live character counts (extendable).
- **Documents** — the artifact is read and judged (`design-brief`, `user-journey`, `user-narrative`, `risk-register`, `metrics-plan`, `competitive-teardown`, `heuristic-report`, `decision-record`). Their interaction is the **annotation harness** (`/annotate`) — click-to-comment, questions, disposition, copy-to-Claude. No invented controls.

When building a new template, ask: would the reviewer want to *change a value and see the effect*? If yes, it's an instrument — add the minimal controls that answer that, styled with the kit. If no, it's a document — the harness is its interaction.

## The rule

**If an artifact is primarily for agent context, it still ships with a well-designed HTML version for human review, and it still carries the annotation harness.** A handoff between an agent and a human is not raw text. (This mirrors the `gather-feedback` skill, which renders completed work as a reviewable page and waits for the response block.)

**R6 — Kit reference enforcement.** Every skill or agent file with an `artifact:` (or `artifacts:`) frontmatter key must reference either `artifacts/templates/<artifact>.html` or `artifacts/kit/studio.css` in its body, and the named template must exist in `artifacts/templates/`. Skills and agents without an `artifact:` key are exempt (orientation and control-plane files). The lint rule in `evals/lint-agnostic.sh` enforces R6 automatically — it fails CI on any artifact-key mismatch or missing template.
