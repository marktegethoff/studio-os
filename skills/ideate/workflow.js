// Executor for /studio:ideate — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Diverge' (post-confirm: 7-lens fan-out → reduction → desirability),
// 'Evaluate' (post-select: 3-evaluator fan-out → DE verdict),
// 'Close' (post-pick: cd ship gate + slop gate data).
// The confirm/select/pick human nodes separate them; --auto runs all with logged defaults.
//
// args: {
//   problem:   string  — the gate-passing problem statement (required; the problem gate runs in prose before this)
//   context:   string  — project context + PM brief summary
//   mode:      string  — 'diverge' | 'evaluate' | 'close' | 'auto'
//   ideas:     object  — prior segment result (reduce output), required for 'evaluate'
//   selected:  array   — the human-selected ideas (select node), required for 'evaluate'
//   picked:    array   — the human-picked final 1–2 directions (pick node), required for 'close'
//   date:      string  — run date, stamped by the orchestrator
// }
// Returns structured results; the orchestrator renders the ideation-output HTML (emit node).

export const meta = {
  name: 'ideate',
  description: 'Divergence across 7 blind lenses, facilitated reduction, feasibility, CD ship gate',
  phases: [
    { title: 'Diverge', detail: 'blind 7-lens fan-out, reduction chain, desirability' },
    { title: 'Evaluate', detail: 'blind 3-evaluator fan-out per selected idea, DE verdict' },
    { title: 'Close', detail: 'cd ship gate + slop gate on the final directions' },
  ],
}

const LENSES = [
  { id: 'historian', agentType: 'studio:historian', brief: 'What similar problems were solved before? What patterns endured, what failed, and what does precedent suggest here? Generate 2–3 ideas grounded in what has actually worked.' },
  { id: 'designer', agentType: 'studio:designer', brief: 'What interaction models could address this? Think in states and transitions, not screens. Generate 2–3 structurally distinct directions.' },
  { id: 'architect', agentType: 'studio:architect', brief: 'What system structures could address this? Data model shapes, boundaries, integration points. Generate 2–3 ideas from the structure outward.' },
  { id: 'scout', agentType: 'studio:scout', brief: 'What external signal bears on this problem — adjacent products, emerging patterns, market moves? Generate 2–3 ideas informed by signal, filtered against the product\'s positions.' },
  { id: 'marketer', agentType: 'studio:marketer', brief: 'What would be commercially distinctive here — differentiation, monetization fit, timing? Generate 2–3 ideas with a commercial edge.' },
  { id: 'writer', agentType: 'studio:writer', brief: 'What could language do here that structure cannot? Naming, framing, voice as a product mechanism. Generate 2–3 language-led ideas.' },
  { id: 'choreographer', agentType: 'studio:choreographer', brief: 'What could motion and sequencing do here — earned motion, rhythm, transitions as communication? Generate 2–3 motion-led ideas.' },
]

const EVALUATORS = [
  { id: 'engineer', agentType: 'studio:engineer', lens: 'implementation cost, risk, and the simplest build path' },
  { id: 'qa', agentType: 'studio:qa', lens: 'testability, failure modes, and invariant impact' },
  { id: 'heurist', agentType: 'studio:heurist', lens: 'usability risk — mental models, friction, gesture dead-ends' },
]

const IDEAS_SCHEMA = {
  type: 'object',
  required: ['lens', 'ideas'],
  properties: {
    lens: { type: 'string' },
    ideas: { type: 'array', items: { type: 'object', required: ['title', 'summary'], properties: { title: { type: 'string' }, summary: { type: 'string' }, rationale: { type: 'string' } } } },
  },
}

const REDUCE_SCHEMA = {
  type: 'object',
  required: ['ideaCards', 'dissents'],
  properties: {
    ideaCards: { type: 'array', items: { type: 'object', required: ['title', 'summary', 'sourceLenses'], properties: { title: { type: 'string' }, summary: { type: 'string' }, sourceLenses: { type: 'array', items: { type: 'string' } }, recommended: { type: 'boolean' } } }, description: '3–5 reduced idea cards; mark the recommended 2–3' },
    dissents: { type: 'array', items: { type: 'string' }, description: 'named conflicts between lenses — preserved, never averaged away' },
  },
}

