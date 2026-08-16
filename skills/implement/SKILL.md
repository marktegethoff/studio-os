---
description: "Engineering workflow — spec through verified build. Reads project-context stack and runs declared build and test commands."
argument-hint: "<optional — usually the brief is already in context from /scope>"
---

Run the engineering blueprint against a task brief.

Arguments: $ARGUMENTS

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Auto Mode

If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.

---

## Project Context

Read project context in this order:

1. Read `.claude/memory/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand, and the **Engineering** block: `stack`, `code_root`, `build`, `test` (the project's own commands and paths). Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from the project's decision ledger (`decisions/`) by name. Do not scan the full directory.
3. If `.claude/memory/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project declares its stack, paths, and build/test commands in **one place** — project-context. This skill never hardcodes them. The project provides the specifics; you provide the discipline.

---

## Blueprint Architecture

This skill is a **hybrid blueprint**: deterministic nodes and agentic nodes, alternating.

- **Deterministic nodes [Det]** invoke a script via the Bash tool. They produce unambiguous pass/fail. No interpretation. No "I think it built." If the script exits 0, the node passed. If it exits non-zero, the node failed. Do not summarize, paraphrase, or skip these.
- **Agentic nodes [Ag]** apply reasoning — write code, diagnose failures, generate test scenarios.

The bounded retry rule: if a deterministic verification fails, exactly **one** agentic fix attempt is allowed, then the same deterministic node runs again. If it fails a second time, **escalate** — do not attempt a third fix.

---

## Engineer Discipline

The stack discipline is **not embedded here** — it lives in the project's **engineer specialist**, selected by the `stack` field in project-context (e.g. `swift-engineer`, `web-engineer`, or the stack-neutral `engineer` base). Apply that specialist in Step 2; it carries the platform's conventions — view/preview requirements, the test/snapshot setup and its helper, framework guarantees, and the artifact paths that produce review PNGs.

Universal rules (every stack):
- Each step touches one behavior. Verify before proceeding.
- Do not introduce unnecessary abstractions. Three similar lines beat a premature helper.
- Do not add error handling for scenarios that cannot happen. Trust the platform's guarantees internally.
- Produce the verification artifacts the specialist defines (tests, snapshots, previews) so `/studio:feedback` can render the result.

### QA Discipline
Purpose: validate behavior.
Responsibilities: test scenarios, regression tests, invariant verification.

---

## Context

Argument (optional): $ARGUMENTS

---

## [Det] Step 0 — Task brief required

Implementation requires a task brief produced by `/scope`. Without one, implementation runs without a verifiable contract.

Check conversation context for a task brief in the canonical format:

```
BRIEF: <title>

SPEC      <...>
OUTPUT    <...>
GATES     <...>
VERIFY    <...>
ESCALATE  <...>
```

If no brief is present, stop. State:

> "Implementation requires a task brief. Run `/scope <task>` first.
>
> A brief defines: spec, output, gates, verification, and escalation triggers. It is the contract that lets implementation run unattended.
>
> If the task is too loose to scope, run `/shape` (problem unclear) or `/design` (no spec) first."

End the skill.

If a brief is present, validate it:

1. **SPEC** — if a path, confirm the file exists. If inline, confirm it describes the work concretely.
2. **OUTPUT** — confirm the expected files/artifacts are named.
3. **GATES** — confirm at least one gate is listed.
4. **VERIFY** — confirm the verification method is concrete.
5. **ESCALATE** — confirm at least one trigger is listed.

If any field is malformed, stop and ask the user to revise via `/scope`.

---

## [Ag] Step 0.5 — Engineering handoff check

If the brief's SPEC field points to a file, check whether the spec includes a complete engineering handoff — component states, design token names, motion parameters, accessibility strings.

If the handoff is incomplete:

> "Spec at `<path>` is missing `<section>`. The engineer will need to make visual judgment calls. Either accept the risk or run `/design` to complete the spec first."

Do not block if the user accepts the risk. But name the gap.

---

> **⏸ PAUSE (skipped in --auto) — Brief loaded.**
> Steps 0–0.5 complete.
> Reply **"continue"** when ready.

---

## [Ag] Step 1 — Restate the contract

