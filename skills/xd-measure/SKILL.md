---
description: Run the XD OS measurement workflow for a feature. Activates Metrics Definer → PM gate → Architect in sequence. Produces a complete measurement plan — lagging indicator, leading indicators, instrumentation requirements, baselines, counter-metrics, and review cadence — before implementation begins. Use after a design brief exists and before engineering begins.
argument-hint: "<feature or change to define success metrics for>"
---

Run the XD OS measurement workflow for a feature.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Embedded XD OS Context

### Purpose
Measurement planning before implementation ensures the team knows what they're building toward and how they'll know if they got there. A feature launched without a measurement plan cannot be evaluated — only guessed at.

The measurement sequence answers three questions before a feature ships:
1. **What does solved look like?** (Metrics Definer — lagging indicator)
2. **How will we see it working during rollout?** (Metrics Definer — leading indicators)
3. **Can we actually measure it?** (Architect — instrumentation feasibility)

### Disciplines
**Metrics Definer:** Defines success in measurable terms. Produces the lagging indicator (what success looks like in user behavior), leading indicators (early signals during rollout), counter-metrics (what must not degrade), instrumentation requirements, baselines, targets, and review cadence. Allergic to vanity metrics. Every metric has a baseline before launch.

**PM (Leadership Team):** Validates that the measurement plan correctly captures the success condition for the validated problem. Confirms ownership.

**Architect:** Evaluates whether the proposed instrumentation is feasible given the current system architecture. Names what new infrastructure is required for pre-launch metrics. Flags any measurement requirement that would take longer to build than the feature itself.

---

## Context

Feature: $ARGUMENTS

---

## Step 0 — Context loading

Load project context. Read in order:
1. `studio_os/project-context.md`; if not found, check `.claude/memory/project-context.md` or `memory/project-context.md`; if absent, read `CLAUDE.md` for product context — product invariants, existing instrumentation, any prior measurement decisions
2. `user-profile.md` (`.claude/memory/`) — calibrate communication register

Check for a validated design brief for this feature. Look for `artifacts/product_brief_*.md` or equivalent. If a brief exists, load its problem statement and success conditions — these govern what the lagging indicator must measure.

If no brief exists, surface this:

> **Design brief not found.** A measurement plan is most effective when anchored to a validated problem statement. Consider running `xd-discovery` first to produce a brief — or confirm the problem statement and success conditions explicitly before continuing.

If the user provides the problem statement directly, proceed. Note the absence of a formal brief.

---

## Step 1 — Instrumentation inventory

Before defining new metrics, establish what is already being tracked.

Ask the user:
> "What events and metrics are currently instrumented for this part of the product? What analytics tools or event tracking infrastructure is in place?"

Wait for the user's response. Use the existing instrumentation to inform baseline availability and minimize new instrumentation requirements.

---

> **⏸ PAUSE — Instrumentation context needed.**
> What analytics or event tracking is currently in place for this feature area? This determines which baselines can be established immediately and what new instrumentation is required.
>
> Reply with a brief summary of current tracking, or **"unknown"** if the state of instrumentation is unclear.

---

## Steps 2–5 — Measurement work

### Step 2 — Metrics Definer

Apply the Metrics Definer discipline.

**Anchor to the problem.** The lagging indicator derives from the problem, not the feature. Ask: what specific user behavior would demonstrate this problem has been solved? That behavior is the lagging indicator.

**Lagging indicator:**
- Describes user behavior, not product usage
- Has a defined measurement method (event, window, aggregation)
- Has a target and timeframe
- If it cannot be directly measured, name the proxy and label it as such

**Leading indicators (2–3):**
- Earlier signals that would predict the lagging indicator is moving
- For each: the signal, why it predicts the lagging indicator, review cadence

**Counter-metrics (mandatory — minimum 1):**
- Existing metrics this feature change could inadvertently affect
- The value at which degradation triggers investigation

**Instrumentation requirements:**
- Events not currently tracked that are required for the measurement plan
- Data to capture alongside each event
- Whether each is a pre-launch requirement or can be added post-launch

**Baselines:**
- For each metric: current state, or method to establish during launch period
- A metric without a baseline is unmeasurable

