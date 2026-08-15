# Orchestration — Graph Doctrine

How multi-agent workflows in Studio OS declare, execute, and govern their topology. Skills orchestrate; this file is the shared method they orchestrate by. Single-pass and interview skills are exempt — a graph block on a linear skill is decoration.

The principle: **the topology is declared, not improvised.** A workflow that fans out, joins, loops, or gates does so because its graph says so — never because the orchestrator felt like it mid-run. Loop discipline governs how each node executes; graph discipline governs which nodes exist and which transitions are permitted.

---

## The graph block

Every multi-agent skill declares its topology in exactly one fenced ` ```graph ` block near the top of its `SKILL.md`. The prose steps remain the executable instructions; the graph block is the contract the prose must match. `evals/lint-agnostic.sh` R7 validates every block structurally.

### Grammar

```
skill: <name>
cost: <low|medium|high> — <one-line spend rationale>
nodes:
  <id>   agent:<agent-name> [owner:<deliverable>] [join]
  <id>   gate[:<what it verifies>]
  <id>   human decides:<the decision only the human can make>
  <id>   router(<option-a>|<option-b>|...)
  <id>   task[:<deterministic step>]
edges:
  <id> -> <id> [-> <id> ...]
  <id> -> {<id>, <id>, <id>}   [if:<condition>]     # fan-out
  {<id>, <id>} -> <id>                              # fan-in (target is a join)
  <id> -> <id>   loop max:<N>                       # bounded loop — max is mandatory
  <id> -> <id>   if:<condition>                     # conditional edge
