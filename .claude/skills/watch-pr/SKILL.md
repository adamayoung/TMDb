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
- End the loop when a full pass resolves no new threads and has no actionable
  check failures. Hard backstop: ~10 passes, then report and stop.
- Waiting: use `gh pr checks --watch` for in-flight CI. When only waiting on a
  human to review, pause and resume later with `ScheduleWakeup` (a few minutes
  while CI is active; longer when idle). This skill also composes with `/loop`
  if the user prefers harness-driven cadence.

## 3. Ready / merge

The PR is **ready** when every review thread is resolved AND no check is failing
or pending.

- **Watch-only**: report "PR is ready" with a short summary (threads handled,
  checks green) and stop.
- **Merge-when-ready**: on ready, merge and clean up, then report the result:

  ```bash
  gh pr merge --squash --delete-branch
  ```

## Guardrails

- Never edit `.github/workflows/*` or other CI/config to force a check green, and
  never force-push, without surfacing to the user first.
- If a requested change is ambiguous or risky, reply on the thread with your
  assessment and leave it for the user (note it in the final summary) rather than
  guessing.
- Every commit fires the pre-commit `make lint` hook; fix lint before retrying.

Arguments: $ARGUMENTS
