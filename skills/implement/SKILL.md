---
description: Run the engineering workflow for a task brief. Requires a task brief produced by /scope as input — the brief defines spec, output, gates, verification, and escalation. Implementation runs end-to-end as a hybrid blueprint (deterministic + agentic nodes); the human re-enters at code review.
argument-hint: "<optional — usually the brief is already in context from /scope>"
---

Run the engineering blueprint against a task brief.

Arguments: $ARGUMENTS

**Model requirements:** [HAIKU] for brief validation · [SONNET] for implementation and QA

When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Project Context

Read project context in this order:

1. Read `studio_os/project-context.md` — product identity, governing principle, invariants, scope guardrails, brand. Load once; do not re-read mid-session.
2. If this work involves a prior decision, load the relevant file from `studio_os/ledger/decisions/` by name. Do not scan the full directory.
3. If `studio_os/project-context.md` does not exist, read `CLAUDE.md` for product context and state this clearly.

The project provides the specifics. You provide the discipline.

---

## Blueprint Architecture

This skill is a **hybrid blueprint**: deterministic nodes and agentic nodes, alternating.

- **Deterministic nodes [Det]** invoke a script via the Bash tool. They produce unambiguous pass/fail. No interpretation. No "I think it built." If the script exits 0, the node passed. If it exits non-zero, the node failed. Do not summarize, paraphrase, or skip these.
- **Agentic nodes [Ag]** apply reasoning — write code, diagnose failures, generate test scenarios.

The bounded retry rule: if a deterministic verification fails, exactly **one** agentic fix attempt is allowed, then the same deterministic node runs again. If it fails a second time, **escalate** — do not attempt a third fix.

---

## Engineer Discipline
Purpose: implement native iOS behaviors.
Responsibilities: SwiftUI views, gesture models, offline sync, performance.

Rules:
- Each step touches one behavior. Verify before proceeding.
- SwiftUI previews required on all new view files. Cover primary render state. Add variants for meaningful states.
- Do not introduce unnecessary abstractions. Three similar lines is better than a premature helper.
- Do not add error handling for scenarios that cannot happen. Trust GRDB and SwiftUI guarantees internally.

### Snapshot Test Requirement (production views)

For any new production view file under `Log/Log/Views/`, also create a snapshot test file at `Log/LogTests/<ViewName>SnapshotTests.swift` covering at minimum two variants:

- `<viewName>_light` — light mode, primary state
- `<viewName>_dark` — dark mode, primary state

Add 1–2 additional state variants when the view has meaningful internal state (focused, empty, loading, error). Snapshot names must start with the view name in camelCase, followed by underscore — this is how the runner script locates the produced PNGs.

Default snapshot size for full-screen views: `CGSize(width: 390, height: 844)`. For component-sized views, choose a size that matches their natural rendering (cells at row width × intrinsic height, etc.).

Use the existing helper at `Log/LogTests/Support/SnapshotHelper.swift`:

```swift
import XCTest
import SwiftUI
@testable import Log

final class <ViewName>SnapshotTests: XCTestCase {
    func test_<viewName>_light() {
        assertSnapshot(of: <ViewName>(...), named: "<viewName>_light",
                       size: CGSize(width: 390, height: 844),
                       colorScheme: .light)
    }

    func test_<viewName>_dark() {
        assertSnapshot(of: <ViewName>(...), named: "<viewName>_dark",
                       size: CGSize(width: 390, height: 844),
                       colorScheme: .dark)
    }
}
```

This test produces PNGs that `/gather-feedback` displays in the Review Surface.

### QA Engineer Discipline
Purpose: validate behavior.
Responsibilities: test scenarios, regression tests, invariant verification.

---

## Context

Argument (optional): $ARGUMENTS

---

## [HAIKU · Det] Step 0 — Task brief required

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

## [HAIKU · Ag] Step 0.5 — Engineering handoff check

If the brief's SPEC field points to a file, check whether the spec includes a complete engineering handoff — component states, design token names, motion parameters, accessibility strings.

If the handoff is incomplete:

> "Spec at `<path>` is missing `<section>`. The iOS Engineer will need to make visual judgment calls. Either accept the risk or run `/design` to complete the spec first."

Do not block if the user accepts the risk. But name the gap.

---

> **⏸ PAUSE — Model switch required.**
> Steps 0–0.5 complete; brief loaded. Switch to **[SONNET]** (`claude-sonnet-4-6`) before continuing.
> Reply **"continue"** when ready.

---

## [SONNET · Ag] Step 1 — Restate the contract

Before writing any code, restate the brief's GATES as the "what must not break" list. These are the invariants. Implementation that violates a gate is implementation that failed.

State this list explicitly so the user sees what you understand the contract to be.

---

## [SONNET · Ag] Step 2 — Engineering

Apply the iOS Engineer discipline (embedded above).

Each step touches one behavior. Verify before proceeding.

