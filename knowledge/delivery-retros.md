# Delivery Retrospectives

A short, honest entry per feature delivered via `/deliver` (its Phase 6), newest
at the top. The point is **continuous improvement**: when the same friction or
deviation recurs across entries, fold the fix into the relevant skill. Keep each
entry to a handful of bullets — a log, not a ceremony.

Format: **Feature / PR** · date · weight · *what worked* · *friction* ·
*deviations* · *one improvement*.

---

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