```

### Node types (six — the complete set)

| Type | Meaning | Existing construct it names |
|---|---|---|
| `agent:<name>` | A discipline agent from `agents/`. Executes one node's work. | "Apply the [Discipline] discipline" / subagent spawn |
| `gate` | A verdict node — work stops here unless it passes. | PM gate · CD SHIP/NO-SHIP · DE review · slop test |
| `human` | A blocking human decision. Skipped in `--auto`. | PAUSE block |
| `router(...)` | Mechanical branch on declared options. Not a judgment call. | Phase gates (exploratory / in-progress / refinement), thresholds |
| `join` | Fan-in synthesis. Waits for **all** members; preserves dissent. | Synthesis steps after parallel rounds |
| `task` | A deterministic step — file emission, scaffold, template render. | HTML artifact emission |

### Edge rules

- **Fan-out members are independent.** No edges between members of the same fan-out group. If two nodes need each other's unfinished output, they are sequential — declare them so. This is the structural test for "may parallelize."
- **Every loop is bounded.** `loop max:N` is mandatory. An unbounded loop is a lint FAIL, not a style choice.
- **Joins wait for all members.** A join that proceeds with missing inputs is a defect. If a member fails, the join reports it (see Failure reporting) — it does not silently synthesize around the hole.
- **`owner:` carries the single-owner rule into the graph.** Exactly one node owns each deliverable.

### Established mappings

PM → CD → DE is a guard-node chain. The Six Functions are a minimum-coverage invariant over any artifact-producing graph (`evals/six-functions.map` drives the lint check). `/studio:solve`'s three-iteration convergence is the canonical bounded evaluator-optimizer loop (`loop max:3`).

---

## Human-node economics

A `human` node is earned only where the human makes a decision the studio cannot:

1. **Direction or taste selection** — choosing among generated options.
2. **Scope or risk acceptance** — widening, narrowing, or accepting a named risk.
3. **An irreversibility boundary** — production writes, external publishing, release.
4. **A contested gate** — agents still disagree after the debate round; the human breaks the tie.

Every `human` node carries `decides:<what>` naming that decision. A human node with nothing to decide is a defect — the lint fails it.

Progress reports are not decisions. "Context loaded," "reduction complete," "judgment complete" become **status lines in the output**, never pauses. The human's attention is the studio's scarcest resource; spend it only where judgment changes the outcome.

**Interview skills are exempt.** In `shape` (and its task mode) the conversation *is* the work — those pauses are the interview, not checkpoints, and are not graph nodes.

---

## Adversarial doctrine

The studio's quality comes from structured disagreement between disciplines. The graph makes that disagreement structural rather than temperamental:

- **Blind fan-out.** Members of a fan-out never see each other's unfinished output. Independence is what produces genuine disagreement; agents that read each other converge early and produce consensus slop. Brief each member from the shared inputs only.
- **Preserved dissent at joins.** A join synthesizes, but named dissents travel forward to the gate. Verdict artifacts include a dissent ledger: which discipline disagreed, with what, and why it was overruled. Averaging disagreement away is **Consensus Laundering** (see `memory/anti-patterns.md`).
- **Refutation edge on ship verdicts.** A SHIP from CD (design) or DE (engineering) gets one bounded adversarial pass: the critic (design) or qa (engineering) is prompted explicitly to *refute* the verdict — strongest case against, not a second opinion. SHIP stands only if the refutation fails. `loop max:1` — the refutation cannot stall shipping; it can only send work back once with named defects.
- **The slop gate is topology.** Every artifact-producing graph carries a `gate` node running the seven markers of `/studio:studio-slop` before its output `task` node. The quality floor is a structural property of the graph, not an opt-in skill.

---

## Run state

Failure in a graph must be localizable: which node failed, with what inputs, what is now blocked.

- **Interactive runs:** every output section is labeled with its node id. State lives in the conversation.
- **`--auto` runs:** the orchestrator maintains a node ledger in `AUTO_RUN_STATE.md` on the auto branch — one line per node: `<node-id> · <done|running|blocked> · <artifact path or —> · <commit>`. Delete the ledger on successful completion; leave it in place on failure so the morning review starts at the failed node.

### Failure reporting

When a node fails, the synthesis names: the node id, the inputs it was given, and the downstream nodes now blocked. Never silently continue past a failed join input. A partial result is reported as partial.

---

## Spend doctrine

Parallelism buys quality and wall-clock with tokens. Spend deliberately:

- Every graph block carries a `cost:` line naming its heaviest structure ("one fan-out of 9 discipline agents").
- Parallelize only when at least two nodes can progress without reading each other's unfinished output — enforced structurally by the no-intra-fan-out-edges rule.
- A graph is added to a skill only when it relieves a named constraint (width, independence, bounded convergence). Linear skills stay linear.

---

## Executors

Each graph-declaring skill ships a sidecar `workflow.js` — a deterministic executor for environments where the Workflow tool is available. The graph block remains the contract either way; the prose path is never removed.

- **Segments.** A graph's `human` nodes partition it into segments. Interactive mode: the orchestrator runs one segment per workflow invocation, converses at the human node, then runs the next segment (prior artifacts passed via `args`). `--auto` mode: human nodes are skipped by contract, so the executor runs all segments end-to-end in one invocation.
- **Conformance.** The executor's agent roster and phase titles must match the graph block's agent set and segments — `evals/lint-agnostic.sh` R7.c fails on divergence.
- **Parity.** Prose path and executor path follow the same graph: same order, same gates, same bounded loops, same node-labeled outputs.

---

## Auto-Mode Safety Contract

The single source of truth. Skills reference this contract with a three-line stub; the full text lives only here. `evals/lint-agnostic.sh` R8 enforces the stub in every skill that supports `--auto`.

If `--auto` appears in a skill's arguments, suppress PAUSE checkpoints (`human` nodes) and proceed with reasonable defaults, stating any decisions made on the user's behalf in the final output's "Auto-mode decisions" section. Before performing any action in `--auto` mode, the orchestrator MUST verify:

1. **Not on the main branch.** If `git rev-parse --abbrev-ref HEAD` returns `main` (or the repo's primary branch), the orchestrator MUST create a new branch named `auto/<skill>-<timestamp>` and switch to it before any writes. Prefer a `git worktree` if multiple `--auto` skills may run in parallel.
2. **No push.** The orchestrator MUST NOT run `git push`, `git push --force`, `gh pr create`, or any remote-affecting command. All work stays local on the auto branch.
3. **No tag.** The orchestrator MUST NOT run `release.sh` or `git tag` in `--auto` mode. Tagging is a deliberate human act after review.
4. **No merge.** The orchestrator MUST NOT merge the auto branch into main or any other branch.
5. **Commit allowed; bounded.** Commits to the auto branch are permitted (and encouraged — they create a reviewable checkpoint history). Each commit is one logical change with a clear message.
6. **Final summary required.** The Output of every `--auto` run MUST include a "Branch" line naming the auto branch, a "Diff size" line (files changed, lines added/removed), and the exact `git checkout <branch>` + `git diff main...<branch>` commands the human can run to review in the morning.

If any of conditions 1–4 cannot be satisfied (e.g., dirty tree, no git repo), the orchestrator MUST refuse to proceed and surface the blocking condition in the output. **Never bypass a guard to make a run succeed.**

Graph-declaring skills additionally maintain the run-state node ledger (see Run state) for the duration of the `--auto` run.

### The stub

Skills that support `--auto` carry exactly this, in place of the full contract:

> If `--auto` appears in $ARGUMENTS: read and apply the **Auto-Mode Safety Contract** from `memory/orchestration.md` before any action. Never bypass a guard to make a run succeed. Graph-declaring skills maintain the run-state node ledger per the same file.
