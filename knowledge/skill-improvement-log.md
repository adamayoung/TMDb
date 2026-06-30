# Skill-Improvement Log

A durable record of every skill-improvement proposal raised by `/deliver`'s
**Phase 6 recurring-pattern scan**, and the decision on it. Newest at the top.

**Why this exists:** the Phase 6 scan surfaces proposals and waits for approval.
Without a memory of past decisions, it would re-propose ideas already **applied**
or deliberately **deferred/rejected** — wasting attention and re-litigating
settled calls. The scan **consults this log before proposing** and skips any
pattern already decided here. Record both the *yes* and the *no* (with rationale)
— the *no*s are what stop the loop repeating itself.

Status values: **applied** · **deferred** · **rejected**.

Format per entry:

```text
### <date> — <short title> · <applied|deferred|rejected>
- **Pattern:** what kept recurring (and the retro entries it appeared in).
- **Decision:** what was agreed, and where it landed (skill + commit/PR) if applied.
- **Rationale:** one or two sentences — why this call.
- **Reconsider when:** (deferred/rejected only) the condition under which the scan
  should resurface this — or `n/a` for applied entries. The Phase 6 scan reads this
  field to decide whether a settled *no* may be re-proposed.
```

Keep this five-field shape on every entry so the scan can parse the log
consistently — in particular **Decision** (status) and **Reconsider when** are the
two fields the dedup step keys on.

---

### 2026-06-30 — Phase 3 per-unit review: replace the blanket rule with a template→replicate reference-unit gate · applied

