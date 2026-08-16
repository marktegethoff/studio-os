// Executor for /studio:solve — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Loop' (post-framing: the bounded convergence loop through the CD verdict,
// refutation, accessibility, slop gate) and 'Close' (post-exit-path, unresolved runs only).
// The framing and exit-path human nodes separate them; --auto runs end-to-end with logged defaults.
//
// args: {
//   problem:     string  — the one-sentence framed problem + named tension (framing node output; required)
//   constraints: string  — the non-negotiable constraints stated at the framing node
//   context:     string  — project context + PM brief + relevant ledger decisions
//   surfaceWork: boolean — the solution involves a surface (if:surface-work)
//   crafts:      array   — sub-team subset of ['typesetter','choreographer','writer','visual'] the solution requires
//   mode:        string  — 'loop' | 'auto'  (the exit-path decision returns to the orchestrator either way)
//   date:        string  — run date, stamped by the orchestrator
// }
// Returns the solution or honest-unresolved state; the orchestrator emits and pauses at exit-path when unresolved.

export const meta = {
  name: 'solve',
  description: 'Bounded evaluator-optimizer: max 3 iterations to an inevitable, refuted, slop-gated solution',
  phases: [
    { title: 'Loop', detail: 'design → critic → marketer → CD verdict, re-entering at most 3 times' },
    { title: 'Close', detail: 'refutation, accessibility, slop gate' },
  ],
}

const TEXT = { type: 'string' }
const VERDICT_SCHEMA = {
  type: 'object',
  required: ['verdict', 'reasoning', 'calibration'],
  properties: {
    verdict: { type: 'string', enum: ['INEVITABLE', 'NOT YET', 'STRUCTURALLY WRONG'] },
    reasoning: TEXT,
    whatIsWrong: { type: 'string', description: 'for NOT YET: precisely what is not in essential form' },
    calibration: { type: 'object', required: ['necessary', 'coherent', 'simplest', 'removalWouldImprove', 'consistent'], properties: { necessary: { type: 'boolean' }, coherent: { type: 'boolean' }, simplest: { type: 'boolean' }, removalWouldImprove: { type: 'boolean' }, consistent: { type: 'boolean' } } },
    dissents: { type: 'array', items: TEXT, description: 'overruled objections, incl. any marketer commercial objection — preserved, never averaged away' },
  },
}
const REFUTE_SCHEMA = {
  type: 'object',
  required: ['refuted', 'case'],
  properties: { refuted: { type: 'boolean' }, case: TEXT, defects: { type: 'array', items: TEXT } },
}
const SLOP_SCHEMA = { type: 'object', required: ['markersFired', 'pass'], properties: { markersFired: { type: 'array', items: TEXT }, pass: { type: 'boolean' } } }

const CRAFTS = [
  { id: 'typesetter', agentType: 'studio:typesetter', brief: 'type hierarchy for the solution surface' },
  { id: 'choreographer', agentType: 'studio:choreographer', brief: 'earned motion for the solution surface' },
  { id: 'writer', agentType: 'studio:writer', brief: 'the language the solution requires' },
  { id: 'visual', agentType: 'studio:visual-designer', brief: 'visual execution: spacing, proportion, weight' },
]

const shared = `PROBLEM (framed):\n${args.problem}\n\nCONSTRAINTS (non-negotiable during the loop):\n${args.constraints || 'none stated'}\n\nCONTEXT:\n${args.context || 'none provided'}`

phase('Loop')
const historian = await agent(`You are the historian. What has been tried before on this class of problem? What survived, what failed and why? Cite specific examples; do not invent precedent.\n\n${shared}`,
  { label: 'historian', phase: 'Loop', agentType: 'studio:historian' })

const iterations = []
let solution = null
let cdResult = null

