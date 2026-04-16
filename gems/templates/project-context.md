# Project Context Template

This file has two parts:
1. **The standing project record** — fill this in once per project and maintain it.
2. **The session header** — generate this at the start of each Gem conversation by copying the relevant fields from your standing record.

The Gems do not have memory. This file is the memory. Keep it current.

---

## How to use this

**Setup (once per project):**
Fill in every section below. The more specific you are, the better the Gems will calibrate. Vague invariants produce vague discipline. "Good design" is not an invariant. "Color is used only to carry semantic signal, never decoration" is.

**Each session:**
At the start of a Gem conversation, paste a session header using the template at the bottom of this file. You don't need to paste everything — just the fields relevant to that session. Three fields are always required: Product, System invariants, Session scope.

**After a session where a structural decision was made:**
Note the decision in the Prior decisions section below before closing. If you're using Claude Code Studio OS alongside this, log it in your decision ledger too.

---

## Standing Project Record

### Product

**Name:**
[Product name]

**One-sentence purpose:**
[What does this product do and for whom? Ex: "A personal journaling app that organizes thinking through AI-assisted structure."]

**Stage:**
[Where is it? Ex: "Pre-launch, building toward MVP" / "In beta, 200 users" / "Shipped, iterating"]

---

### Ethos

**The governing standard:**
[The quality bar your work is held to. What does "done right" feel like for this product? Ex: "Work must feel inevitable — nothing arbitrary, nothing extra, nothing essential missing."]

**Brand principles:**
[2–5 principles that shape every design and product decision. Be specific. Ex:
- Monochrome until it means something
- The instrument records; it does not perform
- AI assists structure; it does not replace authorship]

---

### System Invariants

*These are non-negotiable constraints. The Gems will treat violations as errors. Be specific.*

**[Invariant 1]:**
[Ex: "Entries are append-only. Nothing a user has written is ever deleted or rewritten."]

**[Invariant 2]:**
[Ex: "Color carries semantic signal only. It is never decorative."]

**[Invariant 3]:**
[Ex: "AI assists interpretation and organization. It does not author content or decide on behalf of the user."]

**[Add more as needed]**

---

### User Archetypes

*Who uses this product and how? Name them. The Gems will reference these when evaluating whether a design serves the right person.*

**[Archetype name]:**
[Ex: "The active thinker — writes 3–5 entries/day, primarily during focused work sessions. Values speed of capture over organization. Gets frustrated when the interface interrupts thought."]

**[Archetype name]:**
[Ex: "The reviewer — writes infrequently but reads back often. Values finding things. Frustrated by entries that feel lost."]

**[Add more as needed]**

---

### Decision Log Summary

*Key decisions already made. The Gems will not re-open these unless explicitly asked.*

**[Decision name or number] — [Date]:**
[One sentence summary. Ex: "D-023: Navigation uses a spine-based spatial model with three detents. Drawer-based navigation was rejected."]

**[Decision name or number] — [Date]:**
[One sentence summary.]

**[Add more as needed. Keep this current after every session where a structural decision is made.]*

---

### Active Constraints

*Things that are currently constrained but might change. Different from invariants — these are contextual.*

**[Constraint]:**
[Ex: "No new surfaces until thread detection ships. All design must work within the existing two-view structure."]

**[Add more as needed]**

---

### Tech Stack

*For sessions where architecture or implementation is discussed.*

**Platform:**
[Ex: "iOS 17+, SwiftUI, GRDB for local storage, Supabase for sync"]

**Key dependencies:**
[Ex: "FoundationModels for on-device AI, Apple Intelligence required"]

**Current architecture notes:**
[Ex: "NavigationStack-based with ZStack spatial model. ComposeView always rendered, hidden when nav path is non-empty."]

---

## Session Header Template

*Copy this block at the start of each Gem conversation. Remove sections that aren't relevant to the session. The three required fields are marked.*

```
## Session Context

Product: [name + one-sentence purpose]                           ← REQUIRED
System invariants: [paste relevant invariants from above]        ← REQUIRED
Session scope: [what I'm trying to accomplish today]             ← REQUIRED

Ethos: [paste governing standard and brand principles]
User archetypes: [paste relevant archetypes]
Prior decisions that constrain this: [paste relevant decisions]
Active constraints: [paste relevant constraints]
Tech stack: [paste if architecture is in scope]
```

**Minimum session header (most sessions):**
```
## Session Context

Product: [name] — [one-sentence purpose]
System invariants: [2–3 most relevant]
Session scope: [one sentence on what I'm doing today]
```

**Full session header (structural decisions, new directions):**
```
## Session Context

Product: [name] — [one-sentence purpose]
Ethos: [governing standard]
System invariants: [all that apply]
User archetypes: [names + one sentence each]
Prior decisions that constrain this: [decision names/numbers + one-sentence summary]
Active constraints: [what is currently off-limits]
Session scope: [what I'm trying to accomplish today]
```

---

## Handoff notes between Gems

*When moving from one Gem to another in a single work session, paste both the session header and the output of the prior Gem. The receiving Gem reads this as its full context.*

**Example: Gem 1 → Gem 3 (Problem → Design)**
```
[Paste session header]

---

From Problem Gem:
[Paste the product brief output — validated problem, success definition, key constraints]

Session scope: Design the [surface] that solves the validated problem above.
```

**Example: Gem 3 → Gem 4 (Design → Critique)**
```
[Paste session header]

---

From Design Gem:
[Paste the interaction model or design artifact]

Session scope: Evaluate the design above for shipping readiness.
```
