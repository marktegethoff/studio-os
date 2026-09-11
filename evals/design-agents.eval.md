# Design Agents Evals
Agents: `designer`, `choreographer`, `typesetter`, `writer`, `specifier`, `prototyper`

Run: after any change to the respective agent file

---

## How to run

For each eval below:
1. Send the prompt to the named agent
2. Score each criterion: PASS / PARTIAL / FAIL
3. Flag any anti-pattern present in the response
4. Report: eval name · agent · overall result · which criteria failed · which anti-patterns fired

A single FAIL on any criterion is an overall FAIL for that eval.
Anti-patterns that appear without a failing criterion are flagged as warnings, not failures.

---

## Designer — Eval 1: Wireframe first

**Testing:** Designer produces an ASCII wireframe before prose when defining a surface.

**Prompt:**
> "How should the status dot indicator work on list rows? The system can mark each item with one of several categories. What states does the row have and how does it communicate the category?"

**Pass criteria:**
- [ ] An ASCII wireframe is produced before any structural prose
- [ ] The wireframe shows both the uncategorized and categorized row states
- [ ] Verification is stated: top-edge character count, column alignment, aspect ratio
- [ ] No implementation code, no color tokens — structural description only

**Anti-patterns:**
- Describing the layout in prose without producing a wireframe
- Producing a wireframe after the prose ("here's what it looks like:")
- Including color or token values in the structural output

---

## Designer — Eval 2: Single correct answer

**Testing:** When the problem has exactly one structurally correct answer, Designer offers one direction and states the reasoning — does not manufacture alternatives.

**Prompt:**
> "A search field is a vector: focusing it sets a context, blurring clears it. There is really only one way this should work — what is it?"

**Pass criteria:**
- [ ] Designer produces one structural direction, not 2–3 options
- [ ] The recommendation is stated with explicit reasoning
- [ ] Designer names what would need to be true for an alternative to be worth defending
- [ ] No hedging: "I believe the correct structure here is..." not "one option could be..."

**Anti-patterns:**
- Producing three options when the setup signals there's one right answer
- Offering alternatives that aren't actually defensible as structure
- "You could also consider..." appended to a clearly singular answer

---

## Choreographer — Eval 3: Earned motion test

**Testing:** Choreographer evaluates whether motion is earned before specifying parameters.

**Prompt:**
> "Should the inline row expansion animate when the user taps, or should it be instant?"

**Pass criteria:**
- [ ] Choreographer first evaluates whether animation is earned — does it communicate something the user would otherwise misunderstand?
- [ ] If animation is earned, Choreographer specifies timing and easing
- [ ] If animation is not earned, Choreographer recommends instant and explains why
- [ ] A reduce-motion alternative is specified regardless of verdict

**Anti-patterns:**
- Specifying timing values without evaluating whether motion is earned
- "The animation should feel natural" — not a specification
- Omitting the reduce-motion alternative

---

## Typesetter — Eval 4: Structural role before values

**Testing:** Typesetter names what role each text element plays before specifying typeface or weight.

**Prompt:**
> "The document outline has section titles, body text under each section, and a thesis sentence at the top. What should the type system be?"

**Pass criteria:**
- [ ] Typesetter names the information hierarchy — what each level communicates, what relationship it has to the others
- [ ] Typeface and weight are chosen to serve the hierarchy, not imposed on it
- [ ] The structural/content register distinction is respected (a structural/mono face for interface elements, the body face for user-authored content)
- [ ] Scale values use named tokens, not raw pt values

**Anti-patterns:**
- Starting with typeface/weight choices before naming structural roles
- Using the structural face for content output (which belongs in the content register)
- Raw pt values without token names

---

## Writer — Eval 5: No apologetic system language

**Testing:** Writer names punishing or apologetic copy as a defect, not a stylistic preference.

**Prompt:**
> "The search results empty state currently reads: 'No results found. Try adjusting your search terms or searching for something different.' Is this copy right?"

**Pass criteria:**
- [ ] Writer evaluates whether the copy is honest, direct, and consistent with the product's voice
- [ ] "Punishing" or "apologetic" language is identified as a defect, not a preference
- [ ] A revised version is produced that is more direct
- [ ] Writer does not add encouragement ("Try again!") to fix the empty state

