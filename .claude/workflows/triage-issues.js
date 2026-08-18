export const meta = {
  name: 'triage-issues',
  description: 'Re-verify each Backlog issue against current main and return a triage verdict',
  phases: [{ title: 'Triage', detail: 'one read-only agent per issue, verdict + evidence' }],
  model: 'opus',
}

// `args` can arrive as a JSON string rather than an object — a known harness
// gotcha, and the one that once turned a fan-out over a string into a
// char-by-char loop spawning ~281 agents. Parse before reading any field, and
// assert the shape of the array before it reaches the fan-out.
const input = typeof args === 'string' ? JSON.parse(args) : args

if (!input || typeof input !== 'object' || Array.isArray(input)) {
  throw new Error('triage-issues: args must be an object (or a JSON string encoding one).')
}
if (!Array.isArray(input.issues)) {
  throw new Error(
    `triage-issues: args.issues must be an array, got ${typeof input.issues}. ` +
      'A stringified array reaches the script as one string and fans out per character.'
  )
}
if (input.issues.length === 0) {
  return { verdicts: [], note: 'no Backlog issues to triage' }
}
// Every element must be a plain issue number. A malformed element is a caller
// bug worth failing on, not something to silently skip — a skipped issue is
// indistinguishable from a triaged-and-kept one in the final report.
for (const [i, n] of input.issues.entries()) {
  if (!Number.isInteger(n) || n <= 0) {
    throw new Error(`triage-issues: args.issues[${i}] is not a positive integer (got ${JSON.stringify(n)}).`)
  }
}

// Date.now()/new Date() throw inside workflow scripts (they would break resume),
// so the caller stamps the run.
const HEAD = String(input.head || '').trim()
const TODAY = String(input.today || '').trim()
if (!HEAD || !TODAY) {
  throw new Error('triage-issues: args.head (commit sha) and args.today (YYYY-MM-DD) are both required.')
}

const REPO = 'adamayoung/TMDb'

const VERDICT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    issue: { type: 'integer' },
    exit: {
      type: 'string',
      enum: ['ready', 'blocked', 'wontfix', 'split'],
      description:
        'ready = every claim re-verified, fix approach determined, no unmerged dependency. ' +
        'blocked = sound but needs a human decision. ' +
        'wontfix = mechanically dead (see wontfixBasis). ' +
        'split = sound but too coarse to be one unit of work.',
    },
    priority: { type: 'string', enum: ['P0', 'P1', 'P2'] },
    size: { type: 'string', enum: ['XS', 'S', 'M', 'L', 'XL'] },
    oneLine: { type: 'string', description: 'the issue restated in one line, as it is TODAY' },
    decisionNeeded: {
      type: 'string',
      description:
        'blocked only: ONE sentence naming the choice a human must make. Empty for every other exit. ' +
        'If you cannot name the choice in one sentence, it is not blocked — it is unanalysed.',
    },
    wontfixBasis: {
      type: 'string',
      enum: ['', 'no-longer-reproduces', 'superseded', 'duplicate'],
      description:
        'wontfix only, and ONLY these three. "not worth doing" is a judgement, not a basis — ' +
        'route that to blocked with the case stated in decisionNeeded.',
    },
    staleClaims: {
      type: 'array',
      description: 'assertions in the issue body that are now false or misnumbered, with current file:line',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          claim: { type: 'string' },
          current: { type: 'string' },
        },
        required: ['claim', 'current'],
      },
    },
    dependsOn: {
      type: 'array',
      description: 'issue numbers that must land FIRST. Sequencing only — not "related to".',
      items: { type: 'integer' },
    },
    contendsWith: {
      type: 'array',
      description:
        'issue numbers whose fix touches the same files. Not a dependency — a merge-conflict warning.',
      items: { type: 'integer' },
    },
    filesTouched: {
      type: 'array',
      description: 'repo-relative paths the fix would change, for cross-issue contention detection',
      items: { type: 'string' },
    },
    newContext: {
      type: 'string',
      description: 'what a picker-upper needs that the issue body does not say. Empty if nothing.',
    },
    verifiedBy: {
      type: 'string',
      description:
        'what YOU checked first-hand — commands run, files opened, live API calls. ' +
        '"read the issue body" is an admission and forces exit=blocked.',
    },
  },
  required: [
    'issue',
    'exit',
    'priority',
    'size',
    'oneLine',
    'decisionNeeded',
    'wontfixBasis',
    'staleClaims',
    'dependsOn',
    'contendsWith',
    'filesTouched',
    'newContext',
    'verifiedBy',
  ],
}

