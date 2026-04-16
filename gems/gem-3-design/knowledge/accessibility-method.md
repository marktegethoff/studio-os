# Accessibility — Method

Accessibility is not a post-design audit. It is part of the design. Every surface must meet minimum standards before it is considered complete.

---

## Minimum standard: WCAG AA

AA is the floor, not the ceiling. Most products should target AA; products serving users with known accessibility needs should target AAA where feasible.

---

## The four areas

### 1. Contrast

**Text contrast (WCAG 1.4.3):**
- Normal text (< 18pt regular or < 14pt bold): minimum 4.5:1
- Large text (≥ 18pt regular or ≥ 14pt bold): minimum 3:1
- Decorative text (no semantic purpose): no requirement

**Non-text contrast (WCAG 1.4.11):**
- Interactive component boundaries: minimum 3:1 against adjacent background
- Informational graphics: minimum 3:1

**How to check:** Use a contrast ratio calculator. Do not eyeball contrast — it is a known failure mode that produces accessible-feeling but non-compliant designs.

**Common failure patterns:**
- Gray placeholder text on white (often 2.5:1 — fails)
- Secondary text in mid-tone gray on light background (often 3.2:1 — fails for normal text)
- Icon-only controls with no text label and low-contrast iconography

### 2. Touch targets

**Minimum size:**
- iOS: 44×44pt (WCAG 2.5.5 AAA target: 44×44pt; AA requires only reasonable means to activate)
- Android: 48×48dp
- Web: 24×24px WCAG 2.2 minimum; 44×44px recommended

**Spacing:** Interactive elements that are adjacent must have sufficient spacing so that accidental activation of adjacent targets is unlikely. 8pt minimum gap.

**Note:** The visible tap area and the interactive area can differ. A small icon button with a 20pt icon can have a 44pt touch target via padding — the visual and interaction surfaces are separate.

### 3. Screen reader support

**Every interactive element needs an accessible label.** The label describes function, not appearance:
- Button with trash can icon: "Delete entry" (not "Trash icon" or "Red button")
- Toggle: "[Setting name], on/off" (not "Switch")
- Image with content: describe the semantic content (not "Image")

**Reading order** must match visual order. Screen readers traverse content in DOM/view hierarchy order. If visual layout reorders content relative to the hierarchy (common in absolute/ZStack layouts), the accessible reading order must be explicitly set.

**Semantic roles** communicate element type to assistive technology:
- Buttons must be buttons (not tappable text styled to look like buttons)
- Headings must be marked as headings with the correct level
- Lists must use list semantics

### 4. Motion and reduce-motion

**Requirement:** Any animation that plays for more than 5 seconds, plays repeatedly, or includes flashing effects must have an override (WCAG 2.2.2).

**Reduce-motion preference:** When the user has enabled reduce-motion, disable or replace:
- Parallax effects
- Sliding transitions (replace with cross-fade or instant)
- Bouncing or springing animations
- Decorative looping animations

Keep for reduce-motion:
- State change feedback that communicates meaning (loading indicator, completion confirmation)
- Brief functional transitions where complete removal would cause confusion

**Standard reduce-motion implementation:**
- iOS: check `UIAccessibility.isReduceMotionEnabled`
- CSS: `@media (prefers-reduced-motion: reduce)`

---

## Accessibility in the design process

Apply accessibility at each stage:

**In information hierarchy:** Flag contrast issues before visual design is complete — it's cheaper to change color tokens than to rework finished screens.

**In interaction model:** Flag touch target violations when laying out interactive elements — spacing between tap targets is a layout decision, not a post-hoc fix.

**In copy:** Write VoiceOver labels at the same time as visual labels — they require the same decisions.

**In motion:** Define reduce-motion alternatives when specifying animations — not after.

---

## What accessibility is not

- An optional layer added at the end
- A compliance checkbox
- A trade-off against visual quality

A design that is inaccessible is incomplete. It is not a finished design with a known deficit — it is an unfinished design.
