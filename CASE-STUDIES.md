# Case Studies

These are illustrative scenarios, not documented engagements. They are constructed to show how Studio OS workflows, agent sequencing, and human-agent collaboration work in practice — the kinds of problems the system is designed for, the kinds of decisions it surfaces, and the dynamics that emerge when structured reasoning meets real product judgment.

They are plausible. They are not evidence. Evidence comes from use.

---

## Case Study 1: Redesigning Onboarding for a B2B Analytics Platform

**Problem:** A mid-stage B2B analytics product has a 40% drop-off between signup and first dashboard creation. The existing onboarding is a five-step wizard with tooltips, product tours, and a sample dataset. Users who complete onboarding retain well. Most don't complete it.

**Workflow used:** `/studio-design onboarding drop-off — users abandon before creating their first dashboard`

---

### How the workflow ran

**Context loading.** The project-context file — written during `/studio-init` — established: the product serves operations teams at mid-market companies, the core invariant is "time-to-first-insight must decrease with every release," and previous attempts at guided tours were rejected as patronizing. But the file also carried the team's philosophy: they had defined their brand principle as "respect the operator's time — never make them feel like a student." This wasn't a tagline. It was a decision filter that shaped every agent's reasoning downstream.

This is where team culture enters the system. A different company — one whose brand principle was "guide users to mastery" — would have gotten a different design from the same agents running the same workflow against the same problem. The `/studio-init` interview captures these positions precisely so that agents don't default to generic best practices. They reason from *your* principles.

**Historian** researched onboarding precedent. Found that the most durable pattern in B2B tools is not tutorials but *immediate productive use* — putting the user in a real task with real data before asking them to learn the system. Noted that wizard-style onboarding has consistently underperformed in retention studies for tools with complex data models.

This was the first moment that changed the product lead's thinking. She had framed the problem as "how do we improve our onboarding wizard?" The historian reframed it as "why do you have a wizard at all?" She hadn't questioned the format — only the content. Seeing the precedent research laid out, with specific examples of tools that abandoned wizards and saw retention improve, shifted her from optimizing within the existing pattern to questioning whether the pattern was the problem.

**Strategist** evaluated against product purpose — and against the team's stated brand principle. The current onboarding teaches the product. The product's purpose is insight delivery. These are misaligned — onboarding should deliver an insight, not explain how insights work. But the strategist went further: the wizard format violates "respect the operator's time" by positioning experienced operations professionals as beginners who need step-by-step guidance. The misalignment isn't just functional — it's cultural. Flagged the sample dataset as the structural problem: users learn the tool against fake data, then must re-learn it against their own.

**Architect** mapped the system boundaries. Identified that the onboarding flow is a separate state machine from the core product, creating a conceptual seam — users "graduate" from onboarding into a product that works differently than what they just learned. Proposed collapsing onboarding into the core product flow: first-run states within the real product, not a parallel track.

The product lead pushed back here. Collapsing onboarding into the core product felt risky — "What if they get lost without guidance?" The architect held the position: the conceptual seam *is* why they get lost. Users learn one system (the wizard) and then face a different system (the product). The confusion isn't from lack of guidance — it's from guidance that teaches the wrong thing. The product lead sat with this for a moment and then asked: "So the wizard is actually *causing* the drop-off, not failing to prevent it?" That was the structural insight. The architect didn't soften the recommendation; the product lead's pushback sharpened it into a clearer articulation of the problem.

**Critic** reduced the problem. Eliminated the wizard, the sample dataset, the tooltip system, and the completion tracker. Questioned whether onboarding needs to be a distinct concept at all. Proposed: the product should simply work on first use, with the first session being a guided version of a real session.

The product lead's second pushback came here — about the sample dataset. Her team had spent months curating it. "It's the best part of our onboarding. Users who engage with the sample data convert at 2x." The critic didn't dismiss this. It asked: *why* do sample-data users convert better? Is it because the sample data is good, or because those users are already motivated enough to explore? And if the sample data works, why does it need to be sample data — why not generate the same experience from the user's real data? The product lead later called this the most useful moment in the session: "I was defending the artifact instead of the outcome. The outcome was 'users see a working dashboard quickly.' The sample dataset was just one way to get there, and not even the best way."

**Designer** defined the interaction model. Two states: *empty* (no data connected) and *first-run* (data connected, no dashboards yet). Empty state presents a single action — connect your data source. First-run state presents one pre-built dashboard generated from the user's actual data, with annotation explaining what each section shows and a single prompt: "Edit this, or start a new one." No wizard. No tour. No sample data.