for (let i = 1; i <= 3; i++) {
  const priorDiagnosis = iterations.length ? iterations[iterations.length - 1].verdict.whatIsWrong : null

  const architect = await agent(`You are the architect (iteration ${i} of 3). Produce the structural basis of the simplest solution that satisfies the constraints.${priorDiagnosis ? ` The prior iteration failed for this reason — resolve it, do not vary around it: ${priorDiagnosis}` : ''}\n\n${shared}\n\nPRECEDENT:\n${historian}`,
    { label: `iter${i}:architect`, phase: 'Loop', agentType: 'studio:architect' })
  const designer = await agent(`You are the designer (owner: solution; iteration ${i} of 3). Produce the simplest structure that satisfies the constraints. Maximum 2 directions; recommend one and state why.${priorDiagnosis ? ` Prior failure to resolve: ${priorDiagnosis}` : ''}\n\n${shared}\n\nARCHITECT:\n${architect}`,
    { label: `iter${i}:designer`, phase: 'Loop', agentType: 'studio:designer' })

  let craftOut = null
  if (args.surfaceWork) {
    const active = CRAFTS.filter((c) => (args.crafts || CRAFTS.map((x) => x.id)).includes(c.id))
    const results = await parallel(active.map((c) => () =>
      agent(`You are the ${c.id} (blind pass — you do not see the other craft agents). Apply your discipline to the recommended direction: ${c.brief}.\n\n${shared}\n\nDESIGN:\n${designer}`,
        { label: `iter${i}:craft:${c.id}`, phase: 'Loop', agentType: c.agentType })
    ))
    const failed = active.filter((c, j) => !results[j]).map((c) => c.id)
    if (failed.length) log(`craft node(s) failed at iteration ${i}: ${failed.join(', ')} — reported as missing at craft-join`)
    craftOut = results.filter(Boolean)
  }

  const criticStandard = i === 1 ? 'Remove everything unnecessary. What is left?'
    : i === 2 ? 'Of what remains, what is still not the simplest correct form? Remove again.'
    : 'Is every remaining element inevitable? If anything could be different without loss, it is not yet right.'
  const critic = await agent(`You are the critic (iteration ${i} of 3 — the standard escalates). ${criticStandard}\n\nDESIGN:\n${designer}${craftOut ? `\n\nCRAFT:\n${JSON.stringify(craftOut)}` : ''}`,
    { label: `iter${i}:critic`, phase: 'Loop', agentType: 'studio:critic' })
  const marketer = await agent(`You are the marketer running the commercial pressure test (not a veto). Will users find, choose, and pay for this? Is the complexity proportionate to the return? If it fails commercially, name it explicitly.\n\nDESIGN (post-reduction):\n${designer}\n\nCRITIC:\n${critic}`,
    { label: `iter${i}:marketer`, phase: 'Loop', agentType: 'studio:marketer' })

  cdResult = await agent(`You are the Creative Director evaluating iteration ${i} of 3. Verdict: INEVITABLE (nothing can be removed, clarified, aligned, or simplified) / NOT YET (name precisely what is wrong) / STRUCTURALLY WRONG (the framing or a constraint is incorrect — the direction cannot converge). Answer the five calibration questions explicitly. Your verdict must account for the commercial dimension; if you overrule the marketer, record it as a dissent.\n\n${shared}\n\nDESIGN:\n${designer}${craftOut ? `\n\nCRAFT:\n${JSON.stringify(craftOut)}` : ''}\n\nCRITIC:\n${critic}\n\nMARKETER:\n${marketer}`,
    { label: `iter${i}:cd`, phase: 'Loop', agentType: 'studio:cd', schema: VERDICT_SCHEMA })

  iterations.push({ iteration: i, architect, designer, craft: craftOut, critic, marketer, verdict: cdResult })
  log(`iteration ${i}: ${cdResult.verdict}`)

  if (cdResult.verdict === 'INEVITABLE') { solution = designer; break }
  if (cdResult.verdict === 'STRUCTURALLY WRONG') break
}

let refutation = null
let accessibility = null
let slop = null

if (solution) {
  phase('Close')
  refutation = await agent(`The Creative Director has ruled this solution INEVITABLE. Your task is to REFUTE that verdict — the strongest case against inevitability, not a second opinion: what could still be removed, what constraint was quietly relaxed, what alternative was dismissed without being priced. If you cannot build a credible case, say so plainly (refuted: false).\n\n${shared}\n\nSOLUTION:\n${solution}\n\nCD REASONING:\n${JSON.stringify(cdResult)}`,
    { label: 'refute', phase: 'Close', agentType: 'studio:critic', schema: REFUTE_SCHEMA })

  if (refutation.refuted) {
    // refute -> designer, loop max:1 — one bounded return, then the verdict question re-poses to CD once.
    log(`refutation succeeded — one bounded designer return: ${refutation.defects ? refutation.defects.join('; ') : refutation.case}`)
    solution = await agent(`You are the designer revising the solution once, per the refutation's named defects. Change precisely what the defects require and nothing else.\n\nDEFECTS:\n${JSON.stringify(refutation.defects || [refutation.case])}\n\nCURRENT SOLUTION:\n${solution}`,
      { label: 'designer-revision', phase: 'Close', agentType: 'studio:designer' })
  }

  if (args.surfaceWork) {
    accessibility = await agent(`You are the accessibility specialist. Check the solution surface at production weight: contrast, targets, screen reader labels, reduce-motion. Name the WCAG criterion per finding.\n\nSOLUTION:\n${solution}`,
      { label: 'accessibility', phase: 'Close', agentType: 'studio:accessibility' })
  }

  slop = await agent(`Run the seven slop markers of /studio:studio-slop against the solution artifact (slop gate node). Quote evidence for any marker that fires.\n\nARTIFACT:\n${JSON.stringify({ solution, verdict: cdResult })}`,
    { label: 'slop-gate', phase: 'Close', schema: SLOP_SCHEMA })
}

return {
  date: args.date,
  problem: args.problem,
  iterations,
  outcome: solution ? 'inevitable' : (cdResult && cdResult.verdict === 'STRUCTURALLY WRONG' ? 'structurally-wrong' : 'unresolved'),
  solution,
  refutation,
  accessibility,
  slopGate: slop,
  dissentLedger: iterations.flatMap((it) => it.verdict.dissents || []),
}
