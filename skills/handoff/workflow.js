// Executor for /studio:handoff — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Audit' (paired blind fan-out → gaps-join), 'Package' (post-gaps: data/UAT pair →
// critic → spec → accessibility → slop → CD/PM gates). The gaps and signoff human nodes are
// the segment boundaries; --auto documents gaps and records blockers instead of pausing.
//
// args: {
//   feature:   string  — the feature or component (required)
//   artifacts: string  — loaded prototype artifacts, design-system context, prior specs/findings
//   context:   string  — project context summary
//   mode:      string  — 'audit' | 'package' | 'auto'
//   prior:     object  — audit-segment result, required for 'package'
//   gapNotes:  string  — the human's gap-closure/scope ruling (gaps node), when one was made
//   date:      string  — run date, stamped by the orchestrator
// }
// Returns the package data; the orchestrator renders the state-inventory HTML (emit node).

export const meta = {
  name: 'handoff',
  description: 'Prototype → production package: audits, reduction, build spec, structural gates',
  phases: [
    { title: 'Audit', detail: 'blind state-inventory + flow-completeness pair' },
    { title: 'Package', detail: 'data/UAT pair, critic reduction, spec, accessibility, gates' },
  ],
}

const TEXT = { type: 'string' }
const AUDIT_SCHEMA = {
  type: 'object',
  required: ['items', 'undesigned'],
  properties: {
    items: { type: 'array', items: { type: 'object', required: ['name', 'inPrototype', 'status'], properties: { name: TEXT, inPrototype: { type: 'boolean' }, status: { type: 'string', enum: ['designed', 'needs design', 'intentionally omitted'] }, note: TEXT } } },
    undesigned: { type: 'array', items: TEXT },
  },
}
const REDUCE_SCHEMA = {
  type: 'object',
  required: ['removals', 'dissents'],
  properties: { removals: { type: 'array', items: { type: 'object', required: ['item', 'rationale'], properties: { item: TEXT, rationale: TEXT } } }, dissents: { type: 'array', items: TEXT } },
}
const GATE_SCHEMA = {
  type: 'object',
  required: ['pass', 'blockers'],
  properties: { pass: { type: 'boolean' }, blockers: { type: 'array', items: TEXT }, notes: TEXT },
}
const SLOP_SCHEMA = { type: 'object', required: ['markersFired', 'pass'], properties: { markersFired: { type: 'array', items: TEXT }, pass: { type: 'boolean' } } }

const shared = `FEATURE:\n${args.feature}\n\nARTIFACTS (prototype, design system, prior specs/findings):\n${args.artifacts || 'none loaded — flag this'}\n\nPROJECT CONTEXT:\n${args.context || 'none provided'}`

const mode = args.mode || 'auto'
let audit = args.prior || null

if (mode === 'audit' || mode === 'auto') {
  phase('Audit')
  const [states, flows] = await parallel([
    () => agent(`You are the designer running the state inventory audit (owner: state-inventory; blind pass — you do not see the flow audit). Enumerate every state this feature must exist in for production: default, loading, empty, populated, active/selected/focused, hover/press, disabled, error (by type), success, partial, overflow. For each: name, was it in the prototype (Y/N), status (designed / needs design / intentionally omitted with reason). Flag every undesigned state.\n\n${shared}`,
      { label: 'states', phase: 'Audit', agentType: 'studio:designer', schema: AUDIT_SCHEMA }),
    () => agent(`You are the journey-mapper running the flow completeness audit (owner: flow-inventory; blind pass — you do not see the state audit). Enumerate every user flow: primary, all entry paths, exit paths, error recovery, edge paths (first use, returning, no data, maximum data), abandonment. For each: name, in prototype (Y/N), status. Flag every undesigned flow.\n\n${shared}`,
      { label: 'flows', phase: 'Audit', agentType: 'studio:journey-mapper', schema: AUDIT_SCHEMA }),
  ])
  const failed = [!states && 'states', !flows && 'flows'].filter(Boolean)
  if (failed.length) log(`audit node(s) failed: ${failed.join(', ')} — the gaps-join reports the missing audit, it does not proceed silently`)
  audit = { states, flows, failedNodes: failed }
  const gaps = [...((states && states.undesigned) || []), ...((flows && flows.undesigned) || [])]
  if (gaps.length && mode === 'auto') log(`gaps node (--auto): ${gaps.length} undesigned item(s) documented as known gaps, not invented`)
}

