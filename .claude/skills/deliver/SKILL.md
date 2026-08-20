---
name: deliver
description: Take a plan all the way to a ready-to-merge pull request — review the plan (scaled to risk), implement it test-first, code-review and fix, run the CI gate, open the PR, and watch it green. Use after you have an approved plan (from plan mode, or the Plan agent); pass `issue <n>` to deliver a specific GitHub issue you name, or `next` to take the top startable issue off the project board's Ready column — either way it re-verifies, claims and plans the issue first. Invoking it with a plan already in hand is itself plan approval — it then runs autonomously to a single hard stop: ready-to-merge.
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
free. The plan is created first in **plan mode** (or with the `Plan` agent;
there is no `/plan` skill) — `/deliver`
picks up from there. **A selection run supplies its own plan**: `/deliver next`
takes the top startable issue off the project board's Ready column and
`/deliver issue <n>` takes the one you name, then drafts a plan for it
(Phase 0; [`references/next-mode.md`](references/next-mode.md)).

```text
you approve the plan ─▶ /deliver ─────▶ entry gate (ACs?) ─▶ worktree ─▶ [review-plan] ─▶
   (or: /deliver next | issue <n> ─▶ select ─▶ re-verify ─▶ claim ─▶ draft ─▶ approve ─┘)
  implement ─▶ code-review + fix ─▶ security-review + fix ─▶
  rubric check (ACs met?) ─▶ capture ─▶ retro (pre-PR) ─▶ /pr reviewed ─▶ /watch-pr ─▶
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
   (Phase 2), a **red gate you cannot triage** (§4), or — on an **attended
   selection run, under either policy** — the one approval stop on a plan
   `/deliver` drafted for itself
   (Phase 0). That third case is not an exception to this rule but its
   boundary: invoking the skill approves *the plan you brought*, and a selection
   run brought none — naming the issue yourself settles *what* to build, not
   *how*, so `/deliver issue <n>` gets that stop exactly as `/deliver next`
   does. In `auto` it is not a pause at all — the
   `phase0n-selection` panel rules instead.
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
6. **Keep two records: a `TaskCreate` ledger *and* a run file.** The ledger is
   the live view (one task per phase, statuses current, branch, PR number,
   weight); the **run file** is the durable one, because the ledger does not
   survive `EnterWorktree`, an MCP reconnect, or a plan-mode exit. Phase 0
   writes it, Phase 1 records the reconcile into it, **Phases 4/5/6 each stamp
   it on convergence** (`stamps.reviewedClean` / `securityClean` — that is what
   makes a resume able to skip a pass already done), and **Phase 6 reads the
   rubric from it** — so a skipped step fails loudly at a later phase instead of
   silently. **Every phase that writes is named here**, so if a phase you are in
   is absent, nothing writes on its behalf and you must not assume something
   else did. (Two non-phase writers exist and are documented where they apply:
   an async run writes the file **before** any `ScheduleWakeup`, and Phase 1's
   adopt path flips `entry` before re-locking — see `references/`.) Location and schema:
   [`references/worktree-lifecycle.md`](references/worktree-lifecycle.md). A
   template→replicate delivery adds the **`Phase 4a — reference-unit
   review`** gate task, which **blocks Phase 9**. A multi-deliverable plan
   keeps one ledger sub-tree per deliverable.
7. **Jot knowledge candidates the moment a learning occurs** (a lookup, a
   gotcha, a live-API surprise, a non-obvious decision) — one line each
   (`<category>: <gist> [where]`), in the ledger. Phase 7 curates them;
   reconstruction later loses the best material.
8. **Auto-start after plan-mode approval.** `ExitPlanMode` approval IS the
   start signal — invoke `/deliver` immediately; pause first only if
   Phase 0's entry gate fires.

## Invocation — `/deliver [auto] [merge] [next | issue <n>]`

The four keywords are recognised only as whole, standalone tokens **in a
leading run** — parsing stops at the first token that is not one of them, and
everything from there on is the **named plan target** Phase 0 resolves. So
`/deliver auto merge next` is three keywords, and `/deliver auto fix the merge
handling plan` is one keyword plus the target *"fix the merge handling plan"* —
**not** an auto-merge, even though `merge` appears in it. A keyword found after
the target has begun is part of the target; say so rather than acting on it,
because the failure is silent and one-directional: nobody notices an
auto-merge they did not ask for until it has happened.

**`issue` takes exactly one operand** — the issue number, with an optional
leading `#`. So `/deliver auto issue 480` is two keywords plus an operand, and
selects issue 480. Making it a keyword with an operand, rather than letting a
bare number be a selector, is deliberate: a bare number would be a **fourth
token class** that the leading-run rule has to tell apart from a plan target
whose first word happens to be a number, and that ambiguity would have to be
pinned by a parser. `issue` has no such ambiguity, so the grammar stays
prose-sized.

**Four contradictions — report and stop *before* any board write, worktree or
edit**, rather than silently picking one:

- `issue <n>` with a named plan target
- `issue <n>` together with `next` (two selection policies)
- two `issue` operands
- `issue` with no operand, or a non-numeric one

`next` and a named target contradict each other for the same reason. Either
selector takes precedence over a plan already in the conversation, and says so
before drafting.

**Echo the parse before acting on it** — one line, first thing, before any
board write, worktree or edit:

```text
parsed: auto=on · merge=off · select=issue#480 · target=(none)
```

`select=` renders as `issue#<n>` for an explicit pick, `next` for the
top-of-run-list policy, or `(none)` when neither was requested.

