// Executor for /studio:critique — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Round 1' (context → fan-out ×9 → synthesis → threshold) and 'Debate'
// (debate → final). The debate-call human node separates them; --auto runs both.
//
// args: {
//   artifact:  string   — artifact description + file paths (required)
//   context:   string   — project context summary: governing principle, invariants, brand
//   phase:     string   — 'exploratory' | 'in progress' | 'production'
//   mode:      string   — 'round1' (segment 1 only) | 'debate' (segment 2) | 'auto' (both)
//   round1:    object   — prior segment result, required when mode === 'debate'
//   date:      string   — run date, stamped by the orchestrator (no Date.now in workflows)
// }
// Returns structured findings; the orchestrator renders the critique-report HTML (emit node).

export const meta = {
  name: 'critique',
  description: 'Nine-discipline silent critique with conditional debate round',
  phases: [
    { title: 'Round 1', detail: 'blind fan-out of nine disciplines, then synthesis' },
    { title: 'Debate', detail: 'each discipline responds to Round 1 findings' },
  ],
}

const PHASE_FRAMING = (phase) =>
  `The design phase is ${phase}. Calibrate accordingly: exploratory = structural/conceptual findings, ` +
  `deprioritize craft precision; in progress = full findings at design standard; production = full findings ` +
  `at shipping standard, and name the cost-of-change implication for any finding that requires a breaking redesign.`

// Node ids match the graph block. Blind fan-out: each brief carries shared inputs only.
const DISCIPLINES = [
  { id: 'critic', agentType: 'studio:critic', round1: 'Apply the Critic discipline. Evaluate against the project\'s governing principle and ethos. For every element ask: is this necessary? Is this in its simplest correct form? List everything that should be removed or simplified, with a one-sentence rationale each. If nothing should be removed, say so.', debate: 'Where another discipline recommends improving something you flagged for removal, state your position clearly — removal or improvement are different paths and only one is correct. Where another finding reveals something you missed, acknowledge and extend it.' },
  { id: 'heurist', agentType: 'studio:heurist', round1: 'Apply the Heurist discipline. Evaluate against canonical heuristics (Nielsen, Tognazzini), Apple HIG, and AI interaction guidelines where relevant. Name broken mental models, invisible friction, gesture dead-ends, and trust-eroding AI behavior. Rate each finding P0–P3. If no violations, say so.', debate: 'Where a craft finding has a usability consequence the other specialist didn\'t name, name it. Where another finding contradicts your usability assessment, state why your read holds or where you concede.' },
  { id: 'accessibility', agentType: 'studio:accessibility', round1: 'Apply the Accessibility discipline. Evaluate against WCAG 2.1 AA. Name specific contrast ratios and thresholds, verify 44pt tap targets, check screen reader labels and reduce-motion alternatives. Name the WCAG criterion for each finding. If no issues, say so.', debate: 'Where a proposed improvement would create or resolve an accessibility issue, name it. WCAG criteria are not negotiable — state that clearly where another discipline\'s fix would introduce a violation.' },
  { id: 'visual', agentType: 'studio:visual-designer', round1: 'Apply the Visual Designer discipline. Evaluate spacing, proportion, alignment, and visual weight distribution. State current values and target values — no directional language. Give the structural reason for each correction in one sentence. If no issues, say so.', debate: 'Where a typographic, material, or motion finding has a spacing or proportion consequence, name the specific value impact. Where another finding proposes a change that introduces visual imbalance, state it with the specific value.' },
  { id: 'typesetter', agentType: 'studio:typesetter', round1: 'Apply the Typesetter discipline. Evaluate the type system: scale, hierarchy, weight, rhythm. Name the structural role each text level serves and whether it serves it. Use token names where the design system defines them. If the artifact contains no typography, note it briefly.', debate: 'Where a visual, material, or copy finding intersects with the type system, name the structural consequence. Where another discipline proposes a fix that would break the type hierarchy, state why.' },
  { id: 'materialist', agentType: 'studio:materialist', round1: 'Apply the Materialist discipline. Name the material language of the interface first, then evaluate surface decisions against that model. Name incoherence (mixed models) separately from surface corrections. If no surface qualities to evaluate, note it briefly.', debate: 'Where another discipline\'s finding implies a material decision that hasn\'t been named, name it. Where a proposed change would introduce material incoherence, state what model it violates.' },
  { id: 'writer', agentType: 'studio:writer', round1: 'Apply the Writer discipline. Evaluate all language: microcopy, labels, empty states, system messages, VoiceOver strings. Identify copy that is vague, punishing, off-voice, or inconsistent. Quote the specific copy and state what is wrong. If no language present, note it briefly.', debate: 'Where the Critic flags removal of an element that carries necessary language, make the case for whether the language can move or must go with the element. Where another finding would affect copy, name the copy consequence.' },
  { id: 'choreographer', agentType: 'studio:choreographer', round1: 'Apply the Choreographer discipline. Evaluate motion and transitions: timing, easing, sequencing, rhythm. For each animation, name whether it is earned or gratuitous. If no motion present, note it briefly.', debate: 'Where a structural or material change would affect motion, name the motion consequence. Where a proposed removal would eliminate a transition doing necessary communicative work, state what that work is.' },
  { id: 'mark-maker', agentType: 'studio:mark-maker', round1: 'Apply the Mark Maker discipline. Evaluate any marks present — wordmarks, symbols, icons, monograms — against reduction, legibility at minimum scale, and coherence with the brand system. If no marks present, note it briefly.', debate: 'Where another finding would affect a mark\'s legibility, coherence, or brand integrity, state it precisely. Where a proposed change would improve or harm a mark\'s reduction, name it.' },
]

