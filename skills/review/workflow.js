// Executor for /studio:review — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Round 1' (scope → fan-out → verdicts → conflict router) and 'Resolution'
// (debate → refutation → final). The tiebreak human node separates them; --auto runs both,
// resolving a surviving tie via the cascade rule (PM > CD > DE).
//
// args: {
//   artifact:   string  — artifact description + file paths (required)
//   context:    string  — project context summary + PM brief if loaded
//   phase:      string  — 'pre-ship' | 'checkpoint' | 'post-ship audit'
//   members:    array   — applicable LT members, subset of ['pm','cd','de'] (default all three)
//   mode:       string  — 'round1' (segment 1) | 'resolve' (segment 2) | 'auto' (both)
//   round1:     object  — prior segment result, required when mode === 'resolve'
//   tiebreak:   object  — human ruling when one was made: { element, ruling }
//   date:       string  — run date, stamped by the orchestrator
// }
// Returns structured verdicts; the orchestrator renders the lt-review HTML (emit node).

export const meta = {
  name: 'review',
  description: 'LT review — blind PM/CD/DE fan-out, conditional debate, refutation on SHIP, dissent ledger',
  phases: [
    { title: 'Round 1', detail: 'blind fan-out of applicable LT members, verdict join, conflict router' },
    { title: 'Resolution', detail: 'debate, refutation of SHIP verdicts, final synthesis' },
  ],
}

const PHASE_FRAMING = (phase) =>
  `The review phase is ${phase}. Calibrate accordingly: pre-ship = full ship gate, verdicts carry full weight; ` +
  `checkpoint = frame verdicts as 'ready to advance' not 'ready to ship', findings inform direction; ` +
  `post-ship audit = name cost-of-change for any finding (targeted fix vs. breaking redesign).`

const MEMBERS = [
  { id: 'pm', agentType: 'studio:pm', verdicts: ['READY', 'HOLD'], round1: 'You are the PM in an LT Review. Your mandate: evaluate whether the solution is still solving the validated problem. Check for drift from the PM brief (provided). Deliver your Four Moves assessment focused on problem-solution fit. Apply your Specialist Network — name any specialist that should be engaged to resolve a gap.', debate: 'Where CD or DE recommends action on something you flagged as out of scope, restate whether the action serves the validated problem or extends it. Where another member\'s blocker depends on a problem you have not validated, name that. Where their concern reveals a problem in your validation that you missed, acknowledge it.' },
  { id: 'cd', agentType: 'studio:cd', verdicts: ['SHIP', 'NO-SHIP'], round1: 'You are the Design Director in an LT Review. Your mandate: evaluate design quality and deliver a SHIP / NO-SHIP verdict. Apply your Specialist Routing — name the specific specialist or skill for each issue. Do not route everything to /design; calibrate to scope.', debate: 'Where PM flags drift that affects design intent, state whether the design assumes a different problem than the one PM validated. Where DE\'s implementation concern reveals a craft consequence, name it. Where another member proposes a change that would compromise design integrity, state precisely what would break.' },
  { id: 'de', agentType: 'studio:de', verdicts: ['SHIP', 'REVISE', 'REJECT'], round1: 'You are the Distinguished Engineer in an LT Review. Your mandate: evaluate implementation soundness and deliver a SHIP / REVISE / REJECT verdict. Apply your Specialist Network — name the specialist for each required change.', debate: 'Where PM or CD proposes a change with implementation consequence (cost, durability, invariant impact), name it precisely. Where another member\'s blocker masks a deeper engineering issue, surface it. Where you can support a change you previously called REVISE/REJECT, state what would change your verdict.' },
]

const VERDICT_SCHEMA = (allowed) => ({
  type: 'object',
  required: ['member', 'verdict', 'position', 'routing'],
  properties: {
    member: { type: 'string' },
    verdict: { type: 'string', enum: allowed },
    position: { type: 'string', description: '2–3 sentences, the mandate-specific assessment' },
    routing: { type: 'array', items: { type: 'string' }, description: 'each required change: Issue → Specialist/Skill → then what' },
    flaggedElements: { type: 'array', items: { type: 'string' }, description: 'specific elements/surfaces this verdict turns on' },
  },
})

