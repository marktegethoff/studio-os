# The Artifact Kit

Every studio artifact is a **well-designed HTML document in the studio visual language that `/studio:feedback --overlay` can mark up on demand.** Not raw markdown, not a wall of text — a designed page the human can read, mark up, and return as agent-friendly feedback in one paste. This kit is what every artifact inherits, so no agent restyles from scratch.

## Two parts

1. **`studio.css`** — the shared stylesheet, carrying the **Standard Works identity** (the studio's own brand — not any product's): Neue Haas Grotesk (refined grotesk sans) via Typekit with a Helvetica Neue fallback, black on warm white, Courier for technical labels, monochrome with at most a single earned accent (`--accent`) and, since 1.8, two annotation colors (blue and red), generous margins, no decoration. Source of truth: `~/Standard Works/Apps/Standard-Works/brand-system.html`. A *product* that needs its artifacts themed to its own brand overrides `--accent`/fonts; by default everything carries Standard Works. Link it; don't reinvent it.
2. **The annotation harness** — the click-to-annotate overlay, the `--overlay` mode of `/studio:feedback`. It injects a review bar, click-to-pin comments, brief-derived questions, a disposition (Approve/Revise/Reject), and a copy-to-Claude output block. Run `/studio:feedback --overlay <artifact>.html` (optionally `--brief <brief>`) to attach it. The source artifact is never modified — the overlay writes `<name>.annotated.html`.

## Building an artifact

```html
<!DOCTYPE html><html lang="en"><head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="studio:genre" content="[procedure | verdict | exploratory]">
  <title>[Artifact] — [subject]</title>
  <link rel="stylesheet" href="../kit/studio.css">
  <!-- optional: a studio/product brand override (fonts + --accent/palette), captured at /studio:init Step D -->
  <!-- <link rel="stylesheet" href="../../.claude/memory/brand.css"> -->
</head><body>
  <div class="doc">
    <header class="tblock">
      <div class="c title"><span class="l">Title</span><h1>[Title]</h1></div>
      <div class="c"><span class="l">Artifact</span><span class="v mono">[artifact type]</span></div>
      <div class="c"><span class="l">Owner</span><span class="v">[agent]</span></div>
      <div class="c"><span class="l">Revision</span><span class="v">[1]</span></div>
      <div class="c"><span class="l">Status</span><span class="v">[Draft]</span></div>
    </header>
    <!-- one lettered panel (.pnl) per part: A, B, C … Components are below. -->
  </div>
</body></html>
```

The genre meta is required; the writing check fails without it. Build with the 1.8 components below. ASCII wireframes go in `pre.ascii` — styled and monospaced, never raw.

**Legacy classes** — `.wrap`, `.header`/`.header-sub`/`.header-meta`, `.eyebrow`, `.section`, `.callout`, `.itemlist`/`.item`, `.dcard`, `.tier`, `.compare`, `.tag`, `.pill`, `.grid2`/`.grid3`, `pre.ascii` — are still supported and render unchanged. Existing artifacts need no migration. New artifacts use the 1.8 components.

## 1.8 — legible artifacts

One person builds from an artifact and another judges it, so it must be citable, checkable, and plain. Four principles and one writing rule:

1. **Title block and lettered panels.** Provenance sits in one `.tblock`. Each part is a panel with a letter. Each item has a number. A reviewer cites "B2".
2. **Annotation colors.** Blue annotates or passes. Red marks a violation or a fail. Nothing else is colored.
3. **Limits as measures.** A value is drawn against its limit, not written beside it.
4. **Dimensioned wireframes.** Where structure matters, an SVG wireframe carries its dimensions and callouts (`.s-*`, `.t-*`).

### Genre and markup

Every artifact declares how it is written, in `<head>`: `<meta name="studio:genre" content="procedure|verdict|exploratory">`. The plugin's `memory/writing.md` holds the rules, the sentence limits, and the dictionary format. Four markers adjust the check:

- `data-genre="…"` on an element overrides the genre for its subtree.
- `data-ste="off"` skips the subtree: a quoted draft under critique, a rule-break example, third-party text. `.orig` always carries it. The class alone skips nothing: the checker WARNs when `.orig` lacks `data-ste="off"`.
- `data-ste="copy"` marks shipping product copy (UI strings). Only the dictionary applies. Product copy follows the product's voice, not studio prose.
- The check always skips `<script> <style> <svg> <pre> <code> <head>` and bracketed `[placeholders]`.

| Genre | Sentence limit | Templates |
|---|---|---|
| `procedure` | 20 words | `component-spec` (full sheet), `task-brief`, `motion-spec`, `state-inventory`, `ascii-wireframe`, `flow-diagram`, `copy-deck` (its shipping strings carry `data-ste="copy"`) |
| `verdict` | 25 words | `critique-report`, `lt-review`, `heuristic-report`, `decision-record`, `risk-register`, `metrics-plan`, `experiment-plan`, `design-brief` |
| `exploratory` | 25 words, as a guide | `ideation-output`, `user-journey`, `user-narrative`, `competitive-teardown` |

### Components

