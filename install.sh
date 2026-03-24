#!/usr/bin/env bash
set -e

CLAUDE_DIR="$HOME/.claude"
STUDIO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Studio OS — install"
echo "-------------------"
echo ""

# Verify Claude Code is installed
if ! command -v claude &> /dev/null; then
  echo "Error: Claude Code CLI not found."
  echo "Install it first: https://claude.ai/code"
  exit 1
fi

# Create target directories if needed
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/skills"

# Install agents
echo "Installing agents..."
agent_count=0
for file in "$STUDIO_DIR/agents/"*.md; do
  filename=$(basename "$file")
  dest="$CLAUDE_DIR/agents/$filename"
  if [ -f "$dest" ]; then
    cp "$file" "$dest"
    echo "  Updated: $filename"
  else
    cp "$file" "$dest"
    echo "  Installed: $filename"
  fi
  agent_count=$((agent_count + 1))
done
echo "  $agent_count agents installed."
echo ""

# Install skills (each skill is a directory with SKILL.md)
echo "Installing skills..."
skill_count=0
for dir in "$STUDIO_DIR/skills/"/*/; do
  skill_name=$(basename "$dir")
  dest_dir="$CLAUDE_DIR/skills/$skill_name"
  mkdir -p "$dest_dir"
  if [ -f "$dir/SKILL.md" ]; then
    cp "$dir/SKILL.md" "$dest_dir/SKILL.md"
    echo "  Installed: $skill_name"
    skill_count=$((skill_count + 1))
  fi
done
echo "  $skill_count skills installed."
echo ""

# Install memory files (only if not already present — do not overwrite project preferences)
echo "Installing memory..."
MEMORY_SRC="$STUDIO_DIR/memory"
MEMORY_DEST="$CLAUDE_DIR/agents/memory"
mkdir -p "$MEMORY_DEST"

files_installed=0
files_skipped=0

for file in "$MEMORY_SRC/"*.md; do
  filename=$(basename "$file")
  dest="$MEMORY_DEST/$filename"
  if [ -f "$dest" ]; then
    echo "  Skipped (exists): $filename"
    files_skipped=$((files_skipped + 1))
  else
    cp "$file" "$dest"
    echo "  Installed: $filename"
    files_installed=$((files_installed + 1))
  fi
done

if [ "$files_skipped" -gt 0 ]; then
  echo "  Note: $files_skipped file(s) skipped — existing files preserved."
fi
echo ""

# Done
echo "Studio OS installed."
echo ""
echo "Next: open a Claude Code session in your project and run:"
echo ""
echo "  /studio-init"
echo ""
echo "This sets up project-specific context so all agents calibrate to your product."
echo ""
