// Executor for /studio:discover — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Discovery' (post-materials: research → journey → assumptions → pm-gate) and
// 'Brief' (post-pm-call: brief-writer). The materials and pm-call human nodes separate them;
// --auto runs end-to-end (found materials or team knowledge at Low confidence; pm-gate verdict stands).
//
// args: {
//   problem:   string  — the problem or feature area (required)
//   context:   string  — project context summary
//   materials: string  — research materials supplied at the materials node ('' = team knowledge only)
//   mode:      string  — 'discovery' | 'brief' | 'auto'
//   prior:     object  — discovery-segment result, required for 'brief'
//   pmCall:    string  — the human's confirmed verdict at pm-call ('validated' | 'modified: <scope>' | 'stopped')
//   date:      string  — run date, stamped by the orchestrator
// }
// A linear chain — no parallel() anywhere: each stage consumes the prior stage's output.
// A failed stage blocks everything downstream; the partial result names the failed node.

export const meta = {
  name: 'discover',
  description: 'Sequential discovery: research → journey → assumptions → PM gate → brief',
  phases: [
    { title: 'Discovery', detail: 'research synthesis through the PM gate' },
    { title: 'Brief', detail: 'brief-writer after the PM call' },
  ],
}

const TEXT = { type: 'string' }
const PM_SCHEMA = {
  type: 'object',
  required: ['verdict', 'reasoning'],
  properties: {
    verdict: { type: 'string', enum: ['validated', 'modify scope', 'stop'] },
    reasoning: TEXT,
    modifiedScope: { type: 'string', description: 'the narrowed problem, when verdict is modify scope' },
  },
}

const shared = `PROBLEM AREA:\n${args.problem}\n\nPROJECT CONTEXT:\n${args.context || 'none provided'}\n\nRESEARCH MATERIALS:\n${args.materials || 'none — team knowledge only; findings are Low confidence until validated'}`
const mode = args.mode || 'auto'
let discovery = args.prior || null

const stages = [
  { node: 'research', agentType: 'studio:user-researcher', prompt: `You are the user-researcher. ${args.materials ? 'Inventory the research (type, sample size, recency), extract raw observations verbatim, identify patterns with confidence levels (H/M/L), surface contradictions with their conditions, and name research gaps.' : 'No research materials were provided: state this explicitly, and document team beliefs as clearly-labeled Low-confidence hypotheses, not observations.'}\n\n${shared}` },
  { node: 'journey', agentType: 'studio:journey-mapper', prompt: null }, // built from research output below
  { node: 'assumptions', agentType: 'studio:assumption-mapper', prompt: null },
]

if (mode === 'discovery' || mode === 'auto') {
  phase('Discovery')
  const out = {}
  let blocked = null

  out.research = await agent(stages[0].prompt, { label: 'research', phase: 'Discovery', agentType: stages[0].agentType })
  if (!out.research) blocked = 'research'

  if (!blocked) {
    out.journey = await agent(`You are the journey-mapper. Using the research synthesis: define journey boundaries (trigger, successful outcome, failed outcome), map 3–6 stages (verb-noun name, goal, current state, need, friction type: Orientation/Effort/Confidence/Recovery), map entry/exit paths, and rank the moments that matter. Close with the design brief anchor.\n\n${shared}\n\nRESEARCH SYNTHESIS:\n${out.research}`,
      { label: 'journey', phase: 'Discovery', agentType: 'studio:journey-mapper' })
    if (!out.journey) blocked = 'journey'
  }

  if (!blocked) {
    out.assumptions = await agent(`You are the assumption-mapper. Surface assumptions across User / Technical / Market / Resource as testable claims ("We are assuming that..."), assess Confidence × Impact, name the single binding assumption first, and give the cheapest validation path for it and for every Low-confidence/High-impact assumption.\n\n${shared}\n\nRESEARCH:\n${out.research}\n\nJOURNEY:\n${out.journey}`,
      { label: 'assumptions', phase: 'Discovery', agentType: 'studio:assumption-mapper' })
    if (!blocked && !out.assumptions) blocked = 'assumptions'
  }

  if (!blocked) {
    out.pmGate = await agent(`You are the PM at the discovery gate (pm-gate node). Answer: (1) Is the problem worth solving — does it align with product strategy? (2) Are there users we know have this problem, or are we still assuming? (3) Does anything in the research or assumption register change the go/no-go? Verdict: validated / modify scope / stop, with reasoning.\n\n${shared}\n\nRESEARCH:\n${out.research}\n\nJOURNEY:\n${out.journey}\n\nASSUMPTIONS:\n${out.assumptions}`,
      { label: 'pm-gate', phase: 'Discovery', agentType: 'studio:pm', schema: PM_SCHEMA })
    if (!out.pmGate) blocked = 'pm-gate'
  }

  if (blocked) {
    const chain = ['research', 'journey', 'assumptions', 'pm-gate', 'brief', 'emit']
    const downstream = chain.slice(chain.indexOf(blocked) + 1)
    log(`node ${blocked} failed — downstream blocked: ${downstream.join(', ')}`)
    return { date: args.date, problem: args.problem, discovery: out, failedNode: blocked, blockedNodes: downstream }
  }
  discovery = out
}

let brief = null
const pmCall = args.pmCall || (mode === 'auto' && discovery ? discovery.pmGate.verdict : null)
if (mode === 'auto' && !args.pmCall) log(`pm-call node (--auto): the pm-gate verdict stands — ${pmCall}`)

if ((mode === 'brief' || mode === 'auto') && discovery && pmCall && pmCall !== 'stop' && pmCall !== 'stopped') {
  phase('Brief')
  brief = await agent(`You are the brief-writer (owner: brief). Translate the validated discovery into the design brief: Problem (one sentence), User (primary/secondary archetypes), Success conditions (specific, evaluable), Constraints, Out of scope, Open questions (owner + needed-by), Brief status.${discovery.pmGate.modifiedScope ? ` The PM narrowed the scope — write against it: ${discovery.pmGate.modifiedScope}` : ''}\n\n${shared}\n\nDISCOVERY:\n${JSON.stringify(discovery)}`,
    { label: 'brief', phase: 'Brief', agentType: 'studio:brief-writer' })
}

return { date: args.date, problem: args.problem, discovery, pmCall, brief }
