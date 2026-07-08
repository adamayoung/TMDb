---
name: deliver
description: Take the current plan all the way to a ready-to-merge pull request — review the plan (scaled to risk), implement it test-first, code-review and fix, run the CI gate, open the PR, and watch it green. Use after you have an approved plan (e.g. from /plan) and want the rest of the feature pipeline run end-to-end. Invoking it is itself plan approval — it then runs autonomously to a single hard stop: ready-to-merge.
---

# Deliver

Drive the **current plan** through the whole feature pipeline to a PR that is
green and ready to merge. This skill is an **orchestrator** — it sequences the
existing skills and adds the safety gates; the expertise lives in the pieces
it invokes. It runs **autonomously** from invocation (which is itself plan
approval) to a single hard stop — **ready-to-merge** — auto-scaling its
machinery to the change's risk, and writing a short **retrospective** that
rides the delivery's own PR. Every run happens in its **own git worktree**
(Phase 1; torn down on merge, Phase 12) so the user's main checkout stays
free. The plan is created first with `/plan` (or plan mode) — `/deliver`
picks up from there.

```text
you approve the plan ─▶ /deliver ─▶ entry gate (ACs?) ─▶ worktree ─▶ [review-plan] ─▶
  implement ─▶ code-review + fix ─▶ security-review + fix ─▶ capture ─▶
  rubric check (ACs met?) ─▶ retro (pre-PR) ─▶ /pr reviewed ─▶ /watch-pr ─▶
  GATE: ready-to-merge ─▶ wrap-up (wiki + recurring-pattern scan)
  ▲ the only hard stop
  … then, when the PR actually merges (maybe a later session): teardown (Phase 12)
```

**Detail on demand:** procedures, traps, and incident history live in
[`references/`](references/) — read the named file when its phase arrives,
not up front.

## Agent Behaviour Contract

Non-negotiable. Do these by default, without being reminded.

1. **Invoking `/deliver` is plan approval — run autonomously to the one
   gate** (the diagram above), with no second "is the plan ok?" prompt. The
   only legitimate mid-run pauses: a **blocker** from `/review-plan`
   (Phase 2), or a **red gate you cannot triage** (§4).
2. **Delegate to the existing skills — don't reinvent them**: `/review-plan`,
   `/implement-plan`, `/review-changes`, `/security-review`,
   `/capture-knowledge`, `/pr`, `/watch-pr`, `/fix-integration-failures`.
3. **Never work on `main` — always in a fresh worktree**, entered **before**
   `/review-plan` or any file edit (`CLAUDE.md` forbids editing `main`).
4. **A red gate triages before it stops.** In-diff failure → fix test-first
   and re-run. Pre-existing/unrelated (typically a flaky live integration
   test) → route to `/fix-integration-failures` and re-run — never hard-stop
   on someone else's flake. Only a genuine, in-diff, unfixable break stops
   the pipeline.
5. **Test-first all the way.** Every review-loop fix follows `canon-tdd` —
   failing test first. No untested patches.
6. **Keep a durable phase ledger** — a `TaskCreate` list, one task per phase,
   statuses current, recording branch, PR number, and weight. A
   template→replicate delivery adds the **`Phase 4a — reference-unit
   review`** gate task, which **blocks Phase 9**. A multi-deliverable plan
   keeps one ledger sub-tree per deliverable.
7. **Jot knowledge candidates the moment a learning occurs** (a lookup, a
   gotcha, a live-API surprise, a non-obvious decision) — one line each
   (`<category>: <gist> [where]`), in the ledger. Phase 6 curates them;
   reconstruction later loses the best material.
8. **Auto-start after plan-mode approval.** `ExitPlanMode` approval IS the
   start signal — invoke `/deliver` immediately; pause first only if
   Phase 0's entry gate fires.

## Auto mode & async invocation