```html
<!-- Panel A: numbered items. Each item is citable as A1, A2 … -->
<section class="pnl" aria-labelledby="a-h">
  <div class="pnl-h"><span class="ltr">A</span><h2 id="a-h">[Panel]</h2><span class="ref">[cites B2]</span></div>
  <div class="pnl-b">
    <ol class="items">
      <li><span class="id">A1</span><span class="t">[Item]<small>[detail]</small></span><span class="side"><span class="ok">✓ [Pass]</span></span></li>
    </ol>

    <!-- A measure: set the data; CSS draws the fill and the limit. Add .over when the value breaks the limit. -->
    <div class="meas" style="--val:7;--lim:25;--max:30">
      <div class="mh"><span>[Body length]</span><span class="mv">7 · max 25 words</span></div>
      <div class="track" aria-hidden="true"><span class="fill"></span><span class="limit"></span></div>
      <div class="scale" aria-hidden="true"><span>0</span><span>15</span><span>30</span></div>
    </div>

    <!-- Annotated copy: the quoted draft, then the annotated rewrite. .seg.x marks a violation. -->
    <span class="orig" data-ste="off"><s>Oops!</s> Nothing saved yet.</span>
    <span class="anat">
      <span class="seg"><span class="w">Nothing saved</span><span class="t">State, not mood</span></span>
      <span class="seg x"><span class="w">yet</span><span class="t">[Rule broken]</span></span>
    </span>
  </div>
  <div class="pnl-f">[One line: scope, count rule, or source.]</div>
</section>
```

- **Title block** — each row holds 4 cells; `.wide` spans 2. Fill every row, or an empty cell shows as a black block.
- **Measure** — `--val` and `--max` are required; `--lim` is optional, and without it no limit mark is drawn. Use custom properties only. Never set an inline `width` or `left`.
- **Also** — `.verdict.pass|.fail|.hold`, `.ok`/`.no`/`.na` (status), `.lead`, `.wc` (word count; `.over`), `.dim` (dimension line with `.tk` ticks), `.note`, `.tbox` (wraps a table so it scrolls inside the panel), `.grid2`/`.grid3` (inside `.doc`), and the text helpers `.mono`, `.lbl`, `.annot`, `.viol`.
- **Wireframe labels** — drawing regions are `[A]` to `[D]` (the designer's convention) and share letters with panel ids. Cite a panel item as `B2` and a drawing region as `[B]`.

### The full sheet

A document of lettered panels in `.doc` is the default. An artifact earns the full `.sheet` only when one surface must show its structure, states, copy, and limits on one page. Today that is `component-spec` alone. The sheet adds a zone frame (`.zx`, `.zy`) and a 12-column `.field`. Panels place themselves in the field with `grid-column` and `grid-row`. The sheet stands alone in `<body>`, not inside `.doc`. Below 900px it becomes one column and the zone frame hides.

### The writing check step

After an emitting skill writes an artifact: run `bash ${CLAUDE_PLUGIN_ROOT}/evals/ste-check.sh --vocab .claude/memory/design-vocabulary.md <artifact.html>` (omit `--vocab` if the file does not exist). Fix each FAIL once by shortening or splitting the sentence, re-run once, and list remaining WARNs in the summary. A second FAIL is reported, not looped. (Bounded, like /implement's retry rule.)

## The artifact catalog

Templates live in `artifacts/templates/`. Each is owned by the agent or the skill that produces it.

| Artifact | Owner | Gates / feeds |
|---|---|---|
| User journey | journey-mapper | constrains Designer scope |
| Wireframe (SVG + ASCII) | designer | structure before code |
| User narrative | writer | pairs with the Scene Test |
| Flow diagram | architect | states + transitions |
| Design brief | brief-writer | **gates `/design`** |
| Metrics plan | metrics-definer | committed with the spec |
| Risk register | assumption-mapper | names the binding assumption |
| Component spec sheet | specifier | removes implementation guessing |
| State inventory | designer | prevents happy-path-only specs |
| Motion spec | choreographer | timing/easing + reduce-motion |
| Copy deck | writer | all strings, reviewable as language |
| Competitive teardown | competitive-analyst | read before a brief |
| Heuristic report | heurist | P0–P3 findings |
| Decision record | architect (`/studio:organize` for the layout record) | an HTML view over a ledger entry |
| Critique report | `/studio:critique` | nine-discipline findings; triage |
| Leadership review | `/studio:review` | **gates ship / merge** |
| Task brief | `/studio:shape --task` | **gates `/implement`** |
| Ideation output | `/studio:ideate` | feeds `/shape` brief |
| Experiment plan | `/studio:experiment` | feeds validation |

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

An artifact carries interactive UI controls **only when manipulating it is the point** — never as decoration (that would violate the studio's own anti-gratuitous rule). Two kinds of artifact:

- **Documents** — the artifact is read and judged. Every template today is a document: static HTML with no script and no controls. A limit is drawn as a measure (`.meas`), not as a slider. The interaction is the **annotation harness** (`/studio:feedback --overlay`) — click-to-comment, questions, disposition, copy-to-Claude. No invented controls.
- **Instruments** — the reviewer needs to *tweak and feel* the thing, so the artifact ships live controls. No template is one today.

When building a new template, ask: would the reviewer want to *change a value and see the effect*? If yes, it's an instrument — add the minimal controls that answer that, styled with the kit. If no, it's a document — the harness is its interaction.

## The rule

**If an artifact is primarily for agent context, it still ships with a well-designed HTML version for human review, and it still carries the annotation harness.** A handoff between an agent and a human is not raw text. (This mirrors `/studio:feedback --surface`, which renders completed work as a reviewable page and waits for the response block.)

**R6 — Kit reference enforcement.** Every skill or agent file with an `artifact:` (or `artifacts:`) frontmatter key must reference either `artifacts/templates/<artifact>.html` or `artifacts/kit/studio.css` in its body, and the named template must exist in `artifacts/templates/`. Skills and agents without an `artifact:` key are exempt (orientation and control-plane files). The lint rule in `evals/lint-agnostic.sh` enforces R6 automatically — it fails CI on any artifact-key mismatch or missing template.