const FINDINGS_SCHEMA = {
  type: 'object',
  required: ['discipline', 'substantive', 'findings'],
  properties: {
    discipline: { type: 'string' },
    substantive: { type: 'boolean', description: 'false when the discipline has nothing to flag' },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        required: ['element', 'finding'],
        properties: {
          element: { type: 'string' },
          finding: { type: 'string' },
          severity: { type: 'string', description: 'P0–P3 where the discipline rates severity' },
          recommendsRemoval: { type: 'boolean' },
        },
      },
    },
  },
}

const SYNTHESIS_SCHEMA = {
  type: 'object',
  required: ['convergences', 'signals', 'triage', 'dissents'],
  properties: {
    convergences: { type: 'array', items: { type: 'string' }, description: 'elements flagged by 2+ disciplines, from different angles' },
    signals: {
      type: 'object',
      required: ['volume', 'convergence', 'criticTension'],
      properties: {
        volume: { type: 'boolean', description: 'distinct substantive findings exceed 8' },
        convergence: { type: 'boolean' },
        criticTension: { type: 'boolean', description: 'Critic recommends removal of something another discipline recommends improving' },
      },
    },
    triage: {
      type: 'object',
      required: ['addressNow', 'beforeShip', 'consider'],
      properties: {
        addressNow: { type: 'array', items: { type: 'string' } },
        beforeShip: { type: 'array', items: { type: 'string' } },
        consider: { type: 'array', items: { type: 'string' } },
      },
    },
    dissents: { type: 'array', items: { type: 'string' }, description: 'named inter-discipline conflicts — preserved, never averaged away' },
  },
}

const FINAL_SCHEMA = {
  type: 'object',
  required: ['hardened', 'changed', 'unresolvedTensions', 'triage'],
  properties: {
    hardened: { type: 'array', items: { type: 'string' } },
    changed: { type: 'array', items: { type: 'string' } },
    unresolvedTensions: { type: 'array', items: { type: 'string' }, description: 'each as a decision question the team must answer' },
    triage: {
      type: 'object',
      required: ['addressNow', 'beforeShip', 'consider', 'decide'],
      properties: {
        addressNow: { type: 'array', items: { type: 'string' } },
        beforeShip: { type: 'array', items: { type: 'string' } },
        consider: { type: 'array', items: { type: 'string' } },
        decide: { type: 'array', items: { type: 'string' } },
      },
    },
  },
}

