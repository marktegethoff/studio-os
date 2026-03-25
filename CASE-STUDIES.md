# Case Studies

Two examples of Studio OS applied to real product problems. These walk through the workflow sequences, agent handoffs, and decisions that emerge — not as idealized narratives, but as demonstrations of what structured reasoning looks like in practice.

---

## Case Study 1: Redesigning Onboarding for a B2B Analytics Platform

**Problem:** A mid-stage B2B analytics product has a 40% drop-off between signup and first dashboard creation. The existing onboarding is a five-step wizard with tooltips, product tours, and a sample dataset. Users who complete onboarding retain well. Most don't complete it.

**Workflow used:** `/studio-design onboarding drop-off — users abandon before creating their first dashboard`

---

### How the workflow ran

**Context loading.** The project-context file — written during `/studio-init` — established: the product serves operations teams at mid-market companies, the core invariant is "time-to-first-insight must decrease with every release," and previous attempts at guided tours were rejected as patronizing. But the file also carried the team's philosophy: they had defined their brand principle as "respect the operator's time — never make them feel like a student." This wasn't a tagline. It was a decision filter that shaped every agent's reasoning downstream.

This is where team culture enters the system. A different company — one whose brand principle was "guide users to mastery" — would have gotten a different design from the same agents running the same workflow against the same problem. The `/studio-init` interview captures these positions precisely so that agents don't default to generic best practices. They reason from *your* principles.

**Historian** researched onboarding precedent. Found that the most durable pattern in B2B tools is not tutorials but *immediate productive use* — putting the user in a real task with real data before asking them to learn the system. Noted that wizard-style onboarding has consistently underperformed in retention studies for tools with complex data models.

**Strategist** evaluated against product purpose — and against the team's stated brand principle. The current onboarding teaches the product. The product's purpose is insight delivery. These are misaligned — onboarding should deliver an insight, not explain how insights work. But the strategist went further: the wizard format violates "respect the operator's time" by positioning experienced operations professionals as beginners who need step-by-step guidance. The misalignment isn't just functional — it's cultural. Flagged the sample dataset as the structural problem: users learn the tool against fake data, then must re-learn it against their own.

**Architect** mapped the system boundaries. Identified that the onboarding flow is a separate state machine from the core product, creating a conceptual seam — users "graduate" from onboarding into a product that works differently than what they just learned. Proposed collapsing onboarding into the core product flow: first-run states within the real product, not a parallel track.

**Critic** reduced the problem. Eliminated the wizard, the sample dataset, the tooltip system, and the completion tracker. Questioned whether onboarding needs to be a distinct concept at all. Proposed: the product should simply work on first use, with the first session being a guided version of a real session.

**Designer** defined the interaction model. Two states: *empty* (no data connected) and *first-run* (data connected, no dashboards yet). Empty state presents a single action — connect your data source. First-run state presents one pre-built dashboard generated from the user's actual data, with annotation explaining what each section shows and a single prompt: "Edit this, or start a new one." No wizard. No tour. No sample data.

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

---

### Iteration 2

**Designer** refined the tier definitions. Tier 1: *time-critical* — a patient handoff requires acknowledgment and the receiving clinician hasn't opened it within the escalation window. Tier 2: *shift-relevant* — a handoff assigned to you has a status change, or a colleague sent you a message. The distinction is not severity but *whether delayed response creates risk*.

**Writer** defined the notification language, drawing from the voice principles in project context: clinical precision, no software jargon, written as one clinician would speak to another. Tier 1 notifications name the patient and the action needed — no preamble, no "You have a new..." framing, no app-name branding in the notification. Tier 2 notifications name the colleague and the context. All copy tested against a 2-second comprehension standard: can a clinician glance at this during a procedure and understand what's needed? The voice principles meant the writer agent produced copy that reads like a colleague's shorthand, not like software speaking to a user.

**Critic** examined the escalation window concept. Found it introduces a new system parameter that requires calibration per unit (ICU escalation windows differ from general medicine). Questioned whether this complexity is necessary in v1 or whether a fixed, conservative default serves the same purpose. Recommended shipping with a single default and adding unit-specific configuration only after observing real usage patterns.

**Creative Director** reviewed. The two-tier model with time-sensitivity definitions is clear. The fixed escalation default is the right call for v1 — it reduces implementation complexity and avoids premature configurability. The shift-activity pull model for non-actionable events is sound. Verdict: **ship**.

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

The marketer's input reframed restraint as a competitive advantage rather than a missing feature — an insight that shaped the product narrative, not just the design.

The memory system recorded the decision to defer per-unit configuration, with the reasoning and the trigger condition (observed usage data) for revisiting it.

---

## What these cases demonstrate

**Sequencing matters.** The historian and strategist run before the designer — not because designers can't think strategically, but because separating research from synthesis produces better synthesis. The critic runs before and after design work, ensuring reduction happens at both the problem and solution level.

**Agents have boundaries.** The designer defines interaction models but defers copy to the writer, visual execution to the visual designer, and motion to the choreographer. This constraint prevents any single perspective from dominating and ensures each craft dimension gets dedicated attention.

**Memory compounds.** Each session's decisions — approved, rejected, and deferred — are recorded with reasoning. The next session starts with that context. Over weeks, the project-context file becomes a precise description of the product's design logic, not a generic brief.

**Removal is the primary operation.** In both cases, the most important design decisions were eliminations: the onboarding wizard, the sample dataset, the informational notification tier, the preferences screen. The studio's "remove first" principle isn't aspirational — it's structural. The critic agent exists to enforce it.

**Convergence produces different results than single passes.** The notification system's final form — two tiers defined by time-sensitivity, not severity — only emerged through the creative director sending the first iteration back. A single design pass would have shipped a three-tier system with ambiguous definitions. The convergence loop caught what felt reasonable but wasn't precise.

**Culture is a design input, not decoration.** The same Studio OS agents, running the same workflows, produce materially different outputs for different teams — because `/studio-init` captures the team's philosophy, brand principles, and voice as structured decision filters, not as style guidelines applied at the end. The analytics team's "respect the operator's time" principle eliminated the onboarding wizard before design even started. The healthcare team's "built by someone who's been on the floor" philosophy made "quiet by default" an inevitability, not a choice. A venture-backed growth-stage company with a principle like "guide users to mastery" would have gotten a different onboarding model — perhaps a more progressive one — from the same agents. A healthcare competitor whose philosophy centered on "comprehensive clinical awareness" might have kept the three-tier notification model. The structure of the system stays the same. The decisions it produces change because the inputs change. This is the point of the `/studio-init` interview: not to fill out a template, but to give every agent a precise understanding of *who this team is and what they believe*, so that the work reflects the team's judgment — amplified and structured — rather than generic best practices.