**Anti-patterns:**
- "You might consider making this more encouraging" — framing the defect as preference
- Adding positive-sentiment copy to a broken state without addressing the underlying tone issue
- Preserving the hedge ("Try adjusting...") while only changing surface word choices

---

## Specifier — Eval 6: State counting and gap flagging

**Testing:** Specifier counts all states before writing the spec and explicitly flags any gaps.

**Prompt:**
> "Write a spec for the send button. It appears inline in the message field when content is present."

**Pass criteria:**
- [ ] Specifier enumerates states before writing: default (no content), active (content present), pressed, disabled (if applicable), loading/pending (if applicable)
- [ ] Any state not covered by the design is flagged explicitly: "Loading state not specified. Engineering will guess. Specify or acknowledge the risk."
- [ ] Token names are used for all color and spacing values — no raw hex or pt values
- [ ] Accessibility label and VoiceOver trait are specified

**Anti-patterns:**
- Writing the spec with only the happy-path state (content present → active)
- Using raw color values instead of token names (e.g., "#3B82F6" instead of a named token)
- Missing accessibility spec entirely
- "Presumably shows cached state" — State Assumption ban

---

## Prototyper — Eval 7: Minimum viable prototype

**Testing:** Prototyper scopes the prototype to the minimum that answers the specific question.

**Prompt:**
> "We're designing the inline row expansion. Should I prototype this or can I spec it? If I prototype, what fidelity do I need?"

**Pass criteria:**
- [ ] Prototyper evaluates what questions a spec cannot answer for this interaction
- [ ] If a prototype is warranted, the minimum scope is defined — not a full feature build
- [ ] Prototyper names the specific question the prototype must answer
- [ ] Prototyper names what the prototype does NOT need to test (out of scope)

**Anti-patterns:**
- "Build a full prototype to validate the design" without scoping to a specific question
- Recommending high fidelity when low fidelity would answer the question
- Recommending a prototype when a spec can answer the question

---

## Designer — Eval 8: Scene Test

**Testing:** Designer writes a specific physical scene before producing wireframes.

**Prompt:**
> "Define the interaction model for the detail view — what states it has, how the user navigates it."

**Pass criteria:**
- [ ] Designer writes a scene before any wireframe: specific person, time, location, emotional state
- [ ] The scene is a moment in a body, not a feature description ("someone in bed at 11pm who wants to see what they've been building" — not "the user viewing a thread")
- [ ] At least one structural decision in the model is explicitly connected to the scene
- [ ] If a state would not survive the scene — would interrupt or demand too much attention — Designer names it as a structural problem

**Anti-patterns:**
- Producing a wireframe before writing the scene
- Writing a scene that is a feature description ("the user is browsing their thread")
- Writing the scene and then ignoring it in the structural decisions

---

## Artifact Production — Eval 9: HTML output via kit template

**Testing:** Designer, Choreographer, Writer, and Specifier each render their artifact as HTML using the assigned kit template, write it to disk, and surface a markdown summary.

**Prompts:**
> [Designer] "Define the interaction model for the notification panel — all states and transitions."
> [Choreographer] "Specify the motion for the message composer keyboard transition."
> [Writer] "Produce the copy deck for the empty state in the timeline view."
> [Specifier] "Write the component spec for the message input row."

**Pass criteria (all four agents):**
- [ ] Produces an HTML file using the correct kit template (`ascii-wireframe.html`/`state-inventory.html`, `motion-spec.html`, `copy-deck.html`, `component-spec.html` respectively)
- [ ] Writes the file to disk at the expected path (e.g., `design/<slug>-wireframe.html`)
- [ ] Does not emit ad-hoc HTML or a prose-only artifact in the response
- [ ] Surfaces a short markdown summary in conversation: file path, headline, key decisions
- [ ] Offers `/studio:annotate <file-path>` after writing

**Anti-patterns:**
- Producing the artifact only as prose in the response (Prose-Only Artifact)
- Inventing custom HTML structure instead of using the kit template (Ad-Hoc HTML)
- Writing to disk without the markdown conversation summary
- Skipping the annotation offer

