#!/usr/bin/env bash
set -e

# Studio OS release script.
# Usage: ./release.sh <version>
# Example: ./release.sh 1.2.0
#
# Pre-conditions:
#   1. Add a "## <version> — <date>" entry to CHANGELOG.md with release notes.
#   2. Run this script from the repo root on main with a clean working tree.
#
# What it does:
#   - Bumps version in .claude-plugin/plugin.json and .claude-plugin/marketplace.json
#   - Commits the version bump
#   - Creates a git tag v<version>
#   - Prints the push command (does not push automatically)

VERSION="${1:?Usage: ./release.sh <version>   Example: ./release.sh 1.2.0}"

# Validate semver format
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: version must be in semver format (e.g., 1.2.0)" >&2
  exit 1
fi

# Must be on main
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "main" ]]; then
  echo "Error: must be on main branch (currently on '$BRANCH')" >&2
  exit 1
fi

# Working tree must be clean
if [[ -n $(git status --porcelain) ]]; then
  echo "Error: working tree is not clean — commit or stash changes first" >&2
  exit 1
fi

# CHANGELOG must have an entry for this version
if ! grep -q "^## $VERSION" CHANGELOG.md; then
  echo "Error: no CHANGELOG.md entry found for $VERSION" >&2
  echo "       Add '## $VERSION — $(date +%Y-%m-%d)' and release notes before running this script." >&2
  exit 1
fi

# Tag must not already exist
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
  echo "Error: tag v$VERSION already exists" >&2
  exit 1
fi

# Bump .claude-plugin/plugin.json
python3 - "$VERSION" <<'EOF'
import json, sys

path = ".claude-plugin/plugin.json"
with open(path) as f:
    data = json.load(f)
data["version"] = sys.argv[1]
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
EOF

# Bump .claude-plugin/marketplace.json (top-level + per-plugin entry)
python3 - "$VERSION" <<'EOF'
import json, sys

path = ".claude-plugin/marketplace.json"
with open(path) as f:
    data = json.load(f)
data["version"] = sys.argv[1]
for plugin in data.get("plugins", []):
    if plugin.get("name") == "studio":
        plugin["version"] = sys.argv[1]
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
EOF

echo "Bumped plugin.json and marketplace.json to $VERSION"

git add .claude-plugin/plugin.json .claude-plugin/marketplace.json
git commit -m "Release v$VERSION"
git tag "v$VERSION"

echo ""
echo "Tagged v$VERSION. Review, then publish:"
echo ""
echo "  git push && git push --tags"
echo ""
echo "Consumers will receive this release via: claude plugin update"
