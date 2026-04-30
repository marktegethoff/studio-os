---
description: Run the XD OS discovery workflow for a problem or opportunity. Activates User Researcher → Journey Mapper → Assumption Mapper → PM gate → Brief Writer in sequence. Use before design begins — especially for new product directions, underperforming features, or problems where the user's actual behavior is unclear.
argument-hint: "<problem or feature area to investigate>"
---

Run the XD OS discovery workflow for a problem or opportunity.

Arguments: $ARGUMENTS


When you reach a PAUSE block: stop, output the pause text to the user, and wait for their reply before continuing.

---

## Embedded XD OS Context

### Purpose
Discovery produces a validated product brief. The brief is the artifact that gates design. Design must not begin without it.

The discovery sequence answers three questions before committing to a design direction:
1. **What are users actually doing?** (User Researcher + Journey Mapper)
2. **What are we assuming?** (Assumption Mapper)
3. **What exactly are we solving?** (PM gate + Brief Writer)

### Disciplines
**User Researcher:** Synthesizes qualitative research — interviews, usability sessions, feedback logs. Does not conduct research; works with materials already gathered. Names sample sizes, confidence levels, contradictions.

**Journey Mapper:** Maps the user's end-to-end context — trigger, stages, entry/exit paths, friction types. Works upstream and downstream from the feature, not just inside it. Four friction types: Orientation, Effort, Confidence, Recovery.

**Assumption Mapper:** Surfaces the beliefs the team is treating as facts across four categories: User, Technical, Market, Resource. Names the binding assumption — the one whose failure would make the investment worthless.

**PM (Leadership Team):** Validates that the problem is worth solving before design begins. This is the quality gate between discovery and brief.

**Brief Writer:** Translates validated discovery into a precise handoff document — Problem (one sentence), User, Success conditions, Constraints, Out of scope, Open questions.

---

## Context

Problem or feature area: $ARGUMENTS

---

## Step 0 — Context loading

Load project context. Read in order:
1. `studio_os/project-context.md`; if not found, check `.claude/memory/project-context.md` or `memory/project-context.md`; if absent, read `CLAUDE.md` for product context — user archetypes, product invariants, any prior decisions relevant to this problem space
2. `user-profile.md` (`.claude/memory/`) — calibrate communication register

Check for existing research materials. Look for:
- Interview notes, usability session logs, or feedback files in the project
- Prior journey maps or assumption registers related to this problem
- A prior brief for this problem area (if one exists, note it — the workflow may be a revision, not a first pass)

Report what was found before proceeding.

---

## Step 1 — Research inventory

Before synthesis: establish what research exists.

Ask the user:
> "What research do you have for this problem? Interviews, usability notes, support tickets, survey data, or feedback logs? Share what you have or paste relevant excerpts — or confirm if we're working from observation and team knowledge only."

Wait for the user's response before proceeding to Step 2.

If the user has materials, proceed to Step 2 with those materials as input.
If the user has no materials, note the gap explicitly and proceed to Step 3 with the caveat that the journey map and assumption register will be based on team knowledge rather than observed user behavior. This changes the confidence level of findings.

---

> **⏸ PAUSE — Research materials needed.**
> Share any interview notes, usability session records, support tickets, survey responses, or feedback logs for this problem area.
>
> If you have none, reply **"no research materials"** and we'll proceed from team knowledge — with appropriate confidence levels.

---

## Steps 2–6 — Discovery work

### Step 2 — User Researcher (xd-user-researcher)

Apply the User Researcher discipline.

If research materials were provided:
- Inventory the research: type, sample size, recency, research question
- Extract raw observations (verbatim, no interpretation)
- Identify patterns with confidence levels (High / Medium / Low)
- Surface contradictions — name the conditions under which conflicting findings appeared
- Name research gaps: what this data does not tell us

