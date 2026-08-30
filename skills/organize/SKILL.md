---
description: "Scaffold or reconcile the canonical Studio OS project layout. Creates decisions/, specs/, design/, and reviews/ in scaffold mode; proposes artifact moves in reconcile mode."
argument-hint: "[--reconcile to force reconcile mode on an existing project]"
artifact: decision-record
---

Scaffold or reconcile the project layout.

Arguments: $ARGUMENTS

---

## Mode detection

If `--reconcile` is in $ARGUMENTS: run Reconcile mode.

Otherwise: check whether the four output folders exist (`decisions/`, `specs/`, `design/`, `reviews/`). If all four exist: confirm to the user and exit (nothing to do). If any are missing: run Scaffold mode.

---

## Scaffold mode

Create any missing output folders with a `.gitkeep`:

- `decisions/` — the decision ledger; every choice and its rationale
- `specs/` — engineering handoff specs and framing documents
- `design/` — design artifacts (wireframes, motion specs, copy decks, briefs)
- `reviews/` — gate verdicts (PM · CD · DE)

Do not create `code/` — that is `/studio:init`'s territory.

Check `.claude/memory/project-context.md` if it exists:
- If `spec_path` is not `specs/`, propose updating it. Do not overwrite without confirmation (or in `--auto` mode, update and note it in the summary).
- If `decisions_path` is not `decisions/`, same.

After creating folders, write a decision record:

- **Template:** `artifacts/templates/decision-record.html`
- **Output path:** `decisions/<date>-layout.html` (date as YYYY-MM-DD)
- **Record:** which folders were created, whether project-context.md was updated, date

Confirm to the user:

> "Scaffolded: [list of folders created]. Decision record written to decisions/<date>-layout.html."

---

## Reconcile mode

Read the project to understand what exists and where.

### Step 1 — Scan

Scan the project root (non-recursively) and the top two levels of any non-canonical directories for studio artifacts:

- HTML files (`.html`) — likely design artifacts, specs, or reviews
- Markdown files (`.md`) that are not README, CLAUDE, PHILOSOPHY, STRUCTURE, CHANGELOG, BACKLOG, MIGRATE, EXAMPLES, or SECURITY — likely decisions or specs

**Do not scan or touch:**
- `code/`, `app/` — source code
- `.claude/`, `.git/`, `node_modules/`, `.xcode*/` — tooling
- Any file referenced by an Xcode `.xcodeproj`, `Package.swift`, `project.yml`, or `package.json` dependency graph

### Step 2 — Classify

For each artifact found outside the canonical folders, classify it:

| Type | Signals | Target folder |
|---|---|---|
| Decision | Filename contains `decision`, `adr`, `record`, `ledger`; or content has a "Decision:" or "Rationale:" heading | `decisions/` |
| Spec | Filename contains `spec`, `brief`, `requirement`, `handoff`; or content has a component spec or brief structure | `specs/` |
| Design artifact | HTML file using `studio.css`; wireframe, motion spec, copy deck | `design/` |
| Review | Filename contains `review`, `critique`, `verdict`; or content has SHIP/NO-SHIP/REVISE | `reviews/` |
| Unclassified | Does not match any signal | List separately; do not propose a move |

### Step 3 — Propose

Present the move plan to the user before touching anything:

```
Reconcile proposal — [N] artifacts

MOVE:
  [current path] → [target path]
  [current path] → [target path]
  ...

SKIP (unclassified — review manually):
  [path]
  ...

Source code and tooling paths are not touched.

Confirm? (yes / no / [adjust])
```

In `--auto` mode: do NOT execute moves. Write the proposal as a decision record artifact and stop. Moving files in an unattended run is too risky.

### Step 4 — Execute (interactive only)

On confirmation: execute the proposed moves (`mv`). Update `project-context.md` `spec_path` and `decisions_path` if the canonical paths are now in use.

Write a decision record of what was moved:

- **Template:** `artifacts/templates/decision-record.html`
- **Output path:** `decisions/<date>-reconcile.html`

---

## Auto Mode

If `--auto` appears in $ARGUMENTS:

- **Scaffold mode:** create missing folders and update project-context.md without confirmation. Write the decision record. Safe — only creates, never moves or deletes.
- **Reconcile mode:** scan and classify, write the proposal as a decision record artifact, then stop. Do NOT execute moves unattended.

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from the plugin's `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.