When the product lead saw this model, something clicked: "This isn't an onboarding redesign. We're removing onboarding entirely." That reframe — from *improving a feature* to *eliminating a category* — was something she said she wouldn't have reached on her own, not because she lacked the ability, but because she was too close to the existing system to see it as optional. The agent sequence got her there by building the case across four handoffs: the historian questioned the pattern, the strategist exposed the misalignment, the architect named the seam, and the critic removed the unnecessary. By the time the designer presented the model, the conclusion felt obvious. That's the value of the sequence — no single agent made the leap, but the accumulated reasoning made the leap inevitable for the person making the decision.

**Writer** authored the empty state and first-run copy, calibrated to the team's voice guidelines captured in project context: direct, peer-to-peer, no condescension. The empty state message: the product name, one sentence describing what it does, and a "Connect data source" action. No welcome message, no feature list, no "Let's get you set up!" enthusiasm. The first-run annotations use the user's actual metric names, not generic labels. A team with a warmer, more conversational brand voice would have gotten different copy from the same writer agent — the structure would remain, but the tone would shift to match their culture.

**Heurist** evaluated for friction. Found one issue: users who connect a data source with limited data would see a sparse pre-built dashboard, which could undermine confidence. Recommended a minimum-data threshold — if the connected source has fewer than N records, show an honest message about what's possible rather than a half-empty dashboard.

**Accessibility** verified the flow. The single-action empty state and annotated dashboard both met WCAG standards. Flagged that auto-generated dashboard annotations needed sufficient color contrast against chart backgrounds.

**Specifier** produced the engineering handoff: two new product states (empty, first-run), a dashboard generation service that runs on first data connection, annotation component specifications, and the minimum-data threshold logic.

---

### What the studio removed

- Five-step onboarding wizard
- Product tour with tooltip overlays
- Sample dataset and its maintenance burden
- Completion progress tracker
- Welcome email sequence tied to onboarding steps
- "Getting Started" documentation section

### What the studio produced

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

**Workflow used:** `/studio-solve notification system for clinician handoff coordination`

The team chose `/studio-solve` because notifications in healthcare are a high-stakes structural decision — the wrong model creates alert fatigue in a context where missed alerts have real consequences.

Their `/studio-init` interview had captured something specific: the company was founded by former nurses, and their organizational philosophy was "clinical tools should feel like they were built by someone who's been on the floor." This wasn't a marketing statement — it was an engineering constraint. It meant every design decision would be evaluated against the question: *would a clinician who's been on shift for ten hours experience this as helpful or as noise?* That filter, loaded from `project-context.md`, shaped every agent's reasoning throughout the convergence loop.

---

### Iteration 1

**Historian** researched notification systems in clinical tools. Key finding: alert fatigue is the dominant failure mode. Studies show clinicians receive 50–100+ alerts per shift in most clinical software, and override rates exceed 90%. The systems that work use *severity tiering* and *contextual suppression* — not fewer notifications, but fewer notifications that don't matter right now.

**Designer** proposed an initial model with three tiers: critical (patient safety), actionable (requires response within shift), and informational (status updates). Critical notifications interrupt. Actionable notifications badge. Informational notifications aggregate into a shift summary.

**Critic** challenged the three-tier model. Asked: does the informational tier need to exist at all? If a notification isn't actionable, it's a status update — and status is already visible on the handoff board. Proposed eliminating the informational tier and moving those events to a "shift activity" view that the clinician pulls when they want context, rather than pushing it.

**Marketer** evaluated the notification model against user expectations and competitive positioning. Noted that most competing tools over-notify and that "quiet by default" is a defensible position in a market where clinicians actively resent their tools. But the marketer also connected this to the company's founding philosophy — "built by someone who's been on the floor" becomes tangible when your tool is the one that *doesn't* buzz during a procedure. Recommended leaning into restraint as a product principle — fewer notifications as a feature, not a limitation. The company's culture didn't just permit this recommendation; it demanded it.

**Creative Director** reviewed the iteration. Verdict: the two-tier model (critical, actionable) is structurally sound, but the definitions need precision. "Critical" and "actionable" are ambiguous in clinical context — every notification a clinician receives feels critical to someone. Pushed for definitions grounded in *time-sensitivity and patient impact*, not subjective severity. Sent back for refinement.

