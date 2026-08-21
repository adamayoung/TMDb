<!-- markdownlint-disable-file MD001 -->
<!-- Entries are dated `###` headings under the H1 with no `##` sections —
     the flat newest-first log shape documented in README.md and in the
     format block below. MD001 (heading-increment) would require inventing
     `##` sections this file does not have. Scoped here, not disabled repo-wide. -->

# Skill-Improvement Log

A durable record of every proposal raised against this repo's own tooling, and
the decision on it. Newest at the top. Two producers write here:

- **`/deliver`'s wrap-up recurring-pattern scan** — proposals to change a skill.
- **`/review-knowledge`** — audit findings that were **refuted**, and any
  finding accepted as a standing exception rather than fixed. It also appends a
  one-line **run record** per audit (see below) — telemetry, not a proposal.

**Why this exists:** both producers surface candidates and wait for approval.
Without a memory of past decisions they re-raise what is already **applied** or
deliberately **deferred/rejected/refuted** — wasting attention and re-litigating
settled calls. Both **consult this log before raising** and skip anything
already decided here. Record the *no*s with their evidence: the *no*s are what
stop the loop repeating itself.

**Refutations must live here, not in a PR body.** A refutation recorded only in
a PR description is invisible to the next audit, which then re-raises it cold —
observed on 2026-08-13, when a finding refuted in #444 came back on the very
next run because `grep -rn "refut" knowledge/` found nothing.

Status values: **applied** · **deferred** · **rejected** · **refuted**.

Format per entry:

```text
### <date> — <short title> · <applied|deferred|rejected|refuted>
- **Pattern:** what kept recurring (and the retro entries it appeared in), or —
  for a refutation — what was claimed and where.
- **Decision:** what was agreed, and where it landed (skill + commit/PR) if applied.
- **Rationale:** one or two sentences — why this call. For a refutation, the
  evidence from the tree that disproves the claim, not an opinion.
- **Reconsider when:** (deferred/rejected/refuted only) the condition under which
  the producer may resurface this — or `n/a` for applied entries. Both the
  wrap-up scan and `/review-knowledge` read this field to decide whether a
  settled *no* may be raised again.
```

Keep this five-field shape on every entry so the scan can parse the log
consistently — in particular **Decision** (status) and **Reconsider when** are the
two fields the dedup step keys on.

**One sanctioned exception — `/review-knowledge` run records.** Every audit
appends a single dated line, whatever it found:

```text
### <date> — /review-knowledge run · <N> agents · <T> tokens · <c> critical / <m> major / <n> minor
```

It carries no **Decision** and no **Reconsider when**, so **the dedup scan skips
it**: it is telemetry, not a settled call, and there is nothing for a producer to
re-raise. It exists because
[ADR-0020](decisions/0020-review-knowledge-audit-tier.md)'s revisit trigger
compares the finding counts of two *consecutive* runs — and a run that finds
nothing would otherwise leave no trace at all. The shape is fixed precisely so
those two runs stay comparable.

---

### 2026-08-21 — The run file lives where the worktree guard forbids writing (#490) · deferred

