# Workflow (Skill) Evals
Skills: all 27 workflow skills.
Run: after any change to a skill's `SKILL.md`, or on the full-suite cadence.

Agent evals test *behavior*; these test *orchestration* — does a workflow gate correctly, sequence its agents, satisfy the Six Functions where applicable, and produce the right artifact with a named owner. Scenarios are product-agnostic.

---

## studio — Eval: orient and route, don't execute
**Prompt:** "I have a vague feature idea and don't know where to start."
**Pass:** routes to the right entry workflow (shape / discover / ideate) · shows what the studio can produce · does NOT begin designing or building itself.
**Anti:** jumps into a design; does the downstream work instead of routing.

## init — Eval: write project context
**Prompt:** "Set up Studio OS for my new project."
**Pass:** runs the context interview · writes `.claude/memory/project-context.md` (purpose, invariants, archetypes, brand) · prompts for the reference palette (positive + negative) and optional agent personas.
**Anti:** writes nothing; produces generic context without interviewing.

## shape — Eval: one question at a time, validated brief
**Prompt:** "Help me shape a brief for a notifications feature."
**Pass:** asks ONE question at a time · validates who has the problem, what they do today, what success looks like · outputs a locked `product_brief_<slug>.html` via the design-brief kit template; markdown summary surfaces in conversation.
**Anti:** asks everything at once; produces a brief without validating the problem; writes prose only without the HTML artifact.

## scope — Eval: the five-field task brief
**Prompt:** "Scope this task so I can hand it to /implement."
**Pass:** produces SPEC · OUTPUT · GATES · VERIFY · ESCALATE · tight enough to delegate unattended · writes HTML artifact (task-brief template → specs/task_brief_<slug>.html); markdown summary surfaces in conversation.
**Anti:** vague brief; missing GATES or VERIFY; writes prose only without the HTML artifact.

## discover — Eval: PM gate before the brief
**Prompt:** "Run discovery on why users abandon onboarding."
**Pass:** runs researcher → journey → assumptions → PM gate → brief, in sequence · PM gate precedes the brief · produces a validated brief · writes HTML artifact (user-journey template → specs/discovery_<slug>.html); markdown summary surfaces in conversation.
**Anti:** skips the PM gate; jumps to solutions; writes prose only without the HTML artifact.

## ideate — Eval: problem in, not solution
**Prompt:** "Ideate on adding a Kanban board." *(a solution, not a problem)*
**Pass:** refuses the solution-in-disguise and asks for the problem · diverges across lenses · reduces to 3–5 then 1–2 · does not commit to build · writes HTML artifact (ideation-output template → specs/ideation_<slug>.html); markdown summary surfaces in conversation.
**Anti:** accepts the solution as input; converges to one idea immediately; writes prose only without the HTML artifact.

## design — Eval: brief gate + Six Functions + owner + phase
**Prompt:** "Design the entry detail surface." *(no brief provided)*
**Pass:** requires a validated brief (PM gate) before proceeding · establishes phase (exploratory / in progress / refinement) and applies phase gates (refinement skips Steps 1–4; exploratory skips sub-team / accessibility / specifier) · activates the six functions (framing, generation, craft, reduction, usability/accessibility, and the CD gate) at in progress · the Designer owns the interaction model · writes HTML artifact (phase-dependent: design-brief for exploratory; state-inventory + component-spec for in progress); markdown summary surfaces in conversation.
**Anti:** starts without a brief; fewer than the six functions; no named deliverable owner; runs full nine-step pass on exploratory work; ignores phase; writes prose only without the HTML artifact.

## prototype — Eval: scope to the question
**Prompt:** "Should I prototype the new gesture or just spec it?"
**Pass:** names the question a spec can't answer · defines minimum fidelity · names what the prototype does NOT test.
**Anti:** recommends a full build with no question; high fidelity where low suffices.

## solve — Eval: bounded convergence
**Prompt:** "We've tried three times to design X and it won't converge. Solve it."
**Pass:** runs Historian → Design → Critic → CD → calibration · max 3 iterations · converges to an inevitable solution OR stops and names why.
**Anti:** unbounded iteration; no convergence criterion.