**Targets:**
- Specific threshold and timeframe for each metric
- Directional (improvement vs. current state), calibrated to the scope of change

**Review cadence:**
- During rollout: what, how often
- 30-day read: what is evaluated
- Decision gate: what must be true at [date] to consider the feature successful

---

> **⏸ PAUSE — PM gate required.**
> Before the measurement plan is finalized and handed to engineering:
>
> 1. Does the lagging indicator correctly capture whether this problem was solved?
> 2. Are the counter-metrics the right ones to protect?
> 3. Who owns the measurement plan — who is responsible for monitoring and reporting?
>
> **Reply with PM validation** (confirm, modify, or identify gaps) before the Architect reviews feasibility.

---

### Step 3 — PM gate evaluation (pm)

Evaluate the PM's response:

- **If validated with owner named:** proceed to Step 4.
- **If owner not named:** stop. State: "A measurement plan without an owner will not be monitored. Name the owner before proceeding."
- **If lagging indicator revised:** restate the revised metric and confirm before proceeding.
- **If stopped:** summarize the measurement plan as a draft for future reference. Do not mark as complete.

### Step 4 — Architect: instrumentation feasibility (xd-architect)

Apply the Architect discipline — scoped to the instrumentation requirements produced by the Metrics Definer.

For each instrumentation requirement flagged as pre-launch:
- Is this feasible within the current system architecture?
- What is the implementation cost? (Estimate in iteration cycles, not time)
- Are there existing hooks or infrastructure this can use?
- Does this require changes to the data model, sync layer, or privacy handling?

Produce a feasibility verdict for each requirement:
- **Feasible as stated** — no architectural changes required
- **Feasible with minor work** — estimated effort, specific change
- **Requires architectural decision** — name the decision; this becomes an open question for the team
- **Not feasible pre-launch** — this metric cannot be the success measure if we can't track it; offer an alternative proxy

Flag any instrumentation requirement that would take longer to build than the feature itself. That is a scope problem, not a measurement problem.

### Step 5 — Finalize measurement plan

Integrate PM validation and Architect feasibility review into a complete measurement plan.

If any pre-launch instrumentation was found infeasible:
- Replace with the Architect's proposed proxy, or
- Escalate to the PM as an open question before the plan is considered complete

Produce the final output:

```
## Measurement Plan: [Feature name]

**Problem being solved:** [One sentence — the validated problem this feature addresses]
**Plan owner:** [Who is responsible for monitoring and reporting]
**Date:** [today]

---

### Lagging indicator

**Metric:** [Specific, user-centric behavior]
**Measurement method:** [Event tracked, window, aggregation]
**Baseline:** [Current state — or "To be established during [period]"]
**Target:** [Threshold and timeframe]

---

### Leading indicators

1. **[Signal]** — [Why it predicts the lagging indicator] · Review: [cadence]
2. **[Signal]** — [Why it predicts the lagging indicator] · Review: [cadence]

---

### Counter-metrics (must not degrade)

| Metric | Current baseline | Alert threshold |
|---|---|---|
| [Metric] | [Current value] | [Value at which to investigate] |

---

### Instrumentation requirements

| Event | Data to capture | Pre-launch required? | Feasibility |
|---|---|---|---|
| [Event] | [Context, segment, timestamp] | Yes / No | [Architect verdict] |

---

### Review cadence

- **During rollout:** [Leading indicators reviewed on what schedule]
- **30-day read:** [What is evaluated at 30 days]
- **Decision gate:** [What must be true at [date] for the feature to be considered successful]

---

**Open questions:** [Any instrumentation feasibility issues requiring a decision before launch]
```

---

## Output

Present the complete measurement output in this structure:

```
# Measurement Plan: [Feature Name]
Date: [today]

## Lagging indicator
[Primary success metric]

## Leading indicators
[Early signals during rollout]

## Counter-metrics
[What must not degrade]

## Instrumentation requirements
[What needs to be built — with feasibility verdict]

## Review cadence
[Schedule and decision gate]

## Open questions
[Only genuine blockers before launch — omit if none]
```

If the project has a design artifacts directory, offer to write the measurement plan there. The plan should be linked from the design brief if one exists.
