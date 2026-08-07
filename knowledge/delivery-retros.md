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

## 2026-08-07 — ✨ TMDb v4 authentication (`feature/v4-list-reads`) · full

- **Phases / skills:** 0–9; `review-plan`, `implement-plan`, `review-changes`
  (2 iterations), `security-review`, `capture-knowledge`, `pr`. `consulted:`
  gotchas (False green; EnterWorktree branch naming; growing a public protocol
  additively; bearer-token URLCache key space; SourceKit lag on new files),
  api-notes (error-body shape; silent-ignore of unknown query params), ADR-0001,
  ADR-0005, ADR-0008, ADR-0010.
- **`swept:`** 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
- **What worked:** **probing the live API before writing the plan's models.**
  TMDb's v4 documentation is wrong in ways no amount of reading would surface:
  the documented endpoint *names* are 404s, the same field has different wire
  types on different endpoints, `clear` is a state-changing GET, and both
  `create(public:)` and add-items' `comment` are accepted-then-ignored. Every one
  was found by curl, and each would have shipped as a bug. The corollary is that
  v4 auth-gates *before* routing, so the cheap 401-vs-404 path probe returns
  nothing useful until you hold a credential — which is exactly why the wrong
  paths survived into an approved plan.
  **The adversarial plan review earned its cost twice over**, both unanimous:
  it caught that patching only `CacheHTTPClient` leaves the always-on 1 GB
  on-disk `URLCache` leaking private reads across users, and that splitting
  `V4ListService` across two PRs would make the second one source-breaking. The
  second forced a redraw of the decomposition along a *protocol* boundary
  instead of a read/write one — which dissolved a third blocker for free.
- **Friction:** the delivery stalled at Phase 0 on a credential only the user
  could obtain, and the first ask was mis-scoped — the plan assumed a v4 user
  token was needed for everything, when in fact the v3 key already in the
  environment authenticates all v4 *reads*. A sharper credential matrix up front
  would have unblocked most of the investigation without waiting.
- **Deviations:** decomposed one approved plan into two deliverables (this PR is
  part one of two), on the review's blocker. Issue #394 stays open on merge.
- **One improvement:** `/deliver`'s contract says run autonomously to the single
  ready-to-merge gate, and this run instead ended its turn at four phase
  boundaries to report status — the user had to say "keep going" and later ask
  why no PR existed. The phase summaries are worth writing; ending the turn to
  deliver them is not.

## 2026-07-29 — 🔧 Harden the delivery skills (#407) · full

- **Phases / skills:** 0–9; `review-plan`, `security-review`, `capture-knowledge`,
  `pr`. Substituted an adversarial *mapping* review for `/review-changes` (it
  self-gates to nothing on a no-Swift diff) and **deliberately overrode Phase 5's
  self-skip** — the diff touches `.github/workflows/` and introduces
  `.claude/workflows/`. `consulted:` gotchas (False green; tooling-runner main-checkout;
  EnterWorktree branch naming; lint pins), ADR-0009, ADR-0014.
- **`swept:`** 1 in scope / 0 reclaimed / 0 resumable / 0 reported (this run's own
  worktree, correctly classified `live` by its lock PID).
- **What worked:** *review before writing*. Three plan-review rounds (37 + 9 + 11
  findings) ran before a single file was edited, and they were not cosmetic — round
  1 blocked v1 outright for **data loss** (the sweep would remove worktrees with
  unpushed work) and **credential exposure** (this repo is public and the headless
  job pastes diagnosis text verbatim into an issue). Round 2 caught that the ACs
  still graded mechanisms the plan had just cut, which would have red-gated Phase 6
  by construction. Round 3 caught that the *fix* for the sweep had widened its blast
  radius to the main checkout. Editing first would have shipped all three.
  **Verifying mechanisms instead of asserting them** also paid: the content-stamp
  command's first form was a false green (`git ls-tree` has no exclude pathspec, so
  both hashes were the empty blob and compared equal), and the panel's guard rails
  were exercised live at `agent_count: 0`.