const CONFLICT_SCHEMA = {
  type: 'object',
  required: ['conflicts', 'signals', 'convergences'],
  properties: {
    conflicts: { type: 'boolean' },
    signals: { type: 'array', items: { type: 'string' }, description: 'which fired: split-verdict-same-element, incompatible-routing, dependent-verdicts' },
    convergences: { type: 'array', items: { type: 'string' } },
    elements: { type: 'array', items: { type: 'string' }, description: 'the specific elements in conflict' },
  },
}

const REFUTE_SCHEMA = {
  type: 'object',
  required: ['refuted', 'case'],
  properties: {
    refuted: { type: 'boolean', description: 'true only if a credible case against shipping exists' },
    case: { type: 'string', description: 'the strongest case against, with named defects — or why no credible case exists' },
    defects: { type: 'array', items: { type: 'string' } },
  },
}

const FINAL_SCHEMA = {
  type: 'object',
  required: ['combinedVerdict', 'nextAction', 'dissentLedger'],
  properties: {
    combinedVerdict: { type: 'string', enum: ['SHIP', 'REVISE', 'HOLD', 'REJECT'] },
    nextAction: { type: 'string' },
    hardened: { type: 'array', items: { type: 'string' } },
    changed: { type: 'array', items: { type: 'string' } },
    unresolvedTensions: { type: 'array', items: { type: 'string' } },
    routing: { type: 'array', items: { type: 'string' }, description: 'cascade priority: PM, then CD, then DE' },
    dissentLedger: { type: 'array', items: { type: 'string' }, description: 'each overruled/unresolved position: member, disagreement, why overruled. Empty only for genuine alignment.' },
  },
}

const applicable = MEMBERS.filter((m) => (args.members || ['pm', 'cd', 'de']).includes(m.id))
const shared = `ARTIFACT:\n${args.artifact}\n\nCONTEXT (incl. PM brief if loaded):\n${args.context || 'none provided'}\n\n${PHASE_FRAMING(args.phase || 'pre-ship')}`

const runFan = (round, round1Verdicts) =>
  parallel(applicable.map((m) => () =>
    agent(
      round === 1
        ? `${m.round1}\n\n${shared}`
        : `You are the ${m.id.toUpperCase()} in an LT Review (Round 2 — debate). You have the Round 1 verdicts from all LT members. Respond to the other positions. ${m.debate} Keep each response to two sentences.\n\n${shared}\n\nROUND 1 VERDICTS:\n${JSON.stringify(round1Verdicts)}`,
      { label: `${round === 1 ? 'round1' : 'debate'}:${m.id}`, phase: round === 1 ? 'Round 1' : 'Resolution', agentType: m.agentType, schema: VERDICT_SCHEMA(m.verdicts) }
    )
  ))

const mode = args.mode || 'auto'
let round1 = args.round1 || null
let conflict = args.conflict || null

if (mode === 'round1' || mode === 'auto') {
  phase('Round 1')
  const results = await runFan(1)
  const failed = applicable.filter((m, i) => !results[i]).map((m) => m.id)
  if (failed.length) log(`node(s) failed: ${failed.join(', ')} — reporting mandate as missing, not synthesizing around the hole`)
  round1 = { verdicts: results.filter(Boolean), failedNodes: failed }

  conflict = await agent(
    `You are the verdicts join + conflict router of an LT review. Assess the three conflict signals exactly: (1) split verdict on the same element, (2) convergent flags with incompatible routing, (3) dependent verdicts that have not engaged each other's reasoning. Preserve disagreement as named conflicts — never average it away.\n\nVERDICTS:\n${JSON.stringify(round1.verdicts)}`,
    { label: 'conflict-router', phase: 'Round 1', schema: CONFLICT_SCHEMA }
  )
}

let debate = null
let tiebreakNeeded = false
let refutations = []
let final = null

