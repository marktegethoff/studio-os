// Executor for /studio:design — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Context' (brief gate → designer options), 'Craft' (post-direction: blind
// Phase A fan-out → writer → visual join → heurist with one bounded designer return),
// 'Finish' (post-prototype-gate: accessibility → specifier → slop gate → ship gate).
// The direction and proto-gate human nodes separate them; --auto runs all with logged defaults.
//
// args: {
//   problem:     string  — the design problem (required)
//   context:     string  — project context + brief summary + prior decisions
//   designPhase: string  — 'exploratory' | 'in-progress' | 'refinement' (the phase router)
//   commercial:  boolean — run the marketer (if:commercial)
//   surfaceWork: boolean — the outcome has new surface work (if:surface-work)
//   crafts:      array   — applicable Phase A crafts, subset of ['typesetter','choreographer','materialist']
//   newCopy:     boolean — the surface introduces new copy (if:new-copy)
//   mode:        string  — 'context' | 'craft' | 'finish' | 'auto'
//   prior:       object  — prior segment result (required for 'craft' and 'finish')
//   direction:   string  — the human-chosen option (direction node), required for 'craft'
//   date:        string  — run date, stamped by the orchestrator
// }
// Returns structured results; the orchestrator renders the phase-appropriate HTML (emit node).

export const meta = {
  name: 'design',
  description: 'Full design pass: framing chain, designer options, blind craft fan-out, heurist, gates',
  phases: [
    { title: 'Context', detail: 'philosophy through designer options' },
    { title: 'Craft', detail: 'blind Phase A fan-out, writer, visual join, heurist' },
    { title: 'Finish', detail: 'accessibility, specifier, slop gate, cd ship gate' },
  ],
}

const TEXT = { type: 'string' }
const FINDINGS = { type: 'object', required: ['discipline', 'findings'], properties: { discipline: TEXT, findings: { type: 'array', items: TEXT } } }

const OPTIONS_SCHEMA = {
  type: 'object',
  required: ['interactionModel', 'options', 'recommended'],
  properties: {
    interactionModel: { type: 'string', description: 'states and transitions' },
    visualHierarchy: TEXT,
    options: { type: 'array', maxItems: 3, items: { type: 'object', required: ['name', 'summary'], properties: { name: TEXT, summary: TEXT } } },
    recommended: { type: 'string', description: 'name of the recommended option + one-sentence rationale' },
  },
}

const HEURIST_SCHEMA = {
  type: 'object',
  required: ['findings', 'returnToDesigner'],
  properties: {
    findings: { type: 'array', items: { type: 'object', required: ['finding', 'severity'], properties: { finding: TEXT, severity: { type: 'string', description: 'P0–P3' } } } },
    returnToDesigner: { type: 'boolean', description: 'true only if findings require revising the interaction model' },
    mustChange: { type: 'string', description: 'precisely what must change, when returning' },
  },
}

const GATE_SCHEMA = {
  type: 'object',
  required: ['verdict', 'rationale', 'dissentLedger'],
  properties: {
    verdict: { type: 'string', enum: ['SHIP', 'NO-SHIP'] },
    rationale: TEXT,
    defects: { type: 'array', items: TEXT },
    dissentLedger: { type: 'array', items: TEXT, description: 'overruled dissents from the run: heurist concerns, critic removals, sub-team conflicts' },
  },
}

const SLOP_SCHEMA = {
  type: 'object',
  required: ['markersFired', 'pass'],
  properties: { markersFired: { type: 'array', items: TEXT }, pass: { type: 'boolean' } },
}

const shared = `DESIGN PROBLEM:\n${args.problem}\n\nPROJECT CONTEXT (brief, invariants, prior decisions):\n${args.context || 'none provided — apply general design principles'}\n\nDESIGN PHASE: ${args.designPhase || 'in-progress'}`
const mode = args.mode || 'auto'
const exploratory = (args.designPhase || 'in-progress') === 'exploratory'
let ctx = args.prior && args.prior.ctx ? args.prior.ctx : null
let craft = args.prior && args.prior.craft ? args.prior.craft : null

