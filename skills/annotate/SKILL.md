# Annotate

Generate a click-to-annotate overlay for any HTML prototype. Produces a new file — the source is never modified.

## Usage

```
/annotate path/to/prototype.html
/annotate path/to/prototype.html --brief path/to/brief.md
/annotate path/to/prototype.html --questions ["Question 1", "Question 2"]
```

## What it produces

`[original-name].annotated.html` — identical to the source prototype with an annotation overlay injected before `</body>`. Open in any browser; no server required.

---

## Steps

### Step 1 — Read the source

Read the file at the provided path. If it does not exist, stop and report the error clearly.

### Step 2 — Determine brief-derived questions

**If `--brief <path>` is provided:** Read the file at that path.

**If no `--brief` is given:** Look for a file matching `studio_os/artifacts/product_brief_*.md` in the current working directory tree. If exactly one is found, read it silently. If multiple are found, ask which to use. If none is found, proceed with no brief.

**If `--questions [...]` is provided:** Add those as open-ended questions in addition to any brief-derived questions.

**From the brief, produce 2–4 questions that:**
- Are specific to the stated problem and user in the brief — not generic usability questions
- Challenge a real assumption the prototype makes — about user behavior, product fit, or technical feasibility
- Are assigned a type that matches the kind of answer needed:
  - `binary` — a yes/no judgment the reviewer can make by looking at the screen
  - `open` — something that requires a sentence or two to answer honestly
  - `single` — a choice between defined options where one is right for this design
  - `multi` — a checklist where multiple answers may apply
- For `single` and `multi` types: define 2–4 specific, non-generic options

**If no brief and no `--questions`:** use an empty array: `var BRIEF_QS = [];`

### Step 3 — Build the BRIEF_QS array

Format as a JavaScript array literal matching this structure exactly:

```js
var BRIEF_QS = [
  {
    id: 'bq1',
    type: 'binary',
    options: [],
    answer: null,
    text: "Question text here.",
    removable: false
  },
  {
    id: 'bq2',
    type: 'open',
    options: [],
    answer: '',
    text: "Question text here.",
    removable: false
  },
  {
    id: 'bq3',
    type: 'single',
    options: ['Option A', 'Option B', 'Option C'],
    answer: null,
    text: "Question text here.",
    removable: false
  },
];
```

Rules:
- IDs are `bq1`, `bq2`, `bq3`, ... in sequence
- `removable` is always `false` for brief-derived questions
- `answer` is `null` for binary/single, `''` for open, `[]` for multi
- `options` is `[]` for binary and open types

### Step 4 — Build the annotated file

Take the complete source HTML. Locate the closing `</body>` tag.

**If the source already contains `<!-- ann-overlay-start -->`:** Replace everything from `<!-- ann-overlay-start -->` to `<!-- ann-overlay-end -->` (inclusive) with the new overlay block from Step 5. This allows re-running the skill to update questions without losing annotations in localStorage.

**Otherwise:** Inject the overlay block immediately before `</body>`.

**`</body>` edge cases:**
- If no `</body>` tag exists, append the overlay at the very end of the file.
- If multiple `</body>` tags exist, inject before the last one.
- If no `<body>` tag exists at all (e.g. an HTML fragment), stop and report: `"Cannot inject overlay: no <body> element found in [filename]."`

### Step 5 — Write the output

Write the complete annotated HTML to `[source-filename].annotated.html` in the same directory as the source file.

Tell the user:
- The path to the generated file
- How to open it: `open [path]` (macOS) or just double-click the file in Finder/Explorer

---

## Overlay template

Inject the block below verbatim. **Replace `// __BRIEF_QS__` with the complete `var BRIEF_QS = [...]` array from Step 3.** Do not modify any other part of the overlay.

