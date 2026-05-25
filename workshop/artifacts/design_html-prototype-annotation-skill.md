# Design: HTML Prototype Annotation Skill
Date: 2026-05-03
Status: LOCKED

## Decision
A Claude Code skill generates a single, self-contained HTML file that wraps any HTML prototype with a click-to-annotate overlay, producing structured markdown formatted for direct paste into Claude Code. When a product brief or spec doc exists, Claude generates calibrated questions embedded in the annotation UI — surfacing the minimum challenges that probe whether the prototype serves the stated problem and user.

---

## Structure

**Input:**
- Source prototype HTML file path (required)
- `--brief <path>` — path to a product brief, spec doc, or any markdown context (optional; skill auto-detects `studio_os/artifacts/product_brief_*.md` if not provided)
- `--questions ["...","..."]` — manual question override (optional; supplements brief-derived questions)

**Output:** New HTML file (`[original-name].annotated.html`) — source prototype never modified.

**Injection model:** Annotation layer injected into the prototype document (not an iframe). Full DOM access for element identification. All annotation code is a single `<script>` + `<style>` block appended before `</body>`.

**Data model:**
```js
Annotation {
  id: uuid(),
  timestamp: ISO string,
  element: {
    selector: string,   // CSS selector — most specific stable path
    label: string       // human-readable: "Submit button in payment form"
  },
  comment: string
}

Question {
  id: string,
  type: 'binary' | 'open' | 'single' | 'multi',
  text: string,
  options: string[],          // for single/multi only; empty otherwise
  answer: null | true | string | string[],  // null = unanswered; true = binary checked; string = open/single; string[] = multi
  removable: boolean          // false for brief-derived; true for reviewer-added
}
```

**Persistence:** `localStorage` with three keys, all keyed by filename:
- `ann-[path]` — annotations array
- `ann-[path]-q` — questions array (state: answers + reviewer-added questions)
- `ann-[path]-disp` — disposition (`{ verdict: 'approve'|'revise'|'reject'|null, note: string }`)

All data loads on file reopen. No infrastructure required.

**Questions model — two sources:**

1. **Brief-derived questions** (embedded by the skill at generation time): When a brief or spec doc is present, Claude reads it and produces the minimum questions that genuinely challenge whether the prototype serves the stated problem and user — typically 2–4. Pre-loaded into the HTML; not removable by the reviewer. Claude assigns each a type (`binary`, `open`, `single`, or `multi`) and pre-defines options for `single`/`multi` types. Not a compliance list: the reviewer ignores what isn't useful.

2. **Reviewer-added questions** (added at annotation time): Any user — the original creator or a peer reviewer — can add their own questions directly in the output panel. Reviewer selects the question type before adding. They are removable by the same user who added them. This enables a peer-review workflow: creator generates the annotated HTML with their embedded questions, sends it to a colleague, colleague adds their own questions before annotating and sends it back.

Both question types appear identically in the output block. The distinction is only in the UI (reviewer-added questions have a remove affordance).

**Question types:**

| Type | Source | Answer UI | Output format |
|---|---|---|---|
| `binary` | Brief-derived only | Checkbox | `→ Addressed` or `→ UNADDRESSED` |
| `open` | Brief-derived or reviewer-added | Text input | `→ [answer text]` or `→ No answer provided` |
| `single` | Brief-derived only | Radio group | `→ Selected: [option]` or `→ No selection` |
| `multi` | Brief-derived only | Checkbox group | `→ Selected: [opt1, opt2]` or `→ No selection` |

Reviewer-added questions are always `open` type. Structured types (binary, single, multi) require upfront option design — that's Claude's job when reading a brief, not the reviewer's job at annotation time.

**Disposition model:**

Reviewer sets an overall verdict — Approve, Revise, or Reject — after annotating and answering questions. Revise and Reject surface a note field. Disposition appears at the top of the output block, before annotations.

| Verdict | Meaning | Note field |
|---|---|---|
| `Approve` | Design is ready — proceed | No |
| `Revise` | Design needs specific changes before proceeding | Yes (what needs to change) |
| `Reject` | Design direction is wrong — stop and rescope | Yes (why) |

Disposition is optional. If unset, it is omitted from the output.

**Output format:**
```markdown
## Prototype Feedback
**File:** [filename] · **Session:** [timestamp]
**Disposition:** REVISE — The rating options need to be redesigned.

### [1] [Element label]
**Selector:** `button.submit-cta`
**Feedback:** [comment text]

### Questions

**[Q1 — Binary]** Does the progress indicator match the user's mental model?
→ Addressed

**[Q2 — Open-ended]** Are the rating options specific enough to produce actionable signal?
→ The labels feel too generic for this audience.

**[Q3 — Single select]** Which layout variation feels more scannable?
→ Selected: Option A
   Options: Option A | Option B | Option C

---
*[N] annotations. Paste this block directly into your Claude Code prompt.*
```