const shared = `ARTIFACT:\n${args.artifact}\n\nPROJECT CONTEXT:\n${args.context || 'none provided — apply general design principles'}\n\n${PHASE_FRAMING(args.phase || 'in progress')}`

const runFan = (round, round1Findings) =>
  parallel(DISCIPLINES.map((d) => () =>
    agent(
      round === 1
        ? `You are the ${d.id} in a design critique (Round 1 — silent pass). ${d.round1}\n\n${shared}`
        : `You are the ${d.id} in a design critique (Round 2 — debate). You have the Round 1 findings from all nine disciplines. Respond to the other findings: agree, push back, or build. ${d.debate} Keep each response to two sentences.\n\n${shared}\n\nROUND 1 FINDINGS (all disciplines):\n${JSON.stringify(round1Findings)}`,
      { label: `${round === 1 ? 'round1' : 'debate'}:${d.id}`, phase: round === 1 ? 'Round 1' : 'Debate', agentType: d.agentType, schema: FINDINGS_SCHEMA }
    )
  ))

const mode = args.mode || 'auto'
let round1 = args.round1 || null
let synthesis = args.synthesis || null

if (mode === 'round1' || mode === 'auto') {
  phase('Round 1')
  const results = await runFan(1)
  const failed = DISCIPLINES.filter((d, i) => !results[i]).map((d) => d.id)
  if (failed.length) log(`node(s) failed: ${failed.join(', ')} — reporting as missing, not synthesizing around the hole`)
  round1 = { findings: results.filter(Boolean), failedNodes: failed }

  synthesis = await agent(
    `You are synthesizing Round 1 of a nine-discipline design critique (synthesis join). Preserve disagreement — where disciplines conflict, name the conflict as a dissent; never average it away (Consensus Laundering is a named anti-pattern). Assess the tension threshold signals exactly: volume (substantive findings > 8), convergence (2+ disciplines flag the same element), criticTension (Critic recommends removal of something another discipline recommends improving).\n\n${shared}\n\nFINDINGS:\n${JSON.stringify(round1.findings)}${failed.length ? `\n\nMISSING DISCIPLINES (agent failure — report, do not infer their findings): ${failed.join(', ')}` : ''}`,
    { label: 'synthesis', phase: 'Round 1', schema: SYNTHESIS_SCHEMA }
  )
}

const thresholdMet = synthesis && (synthesis.signals.volume || synthesis.signals.convergence || synthesis.signals.criticTension)

let debate = null
let final = null
if ((mode === 'debate' || (mode === 'auto' && thresholdMet)) && round1) {
  phase('Debate')
  const results = await runFan(2, { findings: round1.findings, synthesis })
  const failed = DISCIPLINES.filter((d, i) => !results[i]).map((d) => d.id)
  if (failed.length) log(`debate node(s) failed: ${failed.join(', ')}`)
  debate = { responses: results.filter(Boolean), failedNodes: failed }

  final = await agent(
    `You are producing the final synthesis of a two-round design critique (final node). Track each significant finding across both rounds: what hardened (survived challenge), what changed (revised or reversed), and what remains genuinely unresolved. Unresolved tensions are decisions the team must make — phrase each as a one-sentence decision question. Preserve named dissent.\n\nROUND 1:\n${JSON.stringify(round1.findings)}\n\nROUND 1 SYNTHESIS:\n${JSON.stringify(synthesis)}\n\nDEBATE RESPONSES:\n${JSON.stringify(debate.responses)}`,
    { label: 'final', phase: 'Debate', schema: FINAL_SCHEMA }
  )
}

return { date: args.date, phase: args.phase, round1, synthesis, thresholdMet: !!thresholdMet, debate, final }