`/deliver auto` replaces every stop-and-ask decision with an **adversarial
panel** of three Opus subagents (majority verdict, ledger audit trail);
decision points are marked **Auto:** below. Never delegated: a **data-loss or
breaking-change plan blocker is a hard stop even in auto**. `/deliver` can
also be queued headless (the plan + ACs must travel in the trigger prompt).
Panel procedure and queuing caveats:
[`references/auto-and-async.md`](references/auto-and-async.md). In attended
mode the **Auto:** branches do not apply — stop and ask, as written.

## Delivery weight — auto-scale to risk

Judge from the plan; re-confirm from the diff after Phase 3; record in the
ledger. **Lite** — small, mechanical, single-unit, no risky surface (no
concurrency, networking/`HTTPClient`, or `Decodable`/`CodingKeys` changes; no
new public API beyond a simple additive method; under a few hundred changed
lines) ⇒ skip `/review-plan`'s critics; `/review-changes` takes its
single-reviewer path. **Full** — anything risky or large ⇒ the three-critic
`/review-plan` and the fan-out + adversarial-verify `/review-changes`.
**When unsure, prefer full.**

## Multi-deliverable plans — one run, several PRs

A plan that is a *program* of cohesive deliverables becomes **one PR per
deliverable**. Decompose in Phase 0 with a dependency graph: **dependent**
(consumes a type/API/helper/file another introduces *or substantially
changes*) → **sequence** it
(branch off its dependency, or wait for its merge); **independent** → own
worktree + branch + PR; **unsure → treat as dependent**. Execution is
**serial implement, concurrent watch**: one deliverable at a time through
Phases 1→9, but once its PR is open, start its `/watch-pr` **in the
background** and move to the next. The gate reports the **batch**; each
worktree is torn down as *its* PR merges; a stuck PR never blocks the others.
The full per-deliverable pipeline applies unchanged. (Genuinely parallel
implementation = separate `/deliver` sessions.)

## Context & isolation (by design)

- The conductor stays **lean** (plan reference, ledger, gate, short per-phase
  summaries); heavy work is already isolated in Workflows/subagents — keep it
  that way.
- **Implement runs inline — on purpose** (the TDD list stays visible). Do
  **not** convert it to a silent subagent.
- **The gate stays in the main agent**; phases hand off via git / disk / the
  PR, not context.
- Separate worktrees get separate `.build` dirs; run builds sequentially
  *within* one worktree. No `SCRATCH_PATH` override is needed — that flag is
  only for multiple agents sharing one working directory.

## Phase 0 — Preconditions

- **A plan must exist** (named target → plan-mode plan → most recent in
  conversation). None → stop; point at `/plan`. Never invent one.
- **A plan born from a review finding is a hypothesis** — verify against the
  code (quick `Explore`) *before* planning or asking strategy questions.
- **State the goal** in a sentence; **judge the weight**; open the ledger.
- **Pull wiki context** best-effort (`get_context` on the goal); degrade
  silently if the `wiki` MCP is absent.
- **Consult the knowledge base** — skim the entry headings of
  [`knowledge/gotchas.md`](../../../knowledge/gotchas.md) and
  [`knowledge/tmdb-api-notes.md`](../../../knowledge/tmdb-api-notes.md), read
  the entries (and any `knowledge/decisions/` ADR) relevant to the goal's
  area, and record one `consulted: <entries | none relevant>` line in the
  ledger. Captured knowledge only compounds if it is read at entry — the
  ledger line is what makes this step checkable.
- **Decompose a multi-deliverable plan** (rules above); single-deliverable
  plans skip this.
- **Entry gate — acceptance criteria required.** Plans are expected as
  *"As a \<user-type\> I want \<feature\> so that \<reason\>"* + acceptance
  criteria. Extract the ACs verbatim as
  the **delivery rubric** (consumed in Phase 7) into the ledger. Absent →
  stop and ask for them ("Given X, when Y, then Z") — don't enter the
  worktree. **Auto:** panel — proceed rubric-less (Phase 7 no-ops) vs stop.
- **Read the plan's content into context now** — `EnterWorktree` switches CWD
  (clearing the plans cache), and a fresh worktree lacks uncommitted local
  files; the plan must travel in the conversation.

