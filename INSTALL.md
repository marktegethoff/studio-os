# Installation

Studio OS requires Claude Code CLI. If you haven't installed it:

```
https://claude.ai/code
```

---

## Install

Studio OS is a Claude Code plugin. In your shell:

```bash
claude plugin marketplace add marktegethoff/studio-os
claude plugin install studio@standard-works
```

The marketplace is `standard-works`; the plugin is `studio`. Inside a session, `/plugin marketplace add marktegethoff/studio-os` and `/plugin install studio@standard-works` do the same. The install command opens the plugin's details so you can choose a scope.

The plugin loads the next time you start Claude Code, or when you run `/reload-plugins`. To check it, type `/` and look for `/studio:studio`, or run `claude plugin list`. Skills and agents are namespaced (`/studio:design`, `studio:designer`), so they never collide with your own.

If you installed with `install.sh` earlier, remove those copies first (see [Uninstall](#uninstall)) so each agent exists once.

---

## Update

```bash
claude plugin marketplace update standard-works
claude plugin update studio@standard-works
```

A marketplace added from GitHub does not auto-update by default (toggle it under `/plugin` → Marketplaces). The first command refreshes the listing. The second installs the new version for your next session, or after `/reload-plugins`.

The plugin pins `version` in `plugin.json`, so an update lands only when the version number changes. Content changed under an unchanged version never reaches an installed copy ([CHANGELOG](CHANGELOG.md), 1.5.2). An update does not touch your project's `.claude/memory/`.

---

## Edit-live

```bash
claude --plugin-dir /path/to/studio-os
```

This loads the repo in place for that session. Edits apply with `/reload-plugins`. For that session it replaces an installed copy of the same plugin.

---

## Project setup

In a Claude Code session in your project:

```
/studio:init
```

The interview covers the product (identity, ethos, system model, user archetypes, stack, research scope, design system), then your role on this project. It writes to `.claude/memory/`:

- `project-context.md` — the file agents load to calibrate to your product.
- `design-vocabulary.md` — the product's registers and material language, and the `## Dictionary` the writing check reads.
- `role-context.md` — your role here. Personal; not committed.

It then offers optional personalization (reference palette, display personas, extra engineering specialists, brand identity) and scaffolds the workspace: `code/app`, plus `code/canvas` and `code/shared` by the shape you choose.

Studio OS works without these files, but agents fall back to generic reasoning. `/studio:organize` creates the output folders (`decisions/`, `specs/`, `design/`, `reviews/`).

In a team, one person runs `/studio:init` per product and commits `project-context.md` and `design-vocabulary.md`. Everyone else gets them on pull.

---

## Personal profile

`~/.claude/memory/user-profile.md` holds who you are across projects: role, skills, experience. Agents use it to calibrate how much to explain. It is optional, and nothing creates it. `install.sh` does not, and `/studio:init` only suggests it when the file is missing. Write it by hand.

---

## Recommended settings

Optional. No studio skill depends on either setting.

**Advisor.** Studio OS pairs well with Claude Code's [advisor](https://code.claude.com/docs/en/advisor): set `"advisorModel": "opus"` in your settings, or run `/advisor opus`. Fable also works where your plan allows; on some plans Fable bills to usage credits. The advisor is experimental and needs the Anthropic API.

**`adversary_model`.** The plugin's own setting, for refutation passes. Set it in `/config` (Claude Code 2.1.269 or later) or under **Configure options** in the plugin's `/plugin` details.

- `agent` (default): each refuter runs on its own frontmatter model, at no extra cost.
- `fable`, `opus`, or `sonnet`: every refuter runs on that model, independent of the verdict it attacks. `fable` may bill to usage credits.

It applies to the refutation nodes in `/studio:review` and `/studio:solve`, and to `/studio:implement`'s halt diagnosis and pre-stage refutation. Any other value is read as `agent`. Detail: the plugin's `memory/orchestration.md` § Model and effort.

---

## Environments without WebSearch

Some enterprise Claude Code deployments disable WebSearch. Six agents declare it in `tools`. Four are built around web research: `historian`, `scout`, `competitive-analyst`, and `surveyor`. `pm` (WebSearch) and `heurist` (WebSearch, WebFetch) use it as a supplement.

Nothing in the plugin detects a missing tool or skips these agents, and `install.sh` has no `--no-web` option. Without WebSearch, the four research agents have no source of live evidence. Use the others.

---

## Fallback: install.sh

Use this only where plugins cannot be installed:

```bash
./install.sh
```

The script takes no options and asks no questions. It checks that `claude` is on your PATH. It copies every `agents/*.md` to `~/.claude/agents/` and every `skills/<name>/SKILL.md` to `~/.claude/skills/<name>/`, overwrites files of the same name, and prints the counts.

It is a reduced install:

- Skills lose the `studio:` namespace. Run `/design`, not `/studio:design`.
- It copies nothing else: no `memory/`, `artifacts/` (kit and templates), `evals/` (including `ste-check.sh`), hook, `workflow.js` executor, or `skills/feedback/overlay.md`. Agents and skills cite those files, so the cited paths do not resolve.
- The `adversary_model` setting does not exist, so every refuter runs on its own model.

To copy only part:

```bash
cp agents/*.md ~/.claude/agents/
```

```bash
for dir in skills/*/; do
  mkdir -p ~/.claude/skills/$(basename "$dir")
  cp "$dir/SKILL.md" ~/.claude/skills/$(basename "$dir")/SKILL.md
done
```

---

## Uninstall

Plugin:

```bash
claude plugin uninstall studio@standard-works
claude plugin marketplace remove standard-works
```

Removing the marketplace also uninstalls every plugin installed from it.

After `install.sh`, from the repo root:

```bash
for f in agents/*.md; do rm -f ~/.claude/agents/"$(basename "$f")"; done
for d in skills/*/; do rm -rf ~/.claude/skills/"$(basename "$d")"; done
```

This also removes a file of the same name that was yours before `install.sh` overwrote it.
