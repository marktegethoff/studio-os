# Studio OS — Cutover (run once)

This moves you from the old flat `~/.claude/agents` install to the **Studio OS plugin** — the new single source of truth. Everything before this lives on the branch `phase-0-studio-os-foundation`; `main` is untouched and nothing is pushed.

## The one-time updater

```bash
bash ~/Code/studio-os/migrate.sh
```

It is safe and idempotent. It will:
1. **Validate** the plugin (`claude plugin validate`).
2. **Back up** your current `~/.claude/{agents,skills,commands}` to `~/.claude/_studio-os-backup-<date>/` (skips if already backed up — you already have `_studio-os-backup-2026-05-25/`).
3. **Install** the plugin — you pick:
   - **A. Marketplace** (versioned, native `claude plugin update`): `claude plugin marketplace add ~/Code/studio-os` → `claude plugin install studio-os@standard-works`.
   - **B. Edit-live** (recommended for you — source *is* the install, zero drift): alias `claude='claude --plugin-dir ~/Code/studio-os'` in `~/.zshrc`.
4. **Remove** the old flat `~/.claude/agents/*.md` (they take precedence over the plugin and would shadow it — backed up first, with confirmation).
5. **Verify** the plugin is present and print the regression checklist.

## Then restart and confirm (the Phase 0 gate)

After restarting Claude Code in your Log project:
- `/studio-os:studio` orients (roles, gates, outputs).
- A gate agent (`cd`) and a workflow (`/studio-os:design`) load and behave as before — **no behavioral regression**.
- Run the **eval suite** (`evals/README.md`) for the full pass.
- All 27 skills invoke by exact name. If a session doesn't *auto-surface* every skill (the listing can truncate at this count), raise the budget in `~/.claude/settings.json`: `"skillListingBudgetFraction": 0.02`.
- Restore if needed: `cp -R ~/.claude/_studio-os-backup-2026-05-25/agents/* ~/.claude/agents/`.

## Promote (your call)

Nothing is pushed. When the cutover verifies clean:
```bash
cd ~/Code/studio-os
git checkout main && git merge phase-0-studio-os-foundation   # or open a PR
git push                                                       # publish when ready
```

That's the last step — the studio becomes the live, sole source, and Log runs on it with no regression.
