---
name: fix-pr-checks
description: Fix the currently-failing status checks on the current branch's PR in one sweep — route each failing check to the right diagnosis skill (via a Haiku subagent, escalating to Opus on a repeat failure), apply and verify the fix, commit, and push once — then return a summary. Use standalone when CI is red, or as the check-fixing step invoked by /watch-pr. Repo is adamayoung/TMDb.
---

# Fix PR Checks

Get a pull request's **failing checks** green: for each failing status check,
diagnose the cause, apply and verify a fix, and push. This is a **single sweep**
over the checks failing *right now* — it diagnoses and fixes them, pushes once,
and returns. Waiting on pending checks and deciding whether to sweep again belong
to the caller (you, or `/watch-pr`).

Repo is `adamayoung/TMDb`. GitHub reads use the **GitHub MCP** (`mcp__github__*`);
`gh` is authenticated and used for the blocking CI wait. If an MCP call fails with
**401/403** (PAT expired or missing scope), fall back to the equivalent `gh` command.

## It stands on the diagnosis skills

Don't read CI logs yourself. The analysis is already a capability — delegate it to
a **Haiku subagent** running the matching diagnosis skill (a repeat failure
re-diagnoses on **Opus** — see §2), so raw logs never enter your context and you
get back a `file:line` cause and a concrete fix:

- The **Integration** check (live-API suite from `integration.yml`) →
  `/diagnose-integration-failure`
- Any **CI** check — lint, markdown lint, build, or unit tests from `ci.yml` →
  `/diagnose-ci-failure`

This skill is the **act-on-it** layer: route → fix → verify → commit → push.

## Principles

1. **One sweep, then return.** Handle every check failing at invocation, push
   once, report. Don't loop waiting for the re-run — that convergence is the
   caller's job.
2. **Diagnose via Haiku, escalate a repeat to Opus, fix locally.** Get Cause/Fix
   from the diagnosis skill, then apply it and **verify before claiming it
   fixed** with the delegated build/test skills. First diagnosis of a check runs
   on Haiku; a check that comes back after a fix re-diagnoses on Opus (§2).
3. **Respect the attempt cap.** A check gets at most **3** fix→push attempts
   (tracked in the run ledger). If it still fails on the same root cause, stop
   touching it and report it exhausted — never loop forever.
4. **Failing only.** Act on `fail` checks. `pending` checks are not yours to
   chase — report them and leave waiting to the caller. `claude-review` and other
   neutral checks are non-blocking.
5. **Never fake green.** Don't edit `.github/workflows/*` or CI config to silence a
   check, and don't force-push, without surfacing to the user first.

## 0. Find the PR

Find the open PR for the current branch with `mcp__github__list_pull_requests`
(owner/repo from the `origin` remote, `head: <owner>:<branch>`, `state: open`), or
read a specific one with `mcp__github__pull_request_read` method `get`. Take
`number`/`html_url`/`state`/`head.ref` from the result.

- An explicit PR number in the arguments overrides the current branch.
- No PR for the current branch → stop and tell the user (suggest `/pr`).
- State not `open` → stop and report.

## 1. List the checks

Use `mcp__github__pull_request_read` method `get_check_runs` (owner/repo from
`origin`, `pullNumber: <n>`) — the individual CI/CD check runs for the head
commit. Classify each by `status` + `conclusion`:

- **fix it** (below): `conclusion` is `failure` / `timed_out` / `cancelled` /
  `action_required`.
- **pending** (report, leave for the caller to wait on): `status` is not
  `completed` (`queued` / `in_progress`).
- **ignore**: `conclusion` is `success` / `skipped` / `neutral` (e.g.
  `claude-review`).

If nothing is failing, return immediately (note any pending checks).

## 2. Diagnose each failing check (Haiku first, Opus on a repeat)

For each `fail` check under its attempt cap, spawn a diagnosis subagent — Agent
tool, `subagent_type: general-purpose` — substituting the check name and the
routed skill. Pick the model from the check's ledger history:

- **First attempt** → `model: haiku`.
- **Repeat** (the ledger shows a prior attempt for this check — a fix that
  didn't verify, or the check failed again after the push) → `model: opus`,
  prepending one line of prior-attempt context to the prompt: the previous
  Cause/Fix and why it didn't stick. A misdiagnosis costs a full
  fix→push→CI round trip; don't pay it twice on the same model tier.

```text
The `<CHECK NAME>` check failed on the TMDb PR for branch `<branch>`.

Use the `<SKILL>` skill to diagnose it. The skill locates the failing run,
reads the log, and maps it to a cause and fix.

DO NOT BUILD OR RUN TESTS — no `make`, no `swift build`, no `swift test`, and
do not invoke /build, /test or /integration-test. Diagnose by reading the
failing run's log and the source. The routed skill tells you to reproduce
locally; that step is the caller's, not yours — it owns the single build slot
for this worktree. Reproduction here would collide with it and with any sibling
diagnosis running beside you.

Report back ONLY the skill's three-section result — Summary, Likely cause,
Suggested fix — including the offending `file:line`, plus the `observed:` line
where the routed skill requires one. Do not paste raw logs.
```

> **Section names.** `/diagnose-ci-failure` emits *Summary / Cause / Fix*;
> `/diagnose-integration-failure` emits *Summary / Likely cause / Suggested
> fix* and adds `observed:` for shape-drift causes. Ask for the latter shape —
> it is a superset, so both skills can satisfy it.

### Two or more failing checks → one Workflow

One failing check stays a direct Agent call; a Workflow for a single agent is
pure overhead. At **two or more**, fan out instead — one diagnosis agent per
check, each schema-validated, with `model` set per agent from the ledger
history so the Haiku→Opus escalation survives (a Workflow cannot see that
history on its own — pass it in via `args`).

Run the script below via the `Workflow` tool with
`args: { branch, checks: [{ name, skill, priorAttempt }] }` — `priorAttempt` is
the ledger's record for that check (omit on a first attempt). It is embedded
here, not a file, because it runs **once per invocation** — the same rule that
keeps `/review-plan`'s and `/review-changes`'s scripts embedded, while
`deliver-panel.js` lives in `.claude/workflows/` (it runs six times per run).
Invoking this skill is itself the opt-in to call `Workflow`.

The guards are **executable `throw`s, not instructions**: a malformed payload
must fail at agent zero, never mid-fan-out.

```javascript
export const meta = {
  name: 'fix-pr-checks-diagnose',
  description: 'Diagnose each failing PR check in parallel, one read-only agent per check',
  phases: [{ title: 'Diagnose', detail: 'one agent per failing check' }],
}

// `args` can arrive as a JSON STRING rather than an object (a known harness
// gotcha). Parsing is not optional: iterating a string character-by-character
// once fanned out ~281 agents into a spend limit, so validate the SHAPE before
// spawning anything.
const input = typeof args === 'string' ? JSON.parse(args) : args
if (!input || typeof input !== 'object') {
  throw new Error('fix-pr-checks: args must be an object (or a JSON string encoding one).')
}
if (!Array.isArray(input.checks)) {
  throw new Error(
    `fix-pr-checks: args.checks must be an ARRAY, got ${typeof input.checks}. ` +
      `Refusing to fan out — iterating a non-array here is the ~281-agent failure.`
  )
}
if (!input.checks.length) throw new Error('fix-pr-checks: args.checks is empty — nothing to diagnose.')
// Element shape too, not just the container. `checks: ['CI', 'Integration']` is the
// natural malformed form: it passes an Array.isArray check, then spawns agents whose
// prompts read "the `undefined` check failed" and reports full coverage, because the
// dead-detection compares `undefined === undefined`. A `null` element instead throws
// at the dead-detection — AFTER the agents ran, discarding their work. Both violate
// "fail at agent zero", so validate here.
if (!input.checks.every((c) => c && typeof c === 'object' &&
    typeof c.name === 'string' && c.name && typeof c.skill === 'string' && c.skill)) {
  throw new Error(
    'fix-pr-checks: every entry in args.checks must be an object { name, skill } with ' +
      'non-empty strings. Refusing to fan out on a malformed element.'
  )
}
if (typeof input.branch !== 'string' || !input.branch) {
  throw new Error('fix-pr-checks: args.branch must be a non-empty string.')
}

const NO_BUILD =
  `DO NOT BUILD OR RUN TESTS — no \`make\`, no \`swift build\`, no \`swift test\`, and do not invoke ` +
  `/build, /test or /integration-test. Diagnose by READING the failing run's log and the source. ` +
  `The routed skill tells you to reproduce locally; that step is the caller's, not yours — it owns the ` +
  `single build slot for this worktree. Reproduction here would collide with it and with any sibling ` +
  `diagnosis running beside you.`

const DIAGNOSIS_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    check: { type: 'string' },
    summary: { type: 'string', description: 'one or two sentences on what failed' },
    likelyCause: { type: 'string', description: 'the ranked root cause' },
    suggestedFix: { type: 'string', description: 'the concrete next step' },
    fileLine: { type: 'string', description: 'the offending file:line, or "unknown"' },
    observed: {
      type: 'string',
      description:
        'for an Integration check: the live call made and the shape returned, or "unavailable (headless)"; ' +
        'omit for CI checks. NEVER include a URL, command or header carrying TMDB_API_KEY.',
    },
  },
  required: ['check', 'summary', 'likelyCause', 'suggestedFix'],
}