if (mode === 'resolve' || mode === 'auto') {
  phase('Resolution')

  if (conflict && conflict.conflicts) {
    const results = await runFan(2, round1.verdicts)
    debate = { responses: results.filter(Boolean) }
    const post = await agent(
      `Post-debate check: are the LT members still split on the same element, or did the debate resolve the conflict? List each member's standing verdict after the debate.\n\nROUND 1:\n${JSON.stringify(round1.verdicts)}\n\nDEBATE:\n${JSON.stringify(debate.responses)}`,
      { label: 'post-debate', phase: 'Resolution', schema: { type: 'object', required: ['stillSplit', 'standingVerdicts'], properties: { stillSplit: { type: 'boolean' }, splitElement: { type: 'string' }, standingVerdicts: { type: 'array', items: { type: 'object', properties: { member: { type: 'string' }, verdict: { type: 'string' } } } } } } }
    )
    debate.post = post
    tiebreakNeeded = post.stillSplit && !args.tiebreak
    if (tiebreakNeeded && mode === 'auto') {
      log('tiebreak node: still split in --auto — resolving via cascade rule (PM > CD > DE); overruled positions enter the dissent ledger')
      tiebreakNeeded = false
    }
  }

  if (tiebreakNeeded) {
    // Interactive segment boundary: return for the human tiebreak, then re-invoke with mode:'resolve' + args.tiebreak.
    return { date: args.date, phase: args.phase, round1, conflict, debate, awaiting: 'tiebreak', question: debate.post.splitElement }
  }

  // Refutation — skipped when a human tiebreak ruled; SHIP must otherwise survive one adversarial pass.
  if (!args.tiebreak) {
    const standing = (debate && debate.post ? debate.post.standingVerdicts : round1.verdicts.map((v) => ({ member: v.member, verdict: v.verdict })))
    const refuters = []
    if (standing.some((v) => v.member === 'cd' && v.verdict === 'SHIP'))
      refuters.push({ node: 'refute-cd', agentType: 'studio:critic', target: 'the Design Director has ruled SHIP on this artifact', lens: 'what is unresolved, unearned, or incoherent in the design' })
    if (standing.some((v) => v.member === 'de' && v.verdict === 'SHIP'))
      refuters.push({ node: 'refute-de', agentType: 'studio:qa', target: 'the Distinguished Engineer has ruled SHIP on this implementation', lens: 'untested invariants, missing regression coverage, boundary failures' })
    refutations = (await parallel(refuters.map((r) => () =>
      agent(
        `${r.target}. Your task is to REFUTE that verdict — make the strongest case against shipping, not a second opinion. Name specific defects: ${r.lens}. If you cannot build a credible case, say so plainly (refuted: false).\n\n${shared}\n\nSTANDING VERDICTS:\n${JSON.stringify(standing)}`,
        { label: r.node, phase: 'Resolution', agentType: r.agentType, schema: REFUTE_SCHEMA }
      ).then((v) => ({ node: r.node, result: v }))
    ))).filter(Boolean)
  }

  final = await agent(
    `Produce the final LT review synthesis (final node). Apply the combined-verdict logic (SHIP = all pass; REVISE = changes required; HOLD = PM drift subordinates others; REJECT = structural restart) and cascade priority PM > CD > DE. A successful refutation downgrades that member's SHIP to REVISE with the named defects as routing items. Preserve every overruled or unresolved position in the dissent ledger — a verdict with vanished dissent is Consensus Laundering.\n\nROUND 1:\n${JSON.stringify(round1)}\n\nCONFLICT:\n${JSON.stringify(conflict)}\n\nDEBATE:\n${JSON.stringify(debate)}\n\nTIEBREAK (human ruling, outranks refutation):\n${JSON.stringify(args.tiebreak || null)}\n\nREFUTATIONS:\n${JSON.stringify(refutations)}`,
    { label: 'final', phase: 'Resolution', schema: FINAL_SCHEMA }
  )
}

return { date: args.date, phase: args.phase, round1, conflict, debate, refutations, tiebreak: args.tiebreak || null, final }