If no research materials were provided:
- State explicitly: "No research materials provided. Findings below are based on team knowledge and should be treated as Low confidence until validated."
- Document what the team believes about user behavior as a starting hypothesis, clearly labeled as assumption rather than observation

### Step 3 — Journey Mapper (xd-journey-mapper)

Apply the Journey Mapper discipline.

Using the User Researcher output as input:

Define journey boundaries:
- **Trigger:** what event causes the user to start this journey?
- **Successful outcome:** what does the user have when it goes well?
- **Failed outcome:** what does the user experience when it doesn't?

Map the stages (3–6):
- Stage name (verb-noun)
- What the user is trying to accomplish
- Current state (what the user does today)
- What the user needs to move forward
- Friction type and description

Map entry and exit paths.

Rank the moments that matter most — which stages or transitions most determine whether the journey succeeds.

Close with: "Design brief anchor: the [n] moments above are where design attention should concentrate."

### Step 4 — Assumption Mapper (assumption-mapper)

Apply the Assumption Mapper discipline.

Surface assumptions across four categories:

**User assumptions** — beliefs about how users behave, what they want, or how they'll respond
**Technical assumptions** — beliefs about what is feasible, reliable, or buildable
**Market assumptions** — beliefs about the competitive environment, timing, or positioning
**Resource assumptions** — beliefs about what the team can accomplish

State each assumption as a testable claim: "We are assuming that [specific, falsifiable belief]."

Assess each: Confidence (H/M/L) × Impact if wrong (H/M/L).

Name the **binding assumption** — the single assumption whose failure would make this entire investment worthless. There is exactly one. Surface it first.

For the binding assumption and any Low confidence / High impact assumptions: name the cheapest validation path — the minimum effort that would move confidence from Low to Medium.

---

> **⏸ PAUSE — PM gate required.**
> Discovery complete. Before the Brief Writer produces the handoff document, the PM must validate:
>
> 1. Is the problem worth solving? Does it align with product strategy?
> 2. Are there users we know have this problem, or are we still assuming?
> 3. Is there anything in the research or assumption register that changes the go/no-go?
>
> **Reply with PM validation** (confirm, modify scope, or stop) before the brief is written.

---

### Step 5 — PM gate evaluation

Evaluate the PM's response:

- **If validated:** proceed to Step 6.
- **If modified scope:** restate the narrowed problem and confirm with the user before proceeding.
- **If stopped:** summarize the discovery output as a record of why this problem was deprioritized. Do not write a brief. Offer to write the assumption register as a file for future reference.

### Step 6 — Brief Writer (brief-writer)

Apply the Brief Writer discipline.

Produce a complete design brief using the discovery output:

```
## Design Brief: [Feature / Problem area]

**Date:** [today]
**Validated by:** [PM — confirmed in PM gate above]

---

### Problem

[One sentence: a specific user has this problem in this context, and current state fails in this way.]

### User

**Primary:** [Archetype — who, in what context, with what prior state]
**Secondary (if applicable):** [Who, in what context, and what they need that differs from primary]

### Success conditions

1. [Specific, evaluable condition]
2. [Specific, evaluable condition]
3. [Specific, evaluable condition]

### Constraints

- [What cannot change and why]
- [Technical or architectural boundary]

### Out of scope

- [Thing that might seem in scope but is not, and why]
- [Adjacent problem not being addressed]

### Open questions

- [Question] — Owner: [name / role] — Needed by: [when]

---

**Brief status:** Ready for design / Pending [open question] before design can begin
```

---

## Output

Present the complete discovery output in this structure:

```
# Discovery: [Problem Area]
Date: [today]

## Research summary
[Key patterns found — or confirmation that findings are based on team knowledge]

## Journey map
[Stages, friction points, moments that matter]

## Assumption register
[Binding assumption + full register]

## Design brief
[Complete brief from Brief Writer]

## Next step
[Ready for /design — or: blocked by [open question]]
```

If the project has a design artifacts directory, offer to write the brief there.