- **Pattern:** `/deliver`'s run file is specified to live at
  `.git/deliver/<id>.json` — deliberately, so it cannot enter a diff and
  survives `ExitWorktree(remove)`. But a worktree-isolated session's `Bash`
  guard refuses any command it cannot statically prove stays inside the
  worktree, and `.git/` is outside it **by design**. So every run-file write
  fights the guard. The friction appears in **four** retro entries
  (`delivery-retros.md`: #432, #476, #486, and this delivery), and #432 states
  the contradiction outright — *"its run-file location is at odds with its
  worktree isolation"*. It is not in this log, so it has recurred four times
  without ever being raised as a proposal.

  The failure is not a hard block — it is a tax. The refusal message asks you to
  "split it into plain, separate commands", so each write becomes write-a-script
  then run-it, and long heredocs are refused where shorter writes to the same
  path succeed (it keys on complexity, not permissions). This delivery paid it
  roughly six times: every `stamps` update, the reconcile record, the rubric,
  and the plan file. `worktree-lifecycle.md` already documents the workaround —
  a fully literal path with a single-purpose command — which is evidence the
  friction is known and has been absorbed rather than fixed.

- **Decision:** **deferred — raised unattended, needs review.** This run was
  `/deliver auto next`; Phase 11 is not a delegable decision point, and a
  proposal that would edit the pipeline's own skills must not be applied by an
  unattended run.

- **Rationale:** four recurrences without a log entry is exactly the shape this
  log exists to stop — each delivery re-derives the same workaround from
  scratch. Three shapes are worth weighing, and the choice is a real judgement
  rather than an obvious fix: (a) keep the location and make the workaround
  first-class — a tiny `Scripts/deliver-runfile.py` with a fixed literal path
  that the guard accepts, called by every phase that stamps; (b) move the file
  inside the worktree and accept losing the batch/teardown survival properties
  ADR-0015 chose it for; (c) leave it, and treat the tax as the cost of the
  isolation guarantee. (a) looks cheapest and preserves the ADR's reasoning, but
  it adds a script to the reflexive set.

- **Reconsider when:** a human reviews this entry, or the guard's behaviour
  changes such that `.git/`-adjacent writes stop being refused.

### 2026-08-20 — Prove an absence-shaped test fails without the fix (#469) · deferred

- **Pattern:** the **False green** family, in its absence-assertion form. When a
  fix means "this value must no longer appear", every test asserts a negative —
  and a negative passes just as happily when the value was never there, when the
  key was renamed upstream, or when the code path is not reached at all. Nothing
  in `/deliver` asks for the one check that distinguishes "the fix works" from
  "the test cannot tell": revert the fix and watch the tests go red. In #469 I
  ran it by hand, on instinct, and it was the single most informative minute of
  the delivery — two wiring tests went red, which is the only reason their green
  meant anything. The family recurs throughout this log (a `ls-tree` hash where
  "found" and "nothing found" were byte-identical; a cached SwiftLint false
  green; a check re-read from an earlier tip) and heads `gotchas.md`, but every
  instance so far has been caught after the fact rather than by a step.
- **Decision:** **deferred — raised unattended, needs review.** Nothing applied.
  The candidate is a Phase 3 checkpoint for redaction/absence-shaped work:
  before declaring implementation done, unwire the fix, confirm the new tests
  fail, restore. Scope is the open question — a blanket rule would be noise on
  the many deliveries whose assertions are positive, so it likely wants a
  trigger ("the acceptance criteria are phrased as *X no longer appears*")
  rather than an unconditional step.
- **Rationale:** raised by an autonomous `/deliver auto` run, which must not
  edit the pipeline's own skills without review. Recording it here rather than
  applying it is the Phase 11 contract for auto mode.
- **Reconsider when:** Adam reviews this entry — or when a second delivery whose
  fix is an absence ships a test that would have passed without the fix, which
  would make the trigger condition concrete rather than hypothetical.

### 2026-08-14 — Review granularity keys on risk surface, not diff shape · applied

- **Pattern:** two entries raised the same conflict from opposite directions.
  #451 (2026-08-13) asked to "scale Phase 2 and Phase 4 by **diff shape**, not
  weight alone" — a reflexive prose change paid for fan-out breadth sized for a
  multi-service Swift diff. #461 (2026-08-14) hit the converse: `/deliver`
  Phase 4's "**Lite / single-unit** → one review of the full diff" would have
  routed a single-unit **concurrency** fix to one reviewer despite `full`
  weight, and `/review-changes` §1 independently decides on size alone with
  "when unsure, prefer small". The two clauses disagree precisely on the
  small-but-risky diff, which is the dangerous case.
- **Decision:** applied. `deliver/SKILL.md` Phase 4 now reads **Lite** (not
  "Lite / single-unit") and states that a small diff does not downgrade a `full`
  review, since "single-unit" is one of lite's *conjunctive* conditions rather
  than an alternative to it; it also tells the conductor to pass the weight to
  `/review-changes`. `review-changes/SKILL.md` §1 gains a **Risk overrides
  size** rule: take the fan-out however small the diff is when the caller says
  `full` or the diff touches concurrency, networking/`HTTPClient`,
  `Decodable`/`CodingKeys`, or new public API — and never re-derive from
  `--stat` a judgement the caller already made.
- **Rationale:** size decides how much there is to read; the risk surface
  decides how many lenses have to read it. This repo's concurrency defects are
  the ones that survived a single pass — #401's two tests were wrong by
  construction and found by review after green, #433's UB passed everything on
  macOS and segfaulted on Linux, and #461's residual gate hang was found by a
  second lens after three deliberate precautions. #451's direction is served by
  the same rule: weight already keys on risk, so a small reflexive change keeps
  the critics without inheriting a Swift-sized fan-out.
- **Reconsider when:** n/a (applied). If the fan-out starts firing on small
  low-risk diffs, the fix is the risky-surface *list*, not a return to sizing by
  diff shape.

### 2026-08-14 — Gate the code samples: a prose call-form checker · applied

- **Pattern:** a stale API call in an uncompiled code sample, for the **third**
  time. #359 (a cross-module DocC break), #452 (a stale `search("…")` fixed in
  `README.md` while the identical call survived in two `.docc` articles), and now
  #459, whose own sweep found `README.md` documenting
  `tmdbClient.search.multi(query:)` — a method that has never existed in
  `Sources/`. Each was found by a reviewer or an incidental grep; none by a gate.
