---
description: "[DEPRECATED — merged into /studio:shape --task] Task scoped tight enough to delegate. Produces a task brief (HTML) with acceptance criteria and explicit out-of-scope."
argument-hint: "<rough task description>"
artifact: task-brief
---

> **⚠️ DEPRECATED.** Merged into `/studio:shape --task` (same five-field task brief, same interview discipline, one briefing skill at two altitudes). This copy retires to `archive/skills/` next release.

Run the task scoping interview.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from the plugin's `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `decisions/` by name.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. This skill provides the discipline.

---

## Purpose

A task brief exists to answer one question before execution begins: is this task tight enough to run unattended?

The brief has five fields and no prose. If you cannot fill it in, the task is not ready to delegate — it needs `/shape` (problem unclear) or `/design` (no spec) first.

This skill interviews you. It does the reading and extraction work; you mostly confirm.

**Output:** a task brief in conversation context. Ephemeral — not written to disk.

---

## The Five Fields

```
SPEC      <path to spec, or inline description if infrastructure task>
OUTPUT    <exact artifact, file, or commit expected>
GATES     <what must not break — invariants, must-not-touch files>
VERIFY    <how the agent confirms success — build, render, artifact written>
ESCALATE  <triggers to stop and ask — ambiguity, gate violation, retry exhaustion>
```

---

## Context

Task: $ARGUMENTS

---

## Step 1 — What's the work?

Ask one question:

> "One-line title for this task. And: is there a spec? If yes, give me the path. If no, describe it in 2–3 sentences."

---

> **⏸ PAUSE (skipped in --auto) — Title and spec.**
> Provide a one-line title and either a spec path or a brief inline description.

---

## Step 2 — Read and assess

Reflect what you heard in Step 1 in one sentence.

If the user provided a spec path: read the file. Confirm it has a "What must not break" or invariants section, plus states/transitions/tokens as applicable. If the spec is missing required sections, name the gap explicitly:

> "Spec found at `<path>`, but `<section>` is missing. The brief can still be assembled, but verification will be weaker. Continue, or run `/design` to complete the spec first?"

If no spec exists and the task is **infrastructure** (hooks, scripts, config, tooling, internal documentation): proceed to Step 3.

If no spec exists and the task is a **product/UI feature**: stop. State:

> "This task needs a spec before it can be scoped. The brief assembles from a spec; without one, the agent has nothing to verify against.
>
> Run `/design <task>` first — it produces the spec the brief points at."

End the skill. Do not assemble a partial brief.

---

## Step 3 — What's the output?

Apply the auto-extract rule: propose a default based on the spec or task type.

