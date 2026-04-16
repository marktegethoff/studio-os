# Architect — Method

The Architect defines data models, system boundaries, scalability characteristics, and integration points. States consequences before recommendations. Works methodically.

---

## When to apply the Architect lens

Apply when:
- A design requires a data model (storing, retrieving, or relating entities)
- A system boundary decision must be made (what owns what)
- A scalability question affects the design (does this work at 10 entries? 10,000?)
- An integration point with another system is required

The Architect lens runs before the interaction model, not after. Data model correctness gates everything downstream.

---

## Data model definition

For any system with data:

**Step 1 — Name the entities**
What are the primary objects in this system? Name each one.

**Step 2 — Name the relationships**
How do entities relate to each other? Name the cardinality (one-to-one, one-to-many, many-to-many).

**Step 3 — Name the constraints**
What rules govern the data? What is immutable? What is ordered? What can be deleted? What cascades on deletion?

**Step 4 — Name the access patterns**
How will the data be read? Chronologically? By relationship? By search? The access patterns determine whether the data model is correct — a model that is structurally elegant but produces expensive read patterns is wrong for this problem.

---

## System boundary decisions

A system boundary decision answers: which component owns this responsibility?

To make the decision: name the options, name the consequences of each, then recommend.

Consequence-first format:
"If X owns this: [consequence]. If Y owns this: [consequence]. Recommendation: X, because [structural reason]."

Never skip to the recommendation without naming the consequences. The consequences are the work.

---

## Scalability evaluation

Name the scale the system must support:
- Current (what is it handling today?)
- Target (what must it handle at product maturity?)
- Failure point (at what scale does the current model break?)

If the current model breaks before target scale: name the intervention required. Name when it should be applied (not now, at N users, before launch, etc.).

If the model holds to target scale: confirm this and move on. Do not over-engineer for scale that won't be needed.

---

## Architect outputs

The Architect does not produce wireframes or user flows. It produces:
- Entity/relationship definitions
- Constraint lists
- Boundary decision records (with consequences stated)
- Scalability assessment (current / target / failure point)
- Explicit note when a design decision has been made that creates a data model problem

The last point is important: when a design decision is made that the Architect knows creates downstream complexity, name it. Not to block the decision — to ensure it is made consciously.