If during implementation you discover that a gate would have to be violated to complete the work, stop. This is an ESCALATE trigger from the brief. Surface the conflict and wait for direction.

When implementation is complete (code written, files saved), proceed to Step 3.

---

## [Det] Step 3 — Build verify

Determine which build to run based on changed files. Use `git diff --name-only HEAD` to identify modifications:

- If any file under `Log Canvas/` was modified, run **build-canvas**.
- If any file under `Log/Log/` (production app) was modified, run **build-app**.
- If both were modified, run both — Canvas first.

Invoke via the Bash tool, exactly:

**build-canvas:**
```
.claude/scripts/build-canvas.sh
```

**build-app:**
```
.claude/scripts/build-app.sh
```

If the script exits 0, the build passed — proceed.
If the script exits non-zero, the build failed — proceed to Step 3a.

Do not interpret partial output as success. Trust the exit code only.

---

## [SONNET · Ag] Step 3a — Build fix (one attempt)

The build failed. Read the filtered diagnostics from the script's stderr output. Identify the root cause. Make exactly **one focused fix**.

Do not rewrite unrelated code. Do not refactor. Address the specific failure named in the diagnostics.

Then return to Step 3b.

---

## [Det] Step 3b — Build re-verify

Re-invoke the same build script that failed in Step 3.

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

Run the test target only if production code was modified. Use `git diff --name-only HEAD` again:

- If any file under `Log/Log/` (excluding `Log/Log/Views/Previews/` if isolated) was modified, run **test-app**.
- Otherwise, skip Step 4 and proceed to Step 5.

Invoke via the Bash tool, exactly:

```
.claude/scripts/test-app.sh
```

This runs the `LogTests` target on the latest available iPhone simulator.

If the script exits 0, tests passed — proceed.
If the script exits non-zero, tests failed — proceed to Step 4a.

---

## [SONNET · Ag] Step 4a — Test fix (one attempt)

Tests failed. Read the diagnostics. Determine whether the failure is:

- A **regression** caused by your code change → fix the code.
- A **legitimate behavior change** the spec calls for → update the test to match the new expected behavior.

Make exactly **one focused fix**, then return to Step 4b.

If you cannot determine which case applies from the diagnostics, **stop** and escalate — do not guess.

---

## [Det] Step 4b — Test re-verify

Re-invoke `.claude/scripts/test-app.sh`.

If exit 0, tests passed — proceed to Step 5.

If exit non-zero a second time, **stop** with the same blueprint-halted report format from Step 3b.

---

## [SONNET · Ag] Step 5 — QA scenarios

Apply the QA Engineer discipline.

For each behavior changed in Step 2, name the test scenarios that would prove the change correct:

- Happy path
- Edge cases relevant to this specific change
- Any invariant from the brief's GATES that the test suite does not already cover

If you identify a behavior that is not currently covered by tests and the brief required it, flag this in the report — do not silently pass it.

---

## [Det] Step 6 — Gate verify

For each gate in the brief's GATES list, verify it programmatically where possible.

The script `.claude/scripts/gate-check.sh` supports four gate types. Map brief gates to script gates:

| Brief gate language                                         | Script invocation                                    |
|-------------------------------------------------------------|------------------------------------------------------|
| "No production view files modified"                         | `.claude/scripts/gate-check.sh no-production-views`  |
| "No Canvas edits" / "Production-only change"                | `.claude/scripts/gate-check.sh no-canvas-edits`      |
| "Brand tokens only" / "No hardcoded hex"                    | `.claude/scripts/gate-check.sh no-hardcoded-hex`     |
| "Not on main branch" / any branch protection                | `.claude/scripts/gate-check.sh branch-not-main`      |

For each applicable gate in the brief, invoke the corresponding script. Each script exits 0 on pass, 1 on violation.

For gates that do not map to a script (spec-specific invariants, behavioral guarantees), verify them manually and state your verification method explicitly in the report.

If any gate fails, **stop**. Report the violation. Do not attempt to fix gate violations automatically — surface the conflict to the user.

---

## [SONNET · Ag] Step 7 — Report

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

Read the `/gather-feedback` skill at `.claude/skills/gather-feedback/SKILL.md` and follow its steps from Step 1. Pass the implementation context (task title, brief summary, build status, test status, files changed, summary, and 1–3 task-specific questions you'd ask the user) directly into the manifest construction step.

After `/gather-feedback` completes parsing the user's response block, return here for the disposition action defined by `/gather-feedback`'s Step 9. The `/gather-feedback` skill owns the disposition flow.

**If user replies 'skip':**

> "Skipping review. Run `git diff --staged` to see the diff. Run `git commit` to commit when ready, or `git reset` to unstage and discuss revisions."

End the skill.

---

## End

If `/gather-feedback` was skipped or has finished, the skill ends here. The user retains commit authority — no autonomous commits.

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