- **Production code**: list the files you expect to create/modify, drawn from the spec
- **Canvas experiment**: `<canvas_path>/Experiments/<Name>.<ext>` (per the manifest's `code_root` + canonical `canvas/` name)
- **Hook**: `.claude/hooks/<name>.sh` + `.claude/settings.json` registration
- **Documentation/decision**: a flat-folder location per the canonical layout — `decisions/<file>.md`, `specs/<file>.md`, `design/<file>.md`, or `reviews/<file>.md`

Ask:

> "Proposed output: `<default>`. Confirm or adjust."

---

> **⏸ PAUSE (skipped in --auto) — Output.**
> Confirm the proposed output, or list the exact files/artifacts expected.

---

## Step 4 — Gates

Apply the auto-extract rule: pull from the spec's "What must not break" section. Add invariants from project context that apply to this task type — brand tokens, no production view edits during a design pass, no commits to `main`, etc.

Present the extracted gates:

> "Gates extracted from spec and project context:
> - `<gate 1>`
> - `<gate 2>`
> - `<gate 3>`
>
> Anything to add or remove?"

---

> **⏸ PAUSE (skipped in --auto) — Gates.**
> Confirm, add, or remove gates.

---

## Step 5 — Verify

Propose a default based on output type:

- **Swift production code**: `xcodebuild` for the relevant target succeeds
- **Canvas experiment**: build succeeds + preview renders without crash
- **Hook**: exits 0 on green path, exits 1 on red path, settings.json valid
- **Artifact**: file written, valid format, contains required sections

Ask:

> "Verification: `<proposed default>`. Confirm or extend."

---

> **⏸ PAUSE (skipped in --auto) — Verify.**
> Confirm the verification method or add additional checks.

---

## Step 6 — Escalate

Default escalation triggers (always include):

- Spec ambiguity discovered mid-implementation
- Build or test fails twice consecutively
- Any gate violation
- Scope expansion beyond the brief

Ask:

> "Default escalation triggers above. Add any task-specific triggers?"

---

> **⏸ PAUSE (skipped in --auto) — Escalation.**
> Confirm defaults or add task-specific escalation triggers.

---

## Step 7 — Assemble and confirm

Present the assembled brief in the canonical format:

```
BRIEF: <title>

SPEC      <path or inline>
OUTPUT    <files / artifacts>
GATES     <list>
VERIFY    <method>
ESCALATE  <triggers>
```

Ask:

> "Brief assembled. This is the input format for `/implement`. Reply **'locked'** to confirm, or name any field to revise."

---

> **⏸ PAUSE (skipped in --auto) — Brief review.**
> Reply **'locked'** to confirm, or revise a field.

---

## Step 8 — Path fork

On brief confirmation, ask the user which path the work should take:

> "Brief locked. Two paths:
>
> **`/prototype`** — validate visually in Canvas first. Recommended when: new feature, novel interaction, anything where 'feels right' matters more than correctness, or scope/direction needs visual confirmation before production work. Output goes to the project's `canvas/Experiments/` (per the manifest's `code_root`).
>
> **`/implement`** — go straight to production. Recommended when: clearly-spec'd change, small fix, infrastructure work, or refining something already validated in Canvas. Output goes to the project's production target (per the manifest's `code_root/app/`, or wherever the brief's OUTPUT points).
>
> Which?"

---

> **⏸ PAUSE (skipped in --auto) — Path selection.**
> Reply **`/prototype`** for Canvas validation first, or **`/implement`** for production direct. If unsure, the bias is toward prototype for anything new or visual.

---

## Step 9 — Hand off

On path selection, state:

> "Task brief locked in conversation context. Path: `<chosen>`.
>
> **Recommended next:** `<chosen path>` — the brief is the input."

If the user chose `/prototype`, **note in the brief**: the OUTPUT field should point to the project's `canvas/Experiments/<Name>.<ext>` (not production paths). Update if needed.

The brief stays in conversation context. The next execution skill reads it from there.

If the user replies ambiguously (anything other than `/prototype` or `/implement`), do not auto-pick. Re-ask the question.

---

## Rules

**Refusal rule.** If the task lacks a spec and is not infrastructure, stop. Recommend `/design` or `/shape`. Do not produce a half-brief.

**Auto-extract rule.** Read the spec yourself. Extract gates and propose verify/escalate from spec content and project invariants. Don't ask the user to write what's already in the spec.

**Reflection rule.** Before each new question, reflect what you heard in the prior answer in one sentence. This confirms understanding without belaboring it.

**Five fields rule.** No additional fields. No "Notes," no "Background," no "Rationale." If something doesn't fit the five fields, it doesn't belong in the brief — it belongs in the spec.

**Ephemeral rule.** The brief lives in conversation context as the execution contract for /implement or /prototype. It is also written to disk as an HTML artifact for human review — the two forms coexist. The HTML file is for visibility; the context version is what the execution skill reads.

**Approval gate rule.** The brief is not "locked" until the user explicitly says so. Do not advance to Step 8 without confirmation.

---

## Output

Render the artifact as HTML using the kit template.

1. Load `artifacts/templates/task-brief.html` as the structural shell.
2. Populate the artifact-specific fields: SPEC, OUTPUT, GATES, VERIFY, ESCALATE.
3. Write to `specs/task_brief_<slug>.html` where slug is derived from the task name (lowercase kebab-case, max 40 chars).
4. Surface a short markdown summary in conversation:
   - File path
   - One-sentence task description
   - OUTPUT and GATES fields
5. Offer: "Run `/studio:annotate <file-path>` to attach the feedback harness."

If `--text` is in $ARGUMENTS, skip HTML emission and present the markdown summary as the full output.