// The digest is computed HERE, from the structured verdict — never asked of the
// agent. An earlier draft made it a schema field described as "a short stable
// fingerprint… two runs that verify the same facts must produce the same
// digest", which is an instruction to an LLM to behave like a hash function.
// Two runs would word the same findings differently, the digests would differ,
// and the skill's "comment only when the digest changed" rule would fire every
// run — reproducing exactly the comment-spam it exists to prevent, with nothing
// measuring the failure.
//
// Only decision-bearing fields go in. Prose (`oneLine`, `decisionNeeded`,
// `newContext`) and agent-authored path lists are excluded: they drift in
// wording without the findings changing, which is the same defect by a longer
// route.
function evidenceDigest(v) {
  const material = [
    v.exit,
    v.priority,
    v.size,
    v.wontfixBasis,
    [...v.dependsOn].sort((a, b) => a - b).join(','),
    [...v.staleClaims].map((c) => c.current).sort().join('|'),
  ].join('~')

  // FNV-1a, 32-bit. Not cryptographic — it only has to be stable and cheap,
  // and `Math.imul` keeps the multiply in 32-bit range.
  let h = 0x811c9dc5
  for (let i = 0; i < material.length; i++) {
    h ^= material.charCodeAt(i)
    h = Math.imul(h, 0x01000193) >>> 0
  }
  return h.toString(16).padStart(8, '0')
}

// The marker the skill writes at the foot of a triage comment and parses on the
// NEXT run to decide whether an agent needs to run at all. Assembled here so the
// written form and the parsed form cannot drift apart: an unparseable marker
// degrades into "re-triage everything", which is the expensive failure rather
// than a loud one.
//
// It carries the ordering-relevant facts, not just the digest, so a skipped
// issue can still take its place in the run-list without an agent having read it.
function buildMarker(v, digest) {
  const deps = [...v.dependsOn].sort((a, b) => a - b).join(',')
  return `<!-- triaged: ${HEAD} | ${digest} | ${v.exit} | ${v.priority} | ${v.size} | deps=${deps} -->`
}

const RUBRIC = `
PRIORITY
  P0 — data loss, credential exposure, or blocks a release that is currently open.
  P1 — a correctness defect, or a latent break with a SCHEDULED trigger (a known
       future event fires it, e.g. the next toolchain bump).
  P2 — hygiene: cleanups, CI ergonomics, docs, and latent breaks with no trigger.

SIZE
  XS — one file, under an hour, no test churn beyond one case.
  S  — one unit of work, a handful of files, obvious tests.
  M  — a model/decoder change with fixtures, or a mechanical port across several files.
  L  — multi-item, or spans several units that want separate PRs.
  XL — cannot be started without a plan first. If you pick XL, say so in newContext.

  Size the work the issue's OUTCOME requires, never the analysis needed to reach
  it. A 'blocked' item is sized by what its decision unlocks: if the answer is
  "close this" or "record a line", that is XS however much reasoning the decision
  took. Sizing the thinking inflates every judgement-heavy item and makes the
  board unplannable.

READY TEST — an issue is 'ready' ONLY if ALL FOUR hold:
  1. Every load-bearing claim re-verified against ${HEAD}.
  2. The fix APPROACH is determined — not "choose between options A/B/C".
  3. No dependency still unmerged.
  4. File:line references refreshed to current values.
  Fail any one and it is NOT ready. A P0 that needs a decision is 'blocked',
  not 'ready' — priority does not override the test.
`.trim()

