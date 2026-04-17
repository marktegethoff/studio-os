#!/bin/bash

# Studio OS Workshop Kit — Installation Script
# Run this once at the start of the workshop session.

set -e

AGENTS_DIR="$HOME/.claude/agents"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Studio OS Workshop Kit — Installing agents..."
echo ""

# Create agents directory if it doesn't exist
if [ ! -d "$AGENTS_DIR" ]; then
  mkdir -p "$AGENTS_DIR"
  echo "✓ Created ~/.claude/agents/"
else
  echo "✓ ~/.claude/agents/ exists"
fi

# Copy workshop agents
for agent in "$SCRIPT_DIR/agents/"*.md; do
  filename=$(basename "$agent")
  cp "$agent" "$AGENTS_DIR/$filename"
  echo "✓ Installed $filename"
done

echo ""
echo "Installation complete."
echo ""
echo "Next steps:"
echo "  1. Open Terminal and navigate to your workshop folder:"
echo "     cd ~/Desktop/workshop"
echo ""
echo "  2. Start Claude Code:"
echo "     claude"
echo ""
echo "  3. Verify agents are active — type this in Claude Code:"
echo "     what agents do I have available?"
echo ""
echo "  4. You're ready. Take a photo of your sketch and drag it into the Claude Code window."
echo ""
