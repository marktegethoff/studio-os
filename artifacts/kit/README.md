# The Artifact Kit

Every studio artifact is a **well-designed HTML document in the studio visual language, with a built-in review harness.** Not raw markdown, not a wall of text — a designed page the human can read, mark up, and return as agent-friendly feedback in one paste. This kit is what every artifact inherits, so no agent restyles from scratch.

## Two parts

1. **`studio.css`** — the shared stylesheet (the Standard Works visual language: Space Mono mechanism, system-sans tape, amber accent, the component classes). Link it; don't reinvent it.
2. **The annotation harness** — the click-to-annotate overlay from the `annotate` skill. It injects a review bar, click-to-pin comments, brief-derived questions, a disposition (Approve/Revise/Reject), and a copy-to-Claude output block. Run `/annotate <artifact>.html` (optionally `--brief <brief>`) to attach it. The source artifact is never modified — `annotate` writes `<name>.annotated.html`.

## Building an artifact

```html
<!DOCTYPE html><html lang="en"><head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Artifact] — [subject]</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">
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

## The rule

**If an artifact is primarily for agent context, it still ships with a well-designed HTML version for human review, and it still carries the annotation harness.** A handoff between an agent and a human is not raw text. (This mirrors the `gather-feedback` skill, which renders completed work as a reviewable page and waits for the response block.)
