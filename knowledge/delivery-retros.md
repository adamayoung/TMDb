# Delivery Retrospectives

A short, honest entry per feature delivered via `/deliver` (its Phase 6), newest
at the top. The point is **continuous improvement**: when the same friction or
deviation recurs across entries, fold the fix into the relevant skill. Keep each
entry to a handful of bullets — a log, not a ceremony.

Format: **Feature / PR** · date · weight · *what worked* · *friction* ·
*deviations* · *one improvement*.

---

## 2026-06-18 — 📝 Add error-handling How-To guide (#344) · lite (docs-only)

- **Worked:** reading the real source first (`TMDbError+TMDbAPIError.swift` for the
  status→case mapping, `RetryHTTPClient.swift` for retry semantics) meant the guide
  documented *actual* behaviour — including the "error thrown only after retries are
  exhausted" nuance from the dropped item 3 — rather than plausible-sounding
  guesses. `make build-docs` (warnings-as-errors) was the real gate: it validated
  every `` ``TMDbError/notFound(_:)`` `` enum-case link and `<doc:>` reference, so a
  broken symbol link would have failed before the PR.
- **Friction:** same recurring one — `make ci` ran the full unit+integration+release
  matrix for a docs-only change; only `build-docs` + `lint-markdown` were meaningful.
- **Deviations:** none — clean docs-only lite path (review auto-skipped, no Swift).
- **Improvement:** reinforces the **docs/config-only fast gate** idea already logged
  on #340/#343 — for a no-`.swift` diff, `make ci` could run just lint +
  lint-markdown + build-docs. Three docs-only deliveries this session each paid the
  full-matrix cost; worth implementing the fast gate in `/pr` step 4 now.

## 2026-06-18 — ♻️ Explicit `Sendable` on `URLSessionHTTPClientAdapter` (#343) · lite

- **Worked:** grounding the plan in the actual code first paid off again — reading
  the adapter revealed it is `internal` and already enforced as `Sendable` via
  `HTTPClient: Sendable`, so the change was correctly framed as
  clarity/future-proofing rather than the bug fix the source review implied. The
  `code-reviewer` confirmed all three safety claims and caught one honest Low (the
  compile-time assertion guards Sendability "by any route", not the explicit
  annotation) — applied the reword and moved on.
- **Friction:** none of note. `make ci` again ran the full ~6-min gate for a
  ~14-line change (same docs/low-risk fast-path gap noted on #340).
- **Deviations:** none — clean lite path (skip critics, single reviewer).
- **Improvement:** the compile-time `requireSendable(_:)` assertion is a nice
  reusable idiom for pinning `Sendable` on concurrency-sensitive types; consider a
  one-line note in `knowledge/gotchas.md` if it recurs (didn't capture yet — single
  use so far).

## 2026-06-18 — ♻️ Standardize details(...) parameter names to `<entity>ID` (#341) · lite

- **Worked:** scouting the *actual* scope before planning (an `Explore` sweep over
  all 26 services) overturned two assumptions from the source review — the change
  was non-breaking (internal names only) and the cheap, convention-aligned
  direction (`<entity>ID`, 7 methods) was the **opposite** of the review's
  recommendation (`id`, 24 methods). Re-confirming the decision with the user
  before editing avoided a 24-method diff against the grain of the codebase.
  Single-`code-reviewer` lite path fit the mechanical diff; build/tests/lint/review
  all clean first time.
- **Friction:** my raw `awk` line-length check flagged ~140 lines >100 chars and
  briefly looked like a lint failure, but `make lint` reported 0 violations (the
  enforced threshold ignores comment/URL lines and is higher than the documented
  100 for code). Wasted a beat reconciling the two. Lesson: trust `make lint`, not
  a hand-rolled length check.
- **Deviations:** had to go back to the user mid-delivery to correct my own earlier
  framing (I'd asked about deprecation/major-bump for a change that turned out
  non-breaking). The right move, but a sign the *up-front* questions were asked
  before the scope was actually understood.
- **Improvement:** when a delivery originates from a review *finding* (not a
  user-authored plan), scope it against the code (a quick `Explore` pass) **before**
  asking the user any strategy questions — the finding's framing may be wrong, as
  it was here (and for the dropped retry "fix"). Treat review findings as
  hypotheses to verify, not approved plans.

## 2026-06-18 — 📝 Fix non-compiling watch-provider README examples (#340) · lite

- **Worked:** lite path was exactly right for a docs-only fix — `/review-plan` and
  `/review-changes` both auto-skipped (no Swift in the diff), so the pipeline went
  branch → edit → `make ci` → PR → green with no wasted machinery. Verifying the
  property against source (`WatchProvider.name`, JSON key `providerName`) before
  editing confirmed the fix was real.
- **Friction:** `make ci` runs the *full* gate (unit + live integration tests,
  release build, docs build) even for a two-character README change — minutes of
  CI for a typo. The hard "always `make ci`" rule has no docs-only fast path.
- **Deviations:** none.
- **Improvement:** consider a docs/config-only gate (lint + markdown-lint + docs
  build, skipping the test/release-build legs) when `git diff --name-only
  main...HEAD` touches no `*.swift` — the PR's own CI still runs the full matrix.
- **Cross-cutting note:** the sibling finding "off-by-one retry semantics" (item 3
  of the same review) turned out to be a **false positive** — the existing test
  `429 exhausts retries and returns last response` (RetryHTTPClientTests.swift:38)
  pins `performCount == 4` for `maxRetries: 3` (1 initial + 3 retries) as the
  intended contract. `/deliver`'s test-first discipline caught it before any
  change. Lesson: treat AI-review findings as *hypotheses* and confirm against the
  contract/tests before delivering.

## 2026-06-18 — ⚡️ Opt-in next-page prefetch (#337) · full

- **Worked:** the full pipeline shone on the riskiest change of the effort (first
  hand-rolled `Task` lifecycle). The fan-out `/review-changes` found a real gap
  (page-level cancellation untested); the fix + re-review converged to 0/0/0/0.
  Haiku-delegated build/test/TSan kept context lean.
- **Friction:** SourceKit `<new-diagnostics>` false positives on every newly-created
  file added narration noise (now a documented gotcha + CLAUDE.md note). The
  cancellation-forwarding test took several iterations to make deterministic.
- **Deviations:** skipped `/review-plan`'s critics (the plan had already converged
  over three prior rounds) — the skill now makes this explicit (Phase 1 plan-aware).
- **Improvement:** delivered — the autonomy/lite/triage/ledger/handoff/retro changes
  in this very PR came out of this run.

## 2026-06-18 — ✨ Auto-pagination coverage for Account/GuestSession/Keyword/Changes (#335) · full

- **Worked:** mechanical, pattern-repeating change went smoothly; the two gates kept
  the user in control without micromanaging.
- **Friction:** the biggest rough edge of the whole session — `make ci` went red on a
  **flaky, pre-existing, unrelated** integration test (`SearchPaginationIntegrationTests`),
  and `/deliver` had no built-in path for "a red gate that isn't your fault." The
  resolution (fix on a branch off `main` → merge → rebase) was entirely improvised
  and cost several `make ci` re-runs (#334).
- **Deviations:** skipped the critic re-run (plan already reviewed); improvised the
  red-gate triage and built `/fix-integration-failures` mid-stream.
- **Improvement:** **red-gate triage** is now built into Phase 4 (in-diff vs
  pre-existing → route to `/fix-integration-failures`), so an unrelated flake no
  longer stalls a delivery. The fan-out review was arguably overkill for this
  mechanical change → **auto-detected lite mode** added.