Before writing any code, restate the brief's GATES as the "what must not break" list. These are the invariants. Implementation that violates a gate is implementation that failed.

State this list explicitly so the user sees what you understand the contract to be.

---

## [Ag] Step 2 — Engineering

Apply the project's engineer specialist (per `stack` in project-context — e.g. `swift-engineer`, `web-engineer`, or the `engineer` base).

Each step touches one behavior. Verify before proceeding.

If during implementation you discover that a gate would have to be violated to complete the work, stop. This is an ESCALATE trigger from the brief. Surface the conflict and wait for direction.

When implementation is complete (code written, files saved), proceed to Step 3.

---

## [Det] Step 3 — Build verify

Run the project's declared **build** command(s) — the `build` field in project-context. If the project declares more than one build target (e.g. app + prototype), determine which to run from the changed files via `git diff --name-only HEAD` mapped against `code_root`, and run the matching target(s).

Invoke the declared command(s) via the Bash tool, exactly as project-context declares them.

If the command exits 0, the build passed — proceed.
If it exits non-zero, the build failed — proceed to Step 3a.

Do not interpret partial output as success. Trust the exit code only.

---

## [Ag] Step 3a — Build fix (one attempt)

The build failed. Read the filtered diagnostics from the script's stderr output. Identify the root cause. Make exactly **one focused fix**.

Do not rewrite unrelated code. Do not refactor. Address the specific failure named in the diagnostics.

Then return to Step 3b.

---

## [Det] Step 3b — Build re-verify

Re-invoke the same declared build command that failed in Step 3.

If the script exits 0, the build passed — proceed to Step 4.

If the script exits non-zero a second time, **stop**. This is an ESCALATE trigger. Report:

```
BLUEPRINT HALTED: build verification failed twice
Failed script: <path>
First failure diagnostics: <summary>
Second failure diagnostics: <summary>
Fix attempted: <description>
```

End the skill. Do not attempt a third fix.

---

## [Det] Step 4 — Test verify (conditional)

Run the project's declared **test** command only if production code was modified — check `git diff --name-only HEAD` against `code_root` (excluding any preview/example-only paths the project names).

Invoke the declared `test` command via the Bash tool, exactly as project-context declares it.

If it exits 0, tests passed — proceed.
If it exits non-zero, tests failed — proceed to Step 4a.

---

## [Ag] Step 4a — Test fix (one attempt)

Tests failed. Read the diagnostics. Determine whether the failure is:

- A **regression** caused by your code change → fix the code.
- A **legitimate behavior change** the spec calls for → update the test to match the new expected behavior.

Make exactly **one focused fix**, then return to Step 4b.

If you cannot determine which case applies from the diagnostics, **stop** and escalate — do not guess.

---

## [Det] Step 4b — Test re-verify

Re-invoke the same declared test command.

If exit 0, tests passed — proceed to Step 5.

If exit non-zero a second time, **stop** with the same blueprint-halted report format from Step 3b.

---

## [Ag] Step 5 — QA scenarios

Apply the QA Engineer discipline.

For each behavior changed in Step 2, name the test scenarios that would prove the change correct:

- Happy path
- Edge cases relevant to this specific change
- Any invariant from the brief's GATES that the test suite does not already cover

If you identify a behavior that is not currently covered by tests and the brief required it, flag this in the report — do not silently pass it.

---

## [Det] Step 6 — Gate verify

For each gate in the brief's GATES list, verify it programmatically where possible.

If the project declares a gate-check mechanism in project-context (e.g. a gate-check script with named gate types), map each brief gate to it. Portable gate types most projects can support:

| Brief gate language                               | Gate type           |
|---------------------------------------------------|---------------------|
| "Not on main branch" / branch protection           | branch-not-main     |
| "Brand tokens only" / "No hardcoded color"          | no-hardcoded-color  |
| Scope boundary (a path that must not be modified)   | path-not-modified   |

For each applicable gate, invoke the project's gate-check with the matching type. Each invocation exits 0 on pass, non-zero on violation.

For gates that do not map to a script (spec-specific invariants, behavioral guarantees), verify them manually and state your verification method explicitly in the report.

If any gate fails, **stop**. Report the violation. Do not attempt to fix gate violations automatically — surface the conflict to the user.

