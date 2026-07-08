---
name: fix-integration-failures
description: Diagnose and fix a failing scheduled (or standalone) TMDb Integration workflow run — re-run transients, or fix real drift on a branch off main, then PR and (optionally) merge. Use for the weekly Sunday Integration cron failure, or any red Integration run not tied to an open PR.
---

# Fix Integration workflow failures

The **`Integration`** workflow (`.github/workflows/integration.yml`) runs the
live-API integration suite on a **weekly schedule** (`cron: '0 0 * * 0'` — Sunday
00:00 UTC), as well as on PRs/pushes. The scheduled run is a **live-API canary**:
nothing in the code changed, so a failure means the live TMDb API drifted, a test's
assumed data went stale, or a transient error/rate-limit hit. This skill takes such
a failure from **red run → green main**: diagnose it, then either re-run a transient
or fix the real cause on its own branch and open (and optionally merge) a PR.

> **Scope.** This is for an Integration failure **not attached to an open feature
> PR** — the scheduled canary, a `workflow_dispatch`, or a failure on `main`. When a
> failing Integration check belongs to an **open PR**, `/watch-pr` and
> `/fix-pr-checks` own that; they delegate the *pre-existing/unrelated* case back
> here (fix on a branch off `main`), which is exactly this skill's job.

**Mode** — check the arguments passed to this skill (shown at the end). If they
include `merge` (e.g. `/fix-integration-failures merge`), **auto-merge** the fix PR
once green. Otherwise stop at **ready-to-merge** and hand off (default).

## Agent behaviour contract

1. **Never edit `main` directly** (`CLAUDE.md`). Any fix lands on a `fix/<slug>`
   branch off `main`, via a PR.
2. **Diagnose before fixing.** Always run `/diagnose-integration-failure` first;
   let its ranked cause drive the fix. Don't guess.
3. **Distinguish transient from real.** A re-run is the cheap test. Only open a PR
   for a cause that survives a re-run (or is clearly a data/shape drift).
4. **Test-first for real fixes.** A model/decoder fix follows `canon-tdd` (failing
   unit test + fixture, then the fix). A drifted-assertion fix updates the
   integration test to assert **behaviour, not a brittle exact value**.
5. **The gate is `make ci`.** Never open the PR until it passes locally.
6. **Don't paper over a real regression.** If the cause is a genuine library bug
   (not drift/transient), fix it properly or stop and report — never just relax a
   test to hide it.

## 0. Find the failing run

> **Interactive vs headless.** The steps below use the **GitHub MCP**
> (`mcp__github__*`, owner/repo from the `origin` remote). When this skill runs
> **headless** from `integration-failure.yml` — a CI runner, where the user-scoped
> MCP is **not** mounted — use the `gh` equivalents instead (given inline at each
> step and in *Running headless* below); that path stays 100% `gh`/`git`.

Find the failing run with `mcp__github__actions_list` method `list_workflow_runs`
(owner/repo from `origin`, `resource_id: integration.yml`,
`workflow_runs_filter: { event: schedule, status: completed }`). The `status` enum has
no `failure` value, so filter the results to `conclusion == "failure"` yourself.

- Prefer the most recent **`schedule`** (or `workflow_dispatch`) run on `main`.
- Note its run `id` and `event` (sets the cause ranking).
- No failing run → report "Integration is green, nothing to fix" and stop.
- **Headless:** `gh run list --workflow Integration --status failure --limit 5 --json databaseId,event,headBranch,conclusion,createdAt,displayTitle`.

## 1. Diagnose

Invoke **`/diagnose-integration-failure`**, handing it the run id (it fetches the
failed-job logs — via `mcp__github__get_job_logs`, or `gh run view --log-failed` when
headless). It returns the three-section analysis — Summary,
Likely cause (ranked; for a scheduled run it leads with backend/data drift, **not**
a code regression), and Suggested fix. Use that ranking to choose the path below.

## 2. Transient? Re-run first

If the diagnosis points to **case 3** (HTTP 429 / rate-limit, a timeout near the
30-min cap, or a truncated log with no assertion failure):

Re-run the failed jobs with `mcp__github__actions_run_trigger` method
`rerun_failed_jobs` (owner/repo from `origin`, `run_id: <id>`), then block on the
re-run with `gh run watch <run-id>` (the MCP has no blocking-wait equivalent). After
it returns, re-read the conclusion with `mcp__github__actions_get` method
`get_workflow_run` (`resource_id: <id>`) — don't trust the rerun call to surface it.

```bash
gh run watch <run-id>   # blocking wait — kept on gh
```

- **Green on re-run** → it was transient. Report and stop; no PR needed.
- **Fails the same way again** → treat as deterministic; go to §3.
- **Headless:** `gh run rerun <run-id> --failed` then `gh run watch <run-id>`.

