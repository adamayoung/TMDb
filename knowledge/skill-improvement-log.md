# Skill-Improvement Log

A durable record of every skill-improvement proposal raised by `/deliver`'s
**wrap-up recurring-pattern scan**, and the decision on it. Newest at the top.

**Why this exists:** the scan surfaces proposals and waits for approval.
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
  should resurface this — or `n/a` for applied entries. The scan reads this
  field to decide whether a settled *no* may be re-proposed.
```

Keep this five-field shape on every entry so the scan can parse the log
consistently — in particular **Decision** (status) and **Reconsider when** are the
two fields the dedup step keys on.

---

### 2026-07-29 — Tooling-runner report becomes a shape-based contract · applied

- **Pattern:** the four tooling skills had no handling for the *subagent* dying,
  as distinct from the build failing — every recovery clause presupposed a
  report existed, while "Do not run the build yourself" was unconditional. The
  documented fallback lived only in `knowledge/gotchas.md`, which no skill reads.
- **Decision:** callers branch on report **shape** — `Status: refused` (caller
  bug) → hard error, never a fallback; `passed`/`failed` → a real result;
  absent/malformed → void, re-invoke once, then `make -C <dir>` with disclosure.
  Refusals now emit `Directory:`/`Status:` too. Applied to the four skills and
  `tooling-runner.md`.
- **Rationale:** the first draft would have reclassified a *deliberate* safety
  refusal as void and fallen back silently — converting the loud caller-bug
  detector built after #397 into exactly the failure it was built to prevent.
  Shape is closed and checkable; a list of refusal strings is not.
- **Reconsider when:** n/a.

### 2026-07-29 — Live observation required before naming an integration cause · applied

- **Pattern:** `/diagnose-integration-failure` never mentioned `mcp__tmdb__*`,
  had no behaviour contract, and stated its "Likely cause" output contract
  *before* its steps — so causes were named from logs alone, against CLAUDE.md's
  standing "ALWAYS use the TMDb MCP server".
- **Decision:** shape-drift and stale-data causes carry an `observed:` line or
  are demoted to `unverified`; `/fix-integration-failures` re-runs the diagnosis
  **once** and then proceeds marked unverified. Transient and in-diff-regression
  causes are exempt. The redaction half is enforced **in
  `integration-failure.yml`**, not in prose.
- **Rationale:** the repo is public and the headless job pastes the diagnosis
  verbatim into an issue body with `TMDB_API_KEY` mounted and no MCP — so a
  "never paste the key" *rule* would have been decoration. Actions masks logs,
  not issue bodies, so the scrub belongs at the last hop.
- **Reconsider when:** n/a.

### 2026-07-29 — /review-changes reports real fan-out coverage · applied

- **Pattern:** the large path returned `dimensionsCovered` as a **static
  constant**, and a dead agent mapped to `[]` findings — so "nobody looked" and
  "nothing found" were byte-identical, in the tool meant to catch false greens.
- **Decision:** each dimension resolves to `{key, ok, findings}`; the return
  carries real `dimensionsCovered`, new `dimensionsMissing`, and `partial`. §3
  requires the coverage line on the large path only.
- **Rationale:** a prose rule could not have fixed this — the value it would
  have required was a constant. The gate had to move into the script. Derivation
  is in `.then` because a dead agent resolves to `null` rather than rejecting, so
  a `.catch` would never have fired.
- **Reconsider when:** n/a.

### 2026-07-29 — /fix-pr-checks diagnosis fans out at >=2 checks · applied

- **Pattern:** diagnosis is read-only and independent per check, but was always
  serial.
- **Decision:** fan out at two or more checks; single-check stays a direct Agent
  call. Every prompt carries `DO NOT BUILD OR RUN TESTS`; args are validated
  (`Array.isArray`) before any spawn; Haiku→Opus escalation is passed in via
  args since a Workflow cannot see attempt history.
- **Rationale:** review initially recommended cutting this outright — the routed
  skills mandate local reproduction, so N agents meant N concurrent builds in
  one worktree, and the args-string iteration failure once spawned ~281 agents.
  Both are fixable with guards rather than fatal, so it ships with them.
- **Reconsider when:** if a fan-out ever produces a concurrent build despite the
  clause, cut the unit rather than adding more prose.

### 2026-07-29 — Auto panel becomes three independent jurors in a script file · applied

- **Pattern:** the auto panel was prose-only (no tool, schema, model pin, or
  dead-agent rule) **and** methodologically empty: two of three verdicts were
  fixed by role before evidence was read.
- **Decision:** one round of three independent `opus`/`xhigh` jurors, free
  schema-validated verdicts, asymmetric tally (a dead panel is not a proceed),
  guards as literal `throw`s, Phase 11 removed from the delegable set. Lives at
  `.claude/workflows/deliver-panel.js`. ADR-0016.
- **Rationale:** a two-round advocates→jurors design was rejected as speculative
  generality — 5 agents × 6 decision points for a mode never exercised. The file
  placement is about **drift**, not tokens: an executed script cannot vary
  between invocations the way a re-authored one can, and drift in a decision
  procedure is a correctness bug.
- **Reconsider when:** the jurors are exercised by a real auto run and the tally
  proves too strict or too loose in practice.

### 2026-07-29 — Durable /deliver run state, and a sweep that actually enumerates · applied

- **Pattern:** four of eleven analysed sessions ended "partially achieved"
  because work outran the transcript; the ledger is explicitly non-durable; and
  the Phase 1 sweep listed a **CWD-relative** `.claude/worktrees/` that does not
  exist inside a worktree, so it silently swept nothing while passing.
- **Decision:** a run file at `.git/deliver/<id>.json` holding rubric,
  decomposition and content-hash stamps; the gate is a **data dependency**
  (Phase 6 reads the rubric from it, and a missing file or missing `reconciled`
  block is a hard stop); liveness from the lock **PID**, not a timeout; sweep
  scoped to `<main-root>/.claude/worktrees/` with removal keeping Phase 12's two
  proofs. ADR-0015.
- **Rationale:** the first design was blocked for data loss and a **circular**
  gate (a ledger task blocking the call that destroys the ledger). Each
  heuristic was replaced by a checkable fact; PID liveness and the stamp were
  verified empirically, and the stamp's first command form turned out to be a
  false green (`ls-tree` has no exclude pathspec, so both hashes were the empty
  blob).
- **Reconsider when:** resume is exercised by a genuinely interrupted run —
  none has been, so the resume path itself remains unproven.

---

### 2026-07-28 — Grade the rubric *before* capturing knowledge (#404) · applied

- **Pattern:** a **single** occurrence, logged deliberately — the third time
  this log has broken its own ≥2-recurrence bar (cf. the #398 release build and
  the #357 adversarial-drop rule). In #404 the capture phase ran first and
  committed a `tmdb-api-notes.md` entry whose whole argument was that
  `Company.Parent` did **not** need an empty-string guard. The next phase's
  independent grader then failed AC6 precisely because `Company.Parent` threw
  on an empty string, the design changed, and the just-committed entry had to
  be rewritten inside the same delivery. Capture records what was decided;
  running it before the last gate that can *change* the decision guarantees the
  occasional rewrite — and risks shipping a knowledge entry that contradicts
  the code it describes, which is the exact decay #403 had just finished
  cleaning out of the base.
- **Decision:** **applied.** Swapped the two phases in
  `.claude/skills/deliver/SKILL.md`: **Phase 6 is now Rubric verification** and
  **Phase 7 is Capture learnings**, with the header diagram, the four
  cross-references, and `references/auto-and-async.md` updated to match. Phase 7
  gains one sentence stating *why* it runs after the gate. Ordering is the only
  change — neither phase's content or contract is otherwise altered.
- **Rationale:** free to do, and it removes a whole class of rework rather than
  the one instance. Capture is the pipeline's memory; it should observe the
  final state of the delivery, not an intermediate one. Waiting for a second
  occurrence would mean knowingly shipping another self-contradicting entry to
  earn evidence already in hand.
- **Reconsider when:** n/a (applied). Note for readers of older entries: retros
  and log entries before 2026-07-28 refer to capture as "Phase 6" and grading as
  "Phase 7" — that was the numbering at the time.

### 2026-07-25 — `/deliver` Phase 3 must run a release build before declaring done (#398) · applied

- **Pattern:** a **single** occurrence, not a recurrence — logged deliberately.
  In #398 (the `TMDbIntelligence` extraction) implementation was declared
  complete on debug-green evidence: `swift build`, `swift build --build-tests`,
  2869 unit tests and 291 integration tests all passed. `swift build -c release`
  was never run, and it was **broken** — a `@testable import` inside the new
  non-test `TMDbTestFixtures` target, which only fails without
  `-enable-testing`. That is `make build-release`, `make ci`, and both CI
  *Build for Release* jobs. The code reviewer caught it; the pipeline did not.
- **Decision:** add a third hard checkpoint to `/deliver` Phase 3 — run
  `swift build -c release` before advancing. Applied in
  `.claude/skills/deliver/SKILL.md` (this PR), cross-referencing the
  `knowledge/gotchas.md` entry.
- **Rationale:** normally the scan waits for a pattern to recur, and the user
  was told this is single-occurrence before approving. It was accepted anyway
  because the cost is ~30 seconds, the failure class is **systematically
  invisible** to every other Phase 3 gate (all of which build with
  `-enable-testing`), and it is most likely exactly when `/deliver` is doing
  target extractions or visibility changes — the work where it matters most.
  Waiting for a second incident would mean shipping another red release gate to
  earn evidence we already have.
- **Reconsider when:** n/a (applied).

### 2026-07-24 — tooling-runner ran in the main checkout, not the worktree (#390, #397) · applied

- **Pattern:** the `tooling-runner` (Haiku) subagent behind `/build`,
  `/build-for-testing`, `/test` and `/integration-test` does not reliably
  inherit the conductor's CWD, so during a `/deliver` — which always runs in a
  worktree — a bare `make` executed against the **main checkout**. In #390 it
  built `main`'s pristine sources and misreported the first build; in #397 a
  delegated `swift test` returned *"no matching test cases found"* for suites
  that plainly existed in the worktree. Both times the workaround was to
  abandon the four skills and shell out via `Bash`, which makes them unusable
  in the situation they exist for. Raised as #390's "one improvement" and
  recurred verbatim one delivery later.
- **Decision:** **applied** — the four skills now pass
  `Package directory: <absolute CWD>` in the task, and `.claude/agents/tooling-runner.md`
  gains a *Working directory — required, and never assumed* section: refuse to
  run when no directory is supplied, verify `Package.swift` exists there, run
  everything via `make -C "<dir>"` (and `swift test --package-path` for scoped
  runs) with absolute log paths, and echo the directory used in the report. The
  stale "work around it by bypassing the runner" advice in
  `knowledge/gotchas.md` was replaced with the fix plus a way to spot a
  pre-fix report.
- **Rationale:** pinning the directory fixes the root cause; refusing to guess
  converts the remaining failure mode from a *convincing wrong answer* (green
  build, or zero tests found) into an explicit error. `make -C` was chosen over
  `cd` so no later command in the same shell can drift back to the wrong tree.
  Echoing the directory makes a wrong-tree run visible in the caller's context
  rather than only in a log path.
- **Reconsider when:** n/a (applied).

### 2026-07-08 — External-review fixes: worktree-safe flake fixing, PR-pinned watch, severity filter · applied

- **Pattern:** an external model review of the `/deliver` pipeline (not the
  wrap-up scan) surfaced three verified gaps: (a)
  `/fix-integration-failures` §3 said `git checkout main`, which fails from
  a `/deliver` worktree (`fatal: 'main' is already used by worktree …`) —
  the exact trap `/pr` already documents for its rebase, learned in one
  skill but not its sibling; (b) `/watch-pr` discovered "the current
  branch's PR", so a background watch could misresolve after the conductor
  moved to another deliverable's worktree; (c) `/review-changes`' fan-out
  script returned `medium: advisory` where `advisory` held medium **and**
  low findings, double-counting every low.
- **Decision:** **applied** (user-approved, 2026-07-08, this branch).
  `/fix-integration-failures` §3 branches off `origin/main` without
  checking out `main`, and mid-`/deliver` gives the fix its own worktree;
  `/watch-pr` §0 accepts a PR number argument that beats branch discovery,
  and `/deliver` Phase 10 passes it from the ledger; the `/review-changes`
  script filters `medium` by severity.
- **Rationale:** the orchestrator must not be more rigorous than the paths
  it calls — a routed flake fix that dies on `git checkout main`, or a
  watch bound to a branch the session has left, stalls an unattended run.
  Three other findings from the same review were assessed and not applied:
  a "missing `/security-review`" claim (false positive — it is a built-in
  Claude Code skill, and log entry 2026-06-24 shows it running), `/pr`'s
  post-review `/format` mutating Swift (defused by the PostToolUse
  format-on-edit hooks + `make ci`), and Phase 11 "undermining the one hard
  stop" (post-gate proposals don't block the deliverable).
- **Reconsider when:** n/a (applied); for the two rejected code-path
  findings — if a `reviewed`-mode `/pr` ever produces a non-formatting
  Swift diff, or a run genuinely blocks on a Phase 11 approval, revisit.

### 2026-07-05 — Knowledge consult at entry + independent rubric grader · applied

- **Pattern:** an external article-driven review of the pipeline (not the
  wrap-up scan) found two gaps: (a) a **consult gap** — `knowledge/` is
  written every delivery (Phase 6) but never read at entry, leaving the
  advisory CLAUDE.md "skim the relevant file" rule silently skipped; and
  (b) the Phase 7 rubric was graded by the **conductor that implemented the
  work** — the one gate without the independent-verifier discipline the rest
  of the pipeline is built on.
- **Decision:** **applied** (user-directed, 2026-07-05, PR #384). Phase 0
  gains a ledger-checkable knowledge-consult step (`consulted:` line);
  Phase 7 splits by weight — full-weight grading is delegated to one
  independent subagent given only the rubric + committed work (lite stays
  inline; grader failure falls back inline and is noted — a dead grader is
  not a pass).
- **Rationale:** memory that isn't read at entry doesn't compound; a maker
  grading its own rubric is the self-critique failure mode the pipeline's
  critics/skeptics already design against.
- **Reconsider when:** n/a (applied).

### 2026-07-05 — Legitimize inline knowledge capture for small in-flight entries · applied

- **Pattern:** five consecutive deliveries (#366, #368, #374, #382, #383)
  captured knowledge **inline** instead of invoking `/capture-knowledge`,
  each time flagged as a benign deviation — small entries (a gotcha, a log
  entry) authored *during* implementation gain nothing from the full skill
  pass.
- **Decision:** **applied** (user-approved at the #382/#383 gate). The
  capture phase of `/deliver` now allows: one or two small entries already
  authored during implementation may be committed inline, noted in the
  retro. Landed in `.claude/skills/deliver/SKILL.md` (PR #383).
- **Rationale:** the deviation was the de-facto convention and consistently
  harmless; legitimizing it stops every retro re-flagging it, while the full
  skill pass stays the default for real candidate lists.
- **Reconsider when:** inline captures start skipping the dedup/curation the
  skill provides (duplicate or low-signal `knowledge/` entries traced back to
  inline capture).

### 2026-07-05 — Retro moved pre-PR: routine post-gate push loop eliminated · applied

- **Pattern:** every delivery pushed the retro to the PR branch **after** the
  ready-to-merge gate, re-triggering `claude-review` + the full CI matrix and
  mandating a re-watch pass — ~5–7 min of CI plus a re-review per run to land a
  markdown file. Bit hard on #361 (a post-gate push raised a High thread that
  blocked the merge); paid silently on every delivery since. The applied
  2026-06-24 "re-sweep after every push" rule treated the symptom, not the
  sequencing.
- **Decision:** **applied** (user-approved plan, this delivery). `/deliver` now
  writes the retro in a new **Phase 3.7 (pre-PR)** so it rides the delivery's
  own PR (entry headed with the branch name; the PR number is backfilled at
  Phase 4 creation, pre-gate). Phase 6 became **wrap-up** (wiki +
  recurring-pattern scan), with the retro **amended post-gate only for a
  noteworthy watch-phase event** (optional `watch:` line). The re-watch rule
  remains for the exceptions (amendments, approved skill edits). Landed in
  `.claude/skills/deliver/SKILL.md`, `CLAUDE.md`,
  `knowledge/delivery-retros.md` (header), `knowledge/README.md`, and
  `.claude/skills/watch-pr/SKILL.md` §2.
- **Rationale:** the root cause was ordering, not the re-watch rule — with the
  retro committed pre-PR, the default path has **zero** post-gate pushes, so
  the gate is never re-opened by the pipeline's own bookkeeping.
- **Reconsider when:** watch-phase learnings routinely turn out noteworthy
  enough that the amendment path fires on most deliveries — then revisit
  deferring watch-phase learnings to the *next* delivery's retro instead.

### 2026-07-02 — Haiku build/test subagents misread xcsift toon `errors[]` as failure (#374) · applied

- **Pattern:** the DocC `.docc` "unhandled file" package-load warning lands in
  xcsift's toon `errors[]` array (with `null,null` coordinates) and makes it print
  `status: failed`, even though `swift build`/`swift test` **exit 0** (the DocC
  plugin only loads under `SWIFTCI_DOCC=1`). During the #374 delivery a Haiku
  `/build-for-testing` subagent keyed off that array and reported the build
  **failed** — a false negative that cost a diagnostic cycle. First occurrence,
  surfaced and fixed the same run at the user's direct request (not via the
  recurring-pattern scan).
- **Decision:** **applied** — added a "trust the exit status, not xcsift's toon
  summary / `status:` field" caveat to all four build/test skill prompts
  (`/build`, `/build-for-testing`, `/test`, `/integration-test`) in #374, naming
  the benign `.docc` unhandled-file entry explicitly. Root cause also captured as a
  gotcha (`knowledge/gotchas.md`, same PR).
- **Rationale:** the prompts already said "check the exit status" but never warned
  that xcsift's structured error list can carry a benign package-load warning, so
  the agent trusted the list over the exit code. Naming the specific false-alarm
  removes the ambiguity without weakening real-failure detection.
- **Reconsider when:** n/a (applied).

### 2026-06-30 — Ledger fragility recurred (#364, #368): re-create it inside the worktree · applied

- **Pattern:** the `TaskCreate` phase ledger (Contract §6) is CWD-scoped and is
  cleared by `EnterWorktree` (and, in #368, reset again mid-run by an MCP
  reconnect / plan-mode exit), so the durable phase ledger keeps getting lost —
  #364 (lost on EnterWorktree) and #368 (lost twice).
- **Decision:** **applied** (user-approved, from the #368 Phase 6 scan). Took the
  **lightweight** path the deferred *2026-06-18 file-based ledger* entry called
  for, not a new state machine: `/deliver` Phase 0.5 now says to (re-)create the
  ledger *inside* the worktree after entering, and to re-create it from the phase
  list if a later phase finds it empty. Landed in `.claude/skills/deliver/SKILL.md`
  Phase 0.5.
- **Rationale:** matches that entry's "reconsider when interruptions actually bite
  — prefer the lighter fix"; a re-create instruction costs nothing and stops a
  reset ledger being mistaken for lost work. The heavy committed-JSON option stays
  rejected.
- **Reconsider when:** the re-create instruction proves insufficient (resets lose
  in-flight decisions not reconstructable from the phase list) — then revisit
  "checkpoint the ledger into the PR description".

### 2026-06-30 — Fast-gate over-matched `.github/`: narrow to `.github/workflows/` · applied

- **Pattern:** the `/pr` docs/config fast-gate detector treated **any** `.github/`
  change as build/CI-affecting (`^\.github/`), so a pure docs change under
  `.github/` — e.g. `.github/CODE_REVIEW.md` in #368 — forced the **full** `make
  ci` (live integration suite included) for a markdown-only diff. The "full gate
  for a no-logic change" friction recurred across #340/#343/#344/#363 and #368.
- **Decision:** **applied** (user-approved). Narrowed the detector's `^\.github/`
  → `^\.github/workflows/` (and the prose `.github/**` → `.github/workflows/**`)
  in `.claude/skills/pr/SKILL.md` step 4 — only workflow files affect CI. Safe
  because the PR's own CI always runs the full matrix regardless; the fast gate
  only trims the *local* run.
- **Rationale:** `.github/CODE_REVIEW.md` and issue/PR templates don't affect
  `swift build`/`test`/docs, so they shouldn't trip the full gate; an obscure
  CI-affecting change is still caught by the PR's own CI.
- **Reconsider when:** the repo adds composite actions under `.github/actions/`
  the local gate should exercise — then widen the pattern to include them.

### 2026-06-30 — `/pr` "skip steps 4–6" off-by-one would skip the mandatory gate · applied

- **Pattern:** `/pr`'s mode preamble said `reviewed`/no-Swift should "**skip steps
  4–6**", but **step 4 is the mandatory `make ci` gate**; the skippable review
  steps are 5–7 (and are correctly annotated as such per-step). Taken literally
  the preamble would skip the gate CLAUDE.md mandates before every PR. Found during
  #368 — a single occurrence, but a correctness bug, so logged despite being below
  the recurring-scan ≥2 bar.
- **Decision:** **applied** (user-approved). Changed both "skip steps 4–6"
  occurrences to "skip steps 5–7" in `.claude/skills/pr/SKILL.md`.
- **Rationale:** the gate is never optional; the preamble must agree with the
  per-step annotations so a future literal reading can't skip `make ci`.
- **Reconsider when:** n/a (applied).

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

### 2026-06-19 — Reconcile local `make ci` lint scope with CI · applied

- **Pattern:** the local `make ci` lint gate and the authoritative GitHub CI lint
  gate disagree on what counts as a violation, so `make ci` mis-signals — twice
  now, in opposite directions. #347: local SwiftLint cached a **false green** on
  new files that CI's clean checkout failed. #349: local `make lint-markdown`
  lints `.claude/**` and went **red** on `.claude/skills/deliver/SKILL.md:347`
  (MD028), but CI's markdown job (`ci.yml:120`) lints only `README.md` + docc, so
  CI is green on it. Both stem from the two gates having different scopes/caches.
- **Decision:** originally **deferred** (the fix was a repo-config change, outside
  the Phase-6 scan's remit) and **closed as applied on 2026-07-28** — the two
  scopes are now identical: `Makefile:47–49` and `.github/workflows/ci.yml:122`
  both lint `README.md`, `CLAUDE.md`, `**/*.docc/**/*.md`, `.claude/**/*.md`.
  The #347 half was already mitigated in `/pr` (the `--no-cache` re-lint step).
- **Rationale:** a green CI sitting behind a red local `make ci` repeatedly cost
  a triage detour and risked a real local failure being dismissed as "just the
  scope thing". Aligning the two scopes in repo config removed the class.
- **Reconsider when:** n/a (applied). *Closed retroactively by the 2026-07-28
  knowledge-base audit — the closure condition had been met by an earlier config
  change and nobody came back to close it. A stale `deferred` in this file is a
  live defect: the scan reads it as the current state of a settled question.*

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
