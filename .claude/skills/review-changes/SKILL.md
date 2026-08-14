---
name: review-changes
description: Review the working-tree changes (vs main) for correctness, concurrency, architecture, testing, and API/doc issues — following .github/CODE_REVIEW.md — and return a severity-graded report. Scales the machinery to the diff size: a single code-reviewer agent for a small change, or a fan-out-and-verify Workflow for a large/multi-unit one. Produces findings; it does not apply fixes (the caller does).
---

# Review Changes

Produce the **pre-PR review** of the current branch's changes against `main`,
following the canonical `.github/CODE_REVIEW.md`. This skill **scales the review
to the size of the change** — a single agent when the diff is small, a parallel
fan-out with adversarial verification when it's large — and returns a
severity-graded report. It does **not** edit code; the caller (e.g. `/deliver`'s
code-review phase, or you) applies the fixes.

## Principles

1. **One source of truth.** Every reviewer — single or fanned-out — follows
   `.github/CODE_REVIEW.md`: the severity rubric, scope, and the mandatory
   adversarial re-evaluation. Don't invent criteria.
2. **Scale to the change.** Don't pay for a fan-out Workflow on a 60-line diff;
   don't review a 12-file multi-model change through one over-stretched context.
3. **Findings only.** Return the report; the caller fixes (test-first) and may
   re-invoke to converge.
4. **Adversarial verification cuts noise.** On the large path, every Critical/High
   finding is independently refuted before it's reported — the strongest lever
   against false positives.

## 0. Gate — skip if there is no reviewable code

Code review exists to review **code** — Swift source, plus the committed
scripts under `.claude/workflows/` (decision infrastructure) and `Scripts/`
(enforcement infrastructure: `check-defaulted-witnesses.py` runs from `make
lint` **and** as its own CI `Lint` step, so a bug there silently weakens a
gate — it shipped as a false green once already, passing on an empty scan).
If the diff touches none of them, there is nothing to review — return
immediately, don't spawn any reviewer.

```bash
git diff --name-only origin/main...HEAD \
  | grep -qE '\.swift$|^\.claude/workflows/|^Scripts/' \
  || echo "no-reviewable-code"
```

If that prints `no-reviewable-code` (e.g. a docs-only, config-only, or
skills-prose change), **stop here** and report "No reviewable code — code
review skipped." Do not run §1–§3. (JSON fixtures under
`Tests/**/Resources/` accompany Swift changes; a fixture-only change with no
`.swift` is rare — note it and let the caller decide.)

**Override — `force-review` in the arguments skips this gate entirely.** The
caller has decided the change carries risk the file extensions don't show.
`/deliver` passes it for a **reflexive delivery** — one that rewrites the
skills, agents or review spec the pipeline itself runs, where the diff is
markdown but the blast radius is the pipeline (#407 shipped three defects
exactly there). Take the §2a single-reviewer path with a brief aimed at the
change's own subject matter: which rule changed, whether anything still
depends on the old wording, and whether the new rule is enforced or merely
stated. Without this the gate and the caller contradict each other and the
skip silently wins.

**If the only reviewable change is a script** (`.claude/workflows/` or
`Scripts/`), take the §2a single-reviewer path with a **script-focused brief**
in place of the Swift lens: input guards and executable `throw`s, schema
shapes, tally / dead-agent handling, and prompt-injection surface (what
untrusted text reaches an agent prompt). For a `Scripts/` checker add the
question that matters most: **can it pass while measuring nothing?** — an empty
scan, a typo'd path, a count compared instead of an explicit set.
`.github/CODE_REVIEW.md`'s severity rubric and adversarial re-evaluation still
apply; its Swift-specific checks don't.

## 1. Scope the change

```bash
git diff --stat origin/main...HEAD
```

Judge size (heuristic, not a rigid count):

- **Small / single-unit** — one cohesive area (a method + its tests + a model +
  docs), a handful of source files, roughly under ~200 changed lines → **§2a**.
- **Large / multi-unit** — several new models/methods/services, or a broad diff →
  **§2b**.

When unsure, prefer **small** — escalate to the fan-out only when the diff is
genuinely broad.

**Risk overrides size.** Take **§2b** however small the diff is when either the
caller states the change is **`full` weight**, or the diff touches a risky
surface — concurrency (actors, `Sendable`, locks, `Task`), networking /
`HTTPClient`, `Decodable` / `CodingKeys`, or new public API. Size decides how
much there is to read; the **risk surface decides how many lenses have to read
it**, and a cohesive one-file concurrency change is the shape whose defects most
reliably survive a single pass (#401, #433, #461 each had one found late, by a
second lens or a second platform). A caller that passes `full` has already made
this judgement from the plan — do not re-derive it from `--stat` and quietly
overrule it.

## 2a. Small change → single agent