---

## Interaction Model

**States:**

| State | Entry | Exit |
|---|---|---|
| `annotating` | Default / segmented control | Switch to View |
| `commenting` | Click any element | Save (pin appears) · Escape · Outside click |
| `viewing` | Segmented control | Switch to Annotate |
| `output-open` | "Review Feedback" button | Close / Escape |

**Control bar (fixed top, 48px, frosted glass):**
- Left: segmented control — `Annotate | View` (both states always visible; active state `#f0f0f0` fill)
- Center: annotation count (absolute centered — avoids flex drift when button widths differ)
- Right: "Review Feedback" button (dark fill; always enabled — panel can be opened to add questions before any annotations exist)
- Questions badge (amber, appears when any question is unanswered) — count reflects unanswered questions only; disappears when all are answered — `aria-label="[N] open questions"`

**Comment popover (280px, appears near click):**
- Heading: "Add Annotation" (new) or "Edit Annotation" (editing existing) — uppercase 12px/600, `rgba(0,0,0,0.60)`
- 72px textarea, `resize: none`
- Save (dark fill, 28px) / Discard (outline, 28px) — right-aligned row

**Pins:** 18×18px `#1a1a1a` circles at `top: -9px; right: -9px` on annotated element. Viewport-edge detection flips position inward if clipped. Invisible tap expansion `::before { inset: -13px }`.

**Output panel (360px, slides from right):**

Panel sections in order (top to bottom):
1. **Header** — "Feedback" heading + close ✕ + instruction subtext
2. **Annotations** — compact scrollable list (max-height 160px), each row: `[N] [label] [comment excerpt]` with edit ✎ and remove × affordances
3. **Questions** — typed question list + add row
4. **Disposition** — Approve / Revise / Reject buttons; note textarea appears for Revise and Reject
5. **Output block** — scrollable markdown, fills remaining panel height (`flex: 1; min-height: 0`)
6. **Copy to Clipboard** button

**Question add row (within Questions section):**
- Full-width text input: "Add a question..."
- "+" button — creates an open-ended question (text input answer)
- No type selector: reviewer-added questions are always open-ended. Structured types (binary, single, multi) are set by Claude at generation time based on the brief.

**Question rendering by type:**
- `binary` — checkbox left of question text with type badge (Yes/No)
- `open` — question text + type badge (Open), text input field below for answer
- `single` — question text + type badge (Single), radio group below
- `multi` — question text + type badge (Multi), checkbox group below

Type badge is a small uppercase tag (`9px/600, rgba(0,0,0,0.28)`) shown on each question. Brief-derived questions have no remove affordance; reviewer-added have ×.

**Disposition section:**
- Three equal-width buttons: Approve (green active) · Revise (amber active) · Reject (red active)
- Clicking active button toggles it off
- Note textarea (52px) appears below buttons when Revise or Reject is active; placeholder: "What needs to change?"
- Disposition persists in `localStorage` alongside annotations and questions

**One annotation per element (enforced):**
Clicking an element that already has an annotation opens edit mode for that annotation rather than creating a second one. This prevents annotation sprawl and keeps feedback focused — if you need to say two things about the same element, edit the comment to include both.

**Edit path — two entry points:**
1. Click annotated element in Annotate mode → popover opens in edit mode
2. ✎ button in annotation list panel → popover opens in edit mode

In edit mode, the popover action row changes: a "Remove" button appears on the left, "Discard" and "Save" remain on the right. Removing via the popover is identical in outcome to removing via the panel list — annotation deleted, pin removed, remaining pins renumbered, output updated.

**Annotation list (within output panel):**
Each saved annotation appears as a compact row: `[N] [element label] / [comment excerpt]` with edit ✎ and remove × affordances. Clicking edit re-opens the popover pre-filled. Removing deletes the annotation, removes the pin, renumbers remaining pins, and updates the output block.

**Responsive panel:**
- ≥900px viewport: panel pushes page content (body gets `padding-right: 360px`)
- <900px viewport: panel overlays with a dimmed backdrop (click backdrop to close); panel width is `min(360px, 92vw)`

**Session restore:** `{n} annotation(s) restored from previous session.` — toast, auto-dismisses at 3.8s. No "clear all" in v0.0.5.