if (mode === 'context' || mode === 'auto') {
  phase('Context')
  const historian = await agent(`You are the historian in a design pass. What similar systems existed for this problem? What patterns endured, what failed, what should be avoided?\n\n${shared}`,
    { label: 'historian', phase: 'Context', agentType: 'studio:historian' })
  const strategist = await agent(`You are the strategist. Does solving this strengthen the product's core value or drift toward feature accumulation? Verdict and reasoning.\n\n${shared}\n\nPRECEDENT:\n${historian}`,
    { label: 'strategist', phase: 'Context', agentType: 'studio:strategist' })
  const marketer = args.commercial
    ? await agent(`You are the marketer. Commercial read on this design problem: differentiation, monetization fit, timing. If your read conflicts with the strategist's, name the tension — do not resolve it silently.\n\n${shared}\n\nSTRATEGIST:\n${strategist}`,
        { label: 'marketer', phase: 'Context', agentType: 'studio:marketer' })
    : null
  const architect = await agent(`You are the architect. Data model, system boundaries, scalability, integration points for this problem.${marketer ? ' Commercial concerns are input, not a hard gate.' : ''}\n\n${shared}\n\nSTRATEGIST:\n${strategist}${marketer ? `\n\nMARKETER:\n${marketer}` : ''}`,
    { label: 'architect', phase: 'Context', agentType: 'studio:architect' })
  const critic = await agent(`You are the critic. Before generation: what should NOT be built here? Remove unnecessary scope, simplify flows, eliminate decoration. Name each removal with a one-sentence rationale.\n\n${shared}\n\nARCHITECT:\n${architect}`,
    { label: 'critic', phase: 'Context', agentType: 'studio:critic' })
  const designer = await agent(`You are the designer (owner: interaction-model). Produce the interaction model (states + transitions), visual hierarchy, and no more than 3 layout options with one recommended. Apply the decision hierarchy; novelty is never a factor.\n\n${shared}\n\nPRECEDENT:\n${historian}\n\nSTRATEGIST:\n${strategist}\n\nARCHITECT:\n${architect}\n\nCRITIC (removals):\n${critic}`,
    { label: 'designer', phase: 'Context', agentType: 'studio:designer', schema: OPTIONS_SCHEMA })
  ctx = { historian, strategist, marketer, architect, critic, designer }
}

let direction = args.direction || null
if (!direction && mode === 'auto' && ctx) {
  direction = ctx.designer.recommended
  log(`direction node (--auto): adopting the Designer's recommended option — ${direction}`)
}

if ((mode === 'craft' || mode === 'auto') && ctx && !exploratory) {
  phase('Craft')
  const CRAFTS = [
    { id: 'typesetter', agentType: 'studio:typesetter', brief: 'Type as architecture: scale, hierarchy, weight, rhythm — and string length constraints for any copy.' },
    { id: 'choreographer', agentType: 'studio:choreographer', brief: 'Motion: what is earned, timing, easing, sequencing.' },
    { id: 'materialist', agentType: 'studio:materialist', brief: 'Surface: depth, elevation, shadow, material coherence.' },
  ].filter((c) => (args.crafts || ['typesetter', 'choreographer', 'materialist']).includes(c.id))

  let phaseA = []
  if (args.surfaceWork !== false && CRAFTS.length) {
    const results = await parallel(CRAFTS.map((c) => () =>
      agent(`You are the ${c.id} refining a chosen design direction (blind pass — you do not see the other craft agents). ${c.brief}\n\n${shared}\n\nCHOSEN DIRECTION: ${direction}\n\nDESIGNER OUTPUT:\n${JSON.stringify(ctx.designer)}`,
        { label: `craft:${c.id}`, phase: 'Craft', agentType: c.agentType, schema: FINDINGS })
    ))
    const failed = CRAFTS.filter((c, i) => !results[i]).map((c) => c.id)
    if (failed.length) log(`craft node(s) failed: ${failed.join(', ')} — reporting as missing at the visual join`)
    phaseA = results.filter(Boolean)
  }

  const typesetterOut = phaseA.find((r) => r.discipline && r.discipline.toLowerCase().includes('typesetter'))
  const writer = args.newCopy
    ? await agent(`You are the writer. The surface introduces new copy: labels, empty states, system messages, VoiceOver strings. Write it.${typesetterOut ? ' Respect the typesetter\'s string length constraints (provided).' : ''}\n\n${shared}\n\nCHOSEN DIRECTION: ${direction}\n\nDESIGNER OUTPUT:\n${JSON.stringify(ctx.designer)}${typesetterOut ? `\n\nTYPESETTER CONSTRAINTS:\n${JSON.stringify(typesetterOut)}` : ''}`,
        { label: 'writer', phase: 'Craft', agentType: 'studio:writer', schema: FINDINGS })
    : null

  const visual = (phaseA.length || writer)
    ? await agent(`You are the visual designer (the visual join — runs last, after all sub-team agents). Evaluate spacing, proportion, alignment, and visual weight across the full surface using all sub-team outputs. Prescribe specific corrections with current → target values. Preserve any conflicts between sub-team outputs as named dissents.\n\n${shared}\n\nCHOSEN DIRECTION: ${direction}\n\nSUB-TEAM OUTPUTS:\n${JSON.stringify({ phaseA, writer })}`,
        { label: 'visual', phase: 'Craft', agentType: 'studio:visual-designer', schema: FINDINGS })
    : null

  let heurist = await agent(`You are the heurist. Evaluate the refined interaction model: broken mental models, invisible friction, gesture dead-ends, AI trust concerns. Set returnToDesigner true ONLY if the interaction model itself must change.\n\n${shared}\n\nDESIGN STATE:\n${JSON.stringify({ direction, designer: ctx.designer, phaseA, writer, visual })}`,
    { label: 'heurist', phase: 'Craft', agentType: 'studio:heurist', schema: HEURIST_SCHEMA })

  let revision = null
  if (heurist.returnToDesigner) {
    // heurist -> designer, loop max:1 — one bounded return, then proceed regardless.
    log(`heurist → designer return (bounded, max 1): ${heurist.mustChange}`)
    revision = await agent(`You are the designer revising the interaction model once, per the heurist's findings. Change precisely what must change and nothing else.\n\nMUST CHANGE:\n${heurist.mustChange}\n\nCURRENT MODEL:\n${JSON.stringify(ctx.designer)}\n\nHEURIST FINDINGS:\n${JSON.stringify(heurist.findings)}`,
      { label: 'designer-revision', phase: 'Craft', agentType: 'studio:designer', schema: OPTIONS_SCHEMA })
    heurist = { ...heurist, resolvedByRevision: true }
  }
  craft = { phaseA, writer, visual, heurist, revision }
}

