# Examples

These are illustrative scenarios, not documented engagements. They are constructed to show how XD OS workflows, agent sequencing, and human-agent collaboration work in practice — the kinds of problems the system is designed for, the kinds of decisions it surfaces, and the dynamics that emerge when structured reasoning meets real product judgment.

They are plausible. They are not evidence. Evidence comes from use.

---

## Case Study 1: Redesigning Onboarding for a B2B Analytics Platform

**Problem:** A mid-stage B2B analytics product has a 40% drop-off between signup and first dashboard creation. The existing onboarding is a five-step wizard with tooltips, product tours, and a sample dataset. Users who complete onboarding retain well. Most don't complete it.

**Workflow used:** `/xd-design onboarding drop-off — users abandon before creating their first dashboard`

---

### How the workflow ran

**Context loading.** The project-context file — written during `/xd-init` — established: the product serves operations teams at mid-market companies, the core invariant is "time-to-first-insight must decrease with every release," and previous attempts at guided tours were rejected as patronizing. But the file also carried the team's philosophy: they had defined their brand principle as "respect the operator's time — never make them feel like a student." This wasn't a tagline. It was a decision filter that shaped every agent's reasoning downstream.

This is where team culture enters the system. A different company — one whose brand principle was "guide users to mastery" — would have gotten a different design from the same agents running the same workflow against the same problem. The `/xd-init` interview captures these positions precisely so that agents don't default to generic best practices. They reason from *your* principles.

**Historian** researched onboarding precedent. Found that the most durable pattern in B2B tools is not tutorials but *immediate productive use* — putting the user in a real task with real data before asking them to learn the system. Noted that wizard-style onboarding has consistently underperformed in retention studies for tools with complex data models.

This was the first moment that changed the product lead's thinking. She had framed the problem as "how do we improve our onboarding wizard?" The historian reframed it as "why do you have a wizard at all?" She hadn't questioned the format — only the content. Seeing the precedent research laid out, with specific examples of tools that abandoned wizards and saw retention improve, shifted her from optimizing within the existing pattern to questioning whether the pattern was the problem.

**Strategist** evaluated against product purpose — and against the team's stated brand principle. The current onboarding teaches the product. The product's purpose is insight delivery. These are misaligned — onboarding should deliver an insight, not explain how insights work. But the strategist went further: the wizard format violates "respect the operator's time" by positioning experienced operations professionals as beginners who need step-by-step guidance. The misalignment isn't just functional — it's cultural. Flagged the sample dataset as the structural problem: users learn the tool against fake data, then must re-learn it against their own.

**Architect** mapped the system boundaries. Identified that the onboarding flow is a separate state machine from the core product, creating a conceptual seam — users "graduate" from onboarding into a product that works differently than what they just learned. Proposed collapsing onboarding into the core product flow: first-run states within the real product, not a parallel track.

The product lead pushed back here. Collapsing onboarding into the core product felt risky — "What if they get lost without guidance?" The architect held the position: the conceptual seam *is* why they get lost. Users learn one system (the wizard) and then face a different system (the product). The confusion isn't from lack of guidance — it's from guidance that teaches the wrong thing. The product lead sat with this for a moment and then asked: "So the wizard is actually *causing* the drop-off, not failing to prevent it?" That was the structural insight. The architect didn't soften the recommendation; the product lead's pushback sharpened it into a clearer articulation of the problem.

**Critic** reduced the problem. Eliminated the wizard, the sample dataset, the tooltip system, and the completion tracker. Questioned whether onboarding needs to be a distinct concept at all. Proposed: the product should simply work on first use, with the first session being a guided version of a real session.

The product lead's second pushback came here — about the sample dataset. Her team had spent months curating it. "It's the best part of our onboarding. Users who engage with the sample data convert at 2x." The critic didn't dismiss this. It asked: *why* do sample-data users convert better? Is it because the sample data is good, or because those users are already motivated enough to explore? And if the sample data works, why does it need to be sample data — why not generate the same experience from the user's real data? The product lead later called this the most useful moment in the session: "I was defending the artifact instead of the outcome. The outcome was 'users see a working dashboard quickly.' The sample dataset was just one way to get there, and not even the best way."

**Designer** defined the interaction model. Two states: *empty* (no data connected) and *first-run* (data connected, no dashboards yet). Empty state presents a single action — connect your data source. First-run state presents one pre-built dashboard generated from the user's actual data, with annotation explaining what each section shows and a single prompt: "Edit this, or start a new one." No wizard. No tour. No sample data.

When the product lead saw this model, something clicked: "This isn't an onboarding redesign. We're removing onboarding entirely." That reframe — from *improving a feature* to *eliminating a category* — was something she said she wouldn't have reached on her own, not because she lacked the ability, but because she was too close to the existing system to see it as optional. The agent sequence got her there by building the case across four handoffs: the historian questioned the pattern, the strategist exposed the misalignment, the architect named the seam, and the critic removed the unnecessary. By the time the designer presented the model, the conclusion felt obvious. That's the value of the sequence — no single agent made the leap, but the accumulated reasoning made the leap inevitable for the person making the decision.

