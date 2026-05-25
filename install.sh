#!/usr/bin/env bash
set -e

# Studio OS — fallback installer.
# The primary install path is the Claude Code plugin:
#   claude plugin marketplace add marktegethoff/studio-os
#   claude plugin install studio-os@standard-works
# This script is for non-plugin contexts: it copies agents and skills
# into ~/.claude/ directly. Plugin namespacing is lost in this mode.

CLAUDE_DIR="$HOME/.claude"
STUDIO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Studio OS — install (fallback / non-plugin mode)"
echo "------------------------------------------------"
echo ""

if ! command -v claude &> /dev/null; then
  echo "Error: Claude Code CLI not found. Install it first: https://claude.ai/code"
  exit 1
fi

mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/skills"

echo "Installing agents..."
agent_count=0
for file in "$STUDIO_DIR/agents/"*.md; do
  cp "$file" "$CLAUDE_DIR/agents/$(basename "$file")"
  agent_count=$((agent_count + 1))
done
echo "  $agent_count agents installed."

echo "Installing skills..."
skill_count=0
for dir in "$STUDIO_DIR/skills/"*/; do
  [ -f "$dir/SKILL.md" ] || continue
  name=$(basename "$dir")
  mkdir -p "$CLAUDE_DIR/skills/$name"
  cp "$dir/SKILL.md" "$CLAUDE_DIR/skills/$name/SKILL.md"
  skill_count=$((skill_count + 1))
done
echo "  $skill_count skills installed."

echo ""
echo "Studio OS installed (fallback mode)."
echo ""
echo "Recommended: use the plugin instead for native updates + namespacing:"
echo "  claude plugin marketplace add marktegethoff/studio-os"
echo "  claude plugin install studio-os@standard-works"
echo ""
echo "Next: open a Claude Code session in your project and set up context."
echo ""
