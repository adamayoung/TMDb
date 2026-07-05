# Delivery Retrospectives

A short, honest entry per feature delivered via `/deliver` — written
**pre-PR** so the entry rides the delivery's own PR (the PR number is
backfilled once the PR opens), newest at the top. A noteworthy watch-phase event
is appended post-gate as an optional *watch:* line — an uneventful watch adds
nothing. The point is **continuous improvement**: when the same friction or
deviation recurs across entries, fold the fix into the relevant skill. Keep each
entry to a handful of bullets — a log, not a ceremony.

Format: **Feature / PR** · date · weight · *phases completed / skills invoked* ·
*what worked* · *friction* · *deviations* · *one improvement* · *watch:*
(optional, amended post-gate).

---

## 2026-07-05 — 🔧 Knowledge consult at entry + independent rubric grader (#384) · lite

- **Phases / skills:** phases 0–10; markdown-only, so `review-plan` skipped
  (lite + `ExitPlanMode` approval), `review-changes` and `security-review`
  self-skipped; capture was inline (the `skill-improvement-log.md` entry *is*
  part of the delivery, per the 2026-07-05 inline-capture decision).
- **Worked:** the plan arrived with the user story + ACs already in
  Given/When/Then form, so the Phase 0 entry gate extracted the rubric with
  zero friction; the diff-by-eye rule-loss check was proportionate for a
  two-section edit (the full inventory method stayed shelved, correctly).
- **Friction:** none material — smallest delivery to date (2 files at
  implement, +49/−8).
- **Deviations:** the change originated from an external article review
  rather than a repo-native trigger; the knowledge-consult it adds was done
  implicitly this run (the design phase had already read the relevant
  gotchas/wiki material) — the new `consulted:` ledger line is what makes it
  explicit from the next run on.
- **One improvement:** extend the consult step to `/implement-plan`
  standalone invocations (deliberately out of scope this run; noted in the
  plan).

## 2026-07-05 — ♻️ Restructure /deliver for progressive disclosure (#383) · lite

