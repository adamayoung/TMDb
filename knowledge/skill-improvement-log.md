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
