# Delivery Retrospectives

A short, honest entry per feature delivered via `/deliver` — written
**pre-PR** so the entry rides the delivery's own PR (the PR number is
backfilled once the PR opens), newest at the top. A noteworthy watch-phase event
is appended post-gate as an optional *watch:* line — an uneventful watch adds
nothing. The point is **continuous improvement**: when the same friction or
deviation recurs across entries, fold the fix into the relevant skill. Keep each
entry to a handful of bullets — a log, not a ceremony.

Format: **Feature / PR** · date · **weight** · *phases completed / skills
invoked* · `consulted:` · `reconciled:` · `swept:` · *what worked* · *friction*
· *deviations* · *one improvement* · *watch:* (optional, amended post-gate).

- **Weight is `lite` or `full` — there is no third tier.** A hybrid run (say, a
  pre-reviewed plan that still gets the full review machinery) records as
  **full** with the skipped machinery noted.
- The three lowercase keys are **tripwires**, one per phase that can be silently
  skipped: `consulted:` (Phase 0's knowledge consult), `reconciled:` (Phase 1's
  worktree sweep), `swept:` (Phase 7's knowledge-retirement sweep). **A missing
  line means that step did not run.** They are deliberately three distinct keys:
  when Phase 1 and Phase 7 both wrote `swept:`, one silently occupied the
  other's slot for four deliveries. See
  [`wrap-up.md`](../.claude/skills/deliver/references/wrap-up.md).

---

## 2026-08-20 — ✨ Assemble the triage run-list in code (issue #471, PR #TBD) · full

- **Phases / skills:** 0–8 pre-PR. Full weight — small diff, but reflexive
  (`.claude/skills/**` + `Scripts/**`) and it changes an unattended decision
  path, so both Phase 4/5 self-skips were overridden. Skills: `review-plan`
  (3 critics), `review-changes` (`force-review`, fan-out — with the five
  Swift lenses **replaced** by ones fitting a Python + prose diff), a targeted
  2-lens converge pass, `security-review`, `capture-knowledge`.
  `consulted:` gotchas *No workflow runs `make`*, *The `Workflow` tool resolves
  a repo-relative `scriptPath`*, *The `Workflow` tool's contract is the schema
  authority*, *A rule written in two files drifts*; wiki
  *a-rule-stated-in-two-files-has-already-drifted*,
  *never-ask-a-model-for-a-stable-fingerprint*.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported. Every
  prior run file was already closed.
  `swept:` `Makefile`, `.github/workflows/ci.yml`,
  `.claude/skills/{lint,triage-issues,deliver}/**` → the mirrored-check registry
  rewritten (five → six); `check-defaulted-witnesses.py`'s `make lint` + CI note
  verified still true; none deleted.

- **What worked — review found every substantive defect; writing the code did
  not.** Three algorithm errors, each of which would have shipped as a silently
  wrong *order* under a correctly-formatted line: a topological sort does not
  promote an unblocker (precedence ≠ promotion); separating contenders by
  swapping them leaves them adjacent; and the fixed band-check compared only the
  new neighbour, not the jumped range, so a P1 could overtake a P0 with no
  dependency edge to disclose it. The first two came from `/review-plan` — i.e.
  **before** the wrong code existed — which is the cheapest place they could
  have been caught.

- **What worked — the anti-drift test caught its own author.** The test that
  reads the skill prose off disk failed on a grammar template introduced by the
  same commit that deleted the original. A test asserting against a literal
  would have passed.

- **Friction — four of my own tests could not fail.** `assertIn(" -->", text)`
  was satisfied by unrelated HTML comments; `build(x) == build(x)` reduced to
  `once == once` because the sort is permutation-invariant; the collection floor
  had 8 tests of slack; and the gate itself exited 0 on an empty run. All four
  are the same shape as the defect under test — a green indistinguishable from
  "nobody looked" — written *while actively thinking about that failure mode*.
  Writing a test does not mean writing a falsifiable one; the check is "make it
  fail once".

- **Deviations:** (1) `Scripts/build_run_list.py`, not the plan's
  `build-run-list.py` — its tests import it and a hyphen is not importable.
  The rubric was left naming the hyphenated path and the grader flagged the
  discrepancy rather than it being quietly reconciled. (2) `/review-changes`'
  fan-out lenses were swapped for the diff's actual subject matter; the five
  stock lenses are Swift-specific and would have returned five empty reports,
  which reads as coverage. (3) Two decisions were escalated mid-`/deliver`
  (vehicle, and whether the mode split was scope creep) because the critics
  overturned a user choice — Phase 2 has no branch for that, so it was handled
  as an ordinary question.

- **One improvement:** `/review-changes` §2b hard-codes five Swift lenses, and
  the skill's own `force-review` path anticipates non-Swift diffs but only
  offers the *single-reviewer* escape. A `full`-weight non-Swift diff therefore
  has no sanctioned fan-out, and the choice to substitute lenses was made
  ad hoc. Worth giving §2b a script-and-prose lens set the way §0 already gives
  the single-reviewer path a script-focused brief.

## 2026-08-20 — ✨ `/deliver next` — select and plan the top Ready issue (#474) · full

- **Phases / skills:** 0–8 pre-PR. Full weight — prose-only diff (~900 lines,
  12 files), but reflexive and it rewrites the pipeline's own contract, so
  `reflexive: true` overrode both self-skips. Skills: `review-plan` (3 critics),
  `review-changes` (`force-review`, single-reviewer path — the fan-out's five
  lenses are all Swift-specific and would have had nothing to read),
  `security-review`, `capture-knowledge`.
  `consulted:` gotchas *In a worktree session, Bash refuses commands it can't
  prove stay inside it*, *`EnterWorktree` no longer uses the requested name*,
  *`markdownlint --fix` turns a line-leading `#NNN` into an H1*, *A `Write` of a
  Markdown file can leak `</content>`*, *Edits can land in the main checkout*;
  ADR-0009.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported / 0 claims
  released. One settled run file closed (PR #469, merged as `cabb3846`).
  `swept:` `.claude/skills/deliver/**`, `.claude/skills/triage-issues/SKILL.md`,
  `.claude/workflows/deliver-panel.js` → ADR-0016 rewritten (its "six decision
  points", stated twice, was stale the moment the enum grew to seven; it now
  points at the `POINTS` enum instead of restating a count).
  `skill-improvement-log.md` left as-is — a decision log records what was
  decided *then*.

- **The dry-run of the selection step paid for itself twice.** Running §1–§6
  read-only against the live board before writing any more prose found (a) that
  real issue bodies express `Breaking class` three different ways, so my
  one-shape parser would have misread two of three; and (b) that the head of the
  queue, issue 426, is not startable at all — it carries three competing fix
  options. Both became commits; (b) became issue #472. A feature that reads a
  live system should be exercised against it before the spec is finished, not
  after.

- **Four review passes, and passes 2–4 mostly found defects the previous fix
  created.** 12 → 8 → 3 → 2 findings. Nearly every one lived in a single seam —
  the claim/release machinery that makes concurrent `next` runs safe — while the
  selection logic was essentially right from the first draft. Worth remembering
  when scoping a review budget: an adversarial loop over prose-as-program is not
  converging on a fixed target, and the cost concentrates in whichever part
  models concurrency.

- **Friction — the ledger tool did not exist this session.** `/deliver`'s
  Contract §6 mandates *two* records, a `TaskCreate` ledger and the run file;
  no `TaskCreate`/`TodoWrite` tool was available, so the contract silently
  degraded to one. The run file carried everything, which is the right
  half to survive — but a mandated record that may simply be absent should say
  so, rather than reading as unconditional.

- **Friction — writes to `.git/deliver/` from inside a worktree fail *silently*.**
  A `python3` heredoc rewriting the run file produced no output, no error and no
  write; only a follow-up `grep` caught it. The existing gotcha documents the
  *loud* refusal. Captured the silent variant and the staged-`cp` workaround.

- **Deviation — the review-loop cap was exceeded by one, with the user's
  authorisation.** Phase 4's 3-iteration cap was reached with three blockers
  still open, all in one seam and all precisely specified. Rather than proceed
  unverified or loop silently, the state went to the user with the option to cut
  the whole concurrency seam instead; they chose one more pass. Passes 3 and 4
  then closed six further findings, two of which (a live conductor's claim being
  swept, and a claim held with no issue recorded) would have shipped.

- **Deviation — AC 3 and AC 4 graded `not met`, deliberately.** AC 3's
  script-assembled run-list line was narrowed at planning time and filed as
  issue #471 (the ordering is computed after that script returns, so it needs
  Phase 6's sort moved too). AC 4 says a dead verifier *rejects* the candidate;
  review finding N3 showed that demotes a healthy issue and blames the board for
  a harness failure, so it now *passes over*. Neither AC was reworded to pass —
  the divergence is the record.

- **One improvement:** the reflexive sweep rule now says **re-sweep after every
  review-loop fix**, not just after the first edit. This delivery's fix commit
  reintroduced exactly the drift its first two commits had avoided, into
  `.github/ISSUE_FILING.md` — a file that declares itself authoritative, so the
  stale copy overrode rather than lagged. That is the third instance of one
  pattern in one delivery, now a gotcha in its own right.

- **`watch:`** the readiness test nearly passed on a PR that could not merge.
  `gh pr checks --watch` exited **0 twice**, minutes apart, with every printed
  row reading `pass` — while eight of the `main` ruleset's ten required checks
  had not reported at all, because the `CI` workflow was still **queued** and a
  workflow that has not started produces **no check runs**. `/watch-pr` §3's
  positive test ("every check run is completed and success") is vacuously true
  over an empty-ish set, so it does not catch this; only `mergeStateStatus:
  BLOCKED` did, and the first cause I inferred for that — a review requirement —
  was wrong. The correct test compares against the ruleset's **required
  contexts**, which needs `gh api repos/:owner/:repo/rules/branches/main`. Filed
  as issue #475. Fourth instance of the False-green family this delivery, and
  the purest: "not yet run" and "nothing wrong" were byte-identical.

## 2026-08-20 — 🔒 Redact credentials from `TMDbError.network`'s payload (#469) · full

Branch `fix/redact-credentials-in-network-error`. Issue #434 (P0) — item 1 in
the board's Ready execution order.

- **Phases / skills:** 0–8 pre-PR. Full weight — networking + a public error
  payload, explicitly non-lite regardless of the diff being small. Skills:
  `review-plan` (3 critics), `implement-plan`/`canon-tdd`, `review-changes`
  (5-dimension fan-out + adversarial verify), `security-review`,
  `capture-knowledge`.
  `consulted:` gotchas §Networking (*`URL(string:)` rejects almost nothing*,
  *Percent-encoding is not a traversal defence*, *`percentEncodedPath`'s setter
  traps*, *`String.contains` compares grapheme clusters*, *Caching a
  credentialed response*), §Tooling (*the tooling-runner runs in the main
  checkout*, *Edits can land in the main checkout*), *False green*; ADR-0001,
  ADR-0012, ADR-0022; plus the personal wiki entry *A diagnostic field added
  for logging is a publishing surface*, whose closing line already named
  `URLError.userInfo[NSURLErrorFailingURLErrorKey]` as the uncovered trap —
  this delivery is that prediction coming true.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` n/a — no infra files in the diff; fallback scan of the neighbouring
  Networking and Testing entries found nothing invalidated.

- **What worked:** *measuring instead of reasoning*, repeatedly and decisively.
  Four separate design points were settled by a throwaway `swiftc` probe rather
  than argument — the deprecated key symbol (a build error, not a style
  choice), `%2B` corruption, the `/3` prefix defeating a naive
  `EndpointPathRedactor` delegate, and custom-error identity dying on rebuild.
  The critics did the same independently, which is why their blockers were
  actionable rather than speculative. Best single moment: a security-review
  hypothesis that a bearer token was reachable through the related-task key was
  **refuted by probe** — the key holds an opaque `String`, not a
  `URLSessionTask` — which saved a real but unnecessary scope expansion.

- **Friction:**
  - The plan I took into `/review-plan` was wrong in two structural ways
    (unconditional rebuild; sweep-by-value-type). Three critics caught both
    unanimously. Cheap here, expensive if it had reached implementation.
  - Batching 13 redactor tests into one red/green cycle meant they all went
    green at once, which is exactly the shape a false green hides in. Cost an
    extra unwire-and-rerun to prove the fix was load-bearing — worth it, but a
    tighter loop would not have needed the detour.
  - `MockURLProtocol`'s process-global statics produced a test that passed
    under `--filter` and failed in the full run. Captured.

- **Deviations:**
  - **No new integration test.** All three critics independently argued the
    planned live-suite test exercised no live behaviour, could pass vacuously
    (it asserted only absence), and risks the weekly cron opening a spurious
    PR. Replaced with an offline full-stack test plus a characterisation test
    that a *real* `URLSession` failure still populates the keys the redactor
    reads. Deliberate departure from CLAUDE.md's unit-and-integration default,
    reasoned rather than skipped.
  - **AC6 was corrected at Phase 6**, not merely fixed. An independent grader
    marked it not met; the criterion itself was factually wrong ("behaviour is
    unchanged" for a bearer client, when redaction keys on the URL rather than
    on how the client was built). The missing test was written and the AC
    restated, with the original wording and the reason recorded beside it — and
    a second grader was asked specifically whether that was a legitimate
    correction or laundering. It ruled correction, on the grounds that the
    missing evidence was supplied rather than written around.

- **One improvement:** `/deliver` has no step that asks *"would these tests fail
  if the fix were reverted?"* — I ran it by hand here, on instinct, and it was
  the single most informative minute of the delivery. For a change whose whole
  purpose is that something no longer appears, absence-assertions are the
  default failure mode, and the pipeline currently relies on the conductor
  thinking of it. Worth considering as an explicit Phase 3 checkpoint for
  security/redaction-shaped work.

---

## 2026-08-14 — 🐛 Generation guard for the cache invalidation race (#461) · full

- **Phases / skills:** 0–8 pre-PR. Full weight — small diff (~270 lines,
  4 files at review time) but a concurrency + `HTTPClient` surface, which is
  explicitly non-lite. Skills: `review-plan` (3 critics), `review-changes`
  (5-dimension fan-out + adversarial verify), `security-review`,
  `capture-knowledge`.
  `consulted:` gotchas *False green* (a test asserting a guarantee it cannot
  observe; green build of the wrong tree), *Testing a memoising actor*,
  *`.timeLimit` does not rescue a task parked on an unresumed continuation*,
  *`withCheckedContinuation`'s body runs in the enclosing actor's isolation*,
  *Caching a credentialed response*, *`make ci` skips the Linux build*;
  ADR-0007, ADR-0013.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` n/a (no infra files in the diff) → fell back to scanning: the two
  `FetchGate` citations in `gotchas.md` name the type, not its path, so
  relocating it to `TestUtils/` invalidated neither; both re-read, still true.

- **Falsifying the guard found a real gap in the delivery's own test.** The
  reproducer was red-first as designed, but deliberately breaking the guard two
  ways — a snapshot off by one, then invalidating on a *failed* mutation —
  showed that an over-eager guard would make the "caching resumes" assertion
  consume a fourth response the mock never had, tripping its
  `preconditionFailure` and aborting the whole test process rather than failing
  one test. A plan critic had flagged that exposure for Test B and it was
  applied there only; the falsification is what caught the same hole in Test A.
  Cheap insurance: enqueue one response more than a passing run consumes.

- **The critics converged unanimously on collapsing two actor hops into one.**
  The plan snapshotted the generation with a separate `currentEpoch()` call
  after the cache miss, then spent a three-clause paragraph arguing the gap was
  benign. All three independently proposed a single
  `lookup(forKey:) -> (response:, generation:)`; that made the snapshot atomic
  by construction, deleted the argument, and cost one *fewer* hop than today.
  A second lone-critic finding — name it `generation`, matching ADR-0013's
  existing pattern, rather than the issue's "epoch" — was applied on the merits.

- **Code review found the residual hang the hardening had missed.** Three
  measures were taken up front against the known `FetchGate` hang class
  (unstructured `Task` over `async let`, `open()` on every path, `.timeLimit`),
  and review still found a fourth path: `waitUntilEntered` *returns* on expiry
  rather than throwing, so when the GET never reaches the transport the mutation
  dequeues the still-gated slot and parks with nobody left to open the gate.
  Ordering assumptions stay invisible in a green run — this was found by
  reading, as #401's were.

- **Friction:** the diff corrected one of **four** places stating the cache
  contract, and two review dimensions independently flagged that fixing one had
  *widened* the divergence; the other three were stale on `PUT` and the
  state-changing `GET` besides. `make ci` cannot see stale prose, so this is a
  manual checklist — now a `gotchas.md` entry.

- **Deviations:** put the new tests in their own file rather than appending to
  `CacheHTTPClientInvalidationTests.swift` (per the plan), so the pre-existing
  suite stays byte-untouched and AC3 is trivially checkable, and so the new
  suite can carry its own `.timeLimit`. The Linux run happened **after** the PR
  opened, not before it: Docker was down at Phase 9, so the PR opened flagged
  Linux-unverified; once the user started Docker the suite passed (3309 tests),
  and a scoped re-run confirmed **by name** that both new race tests executed
  there — the count alone would not have. Worth the second run: the interleaving
  is scheduler-dependent and Linux's cooperative pool differs from Darwin's.
  Re-stamped `reviewedClean` after a post-review commit that only rewrapped a
  doc comment the security reviewer itself had flagged.

- **One improvement:** `/deliver` Phase 4 reads "**Lite / single-unit** → one
  review of the full diff", which would have sent this single-unit diff down the
  single-reviewer path despite full weight; the fan-out was chosen anyway
  because concurrency is where this repo's bugs survive review (#401, #433).
  The rule should key the fan-out on the *risk surface* that already decides
  lite-vs-full, not on diff shape alone — otherwise the two clauses disagree
  precisely on small concurrency changes, which is the dangerous case.

## 2026-08-14 — 🐛 Power-set overloads for the last 54 defaulted witnesses (#459) · full

- **Phases / skills:** 0–8 pre-PR. Full weight (56 files, +11.8k/−1.6k, 306 new
  public overloads, two lint gates). Skills: `review-plan` (3 critics),
  `review-changes` (reference-unit review, then a 4-dimension fan-out +
  adversarial verify), `security-review`, `capture-knowledge`.
  `consulted:` gotchas *A protocol-extension convenience that differs only by a
  default argument becomes the requirement's witness*, *swiftlint file_length /
  type_body_length*, *Removing a force-unwrap orphans its `swiftlint:disable`*,
  *No workflow runs `make`*, *Docs builds need their own scratch path*,
  *Edits can land in the main checkout*; ADR-0004, ADR-0005, ADR-0006, ADR-0023;
  wiki *a-protocol-extension-convenience-must-differ-from-the-requirement-by-more-than-a*,
  *a-detector-whose-green-looks-the-same-when-it-didnt-run-is-not-a-detector*.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` `Makefile`, `.github/workflows/ci.yml`,
  `.claude/skills/{lint,capture-knowledge}/SKILL.md` → 3 entries rewritten
  (*No workflow runs `make`* two checks → three; the `DEFERRED` staleness
  citation; the census paragraph), 1 backlog entry deleted, 2 skill files
  corrected.

- **Generating the 306 overloads is what made the fixes cheap.** Every doc
  block, forwarding body and curation line came from one script driven off the
  parsed signatures, so each defect was fixed once rather than 306 times — and
  three were: the non-`nil` default, a `- Precondition` about a `page` the
  overload no longer takes, and the trimmed parameter lists. Hand-writing would
  have made each a search-and-replace with no way to know it was complete.

- **Every review round found something, and none of it was in the Swift.** The
  three plan critics found a **live self-recursing duplicate already on `main`**
  (`MovieService.releaseDates(forMovie:)`, there since #259 and skipped by the
  guard's own default-*count* filter); that the Trending overlap was four call
  forms, not one, because a defaulted helper is callable under every subset of
  its defaults; and that `build-docs` cannot catch a *missing* curation line, so
  the plan's stated safety net for 306 of them did not exist. The fan-out then
  found four more, all of the same shape: ways a gate could stay green while
  measuring nothing. The final grader's verdict is the fair summary — the code
  was right, the *guards* were not yet.

- **The lesson worth keeping is about direction.** An allowlist-shaped check
  only ever asks whether the count went down. Once the sites were rewritten, the
  thing that mattered was whether the replacements were *written* — and nothing
  else in the repo could tell: a missing overload is a silent source break that
  passes lint, build, test and CI. Reproduced before fixing, then fixed twice
  more, because my first fix derived its filter from the very table it audited
  (self-consistent with a corrupted table) and my second attributed overloads by
  labels alone (so a *defaulted* declaration stood in for a missing one). Ten
  mutation tests now hold it. See [ADR-0024](decisions/0024-two-way-witness-guard.md).

- **Friction: the generator learned the codebase by failing.** Five build/lint
  cycles went on facts a human looks up once — mocks recording under
  `changesForPersonCalls`, `TVSeriesWatchlist` not `TvSeriesWatchlist`, sort
  enums carrying `createdAt(descending:)` and not being `Equatable`, filters
  whose only member is `includeAdult`. What stuck was to stop guessing: the
  calls-property is now resolved by matching each mock call struct's stored
  properties against the site's parameters. The sentinel table stayed
  hand-maintained, and every remaining round-trip came from there.

- **Friction: regenerating wiped hand-written tests twice.** Resetting the test
  files to regenerate them took the Trending resolution pins and the
  `releaseDates` smoke test with them. Fixed by making the hand-written parts an
  idempotent post-pass instead of manual re-application — the same shape as the
  generator itself.

- **Deviations:** the guard rework was pulled forward into the reference unit so
  the completeness oracle protected the other ten services as they landed. Two
  items were taken on beyond the issue: deleting the `releaseDates` duplicate
  (same failure class, surfaced by the widened invariant, and it would have kept
  `make lint` red otherwise) and adding `Scripts/check-docc-curation.py`. A
  pre-existing README bug found by the same sweep was filed as issue #458 rather
  than fixed here.

- **One improvement:** add `make build-docs` to the per-unit gate for any change
  that adds public API. The plan critics put it there for this delivery and it
  caught the DocC ambiguity on commit two of eleven, rather than after the live
  integration suite on the eleventh.

## 2026-08-14 — ✅ Fixture hygiene: strict checker, 9 adoptions, 11 deletions (#457) · full

- **Phases / skills:** 0–8 pre-PR. Full weight (34 files, +654/−1975, a new CI
  gate, and a reflexive edit to `/pr`). Skills: `review-plan` (3 critics),
  `implement-plan`, `review-changes` (5-dimension fan-out + adversarial verify),
  `security-review`, `capture-knowledge`.
  `consulted:` gotchas *False green* (:10), *No workflow runs `make`* (:93),
  *The build/test tooling-runner runs in the main checkout* (:292),
  *A fixture the author invented tests the author's belief* (:855),
  *An empty-string-guard fixture must come from a real record* (:876),
  *Model-decode equality tests: build the expected value directly* (:1027);
  wiki *a-detector-whose-green-looks-the-same-when-it-didn't-run*,
  *a-fixture-you-invented-tests-your-belief-not-the-api*.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` `.claude/skills/pr/SKILL.md`, `.github/workflows/ci.yml`, `Makefile`
  → 1 entry rewritten (*No workflow runs `make`*, now recording two mirrored
  checks and the missing-`outputs:`-key trap).

- **What worked:** building the checker **first** and recording its baseline
  against the untouched tree. That ordering was a `/review-plan` correction, and
  it is the only reason "2 parse failures, 4 camelCase files, 20 orphans" is a
  measurement rather than a claim — three steps later the evidence would have
  been gone. Falsifying each check against engineered input (including from an
  empty directory) cost minutes and is what makes the green mean anything.

- **The plan review earned its keep twice.** Two blockers were real: the
  delete-list used a **type**-level redundancy rule where this repo's rule is
  decoder-**branch**-level, which would have deleted the only coverage of
  `AlternativeTitleCollection`'s `results` branch and the only populated
  `tv_results`. And a unanimous major caught that the planned `fixtures`
  paths-filter output had no `outputs:` declaration — the gate condition would
  have been the empty string, so the new check would never have run while the
  job reported success. A false green inside the check built to stop false
  greens. Counts moved 6 adopt/14 delete → 9 adopt/11 delete.

- **Friction / self-inflicted:** the independent grader caught what five
  reviewers and I missed — two `overview` values hand-truncated while trimming
  captures. Trimming *records* is sanctioned; editing a *retained value* is the
  exact dishonesty the PR exists to remove, and the Slovak assertion passed only
  because it used `.contains(…)`. Fixed, then verified mechanically (147 field
  comparisons against live, 85/85 strings exact) rather than by re-reading, and
  the weak assertions tightened to exact strings. Lesson: when a change's thesis
  is "fixtures must be verbatim", verify verbatim-ness with a diff, not an eye.

- **Deviations:** (a) skipped the standalone `/integration-test` — no production
  code changed and `make ci` at Phase 9 runs the live suite; CLAUDE.md flags
  re-running it beforehand as a delivery's largest avoidable cost (#401).
  (b) The run became **reflexive** at Phase 4: a review finding showed `/pr`'s
  fast gate still classed a fixture-only diff as docs-only, contradicting the
  rule this PR added to CI, so `.claude/skills/pr/SKILL.md` and CLAUDE.md's
  paraphrase were updated. That skill edit is **not** exercised by this run —
  the session loaded its registry from the main checkout — so it is verified by
  reading only. Not logged in `skill-improvement-log.md`: that file names its
  two producers, and this was a review-driven fix, not a proposal.

- **One improvement:** the footprint sweep should run when a delivery *changes a
  rule*, not only when it edits `.claude/`. This PR's rule ("fixtures are
  test-affecting") had three statements — `ci.yml`, `/pr`, CLAUDE.md — and
  Phase 0's reflexive check did not fire because the diff started out touching
  none of `.claude/`. Code review found the third site; a rule-keyed sweep would
  have found it at plan time.

## 2026-08-13 — 🔒 Reject traversal-capable URL path segments (#453) · full

- **Phases / skills:** 0–8 pre-PR. Full weight (security-relevant networking
  change, new type, public DocC, 8 commits, +900/−30). Skills: `review-plan`
  (3 critics), `implement-plan`, `review-changes` (6-dimension fan-out +
  adversarial verify), `security-review`, `capture-knowledge`.
  `consulted:` gotchas *URLComponents path round-trip decodes `%2F`* (:1209),
  *`URL(string:)` on Apple platforms rejects almost nothing* (:1191),
  *False green* (:10), *The build/test tooling-runner runs in the main checkout*
  (:292), *In a worktree session, Bash refuses commands it can't prove stay
  inside it* (:376), *A `#expect(throws:)` test is a false green twice over*
  (:872); tmdb-api-notes *Credentials and PII live in the URL path* (:177);
  ADR-0008.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` no infra files in the diff → the one `urlFromPath` citation is in
  this file, a dated log whose technical claim remains accurate, left as
  history; ADR-0008 and the rewritten gotcha carry the correction.

- **What worked — probing the issue's own premise before planning around it.**
  Issue #421 stated the fix was one line (compose via `percentEncodedPath`).
  Ten minutes of `curl --path-as-is` showed that line does **not** close the
  class: TMDb's edge percent-decodes the path and *then* resolves `..`, so the
  encoded payload reaches the `movie` endpoint exactly as the raw one does. A
  delivery that had trusted the issue would have shipped a fix, closed #421, and
  left the vulnerability open — with an ADR newly asserting it was closed.

- **What worked — the red steps named the leaked URLs.** Writing the reproducing
  tests to assert `performCount == 0` *and* `lastRequest?.url == nil` meant the
  red output printed
  `…/credit/x/../../movie/550?api_key=abc123` and
  `…/guest_session/x?foo=1/rated/movies&api_key=abc123`. The second is a
  **query-injection** vector — items landing *ahead* of `api_key` — that neither
  the issue nor the plan had identified.

- **Friction — the adversarial reviewers each found a different subset, again.**
  `/review-plan` found the three unencoded guest-session builders; the fan-out
  found the fail-open decode and the forwarded authority fields; the security
  review found the grapheme-cluster `contains("/")` gap; the rubric grader found
  the gratuitous public-string change. No single pass would have found all four.

- **Deviation — the plan's "no integration test" call was wrong, and review
  caught it.** The plan argued a live test was pointless because the fix
  short-circuits before the network. But
  `FindIntegrationTests.findWithEmptyExternalIDThrowsBadRequest` is exactly that
  shape, so the convention already existed. Three integration tests added.

- **Deviation — a rubric AC was failed and fixed rather than reinterpreted.**
  AC5 ("every pre-existing unit test still passes, unmodified") came back *not
  met*: widening `errorDescription` had forced an edit to `TMDbErrorTests`. The
  string change was an advisory nit with no security value, so it was reverted;
  `TMDbErrorTests.swift` is byte-identical to `main` again.

- **One improvement — a sweep recipe recorded in an ADR is a liability if it is
  a text pattern.** ADR-0008 prescribed `grep 'path = "/…\(stringVar)"'`. Three
  builders wrote `let path =` on its own line, so the sweep recorded four sites
  when there were eight, and the three it missed carried a *bearer-like
  credential*. The #364 retro (below, 2026-06-24) had already recorded the
  lesson — "do **one type-driven enumeration of all sites up front**" — and the
  ADR still shipped a grep. **Recording a lesson in a retro does not enforce
  it; encoding it in the artifact the next person actually follows does.**
  ADR-0008's recipe is now type-driven.

## 2026-08-13 — ♻️ TMDbIntelligence vocabulary growth valves + `searchFailed` (#452) · full

- **Phases / skills:** 0–8 pre-PR. Full weight (new + breaking public API, error
  paths, 15 Swift files, +664/−36), **with `/review-plan`'s critics skipped** —
  the plan had already taken an adversarial pass this session whose findings were
  applied. Skills: `implement-plan`, `review-changes` (5-dimension fan-out),
  `security-review`, `capture-knowledge`.
  `consulted:` gotchas *Public enums are not implicitly `Sendable`* (:1429),
  *DocC symbol links don't resolve across modules* (:504 + its 2026-07-24
  update), *A `package` symbol cannot be referenced by a DocC link* (:761),
  *The build/test tooling-runner runs in the main checkout* (:265),
  *A `RawRepresentable` enum … gets rawValue equality* (:1001),
  *`NaturalLanguageSearchService` is not platform-gated* (:1018),
  *Renaming a method's internal parameter name* (:1116); **ADR-0018**,
  **ADR-0019** (both governing), ADR-0010; wiki
  *treat-review-findings-as-hypotheses-not-approved-work*.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` n/a (no infra files in the diff) → fell back to neighbouring entries:
  ADR-0019 limb 2 rewritten (its "existing codebase-wide idiom" claim was going
  stale), ADR-0018 read in full and verified still true, gotchas :504/:761/:1001/
  :1018 re-read, still true.
- **Worked — verifying the issue's premises before planning changed the plan.**
  Per the wiki heuristic, all three of issue #420's load-bearing claims were
  checked and **three were wrong**: ADR-0019's `.unknown` idiom does not transfer
  (every instance exists because the value is wire-decoded; none of these types
  are `Codable`), Half 2 was already half-landed by ADR-0018's
  `catch TMDbError.cancelled`, and — the one that mattered — **a catch-all case
  does not on its own prevent the source break**. The issue's literal fix would
  have shipped a valve that didn't valve: adding `.other` stops nothing unless all
  future growth is routed through it. That reframing is what turned the change
  into extensible structs, and became ADR-0021.
- **Worked — the plan's adversarial pass caught two *silent* breaks.** A
  payload-free enum is implicitly `Hashable`, and an enum interpolates as its bare
  case name; a struct is neither. Neither loss produces a diagnostic at the
  conversion site, and the interpolation one would have compiled while silently
  destroying the dictionary keys and column alignment of
  `NaturalLanguageSearchPlannerEvalTests`' accuracy report. Both are now declared,
  tested, and recorded in `gotchas.md`.
- **Worked — spending one 30s gate on the biggest unknown first.** Converting
  `Reason` alone (4 statics) and running `make build-docs` settled whether
  `` ``Intent/byPerson`` ``-style links survive against a `public static let`
  before the bulk conversion multiplied the cost of a wrong answer. They do, so
  zero doc-link churn was needed — evidence rather than the `RetryableErrors`
  precedent's promise.
- **Friction — I asserted a compiler behaviour I had not verified, and two agents
  then disagreed about it.** I told the user the catch-arm ordering was gated by
  *"case will never be executed"*; the security reviewer said it was unenforced
  and rested only on a comment. Settled by reversing the two arms and building: it
  **is** gated, as a hard error under `--Werror`. Cheap to check, expensive to be
  wrong about — a claim about *what enforces an invariant* deserves the same
  evidence bar as a claim about behaviour.
- **Friction — fixed a stale string in one file and didn't sweep for its
  siblings.** `README.md:154` called `search("…")` where the label is
  `search(matching:)`; the review found the **identical** call in
  `TMDbIntelligence.docc` and `TMDbIntelligenceTesting.docc`. DocC code fences
  aren't compiled, so no gate catches them. Same shape as the recurring
  "sweep the rule's whole footprint, not the file you opened" defect.
- **Friction — a test comment claimed to pin an invariant it never reached.** My
  execution-failure test asserted `searchAllQueries.isEmpty` and commented "pins
  `canFallBack` → false", but `canFallBack` is only consulted for errors from
  `planner.plan(for:)`; that failure comes from `executor.execute`, outside the
  inner `do`. The new arm could have been flipped to `true` with nothing failing.
  Fixed by raising `.searchFailed` from the *planning* stage instead. **A comment
  asserting coverage is not coverage** — the reviewer had to catch it because the
  green suite looked identical either way (**False green**).
- **Deviations:** (1) Phase 2 critics skipped, as above — recorded as full with
  the skipped machinery noted. (2) The plan sequenced `ListKind` and `Intent` as
  separate build cycles; both were done in one, since their switch sites live in
  *different* files so an error stayed attributable — one build saved, and it
  compiled clean first time. (3) The `reviewedClean` stamp used the `Sources`/
  `Tests` **tree hashes** rather than the documented
  `git ls-tree … | git hash-object` pipe, which the worktree Bash guard refuses as
  unverifiable; same property, no pipe.
- **One improvement — applied in this PR.** `swept:` disciplines `knowledge/`, but
  both of this delivery's doc misses were **source-tree** sweep failures a
  reviewer caught, not the author. `/implement-plan`'s *Done* checklist gained a
  step 3: *changed a literal string, symbol name or code sample? grep the tree for
  the old text before calling it done* — the `.docc` catalogs and `README.md`
  being the habitual blind spot because **no gate compiles a code sample**. The
  gap it fills is the *incidental* fix: the reflexivity footprint sweep covers
  `.claude/` diffs and the type-driven enumeration covers tasks framed as sweeps,
  but neither covers a one-liner changed in passing. Logged in
  `skill-improvement-log.md`.

## 2026-08-13 — 🔧 Move the `/review-knowledge` audit round to Opus (#451) · full

- **Phases / skills:** 0–8 pre-PR. Full weight and reflexive (`.claude/skills/**`),
  so Phases 4 and 5 ran with their no-Swift self-skip overridden. Skills:
  `review-plan`, `review-changes` (`force-review`), `security-review`,
  `capture-knowledge`.
  `consulted:` gotchas *False green*, *Edits can land in the main checkout*,
  *In a worktree session Bash refuses commands it can't prove stay inside it*,
  *EnterWorktree branch name*, *Workflow resolves a repo-relative scriptPath*,
  *git ls-tree empty hash*, *markdownlint line-leading number-sign*;
  **ADR-0014** (governing — both proposed changes contradicted it), ADR-0016;
  wiki *keep-adversarial-reviewers-independent*,
  *a-detector-whose-green-looks-the-same-when-it-didnt-run*,
  *an-unenforceable-process-rule-gets-silently-skipped*.
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` `.claude/skills/review-knowledge/SKILL.md` → 3 `gotchas.md` entries
  written or extended, 1 factual correction in `decisions/0016` (embedded-script
  count 3 → 4); historical `skill-improvement-log.md` entries left untouched
  (append-only decision memory); `gotchas.md:59` re-read, still true.
- **Worked — Phase 0's knowledge consult caught that the whole plan was
  ADR-governed.** ADR-0014 pins every model tier in `.claude/`, and both proposed
  changes contradicted it: one reversed its six-day-old addendum, the other
  partially re-opened an alternative it had explicitly rejected with a revisit
  trigger that had not fired. Without that read this would have shipped as a
  config tweak that silently reversed a recorded decision.
- **Worked — the plan critics changed the shape of the delivery, not just its
  details.** They killed `effort: high → xhigh` (thinking bills as output at 5×
  input, so moving two variables would have made the saving unmeasurable and left
  a regression with two suspects); caught that a conditional `meta.model` would be
  a temporal-dead-zone `ReferenceError` shipping unexercised, since a reflexive
  delivery cannot dogfood; and showed the second change's trigger could never fire
  for reflexive `.claude/` diffs — the class this repo's defect record is made of.
  Scope went from two changes to one on that evidence; the dropped one is issue
  #450.
- **Worked — the code reviewer caught a falsehood in the durable record.**
  ADR-0020 and the log both claimed *in the past tense* that a GitHub issue had
  been filed. None had. In a delivery specifically about sharpening the audit that
  hunts exactly that class of claim.
- **Worked — a reviewer conceding cleanly on evidence it lacked.** It flagged
  `meta.phases[].model` as an invented key (High, correctly, from where it sat —
  the `code-reviewer` agent has no `Workflow` tool and the schema is documented
  nowhere in the tree). Given the contract it withdrew in full and named its own
  reasoning error: it had read *absence of the situation* as *avoidance of the
  field*. Captured as a gotcha.
- **Friction — the review machinery cost far more than the change saves.**
  ~1.36M subagent tokens on the plan review, ~284k across two code-review rounds,
  ~74k grading — for a 6-file markdown diff whose benefit is roughly a quarter off
  one periodic skill's run. Full weight was the right call for a reflexive change;
  the problem is that full weight currently means the same machinery for a
  6-file prose diff as for a multi-service Swift feature.
- **Friction — the worktree `Bash` guard cost ~8 extra round trips.** Every
  run-file update, the content stamp and the script parse-check had to be
  decomposed into single-purpose commands; `$'\t'` quoting was refused outright.
  Captured.
- **Deviations:** (1) the ADR was authored in **Phase 3, inside the diff**, not
  Phase 7 — on the critics' finding that Phase 7's contract permits writing
  nothing, so a governance record deferred to it is unenforced. This is the
  sanctioned inline-capture exception. (2) Phase 5 was analysed directly rather
  than fanned out: every changed file is markdown and the skill's own rule 16
  excludes documentation findings, so a fan-out was structurally guaranteed
  empty. Recorded as a visible choice rather than a silent narrowing.
- **One improvement:** scale Phase 2 and Phase 4 by **diff shape**, not weight
  alone. `full` currently fixes both risk *and* machinery, so a reflexive prose
  change — which genuinely needs the adversarial lens — pays for fan-out breadth
  sized for a multi-service Swift diff. A reflexive-but-small shape wants the
  critics (they earned their keep here) at a smaller fan-out. Raise against the
  binary-weight decision deliberately, since that vocabulary is itself a recorded
  narrowing.
- **Also noted:** my own AC3 was written too literally — its second clause
  required *every* `fable` hit to sit in one of two named buckets, which would
  have demanded deleting true, unrelated history. The independent grader graded
  the reasonable reading and disclosed the strict one rather than silently
  passing. Write rubric clauses that scope to the change, not to the whole tree.

## 2026-08-13 — 🐛 Exclude tvOS/watchOS from the FoundationModels planner (#449) · full

- **Phases / skills:** 0–8 pre-PR. Full weight, but with two pieces of machinery
  deliberately not used (below): `/review-plan`'s critics and
  `/review-changes`'s fan-out. Skills: `implement-plan`, `review-changes`,
  `security-review`, `capture-knowledge`.
  `consulted:` gotchas *No workflow runs make*, *tooling-runner runs in the main
  checkout*, *Bash refuses commands it can't prove stay inside the worktree*,
  *Edits can land in the main checkout*, *EnterWorktree branch name*,
  *FoundationModels/CoreImage watchOS* (retired by this delivery),
  *NaturalLanguageSearchService is not platform-gated*, *git ls-tree empty
  hash*; wiki *before-bumping-a-pinned-ci-toolchain-version-verify-the-runner-
  image-ships-it*, *a-detector-whose-green-looks-the-same-when-it-didnt-run*,
  *fix-orphaned-platform-gated-api* (ADR-0010 background).
  `reconciled:` 0 in scope / 0 reclaimed / 0 resumable / 0 reported.
  `swept:` `.github/workflows/ci.yml` → 1 entry retired, 2 rewritten; 5 citing
  entries re-read and left unchanged.
- **Worked — probing the platforms before accepting the reported fix found a
  second break.** The issue proposed `&& !os(tvOS)` at four sites and had
  verified it on 18.2.0. Building the *unfixed* tree for all five Apple
  platforms first showed watchOS was also red, and `!os(tvOS)` does not fix it:
  the SDK's availability is asymmetric per symbol, so only the file touching
  `SystemLanguageModel` breaks there. Shipping the reported patch verbatim
  would have left watchOS broken and looked like a complete fix.
- **Worked — the reviewer found a pre-existing false green two lines from the
  diff.** The aggregate `ci` job never checked the `changes` job's result, and
  every job is `if: always()` — so a failed paths-filter left all five jobs
  exiting `success` having done nothing, on a ruleset that requires `CI`. Fixed
  here because it is the same failure family the delivery exists to close.
- **Worked — settling a finding by executing it rather than arguing it.** The
  reviewer flagged that `xcsift --Werror` on a four-SDK `xcodebuild` might fail
  on Apple's own header warnings — a false *red*, and explicitly "cannot be
  settled by reading". One cold piped build per new platform answered it (exit
  0), which is cheaper than the paragraph of speculation it replaced.
- **Friction — the weight vocabulary did not fit the diff.** Full weight
  prescribes the fan-out `/review-changes`, but its five dimensions are all
  Swift lenses (correctness, concurrency, architecture, testing, api-docs) and
  the risk in this diff was 74 lines of GitHub Actions YAML. A fan-out would
  have spent four lenses on a five-line Swift change and still had nobody
  reviewing the workflow. Took the single-reviewer path with a targeted brief.
- **Friction — the `markdownlint --fix` hook silently corrupted a knowledge
  entry** by rewriting a line-leading `#416` into an H1, destroying the
  sentence and then failing the gate on a heading I never wrote. Captured as a
  gotcha; it will recur, because this repo cites `#NNN` constantly and wraps
  prose at 80 columns.
- **Friction (self-inflicted) — ran `make lint` three times** for a diff of five
  one-line `#if` changes and a doc comment. The `PostToolUse` hook already
  formats each file on write; `--strict` is the gate and `make ci` runs it. The
  user pointed this out mid-run.
- **Deviations:** (1) skipped `/review-plan`'s critics — the plan had been
  adversarially verified empirically before `/deliver` was invoked, by testing
  the reporter's proposed fix and finding it insufficient; (2) single-reviewer
  `/review-changes` at full weight, per the friction above; (3) skipped the
  standalone `/integration-test` at Phase 3 — the diff is compile-time-only and
  a provable macOS no-op, the integration target's *compilation* is proven by
  `--build-tests`, and `make ci` runs the live suite at Phase 9 anyway (the
  #401 economy); (4) ran `/security-review` inline rather than via sub-tasks,
  the surface being one workflow file; (5) let the Phase 6 grader run its own
  platform builds, against the skill's execution cap — the rubric was
  build-shaped, so having it trust my logs would have made it non-independent
  on exactly the criteria that mattered.
- **One improvement:** `/review-changes`'s fan-out has no dimension for CI /
  workflow changes, so any diff whose risk is in `.github/workflows/` is either
  reviewed by five Swift lenses or, as here, routed to the single-reviewer path
  by hand. A sixth `ci-workflow` dimension (gate integrity, false-green paths,
  secret exposure, cache keys) would make the fan-out usable for
  infrastructure diffs instead of only Swift ones.

## 2026-08-12 — 🐛 Surface task cancellation as `TMDbError.cancelled` (#433) · full

- **Phases / skills:** 0–8 pre-PR. Full weight: three-critic `/review-plan`, the
  fan-out + adversarial-verify `/review-changes`, independent grader.
  `consulted:` ADR-0001/0003/0012/0013, `next-major.md` (the `invalidRating`
  entry, settled here), gotchas *Swift concurrency* §853-950 (all four entries),
  `swift-concurrency` skill; wiki *semantic-errors-not-transport-errors*,
  *treat-review-findings-as-hypotheses*, *for-a-sendable-test-double-reach-for-a-
  lock-before-an-actor*.
- **Worked — the plan critics changed the design, not just the wording.** All
  three independently found a bug the issue never mentioned: a cancelled
  natural-language search was wrapped as `.planningFailed`, which `canFallBack`
  treats as fallback-eligible, so `TMDbIntelligence` issued *three fresh live
  searches on an already-cancelled task* — the library itself doing the
  "re-run work the user cancelled" harm #419 was filed about. That became Part 4.
  They also killed two defects that would have shipped: the detection predicate
  would have swallowed `URLSession.invalidateAndCancel()` as a user cancellation,
  and `(error as? URLError)` may not match what corelibs-foundation raises on
  Linux — where the integration test meant to prove it never runs.
- **Worked — the simplicity critic reversed my Part 2 design, for the better.**
  I had planned a waiter registry on the actor. The `DataTaskBox`-style
  `ResumeOnce` box it proposed instead is smaller, touches none of ADR-0013's
  commit machinery, and *removes* a hang class (late registration) rather than
  adding one. Its decisive argument was that `onCancel` is synchronous, so a lock
  beats an actor — which is the wiki entry I had already read and not applied.
- **Worked — mutation-testing a review finding.** The fan-out claimed the
  executor-path `catch` arm was untested. Rather than trust or dismiss it, I
  mutated the arm and re-ran: it failed with `planningFailed(underlying:
  .cancelled)`, proving both the finding and, after the fix, the new test.
- **Friction — `.build` contention shaped the schedule, not just the tokens.**
  Phases 4 and 5 read the same commits and feel parallel, but one scratch dir
  means they must be serial; every reviewer prompt needed an explicit "do not
  build". Worth it: full 5/5 dimension coverage, 1 finding dropped by refutation.
- **Deviations:** (1) test-first per *cohesive unit*, not per test — the
  exhaustive switches acted as the red signal for the mapping sites, but that is
  a looser loop than `canon-tdd` prescribes. (2) I skipped a test my own plan
  listed (composing `TMDbAPIClient` over `RetryHTTPClient`); the grader caught
  it. (3) The rubric named AC4 in terms the critics later proved unachievable,
  so it was narrowed mid-run, and AC8 added for Part 4 — both flagged to the
  user rather than quietly restated.
- **One improvement — Phase 6 grades AC-shaped knowledge work that Phase 7 has
  not done yet.** AC6 ("ADR-0018 exists, ADR-0013 amended, `next-major.md` entry
  removed") failed the first grading *purely* because capture runs after the
  rubric gate. The criterion was correct and the ordering is deliberate, but a
  knowledge-shaped AC is guaranteed to fail its first grading. Either `/deliver`
  should grade knowledge ACs after Phase 7, or Phase 0 should refuse to accept
  one — worth a wrap-up scan proposal if it recurs.
- **`swept:`** one stale claim retired — the prefetch-forwarding testing gotcha
  still described the `Task.checkCancellation()` guard this change replaced;
  annotated rather than deleted, since its actor-recorder advice still holds. No
  `Makefile`/`Package.swift`/workflow/`.claude` changes, so the target-layout
  half is n/a.
- **`watch:`** the Linux CI job caught a **production** bug that every other gate
  missed. In `ResumeOnce.resume(_:)` a local named `continuation` shadowed the
  stored property *inside its own initialiser*, so `guard let continuation` read
  uninitialised stack memory. On Darwin that garbage was `nil` and the code
  behaved perfectly — 3144 macOS tests, `make ci`, two review passes, a security
  review and an independent grader all green. On Linux it was non-`nil` and
  segfaulted in `swift_retain`, wedging the runner so hard it ignored both
  GitHub's concurrency cancel and `gh run cancel`. Three lessons, all captured:
  a full green `make ci` **never builds for Linux**, so a hand-rolled concurrency
  primitive needs `make test-linux` *before* the PR; `.timeLimit` cannot rescue a
  task parked on an unresumed continuation (the timeout blocks with it), so my
  earlier claim that it "turns a hang into a failure" was overstated and is now
  corrected in the suite comment; and a diff-reading reviewer cannot see this
  class of bug — `claude-review` explicitly approved the file.

## 2026-08-12 — ✨ Adopt a single decode-tolerance policy (#440) · full

- **Phases / skills:** 0–11; **full**. `/review-plan` (3 critics),
  `/implement-plan`, `/review-changes` (5-dimension fan-out + adversarial
  verify), `/security-review`, independent Phase 6 grader (ALL MET),
  `/capture-knowledge`. 11 commits.
- **Worked — making the failure-class sweep a *blocking ledger task*, not a plan
  bullet.** All three critics independently graded the blast-radius audit as the
  weakest part of revision 1 (two called it a blocker), because it was a *name*
  sweep that missed every synthesized decoder — the exact #404 mistake. Promoting
  it to a Step 0 gate that blocked the container flip is what found the delivery's
  worst bug: `TVSeriesDetailsResponse.lists` was typed `MediaPageableList` when
  `/tv/{id}/lists` returns list summaries with no `media_type`, so tightening
  tolerance would have turned a silent empty array into a thrown call. Rule of
  thumb confirmed: a process step that only exists in prose gets skipped under
  momentum; one that blocks a task does not.
- **Worked — the sweep's exclusions, not just its findings.** It disproved my own
  plan's claim that `TVSeriesListItem.originCountries` was "the one confirmed
  hardening needed" (clean at 1,046/1,046), and showed the 9%-null
  `origin_country` figure recorded for `/company/{id}` does **not** transfer to
  `/search/company` (100/100 clean). Both would have shipped as confident
  assertions a reviewer could reasonably have rejected.
- **Worked — review overturning a decision the critics had settled.** Phase 2
  rejected an inert-equality wrapper for the drop count on the grounds that "no
  production code compares these models". Two review dimensions independently
  pointed out that reasoning covered *in-package* code and ignored consumers,
  who are exactly who a public `Equatable` serves — a decoded page no longer
  equalled its own round trip. Reinstated. Later-phase evidence beating an
  earlier consensus is the pipeline working, not churn.
- **Friction — three of my own load-bearing claims were wrong, each caught by a
  different stage.** (1) "`lists.items` silently drops TV rows" — it threw, like
  `details`; both decode the same `MediaList` (critic). (2) The sentinel "sits
  inside a tolerant container so it never reaches a caller" — every `init(from:)`
  is public, so a consumer decoding cached JSON gets it directly (reviewer).
  (3) The error message was safe — it interpolated an unbounded raw server string
  into a loggable `debugDescription` (security). Each was cheap to fix and
  expensive to have shipped.
- **Friction — a peer session landed `CreditType` (#436) into `main` mid-flight**,
  duplicating work I had already committed. Cost a rebase, four conflict
  resolutions in favour of `main`, and a reworded commit whose message had become
  half-false. Two sessions picking up the same issue is the real cost; the
  worktree sweep saw the peer's worktree but had no way to know what it would
  claim.
- **Deviations:** (1) The run file could not live at `.git/deliver/<id>.json` —
  this session's background worktree-isolation guard refuses every write outside
  the worktree, via both `Write` and a Bash redirect. Kept it at
  `<worktree>/.build/deliver-run.json` (gitignored, survives `make ci`) and
  recorded the deviation in the file. (2) The rubric was **derived** from the
  plan's test list plus the issue's comment rather than supplied, with
  `rubricProvenance` recorded — the path #432's retro asked to have sanctioned.
  (3) `tooling-runner` hit a session limit near the end; fell back to
  `make -C <dir> test` directly and disclosed it.
- **One improvement:** the `tooling-runner` contract reports aggregate counts
  only, so "3147 passed" reads identically whether a new test ran or never
  compiled in — a peer hit the same thing today and logged it as `deferred`. I
  worked around it by re-running each batch of new tests with a scoped
  `--filter` and reading the names back. That workaround should be the contract:
  after adding tests, `/test` should confirm the new ones **by name**, not by
  total.

## Archive (distilled)

Older entries condensed per the rolling window (`knowledge/README.md` →
*Maintenance & retention*); prose is in git history.

| Date | PR | Weight | Outcome |
| --- | --- | --- | --- |
| 2026-08-12 | #432 | full | Decoded empty-string credit dates as nil. **The #404 population sweep paid in both directions**: 300 live `/credit/{id}` records both *cleared* five URL decodes with a measurement (`null`-bearing, never `""`) and *found a bug the issue never mentioned* — `credit_type: "creator"` threw. A sweep earns its keep by excluding as much as by finding. The critics caught a false green the author built in: **no fixture omitted `character`**, so a `decode`-instead-of-`decodeIfPresent` slip would have compiled, passed everything, and broken 36% of live credits — fixed for free by re-sourcing both blank-date fixtures to *crew* credits, which omit `character` entirely. A 2-vs-1 critic split was reconciled **on evidence, not vote**: *Guard consistently within a type* is about one value class diverging, not a date differing from a URL, and guarding would have made `CreditMovie` the lone divergence across ~20 models. Two lasting frictions: the worktree Bash guard refuses commands it cannot prove stay inside the worktree (which blocks writing `/deliver`'s own run file under `.git/deliver/` — its run-file location is at odds with its worktree isolation), and **a subagent asserted a green it could not see** (the tooling-runner reported a named test passed, but xcsift logs carry only aggregate counts; its report shape cannot distinguish *ran and passed* from *never ran*). Its "one improvement" — sanction *deriving* ACs with recorded provenance when a plan states observable before/after behaviour in the wrong shape — **shipped**, and is the entry gate's `derived` branch and `rubricProvenance` field today. |
| 2026-08-07 | #412 | lite | Renamed `Network.homepage` to `homepageURL`, the second firing of the `next-major.md` queue: the item was deferred out of 19.0.0 on 2026-07-27 as cosmetic scope creep on a bug fix, and shipped here because the file was read when the 20.0.0 window opened — the deferral mechanism working end to end. Equally deliberate was the entry that did **not** ship: `TMDbError.invalidRating` stayed deferred because its own condition (a wider `TMDbError` review) was unmet, and that was recorded rather than skipped, so a later reader can tell "considered and declined" from "missed". Stacked on `feature/v4-lists` rather than branched from `main`, since both edit the same `CHANGELOG` section. Its "one improvement" — have `next-major.md` carry a status line naming the open major window, so an entry cannot be filed against a version that already shipped — **shipped**, and `/capture-knowledge` asserts it on every addition today. |
| 2026-08-07 | #411 | full | TMDb v4 lists (`client.v4Lists`), settling ADR-0017's four open decisions. **Phase 0 probing changed the shipped API twice, both unfixable later**: `sort_by` turned out to be honoured on the read side (so `details`/`items` take `sortedBy:` — adding a protocol requirement afterwards is source-breaking), and `create(isPublic:)` shipped after all because TMDb ignores the *boolean* and honours the *integer* — the earlier "it ignores the field" conclusion came from a probe that sent a bool. Reading the resource back caught both. The count-reconciliation assertion caught a real drop on its first outing (`Show.encode` writes no `media_type`, so every encoded item failed to decode and the whole list vanished silently). Two of the three bugs were **the probe scripts lying**: an `EXIT` trap that never fired and orphaned four lists on a real account, and ten identical "rejected" results across a `sort_by` sweep that were the spam filter (`status_code` 18), not an answer — a uniform failure across a sweep is evidence about the sweep. Both are now standing rules in `CLAUDE.md`: a probe must verify its own postcondition. Also a mid-delivery **correction**: I reported credentials committed in `Integration.xctestplan` having read it off disk without running `git ls-files` — the file is gitignored and absent from HEAD (they were committed in 2023 and remain in public history, so rotation still applies). |
| 2026-08-07 | #410 | full | Defaulted-witness convenience sweep across 37 sites. The **reference-unit gate earned its keep again**: reviewing one site before replicating caught a DocC-curation regression (the convenience becomes a distinct symbol and falls out of its Topics group unless curated) that would otherwise have shipped 37 times, and settled three open design questions in one pass. The **census was re-derived rather than trusted** — both reviewers independently reproduced 91/15 and the 37/54 split, after the first census came up **17 short** by grepping protocol *declaration* files and missing the two protocols keeping conveniences in a sibling `+Defaults.swift`. Two lasting False-green bullets came from it: a mechanical sweep did a first-occurrence `str.replace` per file, stripping the default from `favouriteMovies` instead of `lists` **while reporting exactly the 36 edits expected**, and the new checker passed on an empty scan (a typo'd path printed success and exited 0) — so a matching count is not evidence, and a checker must compare against an explicit set. Also **shipped a gate that did not gate**: the check went into `make lint`, but no workflow invokes `make` (the `Lint` job runs swiftlint/swiftformat inline), so it was invisible to CI — now its own step and the gotcha *No workflow runs `make`*. Its "one improvement" — have `/capture-knowledge` prompt "what fails if that number changes?" when an entry records a defect count — **shipped**, and is the *When an entry records a count* section of that skill today. |
| 2026-08-07 | #409 | full | TMDb v4 authentication. The lasting practice is **probing the live API before writing the plan's models**: TMDb's v4 docs are wrong in ways reading cannot surface — documented endpoint *names* 404, the same field has different wire types on different endpoints, `clear` is a state-changing GET, and both `create(public:)` and add-items' `comment` are accepted-then-ignored. Each was found by curl and each would have shipped as a bug. The corollary, now in `tmdb-api-notes.md`: v4 auth-gates *before* routing, so a 401-vs-404 path probe proves nothing until you hold a credential — which is exactly how the wrong paths survived into an approved plan. The adversarial plan review paid for itself twice, both unanimous: patching only `CacheHTTPClient` would still leave the always-on 1 GB on-disk `URLCache` leaking private reads across users, and splitting `V4ListService` across two PRs would have made the second source-breaking — forcing a redraw of the decomposition along a *protocol* boundary, which dissolved a third blocker for free. Its "one improvement" — stop ending the turn at phase boundaries to report status — is the autonomy contract `/deliver` states today. |
| 2026-07-29 | #407 | full | Hardened the delivery skills themselves. **Review before writing** paid outright: three plan-review rounds (37 + 9 + 11 findings) ran before a file was edited, and round 1 blocked v1 for **data loss** (the worktree sweep would remove unpushed work) and **credential exposure** (a public repo, with a headless job pasting diagnosis text verbatim into an issue); round 2 caught ACs still grading mechanisms the plan had just cut, which would have red-gated Phase 6 by construction. Verifying mechanisms rather than asserting them caught the content-stamp's first form as a false green — `git ls-tree` has no exclude pathspec, so both hashes were git's empty blob and compared equal. Its lasting legacy is the **reflexive-delivery rule**: three defects all came from the pipeline rewriting itself (a rewritten `/deliver` grading its own rewrite, ACs outliving their mechanisms, and a fan-out shipped as prose in the PR arguing prose isn't a gate), and the Phase 0 reflexive flag that pins verification to the original text **shipped** from this entry's one improvement. Also the origin of the post-ready review lesson: a readiness call was declared with CI green, then a review of the newest code returned fix-first with a major — the fan-out validated its args' shape but not their elements, so malformed input spawned agents on `undefined` and reported full coverage. Nothing in five earlier passes had read the last-written code as code. |
| 2026-07-28 | #404 | full | Made `Company.logoPath` and `originCountry` optional. Two practices worth keeping. **Sample the population, don't spot-check**: one `curl` showed `logo_path: null` and nearly ended the investigation, while sampling 54 companies produced the field/nullability matrix that proved `origin_country` was in scope and `description`/`headquarters` were not — the difference between a correct fix and a subset. And **"consistent within the type" beats "matches the siblings"**: adjudicating a 2–1 critic split toward the lone dissenter left `Company.logoPath` mapping `""` → `nil` while `Company.Parent.logoPath` still threw — the exact bug the delivery existed to remove, one level down, caught by the independent grader. An unobserved value ranks the risk; it does not close the case. Its "one improvement" — run the rubric grader **before** `/capture-knowledge`, since Phase 7 changed a design that had already invalidated a committed Phase 6 entry — **shipped**, and is the ordering `/deliver` uses today. |
| 2026-07-27 | #401 | full | Cached image URL resolver behind `client.images` (ADR-0013). Two practices worth keeping. **Drive each concurrency hazard out of a genuine red**: the naive memo measured *100 fetches at peak concurrency 76* under 100 concurrent callers and the refresh ABA returned `["first"]` where `["second"]` was expected, which produced evidence those are real regression tests for free. And **plan review caught a bug the plan could not have shipped without** — the cache rules said *what* to memoise but never *who writes state*, so a superseded fetch would clobber a newer `refresh()`, a permanently stale cache that none of the 13 planned tests would have caught; the generation counter came from that, pre-code. Also the source of *a caller that **joins** a shared in-flight fetch is invisible to the mock or gate*, so a gate-based barrier cannot observe coalescing — two tests were wrong by construction, not by observation (0/65 reproductions), fixed with an on-actor entry counter: **after a concurrency fix, re-review the tests, not just the code**. Its real cost was the delivery that made both build-isolation rules concrete: `make build-docs` *mutually invalidates* every other build, because `Package.swift` branches on `SWIFTCI_DOCC` into two different dependency graphs **and** two per-target source lists sharing one `.build` — so interleaving 5 docs runs with unit/release builds while 5–7 review agents built into the same scratch dir produced *cyclical*, not merely slow, work and ~10 `zsh` pipelines pinned at 100% until the user force-quit them. Both improvements shipped: `build-docs` got its own scratch path, and `/deliver` now forbids builds in reviewer/grader prompts and serialises its review phases. Also clarified that the live integration suite is **deliberately serialised** (40 suites on a global `.integrationGate` semaphore), so most of that wall-clock was by design. |
| 2026-07-24 | #398 | full | Extracted the `TMDbIntelligence` product — ~40 sources, ~110 fixtures and ~30 tests relocated behind new targets. Two lasting rules came out of it. **Run `swift build -c release` before declaring implementation done**: a `@testable import` inside the new *non-test* `TMDbTestFixtures` target broke the release build *only*, while debug, `--build-tests`, 2868 unit and 291 integration tests all passed — now a hard Phase 3 checkpoint and a `gotchas.md` entry. And **share fixtures via a `package`-access target, never a `@testable` one** (now a wiki pattern). The plan critics paid for themselves twice over, catching that `TMDbTestingTests` referenced a symbol that was moving out, and unanimously that the planned `.xctestplan` sweep was **ghost work** — those files are gitignored and untracked. Counting tests rather than trusting green proved the move lossless (2868 → 2868, then 2869 → 2869 after rebasing onto #396/#397, whose `.docc` `exclude` list turned out to be **per target**, so the two new catalogs silently re-introduced the failure that only `make ci` caught). Rubric **self-graded — the independent grader died on a session limit; recorded, not silently passed**. |
| 2026-07-24 | #397 | full | Enriched `TMDbError` with structured context (ADR-0012). The plan review paid for the delivery on its own: a critic caught, before a line was written, that the new public `endpointPath` would carry `guest_session_id` (a bearer-like credential) and `account_id` (PII) into a loggable field — the redactor and its tests came from that finding, and `security-review` later confirmed the control covers all 137 request-path templates. Now the wiki pattern *a-diagnostic-field-added-for-logging-is-a-publishing-surface*. Capturing **real** error bodies from the live API while planning (`curl -D-`) beat the plan's guesses: 400/code 22 and 422/code 20, not the invented 422/code 5. Environmental friction was severe — the Xcode 27 / Swift 6.4 `.docc` trap made `make ci` unrunnable, and the first attribution (xcsift `--Werror`) was **wrong**: `pipestatus` showed `swift build` exiting 1 and xcsift 0, which is why the build/test skills now say the exit status is the verdict, not the summary. |
| 2026-07-24 | #390 | full | Migrated model runtimes from `Int` minutes to `Duration` (ADR-0011). The lasting pattern is store-the-raw / expose-the-computed: keep the integer-minute wire value in a private stored property and expose `Duration` as a computed one, so `Codable` stays synthesized and the wire format cannot silently drift — no hand-written 30-property `encode` to maintain. Now the wiki entry *bridge-a-wire-type-to-a-domain-type-inside-the-model*. The `.convertFromSnakeCase` → camelCase-`CodingKeys` check caught the `episodeRunTime` rawValue trap before it broke decode. Its "one improvement" — run the tooling-runner in the *active worktree* rather than the main checkout — recurred verbatim in #397 one delivery later and shipped in #399. |
| 2026-07-08 | #387 | lite | Bumped the CI workflows to Xcode 26.6. The lasting practice: a plan-time `WebFetch` of the `macos-26` runner-image README confirmed `/Applications/Xcode_26.6.app` exists (build 17F113) **before** pinning it — retiring the one real risk of a toolchain-version bump, pinning a version the runner does not ship, at plan time rather than in CI. Now the wiki heuristic *before-bumping-a-pinned-ci-toolchain-version-verify-the-runner-image-ships-it*. `security-review` ran (workflows are security-relevant) and returned 0 findings. |
| 2026-07-06 | #385 | lite | Consolidated the build/test runners into a single `tooling-runner` agent (ADR-0014, model tiers). The plan-time Explore cross-reference sweep pre-scoped the prose blast radius and cut the edit list to 11 files — noticing that "delegates to a Haiku subagent" stays *true* after the refactor, since the runner agent **is** Haiku. Lasting caveat: a freshly added `.claude/agents/*.md` may not register as a spawnable `subagent_type` until a new session, so a consolidation like this cannot be smoke-tested end-to-end inside the delivering session; the first post-merge `/build` is the real verification. |
| 2026-07-05 | #384 | lite | Added the Phase 0 knowledge-consult step and the independent Phase 6 rubric grader — the two gates that make captured knowledge compound and stop the maker grading its own homework. Smallest delivery to date (+49/−8), and the plan arrived with ACs already in Given/When/Then form, so the entry gate extracted the rubric with zero friction. Its own knowledge-consult was done implicitly (the design phase had already read the relevant material); the `consulted:` ledger line is what made it explicit from the next run on. Its "one improvement" — extend the consult step to standalone `/implement-plan` invocations — **shipped in #443**, which added `/implement-plan`'s *Step 0 — Consult the knowledge base*. |
| 2026-07-05 | #383 | lite | Restructured `deliver/SKILL.md` for progressive disclosure — a lean core plus `references/` loaded on demand — after the skill had grown past what fits in working context. Paired with an adversarial mapping review that diffed old against new hunting specifically for dropped or weakened rules, which is the practice that made the compression safe and is now the wiki entry *restructure-a-normative-doc-with-a-rule-inventory-and-an-adversarial-mapping-review*. |
| 2026-07-05 | #382 | lite | Moved the `/deliver` retro to pre-PR so it rides the delivery's own PR instead of re-opening the ready gate. Both open design decisions were settled with the user via `AskUserQuestion` *before* any edit, and the change was dogfooded immediately — its own entry was written under the sequencing it introduced. Surfaced the `EnterWorktree` gotcha: the tool ignores the requested name for the **branch** (`git branch -m` after entering), now a `gotchas.md` entry and a standing Phase 1 step. |
| 2026-07-02 | #374 | lite | Reconciled docs/config honesty gaps from two external reviews. The lasting lesson is **verify a review's claims before acting on them**: an 18-agent read-only pass opened and counted every assertion in-repo and caught real overstatements (eight tools not seven, 84 request files not ~95, `.unsupportedLanguage` reachable rather than dead), so only the verified, softened subset shipped — the origin of the wiki heuristic *treat review findings as hypotheses*. Also diagnosed the xcsift false-failure: a benign DocC "unhandled file" warning lands in toon's `errors[]` and flips `status:` to failed on an exit-0 build, so the four build/test skills now say trust the exit status, not the summary. |
| 2026-06-30 | #368 | lite | Hardened the `/deliver` pipeline from an adversarial audit (P1–P5). Established the pattern this repo keeps returning to: an unenforceable process rule gets silently skipped, so encode the ones that matter as blocking gates (the Phase 3a/4a reference-unit review became a ledger task that blocks a later phase). Skipped code review and `/security-review` on its no-Swift diff (as #365 and #366 had) — the self-gating that #407 later had to override deliberately, when a docs-only change carried real risk. |
| 2026-06-25 | #366 | lite | Migrated the skills from the `gh` CLI to the GitHub MCP (ADR-0009), dogfooded end-to-end. The 3-critic plan review paid for itself pre-edit: it caught that `add_reply_to_pull_request_comment` needs a REST comment id `get_review_comments` doesn't expose (so thread replies stay on `gh`), and a wrong method name. Real cost was a registration detour — the hosted `/x/<toolset>` paths are **exclusive**, so pointing at `/x/actions` silently dropped the default PR toolset mid-implementation; `/x/all` fixed it. Lesson that generalises: when a delivery edits the very skills the pipeline runs, the skill registry loads from the main checkout, so the change can only be dogfooded by the conductor acting manually until merge. |
| 2026-06-24 | #365 | lite | Entry/exit criteria + auto-start for `/deliver`. The docs/config fast-gate correctly classified it (CI green in under 2 min). Lasting lesson: auto-start on `ExitPlanMode` approval is a **soft guarantee** — no harness hook fires on it, so it depends on the model reading the contract. First delivery under the new AC entry gate, and the plan had no formal ACs (circular dependency, noted); its "one improvement" — put an inline `Given X, when Y, then Z` example in the gate prompt — **shipped in #438**; the gate now carries that example in both its derive and its stop branches. Its `reviewThreads`/`gh pr view --json` gotcha was superseded by #366 (the MCP migration removed the call) and is deliberately not carried forward. |
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
