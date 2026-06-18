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

```bash
gh run list --workflow Integration --status failure --limit 5 \
  --json databaseId,event,headBranch,conclusion,createdAt,displayTitle
```

- Prefer the most recent **`schedule`** (or `workflow_dispatch`) run on `main`.
- Note its `databaseId` (the run id) and `event` (sets the cause ranking).
- No failing run → report "Integration is green, nothing to fix" and stop.

## 1. Diagnose

Invoke **`/diagnose-integration-failure`**, handing it the run id (it will
`gh run view <id> --log-failed`). It returns the three-section analysis — Summary,
Likely cause (ranked; for a scheduled run it leads with backend/data drift, **not**
a code regression), and Suggested fix. Use that ranking to choose the path below.

## 2. Transient? Re-run first

If the diagnosis points to **case 3** (HTTP 429 / rate-limit, a timeout near the
30-min cap, or a truncated log with no assertion failure):

```bash
gh run rerun <run-id> --failed
gh run watch <run-id>
```

- **Green on re-run** → it was transient. Report and stop; no PR needed.
- **Fails the same way again** → treat as deterministic; go to §3.

(The integration client already retries 429/5xx with backoff, so a true transient
that survives a re-run is uncommon — a repeat failure is usually real drift.)

## 3. Fix the real cause on a branch off `main`

Reproduce locally first to confirm and to get a fast edit loop:

```bash
git checkout main && git pull --ff-only
git checkout -b fix/<slug>          # e.g. fix/<service>-integration-drift
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
