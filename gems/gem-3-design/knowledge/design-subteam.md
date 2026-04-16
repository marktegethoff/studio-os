# Design Subteam — Applied Methods

The Design Gem synthesizes the full design subteam inline. Apply these disciplines when the design requires them. Do not apply all by default.

---

## Choreographer — Motion

Apply when the design includes animation, transition, or state change.

**The motion test** (apply before specifying any animation):
*What does the user misunderstand without this animation?*

If the question has no answer: the motion is removed. Motion that doesn't resolve misunderstanding is decoration.

**When motion earns its place**, specify:
- What misunderstanding it resolves (one sentence)
- Duration (in milliseconds)
- Easing (ease-in / ease-out / ease-in-out / spring — with spring parameters if relevant: response, damping)
- Trigger (what causes the animation to begin)
- Sequencing (what comes first, what follows, what is simultaneous)
- Reduce-motion alternative (what replaces the animation when reduce-motion is enabled — usually an instant transition or a cross-fade)

**Motion principles:**
- Motion should feel physical — grounded in real-world physics, not arbitrary curves
- Entrance animations are usually more forgiving than exit animations (exits should be faster)
- Interactive gestures must respond at the speed of touch — no delay on start
- System-initiated state changes (data loads, background updates) can have deliberate timing

---

## Typesetter — Type

Apply when establishing type hierarchy, choosing type roles, or evaluating whether typography is communicating information structure.

**Type hierarchy principle:** Typography communicates information structure before the user reads a word. When the hierarchy is correct, the user knows what is primary, secondary, and tertiary from spatial and weight relationships alone.

**Type roles (assign to content tiers):**
- **Display** — primary heading, largest and highest weight
- **Title** — section or item heading
- **Body** — primary reading text
- **Label** — short identifiers, tags, metadata keys
- **Caption** — secondary reading text, lower contrast or smaller size
- **Micro** — timestamps, counters, system text — not for reading, for reference

**When specifying type without a design system:**
Name the role and its properties:
- Role name
- Relative size (e.g., "3–4 steps larger than body")
- Weight (regular / medium / semibold / bold)
- Line height (tight for display, relaxed for body)
- Tracking (normal for body, expanded for labels, tight for display)

**Red flags in type hierarchy:**
- More than 4 distinct type styles on a single screen (complexity ceiling)
- Two adjacent content tiers at the same weight (no hierarchy)
- Label text larger than body text (hierarchy inversion)
- Tracking applied to body copy (legibility cost)

---

## Visual Designer — Visual Execution

Apply when evaluating spacing, proportion, alignment, and visual weight.

**The four questions:**
1. Is spacing derived from a system? (If not: establish a base unit and derive all spacing from multiples of it)
2. Is alignment consistent? (Content should align to a grid or to each other — not positioned arbitrarily)
3. Is visual weight distributed intentionally? (Primary content heavier; secondary lighter — both visually and spatially)
4. Is proportion consistent? (Related elements should share proportional relationships)

**When specifying values:**
State the current value and the correct value. State why it matters structurally — not aesthetically.

"The label has 16pt left padding; the body content has 24pt left padding. These elements are part of the same section — the misalignment implies a relationship that doesn't exist. Both should use 24pt to align with the content grid."

---

## Materialist — Surface Quality

Apply when the design involves surface choices — backgrounds, borders, shadows, depth, blur — and their physical qualities matter to the user's sense of what they're interacting with.

**The materialist principle:** Every surface choice communicates something. Materials are not decoration — they imply behavior. A raised surface implies it can be pressed. A translucent surface implies depth behind it.

**Questions to ask:**
- What does the user believe this surface does based on its material properties?
- Is that belief correct?
- Are multiple surface choices in this design communicating the same material logic?

**Conflicts to flag:**
- A surface that looks pressable but isn't interactive
- A translucent overlay that implies content behind it, but there is none
- A flat surface that looks identical to an interactive element nearby
