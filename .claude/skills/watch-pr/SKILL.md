---
name: watch-pr
description: Watch the current branch's PR — reply to and resolve review threads, fix failing checks, and optionally merge when ready
---

# Watch PR

Watch the open pull request for the current branch: handle review conversations,
fix failing status checks, and — when asked — merge once everything is green.
Repo is `adamayoung/TMDb`; `gh` is authenticated.

**Mode** — check the arguments passed to this skill (shown at the end). If they
include `merge` (e.g. `/watch-pr merge` or "merge when ready"), enable
**merge-when-ready**; otherwise run in **watch-only** mode.

**Run in the background.** Watching blocks on CI for minutes at a time, so run the
watch as a background task — the user can keep interacting while it runs, and is
pinged when the PR needs attention or is ready. Don't tie up the foreground on a
wait loop.

## 0. Find the PR

```bash
gh pr view --json number,url,state,headRefName,mergeStateStatus,statusCheckRollup,reviewDecision
```

- No PR for the current branch → stop and tell the user (suggest `/pr`).
- State not `OPEN` → stop and report.

Keep a **run ledger** in your working notes: resolved thread IDs, a topic
signature per handled thread (`path:line` + short gist), and a fix-attempt
counter per failing check. Use it to avoid repeating work (see Loop Guard).

## 1. Watch loop

Repeat the pass below until the PR is **ready** (§3) or **stuck** (§2).

### 1a. Review threads

Delegate the thread sweep to **`/review-pr-threads`** — it resolves the
currently-unresolved threads in one pass (assess → fix+verify / reply-only →
reply → resolve), reusing **this run's ledger** so a topic you already fixed isn't
re-edited, and returns a summary (fixed w/ SHAs, replied-only, left-for-user,
counts, whether it pushed).

It is a **single sweep** by design — the across-push convergence is *this* loop's
job: fold its summary into the ledger, and if it pushed fixes, the next pass picks
up any fresh threads the `claude-review` bot raises (gated to Critical/High). Do
not duplicate its per-thread logic here.

### 1b. Status checks

Delegate failing-check fixing to **`/fix-pr-checks`** — it routes each failing
check to the right diagnosis skill (`/diagnose-ci-failure` or
`/diagnose-integration-failure`) via a Haiku subagent, applies and verifies the
fix, commits, pushes once, and returns a summary (fixed w/ SHAs, exhausted,
skipped, pending, whether it pushed). It shares **this run's ledger**, so the
3-attempt cap per check is honoured across passes. Fold its summary into the
ledger; if it pushed, the next pass re-checks.

**Waiting stays here** (orchestration, not the fix primitive): if checks are
`pending` and nothing is failing, block efficiently with `gh pr checks --watch`
rather than polling, then loop. If `/fix-pr-checks` reports a check **exhausted**,
stop and report it per the Loop Guard.

### 1c. Failing checks not caused by this PR (usually a flaky integration test)

`/fix-pr-checks` assumes the fix belongs on **this** branch. That is wrong when
the failing check — most often a **live integration test** — is broken or flaky
**independently of this PR's diff**. Patching it onto the feature branch would
muddy the PR's scope and leave the test broken for everyone else. Triage before
fixing here:

1. **Is the failing test in this PR's diff?**
   `gh pr diff <number> --name-only` — if the failing test's file is **not** in
   that list, this PR did not cause it.

2. **Transient or deterministic?** Re-run the failed jobs once
   (`gh run rerun <run-id> --failed`) and watch. Passes on re-run → a transient
   live-API flake; note it and continue. Fails again **and** not in this PR's diff
   → a **pre-existing** problem (e.g. a brittle live-data assertion).

3. **A pre-existing failure is a `main` problem — hand it to
   `/fix-integration-failures`**, which fixes it on its own branch off `main`,
   runs `make ci`, and opens/merges a PR (never on this feature branch). Tell the
   user you're opening a **second** PR to unblock this one; if they'd rather you
   stop, report and stop. Once that fix is on `main`, bring this PR's branch up to
   date (`gh pr update-branch <number>`) and re-watch — the check now passes.

## 2. Loop guard (do not get stuck)

- **Thread dedup is `/review-pr-threads`' job** — it shares this ledger, so it
  won't reprocess a handled thread or re-edit a topic already fixed this run (it
  replies with the earlier SHA and resolves). Keep passing it the same ledger.
- **Check-fix attempts are `/fix-pr-checks`' job** — it shares this ledger and
  caps each check at **3** fix→push attempts. When it reports a check
  **exhausted**, **stop** and report it to the user — never loop forever.