let finish = null
if ((mode === 'finish' || mode === 'auto') && ctx && !exploratory) {
  phase('Finish')
  if (mode === 'auto') log('proto-gate node (--auto): prototype built/verified on the auto branch; no production source writes this run')

  const model = (craft && craft.revision) || ctx.designer
  const accessibility = await agent(`You are the accessibility specialist. Audit the design at production weight: WCAG 2.1 AA contrast (name ratios and thresholds), 44pt targets, screen reader labels, reduce-motion alternatives, dynamic type. Name the WCAG criterion per finding.\n\n${shared}\n\nDESIGN STATE:\n${JSON.stringify({ model, craft })}`,
    { label: 'accessibility', phase: 'Finish', agentType: 'studio:accessibility', schema: FINDINGS })
  const specifier = await agent(`You are the specifier (owner: spec). Produce the complete engineering handoff spec: all component states, dimensions and spacing as token names, typography tokens, color tokens with dark-mode variants, motion parameters, VoiceOver labels/traits/reading order.\n\n${shared}\n\nDESIGN STATE:\n${JSON.stringify({ model, craft, accessibility })}`,
    { label: 'specifier', phase: 'Finish', agentType: 'studio:specifier' })

  const slop = await agent(`Run the seven slop markers of /studio:studio-slop against the artifact content (slop gate node). Quote evidence for any marker that fires.\n\nARTIFACT:\n${JSON.stringify({ model, specifier })}`,
    { label: 'slop-gate', phase: 'Finish', schema: SLOP_SCHEMA })

  const ship = await agent(`You are the Creative Director at the ship gate (the sixth function). Render SHIP / NO-SHIP on the finished design. The run's dissents are provided — heurist concerns, critic removals, sub-team conflicts; read them before ruling and record the dissent ledger. A NO-SHIP names the defects and the owning discipline.\n\n${shared}\n\nFULL RUN STATE:\n${JSON.stringify({ model, craft, accessibility, specifier, slop })}`,
    { label: 'ship-gate', phase: 'Finish', agentType: 'studio:cd', schema: GATE_SCHEMA })

  finish = { accessibility, specifier, slopGate: slop, shipGate: ship }
}

return { date: args.date, designPhase: args.designPhase, ctx, direction, craft, finish }
