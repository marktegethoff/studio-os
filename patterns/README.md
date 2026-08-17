# Patterns — Solved Problems, Cited

A pattern is a **solved problem with provenance**: the platform's canonical answer to a recurring build question, captured as a compilable snippet with the standard it follows and the date it was last verified. The library exists so agents follow platform standards instead of re-deriving them — a re-solved solved problem is a defect, not diligence.

This is the code-side sibling of `artifacts/` (the kit): the kit keeps HTML output from being reinvented; the pattern library keeps platform idioms from being reinvented.

## How agents use it

- **Consult before solving.** The stack specialist reads `patterns/<stack>/INDEX.md` before implementing any UI problem. If a pattern covers it, start from the pattern and note the citation; departing from a pattern is a named decision with a reason. If no pattern covers it, solve it — and flag it as a harvest candidate.
- **Progressive disclosure.** Read the one-line INDEX always; open an individual pattern file only when it applies. Never load the whole library.
- **Cite by name** — "per `patterns/swift/sheet-with-detents`" — the way agents cite `anti-patterns.md` entries.

## Entry format

One file per pattern, required sections (lint R9):

```
# <name>
Problem:    <the recurring question, one sentence>
Standard:   <the platform rule it follows — memory/apple-platform.md §N, HIG area, or WWDC session>
Verified:   <YYYY-MM · OS version it was last confirmed against>

## Solution
<compilable snippet — minimal, idiomatic, no app-specific naming>

## Why this shape
<2–4 sentences: what the platform gives you for free here, and what the naive re-solve gets wrong>

## Prevents
<the anti-pattern or defect this exists to stop, one line>
```

## Lifecycle

- **Harvest** — the surveyor's sweep proposes candidates (new/changed platform idioms, WWDC introductions); any agent that solves an uncovered problem flags a candidate. Candidates land as proposals, not entries.
- **Verify** — an entry ships only after its snippet builds against the current toolchain; `Verified:` records the date and OS. Verification happens in a consuming project or scratch package, not by inspection.
- **Refresh** — the surveyor's platform sweep re-dates or amends entries when the platform moves; an entry older than one OS major is stale and flagged.
- **Retire** — superseded patterns move to `patterns/<stack>/archive/` with one line naming the successor. Nothing is silently deleted.

## Seams

Pattern files live outside the lint's stack-token scan (like `memory/`), so snippets are legal here and only here on the design side; agents reference patterns by path, never inline the code into their own files. Product names never appear — snippets use neutral naming per the R1 discipline.
