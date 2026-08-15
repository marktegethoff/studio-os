---
description: "Collect structured feedback on completed work. Two modes: a Review Surface for any artifact (--surface, default) or a click-to-annotate overlay injected into an HTML prototype (--overlay). Produces a feedback record in the reviews/ directory."
argument-hint: "[<path/to/artifact>] [--surface | --overlay] [--brief <path>] [--questions [\"Q1\",\"Q2\"]]"
---

Collect human feedback on completed work.

Arguments: $ARGUMENTS

One skill, two modes — both built on the Artifact Kit (`artifacts/kit/studio.css` + the annotation harness), so the studio has one review pattern everywhere. This skill absorbed `/studio:gather-feedback` (now the `--surface` mode) and `/studio:annotate` (now the `--overlay` mode).

## Mode selection

- `--overlay` — the target is an HTML file the reviewer should mark up in place (prototypes, rendered artifacts). Injects a click-to-annotate overlay; the source is never modified. **Read `skills/feedback/overlay.md` and follow it.**
- `--surface` *(default)* — everything else: implementation reviews, briefs, specs, prose, mixed evidence. Renders a Review Surface page presenting the work with questions and a copy-to-chat response block.
- Neither flag given: if $ARGUMENTS names an `.html` artifact and the ask is markup-style feedback, use `--overlay`; otherwise use `--surface`. State which mode you chose and why in one line.

---

## Surface mode

The Review Surface is a designed HTML artifact that presents agent-completed work for human review and lets the human respond via a copy-to-chat block the agent parses automatically. This mode produces the artifact, opens it in the browser, and waits for the response.

**Output:** `reviews/<slug>_<timestamp>/index.html` (+ an `evidence/` folder if needed) in the consuming project.

### When to use

- After `/studio:implement` finishes (auto-fired).
- After `/studio:design` produces a spec, to review before locking.
- After `/studio:prototype` hands off (auto-fired).
- Any time a tasteful visual handback beats a chat summary.

### Evidence — generalized beyond snapshots

The surface presents whatever evidence fits the work. Pick the forms that apply; do not force screenshots where they don't:

- **Rendered artifact** — embed or link the artifact HTML (brief, journey, spec, motion preview…). Preferred for design work.
- **Screenshots / snapshots** — UI states, before/after pairs.
- **Code excerpts** — the key diff hunks, syntax-plain, for implementation reviews.
- **Prose summary** — 1–3 plain-language paragraphs: what changed and any judgment calls.
- **Status** — build/test/eval results where relevant (`PASSED` / `FAILED` / `N/A`).

State which evidence forms you used and why the others were omitted.

### Steps

1. **Gather context.** Title (sentence case), subtitle (`Review · Implementation|Design|Brief|Artifact`), branch, spec path, status, the evidence (per above), and a plain-language summary. From the prior workflow if chained, or from `git diff --name-only HEAD` + `git rev-parse --abbrev-ref HEAD` if standalone.
2. **Generate 1–3 questions** focused on judgment calls and uncertainties (not anything answerable from the diff or covered by tests). Types: `text`, `choice` (radios with explicit options), `textarea` (sparingly). A catch-all textarea and a disposition (APPROVE / REVISE / REJECT) are rendered automatically — do not add them yourself.
3. **Render** `index.html` using `studio.css` for the page chrome and the annotation harness for the response block. Self-contained (inline what's needed; copy any evidence into `evidence/`).
4. **Open** it: `open <path>` (macOS) and tell the user.
5. **Wait** for the user to paste the response block back. Parse the disposition + answers + any inline annotations and continue the workflow.

### Response block

The surface produces a single copy-to-chat block: disposition, per-question answers, the catch-all, and any annotations (from the harness). Parse it and act — APPROVE proceeds, REVISE/REJECT routes the named changes to the owning agent.

---

## Overlay mode

Full mechanism in `skills/feedback/overlay.md` — read it when this mode fires. Summary: injects a click-to-annotate overlay before `</body>` of a copy of the target HTML (`[name].annotated.html`); the reviewer clicks elements, types notes, and exports a single copy-to-chat block. Supports `--brief <path>` (renders the brief alongside) and `--questions [...]` (seeds specific questions).

Non-HTML artifacts cannot receive the overlay — use surface mode.

---

## Notes

- Self-contained: both modes open with no server.
- One review pattern across the studio: both modes emit the same copy-to-chat response block format, parsed the same way.