const EVAL_SCHEMA = {
  type: 'object',
  required: ['evaluator', 'assessments'],
  properties: {
    evaluator: { type: 'string' },
    assessments: { type: 'array', items: { type: 'object', required: ['idea', 'finding'], properties: { idea: { type: 'string' }, finding: { type: 'string' }, severity: { type: 'string' } } } },
  },
}

const VERDICT_SCHEMA = {
  type: 'object',
  required: ['verdicts'],
  properties: {
    verdicts: { type: 'array', items: { type: 'object', required: ['idea', 'verdict', 'rationale'], properties: { idea: { type: 'string' }, verdict: { type: 'string', enum: ['PROTOTYPE', 'INVESTIGATE', 'DEFER'] }, rationale: { type: 'string' } } } },
  },
}

const GATE_SCHEMA = {
  type: 'object',
  required: ['verdict', 'rationale'],
  properties: {
    verdict: { type: 'string', enum: ['SHIP', 'NO-SHIP'] },
    rationale: { type: 'string' },
    conditions: { type: 'array', items: { type: 'string' } },
  },
}

const SLOP_SCHEMA = {
  type: 'object',
  required: ['markersFired', 'pass'],
  properties: {
    markersFired: { type: 'array', items: { type: 'string' }, description: 'which of the seven slop markers fire on the artifact content, with the evidence' },
    pass: { type: 'boolean' },
  },
}

const shared = `PROBLEM (gate-passed):\n${args.problem}\n\nPROJECT CONTEXT:\n${args.context || 'none provided — apply general product principles'}`

const mode = args.mode || 'auto'
let diverge = args.ideas || null
let evaluation = null
let close = null

if (mode === 'diverge' || mode === 'auto') {
  phase('Diverge')
  const results = await parallel(LENSES.map((l) => () =>
    agent(`You are the ${l.id} lens in a divergent ideation (blind pass — you do not see the other lenses). ${l.brief}\n\n${shared}`,
      { label: `lens:${l.id}`, phase: 'Diverge', agentType: l.agentType, schema: IDEAS_SCHEMA })
  ))
  const failed = LENSES.filter((l, i) => !results[i]).map((l) => l.id)
  if (failed.length) log(`lens node(s) failed: ${failed.join(', ')} — reporting as missing, not synthesizing around the hole`)
  const allIdeas = results.filter(Boolean)

  const strat = await agent(`You are the strategist. Which of these ideas strengthen the product's core value, and which drift toward feature accumulation? Assess each briefly; do not reduce yet.\n\n${shared}\n\nIDEAS:\n${JSON.stringify(allIdeas)}`,
    { label: 'strategist', phase: 'Diverge', agentType: 'studio:strategist' })
  const crit = await agent(`You are the critic. Which of these ideas should be removed or collapsed into one another? Name what is not earned. Do not reduce yet — argue.\n\nIDEAS:\n${JSON.stringify(allIdeas)}\n\nSTRATEGIST ASSESSMENT:\n${strat}`,
    { label: 'critic', phase: 'Diverge', agentType: 'studio:critic' })
  const reduced = await agent(`You are the Creative Director chairing the reduction (reduce node, owner: idea-cards). Reduce to 3–5 idea cards, marking your recommended 2–3. Preserve dissent: where the lenses, strategist, and critic conflict, name the conflict in dissents — never average it away (Consensus Laundering is a named anti-pattern).\n\n${shared}\n\nIDEAS:\n${JSON.stringify(allIdeas)}\n\nSTRATEGIST:\n${strat}\n\nCRITIC:\n${crit}`,
    { label: 'reduce', phase: 'Diverge', agentType: 'studio:cd', schema: REDUCE_SCHEMA })

  const desirability = await agent(`For each surviving idea card, give a synthetic-user desirability read: who wants this, how strongly, and what the adoption objection would be. Signal, not verdict.\n\n${shared}\n\nIDEA CARDS:\n${JSON.stringify(reduced.ideaCards)}`,
    { label: 'desirability', phase: 'Diverge' })

  diverge = { lenses: allIdeas, failedNodes: failed, strategist: strat, critic: crit, reduce: reduced, desirability }
}