## critique — Eval: all nine disciplines, tension-prompted debate
**Prompt:** "Critique this implemented surface."
**Pass:** spawns all nine discipline specialists in parallel · each delivers findings from their mandate · synthesis names convergences and triages · assesses tension threshold (volume >8 / convergence / Critic tension) · offers debate round if threshold met · debate round has each agent respond to the others · final synthesis tracks hardened / changed / unresolved tensions · does NOT render SHIP / REVISE / REJECT · writes HTML artifact (critique-report template → reviews/critique_<slug>_<timestamp>.html); markdown summary surfaces in conversation.
**Anti:** renders a ship verdict; skips disciplines; offers debate unconditionally without threshold check; vague findings per discipline; writes prose only without the HTML artifact.

## review — Eval: combined LT verdict, phase-aware, conflict-prompted debate
**Prompt:** "Run a Leadership Team review on this artifact before we ship."
**Pass:** establishes phase (pre-ship / checkpoint / post-ship audit) and threads it into every brief · runs PM + CD + DE in parallel · produces combined verdict with convergence notes · names ONE prioritized next action via cascade (PM > CD > DE) · assesses conflict threshold (split verdict on same element / convergent flags with incompatible routing / dependent verdicts) · offers debate round if conflict fires · debate round has each member respond to the others · final synthesis tracks hardened / changed / unresolved tensions · writes HTML artifact (lt-review template → reviews/lt_review_<slug>_<timestamp>.html); markdown summary surfaces in conversation.
**Anti:** a single perspective; three disconnected verdicts with no synthesis; offers debate unconditionally; silences conflict via cascade instead of surfacing it; ignores phase; writes prose only without the HTML artifact.

## implement — Eval: no spec, no start
**Prompt:** "Implement the new compose behavior." *(no brief/spec provided)*
**Pass:** refuses to start without a task brief/spec · states "what must not break" before code · DE review before merge · touches one behavior at a time.
**Anti:** starts without a spec; no invariants stated; broad refactor beyond the task.

## handoff — Eval: complete production package
**Prompt:** "Prepare this validated prototype for engineering."
**Pass:** requires a validated prototype · produces all states + flows, synthetic data, UAT scenarios, and a build spec with design-system token translation · writes HTML artifact (state-inventory template → design/handoff_<slug>.html); markdown summary surfaces in conversation.
**Anti:** happy-path only; no DS token mapping; missing UAT; writes prose only without the HTML artifact.

## simplify — Eval: DE gates plan and result
**Prompt:** "Simplify the services layer."
**Pass:** audits for complexity drift · converges on a plan via Critic + Architect + DE · DE gates BOTH the plan and the final result.
**Anti:** refactors with no plan; no DE gate on the result.

## measure — Eval: outcome plan with counter-metric
**Prompt:** "Define how we'll measure the new digest feature."
**Pass:** requires a design brief · metrics-definer → PM gate → architect · produces leading + lagging indicators, a counter-metric, a baseline, and instrumentation requirements · writes HTML artifact (metrics-plan template → specs/measurement_<slug>.html); markdown summary surfaces in conversation.
**Anti:** vanity metric; no counter-metric or baseline; writes prose only without the HTML artifact.

## experiment — Eval: framed hypothesis, prior check
**Prompt:** "Test whether inline replies increase task completion."
**Pass:** frames the hypothesis as IF/THEN/BECAUSE · checks memory for prior results first · designs the experiment and evaluates short/medium/long-term · writes HTML artifact (experiment-plan template → specs/experiment_<slug>.html); markdown summary surfaces in conversation.
**Anti:** vague hypothesis; ignores prior results; writes prose only without the HTML artifact.

## simulate — Eval: horizon, not a point
**Prompt:** "Simulate how this list performs at 10,000 items over two years."
**Pass:** applies the drum simulation model over the stated horizon · reports holds / degrades / breaks per relevant dimension (navigation at scale, retrieval quality, etc.).
**Anti:** a single-point answer; no time horizon.

## luck — Eval: binding constraint first, then verdict
**Prompt:** "Will building our own sync layer compound value or collapse?"
**Pass:** names the binding constraint FIRST · runs only the diagnostics needed to confirm it · verdict: COMPOUND / SUSTAIN / STAGNATE / COLLAPSE.
**Anti:** runs all seven diagnostics mechanically; no verdict.

## annotate — Eval: feedback harness round-trip
**Prompt:** "Render this artifact with the annotation harness for review."
**Pass:** produces the artifact with an embedded annotation/feedback overlay · returns structured, agent-friendly feedback in one paste · works on any artifact type, not only iOS snapshots.
**Anti:** no structured feedback return; tied to a single artifact type.

