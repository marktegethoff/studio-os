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
</head><body>
  <div class="wrap">
    <header class="header">
      <span class="eyebrow">Studio OS · [artifact type]</span>
      <h1>[Title]<span style="color:var(--amber)">.</span></h1>
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
