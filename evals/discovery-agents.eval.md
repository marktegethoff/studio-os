# Discovery & PM Agents Evals
Agents: `journey-mapper`, `user-researcher`, `brief-writer`, `metrics-definer`, `assumption-mapper`
Run: after any change to one of these agent files.

Scenarios are product-agnostic. These cover the six net-new discovery agents promoted to full standard; a consuming project may add product-specific evals alongside them.

---

## How to run

For each eval: send the prompt(s) · score each criterion PASS / PARTIAL / FAIL · flag anti-patterns · report eval · agent · result · failed criteria · anti-patterns. A single FAIL is an overall FAIL.

---

## Journey Mapper — Eval 1: Map from the real trigger

**Testing:** Journey Mapper begins the journey at the user's need, not at the product, and ranks the moments that matter.

**Prompt:**
> "Map the journey for someone setting up automatic bill payments in a banking app."

**Pass criteria:**
- [ ] The trigger is a real-world event (a missed/late payment, a new bill, anxiety about forgetting) — not "the user opens the app"
- [ ] Stages are sub-goals, not screens; entry AND exit paths (success and abandonment) are both named
- [ ] Friction points are typed (orientation / effort / confidence / recovery), not "this step is confusing"
- [ ] The moments are ranked by impact on the outcome
- [ ] Does not design the solution — identifies the moments, leaves the surface to the Designer

**Anti-patterns:**
- Trigger defined as a product action (Product-Start Fallacy)
- A list of screens presented as a journey (Screen List Masquerade)
- Only the happy path mapped, no abandonment exit (Happy Path Only)
- Designing the fix at a friction point

---

## User Researcher — Eval 2: Sample, confidence, no generalization

**Testing:** User Researcher states sample sizes and confidence, refuses to generalize beyond the data, and surfaces (not resolves) contradictions.

**Prompt:**
> "Here are notes from 6 interviews about how people manage email overload. One person was very passionate that they want an AI to auto-archive everything. Synthesize the patterns."

**Pass criteria:**
- [ ] States the sample (6 interviews) and assigns confidence to each pattern
- [ ] Does not elevate the one passionate account into a pattern (one ≠ pattern)
- [ ] Distinguishes what people said from what they do where the data allows
- [ ] If the data is thin or mixed, says so rather than inventing a clean insight
- [ ] Does not recommend a product decision

**Anti-patterns:**
- "Users want AI auto-archiving" from one vivid account (Anecdote as Pattern)
- Surfacing only findings that fit an assumed direction (Leading the Witness)
- A tidy single takeaway from thin data (Manufactured Coherence)

---

## Brief Writer — Eval 3: One-sentence problem, mandatory out-of-scope, validation gate

**Testing:** Brief Writer requires a validated problem, states the problem in one sentence, and always defines out-of-scope.

**Turn 1:**
> "Write the design brief for a redesign of our notification settings."

**Turn 2 (if it asks for the validated problem):**
> "The validated problem: users miss important notifications because everything is one undifferentiated stream. Confirmed in discovery."

**Pass criteria:**
- [ ] Turn 1: does NOT write the brief without a validated problem — asks for it
- [ ] Problem stated in exactly one sentence (specific user, context, what fails today)
- [ ] Success conditions are evaluable (observable), tied to the user's goal not feature count
- [ ] An explicit out-of-scope section is present and non-empty
- [ ] Does not prescribe the solution / UI

**Anti-patterns:**
- Writing the brief over an unvalidated problem (Validation Bypass)
- Success conditions that can't be tested (Success Theater)
- Missing/empty out-of-scope (Scope Without Edges)
- Constraints that describe a specific UI (Solution Smuggling)

---

## Metrics Definer — Eval 4: Outcome over vanity, mandatory counter-metric

**Testing:** Metrics Definer anchors to a user-behavior outcome, requires leading + lagging indicators, a baseline, and at least one counter-metric.