---

## [Ag] Step 7 — Report

Produce a structured report against the brief:

```
BRIEF: <title>

SPEC      <path/inline> — implemented: <yes/partial/blocked>
OUTPUT    <expected> — produced: <list of actual files>
GATES     <each gate from brief>
          → <gate 1>: <PASS/FAIL with verification method>
          → <gate 2>: <PASS/FAIL with verification method>
VERIFY    Build:  <PASS/FAIL>
          Tests:  <PASS/FAIL/SKIPPED>
          QA:     <scenarios named, or invariant gaps flagged>
ESCALATE  <triggered: yes/no; which trigger if yes>
```

Plus:
- **Open risks** — anything that passed verification but might still be wrong (subtle behaviors, untested edge cases)
- **Judgment calls** — decisions made that were not explicitly in the spec
- **Files changed** — `git diff --name-only HEAD`

---

## Step 7.5 — Simplify offer (optional)

Ask the user:

> "**Run a simplify pass on the changed files?** Catches duplication, orphaned code, single-use abstractions, and convention drift before staging.
>
> Reply **'simplify'** to run it, **'skip'** to proceed to staging."

**If user replies 'simplify':**

Read the `simplify` skill at `~/.claude/skills/simplify/SKILL.md` and follow its steps from Step 1, passing the changed files from the report as the argument. After the simplify skill completes (it runs its own build verification), return here and proceed to Step 8.

**If user replies 'skip':** proceed to Step 8.

---

## [Det] Step 8 — Stage (do not commit)

Stage the changed files for review. Invoke via the Bash tool:

```
git add <each file from the report's "Files changed" list>
```

Then run:

```
git status
```

**Do not run `git commit`.** The user reviews the staged diff and commits manually.

---

## Step 8.5 — Review and hand off

After staging, ask:

> "Implementation complete. Files staged. How do you want to review?
>
> **'review'** — Full LT review (PM + CD + DE) before the feedback surface. Use for significant features or any time the work warrants PM/design/engineering sign-off.
> **'gather'** — Render the feedback surface directly (default).
> **'skip'** — Skip all review. Run `git diff --staged`, then `git commit` when ready."

**If user replies 'review':**

Read the `review` skill at `~/.claude/skills/review/SKILL.md` and follow its steps from Step 1, passing the brief, implementation summary, and changed files as context. After the review completes: if the verdict is SHIP or REVISE, proceed to the 'gather' path below. If REJECT, end the skill and surface the blocking findings — do not stage or render the feedback surface.

**If user replies 'gather' or anything else (default path):**

Read the `feedback` skill (surface mode) at `skills/feedback/SKILL.md` and follow its steps from Step 1. Pass the implementation context (task title, brief summary, build status, test status, files changed, summary, and 1–3 task-specific questions you'd ask the user) directly into the manifest construction step.

After `/studio:feedback` (surface mode) completes parsing the user's response block, return here for the disposition action defined by `/gather-feedback`'s Step 9. The `/gather-feedback` skill owns the disposition flow.

**If user replies 'skip':**

> "Skipping review. Run `git diff --staged` to see the diff. Run `git commit` to commit when ready, or `git reset` to unstage and discuss revisions."

End the skill.

---

## End

If `/studio:feedback` was skipped or has finished, the skill ends here. The user retains commit authority — no autonomous commits.

---

## Rules

**Determinism rule.** When a step is marked [Det], invoke the named script via the Bash tool exactly as written. Do not paraphrase, summarize the expected outcome, or claim "this would pass." Trust only the exit code.

**Bounded retry rule.** Each [Det] verification node permits exactly **one** [Ag] fix attempt. A second failure halts the blueprint. No third attempt.

**No autonomous commit rule.** Step 8 stages files. The user commits. This is non-negotiable for this blueprint.

**Escalation rule.** Any of the following halts the blueprint and surfaces to the user:
- Brief is malformed or absent (Step 0)
- Build fails twice (Step 3b)
- Tests fail twice (Step 4b)
- Test failure is ambiguous between regression vs. legitimate change (Step 4a)
- Any gate violation (Step 6)
- Any ESCALATE trigger from the brief surfaces during implementation