## design-system-init — Eval: scaffold once, with tokens
**Prompt:** "Scaffold a design system for this project."
**Pass:** creates `.claude/skills/design-system/` structure + token-file templates · is idempotent (does not clobber an existing system) · runs once per project.
**Anti:** overwrites an existing design system; no token templates created.

## troubleshoot — Eval: engineering convergence, DE-gated
**Prompt:** "Our list view janks at 10k items and we can't tell if it's the data layer or the render layer. Solve it."
**Pass:** reframes the symptom into the real technical question and names constraints/"solved" · convenes the engineering lenses (Architect + relevant stack engineer + DE) not a single view · produces ≥2 candidate approaches with cost/reversibility · converges to one (or names the deciding condition) · ends in a DE verdict (PROCEED / NEEDS A DECISION / REJECT) · bounded to 3 iterations; does not force a false answer.
**Anti:** jumps to a fix without framing or candidates; single-lens answer; writes production code instead of deciding the approach; no DE verdict; unbounded iteration.

## gather-feedback — Eval: reviewable handback, any work type
**Prompt:** "Render a review surface for this completed work." *(work that is not iOS UI — e.g. a brief or a code change)*
**Pass:** renders a self-contained HTML Review Surface on the Artifact Kit (studio.css + harness) · presents evidence in the form that fits the work (rendered artifact / code excerpt / prose), not forced screenshots · generates 1–3 judgment-call questions (not diff-answerable) · includes disposition + catch-all automatically · opens it and waits for the response block.
**Anti:** raw markdown handback; forces iOS snapshots for non-UI work; questions answerable from the diff; doesn't wait for the response.

## studio-close — Eval: deposit, don't auto-write
**Prompt:** "Close out this session." *(after a session that changed an agent and made a decision)*
**Pass:** proposes deposits across the five homes (preferences · ledger · eval delta · migrations · postmortem candidates) · flags the changed agent's eval as must-pass · records any migration cold-resumably (not "see conversation") · writes nothing without confirmation.
**Anti:** auto-writes without confirmation; leaves a migration only in chat; ignores that a changed agent needs its eval run.

## studio-postmortem — Eval: root cause → ban or precedent
**Prompt:** "We shipped a streak counter to boost retention and it tanked trust. Postmortem it."
**Pass:** states expected vs actual · drives to a root cause (a category of move), not the symptom · classifies as NAMED BAN / PRECEDENT / NEITHER · if a ban, formats it (name · what · trigger), routes to the owning agent, and adds an eval case · does not over-ban (NEITHER is allowed) · confirms before depositing.
**Anti:** bans the symptom; manufactures a ban for an unforeseeable failure; no eval case for a new ban; auto-writes.

## studio-drift — Eval: detect, route, you decide
**Prompt:** "Audit the ledger for drift." *(ledger has a superseded decision and a contradiction)*
**Pass:** detects mechanically (supersession / contradiction / stale-pending / orphan) · routes each to the owning gate (CD/DE/PM) for a judged recommendation with reasoning · presents recommendations for the user to decide · changes nothing without approval (no auto-resolution).
**Anti:** resolves a decision itself; collapses detect/judge/decide into one step; treats supersession as a failure rather than a fact.

## studio-slop — Eval: catches competent-looking emptiness
**Prompt:** "Run the Slop Test on this." *(provide two outputs: one that drops discipline vocabulary with no specific/falsifiable claim, and one with a real specific claim + counter-argument)*
**Pass:** identifies the core claim of each (or "none found") · flags the hollow one as SLOP, naming the specific markers fired (vocabulary-without-judgment, generic, format-without-substance, hedging, prompt-restatement, unfalsifiable, citation-without-lesson) with quoted spans · passes the substantive one as CLEAN · names the single change that would make the slop output substantive.
**Anti:** passes the hollow output because it "looks like good studio work" (the exact failure the test exists to catch); flags the substantive output as slop; vague "feels thin" with no marker named.

---

## Eval summary template

```
Workflow (Skill) Eval Run — [date]
Triggered by: [what changed]

[skill] — [PASS / FAIL] — [failed criterion / anti-pattern, if any]
… (one line per skill)

Overall: PASS / FAIL   (N/26 skills passing)
Failed: [list]
```
