# Anti-pattern Catalog

Named failure modes in design and product work. Agents cite entries by name when a pattern fires. Each entry includes the observable tell, the structural reason it fails, and the minimum viable correction.

---

### Feature Accumulation

**Tell:** The capability set grows with each release and nothing is removed; the surface's complexity increases monotonically.
**Why it fails:** Addition is the path of least resistance; removal requires judgment about what matters. A product that only adds eventually becomes a product that does nothing well.
**Correction:** For every proposed addition, name what it replaces or what is removed to make room. A feature without a corresponding removal is a proposal to accumulate.

---

### Settings Dumping

**Tell:** The settings screen has more than five meaningful toggles; the product defers decisions to user preference rather than making them.
**Why it fails:** Each toggle is a design decision the product refused to make. Twelve options means twelve times the designer gave up. The resulting experience belongs to no one.
**Correction:** Remove options until each remaining one is genuinely load-bearing — a difference in outcome the product cannot predict. Defaults are design decisions; make them.

---

### Dashboard Creep

**Tell:** Every major surface has a summary bar, a progress indicator, a count, or a status metric at the top. The product is narrating itself.
**Why it fails:** Summaries are useful at the moment of decision. Present everywhere, they are ambient noise that teaches the user to ignore them — including when they matter.
**Correction:** Surface metrics where the user acts on them. Remove them from surfaces where they only report.

---

### Decoration Compensation

**Tell:** The surface has unresolved information hierarchy, and the visual treatment uses gradient, shadow, color weight, or illustration to draw attention without resolving the structure.
**Why it fails:** Visual emphasis applied to a structurally unclear surface does not clarify it — it makes the confusion more polished. The decoration signals that the designer noticed the problem and chose not to fix it.
**Correction:** Resolve the hierarchy. Decoration follows structure; it does not substitute for it.

---

### Modal Inflation

**Tell:** Confirmations, secondary choices, errors, and settings are routed through modal dialogs for non-destructive actions.
**Why it fails:** A modal stops the user's momentum and demands a decision before returning control. Non-destructive actions do not warrant this cost; the modal signals that the design has not decided where the action belongs.
**Correction:** Reserve modals for actions that are destructive, irreversible, or require context that cannot be surfaced inline. Everything else belongs in-place.

---

### Empty State Neglect

**Tell:** The zero-state and first-run experience are visually sparse and functionally absent; the product's first impression is an empty list or a blank canvas with no orientation.
**Why it fails:** The empty state is the product's first impression for every new user. Designed last, it shows. A product that cannot explain itself at zero is a product that presumes familiarity.
**Correction:** Design the zero state as the onboarding surface it is — the one moment the product has the user's full attention and nothing to distract from the pitch.

---

### Premature Skin

**Tell:** The visual treatment — type choices, color, spacing system — is committed before the interaction model is settled.
**Why it fails:** Visual treatment encodes structural assumptions. A navigation pattern committed in visual form is hard to revise without a visual regression; the skin forecloses structural options by making them feel finished.
**Correction:** Settle the interaction model in wireframe. The skin applies to a stable structure, not a provisional one.

---

### Explanation as Compensation

**Tell:** A tooltip, helper text, onboarding overlay, or contextual "?" is added in response to user confusion about a UI element.
**Why it fails:** The explanation documents the symptom. It does not fix the design that required explaining. Every explanation added to a confusing element is a permanent maintenance cost on top of a permanent design defect.
**Correction:** Remove the confusion. If the element cannot make its case from context, redesign it. Documentation is not a design fix.

---

### Navigation Debt

**Tell:** Finding any feature requires knowing where it lives; the hierarchy has more than two levels of depth without a clear organizational logic.
**Why it fails:** Navigation layers accumulate incrementally — each addition seems reasonable in isolation; the total is a map the user must memorize. Depth without logic is depth without purpose.
**Correction:** Audit the hierarchy against the actual frequency and sequence of user tasks. Depth is justified only when it mirrors the user's own mental model; otherwise collapse it.

---

### AI Attribution Collapse

**Tell:** AI-generated content — summaries, suggestions, labels, generated text — is rendered in the same visual register as user-generated content. The source is invisible.
**Why it fails:** Users cannot correct what they cannot identify. When AI output looks like their own input, errors accumulate silently and trust erodes on discovery. The attribution collapse is not a visual failure — it is a trust failure that presents as a visual symptom.
**Correction:** Establish a consistent AI register (lighter weight, secondary color, a mono label — pick one and hold it across every AI-authored surface in the product). The register is a single design decision applied uniformly, not a per-surface decoration.

---

## How agents use this catalog

- Cite entries by name when identifying a failure mode: "This is Settings Dumping — the product has deferred 8 decisions to user preference."
- The correction is the minimum viable fix. Name it alongside the diagnosis.
- The catalog is not exhaustive. An unnamed failure mode is still a failure mode — name it and describe it in the evaluation, then propose it as a catalog addition.