**Writer** authored the empty state and first-run copy, calibrated to the team's voice guidelines captured in project context: direct, peer-to-peer, no condescension. The empty state message: the product name, one sentence describing what it does, and a "Connect data source" action. No welcome message, no feature list, no "Let's get you set up!" enthusiasm. The first-run annotations use the user's actual metric names, not generic labels. A team with a warmer, more conversational brand voice would have gotten different copy from the same xd-writer agent — the structure would remain, but the tone would shift to match their culture.

**Heurist** evaluated for friction. Found one issue: users who connect a data source with limited data would see a sparse pre-built dashboard, which could undermine confidence. Recommended a minimum-data threshold — if the connected source has fewer than N records, show an honest message about what's possible rather than a half-empty dashboard.

**Accessibility** verified the flow. The single-action empty state and annotated dashboard both met WCAG standards. Flagged that auto-generated dashboard annotations needed sufficient color contrast against chart backgrounds.

**Specifier** produced the engineering handoff: two new product states (empty, first-run), a dashboard generation service that runs on first data connection, annotation component specifications, and the minimum-data threshold logic.

---

### What was removed

- Five-step onboarding wizard
- Product tour with tooltip overlays
- Sample dataset and its maintenance burden
- Completion progress tracker
- Welcome email sequence tied to onboarding steps
- "Getting Started" documentation section

### What was produced

- Two first-run states within the core product
- Auto-generated dashboard from real user data
- Inline annotations using the user's own terminology
- A minimum-data threshold with honest messaging
- Engineering specification for implementation

### Why it worked

The historian's precedent research prevented the team from iterating on a pattern (guided wizards) that has known structural weaknesses. The strategist caught the misalignment between teaching the product and delivering on its purpose. The critic eliminated the parallel onboarding track entirely. The designer produced a model where onboarding *is* the product — there's no graduation, no conceptual seam, no moment where the user transitions from learning to doing.

But the agents didn't produce this outcome alone. The product lead's pushback was essential to the process. Her resistance to removing the sample dataset forced the critic to articulate *why* the outcome mattered more than the artifact — a distinction she internalized and later applied to other decisions without prompting. Her initial framing ("how do we fix our wizard?") was the natural starting point for someone embedded in the product. The agent sequence didn't override her judgment — it expanded the frame around it, giving her the precedent research, structural analysis, and reductive pressure she wouldn't have applied to her own assumptions. The final decision was hers. The agents made it a better-informed one.

The memory system recorded the rejected approach (guided tours, sample data) with reasoning, so future sessions won't revisit it.

---

## Case Study 2: Defining a Notification System for a Healthcare Coordination App

**Problem:** A healthcare coordination app needs to add notifications. Clinicians use the app to manage patient handoffs between shifts. The team's initial brief: "Add push notifications for new handoffs, status changes, and messages."

**Workflow used:** `/xd-solve notification system for clinician handoff coordination`

The team chose `/xd-solve` because notifications in healthcare are a high-stakes structural decision — the wrong model creates alert fatigue in a context where missed alerts have real consequences.

Their `/xd-init` interview had captured something specific: the company was founded by former nurses, and their organizational philosophy was "clinical tools should feel like they were built by someone who's been on the floor." This wasn't a marketing statement — it was an engineering constraint. It meant every design decision would be evaluated against the question: *would a clinician who's been on shift for ten hours experience this as helpful or as noise?* That filter, loaded from `project-context.md`, shaped every agent's reasoning throughout the convergence loop.

---

### Iteration 1

**Historian** researched notification systems in clinical tools. Key finding: alert fatigue is the dominant failure mode. Studies show clinicians receive 50–100+ alerts per shift in most clinical software, and override rates exceed 90%. The systems that work use *severity tiering* and *contextual suppression* — not fewer notifications, but fewer notifications that don't matter right now.

**Designer** proposed an initial model with three tiers: critical (patient safety), actionable (requires response within shift), and informational (status updates). Critical notifications interrupt. Actionable notifications badge. Informational notifications aggregate into a shift summary.

**Critic** challenged the three-tier model. Asked: does the informational tier need to exist at all? If a notification isn't actionable, it's a status update — and status is already visible on the handoff board. Proposed eliminating the informational tier and moving those events to a "shift activity" view that the clinician pulls when they want context, rather than pushing it.

