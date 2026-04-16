# Idea Card Format

Idea cards are the output of the Diverge Gem. Each card represents one distinct direction.

---

## Format

```
**[Idea name]**
Concept: [One sentence — what this is, stated as a product direction, not a feature]
Why it fits: [One to two sentences connecting this direction to the validated problem]
Differentiator: [One sentence — what makes this different from the obvious answer]
Risk: [One sentence — the specific thing that could go wrong with this direction]
```

---

## What each field does

**Idea name:** Short, specific, memorable. Not a feature name ("search") but a direction name ("Temporal retrieval" or "Thread-based navigation"). The name should hint at the structural approach.

**Concept:** Describes what this direction is at the model level — not what the UI looks like but what the underlying approach is. "Users navigate by time, not by category" is a concept. "A horizontal scroll timeline" is a visual description — wrong level.

**Why it fits:** Connects the direction to the validated problem. If you cannot make this connection explicitly, the idea doesn't belong in the set.

**Differentiator:** Names what is non-obvious about this direction. If the obvious answer to the problem is direction A, and this card is also direction A, it is not a card — it is the default. The differentiator states why this is not the default.

**Risk:** Names the specific mechanism by which this direction could fail. Not "it might not work" — what specifically could go wrong? Adoption risk, complexity risk, trust risk, scale risk, timing risk. Name the category and the specific concern.

---

## Quality standards

**Concept must be model-level.** If it reads like a feature description or a UI description, it is at the wrong level. Push up to the structural principle.

**Risk must be specific.** Vague risk ("users might not like it") is not risk — it is uncertainty. Specific risk ("this model requires users to maintain a tagging discipline that most users abandon after two weeks, as seen in prior bookmark tools") is risk.

**Max 6 cards.** If you have more than 6 ideas, reduce before presenting. Do not present all of them and ask the user to choose — the Diverge Gem does the reduction work.

**Cards must be distinct.** Two cards that represent the same structural direction should be merged. Redundant cards suggest the idea space has not been reduced enough.

---

## Example idea card

```
**Temporal scaffolding**
Concept: Content is organized and retrieved by time-based structure — not tags, not categories, but when and in what sequence things happened.
Why it fits: The problem is that months of thinking feels invisible. Temporal organization makes the arc visible — users can navigate "what I was thinking about in March" rather than searching for keywords they may not remember.
Differentiator: Most retrieval systems optimize for keyword recall; this one optimizes for temporal pattern recognition, which is how autobiographical memory actually works.
Risk: Users who don't write consistently will have sparse timelines that feel empty rather than organized — the model works for daily users but may frustrate irregular ones.
```