const selected = args.selected || (mode === 'auto' && diverge ? diverge.reduce.ideaCards.filter((c) => c.recommended).map((c) => c.title) : null)
if (mode === 'auto' && !args.selected) log('select node (--auto): taking the Creative Director\'s recommended ideas')

if ((mode === 'evaluate' || mode === 'auto') && diverge && selected && selected.length) {
  phase('Evaluate')
  const results = await parallel(EVALUATORS.map((e) => () =>
    agent(`You are the ${e.id} evaluating selected ideas for feasibility (blind pass — you do not see the other evaluators). Assess each idea through the lens of ${e.lens}.\n\n${shared}\n\nSELECTED IDEAS:\n${JSON.stringify(diverge.reduce.ideaCards.filter((c) => selected.includes(c.title)))}`,
      { label: `eval:${e.id}`, phase: 'Evaluate', agentType: e.agentType, schema: EVAL_SCHEMA })
  ))
  const failed = EVALUATORS.filter((e, i) => !results[i]).map((e) => e.id)
  if (failed.length) log(`evaluator node(s) failed: ${failed.join(', ')}`)

  const verdict = await agent(`You are the Distinguished Engineer (verdict node, owner: feasibility-verdicts). Rule PROTOTYPE / INVESTIGATE / DEFER per idea from the evaluator findings. Name what each verdict turns on.\n\nEVALUATIONS:\n${JSON.stringify(results.filter(Boolean))}`,
    { label: 'verdict', phase: 'Evaluate', agentType: 'studio:de', schema: VERDICT_SCHEMA })

  evaluation = { evaluations: results.filter(Boolean), failedNodes: failed, verdict }
}

const picked = args.picked || (mode === 'auto' && evaluation ? evaluation.verdict.verdicts.filter((v) => v.verdict !== 'DEFER').slice(0, 2).map((v) => v.idea) : null)
if (mode === 'auto' && !args.picked && picked && picked.length) log('pick node (--auto): taking the DE-cleared ideas (max 2)')

if ((mode === 'close' || mode === 'auto') && picked && picked.length) {
  phase('Close')
  const gate = await agent(`You are the Creative Director at the ship gate (ship-gate node). Render SHIP / NO-SHIP on these final directions advancing out of ideation: is each framed well enough, reduced enough, and coherent enough to hand to /studio:design? Conditions are allowed.\n\n${shared}\n\nFINAL DIRECTIONS:\n${JSON.stringify(picked)}\n\nFULL REDUCTION:\n${JSON.stringify(diverge ? diverge.reduce : args.ideas)}\n\nFEASIBILITY:\n${JSON.stringify(evaluation ? evaluation.verdict : null)}`,
    { label: 'ship-gate', phase: 'Close', agentType: 'studio:cd', schema: GATE_SCHEMA })

  const slop = await agent(`Run the seven slop markers of /studio:studio-slop against the ideation output (slop gate node): competent-looking emptiness, unowned claims, symmetric hedging, decorative structure, generic vocabulary, unfalsifiable statements, momentum prose. Quote the evidence for any marker that fires.\n\nOUTPUT UNDER TEST:\n${JSON.stringify({ picked, reduce: diverge ? diverge.reduce : args.ideas, gate })}`,
    { label: 'slop-gate', phase: 'Close', schema: SLOP_SCHEMA })

  close = { shipGate: gate, slopGate: slop }
}

return { date: args.date, problem: args.problem, diverge, selected, evaluation, picked, close }
