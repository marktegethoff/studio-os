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

## 7. Single-page marketing site — *not built*

A well-designed, branded one-pager for Studio OS, hosted on **GitHub Pages** (`docs/` or a `gh-pages` branch), linking to the repo (`github.com/marktegethoff/studio-os`) with the one-line marketplace install as the CTA. Branded in the **Standard Works** identity — Neue Haas Grotesk, black on warm white, Courier for technical labels, monochrome with at most one earned accent — the same system as the artifact kit (`artifacts/kit/studio.css`), so it reads as one house.

Functional anatomy (**problem → solution → proof → action**), modeled on the *function* of [impeccable.style](https://impeccable.style/) — a peer Claude Code skill plugin — not its visuals:

- **Hero** — name the pain (design-by-default; AI "slop") + the studio's value in *its own* terms: multi-discipline rigor, gated judgment, work that feels inevitable. (Do **not** use Log's "AI as instrument, not author" — that's a product invariant, not a studio principle.)
- **Foundation** — the ethos: work must feel inevitable (Standard Works).
- **The studio** — 35 disciplines, the Six Functions, the PM → CD → DE gates.
- **Workflows** — the slash commands (`/design`, `/discover`, `/implement`, `/critique`, `/review`, `/solve`…).
- **Artifacts** — the designed-HTML kit + annotation harness (the real differentiator — show, don't tell).
- **Proof** — the quality floor (Slop Test) and/or a before/after.
- **Get Started** — `claude plugin marketplace add …` → `claude plugin install studio@standard-works`.
- **Footer** — repo link, version, Standard Works.

**Dogfooding option:** build it through the studio's own `/design` workflow — the studio designing its own storefront is itself a proof point. This is the public face of "a 10/10 I'd be proud to market," so it likely deserves higher priority than its slot here.

## 8. Named anti-pattern catalog — *extends the Slop Test*

impeccable names its failure modes ("Gallery of Shame": purple gradients, cardocalypse). Studio OS already lists anti-patterns in `CLAUDE.md` / the ethos and has the Slop Test — turn them into a **named, citable catalog** agents reference by name (`critic`, `cd`, `studio-slop`). Each entry: the name, the tell, why it fails, the correction. Doubles as the "proof" section of the marketing site (#7). Working reference first; visual gallery second.

## 9. `CHANGELOG.md` — *user-facing release notes*

A human-readable changelog (impeccable surfaces one prominently). Pairs with the release/version discipline (#3): each version bump appends a short entry. Distinct from the decision ledger — this is "what changed for users," not "why we decided."

## 10. Standalone CLI / generator ("Live Mode") — *to explore*

A standalone tool that generates — variants, or the studio's design vocabulary applied to produce output — usable outside a Claude Code session and by others. Mark wants this; plenty exist in-market but it could still earn its place.

Not a rejection — an open question: today the studio *reasons, critiques, and specifies* rather than generating. A generator is a genuine expansion of what Studio OS is, so it deserves a Strategist/PM pass on shape before any build: does the studio itself generate, or does a separate "Live Mode" companion generate *under* the studio's disciplines and gates? Settle the position, then scope.

### Considered, not pursuing (for now)

- **Browser/Chrome extension** — Studio OS doesn't operate on web pages; out of scope for now.

---

## Done (reference)

- Plugin rename to `studio:` prefix; single-source cutover (flat agents/skills retired); stray `skills/SKILL.md` discovery bug fixed; `CULTURE.md` migrated; flat project layout locked in `STRUCTURE.md`; promoted to `main`. (2026-05-25)
- Scene Test wired into `cd` / `designer` agents + evals.
