# Workflow (Skill) Evals
Skills: all 23 workflow skills.
Run: after any change to a skill's `SKILL.md`, or on the full-suite cadence.

Agent evals test *behavior*; these test *orchestration* — does a workflow gate correctly, sequence its agents, satisfy the Six Functions where applicable, and produce the right artifact with a named owner. Scenarios are product-agnostic.

> **Note:** `lt-review` and `review` overlap (both produce the PM+CD+DE verdict). Flagged as a consolidation candidate — eval both until merged.

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
**Pass:** asks ONE question at a time · validates who has the problem, what they do today, what success looks like · outputs a locked `product_brief_<slug>.md`.
**Anti:** asks everything at once; produces a brief without validating the problem.

## scope — Eval: the five-field task brief
**Prompt:** "Scope this task so I can hand it to /implement."
**Pass:** produces SPEC · OUTPUT · GATES · VERIFY · ESCALATE · tight enough to delegate unattended.
**Anti:** vague brief; missing GATES or VERIFY.

## discover — Eval: PM gate before the brief
**Prompt:** "Run discovery on why users abandon onboarding."
**Pass:** runs researcher → journey → assumptions → PM gate → brief, in sequence · PM gate precedes the brief · produces a validated brief.
**Anti:** skips the PM gate; jumps to solutions.

## ideate — Eval: problem in, not solution
**Prompt:** "Ideate on adding a Kanban board." *(a solution, not a problem)*
**Pass:** refuses the solution-in-disguise and asks for the problem · diverges across lenses · reduces to 3–5 then 1–2 · does not commit to build.
**Anti:** accepts the solution as input; converges to one idea immediately.

## design — Eval: brief gate + Six Functions + owner
**Prompt:** "Design the entry detail surface." *(no brief provided)*
**Pass:** requires a validated brief (PM gate) before proceeding · activates the six functions (framing, generation, craft, reduction, usability/accessibility, and the CD gate) · the Designer owns the interaction model.
**Anti:** starts without a brief; fewer than the six functions; no named deliverable owner.

## prototype — Eval: scope to the question
**Prompt:** "Should I prototype the new gesture or just spec it?"
**Pass:** names the question a spec can't answer · defines minimum fidelity · names what the prototype does NOT test.
**Anti:** recommends a full build with no question; high fidelity where low suffices.

## solve — Eval: bounded convergence
**Prompt:** "We've tried three times to design X and it won't converge. Solve it."
**Pass:** runs Historian → Design → Critic → CD → calibration · max 3 iterations · converges to an inevitable solution OR stops and names why.
**Anti:** unbounded iteration; no convergence criterion.

## critique — Eval: single-pass verdict
**Prompt:** "Critique this implemented surface."
**Pass:** runs Critic + Heurist · checks philosophy, invariants, accessibility, ledger conflicts · returns SHIP / REVISE / REJECT.
**Anti:** vague feedback; no verdict.

## review — Eval: combined LT verdict
**Prompt:** "Run a Leadership Team review on this artifact before we ship."
**Pass:** runs PM + CD + DE · produces a combined verdict with convergence notes · names ONE prioritized next action.
**Anti:** a single perspective; three disconnected verdicts with no synthesis.

## lt-review — Eval: combined LT verdict *(consolidation candidate with review)*
**Prompt:** "/lt-review this artifact."
**Pass:** same as review — PM + CD + DE combined verdict + single next action.
**Anti:** diverges in behavior from `review` (if identical, merge them).

## implement — Eval: no spec, no start
**Prompt:** "Implement the new compose behavior." *(no brief/spec provided)*
**Pass:** refuses to start without a task brief/spec · states "what must not break" before code · DE review before merge · touches one behavior at a time.
**Anti:** starts without a spec; no invariants stated; broad refactor beyond the task.

## handoff — Eval: complete production package
**Prompt:** "Prepare this validated prototype for engineering."
**Pass:** requires a validated prototype · produces all states + flows, synthetic data, UAT scenarios, and a build spec with design-system token translation.
**Anti:** happy-path only; no DS token mapping; missing UAT.

## simplify — Eval: DE gates plan and result
**Prompt:** "Simplify the services layer."
**Pass:** audits for complexity drift · converges on a plan via Critic + Architect + DE · DE gates BOTH the plan and the final result.
**Anti:** refactors with no plan; no DE gate on the result.

## measure — Eval: outcome plan with counter-metric
**Prompt:** "Define how we'll measure the new digest feature."
**Pass:** requires a design brief · metrics-definer → PM gate → architect · produces leading + lagging indicators, a counter-metric, a baseline, and instrumentation requirements.
**Anti:** vanity metric; no counter-metric or baseline.

## experiment — Eval: framed hypothesis, prior check
**Prompt:** "Test whether inline replies increase task completion."
**Pass:** frames the hypothesis as IF/THEN/BECAUSE · checks memory for prior results first · designs the experiment and evaluates short/medium/long-term.
**Anti:** vague hypothesis; ignores prior results.

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

---

## Eval summary template

```
Workflow (Skill) Eval Run — [date]
Triggered by: [what changed]

[skill] — [PASS / FAIL] — [failed criterion / anti-pattern, if any]
… (one line per skill)

Overall: PASS / FAIL   (N/23 skills passing)
Failed: [list]   ·   Consolidation flags: [e.g., lt-review ≡ review]
```
