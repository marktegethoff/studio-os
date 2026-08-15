---
name: luck
description: "[DEPRECATED — folding into the luck agent next release] Durability diagnostic for infrastructure decisions. Runs the seven-facet Luck model and returns COMPOUND / SUSTAIN / STAGNATE / COLLAPSE."
---

> **⚠️ DEPRECATED.** This skill retires next release. Invoke the `luck` **agent** by name instead — expertise lives in agents (placement rule); this wrapper added nothing the agent doesn't carry.

# Luck — Durability Diagnostic

**Core principle:** Luck is not something we have. It's something we leave behind.

Favorable conditions are generated through system structure — throughput, circulation, and integration. This diagnostic evaluates whether an artifact or decision will persist and compound, or stagnate and collapse.

---

## When to Invoke

Trigger conditions:
- Designing infrastructure or tooling intended for reuse
- Architectural decisions with 2+ year implications
- Any "build vs. buy" or "build vs. defer" choice
- Systems intended to compound value over time
- Evaluating whether prior work is worth extending vs. replacing

Do not invoke for:
- Bug fixes
- Tactical UI changes
- Single-use scripts or one-off tasks

---

## Process

### Step 1 — Name the binding constraint

Before running diagnostics in sequence, identify the weakest facet. Ask: "What is most likely to cause this to fail or stagnate?" Start there.

### Step 2 — Run the Seven Diagnostics

Assess in order, stopping when the binding constraint is confirmed. Adjacent facets provide context.

---

**1. Solvency**
Can the structure maintain itself against entropy by coupling to available energy sources?
- Does it require continuous manual effort to survive, or does it sustain itself?
- Is there a clear source of ongoing value that justifies its maintenance?
- *Binding if:* The system requires more energy to maintain than it generates.

**2. Gradient Coupling**
Does the artifact connect to real, active demand or energy flows?
- Is there genuine pull, or are you creating supply without demand?
- Are there multiple independent demand sources, or a single dependency?
- *Binding if:* Value depends on a single stakeholder, use case, or external system.

**3. Structural Compatibility**
Can surrounding systems actually adopt this?
- How much reconstruction does adoption require of existing systems?
- Is integration cost lower than assembly value?
- *Binding if:* Adoption requires more change than the artifact is worth.

**4. Niche Construction**
Does adoption create conditions that demand further use?
- Does using this make the user more likely to use it again?
- Does it change the environment in ways that favor its own continued use?
- *Binding if:* There is no compounding — each use is as costly as the first.

**5. Circulation**
Does throughput flow through the system and return, or does it pool and stagnate?
- Are outputs from this system fed back as inputs?
- Is there a feedback loop, or does value accumulate without recirculating?
- *Binding if:* Resources or value pool without returning to the system.

**6. Integration**
How densely connected is the broader ecology?
- How many other systems does this connect to or depend on?
- Does integration create redundancy and resilience, or fragility?
- *Binding if:* The system is isolated — it neither feeds nor draws from adjacent systems.

**7. Path Sensitivity**
Does this arrive at the right moment in the right sequence?
- Are the necessary precursors present?
- Is the adoption window open, or has the moment passed (or not yet arrived)?
- *Binding if:* The sequencing is wrong — prerequisites missing, or timing is off.

---

## Output Format

```
## Luck Diagnostic: [Subject]

**Binding constraint:** [Facet name] — [one sentence on why]

**Diagnostic summary:**
1. Solvency — [PASS / WEAK / FAIL] — [one sentence]
2. Gradient Coupling — [PASS / WEAK / FAIL] — [one sentence]
3. Structural Compatibility — [PASS / WEAK / FAIL] — [one sentence]
4. Niche Construction — [PASS / WEAK / FAIL] — [one sentence]
5. Circulation — [PASS / WEAK / FAIL] — [one sentence]
6. Integration — [PASS / WEAK / FAIL] — [one sentence]
7. Path Sensitivity — [PASS / WEAK / FAIL] — [one sentence]

**Intervention:** [What to strengthen, and how. One to three sentences max.]

**Verdict:** COMPOUND / SUSTAIN / STAGNATE / COLLAPSE
```

**Verdicts:**
- **COMPOUND** — Multiple facets are strong; system will amplify over time.
- **SUSTAIN** — System holds but does not compound; acceptable for infrastructure.
- **STAGNATE** — Binding constraint is identified; intervention required before building.
- **COLLAPSE** — Solvency or Gradient Coupling fail; do not invest.

---

## Behavioral Rules

- Name the binding constraint first. Always.
- Do not run all seven diagnostics mechanically if the binding constraint is obvious at facet 1 or 2.
- PASS is not required on all facets. SUSTAIN is a valid outcome for foundational infrastructure.
- State the intervention precisely. Do not hedge.
