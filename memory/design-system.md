# Design System
Last updated: [date]
Project: [project name]

This file is loaded by `xd-validate-design` to validate mockups against the project's design system. Define all rules here before running validation.

---

## How This File Works

Each section maps to a validation check. When `xd-validate-design` runs, it applies each rule defined here as a checklist item. Undefined sections are skipped.

Rules should be exact, not approximate. "Use the primary blue" is not a rule. "Primary interactive elements use `--color-action: #0066CC`" is a rule.

---

## Dark Mode Parity

Does this project support dark mode?

- [ ] Yes — define both light and dark values for all tokens below
- [ ] No — skip dark mode checks

Rules:
- [Define background token behavior in dark mode]
- [Define text token behavior in dark mode]
- [Signal/status colors: do they change between modes or stay constant?]
- Icon rendering: [SVG currentColor / hardcoded hex / other]

---

## Color Tokens

### Background Colors
| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `--color-bg-primary` | `#______` | `#______` | [where used] |
| `--color-bg-secondary` | `#______` | `#______` | [where used] |

### Text Colors
| Token | Light | Dark | Contrast (WCAG) |
|-------|-------|------|-----------------|
| `--color-text-primary` | `#______` | `#______` | [ratio] |
| `--color-text-secondary` | `#______` | `#______` | [ratio] |

### Signal / Status Colors
| Token | Value | Meaning |
|-------|-------|---------|
| `--color-signal-[name]` | `#______` | [what it communicates] |

### Brand Colors
| Name | Value | Reserved for |
|------|-------|-------------|
| [Name] | `#______` | [exclusive use] |

---

## Typography

### Typefaces
| Role | Typeface | Used for |
|------|----------|---------|
| [Mechanism / UI] | [font name] | [nav, labels, timestamps, metadata] |
| [Content / Body] | [font name] | [primary content text] |

### Type Violations to Flag
- [Font A] used where [Font B] is required: [context]
- [Any hard rules about font exclusivity]

---

## Icons

- Viewbox: [e.g., 24×24px]
- Stroke width: [e.g., 1.5px]
- Minimum interactive target: [e.g., 44×44px]
- Rendering: [SVG with currentColor / other]
- Prohibited: [e.g., emoji substitutes, inline SVG with hardcoded colors]

---

## Spacing

| Element | Value |
|---------|-------|
| [Component] padding | [value] |
| [Button] size | [value] |
| [Row] padding | [value] |
| Minimum touch target | 44×44px |

---

## Brand Elements

| Element | Specification |
|---------|--------------|
| [Logo mark] | [exact rendering rule] |
| [Primary action] resting state | [border, color, size] |
| [Primary action] active state | [border, color, size] |
| [Other brand element] | [specification] |

---

## Accessibility

### Known passing combinations
- [Text color] on [background color]: [contrast ratio] — WCAG [AA/AAA]

### Known failing combinations (flag these)
- [Text color] on [background color]: [contrast ratio] — fails WCAG AA

### Required labels
- [Component]: must have `aria-label="[value]"`
- [Component]: [accessibility requirement]

---

## Content Rules

- Prohibited placeholder text patterns: [e.g., `[placeholder]`, TODO text]
- Required label vocabulary: [e.g., specific action names, status labels]
- Prohibited terms: [e.g., deprecated labels, old naming]
- Required terms: [e.g., exact button copy, exact badge names]
