---
name: review-plan
description: Adversarially review the current implementation plan with three independent critic subagents, reconcile their findings into a consensus, and apply the agreed feedback to the plan. Use after drafting a plan (in plan mode or a plan/design doc) and before starting implementation, or whenever the user asks to pressure-test, critique, or harden a plan.
---

# Review Plan

Pressure-test the **current plan** before any code is written. Three independent
adversarial critics review the plan in parallel, each from a distinct lens; their
findings are reconciled into a consensus; and the agreed feedback is folded back
into the plan. The point is to surface the gaps, risks, and over-engineering that
a single pass misses — three skeptics, not one cheerleader.

> A plan that survives three hostile reviewers is worth implementing. A plan that
> nobody challenged is just the first idea that came to mind.

## Agent Behaviour Contract

The point of this skill: do these by default, without being reminded.

1. **Find the plan first; never invent one.** Locate the actual current plan
   (see *Locate the plan*). If there is no plan, say so and stop — do not
   fabricate a plan just to review it.
2. **Three reviewers, three lenses, via one Workflow.** Run the embedded
   `Workflow` script below — it fans out exactly three critic agents in parallel,
   each pinned to the **`opus`** model at **`xhigh`** effort and forced to return
   a schema-validated verdict. Each carries a distinct adversarial mandate. They
   are read-only — reviewers critique, they do not edit the plan or the code.
3. **Adversarial, not agreeable.** Each reviewer assumes the plan is flawed and
   hunts for the strongest objection. A reviewer that finds nothing must say so
   explicitly *and* justify why each common failure mode does not apply.
4. **Ground every finding in the codebase.** Findings must cite real files,
   symbols, or constraints (`file:line`) — not generic plan-review platitudes.
   An objection that cannot be tied to this repository's reality is noise.
5. **Reconcile to a consensus — you adjudicate.** Merge overlapping findings,
   record agreement level, and resolve direct contradictions yourself with a
   stated rationale. Do not just concatenate three reports.
6. **Apply the agreed feedback, then show your work.** Revise the plan in place,
   then report what changed, what was deliberately rejected, and why.

## Locate the plan

Use the first that applies:

1. **An explicit target** the user named — a file path (e.g. a design doc or
   `PLAN.md`), or plan text passed as the skill argument.
2. **The active plan-mode plan** — the most recent plan you presented via
   `ExitPlanMode`, or the plan you are currently drafting in plan mode.
3. **A plan in the conversation** — the most recent structured plan / task
   breakdown you produced (including a `TodoWrite` list framed as the plan).

If none of these exists, stop and tell the user there is no plan to review, and
offer to draft one (e.g. via the `Plan` agent or plan mode) first.

Before reviewing, restate in one or two sentences **what the plan is for** (the
underlying goal/task) — the reviewers need the problem, not just the proposed
solution, to judge whether the solution fits.

## Run the review (Workflow)

The three critics run as a single `Workflow` so that the **`opus`** model and
**`xhigh`** effort are guaranteed per agent (these are first-class `agent()`
options) and each verdict is **schema-validated** rather than free-text. Invoking
this skill is itself the opt-in to call the `Workflow` tool.

Pass the plan and goal as `args` — never inline them into the script body (they
contain arbitrary text). Call `Workflow` with `args: { plan: "<full plan text>",
goal: "<one–two sentence restatement of the underlying task>" }` and the script
below. The three lenses live in the script; only `args` changes per run.

