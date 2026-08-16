// Executor for /studio:prototype — mirrors the ```graph block in SKILL.md (the contract).
// Segments: 'Scope' (context → pm scope validation) and 'Criteria' (post-question: blind
// designer/qa pair → join). The question and readiness human nodes bound the segments;
// the build itself and the Review Surface remain orchestrator tasks (build-task, review nodes).
//
// args: {
//   validate:  string  — what to validate (required)
//   context:   string  — project context incl. the prototype environment declaration
//   artifacts: string  — prior briefs, specs, prototype iterations found at the context node
//   mode:      string  — 'scope' | 'criteria' | 'auto'
//   question:  string  — the confirmed test question (question node), required for 'criteria'
//   date:      string  — run date, stamped by the orchestrator
// }

export const meta = {
  name: 'prototype',
  description: 'Scope a falsifiable test question, then blind build-criteria ∥ test-criteria pair',
  phases: [
    { title: 'Scope', detail: 'PM validates the test question' },
    { title: 'Criteria', detail: 'blind designer/qa pair from the confirmed question' },
  ],
}

const TEXT = { type: 'string' }
const SCOPE_SCHEMA = {
  type: 'object',
  required: ['testQuestion', 'failureMode', 'wellScoped'],
  properties: {
    testQuestion: { type: 'string', description: '"We need to know whether [user] will [behavior] when [context]."' },
    failureMode: { type: 'string', description: 'what a "no" answer means for the design direction' },
    wellScoped: { type: 'boolean', description: 'specific + falsifiable + actionable; false if it cannot be scoped to one question' },
    problems: { type: 'array', items: TEXT },
  },
}
const BUILD_SCHEMA = {
  type: 'object',
  required: ['states', 'flows', 'interactions', 'deferred', 'fidelity'],
  properties: {
    states: { type: 'array', items: TEXT },
    flows: { type: 'array', items: TEXT },
    interactions: { type: 'array', items: TEXT },
    copy: { type: 'array', items: TEXT, description: 'where real copy is required vs. placeholder-sufficient' },
    deferred: { type: 'array', items: TEXT, description: 'what instinct would build but the test question does not require' },
    fidelity: { type: 'object', required: ['level', 'reasoning'], properties: { level: { type: 'string', enum: ['Lo-fi', 'Mid-fi', 'Hi-fi'] }, reasoning: TEXT } },
  },
}
const TEST_SCHEMA = {
  type: 'object',
  required: ['successSignal', 'failureSignal', 'ambiguousSignal', 'sample', 'format'],
  properties: {
    successSignal: TEXT,
    failureSignal: TEXT,
    ambiguousSignal: TEXT,
    sample: { type: 'string', description: 'minimum sessions + validation vs. directional' },
    format: { type: 'string', description: 'minimum test format that produces usable learning' },
  },
}

const shared = `WHAT TO VALIDATE:\n${args.validate}\n\nPROJECT CONTEXT (incl. prototype environment):\n${args.context || 'none provided'}\n\nPRIOR ARTIFACTS:\n${args.artifacts || 'none found'}`
const mode = args.mode || 'auto'
let scope = null

if (mode === 'scope' || mode === 'auto') {
  phase('Scope')
  scope = await agent(`You are the PM validating a prototype's test question before any design work (scope node). Formulate it as: "We need to know whether [specific user] will [specific behavior] when [specific context]." One question per prototype. Name the failure mode — what a "no" means for the direction; if the answer would change nothing, the question is wrong. Set wellScoped false if it cannot be reduced to one specific, falsifiable, actionable question.\n\n${shared}`,
    { label: 'scope', phase: 'Scope', agentType: 'studio:pm', schema: SCOPE_SCHEMA })
  if (mode === 'auto') {
    if (!scope.wellScoped) {
      log('question node (--auto): question cannot be scoped — stopping, a prototype against an unscopeable question is waste')
      return { date: args.date, scope, stopped: 'unscopeable-question' }
    }
    log(`question node (--auto): proceeding with the PM-validated question`)
  }
}

const question = args.question || (scope && scope.testQuestion)
let criteria = null

if ((mode === 'criteria' || mode === 'auto') && question) {
  phase('Criteria')
  const [build, test] = await parallel([
    () => agent(`You are the designer producing build criteria (owner: build-criteria; blind pass — you do not see the test criteria). Define the MINIMUM prototype required to answer the test question: only the states, flows, and interactions the test requires; where copy must be real vs. placeholder; everything instinct would add but the question does not require goes to deferred. Recommend minimum fidelity with reasoning. Name the verification artifacts per the project's prototype environment.\n\n${shared}\n\nCONFIRMED TEST QUESTION:\n${question}`,
      { label: 'build', phase: 'Criteria', agentType: 'studio:designer', schema: BUILD_SCHEMA }),
    () => agent(`You are qa producing test criteria (owner: test-criteria; blind pass — you do not see the build criteria). Define evaluation for the test question: success signal (specific, observable), failure signal, ambiguous signal (what forces a second iteration), minimum sample, and the minimum test format that produces usable learning.\n\n${shared}\n\nCONFIRMED TEST QUESTION:\n${question}`,
      { label: 'test', phase: 'Criteria', agentType: 'studio:qa', schema: TEST_SCHEMA }),
  ])
  const failed = [!build && 'build', !test && 'test'].filter(Boolean)
  if (failed.length) log(`criteria node(s) failed: ${failed.join(', ')} — the criteria join reports the missing half; build-task is blocked until both exist`)
  criteria = { build, test, failedNodes: failed }
}

// build-task, review (/studio:feedback surface), readiness, and routing remain orchestrator
// nodes — the build happens in the project's prototype environment, not in this script.
return { date: args.date, validate: args.validate, scope, question, criteria }
