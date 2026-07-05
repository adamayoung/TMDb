# /deliver — auto mode & async invocation (reference)

Read on demand when `/deliver auto` is invoked, or when queuing an unattended
run. The one safety rule that lives in `SKILL.md` regardless: a **data-loss or
breaking-change plan blocker is always a hard stop, even in auto** — it is
never delegated to the panel. (Note: as of 2026-07, auto mode has not yet been
exercised by a real delivery — validate against this spec on first use.)

## Auto mode (unattended)

`/deliver auto` runs the **entire** pipeline with **no human interaction** —
every mid-run decision that would normally stop and ask the user is instead
resolved by an **adversarial panel** of three Opus subagents, and the
conductor acts on the majority verdict and keeps going through wrap-up.

**The panel.** At each decision point, convene three subagents in parallel,
each given the same context (the decision, the evidence, the options):

- **Proceed** — argues the case for continuing the pipeline.
- **Stop** — argues the case for halting and handing back to the user.
- **Devil's advocate** — attacks whichever way looks easiest, so the other two
  can't converge on a comfortable answer unchallenged.

Each returns a one-line verdict (`proceed` / `stop`) and its reasoning.
**Majority wins.** `proceed` resumes the pipeline; `stop` ends the run with
the usual status summary.

**Audit trail.** For **every** panel convened, write a ledger entry recording:
the **decision point**, the **three subagent verdicts**, the **majority
outcome**, and a **one-line rationale**. Autonomy *with* a full record — an
unattended run must still be reviewable.

**Panel decision points** (marked **Auto:** in `SKILL.md`):

- Phase 0 — missing acceptance criteria: proceed without a rubric (Phase 7
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
- Phase 11 — recurring-pattern-scan proposals: the panel reviews **each**
  proposal and applies approved ones directly (edit the skill, commit — an
  exceptional post-gate push, so the re-watch rule applies); rejected
  proposals are still recorded in `skill-improvement-log.md` with the panel's
  rationale.

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