```javascript
export const meta = {
  name: 'review-plan-critics',
  description: 'Three adversarial Opus critics review a plan in parallel',
  phases: [{ title: 'Review', detail: 'three opus/xhigh critics, one per lens' }],
  model: 'opus',
}

const RUBRIC = `Grade each finding by CONSEQUENCE IF THE PLAN SHIPS UNCHANGED, not by your confidence:
- blocker: the plan will fail or do harm as written (goal not met, wrong approach, breaking change, data loss, security hole, irreversible step with no rollback). Implementation must not start until resolved.
- major: can proceed but will likely cause real pain (missing edge case/error path, no test coverage for new behaviour, significant over-engineering or scope creep, portability/concurrency gap, violated project convention).
- minor: a refinement that does not change viability (step ordering, naming, small simplification, docs/DocC reminder).
If unsure whether a finding is real, set "confidence" to low/medium and say so in the claim — do NOT inflate or deflate severity to express doubt.`

const LENSES = [
  {
    key: 'correctness',
    title: 'Correctness & Completeness',
    brief: `Does the plan actually achieve the goal? Hunt for: missing steps, wrong assumptions about how the code works, unhandled edge cases and error paths, ordering/dependency mistakes, missing tests, and "done" criteria that do not actually prove the feature works. This is a Swift package (see CLAUDE.md) — scrutinise Sendable/concurrency gaps, Codable/JSON-fixture coverage of every decoder branch, Linux/Windows portability, and public-API + DocC obligations.`,
  },
  {
    key: 'risk',
    title: 'Risk & Failure Modes (red team)',
    brief: `Assume the plan ships and something breaks. Hunt for: breaking changes to the public API, hidden coupling and side effects, backward-compatibility and migration risk, security/secret exposure, data-loss or irreversible steps, flaky or environment-dependent tests, and the absence of a rollback or verification path. Rank by blast radius.`,
  },
  {
    key: 'simplicity',
    title: 'Simplicity, Scope & Fit',
    brief: `Assume the plan does too much, the wrong way. Hunt for: over-engineering and speculative generality (YAGNI), scope creep beyond the stated goal, reinvention of something the codebase already provides, and divergence from established conventions and patterns in this repo. Propose the simpler alternative the plan should have taken.`,
  },
]

const VERDICT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    lens: { type: 'string' },
    stance: { type: 'string', enum: ['sound', 'sound-with-fixes', 'not-ready'] },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          severity: { type: 'string', enum: ['blocker', 'major', 'minor'] },
          confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
          claim: { type: 'string', description: 'one-line statement of the problem' },
          evidence: { type: 'string', description: 'file:line or a concrete repo constraint' },
          suggestedChange: { type: 'string', description: 'concrete change to make to the plan' },
        },
        required: ['severity', 'confidence', 'claim', 'evidence', 'suggestedChange'],
      },
    },
    cleanNote: { type: 'string', description: 'if a category is clean, why each common failure mode does not apply' },
  },
  required: ['lens', 'stance', 'findings'],
}

const plan = args.plan
const goal = args.goal

phase('Review')
const verdicts = await parallel(LENSES.map((lens) => () =>
  agent(
    `You are an ADVERSARIAL plan reviewer. Assume the plan is flawed and find the strongest objections through the lens of "${lens.title}".\n\n` +
    `${lens.brief}\n\n` +
    `THE GOAL THIS PLAN MUST ACHIEVE:\n${goal}\n\n` +
    `THE PLAN UNDER REVIEW:\n${plan}\n\n` +
    `You are READ-ONLY: read the codebase to verify your claims against real files/symbols, but do not edit anything or run mutating commands. Every finding MUST cite concrete evidence (file:line or a real repo constraint) — generic plan-review platitudes are noise and must be omitted. If your lens is genuinely clean, return an empty findings array and explain in "cleanNote" why each common failure mode does not apply.\n\n` +
    `SEVERITY RUBRIC:\n${RUBRIC}`,
    { label: `critic:${lens.key}`, phase: 'Review', model: 'opus', effort: 'xhigh', schema: VERDICT_SCHEMA }
  ).then((v) => v && { ...v, lens: lens.title })
))

return verdicts.filter(Boolean)
```

The script returns an array of up to three verdicts. If a critic dies, it drops
to `null` and is filtered out — note in your reconciliation if fewer than three
came back. To iterate on the script, edit the file path returned by the
`Workflow` tool and re-invoke with `{ scriptPath }` rather than resending it.

## Severity rubric

Every reviewer grades each finding against the same rubric, so severities are
comparable when you reconcile. Severity is about **consequence if the plan ships
unchanged**, not how confident the reviewer is.

- **`blocker`** — the plan will fail or do harm as written. The goal is not met,
  the approach is wrong, or it introduces a breaking change, data loss, security
  hole, or irreversible step with no rollback. Implementation must not start until
  this is resolved. *Always must-apply.*
- **`major`** — the plan can proceed but will likely cause real pain: a missing
  edge case or error path, absent test coverage for new behaviour, significant
  over-engineering or scope creep, a portability/concurrency gap, or a violated
  project convention. Should be fixed now; cheap to address in the plan, expensive
  to discover mid-implementation.
- **`minor`** — a refinement that improves the plan without changing its
  viability: clearer step ordering, a naming nit, a small simplification, or a
  documentation/DocC reminder. Apply if cheap; defer-able.

When a reviewer is unsure whether something is real, it states the uncertainty in
the finding rather than inflating or deflating the severity — you weigh
confidence during reconciliation.

## Reconcile to consensus

Synthesize the three reports yourself — do not delegate this:

1. **Merge** findings that describe the same concern across reviewers.
2. **Label agreement:** unanimous (3), majority (2), or lone (1).
3. **Decide what to apply.** A finding is **must-apply** if it is a `blocker`, or
   if ≥2 reviewers raise it. A lone `major`/`minor` is applied only if you judge
   it correct on the merits — say so. Reject findings that are wrong, out of
   scope for the stated goal, or contradicted by the code; record the reason.
4. **Adjudicate contradictions.** When reviewers conflict (e.g. "add X" vs "X is
   scope creep"), make the call and state why — usually favouring the smallest
   change that satisfies the goal and the project's conventions.

Present a short consensus table/summary: each finding, its agreement level,
severity, and your decision (apply / reject + reason).

## Apply the feedback

Revise the plan to incorporate every **must-apply** finding and any lone findings
you accepted:

- **Plan in a file** → edit the file in place.
- **Plan-mode plan** → produce the revised plan and re-present it (via
  `ExitPlanMode` when you are ready to exit plan mode, otherwise inline).
- **Plan in the conversation** → restate the corrected plan.

Then close with a brief change log:

- **Applied** — the changes folded in, grouped by the finding that drove them.
- **Rejected** — findings you deliberately did not apply, each with a one-line
  reason.
- **Open questions** — anything the reviewers surfaced that needs a human
  decision before implementation.

Do not silently drop a finding. Every reviewer finding ends up either applied or
explicitly rejected with a reason.