## Phase 1 — Enter an isolated worktree (before any edit)

Procedures and traps:
[`references/worktree-lifecycle.md`](references/worktree-lifecycle.md).

1. **GC first**: reclaim prior worktrees whose PRs have since merged (one
   `list_pull_requests` call → branch→merged map → remove) — this sweep keeps
   unattended runs from leaking disk.
2. **Enter** with `EnterWorktree(name: "<prefix>/<slug>")` (`feature/`,
   `fix/`, `chore/`, …) — sanctioned auto-use, don't ask. **Verify the branch
   name afterwards** (`git branch --show-current`; `git branch -m` if the
   tool renamed it). Already in a worktree? Don't nest — branch there.
3. **Copy `.claude/settings.local.json` in** from the main checkout (the
   permission allowlist; credentials come from the process env).
4. **Record worktree + branch in the ledger, and (re-)create the ledger
   here** — it is CWD-scoped and cleared by `EnterWorktree`, an MCP
   reconnect, or a plan-mode exit; found empty later → re-create from the
   phase list, it isn't lost work.
5. **Edit via worktree paths**: re-`Read` anything read before entering, and
   **verify `git status` shows your diff in the worktree before trusting the
   first green build** (empty diff + baseline counts = edits went to `main`).

Invoked from plan mode? That approval *is* the start signal — exit plan mode,
enter, proceed.

## Phase 2 — Harden the plan (no approval stop)

**Lite, or already reviewed this session** (a converged `/review-plan`, or
`ExitPlanMode` approval) → skip the critics. **Full with an unreviewed plan**
→ invoke `/review-plan`, present the revised plan + a one-line change log
(applied / rejected) as an **FYI**, keep going —
except a **blocker** (wrong approach, breaking, data-loss), which stops the
run. **Auto:** data-loss/breaking = hard stop (never delegated); other
blockers → panel.

## Phase 3 — Implement the plan

Invoke **`/implement-plan`** (Canon TDD: list shown first, one failing test
at a time, done only when the list is empty and both suites green). It
commits at logical checkpoints — required: Phase 4 reviews **committed**
history. Don't advance until `/test` **and** `/integration-test` pass and the
work is committed; re-confirm the weight from the diff. Two hard checkpoints:

- **"Fix every instance of pattern X" → enumerate ALL sites up front** with a
  single **type-driven sweep**, listed in the test list before implementing —
  piecemeal discovery ships subsets (incidents:
  [`references/review-loops.md`](references/review-loops.md)).
- **Consult the specialist skills — mandatory, topic-triggered, including for
  fanned-out subagents.** `swift-concurrency` the moment actors,
  `@MainActor`, `Sendable`/`@unchecked Sendable`, locks, `Task`/task groups,
  or any data-race question appears — to *design*, not just debug;
  `swift-testing-expert` when writing or structuring tests. Same in Phase 4:
  run concurrency-sensitive findings through `swift-concurrency` before
  accepting or dismissing them.

## Phase 4 — Code review + fix loop

**Skip entirely if the diff has no Swift source** (`/review-changes`
self-gates). Review **stable** code once the design settles — not per TDD
item. Granularity by weight:

- **Lite / single-unit** → one review of the full diff (single-reviewer
  path).
- **Full, template→replicate** (one pattern across N≥3 cohesive units) →
  **review the reference unit before the rest are generated**: the hard
  `Phase 4a — reference-unit review @ <sha>` ledger task **blocks Phase 9**
  (procedure: [`references/review-loops.md`](references/review-loops.md)).
- **Full, otherwise** → one review of the full end diff via the fan-out
  path; do **not** interleave per unit.

Converge via **`/review-changes`**: read the severity-graded report; fix each
**Critical/High** test-first, re-run `/test` (+ `/integration-test` if
behaviour changed), **commit the fix** (an uncommitted fix re-reviews as
still-broken); re-invoke; repeat until none remain. **Cap at 3 iterations**,
then stop and surface. **Auto:** panel — proceed (note unresolved findings in
the PR description) vs stop. Medium/Low: apply the cheap, clearly-correct
ones; note the rest in the PR description. This is the **single substantive
review** — `/pr` therefore runs in `reviewed` mode (Phase 9).

