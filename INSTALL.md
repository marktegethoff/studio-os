# Installation

Studio OS requires Claude Code CLI. If you haven't installed it:

```
https://claude.ai/code
```

---

## One-command install

From the repo root:

```bash
./install.sh
```

This copies agents and skills to `~/.claude/` and memory files to `~/.claude/agents/memory/`. Existing memory files are preserved — they are not overwritten on reinstall.

---

## What gets installed

```
~/.claude/agents/          23 discipline agents
~/.claude/skills/          7 workflow skill directories
~/.claude/agents/memory/   Design foundations and memory templates
```

The `CLAUDE.md` in this repo is a template. Copy it to your project root, or use it as a reference when writing your own.

---

## Project setup

After installing, open a Claude Code session in your project and run:

```
/studio-init
```

This runs an interview wizard that captures your product's purpose, brand principles, system invariants, user archetypes, and tech stack. It writes `.claude/memory/project-context.md` — the file all agents load to calibrate themselves to your specific product.

Studio OS works without this file, but agents will fall back to generic reasoning. The interview takes about 10 minutes and makes every subsequent session more useful.

---

## Updating

To update Studio OS after pulling a new version:

```bash
./install.sh
```

Agents and skills are always overwritten on reinstall. Memory files are not — your design preferences, references, and project context are preserved.

---

## Manual install

If you prefer to install selectively:

**Agents only:**
```bash
cp agents/*.md ~/.claude/agents/
```

**Skills only:**
```bash
for dir in skills/*/; do
  mkdir -p ~/.claude/skills/$(basename "$dir")
  cp "$dir/SKILL.md" ~/.claude/skills/$(basename "$dir")/SKILL.md
done
```

**Memory templates only:**
```bash
mkdir -p ~/.claude/agents/memory
cp memory/*.md ~/.claude/agents/memory/
```

---

## Uninstall

Studio OS installs only to `~/.claude/agents/` and `~/.claude/skills/`. Remove those files to uninstall. Nothing is installed system-wide.

```bash
# Remove agents
rm ~/.claude/agents/studio-*.md
rm ~/.claude/agents/choreographer.md
rm ~/.claude/agents/typesetter.md
rm ~/.claude/agents/writer.md
rm ~/.claude/agents/visual-designer.md
rm ~/.claude/agents/specifier.md
rm ~/.claude/agents/mark-maker.md
rm ~/.claude/agents/materialist.md
rm ~/.claude/agents/prototyper.md

# Remove skills
rm -rf ~/.claude/skills/studio
rm -rf ~/.claude/skills/studio-design
rm -rf ~/.claude/skills/studio-implement
rm -rf ~/.claude/skills/studio-review
rm -rf ~/.claude/skills/studio-solve
rm -rf ~/.claude/skills/studio-experiment
rm -rf ~/.claude/skills/studio-init
```