**Marketer** evaluated the notification model against user expectations and competitive positioning. Noted that most competing tools over-notify and that "quiet by default" is a defensible position in a market where clinicians actively resent their tools. But the marketer also connected this to the company's founding philosophy — "built by someone who's been on the floor" becomes tangible when your tool is the one that *doesn't* buzz during a procedure. Recommended leaning into restraint as a product principle — fewer notifications as a feature, not a limitation. The company's culture didn't just permit this recommendation; it demanded it.

**Design Director** reviewed the iteration. Verdict: the two-tier model (critical, actionable) is structurally sound, but the definitions need precision. "Critical" and "actionable" are ambiguous in clinical context — every notification a clinician receives feels critical to someone. Pushed for definitions grounded in *time-sensitivity and patient impact*, not subjective severity. Sent back for refinement.

The CTO resisted here. He felt the two-tier model was solid and wanted to move to implementation. "We're overthinking the labels. Engineers can figure out which bucket each event goes in." The Design Director's response was precise: the labels aren't for engineers — they're the *decision framework* that determines what interrupts a clinician mid-procedure. If "critical" is ambiguous, every future product decision about which tier an event belongs to becomes a judgment call with no anchor. The CTO's pushback was practical and reasonable. But the Design Director identified that shipping ambiguous definitions would create a different kind of cost — not in this sprint, but in every sprint after, as the team debates what counts as "critical" with no shared definition. The CTO agreed to one more iteration. Later, he pointed to this as the moment that saved the team months of internal arguments: "We would have shipped it, and then fought about tier classification on every new feature for a year."

---

### Iteration 2

**Designer** refined the tier definitions. Tier 1: *time-critical* — a patient handoff requires acknowledgment and the receiving clinician hasn't opened it within the escalation window. Tier 2: *shift-relevant* — a handoff assigned to you has a status change, or a colleague sent you a message. The distinction is not severity but *whether delayed response creates risk*.

The CTO had an immediate reaction: "That's it. That's the question we've been trying to articulate." The shift from severity to time-sensitivity resolved a tension the team had been circling for weeks without naming. In early planning meetings, they'd debated whether a colleague's message was "important enough" to push — a question with no right answer because importance is subjective. "Does delayed response create risk?" has a clear answer for every event type. The designer didn't invent this framing from nothing — it emerged because the Design Director's pushback in Iteration 1 forced precision, and the CTO's resistance to that pushback clarified *why* precision mattered. The human's pushback wasn't an obstacle. It was a necessary input that the convergence loop converted into a better outcome.

**Writer** defined the notification language, drawing from the voice principles in project context: clinical precision, no software jargon, written as one clinician would speak to another. Tier 1 notifications name the patient and the action needed — no preamble, no "You have a new..." framing, no app-name branding in the notification. Tier 2 notifications name the colleague and the context. All copy tested against a 2-second comprehension standard: can a clinician glance at this during a procedure and understand what's needed? The voice principles meant the xd-writer agent produced copy that reads like a colleague's shorthand, not like software speaking to a user.

**Critic** examined the escalation window concept. Found it introduces a new system parameter that requires calibration per unit (ICU escalation windows differ from general medicine). Questioned whether this complexity is necessary in v1 or whether a fixed, conservative default serves the same purpose. Recommended shipping with a single default and adding unit-specific configuration only after observing real usage patterns.

This time the CTO pushed back and *won*. He agreed with the fixed default for v1, but insisted on building the data model to support per-unit configuration from the start — not the UI, not the settings screen, just the underlying schema. "The migration cost of adding this later is real. I've done it before." The critic accepted this. It wasn't premature configurability — it was structural foresight from someone with domain-specific implementation experience. The agents don't override human expertise. When the CTO brought specific technical knowledge about migration costs that the critic couldn't evaluate, the recommendation adjusted. The final spec included the extensible schema with a hardcoded default — the CTO's position, refined by the critic's constraint.

**Design Director** reviewed. The two-tier model with time-sensitivity definitions is clear. The fixed escalation default is the right call for v1 — it reduces implementation complexity and avoids premature configurability. The extensible schema is a reasonable engineering hedge that doesn't compromise the design. The shift-activity pull model for non-actionable events is sound. Verdict: **ship**.

---

### What was removed