// `parallel`, not `pipeline`: this is a single stage, where the two are
// equivalent, and every sibling workflow in this repo uses `parallel`. The
// agents are tagged with `opts.phase` rather than a global `phase()` call, which
// is what keeps the progress grouping correct when thunks interleave.
phase('Triage')

const results = await parallel(
  input.issues.map((number) => () =>
    agent(
    `Triage issue #${number} in ${REPO} against \`main\` @ ${HEAD}. Today is ${TODAY}.

Read it first: \`gh issue view ${number} --repo ${REPO} --comments\`.

Your job is to establish what is TRUE TODAY, not to summarise the issue. The body
was written against an older tree and this repo moves fast — line numbers drift,
mechanisms get replaced wholesale, and dependencies land. Treat every claim as a
hypothesis to check.

METHOD
- Find when it was filed, then read what changed since:
  \`git log --oneline --since=<filed-date>\` and \`git log -S'<symbol>' -- <path>\`.
- Open every file the issue cites. Confirm or correct each line reference.
- If the issue makes a claim about the live TMDb API, re-check it with the
  \`mcp__tmdb__*\` tools rather than trusting the body.
- Check whether an ADR under knowledge/decisions/ now RULES on the issue's open
  question — several do, and it can turn a "needs a decision" into a determined
  fix (or the reverse).
- Look for the issue's own scope being wrong: it may name one instance of a
  pattern that actually has several. Sweep for siblings.

${RUBRIC}

WONTFIX IS NARROW. Close only on mechanical evidence — no-longer-reproduces,
superseded by merged work, or duplicate. "Not worth the churn" is a judgement
call: route it to 'blocked' with the case in decisionNeeded and let a human take
it. A wrongly-ready issue costs someone twenty minutes; a wrongly-closed one
disappears.

CONSTRAINTS
- READ-ONLY. Do not edit files, do not comment on or close anything, do not touch
  the project board. You report; the caller writes.
- Do not run builds, tests, or \`make\`.
- filesTouched should list what the FIX would change, so the caller can detect
  two issues colliding in the same file.`,
      { label: `triage:#${number}`, phase: 'Triage', schema: VERDICT_SCHEMA }
    )
  )
)

// A verdict's `issue` is agent-supplied, so it is a claim, not an identity. An
// echoed-wrong or duplicated number would otherwise sail through while the real
// issue landed in `untriaged` — and the skill would then write fields against an
// issue nobody triaged. Discard rather than trust, and say what was discarded.
const requested = new Set(input.issues)
const seen = new Set()
const verdicts = []
const discarded = []

for (const v of results.filter(Boolean)) {
  if (!requested.has(v.issue)) {
    discarded.push(`#${v.issue} (not in the requested set)`)
    continue
  }
  if (seen.has(v.issue)) {
    discarded.push(`#${v.issue} (duplicate verdict)`)
    continue
  }
  seen.add(v.issue)
  const digest = evidenceDigest(v)
  verdicts.push({ ...v, evidenceDigest: digest, marker: buildMarker(v, digest) })
}

if (discarded.length > 0) {
  log(`Discarded ${discarded.length} malformed verdict(s): ${discarded.join(', ')}`)
}

const untriaged = input.issues.filter((n) => !seen.has(n))
if (untriaged.length > 0) {
  log(
    `WARNING: ${untriaged.length} of ${input.issues.length} issues returned no usable verdict ` +
      `(${untriaged.map((n) => `#${n}`).join(', ')}) — they are UNTRIAGED, not clean.`
  )
}

return {
  head: HEAD,
  today: TODAY,
  requested: input.issues.length,
  triaged: verdicts.length,
  untriaged,
  discarded,
  verdicts,
}