- **Friction:** the plan file became a patch note layered over a superseded v1 —
  the round-2 reviewer flagged the stale normative tail as a defect in itself, and
  it had to be fully re-issued. Two cut units were then restored by user decision,
  so scope oscillated mid-review. Context burn was heavy: ~57 findings across three
  rounds plus a 505-rule inventory.
- **Deviations:** `/implement-plan` skipped (markdown + JS, no Canon TDD list);
  `/review-changes` replaced by the mapping review; Phase 5 run despite its
  self-skip. All three deliberate and recorded above.
- **`watch:`** declared ready-to-merge with CI green, then a user-requested review
  of the *newest* code (the two committed JS scripts and the three commits that
  postdated the mapping review) returned **fix-first** with a **major**: the
  fan-out validated its `args`/`checks` shape but not the *elements*, so the most
  likely malformed input spawned agents on `undefined` names and reported full
  coverage — in the commit whose whole purpose was making those guards
  executable. Four smaller defects with it, including an over-redaction that
  would have dead-linked every alert issue. **The readiness call was wrong**: the
  review chain covered the plan, rule-preservation, security and AC conformance,
  but nothing had read the last-written code as code. A post-ready review is not
  redundancy here — it found what five earlier passes structurally could not.

- **One improvement:** the pipeline has no gate for *"this change edits the skills
  the pipeline itself runs"*. Three separate defects came from that reflexivity —
  a rewritten `/deliver` grading itself, a plan whose ACs outlived their mechanisms,
  and a fan-out shipped as prose in the very PR arguing prose isn't a gate. A Phase 0
  check that flags a self-modifying delivery and pins its verification to the
  *original* text would have caught all three earlier.

## 2026-07-28 — 🐛 Company logo path & origin country optional (#404) · full

- **Phases / skills:** 0–8 pre-PR; full weight (breaking public API +
  `Decodable`). `consulted:` next-major.md (the source), tmdb-api-notes
  *Company.logoPath required decode*, gotchas *False green*. `/review-plan`
  (3 Opus critics) → **1 blocker + 9 findings**. `/implement-plan` inline,
  test-first. `/review-changes` 5-dimension fan-out + adversarial verify →
  **0 Critical/High/Medium, 2 Low**, both applied, 0 dropped by verification.
  `/security-review` → 0 findings ≥ conf-8. Independent grader → **6/7 ACs,
  AC6 not met**, fixed and re-graded to met.
- **Worked — the queue fired on its first real use.** `next-major.md` was
  written on 2026-07-27 and consulted on 2026-07-28; the fix reached the
  still-untagged 19.0.0 window instead of waiting for 20.0.0. The whole point
  of that file, validated one day later.