- **Pattern:** Phase 3's "Full / multi-unit → review per cohesive unit,
  interleaving Phases 2 and 3" rule was **never executed as written** across any
  full delivery (#335, #337, #346, #349, #359) and flagged as a deviation in none
  — it structurally fights `/implement-plan`'s drive-to-empty-test-list loop. Its
  valuable core (catch a wrong foundational pattern before it replicates) was
  followed only in the one template→replicate case (#359's informal
  "reference-first" review of `MockGenreService`); parallel-similar fulls used a
  single end-diff fan-out, which worked.
- **Decision:** **applied** (2026-06-30 standardization audit, user-approved).
  `/deliver` Phase 3 now splits the full case: **template→replicate** (one pattern
  across N≥3 units) gets a **hard ledger gate** — a `Phase 3a — reference-unit
  review` task that reviews the first unit's commit before the rest are generated
  and **blocks Phase 4** until done (Contract §6 records the task);
  **full-otherwise** explicitly uses the single end-diff fan-out, with the
  per-unit interleave language removed. Landed in `.claude/skills/deliver/SKILL.md`
  Phase 3 + Contract §6.
- **Rationale:** narrows the gate to the only shape where a foundational defect
  actually fans out (and makes it enforceable via the ledger), instead of
  demanding a per-unit interleave that doesn't happen and isn't worth forcing on
  parallel-similar work.
- **Reconsider when:** a *non-template* multi-unit delivery ships a foundational
  defect an earlier per-unit review would have caught — then widen the trigger.

### 2026-06-30 — Sibling-convention conformance: Phase 2 prevent-probe + review-time detect-lens · applied

- **Pattern:** new code diverges from its existing family because conventions are
  implicit/copy-paste, not enforced — verified in the audit: the empty-input guard
  copy-pasted across 7+ services with no shared helper (the #364 straggler root
  cause); `Movie.addRating` missing the rating guard its TV siblings have;
  `Company` vs `Network` decoding the same field oppositely; service test suites
  mis-tagged `.requests` vs `.services` within a folder.
- **Decision:** **applied** (audit, user-approved). **Prevent:** `/implement-plan`
  Step 1 now says — when an item adds a sibling to an existing family, read the
  1–2 nearest siblings first and capture their shared conventions (validation,
  error case, conformance set, decode strategy, suite tag) as explicit test-list
  items. **Detect:** `.github/CODE_REVIEW.md`'s "Consistency of repeated fixes"
  broadened to "Consistency with siblings" (a new family member must match its
  siblings or the divergence is flagged), with matching cues added to the
  `architecture`/`testing` dimensions in `review-changes`. Shared spec → the
  GitHub bot inherits the lens.
- **Rationale:** the "standardization is the substrate" lesson at this scale —
  prevent divergence at authoring time and catch it pre-PR, closing the class
  instead of finding stragglers one review pass at a time.
- **Reconsider when:** the underlying conventions are unified in code (e.g. a
  shared validation helper lands) so the lens can point at the helper rather than
  "the nearest sibling".

### 2026-06-30 — Adversarial-drop hardening: verify any sibling-claim before dropping a finding · applied

- **Pattern:** the local reviewer's *trustworthiness* has failed by dropping a
  **real** finding on a false premise about siblings — #357 dropped a real
  "missing integration test" High reasoning "no sibling toolbox tool has one" (it
  only checked the unit-test dir), and the PR bot caught it after the local review
  had cleared it. The #357 retro proposed the fix but, as a single occurrence
  below the recurring-scan ≥2 bar, it was never logged or applied — it fell
  through the crack.
- **Decision:** **applied** (audit, user-approved despite being single-occurrence).
  Added rule 5 to `.github/CODE_REVIEW.md`'s adversarial re-evaluation: a finding
  may not be downgraded/dropped on a factual claim about other code ("siblings
  don't", "handled elsewhere", "the convention is X") without **verifying that
  claim against the tree** (list the dir, read the sibling) first. Applies to both
  reviewers.
- **Rationale:** a verifier that confidently drops real findings on unchecked
  assumptions is the failure mode that keeps unsupervised success low; cheapest
  high-leverage reliability fix, and shares a root cause with the
  sibling-convention work above.
- **Reconsider when:** n/a (applied; additive and low-cost).

### 2026-06-30 — Document /deliver's async/queued capability; recommend against routinising it · applied

- **Pattern:** queued/headless `/deliver` is ~90% built (`auto` panel, worktree
  isolation, Phase 0.5 GC, the `TaskCreate` ledger, the CCR `create_trigger` +
  `integration-failure.yml` precedent) but undocumented; a naive fresh-session
  trigger would die at Phase 0's AC gate (no conversation history) or stall on an
  absent user-scoped MCP.
- **Decision:** **applied** (audit, user-approved). Added an "Async / queued
  invocation" section to `/deliver`: possible via `/deliver auto` from a CCR
  trigger / `/schedule`; the **full plan + ACs must be inlined in the trigger
  prompt**; user-scoped MCP (`github`/`wiki`) may be absent (the `gh` fallbacks
  cover GitHub, wiki degrades silently); and **routine async feature delivery is
  explicitly not recommended** for this single-maintainer public-API package — the
  human merge gate is deliberate.
- **Rationale:** captures the real capability and its sharp edges in one place
  while recording the deliberate decision *not* to chase a fully-autonomous-to-PR
  model that's fleet-survival elsewhere and merely convenience here.
- **Reconsider when:** the contributor count grows beyond one, or repetitive
  cross-cutting migrations become common — then build a real async entry point.

### 2026-06-30 — Multi-deliverable plans: one /deliver run, several PRs (serial impl, concurrent watch) · applied

- **Pattern:** `/deliver` assumed one plan → one PR, so a plan that's a *program*
  of independent deliverables had to be force-fit into one PR (coupling unrelated
  review/risk) or split into separate manual invocations (losing shared plan
  context). Surfaced this session: the standardization-audit plan decomposed into
  one pipeline-hardening PR + three independent codebase fixes.
- **Decision:** **applied** (user-requested this session). Added a
  "Multi-deliverable plans — one run, several PRs" section + a Phase 0
  decomposition bullet: decompose into deliverables + a dependency graph (dependent
  = consumes a type/API/helper/file another introduces → sequenced; independent →
  own worktree/branch/PR; **unsure → sequence**). Execution is **serial implement**
  (one inline `/implement-plan` at a time), **concurrent watch** (background
  `/watch-pr` per open PR); the ready-to-merge gate reports the **batch**.
  Per-deliverable pipeline unchanged. Landed in `.claude/skills/deliver/SKILL.md`.
- **Rationale:** respects the single-threaded-conductor reality and the "implement
  is inline/visible" principle (so it doesn't fan out to silent subagents) while
  still giving N PRs per run + parallel CI — the honest win without pretending to
  parallelise compilation. Dependency-aware so it never opens a PR that can't stand
  alone.
- **Reconsider when:** the serial-implement bottleneck actually bites (many
  independent deliverables per run) — then revisit a "fan out to background
  `/deliver` sub-sessions" model (true parallel implementation, at the cost of
  inline visibility).

### 2026-06-30 — Error-idiom unification (`.invalidRating` → `.badRequest`) · rejected

- **Pattern:** the audit flagged two idioms for "caller passed an invalid
  argument" — string validators throw `.badRequest("…")`, rating validators throw
  the dedicated `.invalidRating` — and considered unifying them.
- **Decision:** **rejected** (audit). `.invalidRating` is a **public**,
  non-`@frozen` `TMDbError` case (documented in `HandlingErrors.md`, mapped in
  `ToolErrorMapper`, asserted in 6 test sites); merging it into
  `.badRequest(String? = nil)` is a **breaking** public-API change **and** trades a
  precise typed case for a stringly-typed one — net-negative. The cosmetic
  `throw TMDbError.X` vs `throw .X` style is left to SwiftFormat.
- **Rationale:** a breaking change that makes the API *worse* is not worth doing;
  the dedicated case is arguably the better pattern, so the "debt" framing was
  wrong.
- **Reconsider when:** a deliberate major-version bump is on the table for other
  reasons — then reconsider as part of a broader `TMDbError` review, never alone.

### 2026-06-30 — Align `Network` to `Company` (rename `homepage`, force `logoPath` non-optional) · rejected

- **Pattern:** the audit flagged `Company` and `Network` decoding the same
  homepage-URL / logo-path fields differently and considered making them identical.
- **Decision:** **rejected** for the *aligning* direction; the **non-breaking
  robustness subset is kept** as a separate codebase delivery. Renaming
  `Network.homepage`→`homepageURL` and forcing `Network.logoPath` non-optional are
  both **breaking**, and the `logoPath` change is **wrong-directional** —
  `Network.logoPath` is correctly `URL?` because the API omits it; forcing
  non-optional would make decoding throw. The valuable, non-breaking piece (give
  `Network.homepage` the empty-string→nil guard `Company` already has) is split
  into its own delivery. The opposite latent issue — `Company.logoPath` is a
  *required* decode that throws if `logo_path` is absent — is captured in
  `knowledge/tmdb-api-notes.md` and deferred (fixing it is breaking).
- **Rationale:** "make them consistent" would break public API and degrade decode
  resilience; only the non-breaking robustness improvement is worth doing now.
- **Reconsider when:** a major-version bump lets `Company.logoPath` become optional
  and the two models can be aligned deliberately.

### 2026-06-24 — "Fix every instance of X" deliveries: enumerate all sites up front · applied

- **Pattern:** for a delivery whose goal is "apply change C to every occurrence of
  pattern X", the sites get found **piecemeal across review passes** rather than
  enumerated up front. In #364 (encode every String-into-path interpolation + validate
  every public String input), the plan grep and `/security-review` each missed a
  *different* subset: Phase 3 code review found a 4th encode site (`ReviewRequest`),
  then the `claude-review` bot flagged three more unvalidated `String`-ID service
  methods. Each pass caught a subset; none enumerated the whole class. Echoes #361's
  coverage gap (one of N parallel cases — TV `withoutWatchProviders` — had only unit
  coverage), the same "incomplete enumeration of N parallel instances" shape.
