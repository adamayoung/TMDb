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

## 0. Gate — skip if there are no Swift changes

Code review exists to review **Swift**. If the diff touches no Swift source,
there is nothing to review — return immediately, don't spawn any reviewer.

```bash
git diff --name-only origin/main...HEAD | grep -qE '\.swift$' || echo "no-swift"
```

If that prints `no-swift` (no `*.swift` files changed — e.g. a docs-only,
config-only, or `.claude/` change), **stop here** and report "No Swift changes —
code review skipped." Do not run §1–§3. (JSON fixtures under
`Tests/**/Resources/` accompany Swift changes; a fixture-only change with no
`.swift` is rare — note it and let the caller decide.)

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

## 2a. Small change → single agent

Spawn the **`code-reviewer`** agent on `git diff origin/main...HEAD`. It follows
`.github/CODE_REVIEW.md` including its own adversarial self-pass, and returns the
full severity-graded report. Pass that report back to the caller. Done.

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
  { key: 'architecture', focus: 'architecture — protocol + TMDb-prefixed implementation, service-layer boundaries, new API exposed on TMDbClient and wired in TMDbFactory, required model conformances, AND sibling-convention conformance: a newly-added member of an existing family (service method, model, guarded method) must match its siblings — same input validation, same error case, same conformance set / decode strategy — or the divergence is flagged' },
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
  `Follow the project review guidelines in ${SPEC} — the severity rubric, in/out scope, and the MANDATORY adversarial re-evaluation (drop any finding that doesn't survive). ` +
  `Stay strictly within your lens; other reviewers cover the rest, so don't duplicate them. ` +
  `Report only findings that survive your adversarial pass, each with file, line, what's wrong, why it matters, and a concrete fix. If your lens is clean, return an empty findings array.`

phase('Find')
const perDim = await parallel(DIMENSIONS.map((d) => () =>
  agent(reviewPrompt(d), {
    label: `review:${d.key}`, phase: 'Find',
    model: 'opus', effort: 'high', agentType: 'code-reviewer', schema: FINDING_SCHEMA,
  }).then((r) => (r && r.findings ? r.findings.map((f) => ({ ...f, dimension: d.key })) : []))
))

const all = perDim.filter(Boolean).flat()

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
  dimensionsCovered: DIMENSIONS.map((d) => d.key),
}
```

To iterate on the script, edit the file path the `Workflow` tool returns and
re-invoke with `{ scriptPath }` rather than resending it.

## 3. Output

Return the report in the `.github/CODE_REVIEW.md` shape — **Strengths**, **Issues**
grouped Critical / High / Medium / Low (each with `file:line`, what's wrong, why,
fix), and an **Assessment** (Ready to merge? + reason). On the large path, also
note the dimensions covered and how many Critical/High findings were dropped by
adversarial verification (`droppedByVerification`) — that number is a feature, not
a gap. The caller decides what blocks and applies the fixes.

Arguments: $ARGUMENTS