- **Worked — two independent checks each caught something the other didn't.**
  My type-driven sweep found `Company.Parent.logoPath` (a second instance,
  invisible because `Parent`'s decode is synthesized). The plan critics found
  the **blocker**: `Company.originCountry` is the same bug on the same records,
  so shipping `logoPath` alone would have left Time Warner throwing — and my
  own AC1 integration test failing. Verified independently before accepting:
  5 of 54 sampled companies.
- **Worked — sampling beat spot-checking.** One `curl` showed
  `logo_path: null` and nearly ended the investigation. Sampling 54 companies
  took a minute and produced the field/nullability matrix that proved
  `origin_country` was in scope and `description`/`headquarters` were not —
  the difference between a correct fix and a subset.
- **Friction — I adjudicated a 2–1 critic split wrongly, and the grader caught
  it.** Two critics wanted `Company.Parent` to guard empty strings; one called
  it speculative. I sided with the one, citing 0/54 observed empty strings.
  That produced an asymmetry *inside one type* — `Company.logoPath` mapped
  `""` → `nil` while `Company.Parent.logoPath` still threw — i.e. the exact
  bug this delivery exists to remove, one level down. **Lesson: "matches the
  siblings" and "consistent within the type" can conflict, and within-the-type
  wins;** an unobserved value ranks the risk, it doesn't close the case.
- **Friction — I nearly shipped a knowledge entry contradicting my own code.**
  The api-note written in Phase 6 argued *against* guarding `Parent`; the
  Phase 7 fix reversed that, and the note had to be rewritten in the same
  delivery. Capture-before-grade is the wrong order when grading can still
  change the design.
- **Deviations:** (a) scope grew from one field to three plus a
  `LogoImageProviding` conformance — the blocker forced two, and all three
  critics independently asked for the conformance (it was blocked *only* by
  the non-optional type). (b) Fixtures for the empty/absent cases are
  hand-built, not live captures: TMDb always sends these keys, so those
  decoder branches have no real-world sample. Flagged in-test.
- **One improvement:** **`/deliver` should run the rubric grader before
  `/capture-knowledge`, not after.** Phase 7 changed the design this run, which
  invalidated a Phase 6 entry that had already been committed. Ordering
  capture after grading costs nothing and removes the rewrite.

## 2026-07-27 — ✨ Cached image URL resolver, `client.images` (#401) · full

- **Phases / skills:** 0–8 pre-PR; full weight (new public service + actor,
  8 commits). `/plan` → adversarial review by a Fable reviewer **plus** an
  independent Swift-6 design pass, which converged on the same critical flaw, so
  `/review-plan` was skipped as already-reviewed. `implement-plan` in 4
  checkpoints. `review-changes` ×2 (5-dimension fan-out) → **0 Critical, 0 High
  both rounds**, 15 then 7 advisory, all applied. `security-review` → 0 findings.
  `capture-knowledge` → ADR-0013 + 3 gotchas + 1 correction to an existing entry.
  Rubric: **6/6 ACs met**, independently graded.
- **Worked — driving each mechanism out of a genuine red.** Rather than writing
  the final actor from the plan, each hazard got its own failing test first: the
  naive memo measured **100 fetches at peak concurrency 76** under 100 concurrent
  callers, and the refresh ABA returned `["first"]` where `["second"]` was
  expected. That produced *evidence* those are real regression tests, for free —
  the plan had asked for a deliberate "revert and watch it fail" step, and this
  made it unnecessary.
- **Worked — plan review caught a bug the plan could not have shipped without.**
  Both plan reviewers independently found that the cache rules said *what* to
  memoise but never *who writes state*, so a superseded fetch would clobber a
  newer `refresh()` — a permanently stale cache that **none of the 13 planned
  tests would have caught**. The generation counter came from that, pre-code.
- **Friction — I introduced two flaky tests while fixing review round 1, and only
  round 2 caught them.** A caller that *joins* a shared in-flight fetch never
  reaches the mock or gate, so a gate-based barrier cannot observe it; both new
  tests opened the gate and then asserted on coalescing. Neither ever failed
  locally (one reviewer measured 0/65 reproductions, 25 under load) — they were
  wrong by construction, not by observation. Fixed with an on-actor entry
  counter. **Lesson: after a concurrency fix, re-review the tests, not just the
  code.**
- **Friction — the one that actually cost the user: ~10 zsh pipelines pinned at
  100% until they force-quit them.** My first explanation ("parallel agents,
  build contention") was only half of it, and the smaller half. The real
  amplifier is **`make build-docs` mutually invalidating every other build**:
  `Package.swift` branches on `SWIFTCI_DOCC`, and the `=1` path *adds* the
  swift-docc-plugin dependency while the else path *sets `exclude`* on four
  targets — two different dependency graphs and two different per-target source
  lists, sharing **one** `SCRATCH_PATH` (default `.build`). `Makefile:61` even
  runs a bare `swift package resolve` after the docs build purely to undo the
  first line's resolution, which is the Makefile conceding the point. Evidence:
  `Package.resolved` is gitignored (the package normally has *no* dependencies)
  yet exists, and `.build/checkouts/` holds `swift-docc-plugin` +
  `swift-docc-symbolkit`.
  So when I interleaved `build-docs` (×5) with `make test` / `build-release`
  **while 5–7 review agents were independently building into the same
  `.build`**, each docs run re-resolved the manifest out from under an in-flight
  build; they then fought over `.build/.lock` and repeatedly redid work the other
  had invalidated. Not slow work — *cyclical* work.
  Two things I had wrongly folded into "CPU": the live integration suite is
  **deliberately serialised** (40 suites carry `.integrationGate`, a global
  semaphore), so 300 live tests run one at a time — that is most of the 69- and
  72-minute wall-clock, and it is by design; and sheer redundancy (full unit
  suite ×7, `build-docs` ×5, release ×3, a 12× filtered loop, plus a grader that
  re-ran all of `make ci` unbidden, plus the real `make ci`).
  `CLAUDE.md` mandates sequential builds within a worktree, but **subagents
  cannot see each other**, so nothing could enforce it.
- **Deviations:** (a) `TMDbFactory` was not touched — the issue's AC says
  "registered in `TMDbFactory.swift`", but the factory vends only plumbing and
  every service is built in `TMDbClient`'s private init; the grader independently
  confirmed the criterion is stale. (b) `APIConfigurationStore` carries an
  internal `entryCount` that exists only so tests can observe joining callers —
  production state for the test suite, accepted deliberately and flagged by the
  grader. (c) The ten URL methods are protocol-*extension* members, not
  requirements, to kill the same-signature default-witness recursion hazard.
- **Improvement (two, in priority order):** (1) **Give `build-docs` its own
  scratch path** — `SCRATCH_PATH ?= .build/docs` for that target alone — so the
  docc manifest never touches the directory every other target builds into. One
  line, and it removes the invalidation cycle at the source rather than relying
  on nobody ever running two things at once. (2) `/deliver` should forbid builds
  in reviewer/grader subagent prompts and serialise its review phases: reviewers
  have the diff and the conductor has already run every gate, so a reviewer
  running `make ci` is duplicate CPU — and with N parallel agents on a shared
  scratch path it is not merely N×, it is cyclical.

## 2026-07-24 — 📦 Extract the `TMDbIntelligence` product (#398) · full

- **Phases / skills:** phases 0–8 pre-PR; full weight (~40 sources + ~110
  fixtures + ~30 tests relocated, new targets, CI/docs infra). `/plan` refreshed
  the pre-existing `plans/tmdb-intelligence-product-extraction.md` after a
  3-agent drift check. `review-plan` (3 Opus critics) → **2 blockers + 6
  findings, all applied**. `implement-plan` in 4 checkpoints.
  `review-changes` → **1 Critical**, 3 Medium, 2 Low. `security-review` → 0
  findings ≥ conf-8. `capture-knowledge` → 1 new gotcha + **2 corrections to
  existing ones**. Rubric: 7/7 ACs met (**self-graded — the independent grader
  subagent died on a session limit; recorded, not silently passed**).
- **Worked:** the plan critics paid for themselves twice over — they caught that
  `TMDbTestingTests` tests `SearchPlan.sample` (which moves out, so the target
  would not compile), that the integration inventory was 5 files not 3, and
  unanimously that the **`.xctestplan` sweep was ghost work** (the files are
  gitignored and untracked — the plan would have had me edit non-existent
  files). Counting tests rather than trusting green proved the move lossless:
  **2868 before, 2868 after**, reconciled against the true base `c22a336`.
- **Friction — the one that mattered:** `@testable import TMDb` inside the new
  **non-test** `TMDbTestFixtures` target broke `swift build -c release` *only*.
  Debug builds, `--build-tests`, all 2868 unit tests and 291 integration tests
  passed while `make build-release` — i.e. `make ci` and both CI release jobs —
  was red. I never ran a release build before declaring implementation
  complete; the code reviewer caught it. Whole-module-optimization then
  misreported the culprit file, so the grep for `@testable` mattered more than
  the compiler's own pointer.
- **Deviations:** (a) the shared-fixtures target was **not** in the plan — the
  review blocker forced a decision between duplicating ~100 fixtures, keeping
  tests in place, or a shared target; the user chose the shared target after I
  corrected my own under-estimate of the blast radius (494 of 572 files touch
  those fixtures). (b) `make ci` could not pass locally for most of the
  delivery — the Xcode 27 `.docc` trap, verified to fail **identically on
  `origin/main`**, so every stage was run individually instead; **#396 fixed it
  upstream mid-delivery**, and the rebase onto it made `make ci` green once the
  two new catalogs were added to its `exclude` list. (c) M3 left as documented
  duplication rather than promoting two internal DTOs, which cascades into
  member-level access.
- **Rebase (onto `cea296c`):** picked up #396 (Xcode 27) and #397 (`TMDbError`
  context — the 19.0.0 train partner, now merged). Two conflicts, both in
  append-at-top files (CHANGELOG, retros). The load-bearing catch was silent:
  #396's `.docc` `exclude` list is **per target**, so the two new catalogs
  re-introduced the build failure — a clean textual rebase and a green
  `swift build` both missed it; only `make ci` caught it. Tests reconciled
  again: **2869 on the new base, 2869 after**.
- **Improvement:** **`/deliver` Phase 3 should run `swift build -c release`
  before declaring implementation done.** Debug + tests green is not evidence
  the release gate passes, and the two diverge precisely on access-level and
  `@testable` mistakes — exactly what a target-extraction PR is made of. Cheap
  check, would have caught the only Critical in this delivery.

## 2026-07-24 — ✨ Enrich `TMDbError` with structured context (#397) · full

- **Phases / skills:** phases 0–8 pre-PR; full weight (reshapes the package's
  most load-bearing public enum + networking + new public API). `review-plan`
  (3 critics) → **1 blocker**, 3 majors, 4 minors; all applied, none rejected.
  `implement-plan`/`canon-tdd` in 4 committed increments (additive types →
  atomic reshape + 15-file test migration → fixtures/integration → docs/ADR).
  `review-changes` fan-out (5 dims + adversarial verify) → 0 Critical/High, 2
  Medium, 3 Low; fixed 4, rejected 1 (`Codable` on the new value types —
  speculative, `TMDbError` itself isn't `Codable`). `security-review` → 0
  vulnerabilities, 1 consistency hardening applied. `capture-knowledge` → 2
  API notes + 3 gotchas + ADR-0012. Independent grader: **5/5 ACs met**.
- **Worked:** the plan review paid for the whole delivery — a critic caught that
  `endpointPath` would carry `guest_session_id` (a bearer-like credential) and
  `account_id` (PII) into a **public, loggable** field, before a line was
  written; the redactor and its tests came from that finding, and the security
  review later confirmed the control covers all 137 request-path templates.
  Capturing **real** error bodies from the live API during planning (`curl -D-`)
  beat the plan's guesses: the fixtures became 400/code 22 and 422/code 20 as
  the API actually returns them, not the invented 422/code 5. Keeping the six
  cases semantic and putting transport detail in context (wiki: *semantic
  errors, not transport codes*) un-collapsed the fidelity without exporting 13
  HTTP-shaped public cases.
- **Friction (environmental):** the Xcode 27 / Swift 6.4 `.docc` trap that #390
  logged as annoying became **blocking** — `make ci` cannot run at all. My first
  attribution (xcsift `--Werror`) was **wrong**; `pipestatus` showed `swift
  build` exiting 1 and xcsift 0, and the failure reproduced on a pristine
  `origin/main` worktree, proving toolchain drift rather than a branch defect.
  The tooling-runner CWD trap recurred with a new symptom: a delegated
  `swift test` ran in the **main** checkout and reported "no matching test cases
  found" for suites that plainly exist. Web tools hit a session rate limit
  mid-task; the GitHub API (`runner-images` README + announcement issue) served
  as the substitute source.
- **Deviations:** ran every build/test **directly via `Bash`** in the worktree
  again; verified the delivery against CI's own commands rather than `make ci`.
  Mid-delivery the user asked for Xcode 27 adoption, so that work went to its
  own worktree/branch (**#396**) to keep this PR scoped — its CI then caught a
  real regression (Swift 6.4 moved build products and split the test bundle per
  target, so the hardcoded coverage export silently uploaded 0%).
- **One improvement:** the tooling-runner CWD fix was **already** this file's
  "one improvement" for #390 and it recurred verbatim one delivery later — two
  consecutive full deliveries lost time to it. It should stop being a retro line
  and become a skill change: either pin the tooling-runner's CWD to the active
  worktree, or have `/build`/`/test` refuse to run when their CWD isn't the
  conductor's. Second candidate: `Package.swift` should declare the `.docc`
  catalogs so `-warnings-as-errors` can't fatally trip on them (shipped in #396).

## 2026-07-24 — ♻️ Represent model runtimes as `Duration` instead of `Int` (#390) · full

- **Phases / skills:** phases 0–8 pre-PR; full weight (breaking public API,
  `Codable`/`CodingKeys`). `review-plan` skipped (`ExitPlanMode` approval this
  session). `implement-plan`/`canon-tdd`: TDD'd the `RuntimeMinutes` converter,
  then did the type migration as one **atomic** increment (a breaking type
  change doesn't compile in partial states). `review-changes` fan-out (5 dims +
  adversarial verify) → 0 Critical/High/Medium, 2 Low (both fixed).
  `security-review` → 0 findings. `capture-knowledge` → 3 tooling gotchas +
  ADR-0011 (inline). Independent grader: 6/6 ACs MET.
- **Worked:** the stored-minutes / computed-`Duration` design keeps `encode`
  synthesized, so the integer-minute wire format can't silently drift — no
  hand-written 30-property encode to maintain — and per-model encode
  round-trip tests lock it. Two plan-time Explore agents pre-mapped the whole
  consume/format + test surface, making the migration mechanical. The
  `.convertFromSnakeCase` → camelCase-`CodingKeys` check (wiki/gotcha) caught
  the `episodeRunTime` rawValue trap before it silently broke decode.
- **Friction (environmental, not the change):** the beta Swift 6.4 / macOS 27
  toolchain makes `-Werror` promote the `.docc` "unhandled file" false alarm to
  a **fatal** error, so `make test` / `make build-tests` / `make ci` fail
  locally — and the tooling-runner (Haiku, running in the **main** checkout)
  misreported the very first build as a failure. Homebrew had also drifted
  swiftformat to 0.62.1 vs the 0.61.1 pin, flagging unchanged files and
  reshaping edits. Both cost real diagnosis time.
- **Deviations:** ran every build/test **directly via `Bash`** in the worktree
  (the tooling-runner runs in `main` and never saw the worktree diff); built
  tests without `-Werror` to run them, with `-Werror` + a grep-filter to catch
  real warnings; reinstalled pinned swiftformat 0.61.1 to `~/.local/bin`.
- **One improvement:** the tooling-runner / `/deliver` skills should run the
  tooling-runner **in the active worktree** (or explicitly require builds to go
  direct-via-`Bash` there) — the CWD mismatch silently builds/reviews the wrong
  tree. Captured as a gotcha this delivery; a skill fix would stop the next
  worktree run hitting it cold.

## 2026-07-08 — 👷 Bump CI workflows to Xcode 26.6 (#387) · lite

- **Phases / skills:** phases 0–10; config-only (`.github/workflows/`), so
  `review-plan` skipped (lite + `ExitPlanMode` approval) and `review-changes`
  self-skipped (no Swift). `security-review` **ran** — workflows are a
  security-relevant surface — and returned 0 findings (a trusted-literal token
  swap with no untrusted-input path). `/capture-knowledge` returned nothing:
  the only fact (macos-26 ships Xcode 26.6, build 17F113) is transient
  runner-image state, already recorded in the commit message.
- **Worked:** a plan-time `WebFetch` of the `macos-26` runner-image README
  confirmed `/Applications/Xcode_26.6.app` exists (build 17F113) **before**
  pinning it — retiring the one real risk of a version-pin bump (pinning a
  toolchain the runner doesn't ship) at plan time. Explore's exact-line
  inventory made Phase 3 a mechanical 6-line swap; grep + `actionlint` (exit 0)
  double-checked the result.
- **Friction:** none material.
- **Deviations:** `implement-plan`/`canon-tdd` not applicable — a YAML
  version-string swap has no code under test; edited directly, verified with
  grep (zero `26.5`, six `26.6`). Rubric came from the plan's Verification
  section (chore plan, no Given/When/Then user story).
- **Housekeeping:** distilled the oldest full entry (#361) into the archive
  table, clearing the archive-distil deferred in #368/#374 and keeping the file
  at its ~12-entry window.
- **One improvement:** none — the pre-pin runner-image README check is the right
  guard for any toolchain bump; reuse it verbatim next time the pin moves.

## 2026-07-06 — ♻️ Consolidate build/test runners into a tooling-runner agent (#385) · lite

- **Phases / skills:** phases 0–10; markdown/config-only, so `review-plan`
  skipped (lite + `ExitPlanMode` approval — the two open design choices were
  settled pre-plan via `AskUserQuestion`), `review-changes` and
  `security-review` self-skipped, `/capture-knowledge` returned nothing (the
  sole candidate was already documented inside the `capture-knowledge` skill
  itself); ADR-0014 (model tiers, originally numbered 0010) authored inline in
  Phase 3.
- **Worked:** the plan-time Explore cross-reference sweep pre-scoped the prose
  blast radius — spotting that "delegates to a Haiku subagent" prose stays
  *true* after the refactor (the runner agent **is** Haiku) cut the edit list
  to 11 files, only 4 of them prose spots. Phase 0's gotcha consult paid off
  twice within minutes (branch rename after `EnterWorktree`; `.md` tail check
  after every `Write`).
- **Friction:** none material.
- **Deviations:** `canon-tdd` not applicable — no test surface on a pure
  skills/agents/docs change; the plan's Changes list served as the checklist,
  and the rubric came from its Changes + Verification sections rather than
  Given/When/Then ACs (chore plan, no user story).
- **One improvement:** a freshly added `.claude/agents/*.md` may not register
  as a spawnable `subagent_type` until a new session, so the consolidation
  can't be smoke-tested end-to-end inside the delivering session — the first
  post-merge `/build` is the real verification; if it surprises, that's a
  `gotchas.md` entry.

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

## Archive (distilled)

Older entries condensed per the rolling window (`knowledge/README.md` →
*Maintenance & retention*); prose is in git history.

| Date | PR | Weight | Outcome |
| --- | --- | --- | --- |
| 2026-06-30 | #368 | lite | Hardened the `/deliver` pipeline from an adversarial audit (P1–P5). Established the pattern this repo keeps returning to: an unenforceable process rule gets silently skipped, so encode the ones that matter as blocking gates (the Phase 3a/4a reference-unit review became a ledger task that blocks a later phase). Skipped code review and `/security-review` on its no-Swift diff (as #365 and #366 had) — the self-gating that #407 later had to override deliberately, when a docs-only change carried real risk. |
| 2026-06-25 | #366 | lite | Migrated the skills from the `gh` CLI to the GitHub MCP (ADR-0009), dogfooded end-to-end. The 3-critic plan review paid for itself pre-edit: it caught that `add_reply_to_pull_request_comment` needs a REST comment id `get_review_comments` doesn't expose (so thread replies stay on `gh`), and a wrong method name. Real cost was a registration detour — the hosted `/x/<toolset>` paths are **exclusive**, so pointing at `/x/actions` silently dropped the default PR toolset mid-implementation; `/x/all` fixed it. Lesson that generalises: when a delivery edits the very skills the pipeline runs, the skill registry loads from the main checkout, so the change can only be dogfooded by the conductor acting manually until merge. |
| 2026-06-24 | #365 | lite | Entry/exit criteria + auto-start for `/deliver`. The docs/config fast-gate correctly classified it (CI green in under 2 min). Lasting lesson: auto-start on `ExitPlanMode` approval is a **soft guarantee** — no harness hook fires on it, so it depends on the model reading the contract. First delivery under the new AC entry gate, and the plan had no formal ACs (circular dependency, noted); its "one improvement" — put an inline `Given X, when Y, then Z` example in the gate prompt — still stands. Its `reviewThreads`/`gh pr view --json` gotcha was superseded by #366 (the MCP migration removed the call) and is deliberately not carried forward. |
| 2026-06-24 | #364 | lite | Percent-encode URL path segments + validate `String` IDs (ADR-0008). The security review's end-to-end trace through `urlFromPath`'s `URLComponents` round-trip is what made the fix trustworthy (and found the `%2F`→`/` decode, correctly bounded as path-only on a locked host). Lesson that became skill policy: for "fix every instance of pattern X", do **one type-driven enumeration of all sites up front** — here the planning grep, `/security-review`, code review, and `claude-review` each found a *different subset*. |
| 2026-06-24 | #363 | lite (docs-led) | Documented the existing response caching instead of building it: challenging the premise mid-plan (`curl -D-` showed every GET returns `Cache-Control`/`ETag`, so the default `URLCache` already provides — and beats — the requested opt-in cache) turned a feature build into a docs PR + ADR-0007. A single `code-reviewer` caught a High that both `make build-docs` and `markdownlint` missed: stray `</content>`/`</invoke>` tags the `Write` tool leaked into the article tail. Fourth entry asking for a docs/config-only fast gate, widened here to "no semantic Swift change" so doc-comment-only `.swift` diffs qualify. |
| 2026-06-24 | #361 | lite | Missing discover filter params; single-`code-reviewer` converged 0/0/0 (existing no-op-mutation guard test made the dropped-field risk in the ~30-arg `copy()` helpers trivial to cover). Two recurring traps: edits landing in `main` not the worktree (source `Read` pre-`EnterWorktree` → stale paths; now the Phase 1 `git status` checkpoint), and a stale "ready" call — verify every required check is `COMPLETED`+`SUCCESS` on the current tip, and rule out a pending required check before blaming a review rule on `BLOCKED`. |
| 2026-06-23 | #359 | full | `TMDbTesting` mocks + samples (~16k lines, 14-agent fan-out); reference-first review caught a cross-module DocC break pre-replication; gate re-sourced samples from live MCP + split `TMDbTestingTests`; lessons: invoke specialist skills when their domain appears, never silently relax a locked user decision. |
| 2026-06-23 | #357 | lite | `movieCredits` toolbox tool; local reviewer's adversarial pass dropped a real High on a fabricated "no sibling has one" claim → adversarial drops must verify sibling-convention claims against the tree. |
| 2026-06-19 | #349 | full | `networks` on TVSeason from a schema-diff scan; critics pre-caught the Equatable/over-populated-mock trap → 0/0/0 review; exposed the local-vs-CI `lint-markdown` scope mismatch. |
| 2026-06-18 | #346 | full | AuthenticatedSession wrapper; 3 critics unanimously reversed deprecate-and-add to additive; local-vs-CI lint cache gap → `/pr` `--no-cache` step. |
| 2026-06-18 | #344 | lite | Error-handling How-To guide; `make build-docs` was the real gate; reinforced the docs-only fast-gate need. |
| 2026-06-18 | #343 | lite | Explicit `Sendable` on `URLSessionHTTPClientAdapter`; premise re-framed from bug fix to clarity. |
| 2026-06-18 | #341 | lite | `details(...)` params → `<entity>ID`; Explore-first overturned the review's framing (non-breaking, opposite direction). |
| 2026-06-18 | #340 | lite | README watch-provider example fix; sibling retry "bug" finding disproved (false positive). |
| 2026-06-18 | #337 | full | Opt-in next-page prefetch; fan-out review caught untested cancellation; spawned the autonomy/lite/triage `/deliver` changes. |
| 2026-06-18 | #335 | full | Auto-pagination coverage; unrelated flaky red gate improvised → built `/fix-integration-failures` + red-gate triage. |