phase('Diagnose')
const results = await parallel(input.checks.map((c) => () =>
  agent(
    `The \`${c.name}\` check failed on the TMDb PR for branch \`${input.branch}\`.\n\n` +
      `Use the \`${c.skill}\` skill to diagnose it. The skill locates the failing run, reads the log, ` +
      `and maps it to a cause and fix.\n\n` +
      (c.priorAttempt
        ? `THIS IS A REPEAT. The previous attempt did not stick:\n${c.priorAttempt}\n` +
          `Do not re-propose it — find what that diagnosis missed.\n\n`
        : '') +
      `${NO_BUILD}\n\n` +
      `Report ONLY the skill's three-section result. Do not paste raw logs.`,
    {
      label: `diagnose:${c.name}`,
      phase: 'Diagnose',
      // Haiku first; a repeat escalates. The conductor supplies the history —
      // a Workflow cannot see the ledger's per-check attempt counters.
      model: c.priorAttempt ? 'opus' : 'haiku',
      schema: DIAGNOSIS_SCHEMA,
    }
  ).then((r) => r && { ...r, check: c.name })
))

const live = results.filter(Boolean)
const dead = input.checks.filter((c) => !live.some((r) => r.check === c.name)).map((c) => c.name)
if (dead.length) log(`WARNING: no diagnosis returned for ${dead.join(', ')} — treat as undiagnosed, not as clean`)

return { diagnoses: live, undiagnosed: dead }
```

**The fix stays here.** Only diagnosis is delegated; §3's apply → verify →
commit and §4's single batched push run in the conductor, which owns the build
slot and the attempt counters. A check in `undiagnosed` is **not** clean — leave
it and report it.

## 3. Apply, verify, commit

From the returned Cause/Fix:

1. **Apply the fix** to the offending `file:line`.
2. **Verify locally** with the matching delegated skill — `/lint`, `/build`,
   `/test`, or `/integration-test` (they run in Haiku subagents; logs stay out of
   context).
3. **Commit** with a gitmoji message; record the SHA. **Batch the sweep's
   pushes** — commit per fix, but `git push` **once** after all failing checks are
   handled (§4), so the re-run covers everything in one CI cycle.
4. Increment that check's attempt counter in the ledger.

If the diagnosis is ambiguous or the fix is risky, don't guess — leave the check,
note it for the user, and move on.

## 4. Push once, then finish

After all failing checks are handled, if you committed any fixes, `git push` once
(it re-triggers CI — expected). Every commit fires the pre-commit `make lint`
hook; fix lint before retrying.

## Return: sweep summary

Report, concisely:

- **Fixed** — check name → cause (`file:line`) → commit SHA.
- **Exhausted** — checks at the 3-attempt cap still failing on the same root
  cause; stop and hand to the user.
- **Skipped/ambiguous** — failing checks you intentionally left (risky/unclear),
  with why.
- **Pending** — checks still in progress, left for the caller to wait on.
- Whether you pushed (and thus re-triggered CI) so the caller can decide whether
  to sweep again.

Arguments: $ARGUMENTS