**Prompt:**
> "Define success metrics for a new 'smart inbox' that auto-sorts messages. The team wants to track engagement."

**Pass criteria:**
- [ ] Rejects raw "engagement" as the success metric; anchors the lagging indicator to a user-behavior outcome (e.g., user reaches the messages that matter faster / fewer important messages missed)
- [ ] Defines at least one leading indicator with a stated reason it predicts the lagging one
- [ ] Requires a baseline (or a method to establish one) and a specific target + timeframe
- [ ] Names at least one counter-metric (what must not degrade)

**Anti-patterns:**
- Accepting "engagement / time in app" as the success metric (Vanity Metric)
- A plan with no counter-metric (Metric Without Counter)
- Only a lagging indicator, no leading signal (Lagging-Only)
- A target with no baseline (Baseline-Free Target)

---

## Assumption Mapper — Eval 5: Name the binding assumption, testable claims, no go/no-go

**Testing:** Assumption Mapper surfaces low-confidence assumptions, names the single binding one, states each as a testable claim, and does not make the go/no-go call.

**Prompt:**
> "We're about to build an AI feature that drafts replies for users. Map our assumptions before we commit two months to it."

**Pass criteria:**
- [ ] Surfaces assumptions across categories incl. at least one Low-confidence, high-impact one
- [ ] Names exactly one binding assumption (the one whose failure makes the feature worthless)
- [ ] Each assumption is a testable claim ("users will send AI-drafted replies without heavy editing"), not a hope
- [ ] Provides a cheap validation path for the binding assumption
- [ ] Does not recommend whether to proceed

**Anti-patterns:**
- Only confident assumptions listed; the load-bearing one unspoken (Comfort Mapping)
- No single binding assumption named (No Binding Assumption)
- An assumption with no failure condition (Untestable Bet)
- Making the go/no-go call (oversteps into Strategist/PM)

---

## Artifact Production — Eval 6: HTML output via kit template

**Testing:** Each agent renders its artifact as HTML using the assigned kit template, writes it to disk, and surfaces a markdown summary — not prose buried in the response.

**Prompts:**
> [Journey Mapper] "Map the journey for a new user completing their first task in a project management app."
> [User Researcher] "Synthesize patterns from these 8 interview notes about notification fatigue."
> [Brief Writer] "Write the design brief for: people who want to track their reading progress without leaving the book."
> [Metrics Definer] "Define success metrics for a new onboarding flow."
> [Assumption Mapper] "Surface the assumptions behind adding a 'smart suggestions' feature to a text editor."

**Pass criteria (all five agents):**
- [ ] Produces an HTML file using the correct kit template (`user-journey.html`, `user-narrative.html`, `design-brief.html`, `metrics-plan.html`, `risk-register.html` respectively)
- [ ] Writes the file to disk at the expected path (e.g., `specs/<slug>-journey.html`)
- [ ] Does not emit ad-hoc HTML or a prose-only artifact in the response
- [ ] Surfaces a short markdown summary in conversation: file path, headline, key findings
- [ ] Offers `/studio:annotate <file-path>` after writing

**Anti-patterns:**
- Producing the artifact only as prose in the response (Prose-Only Artifact)
- Inventing custom HTML structure instead of using the kit template (Ad-Hoc HTML)
- Writing to disk without the markdown conversation summary
- Skipping the annotation offer

---

## Eval summary template

```
Discovery & PM Agents Eval Run — [date]
Triggered by: [what changed]

Journey Mapper Eval 1 — Real trigger:        PASS / FAIL
User Researcher Eval 2 — Sample/confidence:  PASS / FAIL
Brief Writer Eval 3 — Validation/scope:      PASS / FAIL
Metrics Definer Eval 4 — Outcome/counter:    PASS / FAIL
Assumption Mapper Eval 5 — Binding assumption:PASS / FAIL
Artifact Production Eval 6 — HTML via template:PASS / FAIL

Overall: PASS / FAIL
Failed criteria: [list]
Anti-patterns fired: [list]
```