let pkg = null
if ((mode === 'package' || mode === 'auto') && audit) {
  phase('Package')
  const gapContext = args.gapNotes ? `\n\nGAP RULING (human):\n${args.gapNotes}` : '\n\nGAPS: documented as known gaps.'

  const [data, uat] = await parallel([
    () => agent(`You are the writer producing synthetic data (owner: synthetic-data; blind pass — you do not see the UAT work). For each state with content: 2–3 realistic variants, at least one boundary-testing variant (shortest/longest plausible), realistic distributions, the product's voice. Flag runtime-dynamic content.\n\n${shared}\n\nSTATE INVENTORY:\n${JSON.stringify(audit.states)}${gapContext}`,
      { label: 'data', phase: 'Package', agentType: 'studio:writer' }),
    () => agent(`You are qa writing UAT scenarios (owner: uat-scenarios; blind pass — you do not see the synthetic-data work). Each scenario: Given / When / Then / Pass if / Fail if — observable, no subjective judgment. Cover all primary flows, interactive transitions, error states with recovery, one edge case per major flow, and one VoiceOver scenario per interactive element.\n\n${shared}\n\nSTATE INVENTORY:\n${JSON.stringify(audit.states)}\n\nFLOW INVENTORY:\n${JSON.stringify(audit.flows)}${gapContext}`,
      { label: 'uat', phase: 'Package', agentType: 'studio:qa' }),
  ])
  const failed = [!data && 'data', !uat && 'uat'].filter(Boolean)
  if (failed.length) log(`package node(s) failed: ${failed.join(', ')}`)

  const critic = await agent(`You are the critic pressure-testing the handoff package before it is specified (the reduction function). Which enumerated states are not earned, which flows duplicate one another, which UAT scenarios test the same thing twice? Remove with one-sentence rationale each. Preserve disagreement: record an auditor's standing inclusion argument as a dissent rather than silently keeping or cutting.\n\nPACKAGE:\n${JSON.stringify({ audit, data, uat })}`,
    { label: 'critic', phase: 'Package', agentType: 'studio:critic', schema: REDUCE_SCHEMA })

  const spec = await agent(`You are the specifier in Build Spec mode (owner: build-spec). Produce the complete engineering handoff document — sufficient to implement without asking a question: overview, all states, all flows, component mapping (flag DS/production token mismatches both directions), dimensions, typography, colors (with dark mode), interactions, motion (with reduce-motion), accessibility, known gaps, implementation notes. Apply the critic's removals.\n\n${shared}\n\nPACKAGE:\n${JSON.stringify({ audit, data, uat })}\n\nCRITIC REDUCTIONS:\n${JSON.stringify(critic)}${gapContext}`,
    { label: 'spec', phase: 'Package', agentType: 'studio:specifier' })

  const accessibility = await agent(`You are the accessibility specialist verifying the build spec's accessibility section and UAT accessibility scenarios: VoiceOver labels, traits, reading order for every interactive element. Findings are spec revisions, not notes — state each precisely.\n\nSPEC:\n${spec}\n\nUAT:\n${uat}`,
    { label: 'accessibility', phase: 'Package', agentType: 'studio:accessibility' })

  const slop = await agent(`Run the seven slop markers of /studio:studio-slop against the handoff package (slop gate node). Quote evidence for any marker that fires.\n\nPACKAGE:\n${JSON.stringify({ spec, uat })}`,
    { label: 'slop-gate', phase: 'Package', schema: SLOP_SCHEMA })

  const cdGate = await agent(`You are the Creative Director at the cd-gate. Confirm: all states designed and specified; the spec requires no engineering judgment; no known gap is an undeferred blocker. pass:false lists blockers.\n\nSPEC:\n${spec}\n\nACCESSIBILITY FINDINGS:\n${accessibility}\n\nCRITIC DISSENTS:\n${JSON.stringify(critic.dissents)}`,
    { label: 'cd-gate', phase: 'Package', agentType: 'studio:cd', schema: GATE_SCHEMA })
  const pmGate = await agent(`You are the PM at the pm-gate. Confirm: UAT scenarios cover the brief's success conditions; known gaps are acceptable for this release; engineering can begin. pass:false lists blockers.\n\nUAT:\n${uat}\n\nKNOWN GAPS:\n${JSON.stringify({ states: audit.states && audit.states.undesigned, flows: audit.flows && audit.flows.undesigned })}\n\nCONTEXT:\n${args.context || 'none'}`,
    { label: 'pm-gate', phase: 'Package', agentType: 'studio:pm', schema: GATE_SCHEMA })

  const blockers = [...(cdGate.pass ? [] : cdGate.blockers), ...(pmGate.pass ? [] : pmGate.blockers)]
  if (blockers.length && mode === 'auto') log(`signoff node (--auto): ${blockers.length} blocker(s) recorded, not waived`)

  pkg = { data, uat, failedNodes: failed, critic, spec, accessibility, slopGate: slop, cdGate, pmGate, blockers }
}

return { date: args.date, feature: args.feature, audit, package: pkg }