The CTO resisted here. He felt the two-tier model was solid and wanted to move to implementation. "We're overthinking the labels. Engineers can figure out which bucket each event goes in." The creative director's response was precise: the labels aren't for engineers — they're the *decision framework* that determines what interrupts a clinician mid-procedure. If "critical" is ambiguous, every future product decision about which tier an event belongs to becomes a judgment call with no anchor. The CTO's pushback was practical and reasonable. But the creative director identified that shipping ambiguous definitions would create a different kind of cost — not in this sprint, but in every sprint after, as the team debates what counts as "critical" with no shared definition. The CTO agreed to one more iteration. Later, he pointed to this as the moment that saved the team months of internal arguments: "We would have shipped it, and then fought about tier classification on every new feature for a year."

---

### Iteration 2

**Designer** refined the tier definitions. Tier 1: *time-critical* — a patient handoff requires acknowledgment and the receiving clinician hasn't opened it within the escalation window. Tier 2: *shift-relevant* — a handoff assigned to you has a status change, or a colleague sent you a message. The distinction is not severity but *whether delayed response creates risk*.

The CTO had an immediate reaction: "That's it. That's the question we've been trying to articulate." The shift from severity to time-sensitivity resolved a tension the team had been circling for weeks without naming. In early planning meetings, they'd debated whether a colleague's message was "important enough" to push — a question with no right answer because importance is subjective. "Does delayed response create risk?" has a clear answer for every event type. The designer didn't invent this framing from nothing — it emerged because the creative director's pushback in Iteration 1 forced precision, and the CTO's resistance to that pushback clarified *why* precision mattered. The human's pushback wasn't an obstacle. It was a necessary input that the convergence loop converted into a better outcome.

**Writer** defined the notification language, drawing from the voice principles in project context: clinical precision, no software jargon, written as one clinician would speak to another. Tier 1 notifications name the patient and the action needed — no preamble, no "You have a new..." framing, no app-name branding in the notification. Tier 2 notifications name the colleague and the context. All copy tested against a 2-second comprehension standard: can a clinician glance at this during a procedure and understand what's needed? The voice principles meant the writer agent produced copy that reads like a colleague's shorthand, not like software speaking to a user.

**Critic** examined the escalation window concept. Found it introduces a new system parameter that requires calibration per unit (ICU escalation windows differ from general medicine). Questioned whether this complexity is necessary in v1 or whether a fixed, conservative default serves the same purpose. Recommended shipping with a single default and adding unit-specific configuration only after observing real usage patterns.

This time the CTO pushed back and *won*. He agreed with the fixed default for v1, but insisted on building the data model to support per-unit configuration from the start — not the UI, not the settings screen, just the underlying schema. "The migration cost of adding this later is real. I've done it before." The critic accepted this. It wasn't premature configurability — it was structural foresight from someone with domain-specific implementation experience. The agents don't override human expertise. When the CTO brought specific technical knowledge about migration costs that the critic couldn't evaluate, the recommendation adjusted. The final spec included the extensible schema with a hardcoded default — the CTO's position, refined by the critic's constraint.

**Creative Director** reviewed. The two-tier model with time-sensitivity definitions is clear. The fixed escalation default is the right call for v1 — it reduces implementation complexity and avoids premature configurability. The extensible schema is a reasonable engineering hedge that doesn't compromise the design. The shift-activity pull model for non-actionable events is sound. Verdict: **ship**.

---

### What the studio removed