- The `claude-review` bot re-reviews on every push (`synchronize`), so your fixes
  trigger fresh reviews — this is expected, not new work to fear. By policy it now
  posts inline threads **only for Critical/High** findings (Medium/Low live in its
  summary comment, which is advisory — do not turn summary bullets into code
  changes). A converging PR should see each push's inline batch shrink; if the same
  severity-gated topic reappears across pushes, treat it as noise per the rule
  above (reply with the earlier SHA, resolve, don't re-edit).
- **Re-sweep after every push — "ready" is only true of the current tip.** Any push
  to the branch (a check fix, *and* a caller's post-gate commit such as a `/deliver`
  retro or skill edit) re-triggers `claude-review`, which can post a fresh
  Critical/High thread that **blocks the merge** (`required_review_thread_resolution`).
  Never declare ready off a thread/check snapshot taken *before* the latest push:
  after the last push settles, run one more full pass (thread sweep + check
  re-confirm) before §3. A single early "0 unresolved" check is not a standing
  guarantee.
- End the loop when a full pass resolves no new threads and has no actionable
  check failures. Hard backstop: ~10 passes, then report and stop.
- Waiting: use `gh pr checks --watch` for in-flight CI. When only waiting on a
  human to review, pause and resume later with `ScheduleWakeup` (a few minutes
  while CI is active; longer when idle). This skill also composes with `/loop`
  if the user prefers harness-driven cadence.

## 3. Ready / merge

The PR is **ready** when every review thread is resolved, no check is failing or
pending, AND the branch is **up to date with `main`** (the `main` ruleset requires
it before merge).

**Verify check completeness explicitly — a running check is not a pass.** "No check
failing" is **not** the same as "all checks passed": a check still `IN_PROGRESS` /
`QUEUED` has **no conclusion yet**, so a filter like `select(.conclusion!="SUCCESS")`
or "are there any failures?" reports it as *absent*, not *pending* — reading as green
when it isn't. Confirm readiness positively: **every required check has
`status == COMPLETED` and `conclusion == SUCCESS` on the current tip.** Concretely,
assert `[.statusCheckRollup[] | select(.status!="COMPLETED")]` is **empty** before
calling it green, and **dedup stale duplicate entries** (the rollup keeps a row per
run, so an earlier tip's passed "Build and Test" can sit alongside the current tip's
`IN_PROGRESS` one — key on the latest run per check name). Do **not** infer green
from a `gh pr checks --watch` exit alone; re-read the rollup. And when
`mergeStateStatus` is `BLOCKED`, **rule out a pending required check first** (it is
the common cause) before attributing the block to a review/policy rule like
code-owner review. (Bit #361: a still-running "Build and Test" was misread as green
and `BLOCKED` was wrongly pinned on code-owner review.)

**Rebase before declaring ready, never after.** `main` advances while you watch
(other PRs merge), leaving the branch `BEHIND`. The moment the PR is otherwise
green, bring it up to date — `gh pr update-branch <number>` (a merge of `main`; no
force-push) — and wait for the re-triggered CI to go green again *before* you call
it ready. "Ready" must mean "mergeable right now": never surface a `BEHIND` PR as
ready and leave the user waiting on a rebase + re-run. Update **once** at the ready
point, not eagerly on every `main` advance — each update re-runs the full ~4–7 min
CI matrix.

- **Watch-only**: report "PR is ready" with a short summary (threads handled,
  checks green, branch up to date) and stop — wait for the user's explicit
  go-ahead before merging.
- **Merge-when-ready**: on ready, merge and clean up, then report the result:

  ```bash
  gh pr merge --squash --delete-branch
  ```

**Several PRs queued?** Merge in dependency order. Stack one on another (base the
later PR on the earlier branch) **only** when they genuinely depend on each other
or the merge order is fixed up front — then merging the first leaves the next
already up to date, with no second rebase. Keep *independent* PRs on separate
`main`-based branches and rely on the rebase-before-ready rule above rather than
coupling unrelated work.

## Guardrails

- Never edit `.github/workflows/*` or other CI/config to force a check green, and
  never force-push, without surfacing to the user first.
- If a requested change is ambiguous or risky, reply on the thread with your
  assessment and leave it for the user (note it in the final summary) rather than
  guessing.
- Every commit fires the pre-commit `make lint` hook; fix lint before retrying.

Arguments: $ARGUMENTS