---

## Motion Spec

| Transition | Duration | Easing | Properties |
|---|---|---|---|
| Popover appear | 120ms | ease-out | opacity 0→1, scale 0.95→1.0, transform-origin near click |
| Pin appear | 100ms (40ms after popover dismiss begins) | ease-out | opacity 0→1, scale 0.6→1.0 |
| Toggle → pins in/out | 150ms | ease-in-out | opacity only |
| Panel slide in | 220ms | cubic-bezier(0.16,1,0.3,1) | translateX(100%→0) |
| Panel slide out | 180ms | ease-in | translateX(0→100%) |
| Popover dismiss (Escape/outside click) | none — cut | — | User-initiated; no causal ambiguity |

---

## Visual Specification

**Control bar:**
```css
height: 48px;
padding: 0 16px;
background: rgba(255, 255, 255, 0.82);
backdrop-filter: blur(12px) saturate(180%);
-webkit-backdrop-filter: blur(12px) saturate(180%);
border-bottom: 1px solid rgba(0, 0, 0, 0.08);
box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
```

Segmented control — active state:
```css
background: #f0f0f0;
border: 1px solid rgba(0, 0, 0, 0.18);
color: #1a1a1a;
height: 30px; padding: 0 12px; border-radius: 4px;
font-size: 13px; font-weight: 500;
min-height: 44px; /* tap target */
```

Count label:
```css
font-size: 12px; font-weight: 400;
color: rgba(0, 0, 0, 0.60); /* raised from 0.45 — AA contrast */
position: absolute; left: 50%; transform: translateX(-50%);
```

CTA button:
```css
height: 30px; min-height: 44px;
padding: 0 14px; border-radius: 4px;
background: #1a1a1a; color: #ffffff;
font-size: 13px; font-weight: 500;
border: none;
```

**Comment popover:**
```css
width: 280px;
border-radius: 8px;
padding: 14px 16px 12px;
background: #ffffff;
border: 1px solid rgba(0, 0, 0, 0.10);
box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12), 0 1px 3px rgba(0, 0, 0, 0.08);
```

Textarea:
```css
width: 100%; box-sizing: border-box;
height: 72px; resize: none;
padding: 8px 10px;
font-size: 13px; line-height: 1.45;
background: #fafafa;
border: 1px solid rgba(0, 0, 0, 0.14);
border-radius: 5px;
margin-bottom: 10px;
```

Discard button:
```css
color: rgba(0, 0, 0, 0.60); /* raised from 0.50 — AA contrast */
border: 1px solid rgba(0, 0, 0, 0.12);
height: 28px; min-height: 44px;
```

**Pins:**
```css
width: 18px; height: 18px; border-radius: 50%;
background: #1a1a1a; color: #ffffff;
font-size: 10px; font-weight: 500;
top: -9px; right: -9px; position: absolute;
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.25);
display: flex; align-items: center; justify-content: center;
```

Tap target:
```css
.pin::before {
  content: ''; position: absolute; inset: -13px;
}
```

**Output panel:**
```css
width: 360px;
padding: 20px 20px 24px;
background: #ffffff;
border-left: 1px solid rgba(0, 0, 0, 0.10);
box-shadow: -4px 0 16px rgba(0, 0, 0, 0.08);
```

Markdown block:
```css
background: #f7f7f7; border-radius: 4px;
font-family: ui-monospace, SFMono-Regular, monospace;
font-size: 11px; line-height: 1.65;
padding: 12px 14px;
flex: 1; min-height: 0; overflow-y: auto;
white-space: pre-wrap; word-break: break-word;
margin-bottom: 12px;
```

Output section wrapper (contains markdown block + copy button):
```css
flex: 1; min-height: 0; display: flex; flex-direction: column;
```

**Disposition buttons:**
```css
/* Container */
display: flex; gap: 5px;

/* Button base */
flex: 1; height: 30px; border-radius: 5px;
font-size: 12px; font-weight: 500;
border: 1px solid rgba(0, 0, 0, 0.14); background: transparent;
color: rgba(0, 0, 0, 0.45); cursor: pointer;

/* Active states */
.approve.active { background: #2d6a4f; color: #fff; border-color: #2d6a4f; }
.revise.active  { background: #92400e; color: #fff; border-color: #92400e; }
.reject.active  { background: #9b1d20; color: #fff; border-color: #9b1d20; }
```

Disposition note textarea:
```css
width: 100%; height: 52px; resize: none; margin-top: 8px;
padding: 7px 9px; font-size: 12px; line-height: 1.5;
border: 1px solid rgba(0, 0, 0, 0.12); border-radius: 5px;
background: #fafafa; color: #1a1a1a;
```