- Informational notification tier (moved to pull-based shift activity view)
- Per-unit escalation window configuration (deferred to v2 with usage data)
- "New message" and "status change" push notifications for non-shift-relevant events
- Notification preferences screen (two tiers don't need a preferences UI)
- Badge counts (replaced with tier-specific visual treatment)

### What was produced

- Two-tier notification model: time-critical and shift-relevant
- Time-sensitivity definitions grounded in patient impact, not subjective severity
- Fixed escalation window with v2 path for unit-specific configuration
- Shift activity view (pull-based) for non-actionable status updates
- Notification copy standards: patient name + action needed, 2-second comprehension
- Engineering specification with state machine for escalation logic

### Why it worked

The convergence loop caught a problem that a single pass would have missed. The first iteration produced a reasonable three-tier model — most teams would have shipped it. The critic's challenge (does the informational tier need to exist?) and the Design Director's push for precise definitions (not "critical" but "time-critical, defined by delayed-response risk") transformed a conventional notification system into one calibrated to how clinicians actually work.

The CTO's involvement shaped the outcome in two distinct ways. His first pushback — wanting to ship after Iteration 1 — was practical but premature. The Design Director held the line, and the CTO later recognized that the precision gained in Iteration 2 would have cost months of internal debate if left unresolved. His second pushback — insisting on an extensible schema — was domain expertise the agents lacked. The critic adjusted. This is the dynamic that makes the system effective: agents apply structured pressure that surfaces the right questions, but they yield to human expertise when the human brings knowledge the system doesn't have. The CTO didn't need the agents to tell him what to build. He needed them to help him decide what *not* to build, and to articulate the decision framework clearly enough that his team could apply it without him in the room.

The marketer's input reframed restraint as a competitive advantage rather than a missing feature — an insight that shaped the product narrative, not just the design.

The memory system recorded the decision to defer per-unit configuration (UI only — schema ships extensible, per the CTO's input), with the reasoning and the trigger condition (observed usage data) for revisiting it.

---

## Case Study 3: Exploring a New Feature Direction with `/xd-ideate`

**Problem:** A product team building a project management tool for async remote teams has noticed that users who return to the product after a gap — two or more days away — frequently log in, scan the screen for a moment, and close the app without taking any action. The team's session data confirms it: re-entry sessions under 90 seconds have a 60% same-day churn rate. Users who take an action in the first 90 seconds retain at twice the rate.

The team's initial brief to the studio: "We need to add a Today view — a dashboard that shows what needs attention."

**Workflow used:** `/xd-ideate users who return after a gap don't know where to start and often leave without acting`

---

### How the workflow ran

**Problem gate.** The team's instinct — "add a Today view" — was a solution, not a problem. The skill rejected it and asked for a reframe: *what is the user unable to do, or doing poorly?* This was a brief pause for the team. They'd been debating what the Today view should contain for two weeks. The question "what are users unable to do?" redirected the conversation. The answer: users returning after a gap can't quickly orient to what's changed and what needs them. The Today view had been proposed as an answer before the question was clear.

This reframe changed the terms. The question became: what makes re-entry disorienting, and what would make it clear? That is meaningfully different from "what should a dashboard contain?" — and it's the question that the divergence step actually ran against.

**Divergence.** Seven disciplines, each given three constraint frames — capture moment (user in motion), review moment (user returning), transition moment (context has shifted). Each discipline was limited to 1–2 ideas. The raw list:

*Historian:* Basecamp's "Hey!" page — a daily digest of what happened while you were away, pulled on demand. Survived because it respected the user's attention model: show me what changed, not what needs to be done. Proposed adaptation: a "what changed since you left" view, generated on re-entry, collapsed by default.

*Designer:* Session restoration — return the user to exactly where they left off, with a brief ambient indicator showing what changed since then. The re-entry is not a new screen; it is a continuation. Second idea: an "attention gradient" — visual weight applied to items based on recency of change, so the user's eye is guided without explicit direction.

*Architect:* A change event graph — a lightweight log of state changes (new assignments, status updates, comments) attached to each work item, queryable by "since I last saw this." The re-entry surface is a view of this graph, not a separate feature built on top of it.

*Scout:* Linear's "my issues" and GitHub's notification model — the assigned-to-me filter as re-entry point. Both tools land users on a filtered view of their own work, not a global dashboard. The insight: re-entry orientation is a personal problem, not a team-wide one. A global dashboard adds noise; a personal lens removes it.

*Marketer:* The commercial case isn't Today view features — it's time-to-first-action. Users who act within 90 seconds retain at 2×. Every second of disorientation at re-entry is a retention risk. The feature's value proposition isn't "comprehensive overview" — it's "get to your next action in one move." That framing changes what the feature should optimize for: not completeness, but speed-to-clarity.

*Writer:* The language of re-entry is wrong in most tools. "Today" implies urgency but delivers breadth. The words users actually need on return are temporal and directional: *where were you, what changed, what's next.* Proposed: replace a dashboard label with a framing sentence — "When you left, you were working on X. Since then, Y." This isn't a feature. It's a copy decision that orients before the user even looks at a list.

*Choreographer:* A brief re-entry state — a moment before content loads where the product acknowledges that time has passed. Not a loading screen. A deliberate pause: "You've been away for 3 days. Here's what to look at first." Motion is the signal; content fills in behind it. This exists in the transition between logging in and seeing work.

The full list: twelve ideas across seven lenses.

**Facilitated Reduction.** The Design Director chaired with Strategist and Critic participating.

*Strategist:* The change event graph (Architect) was marked TENSIONS — structurally interesting but introduces significant backend complexity that may be disproportionate to the re-entry problem alone. The global dashboard pattern (conventional Today view) was marked OUTSIDE — it solves the wrong problem by adding breadth when users need direction.

*Critic:* The attention gradient (Designer) was eliminated as decorative — it adds visual complexity without solving the orientation problem directly. Users don't need help noticing weight; they need help knowing what to do. The assigned-to-me filter (Scout) was flagged as already existing in most tools — including this one. If users had it and weren't using it for re-entry, adding it again solves nothing.

*Design Director:* Four survived. The team lead asked why the change event graph hadn't been eliminated with the others — the Strategist had flagged it. The Design Director held the position: the graph is TENSIONS, not OUTSIDE. Whether it's the right investment is a scoping question, not a quality question. It solves a real problem structurally. It's included because ideas that are expensive aren't wrong; they're deferred to feasibility. The four surviving ideas:

1. **Re-entry framing** — a brief temporal orientation ("you were here / since then / here's what's first") surfaced at login, using copy as the primary mechanism, not a new surface.
2. **Session restoration** — return the user to their last context, with a lightweight "since you left" indicator showing change count.
3. **Personal work lens** — a persistent "my work" view that becomes the default landing for returning users, ordered by recency of change on items assigned to them.
4. **Change event graph** — a structural layer that makes "since I last saw this" queryable across the product.

The team lead pushed back on including Re-entry framing. "That's a copy change, not a feature. Our roadmap isn't going to make room for a copywriting decision." The Design Director disagreed — the framing isn't a copy change, it's an orientation model. The copy is the mechanism, but the decision is about where and how users are oriented at re-entry. If the team treats it as a copywriting task, it will be handed to a writer after design is complete and applied as a veneer. It belongs in the ideation because it may be the right solution — and the right solution might be something product and engineering teams routinely overlook because it doesn't look like a feature. The team lead let it stand.

**Synthetic User Desirability.** The project-context file defined three archetypes: the Executor (works through assigned tasks in priority order), the Orchestrator (manages multiple workstreams and tracks dependencies), and the Async Collaborator (works across time zones, catches up on batches of changes).

*Re-entry framing:* The Async Collaborator lands here most strongly — they return from sleeping or a day away and need temporal orientation before they can act. The problem is real; they frequently describe their current behavior as "I just scroll around until I figure out where I left off." They would describe this to someone as "it tells you what changed while you were out." The Executor finds this less useful — they know exactly what's next; they don't need orientation.

*Session restoration:* The Executor lands here — returning to exactly where they left off requires no orientation. The Orchestrator finds it less useful; they're tracking multiple contexts and rarely return to the same one. Real problem for Executor, less so for the other two.

*Personal work lens:* Lands with all three archetypes but weakly — every tool they use already has a "my work" view and it hasn't solved the re-entry problem. The problem is real; the solution feels table-stakes. One archetype note: the Async Collaborator would describe it as "just a better version of what we already have," which is a low-energy endorsement.

*Change event graph:* The Orchestrator lands here strongly — they manage dependencies across multiple workstreams and the "since I last saw this" query is something they currently do manually by scanning changelogs and Slack threads. The problem is acutely real and poorly served by existing tools. They would describe it as "finally, something that tells you what actually changed without you having to find it."

One observation: Re-entry framing and Change event graph serve the same underlying need from opposite directions. Framing is surface-level and fast; the graph is structural and comprehensive. They are not redundant — they would coexist — but they represent very different investment levels for related outcomes.

**User selection.** The team lead selected Re-entry framing and Change event graph. Her reasoning: "The framing is the fastest path to testing whether orientation is actually the problem. The graph is the right structural answer if it is. We want to validate the problem quickly before committing to the graph."

This was exactly the right selection logic. The ideation had produced a cheap hypothesis (re-entry framing) and an expensive structural bet (change event graph), and the team lead read them correctly as a sequence rather than alternatives.

**Feasibility Pass.** Evaluated in turn.

*Re-entry framing:*
Implementation complexity: LOW — requires session tracking to determine last context, a re-entry state in the navigation layer, and copy. All three exist or are straightforward to add. No new data model.
What must not break: direct-link navigation (users who arrive via a notification link should not see the re-entry state), mobile/desktop parity on session state.
Heuristic concerns: the re-entry framing must not appear on every login — only after a meaningful gap (the project-context file specified 24+ hours as the gap threshold for "returning" sessions). If it fires too frequently, it becomes noise. If it fires too rarely, it doesn't solve the problem.

*Change event graph:*
Implementation complexity: HIGH — requires an event log attached to every work item, an event schema, query infrastructure, and a read model for "changes since last seen." Nothing in the current architecture supports this; it is a new subsystem.
What must not break: existing notification system (the event graph and the notification model must share the same event source or diverge intentionally), performance on workspaces with high activity volume.
Heuristic concerns: "since I last saw this" requires tracking per-user, per-item last-seen timestamps — this is a privacy and data-volume consideration that the interaction model doesn't address. Flagged as underspecified.

**DE Verdict.**

*Re-entry framing:* **PROTOTYPE.** Implementation complexity is low, the interaction model is clear, and the hypothesis can be tested quickly. Build a prototype before writing production code — the copy and the re-entry state can be validated without the full engineering investment.

*Change event graph:* **INVESTIGATE.** The structural approach is sound and the problem is real. But three questions must be answered before prototyping: (1) How does the event graph relate to the existing notification model — shared source or parallel infrastructure? (2) What is the per-user, per-item last-seen data model, and how does it scale? (3) Is 24-hour re-entry the right threshold for the Orchestrator archetype, or do they need a different gap definition? The investigation should produce architecture decisions, not a prototype. Schedule for the session after re-entry framing has been tested.

---

### What was produced

- **Re-entry framing** — cleared for immediate prototyping. A temporal orientation state at login, copy-driven, triggered by 24+ hour gaps. Validate the hypothesis before engineering investment.
- **Change event graph** — cleared for architectural investigation. Three specific questions to answer before prototyping begins.

### What was deferred

- Session restoration — right for the Executor archetype, but doesn't address the Async Collaborator's orientation problem. Revisit if re-entry framing validation shows Executors are underserved.
- Personal work lens — table-stakes; already exists in partial form. Improve before adding a new surface.

### Why it worked

The problem gate prevented the team from spending the session debating Today view contents. The reframe — from "what should a dashboard show?" to "what makes re-entry disorienting?" — took thirty seconds and changed the direction of every idea that followed.

The seven-lens divergence produced a range the team hadn't imagined. The team had been debating between a dashboard and a notification model for two weeks. Neither appeared in the final selection. Re-entry framing (Writer lens) and the change event graph (Architect lens) were outside the team's initial frame entirely. The constraint frames — capture, review, transition — forced each discipline to think specifically about the moment of return, not generically about "what users need."

The Design Director's insistence on keeping Re-entry framing over the team lead's objection ("that's a copy decision") was the most consequential moment in the session. The team lead had correctly identified that copy decisions don't get roadmap priority. The Design Director's response — that orientation is the mechanism, and copy is how it's delivered — reframed the idea as an orientation model rather than a writing task. It passed feasibility as LOW complexity and was the first idea cleared for prototyping. The team lead acknowledged afterward that if the idea had been labeled "copy change," it would have been deferred indefinitely.

The DE's verdict on the change event graph — INVESTIGATE rather than PROTOTYPE — was the right gate. The structural idea is sound; the unknowns are real. The team now has three specific questions to answer, rather than an open-ended architectural exploration. That specificity determines what the next session does, and what it doesn't.

The re-entry framing prototype will validate whether orientation is the problem. If it confirms the hypothesis, the change event graph becomes the structural investment that scales the solution. The ideation produced a sequenced hypothesis, not a feature list.

---

## Case Study 4: Managing Code Drift Under Agent-Driven Development

**Problem:** A product team has been using `/xd-implement` to ship features over several weeks. The service layer has grown without a unifying pass — a helper added during a bug fix that was never removed, a protocol defined for a single caller, a pattern duplicated between two services because the agent didn't locate the existing implementation. The code works. No bugs have surfaced. But a new feature request requires extending the service layer, and the engineer who opens the files doesn't recognize the convention in one service as the same convention under a different name in the adjacent one.

There is no crisis. There is drift. Drift compounds.

---

**Workflow used (Scenario 1):** `/xd-simplify services/`

---

### How the workflow ran

**Context loading.** The skill loaded the project-context file and the two relevant spec files. One of the services had a spec; the other didn't. The audit would proceed against the first service with a contract baseline and against the second without one — a gap the context load surfaced explicitly before any code was touched.

**Code Audit.** Five categories, scanned against the files in scope. The findings:

- *Duplication:* A `parseTimestampedPayload()` helper in `SyncService` — a functional duplicate of `decodeEventPayload()` in `EventService`, written five commits later. Same logic, different name, both callers.
- *Single-use abstraction:* A `RecordFilterable` protocol with one conforming type and one caller. The protocol adds no generality — the call site works directly with the concrete type. The protocol exists because the agent that wrote it preferred protocols at boundaries, whether or not the boundary had more than one side.
- *Orphaned code:* A `debugValidateRecord()` function referenced in a comment but called nowhere. Left over from a bug investigation.
- *Convention drift:* Two services use different async patterns — one uses `async throws`, the other uses `Result<T, Error>` completion handlers. The project-context file specifies `async throws` as the established convention.
- *Scope creep:* A `formatDisplayString()` method on a service type — presentation logic inside a service layer, not traceable to any spec.

The lead engineer looked at the audit and had an immediate reaction: "The `RecordFilterable` protocol isn't wrong. We added that intentionally — we were planning to add a second conformer." The audit had flagged it as a single-use abstraction. This was the first moment where human context mattered. The protocol wasn't accidental. The audit couldn't know that.

**Critic Pass.** The Critic distinguished load-bearing from removable. `RecordFilterable` was moved to the **Leave** column — the team had stated intent to extend it, which changes the calculus. `parseTimestampedPayload()` was flagged for removal with consolidation to the existing `decodeEventPayload()`. `debugValidateRecord()` was removed without qualification. The `formatDisplayString()` method was flagged for relocation to a formatting utility, not deletion — the logic was used; it was in the wrong layer. The async convention drift was flagged for alignment to `async throws` throughout.

The Critic's position on `formatDisplayString()` was notable: it did not recommend deletion. The function was legitimate; its location was wrong. A static analysis pass would have treated it as scope creep and flagged it for removal. The Critic evaluated what kind of problem this was — misplaced, not unnecessary — and produced a different recommendation.

**Architect Pass.** Consolidating the two payload parsers required verifying that the call sites had identical semantic contracts — same error behavior, same edge cases. They did. Aligning the async convention required checking whether any callers depended on the completion handler interface. Two external callers did. The architect added a migration note: align internal service methods first, expose the updated public interface, update callers. Sequence matters. Removing the completion handlers without updating callers would break the build.

**Distinguished Engineer — Plan Review.** The DE read the plan and the actual files.

Verdict: **PROCEED.** The plan is sound. Duplication is correctly identified and consolidated at the right location. The Critic's decision to leave `RecordFilterable` reflects information the audit didn't have — the DE noted that a comment in the protocol file should document the extension intent so a future agent doesn't flag it again. The async migration sequence is correct.

One risk flagged: `decodeEventPayload()` had a subtle difference in its null-handling path versus the duplicate. The implementation step should verify this before deleting the duplicate.

**Engineer: Implement.** Four changes, sequenced. Duplicate parser removed after confirming identical null-handling semantics. Async convention aligned internally. `formatDisplayString()` extracted to a formatting utility. `debugValidateRecord()` deleted. `RecordFilterable` left with an added inline comment documenting extension intent.

**QA.** All existing test scenarios passed. The async convention alignment required two test updates — tests that asserted on the completion handler signature, not the behavior. Behavior unchanged.

**Distinguished Engineer — Code Review.** Verdict: **SHIP.** The implementation reflects the plan. The null-handling edge case was verified before the duplicate was removed. The codebase is simpler, the conventions are coherent, and the one intentional complexity is now documented.

---

### Scenario 2: DE standalone after `/xd-implement`

A separate feature — a new search indexing behavior — was implemented via `/xd-implement`. QA passed. The spec was satisfied. The engineer invoked the Distinguished Engineer for the final code review before merging.

The DE read the spec. The spec defined one method: `index(_ record: Record)`.

The implementation was correct and complete. But the engineer had added a convenience method alongside it: `indexBatch(_ records: [Record])`, which called `index()` in a loop. No spec had authorized it. QA hadn't caught it — `indexBatch()` worked, so no test failed.

Verdict: **REVISE.**

The DE's finding: `indexBatch()` is not wrong today. It will become a problem when batch indexing needs to be optimized — transactions, write coalescing, background scheduling. At that point, the implementation will be `indexBatch()` calling `index()` in a loop, which is not how batch operations should work at scale. A future engineer will either leave it and accept the performance cost, or refactor it — but the refactor will require updating all callers who now depend on the batch interface. The convenience wrapper introduces a coupling between the public API surface and an implementation detail that isn't ready to be committed.

The engineer pushed back. "It's just a loop. It makes the call site cleaner for consumers who have multiple records."

The DE held the position. The cleaner call site is real. But the cost is forward — a public interface creates a contract; that contract constrains how batch operations can be implemented when they need to be different. The spec hadn't authorized this method because batch behavior wasn't ready to be specified. That gap was intentional, not an oversight.

`indexBatch()` was removed. Two internal call sites were updated to call `index()` directly.

DE Code Review, second pass: **SHIP.**

---

### What was removed (Scenario 1)

- `parseTimestampedPayload()` — duplicate of `decodeEventPayload()`, added five commits later
- `debugValidateRecord()` — orphaned, no callers
- Completion handler async pattern — aligned to `async throws` throughout
- `formatDisplayString()` from service layer — relocated to formatting utility

### What was preserved

- `RecordFilterable` — single conformer today, documented extension intent

### What was removed (Scenario 2)

- `indexBatch(_ records: [Record])` — convenience wrapper not authorized by spec; constrains future batch implementation

---

### Why it worked

The audit found the problems. The Critic sorted them. But the consequential work was the Critic's distinction between *misplaced* and *unnecessary* — `formatDisplayString()` needed relocation, not deletion — and the DE's identification of a coupling that no static analysis would catch.

`indexBatch()` worked. QA passed. The DE's objection wasn't about correctness — it was about what committing that interface would cost when the implementation needed to be something different. That's a judgment about durability, not about the code as written today. Linters cannot make that call. The DE made it because it read the spec, understood what the spec had deliberately not yet specified, and recognized that the convenience method had jumped ahead of a decision that hadn't been made.

The engineer's pushback — "it's just a loop" — was reasonable from inside the feature. The DE's response didn't argue about the loop. It named the mechanism: public interfaces create contracts; contracts constrain future implementations; the spec hadn't authorized this contract because batch behavior wasn't ready to be specified. That reframe shifted the question from "is this code correct?" to "is this the right moment to commit this interface?" It wasn't.

The `RecordFilterable` moment from Scenario 1 was the more instructive lesson for the team: the audit surfaced a problem, the Critic deferred to human context, and the DE added documentation so a future agent run wouldn't reopen the question. The system remembered what the audit couldn't know — because a human said so, and the plan captured it.

---

## Case Study 5: Building a Real Product with XD OS

*Coming soon.* A documented account of XD OS applied to an actual product — real decisions, real pushback, real outcomes. Not constructed. Not illustrative. The thing itself.

---

## What these cases demonstrate

**Sequencing matters.** The historian and strategist run before the designer — not because designers can't think strategically, but because separating research from synthesis produces better synthesis. The critic runs before and after design work, ensuring reduction happens at both the problem and solution level.

**Agents have boundaries.** The designer defines interaction models but defers copy to the xd-writer, visual execution to the visual designer, and motion to the xd-choreographer. This constraint prevents any single perspective from dominating and ensures each craft dimension gets dedicated attention. In a team setting, this mirrors how disciplines naturally divide — the agent structure reinforces the division rather than collapsing it.

**Memory compounds.** Each session's decisions — approved, rejected, and deferred — are recorded with reasoning. The next session starts with that context. Over weeks, the project-context file becomes a precise description of the product's design logic, not a generic brief. On a team, this means the tenth session doesn't relitigate what the third session settled.

**Removal is the primary operation.** In both cases, the most important design decisions were eliminations: the onboarding wizard, the sample dataset, the informational notification tier, the preferences screen. The "remove first" principle isn't aspirational — it's structural. The critic agent exists to enforce it.

**Convergence produces different results than single passes.** The notification system's final form — two tiers defined by time-sensitivity, not severity — only emerged through the Design Director sending the first iteration back. A single design pass would have shipped a three-tier system with ambiguous definitions. The convergence loop caught what felt reasonable but wasn't precise.

**Pushback is a feature, not a failure.** In both cases, the human's resistance to agent recommendations produced better outcomes than agreement would have. The product lead's defense of the sample dataset forced the critic to articulate the distinction between artifacts and outcomes — a thinking tool she carried forward. The CTO's insistence on shipping after Iteration 1 created the contrast that made Iteration 2's precision visible. His insistence on an extensible schema brought implementation knowledge the agents lacked. The agents are not designed to override the human. They are designed to hold positions clearly enough that the human's pushback becomes productive — either the agent's reasoning persuades, or the human's expertise refines the recommendation. Both paths improve the outcome.

**The a-ha moments belong to the human.** The agents don't produce insights. They produce the conditions for insight. The product lead's realization — "we're not redesigning onboarding, we're removing it" — was hers. The agents built the case across four handoffs, but the synthesis happened in her head. The CTO's recognition that "does delayed response create risk?" resolved weeks of ambiguous debate was his. The designer named the framing; the CTO recognized its power. This is the point of structured multi-agent work: not to think for you, but to structure the thinking so that the conclusions you reach are sharper than the ones you'd reach alone.

**Culture is a design input, not decoration.** The same XD OS agents, running the same workflows, produce materially different outputs for different teams — because `/xd-init` captures the team's philosophy, brand principles, and voice as structured decision filters, not as style guidelines applied at the end. The analytics team's "respect the operator's time" principle eliminated the onboarding wizard before design even started. The healthcare team's "built by someone who's been on the floor" philosophy made "quiet by default" an inevitability, not a choice. A venture-backed growth-stage company with a principle like "guide users to mastery" would have gotten a different onboarding model — perhaps a more progressive one — from the same agents. A healthcare competitor whose philosophy centered on "comprehensive clinical awareness" might have kept the three-tier notification model. The structure of the system stays the same. The decisions it produces change because the inputs change. This is the point of the `/xd-init` interview: not to fill out a template, but to give every agent a precise understanding of *who this team is and what they believe*, so that the work reflects the team's judgment — amplified and structured — rather than generic best practices.
