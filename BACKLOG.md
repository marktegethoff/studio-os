# Studio OS — Backlog

Roadmap for the plugin itself (the engine). Consuming projects track their own work in their own `decisions/`; this file is only for Studio OS.

Rules that apply to every item: a new skill or agent ships with an eval (the coverage rule in `CLAUDE.md`), and a shipped change bumps the plugin version so `claude plugin update` carries it.

Roughly priority-ordered.

---

## 1. `organize` skill — *not built*

Scaffold and reconcile the canonical project layout (see `STRUCTURE.md`): one `code_root` (default `code/` with per-codebase subdirs, or `app/`) + flat output folders `decisions/ specs/ design/ reviews/`, with context in `.claude/memory/`.

- **Two modes:** *scaffold* (new/empty project) and *reconcile* (sort an existing project, list what to move, fix `CLAUDE.md`).
- **Owner:** `architect` (structure is its charter) — not a new agent.
- **First real use:** reorganize LogApp's `studio_os/` into the flat folders (carefully — Xcode/tooling paths).
- **Open question:** spec-first (brief + eval, then build) vs. prototype-on-LogApp (build, run reconcile as its first test, then harden).
- Needs a brief + an eval per the coverage rule.

## 2. Run the full eval suite live — *built, never run end-to-end*

`evals/` exists (per-area files + README runner) and was sampled behaviorally, but the whole suite has not been executed start-to-finish. Run it, reconcile the live roster/skill set against the coverage table, fix anything that surfaces.

## 3. Release / version discipline — *process gap*

The marketplace install is version-pinned: editing the repo does not propagate until the version bumps (`claude plugin update` reports "already latest"). Define a lightweight release step — bump `plugin.json` + `marketplace.json` version (semver), tag, push — so updates are reliable for any consumer. Document `--plugin-dir` as the dev-only escape hatch.

## 4. Consolidate `lt-review` ≡ `review` — *duplicate*

Both `skills/lt-review/` and `skills/review/` exist and overlap (leadership-team combined verdict). Pick one, redirect the other, update references. Reduction.

## 5. Skill-listing budget friction — *27 skills*

With this many skills a session can truncate its auto-surfaced list (every skill still invokes by exact name). Mitigation is documented (`skillListingBudgetFraction: 0.02` in `MIGRATE.md`). Consider whether the real fix is fewer/consolidated skills (see #4) rather than a settings bump.

## 6. Confirm install-time persona / display-name customization

`init` carries personalization, but verify the agent display-name / persona override path (stable handles `cd`/`de`/`pm` + spelled-out display) is complete and documented end-to-end at setup.

---

## Done (reference)

- Plugin rename to `studio:` prefix; single-source cutover (flat agents/skills retired); stray `skills/SKILL.md` discovery bug fixed; `CULTURE.md` migrated; flat project layout locked in `STRUCTURE.md`; promoted to `main`. (2026-05-25)
- Scene Test wired into `cd` / `designer` agents + evals.
