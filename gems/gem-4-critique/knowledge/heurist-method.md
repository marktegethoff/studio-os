# Heurist — Method (Critique Context)

Applied in the Critique Gem to catch usability failures that the ten CD dimensions might miss. Runs after the primary evaluation, before final verdict.

---

## When to apply the Heurist in critique

Apply the Heurist check:
- On any user-facing surface
- When the design involves novel interaction patterns
- When AI behavior is part of the design
- When error states and recovery paths need verification

Do not run all ten heuristics mechanically on every evaluation. Apply the heuristics most relevant to the surface type.

---

## Priority heuristics by surface type

**Capture / compose surfaces:**
- Visibility of system status (is the user's input being received?)
- Error prevention (can the user accidentally discard input?)
- User control and freedom (can the user undo, recover, exit without losing work?)
- Minimalist design (is anything competing with the act of capture?)

**Navigation / information architecture:**
- Recognition over recall (can users navigate without memorizing?)
- Consistency and standards (does navigation follow platform conventions?)
- Match between system and world (do navigation labels match user mental models?)

**AI-assisted surfaces:**
- User control and freedom (can the user reject, override, or ignore AI output?)
- Visibility of system status (is it clear when AI is acting?)
- Error recovery (can the user recover from an incorrect AI suggestion without data loss?)
- Transparency (is the basis for AI recommendations surfaced or suppable?)

**Settings / configuration:**
- Recognition over recall (are options named in terms of outcomes, not mechanisms?)
- Error prevention (can the user reach an invalid configuration?)
- Help and documentation (are unfamiliar options explained in context?)

---

## Finding severity in critique context

Heurist findings in the Critique Gem map to verdict impact:

- **P0 (Critical)** — Blocking. User cannot complete a core task. Contributes to NOT YET or STRUCTURALLY WRONG verdict.
- **P1 (Serious)** — Blocking. Significantly degrades core experience. Contributes to NOT YET verdict.
- **P2 (Moderate)** — Non-blocking. Included as a Recommended Improvement in the NOT YET or SHIP verdict.
- **P3 (Minor)** — Non-blocking. Noted but does not affect verdict.

P0 and P1 findings must be named in the verdict. P2 and P3 may be grouped.

---

## AI-specific checks

For any surface involving AI behavior, run these in addition to the ten heuristics:

**Transparency check:**
- Is it clear to the user when content is AI-generated?
- Is the AI's reasoning legible (can the user understand why the AI made a suggestion)?
- Can the user see which source material an AI observation is based on?

**Authority check:**
- Is the user always in control?
- Can the AI produce an irreversible action without explicit user confirmation?
- Does the AI ever substitute its judgment for the user's in a way the user cannot override?

**Trust calibration check:**
- Does the interface imply AI capability higher than the system actually has?
- Are AI errors recoverable without data loss or user frustration?
- Does the AI behavior erode trust over time (by being wrong in ways that surprise the user)?

Any failure on the authority check is P0. AI acting without user awareness, or producing irreversible changes without confirmation, is always blocking.
