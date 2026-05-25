#!/usr/bin/env bash
set -euo pipefail

# Studio OS — verify-sync
# Makes silent drift impossible for the FALLBACK flat install.
#
# The primary install is the plugin: with `claude --plugin-dir <repo>` the
# source IS the install, so drift cannot occur. This check is for the
# `install.sh` flat-copy path: it diffs ~/.claude/{agents,skills} against the
# repo and reports anything that has drifted. Exit 0 = in sync, 1 = drift.

CLAUDE_DIR="$HOME/.claude"
STUDIO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
drift=0

echo "Studio OS — verify-sync"
echo "source: $STUDIO_DIR"
echo "install: $CLAUDE_DIR"
echo ""

# Agents
for src in "$STUDIO_DIR/agents/"*.md; do
  name=$(basename "$src")
  dest="$CLAUDE_DIR/agents/$name"
  if [ ! -f "$dest" ]; then
    echo "  MISSING in install: agents/$name"; drift=1
  elif ! diff -q "$src" "$dest" >/dev/null 2>&1; then
    echo "  DRIFT: agents/$name differs from source"; drift=1
  fi
done

# Skills
for dir in "$STUDIO_DIR/skills/"*/; do
  name=$(basename "$dir")
  src="$dir/SKILL.md"; dest="$CLAUDE_DIR/skills/$name/SKILL.md"
  [ -f "$src" ] || continue
  if [ ! -f "$dest" ]; then
    echo "  MISSING in install: skills/$name"; drift=1
  elif ! diff -q "$src" "$dest" >/dev/null 2>&1; then
    echo "  DRIFT: skills/$name differs from source"; drift=1
  fi
done

echo ""
if [ "$drift" -eq 0 ]; then
  echo "In sync. No drift."
else
  echo "Drift detected. Re-run ./install.sh to resync, or switch to the plugin"
  echo "(--plugin-dir) where the source is the install and drift cannot occur."
  exit 1
fi