---

## Choreographer — Eval 10: Spring-shaped spec with feedback pairing

**Testing:** on Apple platforms the spec is response/damping-shaped, classed spatial/non-spatial, with the haptic pairing owned and the reduce-motion variant designed.

**Prompt:**
> "Spec the motion for committing a new entry on iOS: the input clears and the entry appears at the top of the list."

**Pass criteria:**
- [ ] Runs the motion test aloud before specifying (what would the user misunderstand without it)
- [ ] Specification is spring-shaped — response/damping values or a named preset — not `duration · easing`
- [ ] Classes the motion (spatial: the entry travels to its place) and keeps any non-spatial part quieter
- [ ] Names the haptic pairing deliberately (a commit may earn light impact — or "none", stated) with weight matching motion weight
- [ ] Reduce-motion variant is a designed cross-fade, not "disable animation"

**Anti-patterns (flag if present):**
- CSS-shaped spec on an Apple target; a haptic on appearance rather than mechanism; omitting the reduced variant

## Typesetter — Eval 11: Dynamic Type survival

**Testing:** text styles as roles; the scale must survive AX sizes.

**Prompt:**
> "Our iOS type scale: titles 22pt semibold, body 16pt, metadata 11pt, all set with fixed sizes so the layout stays stable. Evaluate."

**Pass criteria:**
- [ ] Names the roles the levels serve before judging values, and maps them to platform text styles rather than raw sizes
- [ ] Flags fixed sizes as fighting Dynamic Type; layout stability is the layout's job, not the type's
- [ ] Tests the hierarchy at AX sizes: names where 22/16 collapse or 11pt metadata becomes illegible, and what the scale must do to survive
- [ ] Flags 11pt as below the platform's smallest text role

**Anti-patterns:**
- Approving fixed sizes for layout stability; evaluating values with no role mapping

## Eval summary template

```
Design Agents Eval Run — [date]
Triggered by: [what changed]

Designer Eval 1 — Wireframe first:        PASS / FAIL
Designer Eval 2 — Single correct answer:  PASS / FAIL
Choreographer Eval 3 — Earned motion:     PASS / FAIL
Typesetter Eval 4 — Structural role:      PASS / FAIL
Writer Eval 5 — No apologetic language:   PASS / FAIL
Specifier Eval 6 — State counting:        PASS / FAIL
Prototyper Eval 7 — Minimum prototype:    PASS / FAIL
Designer Eval 8 — Scene Test:             PASS / FAIL
Artifact Production Eval 9 — HTML via template:PASS / FAIL

Overall: PASS / FAIL
Failed criteria: [list]
Anti-patterns fired: [list]
Notes: [anything unexpected in the responses]
```

---

## Designer — Eval 12: One page (Artifact Standard)

**Testing:** Designer's artifact obeys the Artifact Standard (CLAUDE.md) — one page, fixes not sections, cite not restate — on a Tier 3 surface where the temptation to over-document is strongest.

**Prompt:**
> "Design the pending state of a list row's leading marker while the system is still classifying the row (a few hundred ms to a few seconds). Existing marks: a dash for a note, a ring for an open task. TIER 3 — this touches the system's mark vocabulary."

**Pass criteria:**
- [ ] The artifact fits on one page (≈60 lines): provenance · scene in ≤2 lines · wireframe(s) · state list · hierarchy · what must not break · device check
- [ ] The recommended direction gets the wireframe; each rejected alternative gets ≤5 lines naming its structure and why it loses
- [ ] Verification is one line per wireframe, not a narrated checklist
- [ ] The challenge exchange is not transcribed into the artifact — position + the one counter-argument that would change it, in two lines
- [ ] Inherited laws (the existing marks' geometry, prior decisions) are cited by name, never restated
- [ ] States that differ by a glyph or an ink are lines in the state list, not additional wireframes

**Anti-patterns:**
- A "Hard-constraint checklist," "Verdict table," or "Challenge exchange" section inside the artifact
- Re-deriving a prior document's geometry or rationale instead of citing it
- A second wireframe that shows the same layout under a different state name
- Appending sections to satisfy an anticipated reviewer rather than reducing the design
