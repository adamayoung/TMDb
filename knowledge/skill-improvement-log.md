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