- Informational notification tier (moved to pull-based shift activity view)
- Per-unit escalation window configuration (deferred to v2 with usage data)
- "New message" and "status change" push notifications for non-shift-relevant events
- Notification preferences screen (two tiers don't need a preferences UI)
- Badge counts (replaced with tier-specific visual treatment)

### What the studio produced

- Two-tier notification model: time-critical and shift-relevant
- Time-sensitivity definitions grounded in patient impact, not subjective severity
- Fixed escalation window with v2 path for unit-specific configuration
- Shift activity view (pull-based) for non-actionable status updates
- Notification copy standards: patient name + action needed, 2-second comprehension
- Engineering specification with state machine for escalation logic

### Why it worked

The convergence loop caught a problem that a single pass would have missed. The first iteration produced a reasonable three-tier model — most teams would have shipped it. The critic's challenge (does the informational tier need to exist?) and the creative director's push for precise definitions (not "critical" but "time-critical, defined by delayed-response risk") transformed a conventional notification system into one calibrated to how clinicians actually work.

The CTO's involvement shaped the outcome in two distinct ways. His first pushback — wanting to ship after Iteration 1 — was practical but premature. The creative director held the line, and the CTO later recognized that the precision gained in Iteration 2 would have cost months of internal debate if left unresolved. His second pushback — insisting on an extensible schema — was domain expertise the agents lacked. The critic adjusted. This is the dynamic that makes the multi-agent team effective: agents apply structured pressure that surfaces the right questions, but they yield to human expertise when the human brings knowledge the system doesn't have. The CTO didn't need the agents to tell him what to build. He needed them to help him decide what *not* to build, and to articulate the decision framework clearly enough that his team could apply it without him in the room.

The marketer's input reframed restraint as a competitive advantage rather than a missing feature — an insight that shaped the product narrative, not just the design.

The memory system recorded the decision to defer per-unit configuration (UI only — schema ships extensible, per the CTO's input), with the reasoning and the trigger condition (observed usage data) for revisiting it.

---

## What these cases demonstrate

**Sequencing matters.** The historian and strategist run before the designer — not because designers can't think strategically, but because separating research from synthesis produces better synthesis. The critic runs before and after design work, ensuring reduction happens at both the problem and solution level.

**Agents have boundaries.** The designer defines interaction models but defers copy to the writer, visual execution to the visual designer, and motion to the choreographer. This constraint prevents any single perspective from dominating and ensures each craft dimension gets dedicated attention.

**Memory compounds.** Each session's decisions — approved, rejected, and deferred — are recorded with reasoning. The next session starts with that context. Over weeks, the project-context file becomes a precise description of the product's design logic, not a generic brief.

**Removal is the primary operation.** In both cases, the most important design decisions were eliminations: the onboarding wizard, the sample dataset, the informational notification tier, the preferences screen. The studio's "remove first" principle isn't aspirational — it's structural. The critic agent exists to enforce it.

**Convergence produces different results than single passes.** The notification system's final form — two tiers defined by time-sensitivity, not severity — only emerged through the creative director sending the first iteration back. A single design pass would have shipped a three-tier system with ambiguous definitions. The convergence loop caught what felt reasonable but wasn't precise.

**Pushback is a feature, not a failure.** In both cases, the human's resistance to agent recommendations produced better outcomes than agreement would have. The product lead's defense of the sample dataset forced the critic to articulate the distinction between artifacts and outcomes — a thinking tool she carried forward. The CTO's insistence on shipping after Iteration 1 created the contrast that made Iteration 2's precision visible. His insistence on an extensible schema brought implementation knowledge the agents didn't have. The agents are not designed to override the human. They are designed to hold positions clearly enough that the human's pushback becomes productive — either the agent's reasoning persuades, or the human's expertise refines the recommendation. Both paths improve the outcome.

**The a-ha moments belong to the human.** The agents don't produce insights. They produce the conditions for insight. The product lead's realization — "we're not redesigning onboarding, we're removing it" — was hers. The agents built the case across four handoffs, but the synthesis happened in her head. The CTO's recognition that "does delayed response create risk?" resolved weeks of ambiguous debate was his. The designer named the framing; the CTO recognized its power. This is the point of a multi-agent team: not to think for you, but to structure the thinking so that the conclusions you reach are sharper than the ones you'd reach alone.

**Culture is a design input, not decoration.** The same Studio OS agents, running the same workflows, produce materially different outputs for different teams — because `/studio-init` captures the team's philosophy, brand principles, and voice as structured decision filters, not as style guidelines applied at the end. The analytics team's "respect the operator's time" principle eliminated the onboarding wizard before design even started. The healthcare team's "built by someone who's been on the floor" philosophy made "quiet by default" an inevitability, not a choice. A venture-backed growth-stage company with a principle like "guide users to mastery" would have gotten a different onboarding model — perhaps a more progressive one — from the same agents. A healthcare competitor whose philosophy centered on "comprehensive clinical awareness" might have kept the three-tier notification model. The structure of the system stays the same. The decisions it produces change because the inputs change. This is the point of the `/studio-init` interview: not to fill out a template, but to give every agent a precise understanding of *who this team is and what they believe*, so that the work reflects the team's judgment — amplified and structured — rather than generic best practices.

---

## A note on what's missing

These scenarios are constructed. They illustrate the mechanics — the sequencing, the pushback dynamics, the role of culture — but they don't carry the weight of documented outcomes.

Real case studies, drawn from actual projects built with Studio OS, will replace or supplement these as that work matures. Until then, treat these as a description of how the system is *designed* to work, not proof that it does.