## Phase 5 — Security review + fix loop

**Run only when the diff touches a security-relevant surface**: Swift source,
`Package.swift`/`Package.resolved`, `.github/workflows/`, or
`.claude/settings*`. Pure docs/markdown → skip. No scale-down on lite.
Invoke **`/security-review`** (findings only — the conductor fixes) and
converge with the Phase 4 loop: fix each **High** (and any Medium with a
concrete attack path) test-first where reproducible, commit, re-invoke, cap
at 3. **Auto:** panel — but a **credential leak or clear exploit is a hard
stop even in auto**. This is the pipeline's **only** security gate (CI has no
SAST). Surfaces that bite:
[`references/review-loops.md`](references/review-loops.md).

## Phase 6 — Capture learnings

Invoke **`/capture-knowledge`**, passing the ledger's knowledge-candidates
list as the skill argument (`$ARGUMENTS` — it travels with the call even
after compaction). It curates: durable, non-obvious, reusable items only,
deduped against `knowledge/`, written to the right file (gotchas / API notes
/ an ADR). Before `/pr`, so the notes ride the same PR. Capturing nothing is
a valid outcome. Exception: one or two small entries already authored during
implementation may be committed inline instead — note the inline capture in
the retro.

## Phase 7 — Rubric verification (exit gate)

Take the rubric (Phase 0 ACs) from the ledger; none extracted → skip. How it
is graded depends on weight:

- **Lite** → verify inline: each AC against the committed diff — behaviour
  by diff-scan or a targeted test (`swift test --filter …`), coverage by the
  test + assertion existing, integration by the integration test existing
  (the live run already passed in Phase 3 — no re-run needed).
- **Full** → **an independent grader, not the conductor** — the maker does
  not grade its own homework. Spawn ONE subagent (general-purpose; inherit
  the model) given ONLY the rubric verbatim and the instruction to judge the
  committed work (`git diff origin/main...HEAD`, reading files and running
  targeted `swift test --filter …` as needed) — no conversation context, no
  implementation narrative. It returns per-AC `met`/`not met` + one-line
  evidence (file:line or test name). Run it **synchronously** — it may
  build/test, and builds are sequential within a worktree. Grader dies or
  returns unusable output → fall back to the inline path and note it in the
  ledger — **a dead grader is not a pass**.

Satisfied → mark off. Not → fix test-first, commit, re-verify (full weight:
re-run the grader); a gap needing a plan change is noted in the PR
description. *"Did we build what the plan said?"*, not *"did the build
pass?"*.

## Phase 8 — Write the retrospective (pre-PR)