Spawn the **`code-reviewer`** agent on `git diff origin/main...HEAD`, telling it
**not to build or run tests** (see *Reviewers don't build* below). It follows
`.github/CODE_REVIEW.md` including its own adversarial self-pass, and returns the
full severity-graded report. Pass that report back to the caller. Done.

### Reviewers don't build

**No reviewer — single or fanned-out — may run `make`, `swift build` or
`swift test`.** Reviewing is a reading task: the reviewer has the diff and the
source, and the caller has already run every gate before invoking this skill.

This is not a style preference. Every target shares one SwiftPM scratch
directory per worktree, so N parallel reviewers each starting a build is N
processes contending on one `.build/.lock` — and if any of them builds docs, the
`SWIFTCI_DOCC` manifest flip *invalidates* the others' build plans, so they redo
each other's work in a cycle rather than merely queueing. Observed once as ~10
`zsh` pipelines pinned at 100% long enough that the user killed them (see
`knowledge/gotchas.md` → *Docs builds need their own scratch path*).

If a finding genuinely cannot be settled without executing something, say so in
the finding and let the caller run it — serially, once.

## 2b. Large change → fan-out + verify Workflow

Invoke the **`Workflow`** tool with the script below and `args: { base: "origin/main" }`.
It fans out one reviewer per dimension (each following the spec, focused on a
single lens), dedups, **adversarially verifies every Critical/High** finding with
an independent skeptic (dropping any that don't survive), and returns the
reconciled findings by severity.

```javascript
export const meta = {
  name: 'review-changes-fanout',
  description: 'Fan-out multi-dimension code review with adversarial verification',
  phases: [
    { title: 'Find', detail: 'one reviewer per dimension, in parallel' },
    { title: 'Verify', detail: 'adversarial skeptic per Critical/High finding' },
  ],
  model: 'opus',
}

const BASE = (args && args.base) || 'origin/main'
const SPEC = '.github/CODE_REVIEW.md'

const DIMENSIONS = [
  { key: 'correctness', focus: 'correctness & safety — logic bugs, behavioural regressions, force unwraps / try!, and input validation at system boundaries' },
  { key: 'concurrency', focus: 'Swift 6 concurrency — async/await, actor isolation, Sendable conformance, no blanket @MainActor, and justified @preconcurrency / @unchecked Sendable' },
  { key: 'architecture', focus: 'architecture — protocol + TMDb-prefixed implementation, service-layer boundaries, new API exposed on TMDbClient with the service constructed in its private init (TMDbFactory vends shared plumbing only — services are not registered there), required model conformances, AND sibling-convention conformance: a newly-added member of an existing family (service method, model, guarded method) must match its siblings — same input validation, same error case, same conformance set / decode strategy — or the divergence is flagged' },
  { key: 'testing', focus: 'tests — both unit and integration present, fixtures exercise EVERY decoder branch, edge cases (boundaries / empty / nil), request-pattern correctness, #require over force-unwrap, AND test-suite convention conformance: a new @Suite matches its siblings (same tags / construction pattern) or the divergence is flagged' },
  { key: 'api-docs', focus: 'model<->API alignment (verify properties/optionality/types/CodingKeys via mcp__tmdb__* and the OpenAPI spec) and public-API docs + DocC catalog + README sync' },
]

const FINDING_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    dimension: { type: 'string' },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          severity: { type: 'string', enum: ['critical', 'high', 'medium', 'low'] },
          file: { type: 'string' },
          line: { type: 'string', description: 'line or range, e.g. "42" or "42-50"; "" if N/A' },
          claim: { type: 'string', description: 'one-line statement of the issue' },
          why: { type: 'string', description: 'why it matters' },
          fix: { type: 'string', description: 'concrete fix' },
        },
        required: ['severity', 'file', 'line', 'claim', 'why', 'fix'],
      },
    },
  },
  required: ['dimension', 'findings'],
}

const VERDICT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    real: { type: 'boolean' },
    reasoning: { type: 'string' },
  },
  required: ['real', 'reasoning'],
}

const reviewPrompt = (d) =>
  `Review the changes on this branch through ONE lens only: ${d.focus}.\n\n` +
  `Get the diff yourself with \`git diff ${BASE}...HEAD\`, and read the surrounding source as needed. ` +
  `DO NOT BUILD OR RUN TESTS — no \`make\`, no \`swift build\`, no \`swift test\`. You are one of several reviewers running in parallel against one shared .build directory; a build here collides with theirs and with the caller's. The caller has already run every gate. Review by reading the diff and the source. ` +
  `Follow the project review guidelines in ${SPEC} — the severity rubric, in/out scope, and the MANDATORY adversarial re-evaluation (drop any finding that doesn't survive). ` +
  `Stay strictly within your lens; other reviewers cover the rest, so don't duplicate them. ` +
  `Report only findings that survive your adversarial pass, each with file, line, what's wrong, why it matters, and a concrete fix. If your lens is clean, return an empty findings array.`

phase('Find')
// A dead agent resolves to `null` THROUGH `.then` — it does not reject — so
// `ok` must be derived here, not in a `.catch` (which would never fire). Without
// this, a died reviewer is indistinguishable from a lens that found nothing, and
// the run reports full coverage while missing a dimension entirely.
const perDim = await parallel(DIMENSIONS.map((d) => () =>
  agent(reviewPrompt(d), {
    label: `review:${d.key}`, phase: 'Find',
    model: 'opus', effort: 'high', agentType: 'code-reviewer', schema: FINDING_SCHEMA,
  }).then((r) => ({
    key: d.key,
    ok: Boolean(r && Array.isArray(r.findings)),
    findings: r && r.findings ? r.findings.map((f) => ({ ...f, dimension: d.key })) : [],
  }))
))

// `parallel()` maps a thrown thunk to `null`, so treat that as a dead dimension
// too rather than letting it vanish from the tally.
const dimResults = DIMENSIONS.map((d, i) => perDim[i] || { key: d.key, ok: false, findings: [] })
const covered = dimResults.filter((r) => r.ok).map((r) => r.key)
const missing = dimResults.filter((r) => !r.ok).map((r) => r.key)
if (missing.length) {
  log(`WARNING: ${missing.length}/${DIMENSIONS.length} dimensions did not report (${missing.join(', ')}) — this review is PARTIAL`)
}

const all = dimResults.flatMap((r) => r.findings)

// Dedup overlapping findings across dimensions (same file:line + severity + gist).
const seen = new Set()
const deduped = all.filter((f) => {
  const key = `${f.file}:${f.line || ''}:${f.severity}:${(f.claim || '').slice(0, 40)}`
  if (seen.has(key)) return false
  seen.add(key)
  return true
})

// Critical/High get adversarially verified; Medium/Low pass through as advisory.
const blocking = deduped.filter((f) => f.severity === 'critical' || f.severity === 'high')
const advisory = deduped.filter((f) => f.severity === 'medium' || f.severity === 'low')

phase('Verify')
const verified = await parallel(blocking.map((f) => () =>
  agent(
    `A reviewer claims a ${f.severity} issue at ${f.file}:${f.line || '?'} —\n"${f.claim}"\nWhy they say it matters: ${f.why}\n\n` +
    `Try to REFUTE it. Read the actual code (\`git diff ${BASE}...HEAD\`, then open the file) and decide whether the issue is REAL and in scope for THIS change, per ${SPEC}. ` +
    `Default to real=false if it is theoretical, already handled elsewhere, out of scope, or a misreading of the diff. Be strict.`,
    {
      label: `verify:${f.file}`, phase: 'Verify',
      model: 'opus', effort: 'high', agentType: 'code-reviewer', schema: VERDICT_SCHEMA,
    }
  ).then((v) => (v && v.real ? f : null))
))

const confirmed = verified.filter(Boolean)

return {
  critical: confirmed.filter((f) => f.severity === 'critical'),
  high: confirmed.filter((f) => f.severity === 'high'),
  medium: advisory.filter((f) => f.severity === 'medium'),
  low: advisory.filter((f) => f.severity === 'low'),
  droppedByVerification: blocking.length - confirmed.length,
  dimensionsCovered: covered,
  dimensionsMissing: missing,
  partial: missing.length > 0,
}
```

To iterate on the script, edit the file path the `Workflow` tool returns and
re-invoke with `{ scriptPath }` rather than resending it.

**If the fan-out is interrupted or dies part-way**, don't discard the run. Each
completed agent's return value is recorded as a `{"type":"result",…}` line in
`journal.jsonl` inside the run's transcript directory (the `Workflow` tool
reports the path), so the findings that landed are recoverable — reduce those
and report as **partial**, naming what is missing. Never re-present a salvaged
run as complete.

## 3. Output

Return the report in the `.github/CODE_REVIEW.md` shape — **Strengths**, **Issues**
grouped Critical / High / Medium / Low (each with `file:line`, what's wrong, why,
fix), and an **Assessment** (Ready to merge? + reason). On the large path, also
note how many Critical/High findings were dropped by adversarial verification
(`droppedByVerification`) — that number is a feature, not a gap. The caller
decides what blocks and applies the fixes.

**On the large path, coverage is mandatory in the report**: list
`dimensionsCovered`, and when `partial` is true name every dimension in
`dimensionsMissing` and say plainly that the review is incomplete. A
large-path report without a coverage line is malformed — treat it as
untrustworthy rather than clean. A missing dimension means *nobody looked*,
which reads identically to *nothing was found* unless you say so; that is the
**False green** family (`knowledge/gotchas.md`), the defect this repo hits most.
(§2a's single-reviewer path has no dimensions, so this does not apply there.)

Arguments: $ARGUMENTS
