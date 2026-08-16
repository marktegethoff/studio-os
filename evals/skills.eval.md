# Workflow (Skill) Evals
Skills: all 28 workflow skills (23 active + 5 deprecated pending archive).
Run: after any change to a skill's `SKILL.md`, or on the full-suite cadence.

Agent evals test *behavior*; these test *orchestration* — does a workflow gate correctly, sequence its agents, satisfy the Six Functions where applicable, and produce the right artifact with a named owner. Scenarios are product-agnostic.

## Graph conformance — applies to every graph-declaring skill

The eight graph-declaring skills (critique · review · design · ideate · solve · handoff · prototype · discover) are additionally evaluated against their ```graph block (the contract; see `memory/orchestration.md`):
**Pass:** execution order matches the declared graph · fan-out groups spawned in a single message (or via the executor), briefed blind from shared inputs only · joins wait for all members · loops respect their `max:` · a failed node is reported by id with its inputs and the downstream nodes blocked · every surviving PAUSE maps to a `human` node and presents its `decides:` decision · dissent is preserved at joins (named, never averaged away) · where a `workflow.js` exists, its behavior matches the prose path (same order, gates, bounds).
**Anti:** sequential execution of a declared fan-out; a join that proceeds with missing inputs; a loop past its max; a pause with nothing to decide; prose or executor contradicting the graph block; Consensus Laundering at any join.

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

## scope *(deprecated — merged into /studio:shape --task)* — Eval: the five-field task brief
**Prompt:** "Scope this task so I can hand it to /implement."
**Pass:** produces SPEC · OUTPUT · GATES · VERIFY · ESCALATE · tight enough to delegate unattended · writes HTML artifact (task-brief template → specs/task_brief_<slug>.html); markdown summary surfaces in conversation.
**Anti:** vague brief; missing GATES or VERIFY; writes prose only without the HTML artifact.

## feedback — Eval: two modes, one review pattern
**Prompt 1:** "Collect feedback on this implementation." *(not an HTML prototype)*
**Prompt 2:** "Let me mark up this prototype HTML."
**Pass:** routes prompt 1 to surface mode (Review Surface: evidence fitting the work, 1–3 judgment-call questions, disposition + catch-all, waits for the response block) · routes prompt 2 to overlay mode (reads overlay.md; injects the click-to-annotate harness into a copy; source never modified) · states which mode and why in one line · both modes emit the same copy-to-chat response block format.
**Anti:** forces the overlay on non-HTML work; renders raw markdown instead of the surface; modifies the source file; diff-answerable questions.

## shape — Eval: task altitude (--task)
**Prompt:** "/studio:shape --task tighten the empty-state copy per the spec"
**Pass:** runs the task interview (one question per pause — interview pauses are exempt from the pause economics) · refuses to assemble a brief for a non-infrastructure task with no spec, recommending /studio:design · auto-extracts gates/verify from the spec rather than asking the user to restate it · produces the five fields exactly (SPEC/OUTPUT/GATES/VERIFY/ESCALATE) · locks only on explicit confirmation · forks to /studio:prototype or /studio:implement, re-asking on an ambiguous reply.
**Anti:** a half-brief without a spec; extra fields; auto-picking the path; skipping the lock confirmation.

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

## design — Eval: two decision pauses, gates before emission
**Prompt:** "Design the entry detail surface." *(brief exists; in-progress phase)*
**Pass:** exactly two pauses fire — direction selection (after the Designer's options, presenting the recommendation) and the prototype gate (before any production write) · context loading reports as a status line · the heurist returns work to the Designer at most once, then remaining concerns travel as dissents · the slop gate (seven markers) and the CD ship gate both run before HTML emission, with the ship verdict recording the run's dissent ledger.
**Anti:** a pause to confirm context loading; an unbounded heurist→designer loop; emission without the slop gate or ship gate; craft agents briefed on each other's unfinished output.

## handoff — Eval: reduction and structural gates
**Prompt:** "Produce the handoff package for this tested prototype."
**Pass:** state and flow audits run as a blind pair with a join · the gap pause fires only when undesigned states/flows exist · the critic pressure-tests the package before the Specifier (removals with rationale; standing inclusion arguments preserved as dissents) · accessibility verifies the spec's accessibility section · slop gate runs · the CD and PM gates are executed by the cd and pm agents; the human is pulled in only on flagged blockers.
**Anti:** no reduction pass; gates as prose questions to the user instead of agent verdicts; a gap pause when the audits were clean; blockers silently waived.

## prototype — Eval: scope to the question
**Prompt:** "Should I prototype the new gesture or just spec it?"
**Pass:** names the question a spec can't answer · defines minimum fidelity · names what the prototype does NOT test.
**Anti:** recommends a full build with no question; high fidelity where low suffices.

## solve — Eval: bounded convergence
**Prompt:** "We've tried three times to design X and it won't converge. Solve it."
**Pass:** the framing pause fires first (the one-sentence problem + constraints guard the loop) · runs Historian → Design → Critic (escalating standard) → Marketer → CD · max 3 iterations, iteration reports as status lines · an INEVITABLE verdict survives one critic refutation before it stands (at most one designer return) · accessibility + slop gate on the exit path · converges OR reports honestly unresolved with the exit-path decision (Defer / Escalate / Reframe) put to the human.
**Anti:** unbounded iteration; no convergence criterion; INEVITABLE unrefuted; pausing between iterations for a nod; declaring a solution at iteration 3 that did not pass the gate.

## critique — Eval: all nine disciplines, tension-prompted debate
**Prompt:** "Critique this implemented surface."
**Pass:** spawns all nine discipline specialists in parallel (blind) · each delivers findings from their mandate · synthesis names convergences and triages · assesses tension threshold (volume >8 / convergence / Critic tension) mechanically as a router · the ONE pause is the debate-spend decision, offered only when the threshold is met; artifact/phase confirmation is a status line · debate round has each agent respond to the others · final synthesis tracks hardened / changed / unresolved tensions · does NOT render SHIP / REVISE / REJECT · writes HTML artifact (critique-report template → reviews/critique_<slug>_<timestamp>.html); markdown summary surfaces in conversation.
**Anti:** renders a ship verdict; skips disciplines; offers debate unconditionally without threshold check; pauses to confirm context; vague findings per discipline; writes prose only without the HTML artifact.

## review — Eval: combined LT verdict, phase-aware, conflict-prompted debate
**Prompt:** "Run a Leadership Team review on this artifact before we ship."
**Pass:** establishes phase (pre-ship / checkpoint / post-ship audit) and threads it into every brief · runs PM + CD + DE in parallel · produces combined verdict with convergence notes · names ONE prioritized next action via cascade (PM > CD > DE) · assesses conflict threshold (split verdict on same element / convergent flags with incompatible routing / dependent verdicts) · offers debate round if conflict fires · debate round has each member respond to the others · final synthesis tracks hardened / changed / unresolved tensions · writes HTML artifact (lt-review template → reviews/lt_review_<slug>_<timestamp>.html); markdown summary surfaces in conversation.
**Anti:** a single perspective; three disconnected verdicts with no synthesis; offers debate unconditionally; silences conflict via cascade instead of surfacing it; ignores phase; writes prose only without the HTML artifact.

## review — Eval: refutation and dissent ledger
**Prompt:** "Run an LT review on this artifact." *(CD's verdict comes back SHIP; PM overruled on one element)*
**Pass:** the debate router is mechanical (runs on conflicts, no pause) · a standing CD SHIP is refuted once by the critic (strongest case against, not a second opinion) — SHIP stands only if refutation fails · a standing DE SHIP is refuted by qa likewise · the human tiebreak fires only when members remain split after the debate, and outranks refutation · the final verdict carries a dissent ledger naming each overruled position and why it was overruled.
**Anti:** SHIP ships unrefuted; refutation runs more than once or stalls shipping; the verdict reads unanimous while the transcript disagrees (Consensus Laundering); a pause fires for the conflict threshold.

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

## simulate *(deprecated — retiring next release; job moves to /experiment + assumption-mapper)* — Eval: horizon, not a point
**Prompt:** "Simulate how this list performs at 10,000 items over two years."
**Pass:** applies the drum simulation model over the stated horizon · reports holds / degrades / breaks per relevant dimension (navigation at scale, retrieval quality, etc.).
**Anti:** a single-point answer; no time horizon.

## luck *(deprecated skill — the luck agent carries this behavior; see leadership-agents.eval.md)* — Eval: binding constraint first, then verdict
**Prompt:** "Will building our own sync layer compound value or collapse?"
**Pass:** names the binding constraint FIRST · runs only the diagnostics needed to confirm it · verdict: COMPOUND / SUSTAIN / STAGNATE / COLLAPSE.
**Anti:** runs all seven diagnostics mechanically; no verdict.

## annotate *(deprecated — merged into /studio:feedback --overlay)* — Eval: feedback harness round-trip
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

## gather-feedback *(deprecated — merged into /studio:feedback --surface)* — Eval: reviewable handback, any work type
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

## studio-slop — Eval: catalog integration for design artifacts
**Prompt:** "Run the Slop Test on this design artifact." *(provide a critique report that passes the seven slop markers — makes specific, falsifiable claims — but names no anti-pattern entries despite the work having a visible Settings Dumping instance)*
**Pass:** loads `memory/anti-patterns.md` alongside the seven markers · identifies that the artifact has Settings Dumping and names it · reports it as a structural finding (the critique's claims are specific but wrong — they missed the failure mode) · verdict SLOP because passing the markers but missing catalog entries on a design artifact is still hollow.
**Anti:** passes the artifact as CLEAN because the markers pass (ignores catalog integration); does not load `memory/anti-patterns.md` for design artifacts; reports the catalog finding as a marker violation instead of a separate catalog finding.

---

## organize — Eval: scaffold creates folders, reconcile proposes only
**Pass criteria:**
- Scaffold mode: detects missing folders and creates them with .gitkeep; updates project-context.md spec_path and decisions_path if non-canonical; writes a decision-record.html artifact via the kit template.
- Reconcile mode: scans and classifies artifacts; presents a proposal before touching anything; does NOT execute moves in --auto mode — writes the proposal as a decision record and stops.
- Does not touch source code directories (code/, app/), tooling (.claude/, .git/, node_modules/), or Xcode project files.
- Anti-pattern: does not create folders speculatively — only the four canonical output folders (decisions/, specs/, design/, reviews/), never invents new ones.
- HTML artifact: writes decisions/<date>-layout.html (scaffold) or decisions/<date>-reconcile.html (reconcile) via the decision-record kit template; does not emit prose-only output.
- Markdown summary in conversation: lists what was created or proposed; surfaces the artifact path.

---

## Eval summary template

```
Workflow (Skill) Eval Run — [date]
Triggered by: [what changed]

[skill] — [PASS / FAIL] — [failed criterion / anti-pattern, if any]
… (one line per skill)

Overall: PASS / FAIL   (N/28 skills passing)
Failed: [list]
```
