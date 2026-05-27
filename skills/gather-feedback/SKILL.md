---
description: "Collect structured feedback on a design artifact from a named reviewer. Produces a feedback record in the reviews/ directory."
argument-hint: "<optional — usually inferred from the prior workflow context>"
---

Render the Review Surface for completed work.

Arguments: $ARGUMENTS

The Review Surface is a designed HTML artifact (built on the Artifact Kit — `artifacts/kit/studio.css` + the annotation harness) that presents agent-completed work for human review and lets the human respond via a copy-to-chat block the agent parses automatically. This skill produces the artifact, opens it in the browser, and waits for the response.

**Output:** `reviews/<slug>_<timestamp>/index.html` (+ an `evidence/` folder if needed) in the consuming project.

---

## When to use

- After `/studio:implement` finishes (auto-fired).
- After `/studio:design` produces a spec, to review before locking.
- Any time a tasteful visual handback beats a chat summary.

---

## Evidence — generalized beyond snapshots

The surface presents whatever evidence fits the work. Pick the forms that apply; do not force screenshots where they don't:

- **Rendered artifact** — embed or link the artifact HTML (brief, journey, spec, motion preview…). Preferred for design work.
- **Screenshots / snapshots** — UI states, before/after pairs (was the iOS-only path; now one option among several).
- **Code excerpts** — the key diff hunks, syntax-plain, for implementation reviews.
- **Prose summary** — 1–3 plain-language paragraphs: what changed and any judgment calls.
- **Status** — build/test/eval results where relevant (`PASSED` / `FAILED` / `N/A`).

State which evidence forms you used and why the others were omitted.

---

## Steps

1. **Gather context.** Title (sentence case), subtitle (`Review · Implementation|Design|Brief|Artifact`), branch, spec path, status, the evidence (per above), and a plain-language summary. From the prior workflow if chained, or from `git diff --name-only HEAD` + `git rev-parse --abbrev-ref HEAD` if standalone.
2. **Generate 1–3 questions** focused on judgment calls and uncertainties (not anything answerable from the diff or covered by tests). Types: `text`, `choice` (radios with explicit options), `textarea` (sparingly). A catch-all textarea and a disposition (APPROVE / REVISE / REJECT) are rendered automatically — do not add them yourself.
3. **Render** `index.html` using `studio.css` for the page chrome and the annotation harness for the response block. Self-contained (inline what's needed; copy any evidence into `evidence/`).
4. **Open** it: `open <path>` (macOS) and tell the user.
5. **Wait** for the user to paste the response block back. Parse the disposition + answers + any inline annotations and continue the workflow.

---

## Response block

The surface produces a single copy-to-chat block: disposition, per-question answers, the catch-all, and any annotations (from the harness). Parse it and act — APPROVE proceeds, REVISE/REJECT routes the named changes to the owning agent.

---

## Notes

- Self-contained: opens with no server.
- Built on the Artifact Kit so it inherits the studio visual language and the same review harness every artifact uses — one review pattern across the studio.
- Generalized from the original iOS-snapshot version: snapshots are now one evidence form among several.
