# Studio OS — Gemini Gem Family

A translation of Studio OS discipline for Google Gemini enterprise Gems. Five Gems, organized by cognitive mode. Stateless by design — project context is user-supplied at the start of each session.

---

## What this is

Studio OS in Claude Code uses dynamic agent spawning, session memory, and sequential gates. None of that exists in Gemini Gems. This family does not attempt to port the mechanism — it translates the discipline into what Gemini can carry: a system prompt, knowledge files, and a session context protocol.

What you get: the same ethos, the same specialist voices, the same output contracts. What you don't get: enforced sequential gates, parallel execution, cross-session memory, or file-level code review. See the Claude Code seam section below for what stays there.

---

## The five Gems

| Gem | Mode | Use when |
|-----|------|----------|
| **Problem** | Define | Starting a new direction, re-anchoring, evaluating what to build |
| **Diverge** | Explore | Generating the idea space before committing to a direction |
| **Design** | Structure | Designing a surface, interaction model, or architectural change |
| **Critique** | Evaluate | A surface or document is ready for a quality gate |
| **Write + Ship** | Output | Copy, specs, briefs, docs, prototype strategy |

---

## Setup

### Step 1 — Create your project context file

Copy `templates/project-context.md`. Fill it in for your project following the inline instructions. Save it — you'll paste from it at the start of every Gem session.

### Step 2 — Create a Gem in Gemini

In Google Gemini (enterprise), create a new Gem. For each Gem:

1. **Gem name:** Use the names above (Problem, Diverge, Design, Critique, Write + Ship)
2. **Gem instructions:** Paste the contents of `gem-N-name/system-prompt.md`
3. **Knowledge files:** Upload all files from `shared/` plus all files from `gem-N-name/knowledge/`

Each Gem gets 3 shared files + up to 7 Gem-specific files = 10 files maximum.

### Step 3 — Start every session with a session header

At the start of each Gem conversation, paste your session header. The format is in `shared/session-protocol.md` and templated in `templates/project-context.md`. The Gem will not proceed without it.

---

## File structure

```
gems/
  shared/
    studio-ethos.md              Ethos, decision hierarchy, calibration gate — loaded by all Gems
    studio-disciplines.md        All disciplines condensed — loaded by all Gems
    session-protocol.md          Session header format and behavioral rules — loaded by all Gems

  templates/
    project-context.md           Fill this in for your project. Use it to generate session headers.

  gem-1-problem/
    system-prompt.md             Paste into Gem instructions
    knowledge/                   Upload these + shared/ files to the Gem
      pm-four-moves.md
      strategist-method.md
      historian-method.md
      brief-template.md
      design-foundations.md

  gem-2-diverge/
    system-prompt.md
    knowledge/
      ideate-workflow.md
      lens-prompts.md
      strategist-filter.md
      critic-method.md
      idea-card-format.md

  gem-3-design/
    system-prompt.md
    knowledge/
      designer-method.md
      architect-method.md
      design-subteam.md
      accessibility-method.md
      specifier-format.md
      heurist-method.md

  gem-4-critique/
    system-prompt.md
    knowledge/
      cd-method.md
      de-method.md
      critic-method.md
      heurist-method.md
      routing-guide.md
      design-foundations.md

  gem-5-write-ship/
    system-prompt.md
    knowledge/
      writer-method.md
      specifier-format.md
      brief-template.md
      prototyper-method.md
      doc-templates.md
```

---

## The Claude Code seam

**Gemini Gems handle:**
- Problem definition and brief validation
- Divergent ideation across discipline lenses
- Interaction model and surface structure design
- Design critique and quality gates
- Copy, documentation, spec writing
- Prototype strategy

**Claude Code Studio OS handles:**
- All code generation and implementation
- Architectural decisions with ledger entries
- Cross-session memory and decision log
- Parallel multi-agent execution
- File-level code review (DE)
- Everything that reads or writes the actual codebase

**The handoff:**
Gem 3 (Design) output is formatted to feed directly into `/studio-implement` in Claude Code. Gem 4 (Critique) design review output feeds back into the design workflow. Code review always stays in Claude Code.

**Decision logging:**
Decisions made in Gem sessions are not automatically logged. At the close of any session where a structural decision was made, note it explicitly and carry it back to Claude Code for ledger entry.