- **Decision:** **applied** — `Scripts/check-prose-call-forms.py`, wired into
  `make lint` (`lint-prose`) and mirrored as the `Prose call-form check` step in
  the CI `Lint` job, with `README.md` added to the `swift` paths filter. It
  resolves every `<service>.<method>(<labels>)` in a ```` ```swift ```` fence in
  `README.md` and `**/*.docc/**` against the real API, by name *and* labels.
  Shipped in #460 alongside the `search.multi` fix (issue #458).
- **Rationale:** the previous entry (2026-08-13, below) named this exact trigger
  — *"if this recurs a third time, the enforceable version is narrower"* — and
  chose a checklist step instead because a general "did you grep?" is not
  mechanisable. This is the narrower version, and it turned out cheaper than the
  fence-compiling approach that entry imagined: anchoring on `TMDbClient`'s own
  service properties is what keeps it quiet, since a sample also calls
  `voteAverage.formatted()` and `task.cancel()`, which are not ours to check.
  Two design points earned their keep immediately — a local binding **shadows** a
  service of the same name (`let watchProviders = try await …` then
  `.first(where:)`) which was the only false positive, and parsing whole fences
  rather than line by line nearly doubled coverage (44 → 83 call forms), because
  the wrapped multi-line calls that a line scanner silently skips are exactly the
  ones with the most arguments to get wrong.
- **Reconsider when:** n/a (applied). If it ever produces a false positive, the
  fix is a narrower receiver rule, not a wider skip — a skip here is invisible by
  construction, which is the failure this replaced.

---

### 2026-08-13 — Enumerate Swift sites with the LSP, not `grep` · applied

- **Pattern:** the fourth instance of the partial-sweep family, and the one the
  three existing rules cannot reach — the sweep was performed with the **wrong
  instrument**. ADR-0008 recorded a discovery recipe for future readers:
  `grep 'path = "/…\(stringVar)"'`. That pattern is single-line, so it missed
  three request builders whose `let path =` sat on its own line — four sites
  recorded, **eight** actual, and the three it missed interpolated a
  bearer-like guest session id raw for two months (issue #421, fixed in #453).
  The #364 retro had already recorded the right lesson ("one type-driven
  enumeration up front") and it *was* applied to `/implement-plan` — but the
  ADR, which is the artifact the next person actually opens, kept the grep.
  Adam then asked whether anything instructs using the Swift LSP: the
  preference existed only in session **memory**
  (`feedback-prefer-lsp-swift-navigation`, recorded 2026-08-11 at his request)
  and appeared in no `CLAUDE.md`, skill or knowledge file — so it went unused
  for an entire delivery, including for the very sweep it would have fixed.
- **Decision:** **applied**, at Adam's explicit request, in three places so the
  rule sits where it is executed rather than where it is remembered:
  `CLAUDE.md` → *Navigating Swift: prefer the LSP over `grep`* (read by every
  session and every subagent); `/implement-plan` Step 1 → *Enumerate by symbol,
  not by text*, adjacent to the existing type-driven-sweep guidance; and
  `/deliver` Phase 3's "fix every instance of pattern X" checkpoint, so the two
  copies of that rule do not drift.
- **Rationale:** `grep` answers "what text appears where"; the LSP answers "what
  does the compiler think this is" — and for "find every site that does X" only
  the second is trustworthy. The failure mode is the **False green** family: a
  text sweep that under-reports looks exactly like a clean one. Memory was the
  wrong home because memory surfaces as background context while a skill step is
  a thing that gets followed; the same "recorded somewhere other than the
  artifact people follow" shape as the ADR-0008 grep itself.
- **Reconsider when:** n/a (applied). Note it is prose, not an enforced gate —
  nothing fails if a future sweep uses `grep` anyway. If a text-pattern sweep
  under-reports a **fourth** time, the enforceable version is narrower than a
  general rule: for a named "every instance of X" task, require the enumeration
  to be pasted into the test list with its source (LSP query vs grep), so the
  instrument is visible in review rather than inferred.

---

### 2026-08-20 — Mutation-check a reflexive delivery's anti-drift tests · deferred

- **Pattern:** a **fifth** instance of the partial-sweep family, but with a new
  twist that none of the four existing rules reach: in PR #482 the sweep *was*
  performed and the executable check *was* added — and the check was **blind**.
  Three assertions passed while testing nothing (a line window bleeding into the
  neighbouring bullet; a string-replace that updated a docstring but not the
  regex it described; narrative prose about a past drift supplying the very
  token under test). Two only broke once deliberately broken. Meanwhile rounds 2
  and 3 of the review each found defects **in the previous round's fixes**, so
  Phase 4's 3-iteration cap was measuring the wrong thing.
- **Decision:** **deferred — raised unattended, needs review.** `/deliver auto`
  must not edit and push the repo's own skill files, so no skill file was
  touched. Filed as issue #485 with the fix sketch instead, so the proposal is
  actionable rather than only logged.
- **Rationale:** the four existing sweep rules all assume that *doing* the sweep
  is the hard part. This class is different — the sweep was done and encoded in a
  test, and the test was the thing that lied. The countermeasure is cheap
  (revert each guarded rule, demand red, confirm the baseline is green) and it is
  the only evidence that separates "fixed" from "looks fixed" when the deliverable
  is prose. Recorded in `knowledge/gotchas.md` → *A test that asserts on prose can
  be blind* with the worked matrix.
- **Reconsider when:** Adam reviews issue #485. Keep it scoped to
  `reflexive: true` deliveries that add or change a prose-asserting test —
  widening it to every delivery would demand a mutation pass on Swift suites,
  where the compiler and `--Werror` already do this work.

---

### 2026-08-13 — Grep for a changed string's siblings before calling it done · applied

- **Pattern:** partial sweeps keep recurring, but **outside the scope of the two
  rules that already address them**. The reflexivity gate's footprint sweep
  covers `.claude/` diffs (#441-#446, the entry below); `/implement-plan`'s
  type-driven enumeration covers a task *framed* as "fix every instance of X"
  (#364, #410). Neither covers an **incidental** one-line fix in ordinary feature
  work: #452 corrected a stale `search("…")` → `search(matching:)` sample in
  `README.md` and left the identical call in `TMDbIntelligence.docc` **and**
  `TMDbIntelligenceTesting.docc`, both found by code review rather than the
  author. #359 is the same shape caught earlier (a cross-module DocC break found
  pre-replication).
- **Decision:** **applied** — a new step 3 in `/implement-plan`'s *Done — when
  the test list is empty* checklist: changed a literal string, symbol name or
  code sample, grep the tree for the **old** text before declaring done, with
  `**/*.docc/**` and `README.md` named as the blind spot. Shipped in #452
  alongside the delivery that surfaced it.
- **Rationale:** the mechanism is that **no gate compiles a code sample** —
  `make build-docs` compiles the DocC catalog, not the Swift inside a fence, and
  `markdownlint` does not read it either — so a stale sample is invisible to CI
  by construction and only a reader or a reviewer ever finds it. The two existing
  rules are both scoped to work the author already knows is a sweep; this class
  is the one where they *don't* know it, which is why a third, cheaper check
  earns its place rather than widening either of the others.
- **Reconsider when:** n/a (applied) — and **superseded on 2026-08-14**, when it
  recurred a third time (#459) exactly as anticipated. The checklist step stays;
  it is now backed by the enforced gate described in the entry above, which
  resolves each sample's call against the real API rather than compiling the
  fence.

---

### 2026-08-13 — `/review-knowledge` audit tier drops to Opus; cross-examination stays Fable · applied

- **Pattern:** the 2026-08-07 addendum to ADR-0014 pinned `/review-knowledge`'s
  auditors to a Fable-class model on *expected* verification depth, never on
  measured yield. At $10/$50 per MTok against Opus's $5/$25, and with eight
  agents per run (four auditors plus a four-agent cross-examination), a periodic
  prose audit had become the most expensive configuration in `.claude/`.
- **Decision:** **applied** (user-approved). Audit round → `opus`; the
  cross-examination round **stays** Fable-class. `effort` unchanged at `high` on
  both. Recorded as [ADR-0020](decisions/0020-review-knowledge-audit-tier.md),
  which amends ADR-0014 *in part* — the Haiku/Sonnet/Opus mappings and the
  rejection of Fable `/review-plan` critics are untouched. The addendum's
  "two audit critics" miscount was corrected in place as a factual error.
- **Rationale:** the rounds are not symmetric. A missed finding is re-derived
  next run; a wrong *refutation* is written to this log and makes every later
  audit drop that finding without re-deriving it — durable, self-concealing
  suppression. So the cheap tier goes where mistakes are recoverable, and the
  top tier stays where they are not. Three plan critics separately killed an
  earlier draft that also moved `high → xhigh`: thinking bills as output at 5×
  input, so moving two variables at once would have made the saving
  unmeasurable and left a regression with two suspects.
- **Reconsider when:** two consecutive `/review-knowledge` runs return zero
  `major`-or-`critical` consensus findings while the tree has demonstrably moved
  (check `delivery-retros.md` for intervening deliveries that changed build
  config, target layout or the skills). Also revisit if the projected ~25% saving
  fails to appear once a run at the new tier is recorded.

### 2026-08-13 — Conditional Fable escalation for `/review-plan` critics · deferred

- **Pattern:** proposal to give `/review-plan`'s three critics a Fable-class
  tier when a plan is "complex", keeping Opus otherwise — raised alongside the
  audit-tier change above, and reviewed by the three-critic pass.
- **Decision:** **deferred**, before implementation. `/review-plan` and
  `/deliver` Phase 2 were left untouched; filed as issue
  [#450](https://github.com/adamayoung/TMDb/issues/450) against ADR-0014's
  existing revisit trigger.
- **Rationale:** three independent failures. (1) It delivers none of the stated
  goal — the default path is today's behaviour and the escalated path costs
  *more*. (2) The trigger, expressed in the lite/full rule's risky-surface
  vocabulary, is Swift-only, so it could never fire for a reflexive `.claude/`
  change — the very class this repo's defect record is made of (see the Phase 0
  reflexive rule and PRs #441-#447). (3) Splitting `full` into
  full-because-risky and full-because-large is a third scaling shape, colliding
  with the 2026-08-07 decision that the weight vocabulary stays binary. A fourth,
  smaller point: the flag defaulted silently, so a forgotten escalation would
  have been indistinguishable from a correct cheap run.
- **Reconsider when:** ADR-0014's own trigger fires — an Opus critic pass misses
  a blocker that later ships as a defect — *and* the escalation is expressed as
  a pointer to the weight rule rather than a copy of it, with the selected tier
  logged and recorded in the run file so a missed escalation is visible.

### 2026-08-13 — Full pipeline audit: 39 findings across five PRs (#441-#446) · applied

- **Pattern:** a full review of `CLAUDE.md`, all 21 skills, the 3 agents and
  `knowledge/` — then a `/review-knowledge` run over the result. The recurring
  shape was not any one defect but **a fix scoped to the file in front of it**:
  a rule changed in a `SKILL.md` while the `references/` that `SKILL.md` points
  at kept teaching the superseded version. `deliver/references/worktree-lifecycle.md`
  absorbed three of those (the forbidden `swept:` key, the superseded
  settings-file copy, a schema missing the field Phase 0 was told to write), and
  `/review-knowledge` itself shipped widened in prose with its Workflow still
  scoped to `knowledge/` alone.
- **Decision:** **applied** across #441 (5), #442 (11), #443 (P3s +
  `.worktreeinclude`), #444 (13, three of them regressions of #441-#443), #445
  (agent denylists + `knowledge/` markdown lint) and #446 (the
  worktree-lifecycle drift + a refutation memory). Durable countermeasures, as
  opposed to the individual fixes: the reflexivity gate's third consequence
  (**sweep the rule's whole footprint by grepping the *old* wording**), the
  `consulted:`/`reconciled:`/`swept:` key split, `force-review` so a
  skills-only diff is still reviewed, `disallowedTools` on `code-reviewer` and
  `tooling-runner`, and `knowledge/**` under the markdown gate.
- **Rationale:** the individual defects were cheap; the *class* was not. Three
  consecutive audits each found the previous one's fix incomplete in the same
  way, which is why the countermeasure is a sweep rule rather than more fixes.
  Logged here because the 2026-07-08 and 2026-08-07 external reviews set the
  precedent, and because a future scan reading the retros will otherwise
  re-derive the whole chain.
- **Reconsider when:** n/a (applied). Still open and deliberately not done:
  ~19 minor findings are cleared in the follow-up to #446, and **credential
  rotation** — the API key and password in public git history since 2023 —
  is outside the scope of any of these PRs and remains outstanding.

---

### 2026-08-13 — `/review-knowledge` findings refuted on evidence · refuted

- **Pattern:** two findings raised by the audit behind #444 were refuted after
  verification, and the refutations were recorded **only in the PR body**. The
  next run of the skill re-raised one of them cold, because nothing under
  `knowledge/` carried the decision. The skill's own contract says to record a
  refuted finding "so the next audit doesn't re-raise them cold" — it had no
  place to record it.
- **Decision:** **refuted**, both, and recorded here so they are dedup memory
  rather than PR archaeology:
  1. *"`delivery-retros.md` is over its ~12-entry rolling window (13 entries)."*
     The policy at `knowledge/README.md` is doubly hedged — "roughly … ~12" —
     and three of the 13 landed on one day. In spec.
  2. *"`next-major.md` cites issue #419 where the rule requires the PR (#433)."*
     The text writes the word **issue** before `#419`, which is exactly the
     carve-out the cite-the-PR rule allows and which #442 deliberately kept for
     "issue #417". Adding `#433` would be cosmetic.
- **Rationale:** both refutations rest on the audited file's own stated policy,
  not on taste, and the 2026-08-13 run independently reached the same verdict on
  (1) — a re-derivation that cost a full audit cycle to buy nothing.
- **Reconsider when:** (1) if `delivery-retros.md` reaches ~15 full prose entries,
  or the README's hedge is tightened to a hard number — then it is a real
  overflow, not a rounding argument. (2) if the entry is ever reworded to drop
  the literal word "issue" before the number.

---

### 2026-08-12 — Phase 0 entry gate: drop knowledge-shaped ACs from the rubric (#433) · applied

- **Pattern:** a rubric item whose evidence is a `knowledge/` artifact is
  **guaranteed** to fail its first grading, because Phase 6 grades before Phase 7
  writes. In #433 the delivery-agreed AC6 ("ADR-0018 records the decision,
  ADR-0013's superseded consequence is amended, the `next-major.md` entry is
  removed") came back `NOT MET` from the independent grader with `git diff … --
  knowledge/` **empty** — correctly, and for no reason but the ordering. The
  other seven ACs passed. Second entry touching the capture-vs-grading seam,
  after the 2026-07-28 swap below.
- **Decision:** **applied** in **#439**. `.claude/skills/deliver/SKILL.md` Phase 0's
  entry gate gains a sub-bullet: extract the ACs as now, but **drop** any whose
  evidence is a `knowledge/` artifact, and say which were dropped and why rather
  than silently reshaping the user's criteria. Phase 7 gains a reciprocal
  sentence so the rule is visible from either end. No new **Auto:** marker — the
  drop is deterministic, not a panel decision, so the reference's count of six
  panel decision points still holds.
- **Rationale:** the tempting fix — grade knowledge ACs after capture — would
  revert the 2026-07-28 decision below, which exists because capture must observe
  the delivery's **final** state; #404 shipped a knowledge entry that the next
  phase's grader then invalidated. Both constraints are real and they point in
  opposite directions, so neither phase can move. The gate is the only place left
  to fix it, and nothing is lost: the work is still enforced, by Phase 7's own
  contract (its `swept:` line and capture report) rather than by a rubric row.
- **Reconsider when:** n/a (applied). Adjacent but distinct: the #432 entry below
  adds a *third* entry-gate branch for ACs that are absent but **derivable**, and
  was applied in #438. The two compose — one governs where a missing AC may come
  from, this one governs which extracted ACs are gradeable — and neither
  supersedes the other. #438 promoted this rule from a sub-bullet of the old flat
  gate to a peer rule alongside the three cases, since it applies to all of them.

---

### 2026-08-12 — Merge `TMDbError.invalidRating` into `.badRequest` · rejected

- **Pattern:** `knowledge/next-major.md` carried a deferred entry — *"Revisit
  `TMDbError.invalidRating` inside a broader `TMDbError` review"* — whose own
  condition was that a wider `TMDbError` review must open first. It was
  consciously re-deferred at 20.0.0 (2026-08-07) because none had. Issue #419
  (`TMDbError.cancelled`, PR for `fix/cancellation-tmdberror`) reopened the enum,
  meeting that condition.
- **Decision:** **rejected outright** — `.invalidRating` stays as its own case.
  Recorded here per `next-major.md`'s retention rule ("remove an entry when it
  ships or is rejected outright — record that in `skill-improvement-log.md`"),
  and the `next-major.md` entry deleted in the same PR.
- **Rationale:** the original audit rejected the merge as a net-worse API — a
  precise typed case traded for a stringly-typed one — and nothing about #419
  changes that. `.invalidRating` is an on-device argument-validation failure
  raised before any request is sent; folding it into `.badRequest`, whose whole
  payload is a `TMDbErrorContext` describing a *server* response, would mean a
  case with an all-`nil` context and no way for a caller to distinguish "you
  passed a bad rating" from "TMDb rejected the request". #419 in fact reinforces
  the direction: it added `.cancelled` as a distinct payload-free case for the
  same reason.
- **Reconsider when:** never for the merge itself. Only if `TMDbError` gains a
  general argument-validation case (e.g. `.invalidArgument(name:)`) that
  `.invalidRating` could join without losing precision — at which point this is a
  taxonomy question, not a merge.

---

### 2026-08-12 — Phase 0 entry gate: sanction *deriving* ACs, with provenance (#432) · applied

- **Pattern:** the entry gate treats acceptance criteria as binary — present, or
  stop and ask. A bug fix whose issue already states observable before/after
  behaviour is a **third case**: the ACs are *derivable*, and stopping to ask for
  them is ceremony. Second occurrence. #365 (2026-06-24) hit it first — "the plan
  had no formal ACs (circular dependency, noted)", and its own "one improvement",
  *put an inline `Given X, when Y, then Z` example in the gate prompt*, was
  recorded as **still standing** and never applied. #432 hit it again: the plan
  was a `canon-tdd` test list, so it had a crisp definition of done in the wrong
  shape. The run derived seven ACs from issue #417 plus the test list, recorded
  `rubricProvenance: derived-…` in the run file, and the Phase 6 grader returned
  ALL MET against them — so the workaround demonstrably works; it is just
  unsanctioned.
- **Decision:** **applied** (#438), after the user reviewed it. The entry gate is
  now three cases rather than two: ACs **supplied** → extract verbatim; ACs
  absent **but derivable** from a linked issue or an explicit test list → derive
  into Given/When/Then, record `rubricProvenance: derived — <source>`, and state
  in the PR body that the rubric was derived; **neither** → the hard stop, kept
  intact. `rubricProvenance` added to the run-file schema in
  `references/worktree-lifecycle.md`, and Phase 6 now says explicitly that a
  `derived` rubric is graded exactly as strictly as a `supplied` one.
- **Rationale:** the gate exists so Phase 6 has something real to grade, and a
  derived-with-provenance rubric satisfies that while a hard stop in an
  autonomous run does not. The risk is the conductor deriving ACs that are easy
  to meet, so three things carry the weight: the ACs must be written from the
  source's own words *before* implementing, the provenance field makes a derived
  rubric auditable rather than invisible, and Phase 6's independent grader sees
  only the ACs and the committed diff.
- **Reconsider when:** n/a — but if a delivery is ever found to have derived a
  rubric that flattered its own implementation, tighten by requiring the derived
  ACs to be quoted in the PR body for inspection, not merely disclosed as
  derived.

### 2026-08-12 — ADR-0015's run-file location is unreachable from a background delivery (#440) · deferred

- **Pattern:** first occurrence, but structural rather than incidental, so it will
  recur on every background `/deliver`. [ADR-0015](decisions/0015-durable-deliver-run-state.md)
  puts the durable run file at `<main checkout>/.git/deliver/<id>.json`, chosen
  precisely because `.git` cannot enter a diff. A background session's
  worktree-isolation guard refuses **every** write outside the worktree, and it
  does not distinguish `.git` from working-tree paths — it blocked the `Write`
  tool, and then blocked a Bash heredoc to the same path. So the location the ADR
  mandates is unreachable exactly when `/deliver` runs unattended, which is the
  case the durable file exists for.
- **Decision:** **deferred — raised in an unattended background run, needs
  review; nothing applied.** Worked around by writing to
  `<worktree>/.build/deliver-run.json` (gitignored via `/.build`, untouched by any
  `make ci` step since `clean` is a separate target) and recording a
  `locationDeviation` field in the file itself. Options for review: (a) teach the
  isolation guard that the repo's *common git dir* is a sanctioned write target;
  (b) amend ADR-0015 to put the file under the worktree with an explicit
  cross-worktree-batch caveat; (c) leave it, and have `/deliver` fall back with a
  recorded deviation, which is what happened here.
- **Rationale:** the workaround is sound for a single-deliverable run — the file
  survives the whole delivery and Phase 6 read the rubric from it as designed.
  It is only *unsound for a batch*, where ADR-0015's whole point is that
  deliverable 1's `ExitWorktree(remove)` must not destroy deliverables 2..N's
  state. That case did not arise here, so applying a fix blind would be guessing
  at which of three quite different remedies the user wants.
- **Reconsider when:** a multi-deliverable `/deliver` runs in a background
  session — where the workaround is genuinely wrong, not merely non-canonical —
  or the user picks one of the three options.

### 2026-08-12 — A well-formed tooling-runner report can still assert an unobserved green (#432) · applied

- **Pattern:** third occurrence in the same family — the runner's report reads
  green while the thing you actually cared about was never observed. #374
  (2026-07-02) misread xcsift's `errors[]` as failure; #390/#397 ran in the main
  checkout and returned **baseline** counts as a pass; #432 saw a report whose
  aggregate was true (`Status: passed`, 310 tests) but which volunteered
  "including the newly added `detailsForMovieCredit` test" — a claim the xcsift
  toon log cannot support, because it carries only aggregate counts and **no test
  names**. A scoped `--filter` re-run confirmed the test genuinely ran, so no
  harm here; the point is the report could not be distinguished from one where a
  new test silently never ran. The existing shape-based contract (2026-07-29)
  covers *refused / passed / void* but says nothing about narrative claims inside
  a valid report.
- **Decision:** **applied** (#438), after the user reviewed it.
  `.claude/agents/tooling-runner.md` gains a *Never claim a named test ran*
  section — the runner reports counts and must not volunteer that any **passing**
  test ran (naming **failures** stays required, since the log does name those),
  not even when asked by name or when the total rose; asked to confirm a named
  test, it says the full-suite log cannot show it and recommends the scoped run.
  A `Names observed: yes|no` line joins its report contract. `/test` and
  `/integration-test` each gain *A count is not evidence that your new test ran*,
  pointing at the scoped `--filter` run.
- **Rationale:** this is the repo's most-hit defect family (`gotchas.md` → *False
  green*), and the wiki heuristic *a detector whose green looks the same when it
  didn't run is not a detector* applies directly: "310 passed" looks identical
  whether the new test ran or was never compiled in. Applied on both sides
  deliberately — telling the caller to verify is the durable half, but leaving the
  runner free to volunteer an unfounded claim would keep manufacturing the very
  assurance the caller is meant to distrust.
- **Reconsider when:** n/a. If xcsift ever grows a passing-test name list, the
  `Names observed` marker becomes the place to surface it rather than a reason to
  drop the rule.
- **Confirmed 2026-08-12 (#440), the next delivery, before the fix landed.**
  Fourth occurrence in the family: that run verified every batch of new tests with
  a scoped `--filter` and read the names back, and all had genuinely run — a
  near-miss, not an incident. Two observations that support the shape #438 chose.
  The workaround was arrived at independently by two sessions, so it is a contract
  rather than one operator's habit; and the unfounded claim was made by the
  **conductor** quoting a count in a status message, not only by the runner —
  which is why applying it to `/test` and `/integration-test` as well as
  `tooling-runner.md` was the right call.

### 2026-08-07 — Full CLAUDE.md/skills/agents review: drift fixes + review-integrity seams · applied

- **Pattern:** an external full review (not the wrap-up scan) of `CLAUDE.md`,
  all 21 skills, the 3 agents and the panel script found drift concentrated
  where prose describes things that move: the weekly canary called "nightly"
  (`diagnose-integration-failure`); `document-swift` quoting a README service
  count that had already moved; two skills pointing at a consistency checklist
  that had moved out of `CLAUDE.md`; `CODE_REVIEW.md`'s context block still
  describing `naturalLanguageSearch` as a core service and services as "wired
  in `TMDbFactory`"; and `CLAUDE.md` still claiming Windows after #374 dropped
  that claim from the README/`CODE_REVIEW.md` (no CI builds it). Plus four
  seams: `code-reviewer.md` permitting builds while every caller forbids them;
  `/pr`'s standalone review spawning a non-scaling single reviewer;
  `.claude/workflows/` scripts having no correctness-review path; and
  `documentation-writer.md` declaring an invalid `permissionMode: restricted`
  plus a nonexistent `autoApprove` field — both silently ignored per the
  official subagent frontmatter schema, so its permission scheme never applied.
- **Decision:** **applied** (user-approved, this PR). All drift corrected
  (Windows aligned to #374's call); `code-reviewer.md` now defaults to
  no-build; `/pr` step 5 delegates to `/review-changes`; the `/review-changes`
  gate widens to `.claude/workflows/` (script-focused §2a brief);
  `/review-pr-threads` replies via the MCP (`add_reply_to_pull_request_comment`
  with the `#discussion_r<id>` anchor id — verified 2026-08-07; `gh api
  graphql` demoted to fallback) with ADR-0009 annotated; `documentation-writer`
  gets `permissionMode: auto` + a real `tools` allowlist (including
  `Edit`/`Write`) and preloads `document-swift`; ADR-0014 gains an addendum
  recording `/review-knowledge`'s Fable pin. Two deliberate narrowings, both
  user-chosen: `/deliver` Phase 2's skip now requires an actual adversarial
  review (`ExitPlanMode` approval alone is consent, not review), and the
  delivery-weight vocabulary stays **binary** (hybrids record as full with
  skips noted — no "medium" tier).
- **Rationale:** the drift sat exactly where `review-knowledge`'s scope table
  predicts (prose describing moving parts); the seams all reduce to one
  principle — a guard that lives only in per-call prompts, or in a frontmatter
  field the schema ignores, is not a guard.
- **Reconsider when:** for the weight binary — a third genuinely distinct
  scaling shape recurs across retros (not a full run with one skipped step).
  For the narrowed Phase 2 skip — if the three-critic pass starts firing
  redundantly on plans that plainly had equivalent in-conversation review,
  tighten the *wording* of what qualifies, not the gate.

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
  into its own delivery. The opposite latent issue — `Company.logoPath` was a
  *required* decode that threw if `logo_path` was absent — was deferred here as
  breaking, then **fixed in #404 and released in 19.0.0**: it is now `URL?`
  decoded with `decodeNonEmptyURLIfPresent` (`Company.swift:48,131`), and so is
  the nested `Company.Parent.logoPath` (`:163,213`).
- **Rationale:** "make them consistent" would break public API and degrade decode
  resilience; only the non-breaking robustness improvement is worth doing now.
- **Reconsider when:** **n/a for the `homepage` rename — it shipped.** The
  condition was met when the 20.0.0 window opened, and `Network.homepage` →
  `homepageURL` was merged in **#412** (2026-08-07) via `next-major.md`, which is
  exactly the route this entry anticipated. (Merged, not released: 20.0.0 is
  still untagged.) The rejection stands only for the *aligning* direction it was
  written about — forcing `Network.logoPath` non-optional remains wrong. **The
  entry is now fully settled**: the `Company.logoPath` half it left open shipped
  in #404, so there is nothing here for the dedup scan to resurface.

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
  (MD028), but CI's markdown job then lints only `README.md` + docc, so
  CI is green on it. Both stem from the two gates having different scopes/caches.
- **Decision:** originally **deferred** (the fix was a repo-config change, outside
  the Phase-6 scan's remit) and **closed as applied on 2026-07-28** — the two
  scopes are now identical: the `lint-markdown` target in `Makefile` and the
  `Lint Markdown` job's run step in `.github/workflows/ci.yml` both lint
  `README.md`, `CLAUDE.md`, `**/*.docc/**/*.md`, `.claude/**/*.md`. (Named by
  target and job rather than line number — the numbers rot.)
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
