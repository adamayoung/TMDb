export const meta = {
  name: 'deliver-panel',
  description: 'Three independent jurors rule on one /deliver auto decision',
  phases: [{ title: 'Rule', detail: 'three independent opus/xhigh jurors, free verdicts' }],
  model: 'opus',
}

// The ONLY decisions `/deliver auto` may delegate. An unlisted point cannot be
// panelled at all — that is what keeps the hard stops hard by construction
// rather than by prose. Phase 11 is deliberately ABSENT: a `proceed` must never
// authorise an unattended run to edit and push the repo's own skill files,
// least of all this script.
const POINTS = {
  'phase0-no-acs':
    'The plan arrived with no acceptance criteria. Proceeding makes Phase 6 (rubric verification) a no-op for the whole delivery — it ships with no exit gate.',
  'phase2-blocker':
    'A /review-plan blocker that is NOT data loss and NOT a breaking change. (Those two never reach this panel.)',
  'phase4-findings':
    'Critical/High code-review findings still open after the 3-iteration cap. Proceeding ships them, noted in the PR description.',
  'phase5-findings':
    'High security findings still open after the 3-iteration cap. (A credential leak or a clear exploit never reaches this panel.)',
  'phase9-ci':
    'An in-diff `make ci` failure that would not converge. Proceeding opens the PR with a known-red required check.',
  'phase10-stuck':
    'The PR is stuck. Proceeding schedules a later re-check and keeps watching instead of handing back.',
}

const VERDICT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    verdict: { type: 'string', enum: ['proceed', 'stop'] },
    confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
    decidingFact: {
      type: 'string',
      description: 'the ONE fact that decided it — not a summary of the evidence',
    },
    verifiedBy: {
      type: 'string',
      description:
        'what YOU checked first-hand (command, file:line, PR check name). "nothing" is an admission and forces a stop vote.',
    },
  },
  required: ['verdict', 'confidence', 'decidingFact', 'verifiedBy'],
}

// `args` can arrive as a JSON string rather than an object (a known harness
// gotcha) — parse before reading any field, or every lookup is `undefined` and
// the jurors rule on an empty decision.
const input = typeof args === 'string' ? JSON.parse(args) : args

if (!input || typeof input !== 'object') {
  throw new Error('deliver-panel: args must be an object (or a JSON string encoding one).')
}
// `hasOwnProperty.call`, not a bare lookup: `POINTS['constructor']` and friends
// walk the prototype chain and would pass a bare truthiness guard.
if (!Object.prototype.hasOwnProperty.call(POINTS, input.decision)) {
  throw new Error(
    `deliver-panel: "${input.decision}" is not a delegable decision point. ` +
      `Auto mode may only panel: ${Object.keys(POINTS).join(', ')}. Anything else is a hard stop — ` +
      `data loss, a breaking change, a credential leak and a clear exploit are never delegated, ` +
      `and Phase 11 skill edits are not delegable at all.`
  )
}
// Independence by construction: there is nowhere to put a preference, so one
// cannot leak into the jurors' reading. A conductor that wants to argue a side
// must do it by supplying better evidence, in public.
for (const banned of ['recommendation', 'preference', 'suggested', 'preferred', 'lean']) {
  if (banned in input) {
    throw new Error(
      `deliver-panel: the conductor must not supply "${banned}". Pass facts only ` +
        `(context, evidence, proceedMeans, stopMeans, artifacts) — a panel fed the conductor's ` +
        `preference is theatre, not deliberation.`
    )
  }
}

const STAKES =
  `DECISION POINT: ${input.decision}\n${POINTS[input.decision]}\n\n` +
  `WHERE THE PIPELINE IS:\n${input.context || '(not supplied)'}\n\n` +
  `EVIDENCE, as supplied by the conductor — a party with an interest in continuing. ` +
  `Weigh the facts; discount the adjectives:\n${input.evidence || '(none supplied)'}\n\n` +
  `WHAT "PROCEED" CONCRETELY MEANS HERE:\n${input.proceedMeans || '(not supplied)'}\n\n` +
  `WHAT "STOP" CONCRETELY MEANS HERE:\n${input.stopMeans || '(not supplied)'}\n\n` +
  `THINGS YOU CAN CHECK FIRST-HAND:\n${(input.artifacts || []).join('\n') || '(none listed — go find them yourself)'}`

const READONLY =
  `You are READ-ONLY: read the repo, the diff, the PR and the CI logs freely (Read/Grep, and Bash for git and gh), ` +
  `but do NOT edit anything and do NOT push. ` +
  `DO NOT BUILD OR RUN TESTS — no \`make\`, no \`swift build\`, no \`swift test\`. Every target in this worktree ` +
  `shares one .build directory; a build here collides with the conductor's and with the other jurors'.`

phase('Rule')
const ruled = await parallel(
  ['j1', 'j2', 'j3'].map((id) => () =>
    agent(
      `You are one of three INDEPENDENT jurors ruling on a single go/no-go decision inside an unattended ` +
        `\`/deliver auto\` run. You have NOT been assigned a side and no one is arguing one at you — your verdict ` +
        `is genuinely free, and the tally is over the three jurors only. Reason from the evidence to the answer.\n\n` +
        `${STAKES}\n\n` +
        `Rule as follows:\n` +
        `1. VERIFY the load-bearing claim yourself before voting. A verdict resting only on what the conductor ` +
        `asserted is worthless — that credulity is the failure this panel exists to prevent. Record what you ` +
        `actually checked in "verifiedBy".\n` +
        `2. If you cannot verify the decisive claim, vote "stop" and say so. In an unattended run, "stop" hands ` +
        `the decision to a human and is recoverable; "proceed" may not be.\n` +
        `3. Name the ONE fact that decided it in "decidingFact". Do not summarise the evidence back.\n\n` +
        `${READONLY}`,
      { label: `juror:${id}`, phase: 'Rule', model: 'opus', effort: 'xhigh', schema: VERDICT_SCHEMA }
    ).then((v) => v && { juror: id, ...v })
  )
)

const jurors = ruled.filter(Boolean)
const forProceed = jurors.filter((v) => v.verdict === 'proceed').length

// Deliberately asymmetric, and a dead panel is NOT a proceed — Phase 6's
// "a dead grader is not a pass" applied to the panel. `proceed` needs a strict
// majority of LIVE jurors and at least two live jurors, so 3 live -> 2 of 3,
// 2 live -> both must agree (a 1-1 is a stop), <=1 live -> stop. The asymmetry
// is justified rather than squeamish: stop is recoverable, proceed may not be.
const outcome =
  jurors.length >= 2 && forProceed > jurors.length / 2 ? 'proceed' : 'stop'
const degraded = jurors.length < 3

if (degraded) {
  log(`WARNING: only ${jurors.length}/3 jurors returned — a dead panel is not a proceed`)
}

const tally = `${forProceed}-${jurors.length - forProceed}`

return {
  outcome,
  tally,
  liveJurors: jurors.length,
  degraded,
  jurors,
  // Preformatted so the audit trail is copy-paste, not re-derived per call.
  ledgerLine:
    `panel ${input.decision}: ${outcome.toUpperCase()} ${tally} ` +
    `(${jurors.length}/3 jurors live${degraded ? ', DEGRADED' : ''}) — ` +
    `${(jurors[0] && jurors[0].decidingFact) || 'no verdict returned'}`,
}
