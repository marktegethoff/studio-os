# Installation

XD OS requires Claude Code CLI. If you haven't installed it:

```
https://claude.ai/code
```

---

## Install

From the repo root:

```bash
./xd setup
```

This asks for your primary discipline, installs the relevant agents and skills to `~/.claude/`, and runs a short interview to build your personal profile at `~/.claude/memory/user-profile.md`.

---

## What gets installed

Installation varies by discipline selection. The Core tier is always included.

**Core (always installed)**
```
~/.claude/agents/          6 core agents
~/.claude/skills/          6 core skills
~/.claude/agents/memory/   Design foundations and memory templates
```

**Design role adds** ~15 agents + 6 skills

**Product role adds** ~11 agents + 2 skills

**Engineering role adds** 5 agents + 2 skills

Select **All disciplines** to install everything. Agents shared across roles are installed once.

---

## Personal profile

During `./xd setup` you'll be asked three questions: your role, your strongest skills, and where you are in your practice. The answers are written to `~/.claude/memory/user-profile.md`.

Agents read this file to calibrate how they work with you — the level of explanation they provide, how they frame tradeoffs, which aspects of a problem they foreground.

Update your profile any time:

```bash
./xd setup --me
```

---

## Project setup

After installing, open a Claude Code session in your project and run:

```
/xd-init
```

This runs an interview that captures your product's purpose, brand principles, system invariants, user archetypes, and tech stack. It writes `.claude/memory/project-context.md` — the file all agents load to calibrate themselves to your specific product.

XD OS works without this file, but agents fall back to generic reasoning. The interview takes about 10 minutes and makes every subsequent session more useful.

In a team setting, one person runs `/xd-init` per product and commits the resulting `project-context.md` to the repo. Everyone else gets it on pull.

---

## Adding disciplines later

```bash
./xd add
```

Shows which disciplines are currently installed, and lets you add another — or choose individual agents.

---

## Updating

```bash
./xd update
```

Updates all currently installed agents and skills to the latest versions. Memory files are not touched — your design preferences, references, and project context are preserved.

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

XD OS installs only to `~/.claude/agents/`, `~/.claude/skills/`, and `~/.claude/memory/`. Remove those files to uninstall. Nothing is installed system-wide.

To remove all XD OS agents and skills:

```bash
# Core agents
rm -f ~/.claude/agents/pm.md
rm -f ~/.claude/agents/de.md
rm -f ~/.claude/agents/competitive-analyst.md
rm -f ~/.claude/agents/xd-design-director.md
rm -f ~/.claude/agents/xd-heurist.md
rm -f ~/.claude/agents/xd-audit.md

# Role agents (xd-prefixed and others)
rm -f ~/.claude/agents/xd-*.md
rm -f ~/.claude/agents/engineer.md
rm -f ~/.claude/agents/qa.md
rm -f ~/.claude/agents/marketer.md
rm -f ~/.claude/agents/brief-writer.md
rm -f ~/.claude/agents/assumption-mapper.md
rm -f ~/.claude/agents/metrics-definer.md

# Skills
rm -rf ~/.claude/skills/xd-*
rm -rf ~/.claude/skills/lt-review
rm -rf ~/.claude/skills/design-system-init
```