- **Phases / skills:** phases 0–9 (new numbering); markdown-only so the Swift
  review gates self-skipped — but the plan's **rule-inventory mapping check**
  ran as a dedicated adversarial `code-reviewer` pass instead (the diff's real
  risk was rule loss, not code). Stacked dependent PR: branched off
  `chore/deliver-retro-before-pr` (#382), base retargets on its merge.
- **Worked:** the **inventory-first** method — extract every load-bearing rule
  with a destination *before* rewriting, then have an independent reviewer
  diff old-vs-new against it. The reviewer confirmed all ten known
  load-bearing rules survived in the core and caught **8 real text drops**
  (1 Medium, 7 Low — e.g. the merge/auto-mode routing for scan-applied skill
  edits), all restored. 915 → 343 core lines + four on-demand reference
  files.
- **Friction:** the ≤~350-line AC needed a second compression pass (first
  rewrite landed at 401) — line budgets are easy to overshoot while
  preserving every rule.
- **Deviations:** `/pr`'s rebase-onto-`origin/main` step doesn't apply to a
  stacked PR (it would fold the dependency's diff into this one) — based on
  the dependency branch instead, per `/watch-pr`'s stacking guidance.
- **One improvement:** the mapping-check-in-lieu-of-code-review worked well
  for a docs-structure diff; if meta-changes to `.claude/skills/**` recur,
  consider making "no-Swift but skill-structure diff → run a rule-loss
  review" an explicit branch in the review phase.

## 2026-07-05 — 🔧 Write the /deliver retro pre-PR (#382) · lite

- **Phases / skills:** phases 0–4; no sub-skills fired (markdown-only: code +
  security review self-skipped, `/implement-plan` N/A with no Canon TDD list,
  `/review-plan` skipped — lite + plan approved via `ExitPlanMode` after a
  plan-mode design round). Knowledge captured **inline** (an `EnterWorktree`
  gotcha + the skill-improvement-log entry), precedented in #366/#368/#374.
- **Worked:** the plan came from a first-principles review of `/deliver` against
  this file and the improvement log — the same loop the skill automates — and
  both open design decisions (amend-only-if-noteworthy; two sequenced PRs) were
  settled with the user via `AskUserQuestion` *before* any edit. The change is
  **dogfooded immediately**: this entry is written pre-PR under the sequencing
  it introduces, and the overdue archive-distil (deferred in #368 and #374) ran
  as part of the new Phase 3.7 windowing step.
- **Friction:** `EnterWorktree` ignored the requested name for the **branch**
  (created `worktree-chore+…`; prior deliveries got the requested name) —
  renamed with `git branch -m`, now a `gotchas.md` entry.
- **Deviations:** none material — inline knowledge capture per precedent.
- **One improvement:** deliverable B of this same run — the
  progressive-disclosure restructure of `deliver/SKILL.md` — is the standing
  improvement; no new one surfaced.

## 2026-07-02 — 📝 Reconcile docs/config honesty gaps from external reviews (#374) · lite

- **Phases / skills:** phases 0.5–6; `review-changes, security-review,
  build-for-testing, pr`. Skipped `/review-plan` (lite + the worklist was approved
  via `ExitPlanMode` this session, and its findings were already adversarially
  *verified* by an 18-agent read-only workflow beforehand); skipped
  `/implement-plan` (no Canon TDD list — docs/config edits + a dead-code deletion).
  Knowledge captured **inline** (a gotcha + the skill-improvement-log entry), not
  via a separate `/capture-knowledge`.
- **Worked:** the standout was **verifying the reviews before acting on them.** Two
  external reviews (Fable + Codex) were turned into a de-risked worklist by an
  18-agent workflow that opened/grepped/counted every claim in-repo — which caught
  real overstatements before any edit (tool count is *eight* not "seven"; the
  `*DetailsResponse` decoders are 90–225 lines not "~180"; 84 request files not
  "~95"; `.unsupportedLanguage` is actually reachable, not dead). Only the
  **verified, softened** Tier-1 subset was delivered. `make ci` green first try
  (2838 unit + 289 integration); the single `code-reviewer` returned **0 findings**
  and independently re-checked the docs claims (tool count, CHANGELOG dates vs the
  actual tags).
- **Friction — the standout:** the Haiku `/build-for-testing` subagent reported the
  build **failed** when `swift build` had **exited 0**. Cause: the benign DocC
  `.docc` "unhandled file" package-load warning lands in xcsift's toon `errors[]`
  array (with `null,null` coords) and flips its `status:` field to `failed`; the
  agent trusted that field over the exit code. The same artifact reappeared in
  `make ci`'s toon (`status: failed` with `failed_tests: 0`). Cost a diagnostic
  cycle to prove it benign. **Fixed this run** (user-requested): a gotcha in
  `gotchas.md` + a "trust the exit status, not xcsift's toon summary" caveat added
  to all four build/test skill prompts (`/build`, `/build-for-testing`, `/test`,
  `/integration-test`).
- **Deviations:** (1) the delivery is **one tier of a 5-batch verified worklist**
  (user green-lit Tiers 1–4 + F7 via `AskUserQuestion`), so the "plan" is the
  worklist doc, not a single-feature plan. (2) **Bundled** the build/test
  skill-prompt fix + its gotcha + skill-improvement-log entry into this honesty PR
  rather than a separate one — the diagnosis gotcha was already committed here, so
  splitting diagnosis from remediation would be worse; a mild scope-broadening,
  flagged to the user. (3) Ran `/security-review` on a zero-attack-surface change
  (docs + a version string + a dead-code deletion) because the Swift-touched gate
  triggered — returned clean, as expected.
- **One improvement:** the DocC-warning false-failure is patched at the prompt
  level, but the deeper fix is to give the Haiku build subagents an **unambiguous**
  pass/fail signal instead of asking them to interpret xcsift's toon fields — e.g.
  have the `make build*/test*` targets append the real exit code to the log
  (`echo "EXIT=$?"`) so the subagent parses one authoritative line. Worth a
  follow-up if the toon-interpretation ambiguity bites again.
- **Housekeeping:** this file is ~2 cycles over its ~12-entry window (archive-distil
  of the 2026-06-18 cluster was deferred in #368 too) — an archive pass is overdue
  next cycle.

## 2026-06-30 — 🔧 Harden & extend the /deliver pipeline (audit P1–P5) (#368) · lite

- **Phases / skills:** phases 0–6; `pr, watch-pr`. Skipped `/review-plan` (the
  proposals came from an adversarial audit earlier this session; `/deliver`
  invocation was approval); skipped `/implement-plan` (markdown-only — no Canon
  TDD list); skipped code review + `/security-review` (no Swift, and the diff
  touches none of the security triggers — `.github/CODE_REVIEW.md` and
  `.claude/skills/**` are not `.github/workflows/` or `.claude/settings*`).
  Knowledge captured **inline** (skill-improvement-log + tmdb-api-notes), not via
  a separate `/capture-knowledge`.
- **Worked:** the audit→plan→deliver chain held end-to-end for a *meta* change
  (editing the pipeline's own skills). Full `make ci` clean first try (unit 2824,
  integration 289 — no flake); the PR's path-aware CI resolved in ~1 min. Scoping
  the run to **Part 1** (skills) up front and deferring codebase fixes A/B/C to
  follow-on runs kept it cohesive. Absorbed two mid-run asks (P5 multi-PR; the
  durable `Company.logoPath` note) without losing the thread.
- **Friction:** (1) **the `TaskCreate` ledger reset twice** mid-run (after the MCP
  reconnect / plan-mode exit) — phases tracked inline instead. **Second** delivery
  to lose the ledger (cf. #364 "CWD-scoped, lost on EnterWorktree"). (2) **The
  markdownlint `--fix` hook corrupted a paragraph** — an inline `#A` token was
  rewritten into a real `# A")` H1 (MD025), caught by `make lint-markdown`; fixed
  by rewording to "PR A/B/C". (3) **Docs fast-gate over-matched** — a review-spec
  doc (`.github/CODE_REVIEW.md`) trips `^\.github/` → full `make ci` though it's
  not build/test-affecting.
- **Deviations:** none material — knowledge captured inline (as in #366) since it
  was authored during implementation. The retro file is over its ~12 window;
  archive-distil deferred to next cycle.
- **Bug found in `/pr`:** the mode preamble says reviewed mode should "**skip steps
  4–6**", but **step 4 is the mandatory `make ci` gate** — the per-step
  annotations correctly mark 5–7 as the skippable review steps. Taken literally it
  would skip the gate; I ran it regardless. Candidate fix (separate PR).
- **One improvement:** ledger fragility now has **two** occurrences — resurface
  the deferred `2026-06-18 file-based ledger` decision (its "reconsider when
  interruptions actually bite" condition now holds), or have `/deliver` re-create
  the ledger after an `EnterWorktree`/reconnect.

## 2026-06-25 — 🔧 Use the GitHub MCP instead of the gh CLI in the skills (#366) · lite

- **Phases / skills:** phases 0–6; `pr, watch-pr` (both dogfooded the new MCP path).
  Skipped `/review-plan` as a *skill* (the plan already got a 3-critic adversarial
  pass earlier in the session, pre-`/deliver`); skipped `/implement-plan` (markdown
  only — no TDD list); skipped code review (no Swift) and the automated
  `/security-review` (diff is 100% markdown — `.md` is excluded; the only
  security-relevant artifact, the `mcp__github__*` permission, is gitignored and out
  of the PR — reviewed by reasoning instead, parity with `Bash(gh:*)`, ADR-0009).
- **Worked:** the migration was **dogfooded end-to-end** — PR opened via
  `mcp__github__create_pull_request`, readiness verified positively via
  `get`/`get_check_runs`/`get_review_comments`, and the blocking wait used the
  *retained* `gh pr checks --watch`. The pre-implementation 3-critic plan review paid
  off: it caught two **BLOCKERs** before any edit — the review-reply mapping gap
  (`add_reply_to_pull_request_comment` needs a REST comment id `get_review_comments`
  doesn't expose → reply stays on `gh`) and the wrong method name (`rerun_failed_jobs`,
  not "rerun-failed"). Path-aware CI resolved the docs-only PR in ~1 min.
- **Friction — the MCP registration detour cost real time.** Enabling the `actions`
  toolset, the user repointed the single `github` server to `…/mcp/x/actions`, whose
  **exclusive** path silently dropped the default PR toolset — `pull_request_read`
  etc. vanished mid-implementation, needing diagnosis + two reconnect cycles before
  `…/mcp/x/all` fixed it. Now an ADR + `gotchas.md` entry.
- **Deviations:** (1) the owner/repo "single source" decision surfaced *mid-edit*
  from a user question, not in the plan — it should have been a planned design point
  (it forced re-touching four already-edited files). (2) Captured knowledge **inline**
  (ADR-0009 + gotchas) rather than invoking `/capture-knowledge`, since the ADR was
  written during implementation. (3) This PR **supersedes** #365's
  `reviewThreads`/`gh pr view --json` gotcha — watch-pr §0 no longer calls
  `gh pr view` at all, so that guard was adapted to the MCP (`get_review_comments`).
- **One improvement:** when a delivery edits the *very skills the pipeline runs*
  (`/pr`, `/watch-pr`, `/deliver`), `/deliver` should note up front that the skill
  **registry loads from the main checkout**, so the in-session skills keep the *old*
  behaviour until merge — the change can only be dogfooded by the conductor acting
  manually, not by the sub-skills. Flagging this avoids confusion when `/pr` visibly
  runs `gh pr create` while the diff says otherwise.

## 2026-06-24 — 🔧 Add entry/exit criteria and auto-start to /deliver (#365) · lite

- **Phases / skills:** phases 0–6; `pr, watch-pr`. Skipped `/review-plan` (lite +
  plan approved via ExitPlanMode this session); skipped `/implement-plan`
  (markdown-only — no TDD test list); skipped code review + security review (no
  Swift changed).
- **Worked:** the fast-gate detector caught this as docs/config-only correctly —
  only `make lint-markdown` ran locally, CI resolved in under 2 minutes. Deriving
  the changes directly from the conversation (Looper article → gap analysis →
  plan) kept the plan tight and the edits focused. The three changes (entry gate,
  Phase 3.6, Contract §8) landed cleanly in one commit with no review friction.
- **Friction:** the auto-start behaviour (Contract §8) can only be captured in the
  skill itself and memory — there's no harness hook that fires on ExitPlanMode
  approval, so it relies on the model reading the contract. That's a soft guarantee.
- **Deviations:** Plan had no formal acceptance criteria (the first delivery under
  the new entry gate!) — the circular dependency was noted and the Verification
  section stood in. Phase 3.6 was accordingly a no-op for this run.
- **One improvement:** the entry gate prompts for ACs but doesn't suggest a format
  or example in context — the prompt could include a one-line example inline
  ("e.g. 'Given X, when Y, then Z'") to reduce back-and-forth.
- **Gotcha — `reviewThreads` is not a valid `gh pr view --json` field.** Adding it
  causes `gh` to error with empty stdout; any JSON parsing then fails with
  `JSONDecodeError: Expecting value: line 1 column 1`. Thread data must be fetched
  via `gh api graphql` — `/review-pr-threads` already does this correctly. Added a
  guard note to `watch-pr/SKILL.md §0`. Do not add `reviewThreads` (or `comments`)
  to `gh pr view --json` calls.

## 2026-06-24 — 🔒 Harden URL path interpolation & validate inputs (#364) · lite

- **Phases / skills:** phases 0–6; `test, integration-test, review-changes,
  security-review, capture-knowledge, pr, watch-pr`. Skipped `/review-plan` (lite;
  plan built from a careful Explore sweep + the originating security review).
- **Worked:** the **Phase 3.4 security review earned its place** — it traced the
  encoding *end-to-end* through `TMDbAPIClient.urlFromPath`'s `URLComponents`
  round-trip and confirmed query/fragment injection is genuinely blocked (not just
  at the string layer), while surfacing the subtle `%2F`→`/` decode and correctly
  bounding it as path-only on a locked host. That trace is what made the fix
  trustworthy and produced ADR-0008 + the gotcha. Reusing the existing
  `TMDbSearchService.validate` pattern kept validation uniform and review-clean.
- **Friction — a repeated blind spot for `String`-typed IDs.** The *same class* of
  site kept being found later than it should: my planning grep **and** the initial
  `/security-review` both missed sites; Phase 3 code review found a 4th
  String-into-path builder (`ReviewRequest`); then `claude-review` flagged **three
  more** public service methods taking `String` IDs with no empty guard
  (`CreditService`/`ReviewService`/`TVEpisodeGroupService` `.details(for…:)`). Each
  pass found a subset. A type-driven sweep up front (grep `path = "/…\(` for
  String interpolations **and** scan public service signatures for `String`/`*.ID`
  params) would have enumerated all of them in one shot.
- **Deviations:** none material — heeded the worktree edit-path gotcha (re-`Read`
  via worktree paths after the pre-`EnterWorktree` reads; no main-checkout edits).
  Minor: the `TaskCreate` ledger is CWD-scoped, so it was lost on `EnterWorktree`
  and had to be recreated inside the worktree. The retro commit also hit a
  same-day ADR-number collision with #363 (both claimed 0007) — renumbered to
  0008 during the rebase.
- **One improvement:** when a delivery's goal is "fix every instance of pattern X",
  do one **type-driven enumeration of all sites up front** and list them in the
  plan, rather than discovering them incrementally across review passes.

## 2026-06-24 — 📝 Document existing response caching (#363) · lite (docs-led)

- **Phases / skills:** phases 0–6; `review-changes, capture-knowledge, pr,
  watch-pr`. Skipped `/review-plan` (lite + `/deliver` invocation was the
  approval); skipped `/security-review` (no executable surface — doc comments +
  markdown only); did **not** run `/implement-plan` (docs-only — no Canon TDD
  test list to drive).
- **Worked:** the standout was **challenging the premise before building.** The
  user asked "evaluate whether this feature is needed — there's already an HTTP
  cache" mid-plan; a quick `curl -D-` of real TMDb endpoints (every GET returns
  `Cache-Control: public, max-age` + `ETag`) plus reading `TMDbFactory` showed the
  requested opt-in on-disk cache **already exists** via the default `URLCache`
  (Apple platforms) — and a hand-rolled one would be *inferior* (fixed TTL, no 304
  revalidation). `AskUserQuestion` → "document, build nothing" turned a feature
  build into a docs PR + ADR-0007. `make build-docs` (warnings-as-errors) was the
  real gate for the `<doc:>`/symbol links.
- **Friction:** (1) The single `code-reviewer` caught a genuine **High** that
  *both* `make build-docs` and `markdownlint` missed — stray `</content>`/
  `</invoke>` tags the `Write` tool leaked into the article tail (DocC renders
  them as prose; `MD013` is off). Strong evidence that code review earns its keep
  even on a "docs-only" change, and now a captured gotcha. (2) The recurring
  full-`make ci` cost: the diff is doc-comments + markdown, yet ran the entire
  unit+integration+release matrix.
- **Deviations:** (a) The plan-file `Write` was rejected and `/deliver` invoked
  directly, so the plan lived only in conversation — Phase 0's "read plan content
  into context" covered it cleanly. (b) Wrote docs directly instead of via
  `/implement-plan` (no test list for prose); build-docs + lint-markdown were the
  gates.
- **One improvement:** the **docs/config-only fast gate** is now logged on #340,
  #343, #344 and here — four deliveries paying the full ~6-min matrix for
  no-logic changes. Refinement this run exposes: the existing fast-gate detector
  keys on the `.swift` *extension*, so a **comment/doc-only `.swift` diff** (like
  this one) still trips the full gate. Worth finally implementing the fast gate
  **and** widening its trigger to "no semantic Swift change" (e.g. diff is only
  within `///`/`//` lines), so doc-comment touch-ups qualify too.

## 2026-06-24 — ✨ Add missing discover filter parameters (#361) · lite

- **Phases / skills:** phases 0–6; `build-for-testing, test, integration-test,
  lint, review-changes, capture-knowledge, pr, watch-pr`. Skipped `/review-plan`
  (lite + the plan was already adversarially reviewed earlier this session by the
  3-agent finding-verification pass).
- **Worked:** lite-weight scoping was correct — single-`code-reviewer` review
  converged **round 1 with 0 critical/high/medium**. The codebase's existing
  *"no-op mutation preserves every other populated field"* guard test made the
  real risk (new fields silently dropped by the ~30-arg fluent `copy()` helpers)
  trivial to cover: extend `fullyPopulatedFilter`, and a missing pass-through
  fails loudly. Verifying the finding against the live API up front caught the
  `release_date.*` vs `primary_release_date.*` semantic distinction before coding.
- **Friction:** (1) **The big one — edits landed in the main checkout, not the
  worktree.** I `Read` the source files in Phase 0 *before* `EnterWorktree`, so
  their absolute paths pointed at `main`; continuing to `Edit` those paths after
  entering wrote to `main`. Worse, the build/test then ran against the *pristine*
  worktree and returned **baseline** counts (2792/282), masking that nothing had
  landed — only an empty `git status` in the worktree exposed it. Recovered via a
  shared stash (`git -C main stash` → `git -C worktree stash pop`). (2) The
  `Date(iso8601:)` test helper is `TMDbTests`-only, so an integration test using
  it failed to compile — but only once the integration target actually built.
  (3) **Asymmetric integration coverage, then a stale "ready" call.** Three of the
  four new params got a live integration test but TV `withoutWatchProviders` got
  only unit coverage — `claude-review` flagged it **High**. Worse, I'd declared the
  PR "ready, 0 unresolved threads" *before* re-checking: the retro/skill-fix pushes
  and the `main` merge each re-ran `claude-review`, which posted that thread **after**
  my one-time thread check. The thread also **blocked the merge** (the `main`
  ruleset requires `required_review_thread_resolution`), so "ready" was wrong on two
  counts. (4) **Misread `BLOCKED` as code-owner review when a required check was
  still running.** A filtered rollup query (`select(.conclusion!="SUCCESS")`) hid a
  still-`IN_PROGRESS` "Build and Test" (no conclusion yet ⇒ absent from the filter),
  compounded by a stale passed copy of the same check from an earlier tip — so I
  reported "all green" and pinned the merge block on the un-satisfiable code-owner
  self-review. The user caught it. Lesson: confirm **every required check is
  `COMPLETED`+`SUCCESS` on the current tip** (assert nothing is `status!=COMPLETED`),
  and when `BLOCKED`, rule out a **pending required check** before blaming a review
  rule.
- **Deviations:** an unplanned mid-Phase-2 stash-rescue to move the change off
  `main` into the worktree; and a post-gate fix loop (add the missing TV
  `withoutWatchProviders` integration test, resolve the bot thread) before the merge
  could proceed — i.e. the `/watch-pr` thread sweep had to actually run per-push,
  not once.
- **One improvement:** `/deliver` Phase 0 already reads the *plan* into context
  before the worktree, but reading *source* files there is a trap — their paths
  become stale on `EnterWorktree`. Phase 0.5 should add a hard checkpoint: after
  entering, **verify `git status` shows the diff in the worktree before trusting
  the first green build**. (This is the **second** delivery to hit main-vs-worktree
  path confusion — see #359 — so it's now a recurring pattern worth a skill edit.)

## 2026-06-23 — ✨ Add `TMDbTesting` public mocks & sample-data library (#359) · full

- **Phases / skills:** phases 0–6; `review-plan, implement-plan, build-for-testing,
  test, integration-test, lint, review-changes, capture-knowledge, pr, watch-pr`,
  plus three bespoke Workflows (mock/sample generation, test generation, the
  review fan-out).
- **Worked:** the **reference-first** discipline paid off massively — building and
  *reviewing* `MockGenreService` before replicating caught a cross-module DocC
  break that would otherwise have been baked into all 26 mocks. Fanning the bulk
  generation out to 14 sonnet agents over a precise pre-computed spec (signatures,
  return-type ownership, batch partitions) turned a ~16k-line mechanical job into
  a handful of build-and-fix passes; the final 5-dimension review found **0
  critical / 0 high** across it. `/review-plan`'s three critics were genuinely
  load-bearing (they killed the plan's false "gate the NL mock" premise up front).
- **Friction:** (1) some generation subagents wrote files to the **main checkout**
  path instead of the worktree — had to detect and consolidate (now a captured
  gotcha). (2) The generation Workflow failed on the **args-stringification**
  gotcha despite it being in memory — I forgot the `JSON.parse` guard and lost one
  run. (3) `codecov/patch`/`project` go red on a 15k-line mock library (inherently
  low line-coverage of trivial record-return boilerplate) — non-blocking here, but
  noise. (4) couldn't run `make build-linux` locally (Docker down) — leaned on CI's
  `build-test-linux` job.
- **Deviations:** for the bulk (25 mocks + 87 samples) I inverted strict
  test-first — generated production from the reviewed template, then added
  representative + smoke tests — rather than red-green per method. Defensible for
  mechanical replication of an already-test-driven reference, but a deviation from
  `/implement-plan`'s one-test-at-a-time contract. Also expanded the main-target
  change beyond the planned `GuestSession` init (9 filter types → `Sendable`).
- **Improvement:** the Workflow tool's own description warns about
  args-stringification, yet it bit again — worth a **standard `args` parse-guard
  preamble** baked into any `/deliver` generation-Workflow snippet (or a lint of
  the script before launch), so the guard isn't re-derived from memory each time.
- **Specialist skills under-used (`swift-concurrency`, `swift-testing-expert`):**
  `/implement-plan`'s contract says to route anything touching actors/`Sendable`/
  data races through `swift-concurrency`, and test structuring through
  `swift-testing-expert`. I did neither — the `NSLock`/`@unchecked Sendable` mock
  design and the 9-filter-types `Sendable` change were hand-rolled, and tests
  followed the reference pattern via general-purpose agents. It compiled and
  passed, but the user had to prompt me to consult `swift-concurrency` on the
  actor-vs-lock question. When finally invoked, the skill *validated* the lock
  choice **and** surfaced a real gap: `@unchecked Sendable` needs a documented
  safety invariant **and a removal plan** (migrate to `Mutex` once the floor
  reaches iOS 18/macOS 15) — which I'd omitted from the ADR. **Lesson:** invoke
  the specialist skill *at the moment its domain appears* (lock/`Sendable`/actor
  design, test structure), not only when asked — that's the difference between
  "it passed" and "it's right, and the rationale is recorded."
- **Gate-driven refinements (post-PR, pre-merge):** the human gate caught two
  things the autonomous run had shipped sub-optimally, both fixed before merge:
  (a) **sample data wasn't from the live MCP** — I'd relaxed the locked "real MCP
  data" decision in Phase 1 to "reuse existing fixtures", and agents fabricated
  placeholders (`"Cast Member"`, `"Movie Overview"`) for the ~12 fixture-less
  types; re-sourced all 67 API-backed samples from real `mcp__tmdb__*` responses.
  (b) **`TMDbTesting` tests lived inside `TMDbTests`** (per the plan) rather than a
  dedicated target; split them into `TMDbTestingTests` with public-only imports so
  the consumer story is compiler-enforced. **Lesson:** when I relax a *locked*
  user decision during plan-hardening (here "samples from real MCP"), that's a
  choice to flag back to the user at the gate, not absorb silently — both fixes
  were cheap pre-merge but would have been debt post-merge.

## 2026-06-23 — ✨ Add `movieCredits` language-model tool to TMDbToolbox (#357) · lite

- **Phases / skills:** phases 0–6; `implement-plan, build-for-testing, test,
  integration-test, lint, review-changes, capture-knowledge, pr, watch-pr`
  (skipped `review-plan` — lite).
- **Worked:** lite path fit a mechanical mirror of `MovieDetailsTool`; reading the
  sibling source first meant a faithful copy with zero implementation surprises
  (2714 unit tests green first try). The **`swiftlint --no-cache` step in `/pr`
  step 4** (the #346 improvement) earned its keep: adding the credits block tipped
  the formatter file/test over `file_length`/`type_body_length`, caught **locally**
  and fixed by splitting into a `+Credits` extension file + separate `@Suite`
  before any CI round-trip.
- **Friction — the standout:** the local `code-reviewer`'s adversarial pass
  **dropped a real High** — "missing integration test for `movieCredits`" — with
  the false reasoning *"no sibling toolbox tool has a per-tool integration test."*
  In fact `Tests/TMDbIntegrationTests/LanguageModelToolsIntegrationTests.swift` has
  one per tool; the reviewer only inspected the per-tool **unit** tests and never
  listed the integration dir. The `claude-review` bot on the PR caught it
  correctly, costing a post-PR fix + a second full CI run. Phase 3 is supposed to
  converge Critical/High *before* the PR; a fabricated "siblings don't either"
  dismissal defeated that.
- **Deviations:** the integration-test gap was fixed in **Phase 5 (watch-pr)**, not
  Phase 3, because the local review wrongly cleared it.
- **Improvement:** when a reviewer is about to drop a "missing integration test"
  (or any "siblings don't do this either") finding, it must **verify the
  sibling-convention claim by listing the actual directory** (here
  `Tests/TMDbIntegrationTests/`) — not assume from the unit-test dir. Worth a line
  in `.github/CODE_REVIEW.md` / the `code-reviewer` adversarial-pass guidance:
  *an adversarial drop that rests on a factual claim about sibling code must check
  that claim against the tree.*

## Archive (distilled)

Older entries condensed per the rolling window (`knowledge/README.md` →
*Maintenance & retention*); prose is in git history.

| Date | PR | Weight | Outcome |
| --- | --- | --- | --- |
| 2026-06-19 | #349 | full | `networks` on TVSeason from a schema-diff scan; critics pre-caught the Equatable/over-populated-mock trap → 0/0/0 review; exposed the local-vs-CI `lint-markdown` scope mismatch. |
| 2026-06-18 | #346 | full | AuthenticatedSession wrapper; 3 critics unanimously reversed deprecate-and-add to additive; local-vs-CI lint cache gap → `/pr` `--no-cache` step. |
| 2026-06-18 | #344 | lite | Error-handling How-To guide; `make build-docs` was the real gate; reinforced the docs-only fast-gate need. |
| 2026-06-18 | #343 | lite | Explicit `Sendable` on `URLSessionHTTPClientAdapter`; premise re-framed from bug fix to clarity. |
| 2026-06-18 | #341 | lite | `details(...)` params → `<entity>ID`; Explore-first overturned the review's framing (non-breaking, opposite direction). |
| 2026-06-18 | #340 | lite | README watch-provider example fix; sibling retry "bug" finding disproved (false positive). |
| 2026-06-18 | #337 | full | Opt-in next-page prefetch; fan-out review caught untested cancellation; spawned the autonomy/lite/triage `/deliver` changes. |
| 2026-06-18 | #335 | full | Auto-pagination coverage; unrelated flaky red gate improvised → built `/fix-integration-failures` + red-gate triage. |