Write the retro **now, before the PR opens, so it rides the PR itself** and
the gate is never re-opened by a routine retro push. Mandatory. A dated entry
in [`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md),
headed with the **branch name** (Phase 9 backfills the PR number): phases /
skills telemetry, what worked, friction, deviations, one improvement; omit
`watch:` (post-gate amendments only, Phase 11). **Commit it on the PR
branch**, then run the **windowing step** (>~12 full entries → distil the
oldest into the archive table). Format detail:
[`references/wrap-up.md`](references/wrap-up.md).

## Phase 9 — Create the PR

**Gate check first (template→replicate only):** the `Phase 4a` ledger task
must be **completed** — still open → back to Phase 4.

Invoke **`/pr reviewed`** (Phase 4 already converged this code, so `/pr`
skips its internal review). It formats, runs **`make ci`** — the mandatory
gate; `/pr` scales it to a docs-only fast gate when nothing build-affecting
changed — pushes, and opens the PR. **If `make ci` fails, triage** (§4): the
failing test/file in `git diff --name-only origin/main...HEAD`? **In-diff** →
fix test-first, commit, re-run; stop only if it can't converge (**Auto:**
panel — open with the failure noted vs stop). **Pre-existing/unrelated** → a
`main` problem: hand to `/fix-integration-failures`, update this branch,
re-run — never patch an unrelated test here.

Record the PR number/URL in the ledger. **Backfill the retro heading** with
the PR number, commit, push immediately — pre-gate (the superseded CI run is
cancelled by the concurrency group).

## Phase 10 — Watch to ready → GATE: ready-to-merge

Invoke **`/watch-pr`** in **watch-only** mode, **in the background**,
**passing the PR number from the ledger** (`/watch-pr <number>`) — a
background watch must be pinned to its PR, not to "current branch", which
changes when the conductor moves to the next deliverable's worktree. It
resolves threads, fixes failing checks (routing unrelated integration
failures per §4), and loops until **ready** or **stuck**. Ready means
**mergeable now** (branch brought up to date with `main`, re-run green).

**THE GATE — hard stop.** Ready → stop; hand the merge to the user; report
the PR URL and state; run Phase 11. The worktree **stays** (torn down only on
merge, Phase 12). Stuck → stop, summarise what's blocking, **keep the
worktree**. **Auto:** stuck → panel (retry via `ScheduleWakeup` vs stop); the
gate itself is not a panel decision — in auto, ready behaves as the `merge`
opt-in. **Opt-in auto-merge:** only if the user passed `merge`, forward it
(`/watch-pr merge <number>`) — the gate becomes "report the merge" → Phase 12.

## Phase 11 — Wrap-up (wiki, pattern scan, exceptional retro amendment)

The retro is already on the PR (Phase 8) — **the default path pushes nothing
after the gate**. Guidance:
[`references/wrap-up.md`](references/wrap-up.md).

- **Amend the retro only for a noteworthy watch phase** (stuck check, new
  Critical/High thread, routed flake, wrong readiness call): append a
  one-line `watch:` bullet, commit, push — on the PR branch (watch-only), or
  a fresh branch off `origin/main` as a small follow-up PR (`merge`/auto
  mode, before teardown; the same routing applies to any skill edits the auto
  scan commits). Uneventful watch → don't touch it.
- **Any post-gate push re-opens the gate** — after the last exceptional push
  (amendment or approved skill edit), run the `/watch-pr` loop once more on
  the new tip before merge.
- **Update the personal wiki** — best-effort, `propose_entry` only (never
  autonomous writes); degrade silently if absent.
- **Recurring-pattern scan**: friction/deviations recurring across the last
  ~12 retro entries → numbered proposals. **Consult
  `skill-improvement-log.md` first** and skip anything already decided;
  **wait for explicit approval on each proposal — never edit a skill file
  unasked**; record **every** decision in the log (five-field format). No new
  recurrence → say so and stop. **Auto:** the panel adjudicates instead.

## Phase 12 — Teardown on merge (reclaim the worktree)

**The trigger is the merge, and only the merge**: right after a `merge`-mode
merge, or when a watch-only merge is confirmed *within this session*. Session
ends with the PR open → **leave the worktree** (the next run's Phase 1 GC
reclaims it once merged). Stuck/blocked/abandoned → **never** tear down.

Two preconditions, both required, then
`ExitWorktree(action: "remove", discard_changes: true)`:

1. The PR is actually **merged** (`pull_request_read` → `merged: true`).
2. **No unsaved work beyond what's merged**: `git status --porcelain` empty
   **and** `git rev-parse HEAD` equals `git rev-parse @{u}`. Either fails →
   land the work first; do **not** discard.

`discard_changes` is safe *only because* precondition 2 proved nothing
un-merged remains (a squash-merge means the branch commits aren't literally
on `main`). Leave the main checkout as you found it. Detail:
[`references/worktree-lifecycle.md`](references/worktree-lifecycle.md).

## When the pipeline stops

Wherever it stops — the gate, an untriageable red gate, a stuck PR — end with
a concise status: phase reached, branch and PR, what passed, what's blocking,
and the single next action needed from the user. The destination is a green
PR ready for their merge — say plainly whether you got there.