**Question type tag:**
```css
font-size: 9px; font-weight: 600; text-transform: uppercase;
letter-spacing: 0.05em; color: rgba(0, 0, 0, 0.28);
background: rgba(0, 0, 0, 0.05); border-radius: 3px;
padding: 2px 5px;
```

Question answer input (open-ended):
```css
width: 100%; height: 26px; padding: 0 8px;
font-size: 12px; border: 1px solid rgba(0, 0, 0, 0.12); border-radius: 4px;
background: #fafafa; margin-top: 6px;
```

Question type selector (add row):
```css
height: 24px; padding: 0 4px; font-size: 11px;
border: 1px solid rgba(0, 0, 0, 0.12); border-radius: 4px;
background: #fafafa;
```

Copy button:
```css
width: 100%; height: 44px;
background: #1a1a1a; color: #ffffff;
font-size: 13px; font-weight: 500;
border: none; border-radius: 4px;
```

---

## Copy

| Element | String |
|---|---|
| Segmented control | `Annotate` / `View` |
| Count — 0 | `No annotations` |
| Count — 1 | `1 annotation` |
| Count — N | `{n} annotations` |
| CTA | `Review Feedback` |
| Popover heading | `ADD ANNOTATION` |
| Textarea placeholder | `Describe the issue or change needed.` |
| Save | `Save` |
| Discard | `Discard` |
| Panel heading | `Feedback` |
| Panel instructions | `Copy the output below and paste it into Claude Code to continue iteration.` |
| Empty state | `No annotations. Click any element in Annotate mode to begin.` |
| Copy button | `Copy to Clipboard` |
| Copy — success | `Copied!` |
| Copy — failure | `Copy failed — select all` |
| Questions heading | `Open Questions` |
| Add question placeholder | `Add a question...` |
| Answer placeholder (open) | `Your answer...` |
| Disposition heading | `Disposition` |
| Disposition: approve | `Approve` |
| Disposition: revise | `Revise` |
| Disposition: reject | `Reject` |
| Disposition note placeholder | `What needs to change?` |
| Session restored | `{n} annotation(s) restored from previous session.` |

---

## Accessibility

- All interactive elements: `min-height: 44px`
- Toggle: `aria-pressed="true/false"` + `aria-label="Toggle annotation mode"`
- Count: `aria-live="polite"`
- Pins: `aria-label="Annotation [N]: [element label]"`
- Popover: `role="dialog"`, `aria-label="Add annotation"`, focus trap on open
- Copy button: `aria-live="polite"` region for Copied/failed state
- Questions badge: `aria-label="[N] open questions"`

---

## What Was Removed

- User attribution — single-user tool; adds fields without value
- Screenshot per element — CSS selector + label is sufficient
- Multiple export formats — one format: structured markdown for Claude Code
- Element inspector panel — over-engineered
- Comment threading — this feeds a model, not a discussion
- iframe approach — injection gives full DOM access without friction
- Popover dismiss animation on Escape — user-initiated, no causal ambiguity to resolve

---

## Repo Deliverables

Three artifacts ship with the skill:

1. **The skill** — `annotate.md` (or `html-annotate.md`) in `~/.claude/skills/`, installable by any Claude Code user
2. **Demo prototype** — `demo/prototype.html` — a realistic but generic HTML prototype (a simple multi-step form or card-based UI) with no organization-specific references
3. **Generated demo** — `demo/prototype.annotated.html` — the skill applied to the demo prototype, pre-loaded with 2–3 example annotations so users can see the output without running the skill first
4. **README** — covers: what this is, prerequisites (Claude Code), install (copy skill file to `~/.claude/skills/`), usage (`/annotate <file>`, `--brief`, `--questions`), and what the output looks like

**General-purpose principle:** No organization-specific references anywhere in the skill, demo, or docs. The tool is for any designer, PM, or engineer using Claude Code to iterate on HTML prototypes.

---

## Open Questions

- **Selector stability (low priority):** Prototypes built on structured design systems should have stable, predictable class names — likely a non-issue. Verify in a real environment by annotating a component, modifying surrounding content, and confirming the selector still resolves. If edge cases appear (generated IDs, deeply nested anonymous elements), evaluate XPath or `data-annotation-id` injection at that point. Not a pre-condition for v0.0.5.
- **Control bar dark variant:** Frosted glass can pick up saturated color from dark prototype backgrounds. Consider `--dark-bar` flag for v0.1 if sandbox testing reveals this.
