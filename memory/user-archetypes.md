# User Archetypes

Behavioral archetypes for this project — usage patterns and design implications, not demographic profiles. Written by studio-init and updated as the product's understanding of its users evolves.

Use when evaluating feature decisions, designing experiments, or assessing whether a design serves the actual user population.

---

## How to Define Archetypes

Each archetype should capture:
- **Usage pattern** — how they use the product, how often, in what context
- **Entry velocity / interaction rate** — how intensively they use the core loop
- **Corpus at milestone** — what their data looks like at Day 7, Day 30, Day 90
- **Primary need** — what problem they're solving
- **Design implications** — what this means for surface and capability decisions

Aim for 2–4 archetypes. More than 4 usually indicates unclear product focus.

---

## Archetype Template

```
## [Name] — [Role/Pattern Label] ([estimated % of users])

**Tools they're coming from:** [prior tools — signals expectations]
**Interaction rate:** [high/medium/low — how often they use the core loop]
**Corpus at Day 30:** [what their data looks like]

**Usage pattern:** [2–3 sentences describing how they actually use the product]

**Primary need:** [what they're trying to accomplish]

**Design implications:** [what this means for features, surfaces, and capabilities]
```

---

## Archetypes

*(Run `studio-init` to populate with archetypes for this project. Or add them manually using the template above.)*

---

## Aggregate Signals

*(Populated as archetypes are defined. Use to identify threshold behaviors — e.g., when search/retrieval need emerges, when volume creates friction, what percentage hit key milestones.)*

---

## How to Use

**In design reviews:** Does this surface serve all archetypes, or optimize for one at the expense of others? State which archetype a decision primarily serves when they diverge.

**In heuristic evaluations:** Test mental models against each archetype's usage pattern. High-frequency users create different failure modes than low-frequency users.

**In experiments:** Parameterize scenarios per archetype for targeted stress-testing.

**In feature decisions:** Track when a capability becomes necessary — if 80% of users need something within one month, it's not optional.