(The integration client already retries 429/5xx with backoff, so a true transient
that survives a re-run is uncommon — a repeat failure is usually real drift.)

## 3. Fix the real cause on a branch off `main`

Reproduce locally first to confirm and to get a fast edit loop. Branch **off
`origin/main` directly — never `git checkout main` first**. This is
**worktree-safe**: when this skill is invoked from a `/deliver` worktree (via
`/watch-pr` §1c), `main` is usually checked out in the main working copy, so
`git checkout main` fails with `fatal: 'main' is already used by worktree …` —
the same trap `/pr` documents for its rebase step:

```bash
git fetch origin
git checkout -b fix/<slug> origin/main   # e.g. fix/<service>-integration-drift
```

**Invoked mid-`/deliver` (from `/watch-pr`)?** Don't create the fix branch in
the deliverable's worktree — that switches its checkout away from the feature
branch being watched. Give the fix its own worktree instead and work there,
removing it once the fix PR merges:

```bash
git worktree add .claude/worktrees/fix-<slug> -b fix/<slug> origin/main
```

Run the failing suite locally to reproduce — `/integration-test` (or
`swift test --filter <Suite>/<test>`). Then fix per the diagnosis:

- **TMDb backend / response-shape change** (a field added, removed, renamed, or now
  nullable) → fix the Swift model / `CodingKeys` / fixture **test-first**
  (`canon-tdd`): add a failing unit test + a JSON fixture matching the *current*
  live shape (confirm via the OpenAPI spec / `mcp__tmdb__*`), then the model fix.
- **Stale assumed data** (a test asserts a specific live title, count, id, date, or
  ordering that drifted) → relax the integration assertion to verify **behaviour,
  not a brittle exact value** (e.g. assert non-empty / a stable property / `>= 1`
  rather than an exact count). Match the robust pattern already used by sibling
  tests in the same suite.
- **A genuine library regression** → fix it properly, test-first. If it is not a
  quick, confident fix, **stop and report** — don't merge a workaround.

Verify: `/integration-test` green for the touched suite, then **`make ci`**
(mandatory full gate). If `make ci` is red, fix and re-run — never PR on red.

## 4. Open the PR (and optionally merge)

Run **`/pr`** to commit (gitmoji), push, and open the PR (`🐛`/`✅`/`♻️` as fits;
`make ci` runs again inside `/pr`). Then run **`/watch-pr`** to drive it to ready:

- **Default (no `merge`)** → `/watch-pr` watch-only: report the ready PR URL and
  **stop** for the user to merge.
- **`merge`** → `/watch-pr merge`: squash-merge once green, then report.

`/watch-pr` handles any further transient flakes on the PR's own checks (re-run),
so a live-API hiccup during CI won't strand the fix.

## 5. Report

Close with: the run id that failed, the diagnosis verdict (transient vs real), what
you changed (file + one line) or that a re-run cleared it, the PR URL and whether it
merged, and anything left for the user (e.g. a real regression you chose not to
auto-fix).

## Running headless (from `integration-failure.yml`)

When the **Integration Failure Alert** workflow invokes this skill on a scheduled
failure, it runs non-interactively, so adapt:

- A failing-step log is already at **`failure-log.txt`** in the workspace — diagnose
  from it (pass it to `/diagnose-integration-failure`); don't re-download logs.
- **Verify with the targeted suite + a build** — `swift build --build-tests` and
  `swift test --filter <Suite>/<test>` — **not** the full `make ci`. The **opened
  PR's own CI** (`ci.yml` + `integration.yml`) is the authoritative gate; the alert
  job need not replicate the whole pinned-lint/xcsift toolchain.
- **Open the PR with `git`/`gh` directly** (`git checkout -b` → commit → push →
  `gh pr create`), **not** `/pr` — `/pr` runs the full `make ci`, which the
  lightweight alert job can't satisfy. The format/lint hooks still reshape files on
  edit, so the diff stays clean.
- **Then STOP** — do **not** run `/watch-pr` and do **not** merge (a human reviews
  it). Write the diagnosis to `claude-analysis.md` and, if you open a PR, its URL on
  one line to `pr-url.txt`.
- If the cause is **transient** (re-run territory) or a **genuine regression you
  should not auto-fix**, open **no** PR — explain in `claude-analysis.md` so the
  alert issue carries it.

## Guardrails

- Never edit `.github/workflows/*` to force a check green, and never force-push,
  without surfacing to the user first.
- One failing run can surface several drifted assertions — fix them together in one
  PR, but keep each change minimal and behaviour-preserving.
- If the live API is broadly down/throttled (many unrelated suites failing fast),
  that's an outage, not a fix target — report and wait it out.
- Capture anything durable you learned (a new live-API shape, a recurring drift)
  with `/capture-knowledge` before the PR, so the fixture/notes land with it.

Arguments: $ARGUMENTS