- **Decision:** **applied** (user-approved in the Phase 6 scan). `/deliver` Phase 2:
  added a blockquote — when the plan's goal is "fix every instance of pattern X", do a
  single **type-driven sweep first** and list all sites in the test list before
  implementing; sweep by type (e.g. `grep 'path = "/.*\('` for String-into-path
  interpolations *and* scan public service signatures for `String`/`*.ID` params; `Int`
  IDs are safe) rather than eyeballing. Landed in `.claude/skills/deliver/SKILL.md`
  Phase 2 (PR #364).
- **Rationale:** piecemeal discovery means a grep keyed on the wrong signal silently
  finds a subset and the stragglers surface one at a time across code/security review —
  late, scattered, and easy to ship incomplete. One type-driven enumeration up front
  makes "did I get them all?" a single answerable question.
- **Reconsider when:** n/a (applied).

### 2026-06-24 — Verify checks positively (COMPLETED+SUCCESS on current tip), not "no failures" · applied

- **Pattern:** misreading a still-running required check as green. In #361 a
  filtered rollup (`select(.conclusion!="SUCCESS")`) omitted an `IN_PROGRESS`
  "Build and Test" (no conclusion yet ⇒ not a "failure"), and a stale passed copy of
  the same check from an earlier tip reinforced the false green — so `mergeStateStatus:
  BLOCKED` was wrongly attributed to the un-satisfiable code-owner self-review rather
  than the pending check. User caught it. Single occurrence, user-directed.
- **Decision:** **applied** (user-directed). `/watch-pr` §3: added "Verify check
  completeness explicitly — a running check is not a pass": assert nothing is
  `status!=COMPLETED`, require `conclusion==SUCCESS` per required check on the current
  tip, dedup stale per-tip duplicates, don't infer green from a `--watch` exit, and
  when `BLOCKED` rule out a pending required check before blaming a review/policy
  rule. Landed in PR #361.
- **Rationale:** "no failures" ≠ "all passed" — a pending check has no conclusion and
  slips through failure-filters; a false-green merge readiness call wastes a round
  trip and (here) produced a wrong root-cause diagnosis.
- **Reconsider when:** n/a (applied).

### 2026-06-24 — Post-gate pushes re-open the gate: re-sweep threads/checks after the last push · applied

- **Pattern:** declaring a PR "ready, 0 unresolved threads" off a snapshot taken
  *before* later pushes. In #361 the ready call was made in Phase 5, then Phase 6
  pushed the retro + a skill edit and the branch was updated with `main` — each push
  re-ran `claude-review`, which posted a **High** thread *after* the snapshot. The
  unresolved thread then **blocked the merge** (`required_review_thread_resolution`).
  Single occurrence (below the recurring-scan bar), but user-directed.
- **Decision:** **applied** (user-directed). `/deliver` Phase 6: added "Pushing the
  retro re-opens the gate — re-watch before merge" (return to the `/watch-pr` loop
  after the last post-gate push; "ready" is only true of the current tip).
  `/watch-pr` §2 Loop guard: added "Re-sweep after every push" making the per-push
  thread+check re-confirm explicit. Both landed in PR #361; logged here.
