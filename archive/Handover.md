# Handover
Last updated: 2026-04-22

## Session summary

Extended XD OS enterprise expansion session. All changes committed and pushed to `main`.

---

## What shipped

### New skills
- `/xd-prototype` — scopes a test question, runs parallel build + test criteria, routes findings
- `/xd-prepare-handoff` — prototype-to-production completeness: all states + flows, synthetic data, UAT scenarios, build spec

### Agent improvements
- `xd-specifier` — Build Spec Mode added: DS companion token → production component mapping
- `xd-historian` — source integrity rule (no fabricated citations) + offline fallback labeling
- `xd-heurist` — same source integrity rule + offline fallback for AI-surface quarterly check
- `pm` — WebSearch removed from tools (was never referenced in agent body)

### Skill cleanup — all 12 skills
- Removed all `[HAIKU]` / `[SONNET]` / `[OPUS]` inline model tags from step headers
- Removed all "⏸ PAUSE — Model switch required" blocks
- Added agent names to discipline step headers (e.g. `### Step 4 — Strategist (xd-strategist)`)
- Model routing now lives in agent frontmatter only

### WebSearch enterprise compatibility
- `xd-scout`, `xd-research-sweep`, `competitive-analyst` — `web-required: true` frontmatter added
- `./xd setup --no-web` flag: skips web-required agents at install time
- Interactive WebSearch prompt added to `./xd setup` flow
- End-of-setup message lists skipped agents and how to add them later
- INSTALL.md: enterprise/no-web section added

### README
- "Three-tier distribution model" section cut (restated what agents section already showed)
- "Codebase coherence" section cut (covered by agent tables and workflow artifacts table)
- Flat agent name lists replaced with Output tables — each agent now shows what it produces
- ⁺ footnote marks web-required agents
- Workflow artifacts table moved directly under skills list

### Other
- `CASE-STUDIES.md` renamed to `EXAMPLES.md`
- README attribution: Built by Mark Tegethoff

---

## Local install — complete

All changes ported to `~/.claude/`:
- `./xd update` — updated all existing agents and skills
- `/xd-prototype` and `/xd-prepare-handoff` — manually copied to `~/.claude/skills/`
- `user-profile.md` — written to `~/.claude/memory/`: Designer Founder, visual/interaction/systems/service design/strategy, executive-level

---

## Open questions / next work

None carried over from this session. Clean state.

Likely next: `/studio-design search redesign` — brief validated 2026-04-20, Reviewer persona, two-tier model (structured free / archivist NL Pro). See `studio_os/artifacts/product_brief_search.md`.
