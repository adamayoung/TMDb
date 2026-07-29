# /deliver — auto mode & async invocation (reference)

Read on demand when `/deliver auto` is invoked, or when queuing an unattended
run. The one safety rule that lives in `SKILL.md` regardless: a **data-loss or
breaking-change plan blocker is always a hard stop, even in auto** — it is
never delegated to the panel. (Note: as of 2026-07, auto mode has not yet been
exercised by a real delivery — validate against this spec on first use. The
panel's two guard rails **have** been exercised: an unlisted `decision` and a
conductor-supplied `recommendation` each throw before any agent spawns,
verified 2026-07-29. The jurors themselves remain unexercised.)

## Auto mode (unattended)

`/deliver auto` runs the **entire** pipeline with **no human interaction** —
every mid-run decision that would normally stop and ask the user is instead
resolved by a **panel of three independent Opus jurors**, and the conductor
acts on their verdict and keeps going through wrap-up.

**The panel.** Run the script at
[`.claude/workflows/deliver-panel.js`](../../../workflows/deliver-panel.js):

```text
Workflow({ scriptPath: '.claude/workflows/deliver-panel.js',
           args: { decision, context, evidence, proceedMeans, stopMeans, artifacts } })
```

(A repo-relative `scriptPath` resolves — verified 2026-07-29. It lives in a file
rather than embedded in this doc because it runs at **six** decision points per
run: an executed script cannot drift between invocations the way one re-authored
from prose can, and drift in a *decision procedure* is a correctness bug, not an
inefficiency. The three review skills embed theirs because each runs once per
invocation.)

It convenes **three independent jurors** — `opus`/`xhigh`, schema-validated,
each returning a free verdict, a confidence, the one deciding fact, and **what
it verified first-hand**. A juror that cannot verify the decisive claim is
instructed to vote `stop`.

*Why not the old Proceed / Stop / Devil's-advocate panel:* two of its three
verdicts were **fixed by role before any evidence was read**, so its "majority"
tallied one free vote and two constants — and the one free vote belonged to the
agent told to attack whichever way looked easiest. Role pre-commitment is useful
for *generating* an argument and invalid for *reaching* a verdict; since nothing
downstream consumed the arguments, the roles are gone and only free verdicts are
tallied.

**Tally — deliberately asymmetric.** `proceed` needs a strict majority of
**live** jurors **and** at least two live jurors; everything else is `stop`. So
3 live → 2 of 3; 2 live → both must agree (a 1-1 is a `stop`); ≤1 live → `stop`,
`degraded: true`. **A dead panel is not a proceed** — Phase 6's *"a dead grader
is not a pass"* (Phase 6) applied here. The asymmetry is justified, not
squeamish: `stop` hands back to a human and is recoverable; `proceed` may not be.

**The conductor may not state a preference.** `args` carries facts only —
`decision`, `context`, `evidence`, `proceedMeans`, `stopMeans`, `artifacts`.
The script **throws** if passed `recommendation`/`preference`/`suggested`, and
**throws** on any `decision` outside the six below. That is what keeps the hard
stops hard *by construction* rather than by prose: an unattended run cannot
invent a new delegable decision.

**Audit trail.** The script returns a preformatted `ledgerLine` plus the full
record (per-juror verdicts, tally, live count, `degraded`). Paste the line into
the ledger for **every** panel convened. Autonomy *with* a full record — an
unattended run must still be reviewable.

**Panel decision points** — **six** (marked **Auto:** in `SKILL.md`):

- Phase 0 — missing acceptance criteria: proceed without a rubric (Phase 6
  becomes a no-op) vs stop.
- Phase 2 — a plan-review blocker that is *not* data-loss/breaking: proceed
  vs stop. (Data-loss/breaking = hard stop, never delegated.)
- Phases 4/5 — Critical/High (or High security) findings persisting after the
  3-iteration cap: note in the PR description and proceed, vs stop. A finding
  that **leaks credentials or opens a clear exploit** is the security analogue
  of the data-loss blocker — hard stop even in auto.
- Phase 9 — an in-diff `make ci` failure that can't converge: open the PR
  with the known-failing check noted, vs stop.
- Phase 10 — a stuck PR: schedule a later re-check (`ScheduleWakeup`) and
  resume watching, vs stop and report. The ready-to-merge gate itself is
  **not** a panel decision: in auto it behaves as the `merge` opt-in — once
  ready, proceed to wrap-up (and merge if `merge` was passed).

**Not delegable — Phase 11.** The recurring-pattern scan used to be a seventh
decision point, with the panel approving proposals and **applying them
directly**. It is now excluded, and the script throws if asked for it: a
`proceed` there would authorise an unattended run to edit and push the repo's
own skill files — including `deliver-panel.js`, the script defining the panel
that authorised it. In auto mode the scan **records every proposal in
`skill-improvement-log.md` as `deferred — raised unattended, needs review` and
applies none**. Phase 11 is post-gate, so the run still completes; the proposals
simply wait for a human. This also means the default auto path pushes nothing
after the gate.

**Write the run file before any `ScheduleWakeup`.** A `phase10-stuck` →
`proceed` schedules a later re-check, which crosses a session boundary — the
ledger does not survive it. Unless the run file is on disk first, the wakeup
arrives with no rubric and no decomposition graph, and Phase 6 hard-stops on the
missing file. See `worktree-lifecycle.md` → *Run state, reconcile & resume*.

## Async / queued invocation

`/deliver` can be queued to run unattended — the worktree isolation, the
ledger, the Phase 1 GC sweep, and auto mode are exactly what an unattended run
needs. Two entry points already do this: a **CCR trigger** (`create_trigger`
with `create_new_session_on_fire`, or the `/schedule` skill) fires a fresh
session whose prompt is `/deliver auto …`, and `integration-failure.yml` runs
a skill **headless** on a runner.

If you queue a `/deliver`, mind two things:

- **Inline the whole plan + acceptance criteria in the trigger prompt.** A
  fresh session has no conversation history, and Phase 0's entry gate
  **requires ACs** — so the plan text and its ACs must travel *in* the prompt,
  or the run stops at the gate immediately.
- **User-scoped MCP may be absent** (`mcp__github__*`, `wiki`). The `gh`
  fallbacks in `/pr` and `/watch-pr` cover GitHub; the wiki step degrades
  silently. A headless GitHub-Actions run has no user MCP at all (it uses
  `git`/`gh`); a CCR-spawned session in your own environment usually keeps
  them.

**Recommendation — don't routinise async *feature* delivery here.** This is a
single-maintainer package with public API surface, where the ready-to-merge
human gate is deliberate — every change is a compatibility call worth a
human's eyes. Async earns its place for the *occasional* away-from-keyboard
run and for the self-healing integration cron (which already opens a PR for
review, never merges) — not as the default path.