- **Rationale:** every push re-triggers the review bot and CI, so a pre-push "ready"
  is stale; cheap to re-sweep, and a missed Critical/High thread is a hard merge
  blocker, not advisory.
- **Reconsider when:** n/a (applied).

### 2026-06-24 — Phase 0.5 checkpoint: edit via worktree paths, verify the diff landed · applied

- **Pattern:** edits landing in the **main checkout** instead of the active
  worktree, masked by a green build/test that merely re-ran the *pristine* worktree
  and returned baseline counts. Recurred across two deliveries: **#359** (fanned-out
  generation subagents wrote to the main-checkout path) and **#361** (the conductor
  `Read` source files in Phase 0 *before* `EnterWorktree`, then `Edit`ed those
  now-stale main-checkout absolute paths). #359 was captured only as a `gotchas.md`
  note, never as a skill change — so it recurred.
- **Decision:** **applied** (user-approved in the Phase 6 scan). Added a bolded
  checkpoint at the end of `/deliver` Phase 0.5: after `EnterWorktree`, re-`Read`
  source before editing, and **verify `git status` shows the diff in the worktree
  before trusting the first green build** (empty diff + baseline counts = edits went
  to `main`); rescue via shared stash. Landed in `.claude/skills/deliver/SKILL.md`
  Phase 0.5 (PR #361). Also generalized the `gotchas.md` entry to cover the conductor
  variant and proposed+saved a cross-project wiki entry.
- **Rationale:** a green run that silently validated nothing is the most dangerous
  failure mode in an autonomous pipeline; a cheap `git status` check converts it from
  a late, confusing discovery into an immediate one.
- **Reconsider when:** n/a (applied).

### 2026-06-23 — Add a "update the personal wiki" step after the retro · applied

- **Pattern:** `/deliver` Phase 6 captured durable learnings into the
  project-specific `knowledge/` base and `skill-improvement-log`, but never fed
  the **personal `wiki`** (Adam's cross-project engineering knowledge) — so
  generalizable opinions/heuristics from a delivery weren't being kept where they
  carry to the next project. Surfaced when Adam asked, post-merge, "anything to
  update in my wiki?" and then "updating my wiki should be a step after the retro."
- **Decision:** **applied** (user-directed). Added an "Update the personal wiki
  (after the retro)" subsection to `/deliver` Phase 6: search first, propose via
  `propose_entry` (review-gated — never autonomous `add_entry`/`update_entry`),
  be selective (generalizable only; project-specific stays in `knowledge/`), and
  degrade silently if the `wiki` MCP is absent. Landed in
  `.claude/skills/deliver/SKILL.md` Phase 6.
- **Rationale:** the retro already distils the delivery's learnings, so it's the
  cheapest moment to lift the *generalizable* ones into the durable, cross-project
  store; gating on `propose_entry` respects the wiki tooling's approval model.
- **Reconsider when:** n/a (applied).

### 2026-06-23 — Hard checkpoint to consult swift-concurrency / swift-testing-expert · applied

- **Pattern:** in #359 the concurrency-sensitive work (an `NSLock`/`@unchecked
  Sendable` mock design, making 9 types `Sendable`) and the test authoring were
  hand-rolled, and `swift-concurrency` was only consulted when the **user**
  prompted — at which point it validated the design *and* caught a missing
  `@unchecked Sendable` removal-plan. `/implement-plan` §4 already mandated this,
  but the soft wording was easy to skip under delivery momentum, and `/deliver`
  only mentioned the skills passively ("as the work demands").
- **Decision:** **applied** (user-directed, so no Phase-6 approval gate needed).
  Strengthened `/deliver` Phase 2 into a **mandatory topic-triggered checkpoint**:
  invoke `swift-concurrency` the moment the change touches actors/`@MainActor`/
  `Sendable`/locks/`Task`/data-races (to *design*, not just debug), and
  `swift-testing-expert` when writing/structuring tests — including when the work
  is fanned out to subagents/Workflows. Extended to Phase 3 (run concurrency-
  sensitive findings through `swift-concurrency`). Landed in
  `.claude/skills/deliver/SKILL.md` Phase 2, PR #359.
- **Rationale:** the instruction existed but wasn't load-bearing; tying it to the
  *topic* (not "when stuck") and repeating it at the orchestrator level makes it a
  gate that's hard to skip, and explicitly covers the fan-out case this run missed.
- **Reconsider when:** n/a (applied).

### 2026-06-19 — Reconcile local `make ci` lint scope with CI · deferred

- **Pattern:** the local `make ci` lint gate and the authoritative GitHub CI lint
  gate disagree on what counts as a violation, so `make ci` mis-signals — twice
  now, in opposite directions. #347: local SwiftLint cached a **false green** on
  new files that CI's clean checkout failed. #349: local `make lint-markdown`
  lints `.claude/**` and went **red** on `.claude/skills/deliver/SKILL.md:347`
  (MD028), but CI's markdown job (`ci.yml:120`) lints only `README.md` + docc, so
  CI is green on it. Both stem from the two gates having different scopes/caches.
- **Decision:** **deferred** — surfaced to the user. The real fix is a **repo
  config** change (narrow the Makefile `lint-markdown` to match `ci.yml`, *or* add
  `.claude/**` to the CI markdown job and fix the pre-existing MD028), which is
  outside the Phase-6 scan's remit (it edits SKILL.md files, not the Makefile/CI).
  The #347 half is already mitigated in `/pr` (the `--no-cache` re-lint step).
- **Rationale:** a green CI sitting behind a red local `make ci` repeatedly costs
  a triage detour and risks a real local failure being dismissed as "just the
  scope thing". But the fix belongs in `Makefile`/`ci.yml`, not a skill, so it
  needs the user's call rather than an auto-applied skill edit.
- **Reconsider when:** the user aligns the two scopes in repo config (then close
  as applied), or the disagreement recurs a third time — at which point add an
  explicit "local lint-markdown over-covers `.claude/**`; a red there on a file
  not in your diff is a known local-only artifact" triage note to `/deliver`
  Phase 4 and `/pr` step 4 (a skill-level mitigation that *is* in remit).

### 2026-06-18 — Telemetry (phases completed + skills invoked) in retro · applied

- **Pattern:** retros captured friction but no signal on which skills fire, which
  phases run, or where sessions stop — leaving the recurring-pattern scan
  under-informed.
- **Decision:** added "Phases completed" + "Skills invoked" lines to the retro
  entry format (`/deliver` Phase 6 + `delivery-retros.md` header).
- **Rationale:** near-zero cost, additive, and builds the signal the scan needs
  over time.
- **Reconsider when:** n/a (applied).

### 2026-06-18 — Wiki get_context in Phase 0 · applied

- **Pattern:** the personal wiki (Adam's engineering knowledge) was never read by
  the pipeline — sophisticated tooling, but uncalibrated to how Adam thinks.
- **Decision:** Phase 0 now pulls relevant wiki context (best-effort, guarded "if
  the wiki MCP is available") to calibrate the approach before planning.
- **Rationale:** matches Adam's global "consult the wiki silently before
  non-trivial decisions". Worded to degrade silently off Adam's machine, since
  these skill files ship in the public repo.
- **Reconsider when:** n/a (applied).

### 2026-06-18 — Close the loop: this improvement log · applied

- **Pattern:** the Phase 6 scan proposed but had no memory of past decisions, so
  it would re-propose already-decided patterns.
- **Decision:** created this file; Phase 6 scan consults it first and records each
  decision after.
- **Rationale:** makes the recurring-pattern scan converge instead of looping.
- **Reconsider when:** n/a (applied).

### 2026-06-18 — Phase 0: verify review-originated findings against code · applied

- **Pattern:** a delivery originating from a code/source-review *finding* was
  acted on as if approved — strategy questions or a drafted plan preceded any
  check against the actual code, and the framing repeatedly turned out wrong
  (#340, #341, #343).
- **Decision:** added a Phase 0 precondition to treat a review-originated finding
  as a hypothesis and confirm it against the code (a quick `Explore` pass) before
  planning or asking strategy questions. Landed in `/deliver` Phase 0 (PR #348).
- **Rationale:** catches a mis-framed finding before it reaches the user.
- **Reconsider when:** n/a (applied).

### 2026-06-18 — `/review-plan` critics load Adam's heuristics · deferred

- **Pattern:** the three Opus critics apply generic Swift/TMDb standards, not
  Adam's specific engineering opinions.
- **Decision:** **deferred.** Not implemented.
- **Rationale:** the critics' value is adversarial *independence*; feeding them
  "Adam prefers X" risks confirmation over challenge, exactly when a critic is
  most useful.
- **Reconsider when:** scoped narrowly to "load durable *constraints*/ADRs the
  critics may cite" (never "load opinions to agree with"), and only after
  confirming wiki MCP reachability inside the review-plan Workflow.

### 2026-06-18 — File-based `.claude/deliver-state.json` ledger · deferred

- **Pattern:** the `TaskCreate` phase ledger is ephemeral; a long interrupted
  session has no durable recovery path beyond "read the ledger if it survived".
- **Decision:** **deferred.** Not implemented.
- **Rationale:** `TaskCreate` + the checkpoint commits + git history already give
  a real recovery path; a committed JSON state file adds PR noise (or, if
  gitignored, isn't on the branch for anyone else).
- **Reconsider when:** interruptions actually bite — and even then prefer the
  lighter "checkpoint the ledger into the PR description" over a new state machine.
