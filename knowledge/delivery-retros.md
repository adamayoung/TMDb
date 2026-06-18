# Delivery Retrospectives

A short, honest entry per feature delivered via `/deliver` (its Phase 6), newest
at the top. The point is **continuous improvement**: when the same friction or
deviation recurs across entries, fold the fix into the relevant skill. Keep each
entry to a handful of bullets — a log, not a ceremony.

Format: **Feature / PR** · date · weight · *what worked* · *friction* ·
*deviations* · *one improvement*.

---

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
