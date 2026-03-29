---
description: Scaffold a design system skill for this project. Creates the directory structure and token file templates at `.claude/skills/design-system/`. Run once per project after `studio-init`.
argument-hint: ""
---

Scaffold a design system skill for this project.

Arguments: $ARGUMENTS

---

## Steps

### Step 1 — Check for existing skill

Read `.claude/skills/design-system/SKILL.md`.

If it exists, list all files under `.claude/skills/design-system/` and stop. Do not overwrite existing work. Report: "Design system skill already exists at `.claude/skills/design-system/`. To see usage guidance, run `design-system`."

### Step 2 — Create SKILL.md

Write `.claude/skills/design-system/SKILL.md`:

```markdown
# Design System

This skill defines the token vocabulary, component library, and patterns for this project.
Load this file first, then follow the routing table to find the values you need.

## Routing table

| Task | Load |
|------|------|
| Choosing a color | `tokens/colors.md` |
| Setting typography | `tokens/typography.md` |
| Setting spacing, sizing, or layout | `tokens/spacing.md` |
| Specifying animation or motion | `tokens/motion.md` |
| Setting stroke width, corner radius, opacity, or elevation | `tokens/surface.md` |
| Building or evaluating a component | `components/` |
| Applying a layout or interaction pattern | `patterns/` |

## Invariants

[Define system-wide rules here. These are non-negotiable constraints that all agents must respect.]

Examples:
- [Color represents semantic signal only — no decorative color]
- [No drop shadows — use tonal separation for elevation]
- [All interactive elements must have accessibility labels]

## Validation checklist

Before shipping any UI surface:
- [ ] All colors use named tokens (no raw hex values)
- [ ] All spacing uses scale values (no raw pt values where a token exists)
- [ ] All typography uses register or role tokens
- [ ] Touch targets ≥ 44pt on all interactive elements
- [ ] WCAG AA contrast verified for all text
- [ ] VoiceOver labels specified for all interactive and informational elements
- [ ] Reduce-motion alternative specified for all animations
```

### Step 3 — Create token files

**`tokens/colors.md`:**

```markdown
# Color Tokens

Defines the color vocabulary for this project — scales, semantic assignments, and brand colors.
Agents: load this file when choosing any color, evaluating contrast, or assigning dark mode values.

## Scale

The base color scale. Reference by token name, not hex value.

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| [name] | [hex] | [hex] | [usage] |

## Semantic

Colors assigned to specific roles in the interface.

| Token | Value | Usage |
|-------|-------|-------|

## Signal / Intent

Colors that represent meaning. Fixed across light and dark mode.

| Intent | Token | Value |
|--------|-------|-------|

## Brand

Colors reserved for brand elements.

| Token | Value | Notes |
|-------|-------|-------|

## Known contrast ratios

| Foreground | Background | Ratio | AA pass? |
|------------|------------|-------|---------|
```

**`tokens/typography.md`:**

```markdown
# Typography Tokens

Defines the type system for this project — typefaces, scale, and register assignments.
Agents: load this file when setting any text style, evaluating type hierarchy, or writing copy.

## Typefaces

| Name | Variable | Usage |
|------|----------|-------|

## Scale

| Token | Size | Weight | Line height | Usage |
|-------|------|--------|-------------|-------|

## Registers / Roles

Semantic roles that govern which typeface and style is used where.

| Register | Typeface | Case | Usage |
|----------|----------|------|-------|

## Rules

[Define register rules here — which register is used for labels, body, metadata, etc.]
```

**`tokens/spacing.md`:**

```markdown
# Spacing Tokens

Defines the spacing scale and component dimension values for this project.
Agents: load this file when setting padding, margins, row heights, or component sizes.

## Scale

| Token | Value | Usage |
|-------|-------|-------|

## Component dimensions

| Component | Dimension | Value | Notes |
|-----------|-----------|-------|-------|
```

**`tokens/motion.md`:**

```markdown
# Motion Tokens

Defines animation durations, spring configurations, and easing curves.
Agents: load this file before specifying any transition or animation.

## Durations

| Token | Value | Usage |
|-------|-------|-------|

## Springs

| Token | Response | Damping | Usage |
|-------|----------|---------|-------|

## Easing curves

| Token | Curve | Usage |
|-------|-------|-------|

## Invariants

- Never run animations when `accessibilityReduceMotion` is enabled.
- [Add project-specific motion rules here.]
```

**`tokens/surface.md`:**

```markdown
# Surface Tokens

Defines stroke widths, corner radii, opacity values, and elevation strategy.
Agents: load this file when setting any stroke, radius, opacity, or elevation value.

## Stroke widths

| Token | Value | Usage |
|-------|-------|-------|

## Corner radii

| Token | Value | Usage |
|-------|-------|-------|

## Opacity scale

| Token | Value | Usage |
|-------|-------|-------|

## Elevation strategy

[Describe how elevation is communicated in this project — tonal separation, shadows, blur, etc.]

Rule: [Define the elevation rule here — e.g. "No drop shadows. Use tonal separation only."]
```

### Step 4 — Create component and pattern directories

**`components/README.md`:**

```markdown
# Components

Each component has its own file documenting states, token assignments, copy, and accessibility labels.

## Format

Each component file should cover:
- States (default, hover, active, disabled, loading, error)
- Token assignments (color, spacing, typography, surface tokens per element)
- Copy (labels, empty states, error messages)
- Accessibility (VoiceOver label, trait, touch target size)
- Interaction parameters (if animated: duration, spring, reduce-motion alternative)

## Add a component

Create a new file: `components/[component-name].md`
```

**`patterns/README.md`:**

```markdown
# Patterns

Recurring interaction and layout patterns used across the product.

## Format

Each pattern file should cover:
- When to use this pattern
- Structure (what elements, what order)
- Token assignments
- Variations (if any)
- Anti-patterns (what not to do)

## Add a pattern

Create a new file: `patterns/[pattern-name].md`
```

### Step 5 — Report

List all files created. Then output:

---

**Design system skill scaffolded.**

Next steps:
1. Populate `tokens/colors.md` with your project's color values
2. Populate `tokens/typography.md` with your typeface and scale decisions
3. Populate `tokens/spacing.md` with your spacing scale
4. Define system invariants in `SKILL.md`
5. Add component files to `components/` as you build them

Once populated, Studio OS agents will load this skill automatically when working on this project.
