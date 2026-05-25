#!/usr/bin/env bash
# Studio OS — one-time cutover / updater.
# Run this ONCE on a clean session to move from the old flat ~/.claude install
# to the Studio OS plugin (the new single source of truth). Safe + idempotent:
# it backs up, validates, and asks before anything destructive. Restore steps
# are printed at the end.
#
# Usage:  bash ~/Code/studio-os/migrate.sh
set -uo pipefail

STUDIO="$HOME/Code/studio-os"
CLAUDE="$HOME/.claude"
TS="$(date +%Y-%m-%d)"
BK="$CLAUDE/_studio-os-backup-$TS"

say(){ printf '\n\033[1m%s\033[0m\n' "$1"; }
ok(){  printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn(){ printf '  \033[33m!\033[0m %s\n' "$1"; }

say "Studio OS — cutover to the plugin"

# 1) Pre-flight ---------------------------------------------------------------
[ -d "$STUDIO" ] || { echo "Source not found at $STUDIO"; exit 1; }
command -v claude >/dev/null || { echo "Claude Code CLI not found."; exit 1; }
say "1. Validate the plugin"
if claude plugin validate "$STUDIO" 2>&1 | grep -q "Validation passed"; then
  ok "plugin + marketplace manifests valid"
else
  warn "validation did not report success — inspect before continuing"; claude plugin validate "$STUDIO"; exit 1
fi

# 2) Back up the current live install (idempotent) ----------------------------
say "2. Back up the current live install"
if [ -d "$BK" ]; then ok "backup already exists: $BK"; else
  mkdir -p "$BK"
  for d in agents skills commands; do [ -d "$CLAUDE/$d" ] && cp -R "$CLAUDE/$d" "$BK/$d"; done
  ok "backed up agents/skills/commands → $BK"
fi

# 3) Install the plugin -------------------------------------------------------
say "3. Install the Studio OS plugin"
echo "  Two ways — pick one:"
echo "    A. Marketplace (versioned, native updates):"
echo "         claude plugin marketplace add \"$STUDIO\""
echo "         claude plugin install studio-os@standard-works"
echo "    B. Edit-live (source IS the install, zero drift — recommended for you):"
echo "         alias claude='claude --plugin-dir \"$STUDIO\"'   # add to ~/.zshrc"
echo ""
read -r -p "  Run option A now (marketplace add + install)? [y/N] " a
if [ "${a:-N}" = "y" ] || [ "${a:-N}" = "Y" ]; then
  claude plugin marketplace add "$STUDIO" && claude plugin install studio-os@standard-works && ok "plugin installed" || warn "install reported an issue — check output"
else
  warn "skipped — set up option B (alias) yourself, or run A later"
fi

# 4) Remove the shadowing flat copies ----------------------------------------
# Flat ~/.claude/agents/*.md take PRECEDENCE over the plugin, so they must go.
say "4. Remove the old flat copies that would shadow the plugin"
FLAT=$(ls "$CLAUDE/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  $FLAT flat agent files in $CLAUDE/agents (backed up at $BK)."
read -r -p "  Remove them so the plugin's agents take over? [y/N] " r
if [ "${r:-N}" = "y" ] || [ "${r:-N}" = "Y" ]; then
  rm -f "$CLAUDE/agents/"*.md && ok "flat agents removed (restore from $BK if needed)"
else
  warn "skipped — the plugin will be shadowed by the flat copies until you remove them"
fi

# 5) Verify -------------------------------------------------------------------
say "5. Verify"
claude plugin list 2>/dev/null | grep -qi "studio-os" && ok "studio-os plugin present" || warn "studio-os not listed — finish step 3"
echo ""
say "Next — confirm no regression (restart Claude Code first):"
cat <<'EOF'
  - Open a session in your Log project and run /studio-os:studio — it should orient.
  - Invoke a gate (e.g. the cd agent) and a workflow (e.g. /studio-os:design) — confirm they load and behave as before.
  - Run the eval suite (see evals/README.md) for the full confidence pass.
  - If anything is wrong: restore with  cp -R "$BK"/agents/* ~/.claude/agents/
EOF
say "Done. Source of truth is now $STUDIO."