The leading-run rule still can't disambiguate a target whose *first* token is a
keyword (`/deliver merge conflict handling plan` reads as `merge` + *"conflict
handling plan"*), and no grammar fixes that without banning reasonable plan
names. An echo does: a mis-parse becomes visible in the second before it
matters, rather than at the moment an unrequested squash-merge lands. Phase 0
already writes this parse to the run file at the same instant, so the line costs
nothing to produce.

- **`auto`** — unattended; every stop-and-ask becomes a juror panel (below).
- **`merge`** — squash-merge once the PR is green, instead of stopping at the
  gate (Phase 10).
- **`next`** — no plan needed: requests the **`top-of-run-list`** selection
  policy, which takes the top startable issue off the board's Ready column and
  drafts one (Phase 0;
  [`references/next-mode.md`](references/next-mode.md)).
- **`issue <n>`** — no plan needed: requests the **`explicit`** selection
  policy, which takes the issue *you* name and drafts one. Same path from there
  on — re-verify, claim, draft, and release the claim on any stop before the PR
  opens. Unlike `next` it may name an issue in **Backlog**: choosing it yourself
  is the triage judgement the Ready test otherwise stands in for.

Both selectors require the user-scoped GitHub Projects MCP — `explicit` still
has to claim the issue — so both are **unavailable on a GitHub Actions
runner**.

### Auto mode & async invocation

`/deliver auto` replaces every stop-and-ask decision with an **adversarial
panel** of three independent Opus jurors — a dead panel is never a proceed,
and every panel convened leaves an audit line in the ledger. Decision points
are marked **Auto:** below. Never delegated: a **data-loss or
breaking-change plan blocker is a hard stop even in auto**, and in
`auto merge` a **breaking** issue is never merged unattended: under `next` it is
not selectable at all, and under `issue <n>` the `merge` opt-in is **dropped**
so the PR waits at the gate ([`references/next-mode.md`](references/next-mode.md)
§5). `/deliver` can
also be queued headless (the plan + ACs must travel in the trigger prompt —
unless `next` supplies them, which only works where the Projects MCP is
mounted). Panel procedure and queuing caveats:
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
**When unsure, prefer full.** The vocabulary is **binary** — a hybrid run
(e.g. a pre-reviewed plan with the full review machinery) records as **full**
with the skipped machinery noted, in the ledger and the retro; never invent a
third tier.

**One named override exists, and it is not a third tier.** An `auto` **selection
run** — under either policy — drafted its own plan with no human between the
issue and the implementation, so
it **always** runs `/review-plan`'s critics whatever the weight (Phase 2).
Record that as `planReview: forced — auto-<policy>` in the run file and the
retro, leaving `weight` itself untouched; a lite run stays lite for Phases 4 and
5. **`explicit` is covered too**: naming the issue yourself puts a human between
you and the *issue*, not between anyone and the *plan*, and it is the plan the
critics read.
An **attended** selection run is **not** covered: its Phase 0 approval stop is
the same consent `ExitPlanMode` gives every other run, so it follows weight as
normal.

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
- Separate worktrees get separate `.build` dirs. No `SCRATCH_PATH` override is
  needed — that flag is only for multiple agents sharing one working directory.
- **One Swift process per worktree — at any instant, across every agent.** Not
  "each agent runs its builds sequentially": *one build in the whole worktree,
  full stop. The conductor owns it.* Concretely:
  - Only the conductor and the `tooling-runner` it spawns may build. **Reviewer,
    security and grader subagents must be told not to build** — their prompts
    say so, and `/review-changes` and Phase 6 above already carry that
    instruction.
  - **Never run two analysis phases concurrently.** Phase 4 and Phase 5 read the
    same commits and feel independent, so "run the security review while the
    fan-out finishes" is tempting — it parallelises tokens but serialises
    nothing on disk. Finish one, then start the next.
  - Never spawn a `tooling-runner` in the background, and never two at once.
  Why it matters more than ordinary contention: every target shares one scratch
  directory, and a `build-docs` run flips the `SWIFTCI_DOCC` manifest, which
  *invalidates* any concurrent build's plan rather than merely queueing behind
  it — so the processes redo each other's work in a cycle. This once put ~10
  `zsh` pipelines at 100% until the user killed them
  (`knowledge/gotchas.md` → *Docs builds need their own scratch path*).

## Phase 0 — Preconditions

- **A plan must exist** (named target → plan-mode plan → most recent in
  conversation). None → stop; ask for one in plan mode. Never invent one —
  **except on the one sanctioned path**: a **selection run** *selects* one
  instead. Under `top-of-run-list` (`next`) it takes
  the top startable issue off the board's Ready column; under `explicit`
  (`issue <n>`) it takes the issue you named, which may sit in **Backlog**.
  Either way it then re-verifies against
  `origin/main`, claims it, and drafts a plan with the `Plan` agent — and
  continues through the rest of this phase unchanged. Procedure, exclusions and
  the `selection` block:
  [`references/next-mode.md`](references/next-mode.md). Selection is part of
  Phase 0 rather than a phase of its own precisely so the run file keeps one
  writer and the knowledge consult below still precedes the drafting that
  consumes it. Nothing startable, or no Projects MCP → **stop before the
  worktree**; never fall through to the "no plan" stop, which reads as an
  unrelated failure.
  **Write the parsed invocation into the run file when you parse the keywords —
  before selection runs**, not after. Record **every** keyword, not just this
  one (`"mode": "auto merge next"`, or `"mode": "auto explicit"` for
  `issue <n>` — `next` and `explicit` are the two **selection-policy tokens**,
  and every gate keys on that rather than on the literal word `next`), plus the
  raw argument string as `invocation`, plus `conductorPid` — this session's PID.
  Written afterwards, a run that skipped selection carries no `mode` either and
  sails through Phase 6's gate as an ordinary run; and `auto`/`merge` recorded
  nowhere durable means Phase 6's `planReview` stop and Phase 10's merge-drop
  both read a keyword the ledger lost at `EnterWorktree` — they would silently
  no-op on exactly the resumed and backgrounded paths the run file exists for.
  **Auto:** the approval stop below becomes the `phase0n-selection` panel —
  proceed with this self-picked issue and self-drafted plan, vs stop.
- **A plan born from a review finding is a hypothesis** — verify against the
  code (quick `Explore`) *before* planning or asking strategy questions.
- **State the goal** in a sentence; **judge the weight**; open the ledger.
- **Pull wiki context** best-effort (`get_context` on the goal); degrade
  silently if the `wiki` MCP is absent.
- **Consult the knowledge base** — skim the entry headings of
  [`knowledge/gotchas.md`](../../../knowledge/gotchas.md) and
  [`knowledge/tmdb-api-notes.md`](../../../knowledge/tmdb-api-notes.md), read
  the entries (and any `knowledge/decisions/` ADR) relevant to the goal's
  area, and record one `consulted: <entries | none relevant>` line **in the run
  file** (and the ledger for convenience). Captured knowledge only compounds if
  it is read at entry — that line is what makes this step checkable, so it must
  live where it survives: **the ledger alone is not enough, because Phase 1's
  `EnterWorktree` clears it.** Phase 8 copies it into the retro, which is the
  committed, human-reviewed copy.
- **Identify the issue this delivers, and record it.** Most deliveries implement
  a tracked issue — `next` takes one off the board's Ready column, and a
  plan usually names one. Record `issue: <number>` on **the deliverable** in the
  run file (or `issue: null` when the work is genuinely untracked, which is the
  honest answer for an ad-hoc fix). Per-deliverable, not run-scoped: a
  multi-deliverable plan can close a different issue per PR, or none. Phase 1
  moves it to **In progress** and Phase 10 to **In review**, so an unrecorded
  issue is one the board silently never reflects. It goes in the run file rather
  than the ledger for the usual reason — `EnterWorktree` clears the ledger.
  A `next` run has already made the **In progress** move itself, at the pick —
  it has to claim the issue before the drafting window, or a concurrent session
  delivers the same one. Phase 1's move then finds it already set and no-ops.
  The claim carries an obligation: **any stop before the PR opens releases it
  back to `selection.claimedFrom`** — the column it was claimed from, which is
  `Ready` for a `next` pick and may be **Backlog** under `explicit`
  ([`references/next-mode.md`](references/next-mode.md)).
- **Flag a reflexive delivery.** If the plan touches any of the **reflexive
  set** — `.claude/skills/**`, `.claude/agents/**`, `.claude/workflows/**` or
  `.github/CODE_REVIEW.md` — this run is **rewriting the
  machinery that runs it**. Record `reflexive: true` in the run file and hold
  two consequences for the rest of the pipeline:

  > **This list is the reflexive set, and it is quoted in two other places** —
  > [`references/next-mode.md`](references/next-mode.md) §5b, which
  > refuses such an issue in `merge` mode, and
  > [`references/worktree-lifecycle.md`](references/worktree-lifecycle.md)'s
  > run-file schema, which defines the `reflexive` field itself.
  > **Change all three or none**, and
  > `Scripts/tests/test_deliver_selection_prose.py` asserts that they agree —
  > this note previously said "exactly one other place" while the third copy had
  > already drifted, which is why the check is now executable rather than a
  > cross-reference. They were
  > briefly out of step: this list omitted `.claude/workflows/**`, so
  > `/deliver auto merge next` could have selected an issue whose plan rewrote
  > `deliver-panel.js` — the script defining the panel that authorises unattended
  > work — computed `reflexive: false`, and squash-merged it with nobody
  > reading the diff. `.claude/workflows/` was already a Phase 5 security
  > surface and a Phase 4 review surface; it belongs here for the same reason.
  > **When in doubt about a path, resolve it as reflexive** — the cost of a
  > false positive is one human merge, and the cost of a false negative is the
  > pipeline silently editing its own gates.
  1. **It cannot be dogfooded before merge.** The skill registry loaded at
     session start comes from the **main checkout**, so your edits are not what
     executes this run. Verify by reading, and say so in the PR — never claim a
     changed skill was exercised end-to-end.
  2. **Pin verification to the original text.** A rewritten rule must not be
     the thing that grades its own rewrite: Phase 6's rubric and any review of
     this diff judge against the ACs and the text as they stood at Phase 0.
     (#407 shipped three defects from exactly this: a rewritten `/deliver`
     grading itself, ACs that outlived the mechanisms they graded, and a
     fan-out shipped as prose in the PR arguing prose isn't a gate.)
  3. **Sweep the rule's whole footprint, not the file you opened.** Changing a
     rule in a `SKILL.md` is not done until you have grepped its own
     `references/`, the skills that delegate to it, and `CLAUDE.md` for the old
     wording — a reference is not a copy of the skill, it is where the skill
     sends you for the procedure, so a stale one is followed rather than
     ignored. Grep for the *old* term, not the new one:

     ```bash
     git diff --name-only origin/main...HEAD | grep '^\.claude/skills/' \
       | sed 's|/[^/]*$||' | sort -u        # every skill dir you touched
     grep -rn '<the old wording>' .claude/ CLAUDE.md .github/CODE_REVIEW.md
     ```

     **Re-sweep after every review-loop fix, not just after the first edit.**
     A Phase 4 or Phase 5 fix that changes the rule *again* has its own
     footprint, and a sweep run against the original change's wording will not
     find it. This is how the recurrence below reached three: the first two
     commits of a delivery swept clean, and the commit that *fixed* the review's
     findings reintroduced the drift — into `.github/ISSUE_FILING.md`, which
     declares itself authoritative over the skills, so the stale copy overrode
     rather than lagged. Sweep is per-commit-that-changes-a-rule, not per-run.

     This has now recurred twice. #441–#443 each fixed `deliver/SKILL.md` and
     left `deliver/references/worktree-lifecycle.md` — the file `SKILL.md`
     points at — still teaching the forbidden `swept:` key, the superseded
     "copy the settings file in" procedure, and a run-file schema missing the
     field Phase 0 had just been told to write. Same shape as #444's
     "the rule landed in `/capture-knowledge`; the sweep was scoped to the
     instances in front of it".
  Phase 4 and Phase 5 both self-skip on a no-Swift diff — **override that here**
  and review the change on its own terms; the diff being markdown is not
  evidence it is low-risk.
- **Decompose a multi-deliverable plan** (rules above); single-deliverable
  plans skip this.
- **Entry gate — a gradeable rubric required.** Plans are expected as
  *"As a \<user-type\> I want \<feature\> so that \<reason\>"* + acceptance
  criteria. Extract the ACs verbatim as
  the **delivery rubric** (consumed in Phase 6) into **the run file** (and the
  ledger for convenience), and record
  `rubricProvenance: supplied`. Three cases, and only the last one stops:
  - **ACs supplied** → the above.
  - **ACs absent but derivable** — the plan has a definition of done in the
    wrong *shape* rather than none at all: a linked issue stating observable
    before/after behaviour, or an explicit `canon-tdd` test list. **Derive** the
    ACs into "Given X, when Y, then Z" form, record
    `rubricProvenance: derived — <the source>`, and say in the PR body that the
    rubric was derived rather than supplied. Bug fixes land here routinely;
    stopping to ask a question the plan already answers is ceremony, not rigour.
    **A selection-run-drafted plan always lands here, under either policy**, whatever its text contains:
    record `derived — issue <number>`, **never `supplied`**. The drafted plan
    will carry ACs — the `Plan` agent writes them — but `supplied` means *a
    human set the bar*, and here the run that gets graded wrote its own rubric.
    This is reflexive rule 2 in another costume: the thing being graded must not
    be the thing that sets the grade. Do not "simplify" it back.
  - **Neither** → stop and ask for them ("Given X, when Y, then Z") — don't
    enter the worktree. **Auto:** panel — proceed rubric-less (Phase 6 no-ops)
    vs stop; record that as `rubric: none`, which is **present-and-empty**, not
    a missing file.

  **Reject a knowledge-shaped AC — it cannot pass.** This applies to whichever
  case produced the rubric: an AC whose evidence is a `knowledge/` artifact ("an
  ADR records X", "the `next-major.md` entry is removed", "a gotcha is
  captured") is **guaranteed** to fail its first grading, because Phase 7 writes
  that artifact *after* Phase 6 grades. That ordering is deliberate — capture
  must observe the delivery's final state, not an intermediate one — so the fix
  is at this gate, not in the sequence. Drop such an AC from the rubric when
  extracting it; the work still happens and is still enforced, by Phase 7's own
  contract (its `swept:` line and capture report). Say which ACs you dropped and
  why, rather than silently reshaping the user's criteria. When *deriving*, don't
  write one in the first place.

  Derive to *grade yourself honestly*, not to pass: write the ACs from the
  source's own words before implementing, never after, and never soften one
  because the implementation went another way. The provenance field is what
  makes a derived rubric auditable, and Phase 6's independent grader — which
  sees only the ACs and the committed diff — is what stops a self-serving one.
- **Read the plan's content into context now** — `EnterWorktree` switches CWD
  (clearing the plans cache), and a fresh worktree lacks uncommitted local
  files; the plan must travel in the conversation.

## Phase 1 — Reconcile prior runs, then enter an isolated worktree

Procedures and traps:
[`references/worktree-lifecycle.md`](references/worktree-lifecycle.md).

1. **Reconcile before `EnterWorktree`** (the run file already exists — Phase 0
   wrote it; record the sweep *into* it, never mint a second one).
   Enumerate with **`git worktree list --porcelain`** (never
   `ls .claude/worktrees/` — that path doesn't exist inside a worktree, so the
   old sweep silently swept nothing), scoped to
   `<main-root>/.claude/worktrees/`, and classify every one first-match-wins:
   `live` (lock PID alive — never touch) / `report` / `reclaim` (merged **and**
   Phase 12's two proofs) / `resumable` / `settled`. **Report, never remove,
   anything that doesn't prove reclaimable**, and verify a directory is gone
   before counting it reclaimed. Record `reconciled:` in the ledger, the
   `reconciled` block in the run file, and the retro (Phase 8) — **never as
   `swept:`, which is Phase 7's knowledge sweep and will silently take the
   slot**. Procedure, buckets and traps:
   [`references/worktree-lifecycle.md`](references/worktree-lifecycle.md).
   **Release stranded selection claims while you are here — keyed on the PID,
   not on a bucket.** For every run file whose `mode` names a **selection-policy
   token** (`next` or `explicit`) **or which carries a `selection.policy`**,
   with `pr: null`,
   `status: open`, **no `claimHandedBack` stamp**, and **`selection.claimed` not
   `false`**, test its `conductorPid` with `kill -0`. **Dead** → that run is
   holding an issue in **In progress** with nobody to release it: move the issue
   back to **`selection.claimedFrom`** (the column it was claimed from —
   defaulting to **Ready** when the field is absent, which is every pre-change
   run file), **stamp `claimHandedBack: <iso8601>` on the deliverable**,
   and count it in the `reconciled` line's `claims released` slot. **Alive, or
   the PID is absent/unparseable** → leave it entirely, and report it.

   > **Release to `claimedFrom`, never unconditionally to `Ready`.** The
   > `explicit` policy may claim an issue out of **Backlog**, and returning that
   > to `Ready` would promote untriaged work past `/triage-issues`' Ready test
   > with no Priority or Size — giving that column a second owner and feeding
   > unvetted work to the next unattended `next` run. This sweep runs in a
   > *later, different session* than the run it is cleaning up, so the origin
   > column has to have been persisted at claim time; it cannot be inferred here.

   Both extra predicate clauses prevent the sweep from taking an issue away from
   a **live** delivery, which is the same harm the claim itself exists to
   prevent — just reached from the other direction:
   - **`claimed: false`** means that run's claim write failed and it proceeded
     unclaimed (`references/next-mode.md` §6). It never held the issue, so there
     is nothing to give back — and by now another run may legitimately hold it.
   - **`claimHandedBack`** makes the release **idempotent**. The predicate is
     otherwise still true after a release, so the next run re-releases the same
     issue; once it has been re-claimed by anyone, that repeat is a theft rather
     than a recovery. Nothing else closes the file: bucket 4 explicitly permits
     a dead run file to be left standing.

   **Evaluate the predicate at two scopes** — it mixes them, and only looks
   unambiguous at one deliverable. `mode`, `conductorPid` and
   `selection.claimed` are **run**-scoped; `pr`, `status`, `issue` and
   `claimHandedBack` are **per-deliverable**. So walk the deliverables: release
   and stamp **each qualifying one independently**, rather than asking whether
   "the run" has a PR. A batch where deliverable 1 has merged and 2–3 are still
   open otherwise either never releases anything or strands the rest behind one
   stamp. A `next` pick *can* decompose — Phase 0's decomposition runs after
   selection, and the board currently holds batch-shaped issues.
   One corollary: `claimed: false` suppresses the release of
   `selection.picked`'s issue **only**. A batch's other issues reached
   **In progress** via Phase 1 step 5, not via the `next` claim, so that flag
   never described them.
   Do **not** key this on the worktree buckets. `resumable` tests the PID, but
   `settled` does not test liveness at all, and — decisively — a `next` run
   holds its claim from **Phase 0, before any worktree exists**, which is the
   whole reason it claims early. Such a run has no worktree to classify, so a
   bucket-keyed rule either releases a **live** conductor's claim while it waits
   at the approval stop (re-opening the double-delivery the claim prevents, in
   the exact window it was designed for) or never releases it at all. The PID
   test is the only thing that separates those two, and it covers the
   pre-worktree window the buckets cannot see. Treat an `EPERM` from `kill -0`
   as alive, and cross-check a suspiciously old PID against
   `ps -p <pid> -o lstart=` exactly as the lock-liveness rule does.
2. **Enter** with `EnterWorktree(name: "<prefix>/<slug>")` (`feature/`,
   `fix/`, `chore/`, …) — sanctioned auto-use, don't ask. **Verify the branch
   name afterwards** (`git branch --show-current`; `git branch -m` if the
   tool renamed it). Already in a worktree? Don't nest — branch there.
3. **Check `.claude/settings.local.json` arrived** — `.worktreeinclude` at the
   repo root copies it into every worktree Claude Code creates, so this is a
   verification (`test -f .claude/settings.local.json`), not a copy. Missing →
   copy it from the main checkout and say so.
   **It carries the credentials**, not just permissions: `TMDB_API_KEY`,
   `TMDB_USERNAME`, `TMDB_PASSWORD` and the two v4 tokens live in its `env`
   block, and a fresh checkout has none of them, so without it the integration
   suites cannot authenticate. (Permission *approvals* no longer need copying —
   since Claude Code v2.1.211 they save to the **main checkout's** copy and
   apply in every worktree of the repo.) Never paste its contents anywhere.
4. **Record worktree + branch in the run file and the ledger, and (re-)create
   the ledger here** — the ledger is CWD-scoped and cleared by `EnterWorktree`,
   an MCP reconnect, or a plan-mode exit; found empty later → re-create from
   the phase list and the run file, it isn't lost work. Set the run file's
   `entry` to `created`, or to `adopted` when resuming an existing worktree
   via `EnterWorktree(path:)` — **Phase 12's teardown branches on it.**
   **Adopting a selection run whose deliverable carries `claimHandedBack`?** Its
   issue was handed back to its `selection.claimedFrom` column while it was dead
   and may now belong to
   someone else. Re-run the claim steps in
   [`references/next-mode.md`](references/next-mode.md) §6 before resuming —
   `Status` neither `claimedFrom` nor claimable → stop and say the issue was
   re-claimed elsewhere. **Do not test against `Ready` specifically**: a
   Backlog-claimed issue is handed back to *Backlog*, so a `Ready` test would
   report "re-claimed elsewhere" for every `explicit` resume and brick it.
   Resuming on the strength of a claim the sweep already released is how an
   adopted run comes to "release" an issue a live delivery is holding.
5. **Move the issue to `In progress`** — the run file's `issue`, if it has one.
   This is the right moment rather than Phase 0: the entry gate can still stop a
   run, so the worktree is the first step that commits to doing the work. Column
   vocabulary and the exact call:
   [`.github/ISSUE_FILING.md`](../../../.github/ISSUE_FILING.md) →
   *Board status — the column lifecycle*. No issue → skip and say so; a failed
   board write is reported, never fatal.
6. **Edit via worktree paths**: re-`Read` anything read before entering, and
   **verify `git status` shows your diff in the worktree before trusting the
   first green build** (empty diff + baseline counts = edits went to `main`).

Invoked from plan mode? That approval *is* the start signal — exit plan mode,
enter, proceed.

## Phase 2 — Harden the plan (no approval stop)

**Lite, or already adversarially reviewed this session** (a converged
`/review-plan`, or an equivalent in-conversation critique whose findings were
applied) → skip the critics. `ExitPlanMode` approval alone is consent, not
review — it does **not** skip. **An `auto` selection run never skips**, under
either policy and at any weight: no
human read the plan before implementation, so the critics are the only review
it gets. Record it as `planReview: forced —
auto-<policy>` (see *Delivery weight*); an **attended** selection run follows
weight as normal, because its Phase 0 approval stop is that missing human. **Full with an
unreviewed plan**
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
work is committed; re-confirm the weight from the diff. Three hard checkpoints:

- **Run `swift build -c release` before declaring implementation done** —
  **directly via `Bash`, not `/build`**: `tooling-runner` exposes only
  `build`, `build-tests`, `test` and `integration-test`, so there is no
  delegated runner for the release build and asking for one silently gets
  you a debug build. Use `make build-release`.
  debug-green is not evidence the release gate passes. `swift build`,
  `--build-tests` and both suites all compile the package with
  `-enable-testing`; the release build does not, so **access-level and
  `@testable` mistakes fail there and nowhere else** — precisely what target
  extractions, new non-test targets, and visibility changes are made of. It is
  a ~30s check that guards `make build-release`, `make ci`, and the *Build for
  Release* steps of both CI Build and Test jobs. (Incident: PR #398 shipped a
  `@testable import` inside a new non-test fixtures target; debug, `--build-tests`, 2869 unit and 291
  integration tests all passed while release was red — caught only in code
  review. See `knowledge/gotchas.md`.)

- **"Fix every instance of pattern X" → enumerate ALL sites up front** with a
  single **type-driven sweep**, listed in the test list before implementing —
  piecemeal discovery ships subsets (incidents:
  [`references/review-loops.md`](references/review-loops.md)). Do that sweep
  with the **LSP** (`ToolSearch("select:LSP")` → `findReferences`,
  `incomingCalls`, `goToImplementation`), not `grep`: a text pattern
  under-reports silently — ADR-0008's grep recipe found four of eight path
  interpolation sites, and the three it missed carried a credential (#421).
- **Consult the specialist skills — mandatory, topic-triggered, including for
  fanned-out subagents.** `swift-concurrency` the moment actors,
  `@MainActor`, `Sendable`/`@unchecked Sendable`, locks, `Task`/task groups,
  or any data-race question appears — to *design*, not just debug;
  `swift-testing-expert` when writing or structuring tests. Same in Phase 4:
  run concurrency-sensitive findings through `swift-concurrency` before
  accepting or dismissing them.

## Phase 4 — Code review + fix loop

**Skip entirely if the diff has no reviewable code — no Swift, no
`.claude/workflows/` script and nothing under `Scripts/`** (`/review-changes`
self-gates on the same set). **Exception — a reflexive delivery** (Phase 0 set
`reflexive: true`): do **not** skip. Run `/review-changes` with
`force-review` so it reviews the change on its own terms; a diff being
markdown is not evidence it is low-risk, and this is the case #407 shipped
three defects through. Review
**stable** code once the design settles — not per TDD item. Granularity by
weight:

- **Lite** → one review of the full diff (single-reviewer path).
- **Full, template→replicate** (one pattern across N≥3 cohesive units) →
  **review the reference unit before the rest are generated**: the hard
  `Phase 4a — reference-unit review @ <sha>` ledger task **blocks Phase 9**
  (procedure: [`references/review-loops.md`](references/review-loops.md)).
- **Full, otherwise** → one review of the full end diff via the fan-out
  path; do **not** interleave per unit.

**A small diff does not downgrade a `full` review.** Weight is decided by the
*risk surface* (§*Delivery weight*), and "single-unit" is one of lite's
conjunctive conditions, not an alternative to it — so a cohesive 200-line
concurrency fix is still `full`, and still takes the fan-out. That is the case
the multi-dimension lenses exist for: this repo's concurrency defects are
precisely the ones that survived a single reviewer and were caught later, or
on another platform (#401, #433, #461). **Tell `/review-changes` the weight**
when you invoke it, so its own size heuristic cannot silently re-decide what
Phase 0 already judged.

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
`Package.swift`/`Package.resolved`, `.github/workflows/`, `.claude/settings*`,
or **`.claude/workflows/`** (committed scripts that spawn agents and gate
autonomous decisions). Pure docs/markdown → skip. No scale-down on lite.
Invoke **`/security-review`** (findings only — the conductor fixes) and
converge with the Phase 4 loop: fix each **High** (and any Medium with a
concrete attack path) test-first where reproducible, commit, re-invoke, cap
at 3. **Auto:** panel — but a **credential leak or clear exploit is a hard
stop even in auto**. This is the pipeline's **only** security gate (CI has no
SAST). Surfaces that bite:
[`references/review-loops.md`](references/review-loops.md).

## Phase 6 — Rubric verification (exit gate)

Take the rubric (Phase 0 ACs) **from the run file** — the ledger copy is a
convenience, not a source, and the plan text in context is not one either.
Three distinct cases, and they must not be conflated:

- **File present, rubric populated** → grade it (below). Grade a `derived`
  rubric exactly as strictly as a `supplied` one — the provenance is there to be
  disclosed, never to lower the bar.
- **File present, `rubric: none`** → the sanctioned rubric-less path; skip.
- **File missing, or missing its `reconciled` block** → **hard stop.** A
  missing run file is not a pass, exactly as a dead grader is not a pass; and a
  file without `reconciled` means Phase 1's sweep never ran. This is what makes
  both gates real rather than advisory.
- **A `mode` naming a selection-policy token (`next` or `explicit`) with
  `selection` missing or empty** → **hard stop**, the same
  way and for the same reason: it means the selection in
  [`references/next-mode.md`](references/next-mode.md) never ran, so nothing
  established that this issue was the right one, still verified, or claimed.
  Without this the `selection` block would be telemetry no phase reads — a
  green indistinguishable from never having looked. (`mode` is written at
  Phase 0's keyword parse, *before* selection, so a skipped selection shows up
  as a policy token with no `selection` rather than as an ordinary run.)
- **A `mode` naming `auto`, together with a selection-policy token
  (`next` or `explicit`) in `mode` — or a `selection.policy` — and `planReview` missing**
  → **hard stop.** That field is the sole record that the forced `/review-plan`
  actually ran, and a self-drafted, unattended plan whose critics
  were skipped is the least-reviewed thing this pipeline can produce — whether
  the run picked the issue itself or you named it, because neither puts a human
  between the issue and the plan. Read
  `auto` from the run file's `mode`, never from memory of the invocation — the
  ledger that held it does not survive `EnterWorktree`, a resume, or Phase 10's
  background handoff.

How it is graded depends on weight:

- **Lite** → verify inline: each AC against the committed diff — behaviour
  by diff-scan or a targeted test (`swift test --filter …`), coverage by the
  test + assertion existing, integration by the integration test existing
  (the live run already passed in Phase 3 — no re-run needed).
- **Full** → **an independent grader, not the conductor** — the maker does
  not grade its own homework. Spawn ONE subagent (general-purpose; inherit
  the model) given ONLY the rubric verbatim and the instruction to judge the
  committed work by **reading** `git diff origin/main...HEAD` and the files —
  no conversation context, no implementation narrative. It returns per-AC
  `met`/`not met` + one-line evidence (file:line or test name). Run it
  **synchronously**. Grader dies or returns unusable output → fall back to the
  inline path and note it in the ledger — **a dead grader is not a pass**.
  - **Cap what it may execute, explicitly.** Phase 3 and Phase 9 already run
    the full gates; a grader re-running them proves nothing new and costs
    minutes. Tell it: *at most one targeted `swift test --filter …`, and never
    `make ci` / `make test` / `make integration-test` / `make build-docs`.*
    Left unsaid, a thorough grader will run the whole of `make ci` — one did,
    for 72 minutes, including the 300-test live suite.

Satisfied → mark off. Not → fix test-first, commit, re-verify (full weight:
re-run the grader); a gap needing a plan change is noted in the PR
description. *"Did we build what the plan said?"*, not *"did the build
pass?"*.

## Phase 7 — Capture learnings

Invoke **`/capture-knowledge`**, passing the ledger's knowledge-candidates
list as the skill argument (`$ARGUMENTS` — it travels with the call even
after compaction). It curates: durable, non-obvious, reusable items only,
deduped against `knowledge/`, written to the right file (gotchas / API notes
/ an ADR). Runs **after** the rubric gate, so a grading failure that changes the design cannot invalidate an entry already committed; still before `/pr`, so the notes ride the same PR. Capturing nothing is
a valid outcome. Exception: one or two small entries already authored during
implementation may be committed inline instead — note the inline capture in
the retro.

That ordering is why Phase 0 **drops a knowledge-shaped AC** from the rubric:
grading it would always precede the work. This phase's own contract — the
`swept:` line and the capture report below — is what enforces it instead.

Its report must include the `swept:` line — Phase 7 is the knowledge base's
retirement trigger (the skill's step 5); a report without it means the sweep
did not run. That applies to the inline-capture exception too: a delivery that
touched `Makefile`, `Package.swift`, `.github/workflows/` or `.claude/` still
owes the sweep, whoever wrote the entries.

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

On ready it also moves the issue to **In review**, which it reads from the
`Closes #NNN` line Phase 9's PR body carries — **not** from an argument. Two bare
numbers in one invocation (`/watch-pr <pr> <issue>`) would be ambiguous, and the
PR body is the same link GitHub uses to close the issue on merge, so there is one
source rather than two that can disagree. The run file's `issue` is what Phase 1
uses, before any PR exists.

**THE GATE — hard stop.** Ready → stop; hand the merge to the user; report
the PR URL and state; run Phase 11. The worktree **stays** (torn down only on
merge, Phase 12). Stuck → stop, summarise what's blocking, **keep the
worktree**. **Auto:** stuck → panel (retry via `ScheduleWakeup` vs stop); the
gate itself is not a panel decision — in auto, ready behaves as the `merge`
opt-in. **Opt-in auto-merge:** only if the user passed `merge`, forward it
(`/watch-pr merge <number>`) — the gate becomes "report the merge" → Phase 12.

**`merge` is dropped, not honoured, when *either* holds** — and both apply under
both selection policies (`next` or `explicit`):

1. the run file says **`reflexive: true`** *and* it is a selection run — its
   `mode` names a **selection-policy token** (`next` or `explicit`), **or** it
   carries a `selection.policy`; or
2. **`selection.mergeRefused` is present** — selection already refused the
   opt-in under §5a/§5b/§5c.

Read all of it from the run file, since this phase
runs in the background, potentially long after the invocation. A selection run
did not have a human choose *both* the issue and the plan — `next` chose the
issue itself, and under `explicit` you named an issue but the run still drafted
its own plan — so nobody decided to
merge a rewrite of the pipeline's own skills unattended. Stop at the gate and
say the opt-in was dropped and why.

> **Two witnesses, deliberately.** `mode` is written by hand at Phase 0 and a
> mis-written one silently disables this gate — that has already happened once,
> on the first `explicit` run ever performed, which recorded `mode: "auto"` with
> a full `selection` block. Phase 1 and Phase 10 both read a *completed*
> `selection`, so `selection.policy` is a free second witness and either suffices.
> Only Phase 6's **selection gate** cannot use it — that one gate fires
> precisely when `selection` is **absent**, so it has no second witness to read
> and stays keyed on `mode` alone. Phase 6's **`planReview` stop** is not
> exempt: it fires on a run whose `selection` block is present and complete, so
> it takes the second witness like Phase 1 and Phase 10. Getting that wrong
> would let an unattended, self-drafted plan whose forced critics never ran pass
> the exit gate green — the least-reviewed artefact this pipeline can produce.
>
> **Both conditions are needed; neither subsumes the other.** §5b refuses a
> reflexive candidate at *selection* time, judging from the issue's own fix
> sketch ([`references/next-mode.md`](references/next-mode.md) §5b) and setting
> `mergeRefused`. Condition 1 is the backstop for when that sketch
> **understated** the footprint and Phase 0 discovered the truth only from the
> drafted plan — there is no `mergeRefused` in that case, because selection saw
> nothing to refuse. Dropping condition 1 in favour of the `mergeRefused`
> disjunct alone would let `/deliver auto merge issue <n>` squash-merge a
> rewrite of `.claude/skills/**` that nobody read.

## Phase 11 — Wrap-up (wiki, pattern scan, exceptional retro amendment)

The retro is already on the PR (Phase 8) — **the default path pushes nothing
after the gate**. Guidance:
[`references/wrap-up.md`](references/wrap-up.md).

- **Amend the retro only for a noteworthy watch phase** (stuck check, new
  Critical/High thread, routed flake, wrong readiness call): append a
  one-line `watch:` bullet, commit, push — on the PR branch (watch-only), or
  a fresh branch off `origin/main` as a small follow-up PR (`merge`/auto
  mode, before teardown). Uneventful watch → don't touch it.
- **Any post-gate push re-opens the gate** — after the last exceptional push
  (amendment or approved skill edit), run the `/watch-pr` loop once more on
  the new tip before merge.
- **File what this delivery deliberately left behind.** Every phase that scopes
  something out — a review finding ruled out of scope, a security finding not in
  this change's class, a rubric gap accepted, a breaking change deferred — has
  produced a fact that exists only in this session's transcript until it is
  filed. Open an issue per
  [`.github/ISSUE_FILING.md`](../../../.github/ISSUE_FILING.md) for each, citing
  this PR as `**Origin:**`, and list the numbers in the retro. **Auto mode files
  these too** — it is additive, reversible, and touches no source; the Phase 11
  prohibition is on editing *skill files* unattended, not on recording work.
  Deferring a finding without filing it is how it gets rediscovered as novel six
  weeks later, which this repo has done more than once.
- **Update the personal wiki** — best-effort, `propose_entry` only (never
  autonomous writes); degrade silently if absent.
- **Recurring-pattern scan**: friction/deviations recurring across the last
  ~12 retro entries → numbered proposals. **Consult
  `skill-improvement-log.md` first** and skip anything already decided;
  **wait for explicit approval on each proposal — never edit a skill file
  unasked**; record **every** decision in the log (five-field format). No new
  recurrence → say so and stop. **Auto:** **not delegable** — the panel has no
  Phase 11 decision point and the script throws if asked for one. An unattended
  run must never edit and push the repo's own skill files (least of all the
  panel script itself), so in auto mode it **records every proposal in
  `skill-improvement-log.md` as `deferred — raised unattended, needs review`
  and applies none**. Phase 11 is post-gate, so the run still completes.

## Phase 12 — Teardown on merge (reclaim the worktree)

**The trigger is the merge, and only the merge**: right after a `merge`-mode
merge, or when a watch-only merge is confirmed *within this session*. Session
ends with the PR open → **leave the worktree** (the next run's Phase 1 GC
reclaims it once merged). Stuck/blocked/abandoned → **never** tear down.

Two preconditions, both required, then
`ExitWorktree(action: "remove", discard_changes: true)`:

0. Which teardown applies — the run file's `entry`. **`created`** →
   `ExitWorktree(action: "remove", …)`. **`adopted`** → `ExitWorktree` will
   **not** remove a worktree entered by `path`; it no-ops while you report a
   reclaim. Use `action: "keep"` then remove by hand (unlock → `git worktree
   remove` → `git branch -D`). Either way, **verify the directory is gone
   before reporting a reclaim.**
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

A **selection run** that stops **before its PR opens** owes one extra line: the
issue it claimed has been released back to its `selection.claimedFrom` column,
or it is stranded in a column nothing else can move it out of.

Arguments: $ARGUMENTS