```html
<!-- ann-overlay-start -->
<style>
  @media (min-width: 900px) { body.panel-open { padding-right: 360px; } }

  .ann-bar {
    position: fixed; top: 0; left: 0; right: 0; height: 48px;
    display: flex; align-items: center; padding: 0 16px; z-index: 9000;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: rgba(255,255,255,0.82);
    backdrop-filter: blur(12px) saturate(180%);
    -webkit-backdrop-filter: blur(12px) saturate(180%);
    border-bottom: 1px solid rgba(0,0,0,0.08);
    box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  }
  .ann-segmented {
    display: flex; border: 1px solid rgba(0,0,0,0.14); border-radius: 6px;
    padding: 2px; gap: 2px; background: rgba(0,0,0,0.03);
  }
  .ann-seg-btn {
    height: 26px; padding: 0 12px; font-size: 12.5px; font-weight: 500;
    background: transparent; border: none; color: rgba(0,0,0,0.40);
    cursor: pointer; font-family: inherit; border-radius: 4px;
    transition: background 0.12s, color 0.12s;
  }
  .ann-seg-btn.active { background: #fff; color: #1a1a1a; box-shadow: 0 1px 3px rgba(0,0,0,0.10); }
  .ann-bar-center {
    position: absolute; left: var(--bar-cx, 50%); transform: translateX(-50%);
    display: flex; align-items: center; gap: 8px; pointer-events: none;
    transition: left 220ms cubic-bezier(0.16,1,0.3,1);
  }
  .ann-count { font-size: 12px; color: rgba(0,0,0,0.60); font-family: inherit; }
  .ann-q-badge {
    font-size: 11px; font-weight: 600; color: #7d5200;
    background: rgba(251,191,36,0.18); border: 1px solid rgba(251,191,36,0.45);
    border-radius: 10px; padding: 2px 8px; font-family: inherit;
  }
  .ann-bar-right { margin-left: auto; }
  .ann-cta {
    height: 28px; padding: 0 14px; border-radius: 5px;
    background: #1a1a1a; color: #fff; font-size: 12.5px; font-weight: 500;
    border: none; cursor: pointer; font-family: inherit;
  }
  .ann-hovered { outline: 1px dashed rgba(0,0,0,0.30) !important; outline-offset: 2px; cursor: crosshair !important; }
  .ann-pin {
    position: fixed; width: 18px; height: 18px; border-radius: 50%;
    background: #1a1a1a; color: #fff; font-size: 10px; font-weight: 500;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    display: flex; align-items: center; justify-content: center;
    box-shadow: 0 1px 4px rgba(0,0,0,0.28); z-index: 8000;
    pointer-events: none; transition: opacity 0.15s ease-in-out;
  }
  .ann-popover {
    position: fixed; width: 280px; border-radius: 8px; padding: 14px 16px 12px;
    background: #fff; border: 1px solid rgba(0,0,0,0.09);
    box-shadow: 0 4px 16px rgba(0,0,0,0.11), 0 1px 3px rgba(0,0,0,0.07);
    z-index: 9500; display: none;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    animation: ann-popIn 0.12s ease-out;
  }
  @keyframes ann-popIn { from { opacity:0; transform:scale(0.96); } to { opacity:1; transform:scale(1); } }
  .ann-popover-heading {
    font-size: 10.5px; font-weight: 600; text-transform: uppercase;
    letter-spacing: 0.05em; color: rgba(0,0,0,0.55); margin-bottom: 9px;
  }
  .ann-popover textarea {
    width: 100%; height: 72px; resize: none; padding: 8px 10px;
    font-size: 13px; line-height: 1.45; background: #fafafa;
    border: 1px solid rgba(0,0,0,0.12); border-radius: 5px;
    margin-bottom: 10px; font-family: inherit; color: #1a1a1a; outline: none;
    box-sizing: border-box;
  }
  .ann-popover textarea:focus { border-color: rgba(0,0,0,0.28); background: #fff; }
  .ann-popover-actions { display: flex; justify-content: space-between; align-items: center; gap: 7px; }
  .ann-popover-actions-right { display: flex; gap: 7px; }
  .ann-btn-remove {
    height: 28px; padding: 0 10px; background: transparent;
    color: rgba(155,29,32,0.70); font-size: 12px; font-family: inherit;
    border: 1px solid rgba(155,29,32,0.22); border-radius: 4px;
    cursor: pointer; display: none; transition: background 0.1s, color 0.1s;
  }
  .ann-btn-remove:hover { background: rgba(155,29,32,0.07); color: #9b1d20; }
  .ann-btn-remove.visible { display: block; }
  .ann-btn-discard {
    height: 28px; padding: 0 12px; background: transparent;
    color: rgba(0,0,0,0.55); font-size: 12px; font-family: inherit;
    border: 1px solid rgba(0,0,0,0.12); border-radius: 4px; cursor: pointer;
  }
  .ann-btn-save {
    height: 28px; padding: 0 14px; background: #1a1a1a; color: #fff;
    font-size: 12px; font-weight: 500; border: none; border-radius: 4px;
    cursor: pointer; font-family: inherit;
  }
  .ann-backdrop {
    display: none; position: fixed; inset: 0; z-index: 8400; background: rgba(0,0,0,0.25);
  }
  @media (max-width: 899px) {
    .ann-backdrop.visible { display: block; }
    .ann-panel { width: min(360px, 92vw); }
  }
  .ann-panel {
    position: fixed; top: 48px; right: 0; bottom: 0; width: 360px;
    background: #fff; border-left: 1px solid rgba(0,0,0,0.09);
    box-shadow: -4px 0 20px rgba(0,0,0,0.07);
    padding: 20px 20px 24px; z-index: 8500;
    display: flex; flex-direction: column; overflow: hidden;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    transform: translateX(100%);
    transition: transform 220ms cubic-bezier(0.16,1,0.3,1);
  }
  .ann-panel.open { transform: translateX(0); }
  .ann-panel-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 3px; flex-shrink: 0; }
  .ann-panel-heading { font-size: 14px; font-weight: 600; color: #1a1a1a; letter-spacing: -0.01em; }
  .ann-panel-close {
    width: 28px; height: 28px; border-radius: 50%; background: rgba(0,0,0,0.06);
    border: none; cursor: pointer; font-size: 15px; color: rgba(0,0,0,0.40);
    display: flex; align-items: center; justify-content: center;
    font-family: inherit; transition: background 0.1s, color 0.1s;
  }
  .ann-panel-close:hover { background: rgba(0,0,0,0.10); color: #1a1a1a; }
  .ann-panel-sub { font-size: 12px; color: rgba(0,0,0,0.42); line-height: 1.5; margin-bottom: 14px; flex-shrink: 0; }
  .ann-section-label {
    font-size: 10.5px; font-weight: 600; text-transform: uppercase;
    letter-spacing: 0.06em; color: rgba(0,0,0,0.35); margin-bottom: 8px;
  }
  .ann-list-section { flex-shrink: 0; }
  .ann-list-scroll { max-height: 160px; overflow-y: auto; }
  .ann-list-row { display: flex; align-items: flex-start; gap: 7px; padding: 6px 0; border-bottom: 1px solid rgba(0,0,0,0.05); }
  .ann-list-row:last-child { border-bottom: none; }
  .ann-list-num {
    width: 16px; height: 16px; border-radius: 50%; flex-shrink: 0;
    background: #1a1a1a; color: #fff; font-size: 9px; font-weight: 700;
    display: flex; align-items: center; justify-content: center; margin-top: 1px;
  }
  .ann-list-text { flex: 1; font-size: 12px; color: rgba(0,0,0,0.60); line-height: 1.45; overflow: hidden; }
  .ann-list-lbl { font-weight: 500; color: rgba(0,0,0,0.70); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; }
  .ann-list-cmt { color: rgba(0,0,0,0.45); font-size: 11.5px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
  .ann-list-acts { display: flex; gap: 2px; flex-shrink: 0; margin-top: 1px; }
  .ann-icon-btn {
    width: 22px; height: 22px; border-radius: 4px; border: none;
    background: transparent; cursor: pointer; font-size: 12px;
    display: flex; align-items: center; justify-content: center;
    color: rgba(0,0,0,0.28); transition: background 0.1s, color 0.1s;
  }
  .ann-icon-btn:hover { background: rgba(0,0,0,0.07); color: #1a1a1a; }
  .ann-icon-btn.ann-danger:hover { background: rgba(155,29,32,0.08); color: #9b1d20; }
  .ann-list-empty { font-size: 12px; color: rgba(0,0,0,0.32); padding: 4px 0 8px; font-style: italic; }
  .ann-divider { height: 1px; background: rgba(0,0,0,0.07); margin: 10px 0; flex-shrink: 0; }
  .ann-q-section { flex-shrink: 0; }
  .ann-q-item { margin-bottom: 8px; padding-bottom: 8px; border-bottom: 1px solid rgba(0,0,0,0.05); }
  .ann-q-item:last-child { border-bottom: none; padding-bottom: 0; }
  .ann-q-row { display: flex; align-items: flex-start; gap: 6px; }
  .ann-q-text { flex: 1; font-size: 12px; line-height: 1.5; color: rgba(0,0,0,0.65); }
  .ann-q-answer-wrap { margin-top: 6px; }
  .ann-q-answer-input {
    width: 100%; height: 26px; padding: 0 8px; box-sizing: border-box;
    font-size: 12px; font-family: inherit; color: #1a1a1a;
    border: 1px solid rgba(0,0,0,0.12); border-radius: 4px;
    background: #fafafa; outline: none;
  }
  .ann-q-answer-input:focus { border-color: rgba(0,0,0,0.28); background: #fff; }
  .ann-q-answer-input::placeholder { color: rgba(0,0,0,0.28); }
  .ann-q-options { margin-top: 5px; }
  .ann-q-option { display: flex; align-items: center; gap: 6px; font-size: 12px; color: rgba(0,0,0,0.60); margin-bottom: 4px; cursor: pointer; line-height: 1.4; }
  .ann-q-option:last-child { margin-bottom: 0; }
  .ann-q-option input { cursor: pointer; accent-color: #1a1a1a; flex-shrink: 0; }
  .ann-q-add { display: flex; gap: 6px; margin-top: 8px; align-items: center; }
  .ann-q-add input {
    flex: 1; height: 28px; padding: 0 9px; font-size: 12px; font-family: inherit;
    border: 1px solid rgba(0,0,0,0.12); border-radius: 5px;
    background: #fafafa; color: #1a1a1a; outline: none;
  }
  .ann-q-add input:focus { border-color: rgba(0,0,0,0.28); background: #fff; }
  .ann-q-add input::placeholder { color: rgba(0,0,0,0.28); }
  .ann-q-add-btn {
    width: 28px; height: 28px; flex-shrink: 0; border-radius: 5px;
    border: 1px solid rgba(0,0,0,0.14); background: transparent;
    color: rgba(0,0,0,0.40); font-size: 20px; line-height: 1;
    cursor: pointer; display: flex; align-items: center; justify-content: center;
    font-family: inherit; padding: 0 0 1px;
    transition: background 0.1s, color 0.1s, border-color 0.1s;
  }
  .ann-q-add-btn:hover { background: #1a1a1a; color: #fff; border-color: #1a1a1a; }
  #ann-q-list.ann-q-list-filled + .ann-q-add { border-top: 1px solid rgba(0,0,0,0.07); margin-top: 6px; padding-top: 8px; }
  .ann-disp-section { flex-shrink: 0; }
  .ann-disp-btns { display: flex; gap: 5px; }
  .ann-disp-btn {
    flex: 1; height: 30px; border-radius: 5px; font-size: 12px; font-weight: 500;
    font-family: inherit; border: 1px solid rgba(0,0,0,0.14); background: transparent;
    color: rgba(0,0,0,0.45); cursor: pointer;
    transition: background 0.12s, color 0.12s, border-color 0.12s;
  }
  .ann-disp-btn:hover { border-color: rgba(0,0,0,0.28); color: rgba(0,0,0,0.70); }
  .ann-disp-btn.d-approve.active { background: #2d6a4f; color: #fff; border-color: #2d6a4f; }
  .ann-disp-btn.d-revise.active  { background: #92400e; color: #fff; border-color: #92400e; }
  .ann-disp-btn.d-reject.active  { background: #9b1d20; color: #fff; border-color: #9b1d20; }
  .ann-disp-note {
    display: none; width: 100%; height: 52px; resize: none; margin-top: 8px;
    padding: 7px 9px; font-size: 12px; font-family: inherit; line-height: 1.5;
    color: #1a1a1a; border: 1px solid rgba(0,0,0,0.12); border-radius: 5px;
    background: #fafafa; outline: none; box-sizing: border-box;
  }
  .ann-disp-note:focus { border-color: rgba(0,0,0,0.28); background: #fff; }
  .ann-disp-note::placeholder { color: rgba(0,0,0,0.28); }
  .ann-disp-note.visible { display: block; }
  .ann-output-section { flex: 1; min-height: 0; display: flex; flex-direction: column; }
  .ann-output-block {
    background: #f7f7f7; border-radius: 5px;
    font-family: ui-monospace, SFMono-Regular, 'Menlo', monospace;
    font-size: 11px; line-height: 1.65; padding: 12px 14px;
    overflow-y: auto; white-space: pre-wrap; word-break: break-word;
    color: #222; flex: 1; min-height: 0; margin-bottom: 12px;
  }
  .ann-copy-btn {
    width: 100%; height: 40px; background: #1a1a1a; color: #fff;
    font-size: 13px; font-weight: 500; border: none; border-radius: 5px;
    cursor: pointer; font-family: inherit; flex-shrink: 0; transition: background 0.1s;
  }
  .ann-copy-btn.ann-copied { background: #2d6a4f; }
  .ann-copy-btn.ann-failed { background: #9b1d20; }
  .ann-toast {
    position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%);
    background: #1a1a1a; color: #fff; font-size: 12px; font-weight: 500;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    padding: 8px 16px; border-radius: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.20);
    z-index: 9999; pointer-events: none;
    animation: ann-toastIn 0.2s ease-out, ann-toastOut 0.3s ease-in 3s forwards;
  }
  @keyframes ann-toastIn  { from { opacity:0; transform:translateX(-50%) translateY(8px); } to { opacity:1; transform:translateX(-50%) translateY(0); } }
  @keyframes ann-toastOut { from { opacity:1; } to { opacity:0; } }
</style>

<div class="ann-bar">
  <div class="ann-segmented">
    <button class="ann-seg-btn active" id="ann-seg-annotate">Annotate</button>
    <button class="ann-seg-btn"        id="ann-seg-view">View</button>
  </div>
  <div class="ann-bar-center">
    <span id="ann-count" class="ann-count">No annotations</span>
    <span id="ann-q-badge" class="ann-q-badge" style="display:none;"></span>
  </div>
  <div class="ann-bar-right">
    <button class="ann-cta" id="ann-cta">Review Feedback</button>
  </div>
</div>

<div class="ann-popover" id="ann-popover">
  <div class="ann-popover-heading" id="ann-popover-heading">Add Annotation</div>
  <textarea id="ann-textarea" placeholder="Describe the issue or change needed."></textarea>
  <div class="ann-popover-actions">
    <button class="ann-btn-remove" id="ann-remove">Remove</button>
    <div class="ann-popover-actions-right">
      <button class="ann-btn-discard" id="ann-discard">Cancel</button>
      <button class="ann-btn-save"    id="ann-save">Save</button>
    </div>
  </div>
</div>

<div class="ann-backdrop" id="ann-backdrop"></div>

<div class="ann-panel" id="ann-panel">
  <div class="ann-panel-header">
    <div class="ann-panel-heading">Feedback</div>
    <button class="ann-panel-close" id="ann-panel-close" aria-label="Close">&#x2715;</button>
  </div>
  <div class="ann-panel-sub">Copy the output below and paste it into Claude Code to continue iteration.</div>

  <div class="ann-list-section">
    <div class="ann-section-label">Annotations</div>
    <div class="ann-list-scroll" id="ann-list"></div>
  </div>

  <div class="ann-divider"></div>

  <div class="ann-q-section">
    <div class="ann-section-label">Questions</div>
    <div id="ann-q-list"></div>
    <div class="ann-q-add">
      <input type="text" id="ann-q-input" placeholder="Add a question...">
      <button class="ann-q-add-btn" id="ann-q-add-btn" aria-label="Add question">+</button>
    </div>
  </div>

  <div class="ann-divider"></div>

  <div class="ann-disp-section">
    <div class="ann-section-label">Disposition</div>
    <div class="ann-disp-btns">
      <button class="ann-disp-btn d-approve" id="ann-disp-approve">Approve</button>
      <button class="ann-disp-btn d-revise"  id="ann-disp-revise">Revise</button>
      <button class="ann-disp-btn d-reject"  id="ann-disp-reject">Reject</button>
    </div>
    <textarea class="ann-disp-note" id="ann-disp-note" placeholder="What needs to change?"></textarea>
  </div>

  <div class="ann-divider"></div>

  <div class="ann-output-section">
    <div class="ann-output-block" id="ann-output"></div>
    <button class="ann-copy-btn" id="ann-copy">Copy to Clipboard</button>
  </div>
</div>

<script>
(function () {
  var SK  = 'ann-v1-' + location.pathname;
  var SQK = SK + '-q';
  var SDK = SK + '-disp';
  var FILENAME = location.href.split('/').pop().replace(/[?#].*$/, '') || 'prototype';

  // __BRIEF_QS__

  var annotations      = [];
  var questions        = BRIEF_QS.map(function(q) { return { id: q.id, type: q.type, options: (q.options || []).slice(), answer: q.answer, text: q.text, removable: q.removable }; });
  var disposition      = null;
  var dispNote         = '';
  var mode             = 'annotating';
  var panelOpen        = false;
  var activeEl         = null;
  var hoveredEl        = null;
  var pins             = [];
  var pinRepositioners = [];
  var editingId        = null;

  var segAnnotate = gi('ann-seg-annotate');
  var segView     = gi('ann-seg-view');
  var countEl     = gi('ann-count');
  var qBadge      = gi('ann-q-badge');
  var ctaBtn      = gi('ann-cta');
  var panel       = gi('ann-panel');
  var backdrop    = gi('ann-backdrop');
  var closeBtn    = gi('ann-panel-close');
  var popover     = gi('ann-popover');
  var popHeading  = gi('ann-popover-heading');
  var textarea    = gi('ann-textarea');
  var saveBtn     = gi('ann-save');
  var discardBtn  = gi('ann-discard');
  var removeBtn   = gi('ann-remove');
  var annList     = gi('ann-list');
  var qListEl     = gi('ann-q-list');
  var qInput      = gi('ann-q-input');
  var qAddBtn     = gi('ann-q-add-btn');
  var dispApprove = gi('ann-disp-approve');
  var dispRevise  = gi('ann-disp-revise');
  var dispReject  = gi('ann-disp-reject');
  var dispNoteEl  = gi('ann-disp-note');
  var outputBlock = gi('ann-output');
  var copyBtn     = gi('ann-copy');

  function gi(id) { return document.getElementById(id); }

  // ── Init ────────────────────────────────────────────────────
  try {
    var sa = localStorage.getItem(SK);
    if (sa) {
      annotations = JSON.parse(sa);
      if (annotations.length) showToast(annotations.length + ' annotation' + (annotations.length === 1 ? '' : 's') + ' restored.');
    }
  } catch(e) {}

  try {
    var sq = localStorage.getItem(SQK);
    if (sq) {
      JSON.parse(sq).forEach(function(saved) {
        if (!saved.type) saved.type = 'binary';
        if (saved.answer === undefined) saved.answer = saved.checked ? true : null;
        if (!saved.options) saved.options = [];
        if (saved.type === 'binary' && typeof saved.answer === 'boolean') saved.answer = saved.answer ? 'yes' : null;
        var bq = questions.filter(function(q) { return q.id === saved.id; })[0];
        if (bq) {
          bq.answer = saved.answer;
        } else if (saved.removable !== false) {
          questions.push({ id: saved.id, type: saved.type, options: saved.options, answer: saved.answer, text: saved.text, removable: true });
        }
      });
    }
  } catch(e) {}

  try {
    var sd = localStorage.getItem(SDK);
    if (sd) { var d = JSON.parse(sd); disposition = d.verdict; dispNote = d.note || ''; }
  } catch(e) {}

  (function() {
    var _bp = parseInt(window.getComputedStyle(document.body).paddingTop, 10) || 0;
    document.body.style.paddingTop = (_bp + 48) + 'px';
  })();

  rebuildPins();
  updateCount();
  updateBadge();
  renderOutput();

  // ── Mode ────────────────────────────────────────────────────
  segAnnotate.addEventListener('click', function() { setMode('annotating'); });
  segView.addEventListener('click',     function() { setMode('viewing'); });

  function setMode(m) {
    mode = m;
    segAnnotate.classList.toggle('active', m === 'annotating');
    segView.classList.toggle('active',     m === 'viewing');
    pins.forEach(function(p) { p.style.opacity = m === 'viewing' ? '0' : '1'; });
    if (m === 'viewing') hidePopover();
  }

  // ── Panel ───────────────────────────────────────────────────
  ctaBtn.addEventListener('click',   function() { setPanel(!panelOpen); });
  closeBtn.addEventListener('click', function() { setPanel(false); });
  backdrop.addEventListener('click', function() { setPanel(false); });

  function setPanel(open) {
    panelOpen = open;
    panel.classList.toggle('open', open);
    document.body.classList.toggle('panel-open', open);
    backdrop.classList.toggle('visible', open);
    updateBarCenter();
    requestAnimationFrame(repositionPins);
    if (open) { renderAnnotationList(); renderQuestions(); renderDisposition(); renderOutput(); }
  }

  function updateBarCenter() {
    var panelW = (panelOpen && window.innerWidth >= 900) ? 360 : 0;
    document.documentElement.style.setProperty(
      '--bar-cx',
      panelW ? ((window.innerWidth - panelW) / 2) + 'px' : '50%'
    );
  }

  window.addEventListener('resize', function() { updateBarCenter(); repositionPins(); }, { passive: true });

  // ── Hover ───────────────────────────────────────────────────
  document.addEventListener('mouseover', function(e) {
    if (mode !== 'annotating') return;
    var el = e.target;
    if (isAnn(el) || el === document.body || el === document.documentElement) return;
    if (hoveredEl) hoveredEl.classList.remove('ann-hovered');
    hoveredEl = el;
    el.classList.add('ann-hovered');
  });

  document.addEventListener('mouseout', function(e) {
    if (hoveredEl && e.target === hoveredEl) {
      hoveredEl.classList.remove('ann-hovered');
      hoveredEl = null;
    }
  });

  // ── Click to annotate ───────────────────────────────────────
  document.addEventListener('click', function(e) {
    if (mode !== 'annotating') return;
    var el = e.target;
    if (isAnn(el) || el === document.body || el === document.documentElement) return;
    e.preventDefault();
    e.stopPropagation();
    if (hoveredEl) { hoveredEl.classList.remove('ann-hovered'); hoveredEl = null; }

    var selector = getSelector(el);
    var existing = annotations.filter(function(a) { return a.element.selector === selector; })[0];

    if (existing) {
      editingId = existing.id;
      activeEl  = null;
      popHeading.textContent = 'Edit Annotation';
      textarea.value = existing.comment;
      removeBtn.classList.add('visible');
    } else {
      editingId = null;
      activeEl  = el;
      popHeading.textContent = 'Add Annotation';
      textarea.value = '';
      removeBtn.classList.remove('visible');
    }
    showPopoverAt(e.clientX, e.clientY);
  }, true);

  function showPopoverAt(cx, cy) {
    var pw = 280;
    var panelW = (panelOpen && window.innerWidth >= 900) ? 360 : 0;
    var left = cx + 12;
    var top  = cy + 12;
    popover.style.visibility = 'hidden';
    popover.style.display = 'block';
    var ph = popover.getBoundingClientRect().height || 168;
    if (left + pw > window.innerWidth - panelW - 8) left = cx - pw - 12;
    if (left < 8) left = 8;
    if (top + ph > window.innerHeight - 8) top = cy - ph - 12;
    if (top < 56) top = 56;
    popover.style.left = left + 'px';
    popover.style.top  = top  + 'px';
    popover.style.visibility = '';
    textarea.focus();
  }

  function hidePopover() {
    popover.style.display = 'none';
    activeEl  = null;
    editingId = null;
    removeBtn.classList.remove('visible');
  }

  discardBtn.addEventListener('click', hidePopover);

  removeBtn.addEventListener('click', function() {
    if (!editingId) return;
    annotations = annotations.filter(function(x) { return x.id !== editingId; });
    persist(); rebuildPins(); updateCount();
    if (panelOpen) { renderAnnotationList(); renderOutput(); }
    hidePopover();
  });

  document.addEventListener('keydown', function(e) { if (e.key === 'Escape') hidePopover(); });

  // ── Save ────────────────────────────────────────────────────
  saveBtn.addEventListener('click', function() {
    var comment = textarea.value.trim();
    if (!comment) return;
    if (editingId) {
      var a = annotations.filter(function(x) { return x.id === editingId; })[0];
      if (a) a.comment = comment;
    } else {
      if (!activeEl) return;
      annotations.push({
        id: Date.now().toString(),
        timestamp: new Date().toISOString(),
        element: { selector: getSelector(activeEl), label: getLabel(activeEl) },
        comment: comment
      });
    }
    persist();
    rebuildPins();
    updateCount();
    if (panelOpen) { renderAnnotationList(); renderOutput(); }
    hidePopover();
  });

  // ── Pins ────────────────────────────────────────────────────
  function rebuildPins() {
    pinRepositioners.forEach(function(fn) { window.removeEventListener('scroll', fn); });
    pins.forEach(function(p) { p.remove(); });
    pins = [];
    pinRepositioners = [];
    annotations.forEach(function(a, i) {
      var el;
      try { el = document.querySelector(a.element.selector); } catch(e) {}
      if (!el) return;
      var pin = document.createElement('div');
      pin.className = 'ann-pin';
      pin.textContent = i + 1;
      pin.title = a.element.label;
      pin.style.opacity = mode === 'viewing' ? '0' : '1';
      document.body.appendChild(pin);
      pins.push(pin);
      (function(target, p) {
        function pos() {
          var r = target.getBoundingClientRect();
          p.style.top  = (r.top  - 9) + 'px';
          p.style.left = (r.right - 9) + 'px';
        }
        pos();
        pinRepositioners.push(pos);
        window.addEventListener('scroll', pos, { passive: true });
      })(el, pin);
    });
  }

  function repositionPins() {
    pinRepositioners.forEach(function(fn) { fn(); });
  }

  // ── Annotation list ─────────────────────────────────────────
  function renderAnnotationList() {
    annList.innerHTML = '';
    if (!annotations.length) {
      annList.appendChild(mk('div', 'ann-list-empty', 'No annotations yet.'));
      return;
    }
    annotations.forEach(function(a, i) {
      var row  = mk('div', 'ann-list-row');
      var num  = mk('div', 'ann-list-num', String(i + 1));
      var text = mk('div', 'ann-list-text');
      text.appendChild(mk('span', 'ann-list-lbl', a.element.label));
      text.appendChild(mk('span', 'ann-list-cmt', a.comment));
      var acts = mk('div', 'ann-list-acts');

      var editBtn = mk('button', 'ann-icon-btn', '✎');
      editBtn.title = 'Edit';
      (function(ann) {
        editBtn.addEventListener('click', function() {
          editingId = ann.id;
          activeEl  = null;
          popHeading.textContent = 'Edit Annotation';
          textarea.value = ann.comment;
          removeBtn.classList.add('visible');
          var cx = window.innerWidth / 2 - ((panelOpen && window.innerWidth >= 900) ? 180 : 0);
          showPopoverAt(cx, window.innerHeight / 2);
        });
      })(a);

      var rmBtn = mk('button', 'ann-icon-btn ann-danger', '×');
      rmBtn.title = 'Remove';
      (function(id) {
        rmBtn.addEventListener('click', function() {
          annotations = annotations.filter(function(x) { return x.id !== id; });
          persist(); rebuildPins(); updateCount();
          renderAnnotationList(); renderOutput();
        });
      })(a.id);

      acts.appendChild(editBtn);
      acts.appendChild(rmBtn);
      row.appendChild(num); row.appendChild(text); row.appendChild(acts);
      annList.appendChild(row);
    });
  }

  // ── Questions ───────────────────────────────────────────────
  function renderQuestions() {
    qListEl.innerHTML = '';
    questions.forEach(function(q) { qListEl.appendChild(buildQuestionItem(q)); });
    qListEl.classList.toggle('ann-q-list-filled', questions.length > 0);
  }

  function buildQuestionItem(q) {
    var item = mk('div', 'ann-q-item');
    var row  = mk('div', 'ann-q-row');
    var txt = mk('span', 'ann-q-text', q.text);

    row.appendChild(txt);

    if (q.removable !== false) {
      var rm = mk('button', 'ann-icon-btn ann-danger', '×');
      rm.title = 'Remove'; rm.style.flexShrink = '0';
      (function(question) {
        rm.addEventListener('click', function() {
          questions = questions.filter(function(x) { return x.id !== question.id; });
          persistQ(); renderQuestions(); updateBadge(); renderOutput();
        });
      })(q);
      row.appendChild(rm);
    }

    item.appendChild(row);

    if (q.type === 'binary') {
      var binGroup = mk('div', 'ann-q-options');
      ['yes', 'no'].forEach(function(opt) {
        var lbl = mk('label', 'ann-q-option');
        var rad = document.createElement('input');
        rad.type = 'radio'; rad.name = 'annqr-' + q.id; rad.value = opt;
        rad.checked = q.answer === opt;
        rad.style.accentColor = '#1a1a1a';
        (function(question, radio, option) {
          radio.addEventListener('change', function() { question.answer = option; persistQ(); updateBadge(); renderOutput(); });
        })(q, rad, opt);
        lbl.appendChild(rad);
        lbl.appendChild(document.createTextNode(opt === 'yes' ? 'Yes' : 'No'));
        binGroup.appendChild(lbl);
      });
      item.appendChild(binGroup);
    } else if (q.type === 'open') {
      var wrap = mk('div', 'ann-q-answer-wrap');
      var inp  = document.createElement('input');
      inp.type = 'text'; inp.className = 'ann-q-answer-input';
      inp.placeholder = 'Your answer...';
      inp.value = q.answer || '';
      (function(question, input) {
        input.addEventListener('input', function() { question.answer = input.value; persistQ(); updateBadge(); renderOutput(); });
      })(q, inp);
      wrap.appendChild(inp);
      item.appendChild(wrap);
    } else if (q.type === 'single') {
      var og = mk('div', 'ann-q-options');
      q.options.forEach(function(opt) {
        var lbl = mk('label', 'ann-q-option');
        var rad = document.createElement('input');
        rad.type = 'radio'; rad.name = 'annqr-' + q.id; rad.value = opt;
        rad.checked = q.answer === opt;
        rad.style.accentColor = '#1a1a1a';
        (function(question, radio, option) {
          radio.addEventListener('change', function() { question.answer = option; persistQ(); updateBadge(); renderOutput(); });
        })(q, rad, opt);
        lbl.appendChild(rad);
        lbl.appendChild(document.createTextNode(opt));
        og.appendChild(lbl);
      });
      item.appendChild(og);
    } else if (q.type === 'multi') {
      var og2 = mk('div', 'ann-q-options');
      var cur = Array.isArray(q.answer) ? q.answer : [];
      q.options.forEach(function(opt) {
        var lbl2 = mk('label', 'ann-q-option');
        var chk  = document.createElement('input');
        chk.type = 'checkbox'; chk.value = opt;
        chk.checked = cur.indexOf(opt) !== -1;
        chk.style.accentColor = '#1a1a1a';
        (function(question, checkbox, option) {
          checkbox.addEventListener('change', function() {
            var a = Array.isArray(question.answer) ? question.answer.slice() : [];
            if (checkbox.checked) { if (a.indexOf(option) === -1) a.push(option); }
            else { var idx = a.indexOf(option); if (idx !== -1) a.splice(idx, 1); }
            question.answer = a;
            persistQ(); updateBadge(); renderOutput();
          });
        })(q, chk, opt);
        lbl2.appendChild(chk);
        lbl2.appendChild(document.createTextNode(opt));
        og2.appendChild(lbl2);
      });
      item.appendChild(og2);
    }
    return item;
  }

  function doAddQuestion() {
    var text = qInput.value.trim();
    if (!text) return;
    questions.push({ id: 'uq-' + Date.now(), type: 'open', options: [], answer: '', text: text, removable: true });
    persistQ(); renderQuestions(); updateBadge(); renderOutput();
    qInput.value = '';
    qInput.focus();
  }

  qAddBtn.addEventListener('click', doAddQuestion);
  qInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') { e.preventDefault(); doAddQuestion(); } });

  // ── Disposition ─────────────────────────────────────────────
  [['approve', dispApprove], ['revise', dispRevise], ['reject', dispReject]].forEach(function(pair) {
    pair[1].addEventListener('click', function() {
      disposition = disposition === pair[0] ? null : pair[0];
      persistDisp(); renderDisposition(); renderOutput();
    });
  });

  dispNoteEl.addEventListener('input', function() {
    dispNote = dispNoteEl.value;
    persistDisp(); renderOutput();
  });

  function renderDisposition() {
    dispApprove.classList.toggle('active', disposition === 'approve');
    dispRevise.classList.toggle('active',  disposition === 'revise');
    dispReject.classList.toggle('active',  disposition === 'reject');
    var showNote = disposition === 'revise' || disposition === 'reject';
    dispNoteEl.classList.toggle('visible', showNote);
    if (showNote && !dispNoteEl.value && dispNote) dispNoteEl.value = dispNote;
  }

  // ── Output ──────────────────────────────────────────────────
  function renderOutput() {
    var date = new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
    var lines = ['## Prototype Feedback', '**File:** ' + FILENAME + '  ·  **Session:** ' + date];

    if (disposition) {
      var dLabel = disposition.toUpperCase();
      var noteText = dispNote.trim();
      lines.push(noteText ? '**Disposition:** ' + dLabel + ' — ' + noteText : '**Disposition:** ' + dLabel);
    }

    lines.push('');

    if (!annotations.length) {
      lines.push('*No annotations yet.*');
    } else {
      annotations.forEach(function(a, i) {
        lines.push('### [' + (i + 1) + '] ' + a.element.label);
        lines.push('**Selector:** `' + a.element.selector + '`');
        lines.push('**Feedback:** ' + a.comment);
        lines.push('');
      });
    }

    if (questions.length) {
      var typeTags = { binary: 'Binary', open: 'Open-ended', single: 'Single select', multi: 'Multi-select' };
      lines.push('### Questions');
      questions.forEach(function(q, i) {
        lines.push('**[Q' + (i + 1) + ' — ' + (typeTags[q.type] || q.type) + ']** ' + q.text);
        if (q.type === 'binary') {
          var binAns = typeof q.answer === 'string' ? q.answer : (q.answer ? 'yes' : null);
          lines.push('→ ' + (binAns ? binAns.charAt(0).toUpperCase() + binAns.slice(1) : 'No answer'));
        } else if (q.type === 'open') {
          var ans = (q.answer || '').trim();
          lines.push('→ ' + (ans || 'No answer provided'));
        } else if (q.type === 'single') {
          lines.push('→ ' + (q.answer ? 'Selected: ' + q.answer : 'No selection'));
          if (q.options.length) lines.push('   Options: ' + q.options.join(' | '));
        } else if (q.type === 'multi') {
          var sel = Array.isArray(q.answer) && q.answer.length ? q.answer.join(', ') : null;
          lines.push('→ ' + (sel ? 'Selected: ' + sel : 'No selection'));
          if (q.options.length) lines.push('   Options: ' + q.options.join(' | '));
        }
        lines.push('');
      });
    }

    lines.push('---');
    var n = annotations.length;
    lines.push('*' + n + ' annotation' + (n === 1 ? '' : 's') + '. Paste this block directly into your Claude Code prompt.*');
    outputBlock.textContent = lines.join('\n');
  }

  // ── Copy ────────────────────────────────────────────────────
  copyBtn.addEventListener('click', function() {
    var text = outputBlock.textContent;
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(
        function() { flash('ann-copied', 'Copied!', 2000); },
        function() { fallbackCopy(text); }
      );
    } else {
      fallbackCopy(text);
    }
  });

  function fallbackCopy(text) {
    flash('ann-failed', 'Copy failed — select all', 3000);
    var r = document.createRange();
    r.selectNodeContents(outputBlock);
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(r);
  }

  function flash(cls, label, ms) {
    copyBtn.textContent = label;
    copyBtn.classList.add(cls);
    setTimeout(function() { copyBtn.textContent = 'Copy to Clipboard'; copyBtn.classList.remove(cls); }, ms);
  }

  // ── Counters ────────────────────────────────────────────────
  function updateCount() {
    var n = annotations.length;
    countEl.textContent = n === 0 ? 'No annotations' : n === 1 ? '1 annotation' : n + ' annotations';
  }

  function questionAnswered(q) {
    if (q.type === 'binary') return !!q.answer;
    if (q.type === 'open') return !!(q.answer && q.answer.trim());
    if (q.type === 'single') return !!q.answer;
    if (q.type === 'multi') return Array.isArray(q.answer) && q.answer.length > 0;
    return false;
  }

  function updateBadge() {
    var n = questions.filter(function(q) { return !questionAnswered(q); }).length;
    if (n === 0) { qBadge.style.display = 'none'; return; }
    qBadge.style.display = '';
    qBadge.textContent = n + ' open question' + (n === 1 ? '' : 's');
  }

  // ── Persistence ─────────────────────────────────────────────
  function persist()     { try { localStorage.setItem(SK,  JSON.stringify(annotations)); } catch(e) {} }
  function persistQ()    { try { localStorage.setItem(SQK, JSON.stringify(questions));   } catch(e) {} }
  function persistDisp() { try { localStorage.setItem(SDK, JSON.stringify({ verdict: disposition, note: dispNote })); } catch(e) {} }

  // ── Helpers ─────────────────────────────────────────────────
  function isAnn(node) {
    return node.closest && node.closest('#ann-popover, .ann-bar, #ann-panel, .ann-pin, .ann-toast, .ann-backdrop');
  }

  function getSelector(node) {
    if (node.id) return '#' + node.id.replace(/([^\w-])/g, '\\$1');
    var tag     = node.tagName.toLowerCase();
    var classes = Array.prototype.slice.call(node.classList).filter(function(c) { return c !== 'ann-hovered' && c !== 'selected'; }).slice(0, 2);
    if (classes.length) {
      var sel = tag + '.' + classes.join('.');
      if (document.querySelectorAll(sel).length === 1) return sel;
    }
    var parent  = node.parentElement;
    if (!parent || parent === document.body) return tag;
    var same = Array.prototype.slice.call(parent.children).filter(function(c) { return c.tagName === node.tagName; });
    var idx  = same.indexOf(node) + 1;
    return getSelector(parent) + ' > ' + tag + (same.length > 1 ? ':nth-of-type(' + idx + ')' : '');
  }

  function getLabel(node) {
    return node.getAttribute('aria-label')
      || (node.innerText && node.innerText.replace(/\s+/g, ' ').trim().slice(0, 60))
      || node.getAttribute('placeholder')
      || node.tagName.toLowerCase();
  }

  function mk(tag, cls, text) {
    var e = document.createElement(tag);
    e.className = cls;
    if (text !== undefined) e.textContent = text;
    return e;
  }

  function showToast(msg) {
    var t = document.createElement('div');
    t.className = 'ann-toast'; t.textContent = msg;
    document.body.appendChild(t);
    setTimeout(function() { t.remove(); }, 3800);
  }

})();
</script>
<!-- ann-overlay-end -->
```

---

## Question generation principles

When reading a brief:

- **Prefer open questions** when the answer depends on the reviewer's read of the design — no right answer, just a judgment call
- **Use binary** for a clear yes/no that the reviewer can answer by looking at the screen (not reading documentation)
- **Use single select** when there are 2–4 mutually exclusive positions the reviewer should choose between
- **Use multi-select** when multiple items from a defined set may apply simultaneously

Avoid generic usability questions ("Is this clear?", "Is the hierarchy right?"). Every question should name something specific to the brief's stated problem or user.

---

## Notes

- The overlay uses `var` and function declarations for maximum browser compatibility — no transpilation required
- All animation and transition keyframe names are prefixed `ann-` to avoid collisions with the target prototype's CSS
- The `localStorage` key includes `ann-v1-` prefix to allow future schema migrations without data corruption
- The `isAnn()` guard prevents the annotation click handler from capturing events on the overlay's own elements
