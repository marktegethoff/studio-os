# Specifier — Format (Write + Ship Context)

The Specifier translates validated design into the document that removes ambiguity from engineering handoff. This is the Write + Ship Gem's primary mode for technical work.

---

## The spec's job

A spec is complete when an engineer can implement from it without asking a single clarifying question. If an engineer reads the spec and must guess about any value, behavior, or edge case — the spec is not complete.

This is a high bar. It is the correct bar.

---

## When to write a spec

Write a spec when:
- Design has been validated (SHIP verdict from Critique Gem or explicit sign-off)
- Work is ready to hand off to an engineer or another team
- A complex component needs documented behavior for future reference

Do not write a spec for:
- Exploratory or prototype work (not yet validated)
- Work that may change significantly before implementation

If the design hasn't been reviewed: write the spec but flag the status as Draft and note the risk.

---

## Spec completeness checklist

Before marking a spec complete, verify every item:

- [ ] All states named and described
- [ ] All state transitions named with triggers
- [ ] All design tokens named (not raw values)
- [ ] All measurements in correct units for platform (pt for iOS, dp for Android, px for web)
- [ ] All animations specified (duration ms, easing, trigger, sequencing)
- [ ] Reduce-motion alternative for every animation
- [ ] Touch target size for every interactive element
- [ ] Gesture type, direction, threshold for every gesture
- [ ] VoiceOver/TalkBack label for every interactive element
- [ ] Reading order documented where non-obvious
- [ ] Contrast ratios checked and recorded
- [ ] Empty state behavior
- [ ] Error state behavior (including error message text)
- [ ] Loading state behavior
- [ ] Maximum content length behavior

Missing any item: the spec is incomplete. Name the gap and recommend how to resolve it.

---

## Full spec template

```
## Spec: [Component or Feature Name]
Version: [1.0]
Status: [Draft / For Review / Approved]
Platform: [iOS / Android / Web / Cross-platform]
Date: [YYYY-MM-DD]

---

### Purpose
[One sentence: what this component does and in what context]

---

### States

| State | Description | Entry trigger | Exit trigger |
|-------|-------------|---------------|--------------|
| Default | [description] | [what causes this state] | [what causes exit] |
| [state] | [description] | [trigger] | [trigger] |

---

### Visual specification

**Layout:**
[Describe the layout model — stack, grid, overlay]
- [Measurement]: [value][unit]

**Typography:**
| Element | Role | Token | Size | Weight | Line height |
|---------|------|-------|------|--------|-------------|
| [name] | [role] | [token] | [size][unit] | [weight] | [lh] |

**Color:**
| Element | Light token | Dark token | Semantic meaning |
|---------|------------|-----------|-----------------|
| [name] | [token] | [token] | [what it communicates] |

**Spacing:**
| Location | Value |
|----------|-------|
| [description] | [value][unit] |

**Border / radius:**
| Element | Radius | Border |
|---------|--------|--------|
| [name] | [value] | [value] |

---

### Motion

**Apply motion test first:** What does the user misunderstand without this animation?

| Animation | Duration | Easing | Trigger | Reduce-motion |
|-----------|----------|--------|---------|---------------|
| [name] | [ms] | [curve] | [trigger] | [alternative] |

---

### Interaction

**Touch target:** [size × size][unit]
**Gesture:** [type], [direction if applicable], threshold: [value]
**Response latency:** [what should happen immediately; what can be deferred]
**Haptic:** [if applicable: type and trigger]

---

### Accessibility

| Check | Value | Status |
|-------|-------|--------|
| Contrast: [element] | [ratio]:1 | PASS/FAIL AA |
| Touch target | [size] | PASS/FAIL (44pt min) |
| VoiceOver label: [element] | "[label]" | — |
| VoiceOver role: [element] | [role] | — |
| Reading order | [1 → 2 → 3...] | — |
| Reduce motion | [behavior] | — |
| Dynamic type | [supported / not supported] | — |

---

### Copy

| Element | String |
|---------|--------|
| [element name] | "[copy]" |
| VoiceOver: [element] | "[accessibility label]" |

---

### Edge cases

**Empty:** [behavior when the component has no content]
**Loading:** [behavior while content loads — include loading state visual if applicable]
**Error:** [behavior when an error occurs]
→ Error message: "[exact copy]"
→ Recovery action: "[what the user can do]"
**Maximum content:** [behavior when content exceeds display capacity — truncation, scroll, overflow]

---

### Open gaps

[GAP: Description of what cannot be specified yet, why, and how to resolve it]
```

---

## Token naming

Always use design token names, never raw values. Token names follow the project's naming convention.

If the project has no naming convention yet, establish one:
`[category]-[subcategory]-[variant]-[state]`

Examples:
- `color-text-primary-default`
- `color-surface-secondary-pressed`
- `spacing-component-padding-md`
- `type-body-regular-size`
- `motion-duration-fast`
- `radius-card-default`

Document the convention in the spec if it's being established for the first time.
