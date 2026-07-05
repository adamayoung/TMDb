---
name: deliver
description: Take the current plan all the way to a ready-to-merge pull request — review the plan (scaled to risk), implement it test-first, code-review and fix, run the CI gate, open the PR, and watch it green. Use after you have an approved plan (e.g. from /plan) and want the rest of the feature pipeline run end-to-end. Invoking it is itself plan approval — it then runs autonomously to a single hard stop: ready-to-merge.
---

# Deliver

Drive the **current plan** through the whole feature pipeline to a PR that is
green and ready to merge — without you hand-running each step. This skill is an
**orchestrator**: it does not re-implement review, TDD, or PR logic; it sequences
the existing skills and the `code-reviewer` agent, adds the safety gates, and
keeps going across the long session until the PR is ready.

```text
you approve the plan ─▶ /deliver ─▶ entry gate (ACs?) ─▶ worktree ─▶ [review-plan] ─▶
  implement ─▶ code-review + fix ─▶ security-review + fix ─▶ capture ─▶
  rubric check (ACs met?) ─▶ retro (pre-PR) ─▶ /pr reviewed ─▶ /watch-pr ─▶
  GATE: ready-to-merge ─▶ wrap-up (wiki + recurring-pattern scan)
  ▲ the only hard stop
  … then, when the PR actually merges (maybe a later session): teardown (Phase 7)
```

Every `/deliver` runs in its **own git worktree** (Phase 0.5), so your **main
checkout on disk stays free** — a second Claude session, Xcode, or a manual build
can use it while this delivery runs (and you can launch a second `/deliver` in
another session), with no fighting over the working tree or `.build`. (This very
session is busy delivering; what's freed is the checkout, for *other* tools and
sessions.) The worktree and its `.build` are **torn down on merge** (Phase 7
teardown).

**Invoking `/deliver` on an approved plan is itself the plan-approval gate.** From
there it runs **autonomously** to a single hard stop — **ready-to-merge** — pausing
mid-run only for a genuine blocker (a plan-review blocker, or a red gate it cannot
triage). It **auto-scales** the machinery to the change's risk (see *Delivery
weight*), and writes a short **retrospective** that rides the delivery's own PR
(Phase 3.7) so the workflow keeps improving.

The plan itself is **not** part of this skill — create it first with `/plan` (or
plan mode). `/deliver` picks up from there.

## Agent Behaviour Contract

These are non-negotiable. Do them by default, without being reminded.

1. **Invoking `/deliver` is plan approval — then run autonomously to the one
   gate.** Do not stop for a second "is the plan ok?" confirmation. Proceed through
   branch → (review-plan) → implement → code-review/fix → capture → retro →
   pr → watch-pr to the single hard stop, **Gate: ready-to-merge** (Phase 5). The only legitimate
   mid-run pauses are: a **blocker** raised by `/review-plan` (Phase 1), or a **red
   gate you cannot triage** (Contract §4).
2. **Delegate to the existing skills — don't reinvent them.** Invoke
   `/review-plan`, `/implement-plan`, `/review-changes`, `/security-review`,
   `/capture-knowledge`, `/pr`, `/watch-pr`, and `/fix-integration-failures`
   (`/review-changes` is what spawns the `code-reviewer` agent or the review
   Workflow). This skill only sequences and gates; the expertise lives in those
   pieces.
3. **Never work on `main` — always in a fresh worktree.** Phase 0.5 enters a
   dedicated git worktree (a new branch off `origin/main`) **before** `/review-plan`
   or any file edit, and all work happens there — so the user's main checkout is
   never touched and stays free for concurrent work. `CLAUDE.md` forbids editing
   `main`; the worktree guarantees it. On merge, tear the worktree down (Phase 7).
4. **A red gate triages before it stops.** If `make ci` or a check fails, first
   classify **in-diff vs pre-existing** (Phase 4). A failure your diff caused → fix
   test-first and re-run; only **stop** if it can't converge in the cap. A
   **pre-existing / unrelated** failure (typically a flaky live integration test
   not in your diff) → route it to `/fix-integration-failures` (fix off `main`,
   merge, update this branch) and re-run — **don't** hard-stop on someone else's
   flake. Only a genuine, in-diff, unfixable break stops the pipeline.
5. **Test-first all the way.** Every fix in the code-review loop follows
   `canon-tdd` — reproduce with a failing test, then fix. No untested patches.
6. **Keep a durable phase ledger.** This is a long session that may be summarised.
   Track it in a **`TaskCreate` task list — one task per phase** (Phase 0.5 →
   Phase 6), set `in_progress`/`completed` as you go, and record the branch name,
   PR number, and the delivery weight on the relevant tasks. A task list survives
   compaction better than prose working-notes, so you can resume cleanly. For a
   **template→replicate** full delivery, the ledger also carries the
   **`Phase 3a — reference-unit review`** gate task (Phase 3), which **blocks
   Phase 4** until the reference unit has been reviewed and converged. For a
   **multi-deliverable** plan, keep **one ledger sub-tree per deliverable** (its
   own branch / PR / weight) — see *Multi-deliverable plans*.
7. **Jot knowledge candidates as you go.** Keep a running **knowledge-candidates**
   list (in the ledger) and append to it the *moment* a learning occurs during
   Phases 2–3 — a thing you had to look up or web-search, a gotcha or dead-end, a
   surprising live-API behaviour, or a non-obvious decision. One line each
   (`<category>: <gist> [where]`). Phase 3.5 curates this list; reconstructing it
   at the end loses the best material (and may not survive compaction).
8. **Auto-start after plan-mode approval.** When a plan has just been approved via
   `ExitPlanMode` in this session, invoke `/deliver` immediately — **do not ask
   "shall I start?" or "ready to proceed?"**. The plan-mode approval IS the start
   signal. The only legitimate reason to pause before starting is if Phase 0's
   entry gate fires (missing acceptance criteria) — that is a plan problem, not a
   confirmation prompt.

## Auto mode (unattended)

`/deliver auto` runs the **entire** pipeline with **no human interaction** — every
mid-run decision that would normally stop and ask the user is instead resolved by
an **adversarial panel** of three Opus subagents, and the conductor acts on their
majority verdict and keeps going through Phase 6.

**The panel.** At each decision point, convene three subagents in parallel, each
given the same context (the decision, the evidence, the options):

- **Proceed** — argues the case for continuing the pipeline.
- **Stop** — argues the case for halting and handing back to the user.
- **Devil's advocate** — attacks whichever way looks easiest, so the other two
  can't converge on a comfortable answer unchallenged.

Each returns a one-line verdict (`proceed` / `stop`) and its reasoning. **Majority
wins.** The conductor records the outcome in the ledger and continues — `proceed`
resumes the pipeline; `stop` ends the run with the usual status summary.

**Audit trail.** For **every** panel convened, write a ledger entry recording: the
**decision point**, the **three subagent verdicts**, the **majority outcome**, and
a **one-line rationale**. The point of `auto` is autonomy *with* a full record of
why each call was made — a run that went unattended must still be reviewable.

**The one exception — never delegated.** A Phase 1 `blocker` where the plan would
cause **data loss** or a **breaking change** is **always a hard stop**, even in
`auto`. It is too consequential to hand to a panel: surface it to the user and
wait. (Every other decision point — including all *other* Phase 1 blockers — goes
to the panel.)

Each decision point below marks its **Auto:** branch. In the default (attended)
mode those branches do not apply — the pipeline stops and asks, as written.

## Async / queued invocation

`/deliver` can be **queued to run unattended**, not just driven from an
interactive session — the worktree isolation, the `TaskCreate` ledger, the
Phase 0.5 GC sweep, and `auto` mode (the panel) are exactly what an unattended run
needs. Two existing entry points already do this: a **CCR trigger**
(`create_trigger` with `create_new_session_on_fire`, or the `/schedule` skill)
fires a fresh session whose prompt is `/deliver auto …`, and
`integration-failure.yml` runs a skill **headless** on a runner.

If you queue a `/deliver`, mind two things:

- **Inline the whole plan + acceptance criteria in the trigger prompt.** A fresh
  session has no conversation history, and Phase 0's entry gate **requires ACs** —
  so the plan text and its ACs must travel *in* the prompt, or the run stops at
  the gate immediately.
- **User-scoped MCP may be absent** (`mcp__github__*`, `wiki`). The `gh` fallbacks
  in `/pr` and `/watch-pr` cover GitHub; the wiki step degrades silently. A
  headless GitHub-Actions run has no user MCP at all (it uses `git`/`gh`); a
  CCR-spawned session in your own environment usually keeps them.

**Recommendation — don't routinise async *feature* delivery here.** This is a
single-maintainer package with public API surface, where the **ready-to-merge
human gate is deliberate** — every change is a compatibility call worth a human's
eyes. Async earns its place for the *occasional* away-from-keyboard run and for
the **self-healing integration cron** (which already opens a PR for review, never
merges) — not as the default path.

## Delivery weight — auto-scale to risk (lite vs full)

`/deliver` sizes its machinery to the change, automatically — no flag. Judge the
weight from the plan up front, and re-confirm from the actual diff after Phase 2:

- **Lite** — a small, mechanical, single-unit change that touches **no risky
  surface**: no concurrency (`Task`/actor/`Sendable`), no networking/`HTTPClient`
  layer, no model `Decodable`/`CodingKeys` changes, and no new public API beyond a
  simple additive method; roughly **under a few hundred changed lines**. Lite ⇒
  **skip `/review-plan`'s three-critic pass** (Phase 1) and let `/review-changes`
  take its **single-reviewer** path (Phase 3) — it already self-scales.
- **Full** — anything risky or large: new concurrency, networking, models/decoders,
  a new service or public-API surface, multi-unit work, or a big diff. Full ⇒ the
  **three-critic `/review-plan`** and the **fan-out + adversarial-verify**
  `/review-changes`.

When unsure, prefer **full** — the heavier review is cheap insurance against the
changes that actually bite. Record the chosen weight in the ledger.

## Multi-deliverable plans — one run, several PRs

A plan is sometimes a **program of independent deliverables**, not one change
(e.g. "extract a shared validation helper" + "fix the mis-applied test tags" +
"harden a decoder" — three cohesive changes that don't touch each other). Forcing
those into one PR couples unrelated review and risk; running them as wholly
separate invocations loses the shared plan context. So `/deliver` **decomposes a
multi-deliverable plan into one PR per deliverable**, runs the independent ones in
the same session, and **only serialises the ones that are obviously dependent**.

**Decompose up front (Phase 0).** List the deliverables and build a **dependency
graph**:

- **Dependent** = one deliverable consumes a type, API, helper, or file that
  another *introduces or substantially changes* (e.g. "B calls the shared helper A
  extracts"). Dependent deliverables are **sequenced** — the dependent one
  branches off its dependency (or waits for it to merge).
- **Independent** = no such coupling → each gets its **own worktree + branch +
  PR**.
- **When unsure, treat as dependent and sequence** — the safe default. Split into
  concurrent PRs only when independence is *obvious*.

**Execution — serial implement, concurrent watch.** A single conductor can only
drive one inline `/implement-plan` loop at a time (the implement phase is
deliberately visible — *Context & isolation*), so each deliverable's
**implementation runs serially**, one worktree at a time, through Phases 0.5 → 4
(its own worktree, code review, security review, rubric, PR). What runs
**concurrently is Phase 5**: once a deliverable's PR is open, start its
`/watch-pr` **in the background** and move on to implement the next independent
deliverable — so CI churns on the open PRs while the conductor keeps building.

> The honest win is **N PRs from one run + their CI watched in parallel**, not
> parallel compilation — builds stay serial within the single-threaded conductor
> (cross-worktree `.build` dirs are separate, but the conductor is not). For
> genuinely parallel *implementation*, launch a separate `/deliver` per
> deliverable in its own session (see *Async / queued invocation*).

**The gate becomes a batch.** Phase 5's ready-to-merge gate reports **all** the
deliverables' PRs and their states together (PR A ready · PR B ready · PR C
waiting on PR A) and hands the batch to the user. Each worktree is torn down
(Phase 7) as **its** PR merges, independently; a stuck PR in the batch never
blocks reporting the others as ready. Per-deliverable, nothing else changes —
each PR still runs the full single-deliverable pipeline (weight scaling, review,
security, capture, rubric); multi-deliverable mode only adds the decomposition,
the dependency ordering, and the batched gate.

## Context & isolation (by design)

`/deliver` is a **lean main-context conductor** — it should hold only the plan
reference, the phase ledger, the one gate interaction, and a short summary returned
from each phase. The heavy or independent-judgment work is deliberately isolated so
it never bloats or biases the main window:

- **Already isolated — keep it that way.** `/review-plan` runs its three Opus
  critics in a separate Workflow (only verdicts return); the `code-reviewer`
  agent reads the diff, OpenAPI spec, and MCP in its own context; and `/test`,
  `/build`, `/integration-test`, `/lint` delegate their logs to Haiku subagents.
- **Implement runs inline — on purpose.** `/implement-plan` stays in the main
  context so the Canon TDD test list and each red/green step are **visible** to
  the user, and so it can pause for any mid-implementation decision. Its noisy
  output (test/build logs) is already delegated to Haiku, so the inline cost is
  mostly the edits themselves. **Do not** convert this phase to a silent subagent
  — that would trade away the visibility the workflow is built around.
- **The gate stays in the main agent.** Subagents are non-interactive; the
  ready-to-merge gate is handed to the user, so the conductor — not a subagent —
  owns it. Phases hand off via **git / disk / the PR**, not via context.
- **The work happens in a worktree, the session stays put.** The conductor
  `EnterWorktree`s in Phase 0.5 so the delivery's branch and its multi-GB `.build`
  live in `.claude/worktrees/<branch>/`, isolated from the user's main checkout.
  This is what lets a second `/deliver` (or hand work) run concurrently — separate
  worktrees get separate `.build` directories automatically (the scratch path is
  CWD-relative), so their builds don't collide. No `SCRATCH_PATH` override is needed
  for this; that flag is only for *multiple agents sharing one* working directory.

## Phase 0 — Preconditions

- **A plan must exist.** Locate it the way `/review-plan` does (named target →
  plan-mode plan → most recent plan in the conversation). If there is no plan,
  stop and tell the user to run `/plan` first — do not invent one.
- **If the plan originates from a review finding, verify it first.** When the
  delivery comes from a code-review / source-review *finding* rather than a
  user-authored plan, treat the finding as a **hypothesis, not an approved
  plan**: do a quick `Explore` pass to confirm it against the actual code (Is it
  real? Is the framing right? Breaking or not?) **before** drafting the plan or
  asking the user any strategy questions. Review findings have repeatedly been
  mis-framed — a non-breaking change mistaken for breaking, a false-positive
  "bug", a "fix" that was really a clarity tweak.
- **State the goal** in a sentence so every downstream phase is anchored to it.
- **Pull relevant context from the wiki** (best-effort). If the personal `wiki`
  MCP is available, call `get_context` on the goal to surface any of Adam's
  durable preferences, prior decisions, or conventions that bear on the approach,
  and let them calibrate the plan and the review emphasis. **Degrade silently** if
  the wiki MCP is absent (a contributor's machine, a headless/cron run) — never
  block the pipeline on it.
- **Judge the delivery weight** (lite vs full) from the plan, and open the
  `TaskCreate` ledger (Contract §6).
- **Decompose a multi-deliverable plan.** If the plan is a *program* of more than
  one cohesive deliverable, decompose it now and build the **dependency graph**
  (see *Multi-deliverable plans*) — this decides whether the run opens **one PR or
  several**, and in what order. A single-deliverable plan skips this.
- **Entry gate — acceptance criteria required.** Plans are expected in the form
  *"As a \<user-type\> I want \<feature\> so that \<reason\>"* followed by
  acceptance criteria and any elaboration. Locate the acceptance criteria in the
  plan:
  - **If acceptance criteria are present:** extract them verbatim as the **delivery
    rubric** and record them in the ledger. Proceed silently.
  - **If acceptance criteria are absent:** stop and ask the user to add them before
    proceeding — do not enter the worktree or begin implementation. Be specific:
    *"The plan has no acceptance criteria. Please add them so there is a clear
    definition of done (e.g. 'Given X, when Y, then Z')."*
  - **Auto:** convene the panel on a missing-AC stop. **Proceed** majority → note
    the gap in the ledger, continue without a rubric (Phase 3.6 becomes a no-op).
    **Stop** majority → surface to the user.

  The delivery rubric (extracted ACs) travels through the run and is consumed in
  Phase 3.6.

- **Read the plan's content into context now — before the worktree.** Phase 0.5's
  `EnterWorktree` switches the working directory and **clears the CWD-scoped plans
  cache**, so the active plan reference can be lost after the switch. Locate and
  **read the plan file fully here** (its content travels with the conversation),
  so Phase 1+ can work from it inside the worktree without re-finding it.

## Phase 0.5 — Enter an isolated worktree (before any edit)

Do this **before** Phase 1 — `/review-plan` applies its consensus by editing the
plan, and all of implementation happens next; none of it may touch `main` or the
user's main checkout (`CLAUDE.md` forbids editing `main`; Contract §3). **Every
`/deliver` runs in its own git worktree** so the user's checkout stays free for
concurrent work.

**First, GC any stale worktree from a prior delivery** (this run is the garbage
collector for the *previous* one's deferred merge — Phase 7 only fires on an
in-session merge, and the common path is "merged later, elsewhere"). Sweep the
worktree dirs and reclaim any whose PR has since merged. Get every PR's state in
**one** call — `mcp__github__list_pull_requests` (owner/repo from the `origin` remote,
`state: all`, `perPage: 100`) — and build a `head.ref → merged?` map (a merged PR
reports `state: closed` + `merged: true`). Then, for each worktree branch the map
marks **merged**, remove it:

```bash
# For each $wt under .claude/worktrees/ whose branch ($br) the map marks merged:
git worktree remove --force "$wt" && git branch -D "$br" 2>/dev/null
```

(The branch→merged map comes from the MCP call above; the shell step only does the
removal — tool calls can't run inside a bash loop. Get branches with
`git -C "$wt" rev-parse --abbrev-ref HEAD`.)

This keeps `.claude/worktrees/` (each carrying a multi-GB `.build`) from
accumulating across deliveries the user merged in the GitHub UI or a later session.

**Enter the worktree** with the harness's `EnterWorktree` tool, naming it from the
plan with a conventional prefix — `feature/<slug>` for new work, `fix/<slug>` for a
bug fix, etc.:

- `EnterWorktree(name: "feature/<slug>")` creates `.claude/worktrees/feature/<slug>/`
  and switches the session into it. By default (`worktree.baseRef: fresh`) the branch
  is cut from **`origin/main`**; if the user has set `worktree.baseRef: head`, it's
  cut from local HEAD instead — so don't assume `origin/main` unconditionally. This
  is the sanctioned auto-use of `EnterWorktree` for `/deliver` (Contract §3 +
  memory) — do it without asking. **Note the `fresh` consequence:** the worktree is
  cut from `origin/main`, so any **uncommitted or local-only** state (including the
  on-disk plan file, if it isn't committed) is **absent** — which is why Phase 0
  reads the plan's content into the conversation first.
- **Already in a worktree?** (e.g. the user entered one manually.) Don't nest — use
  the current worktree and just create the branch in it (`git checkout -b
  feature/<slug>`). `EnterWorktree` refuses to nest anyway.

**Restore the local permission allowlist in the worktree.** Credentials are **not**
the concern — `TMDB_API_KEY` / `USERNAME` / `PASSWORD` are injected into the
session's **process environment** at startup (CWD-independent), and `make ci` /
`make integration-test` read them straight from the environment, so a subshell in
the worktree inherits them regardless. What a fresh worktree lacks is the
**gitignored `.claude/settings.local.json`**, which also holds the **permission
allowlist** — and whether the harness re-reads it from the new CWD is unverified, so
without it an autonomous run could stall on permission prompts. Copy it in as cheap
insurance:

```bash
# CWD is the worktree; the main checkout is the first entry of `git worktree list`.
main_root=$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')
mkdir -p .claude
cp "$main_root/.claude/settings.local.json" .claude/settings.local.json 2>/dev/null || true
```

It stays gitignored in the worktree, so it won't be committed. If `make ci`'s
integration leg fails on **credentials**, the cause is the *env* not being inherited
by whatever spawned the subshell — **not** this file; check the environment first.

Record the worktree path and branch name in the ledger. The branch is what the PR
and all later phases (`git diff origin/main...HEAD`, `/pr`, `/watch-pr`) operate on.

**(Re-)create the ledger here, inside the worktree.** The `TaskCreate` ledger is
**CWD-scoped and cleared by `EnterWorktree`** (and can be reset mid-run by an MCP
reconnect or a plan-mode exit), so open the Contract §6 ledger *after* entering
the worktree — and if a later phase finds it empty, **re-create it from the phase
list** rather than treating it as lost work. (Bit #364 and #368.)

**Edit via worktree paths, and verify your diff landed there — not on `main`.** A
file `Read` *before* `EnterWorktree` (e.g. source you scoped in Phase 0) yields a
**main-checkout** absolute path; continuing to `Edit` that exact path after entering
writes to **`main`**, not the worktree (they share `.git` but have **separate
working dirs**). The trap is self-concealing: the build/test then runs against the
still-pristine worktree and returns **baseline** counts, so a green run "confirms"
work that never landed. So: after entering, **re-`Read` source files before editing
them**, and **before trusting the first green build, verify `git status` shows your
diff in the worktree** (an empty diff + baseline test counts = edits went to `main`).
Rescue stranded edits with a shared stash: `git -C <main-checkout> stash` then
`git stash pop` in the worktree. (Same root cause as the fanned-out-subagent variant
in `knowledge/gotchas.md` → *Edits can land in the main checkout*.)

**Invoked from plan mode?** If you reach `/deliver` while in plan mode with an
approved plan, that approval *is* Gate-1: exit plan mode (the plan file is your
input — already read into context in Phase 0), enter the worktree, and proceed —
there's no separate `ExitPlanMode`-then-approve dance, and no second "is the plan
ok?" prompt.

## Phase 1 — Harden the plan (no separate approval stop)

The plan is already approved (Contract §1), so this phase only **hardens** it; it
does not re-ask for approval.

- **Lite change, or a plan already reviewed this session** (a recent `/review-plan`
  that converged, or a plan approved via `ExitPlanMode`) → **skip the critics** and
  proceed straight to Phase 2. Re-running three Opus critics on a settled or trivial
  plan is wasted work.
- **Full change with an unreviewed plan** → invoke **`/review-plan`** (three
  adversarial Opus critics → consensus → applied to the plan). Then:
  - Present the **revised** plan + a one-line change log (applied / rejected) as an
    **FYI**, and **keep going** — do not wait for re-approval.
  - **Exception — a `blocker`:** if a critic raises a blocker (the approach is
    wrong, a breaking change, data-loss, etc.), **stop and surface it** before
    implementing. A blocker means the approved plan would do harm; that's worth the
    interruption. Improvements/`major`/`minor` are folded in and you proceed.
    - **Auto:** a **data-loss or breaking-change** blocker is **always a hard
      stop** (the never-delegated exception). For **any other** blocker, convene
      the panel to decide proceed vs stop and act on the majority verdict.

## Phase 2 — Implement the plan

Invoke **`/implement-plan`**. It derives the Canon TDD test list (shown before any
code), drives the Red-Green-Refactor loop one test at a time, and finishes only
when the **test list is empty** and the suites are green, and expects the
lint/format PostToolUse hook to reshape files after writes.

> **"Fix every instance of pattern X" → enumerate ALL sites up front.** When the
> plan's goal is to apply one change across every occurrence of a pattern (encode
> every path interpolation, validate every public String input, rename every call
> site), do a single **type-driven sweep first** and list the sites in the test
> list before implementing — don't discover them piecemeal. Piecemeal discovery is
> a recurring miss: a grep keyed on the wrong signal finds a subset, and the
> stragglers surface one at a time across code review / security review / the
> `claude-review` bot (PR #364 found a 4th encode site in review and three more
> unvalidated methods from the bot, after both the plan sweep and `/security-review`
> had each missed a different subset). Sweep by **type**, not by eyeballing: e.g.
> `grep 'path = "/.*\('` for String-into-path interpolations *and* scan public
> service signatures for `String`/`*.ID` params — `Int` IDs are injection-safe and
> need nothing. Confirm the full list, then implement against it.
>
> ---
>
> **Consult the specialist skills — don't hand-roll their domains (mandatory).**
> `/implement-plan`'s contract §4 already requires this, but it is easy to skip
> under delivery momentum, so treat it as a hard checkpoint here too — including
> when implementation work is fanned out to subagents/Workflows (give them the
> same instruction). The trigger is the *topic*, not whether you feel stuck:
>
> - **`swift-concurrency`** — invoke the moment the change touches `actor`s,
>   `@MainActor`, `Sendable`/`@unchecked Sendable`, locks (`NSLock`/`Mutex`),
>   `Task`/`async let`/task groups, or any data-race/isolation question. Use it to
>   *design* the approach, not just to debug a diagnostic. (This run hand-rolled an
>   `NSLock`/`@unchecked Sendable` mock design and only consulted the skill when the
>   user prompted — at which point it both validated the choice and caught a missing
>   `@unchecked Sendable` removal-plan. See `delivery-retros.md` 2026-06-23 #359.)
> - **`swift-testing-expert`** — invoke when writing or structuring tests
>   (`@Test`/`#expect`/`#require`, suites, traits/tags, parameterised tests, async
>   waiting), not after hand-writing them.
>
> The same applies in **Phase 3**: when the diff is concurrency-sensitive, run the
> finding through `swift-concurrency` before accepting or dismissing it.

It also **commits at logical checkpoints** as it goes — each commit a coherent,
green, lint-clean increment (`/implement-plan`'s *Commit at logical points*). This
matters for the pipeline: Phase 3 reviews **committed** history (`git diff
origin/main...HEAD`), so committing as you implement means the review sees the real
change rather than an empty diff.

Do not advance until `/implement-plan` reports an empty test list with `/test`
**and** `/integration-test` passing, and the work committed. Re-confirm the
delivery weight from the actual diff now (a "lite" plan that ballooned is `full`).

## Phase 3 — Code review + fix loop

**Skip this phase entirely if the change has no Swift source.** `/review-changes`
self-gates (it returns immediately when `git diff origin/main...HEAD` touches no
`*.swift`), so a docs-only / config-only delivery sails straight to Phase 3.5
with no review. Code review is for Swift.

Review **stable** code, not work in progress. Code review is an independent,
adversarial lens — apply it once the design has settled, not after every Canon TDD
item (the test list is deliberately emergent; early items are reshaped by later
ones, so per-item review just flags churn). The per-item quality gate already
lives in Phase 2 — the passing test, the inline docs, the lint hook, and
refactor-on-green.

**Granularity by delivery weight:**

- **Lite / single-unit** (one method, one model) → review **once**, on the full
  diff after Phase 2. `/review-changes` takes its single-`code-reviewer` path.
- **Full, template→replicate** (one pattern applied across **N≥3 cohesive
  units** — e.g. 25 sibling mocks, "validate every public String input", one
  method mirrored across services; the shape Phase 2's *"enumerate ALL sites up
  front"* blockquote already flags) → **review the reference unit before the rest
  are generated.** This is a **hard ledger gate**, not advice: add a
  `Phase 3a — reference-unit review @ <sha>` task to the ledger, have
  `/implement-plan` commit the first unit on its own, run `/review-changes` scoped
  to that commit (`git diff origin/main...<sha>`), converge its Critical/High per
  the loop below, and only then let Phase 2 replicate the pattern across the
  remaining units. **Phase 4 must not start while this task is open.** A wrong
  foundational pattern caught here is one *not* baked into all N units (the #359
  "reference-first" win: a cross-module DocC break caught in `MockGenreService`
  before it replicated into 25 mocks).
- **Full, otherwise** (multi-unit but *not* template-replicate — several distinct
  models/methods, parallel-similar work, risky concurrency/networking) → review
  **once**, on the full diff after Phase 2, via the fan-out + adversarial-verify
  `/review-changes`. A single end-diff fan-out is the right tool here; do **not**
  interleave per unit — the units don't build on each other, so per-unit review
  only adds churn, and the fan-out's per-dimension adversarial pass already covers
  the whole diff.

Run the review via **`/review-changes`**, which scales the machinery to the diff
itself: a single `code-reviewer` agent for a small change, or a fan-out Workflow
(one reviewer per dimension → adversarial verification of each Critical/High →
reconcile) for a large/multi-unit one. Then converge:

1. Read its severity-graded report (it follows `.github/CODE_REVIEW.md`, including
   the adversarial pass — on the large path, Critical/High are independently
   verified, so they're high-confidence).
2. **If there are Critical or High findings**, fix each one **test-first** via
   `canon-tdd` — failing test that captures the defect, then the fix — then re-run
   `/test` (+ `/integration-test` if behaviour changed) and **commit the fix**.
   The commit is required: `/review-changes` diffs **committed** history
   (`origin/main...HEAD`), so an uncommitted fix would re-review as still-broken and never
   converge.
3. **Re-invoke `/review-changes`** on the updated (committed) diff. Repeat until no
   Critical/High findings remain.
4. **Cap at 3 iterations.** If Critical/High issues persist after three rounds,
   stop and surface them to the user — don't loop forever or paper over them.
   - **Auto:** convene the panel. **Proceed** → note the unresolved Critical/High
     findings in the PR description and continue; **stop** → surface to the user.

Medium/Low findings: apply the cheap, clearly-correct ones; note the rest in the
PR description rather than blocking on them.

This is the **single substantive review** of the change — it converges Critical/
High here so the pipeline doesn't stall. `/pr` is therefore invoked in `reviewed`
mode (Phase 4) so it won't deep-review the identical code again.

## Phase 3.4 — Security review + fix loop

Once code review has converged (Phase 3), run a **security-focused** pass over the
same committed diff. Code review and security review are different lenses —
correctness / concurrency / architecture versus **attack surface** — and an
unattended `/deliver` (especially `auto`) opens PRs without a human reading every
line, so the security lens earns its place before the PR.

**Skip this phase entirely if the change has no security-relevant surface.** Run it
when `git diff --name-only origin/main...HEAD` touches **Swift source**,
**dependency manifests** (`Package.swift` / `Package.resolved`), **CI / workflow**
(`.github/workflows/`), or **permission / credential config** (`.claude/settings*`).
A pure docs / markdown delivery has no attack surface — sail straight to Phase 3.5.
This phase does **not** scale down on a `lite` change: if the surface is touched, it
runs (a `lite` change is a single pass anyway).

Run the review via **`/security-review`** — it reviews the pending changes on the
branch and returns findings graded **High / Medium / Low** (no "Critical" tier; it
filters out anything below confidence 8 and excludes documentation files, so a
docs-only diff returns nothing). It produces findings; it does **not** fix — the
conductor applies fixes, symmetric with Phase 3. For this library the
surfaces that actually bite: the `HTTPClient` / networking layer, `api_key` and
session / credential handling, URL and query construction, `Decodable` paths over
untrusted API data, anything that logs, and dependency / permission changes. Then
converge with the same loop as Phase 3:

1. Read the severity-graded findings.
2. **For each High finding** (and any Medium with a concrete attack path), fix it —
   **test-first via `canon-tdd` where the defect is reproducible** (input validation
   at a public boundary, a decoding guard), or by the minimal direct change where it
   is not (removing a secret-leaking log line, tightening a permission). Re-run
   `/test` (+ `/integration-test` if behaviour changed) and **commit the fix** — the
   commit is required so the re-review diffs committed history and converges (as in
   Phase 3).
3. **Re-invoke `/security-review`** on the updated (committed) diff. Repeat until no
   High findings remain.
4. **Cap at 3 iterations.** If High findings persist after three rounds,
   stop and surface them to the user — never loop forever or ship a known
   vulnerability silently.
   - **Auto:** convene the panel. **Proceed** → note the unresolved finding in the
     PR description and continue; **stop** → surface to the user. A finding that
     **leaks credentials or opens a clear exploit** is the security analogue of the
     never-delegated data-loss blocker — treat it as a **hard stop even in `auto`**.

Medium/Low findings: apply the cheap, clearly-correct ones; note the rest in the PR
description rather than blocking on them.

Phase 4's `make ci` is a **correctness** gate (lint, tests, build, docs) — there is
no SAST step in CI — so this phase is the pipeline's **only** security gate. Don't
skip it on a change that touches the surfaces above.

## Phase 3.5 — Capture learnings

Invoke **`/capture-knowledge`**, **passing the knowledge-candidates list you kept
in the ledger (Contract §7) as the skill argument** (`$ARGUMENTS`) — paste the
list lines into the invocation rather than assuming the skill can still see the
ledger in context. The ledger may have been summarised away by now; the argument
travels with the call, so the candidates reach the skill even after compaction.
Its job here is to **curate** that list — filter to the durable, non-obvious,
reusable items, dedup against existing `knowledge/` entries, and write them into
the right file (gotchas / API notes / a new ADR for
decisions). Starting from the running list is the whole point — it captures the
learnings you'd have forgotten by now.

Do this **before** `/pr` so the notes are committed in the **same PR** as the
change. Capturing nothing is a valid outcome — don't manufacture entries. The
`knowledge/` files are Markdown, so they add no review noise (the GitHub reviewer
ignores `**/*.md`); keep entries tidy by hand.

## Phase 3.6 — Rubric verification (exit gate)

Retrieve the delivery rubric (the acceptance criteria extracted in Phase 0) from
the ledger. If none were extracted — the plan lacked ACs and the auto panel chose
to proceed — **skip this phase entirely**.

For each AC, verify the committed diff satisfies it:

- **A behaviour criterion** (decoding, error handling, an API call shape) → scan
  the diff (`git diff origin/main...HEAD`) for the relevant code path, or run a
  targeted test (`swift test --filter …`) if one covers it directly.
- **A test-coverage criterion** → confirm the test file and assertion exist in
  the diff.
- **An integration criterion** → confirm the integration test exists; the live
  run already passed in Phase 2, so no re-run is needed.

**For each criterion:**

- **Satisfied** → mark it off in the ledger, no action.
- **Not satisfied** → fix it test-first (`canon-tdd`), commit, and re-verify. If
  a gap cannot be closed without a plan change, note it in the PR description with
  the reason.

This check is lightweight — reading a diff against a short list, not a full review.
Do it inline (no subagent needed). If every item passes in a quick scan, this phase
takes seconds. Only gaps trigger work.

The rubric answers a different question than CI: *"did we build what the plan
said?"* not *"did the build pass?"*

## Phase 3.7 — Write the retrospective (pre-PR)

Write the delivery's retrospective **now — before the PR opens — so it rides the
PR itself** and the ready-to-merge gate is never re-opened by a routine retro
push (every post-gate push re-triggers `claude-review` and the CI matrix; see
Phase 6). This is mandatory, not optional. Reflect on the delivery so far
(Phases 0–4) and write a dated entry to
[`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md):

- **Feature / branch**, date, and delivery weight (lite/full). The PR number
  doesn't exist yet — head the entry with the branch name; Phase 4 backfills
  the number right after the PR is created.
- **Phases completed / Skills invoked** — a compact one-liner each (e.g. phases
  `0–4`; skills `review-plan, implement-plan, review-changes, security-review,
  capture-knowledge`). This is telemetry for the recurring-pattern scan: over
  time it shows which skills fire, which phases get skipped, and where
  deliveries stop.
- **What worked** — one or two things the pipeline did well.
- **Friction** — where it was rough, slow, or stopped unnecessarily.
- **Deviations** — anywhere you had to depart from this skill to do the right
  thing (a strong signal the skill has a gap).
- **One improvement** — the single highest-value change to `/deliver` (or a
  sub-skill) suggested by this run.
- **`watch:`** — omit it now. This optional line is added only as a
  **post-gate amendment** when Phase 5 produces a noteworthy event (see
  Phase 6); an uneventful watch adds nothing.

Keep it to a handful of bullets — a log, not a ceremony. **Commit the entry on
the PR branch** so it travels with the delivery (the GitHub reviewer ignores
`**/*.md`, so it adds no review noise).

**Keep the file windowed.** After adding the entry, if `delivery-retros.md` holds
more than **~12 full entries**, distil the oldest into its one-line archive table
(`date · PR · weight · one-line outcome`) and drop the prose — per
[`knowledge/README.md`](../../../knowledge/README.md) → *Maintenance & retention*.
An old retro's lesson already lives in the skills and `skill-improvement-log.md`;
the table preserves the telemetry without the bulk.

## Phase 4 — Create the PR

**Gate check (template→replicate deliveries):** before anything else, confirm the
ledger's `Phase 3a — reference-unit review` task is **`completed`**. If it is
still open, the reference unit was never reviewed — **go back to Phase 3** and run
it before opening the PR. (Other deliveries have no Phase 3a task; this is a
no-op for them.)

Invoke **`/pr reviewed`** — the `reviewed` argument tells `/pr` to **skip its
internal `code-reviewer` pass**, because Phase 3 already reviewed and converged
this exact code; re-running the deep review on identical code is wasted work (and
its stop-to-ask gate would interrupt the autonomous run). `/pr` will then: run
`/format` (committing any formatting changes), run `make ci` (the **mandatory**
full gate — lint, markdown, unit + integration tests, release build, docs build),
then push the branch and open the PR with a gitmoji title and structured body.

**If `make ci` fails, triage before you stop** (Contract §4):

1. **Which check, and is it in your diff?** Read the failure. Compare the failing
   test/file against `git diff --name-only origin/main...HEAD`.
2. **In-diff genuine failure** → it's yours: fix it (test-first), commit, re-run
   `make ci`. Only **stop and report** if it can't converge.
   - **Auto:** when it can't converge, convene the panel. **Proceed** → open the
     PR with the known-failing check noted in its description; **stop** → report.
3. **Pre-existing / unrelated** — the failing test isn't in your diff and (for a
   live integration test) often passes in isolation / on a re-run → it's a `main`
   problem, not yours. Hand it to **`/fix-integration-failures`** (it fixes the
   flake on its own branch off `main`, runs `make ci`, and merges), then bring this
   branch up to date (`git merge main` / `mcp__github__update_pull_request_branch`)
   and re-run the gate.
   Don't patch an unrelated test onto this feature branch, and don't hard-stop on it.

Record the PR number/URL in the ledger.

**Backfill the retro heading.** Phase 3.7 headed the fresh `delivery-retros.md`
entry with the branch name (no PR number existed yet). Now that the PR is open,
replace it with the PR number, commit, and push immediately. This is
**pre-gate** — CI has only just started on the opening push, and the superseded
run is cancelled by the workflow's concurrency group — so nothing is re-opened.

## Phase 5 — Watch to ready  → GATE: ready-to-merge

Invoke **`/watch-pr`** in **watch-only** mode (do not pass `merge`), and **run it in
the background** so the user can keep interacting while CI churns. It resolves
review threads and fixes failing checks (its §1c routes a pre-existing/unrelated
integration failure to `/fix-integration-failures`, per Contract §4), looping until
the PR is **ready** (green checks, threads resolved) or **stuck**.

**Ready means mergeable *now*.** Before the gate, `/watch-pr` brings the branch up
to date with `main` (`mcp__github__update_pull_request_branch`) and waits for the
re-run, so a PR
reported ready isn't `BEHIND` and waiting on a rebase — the user can merge straight
away. (See `/watch-pr` §3.)

**THE GATE — hard stop at ready-to-merge.** When the PR is ready, **stop and hand
it to the user for the final merge** — `/deliver` does not merge by default. Report
the PR URL and its ready state, then run Phase 6. The **worktree stays in place**
at the gate (the PR branch lives there); it's torn down only on merge (Phase 7). If
`/watch-pr` reports the PR is **stuck** (a check it can't fix, or a human-decision
review thread), stop and summarise what's blocking — **keep the worktree** so the
work can be resumed.

> **Auto:** on a stuck PR, convene the panel to decide **wait-and-retry vs stop**.
> **Proceed** (majority to keep trying) → schedule a later re-check with
> `ScheduleWakeup` and resume `/watch-pr` when it fires; **stop** (majority) → end
> the run and report what's blocking. The ready-to-merge gate itself is **not** a
> panel decision: in `auto` it behaves exactly as the `merge` opt-in below — once
> the PR is ready, proceed to Phase 6 (and merge if `merge` was passed).
>
> **Opt-in auto-merge:** if the user explicitly passes `merge` to `/deliver`,
> forward it to `/watch-pr` (`/watch-pr merge`) so it squash-merges once ready, and
> the gate becomes "report the merge" instead of stopping. Default is watch-only.
> Either way, a confirmed merge triggers **Phase 7 teardown**.

## Phase 6 — Wrap-up (wiki, pattern scan, exceptional retro amendment)

The retrospective is already on the PR (Phase 3.7). After the gate (PR ready, or
merged in `merge` mode), finish with the wrap-up below — **the default path
pushes nothing after the gate**; that is the point of writing the retro pre-PR.
Then **scan recent entries** for recurring friction or deviations — the
recurring-pattern scan below formalizes this.

**Amend the retro only for a noteworthy watch phase.** If Phase 5 was uneventful
(checks went green, threads resolved without surprises), the retro is complete —
do not touch it. If the watch phase produced something the next
recurring-pattern scan should see — a stuck check, a new Critical/High review
thread, a flake routed to `/fix-integration-failures`, a wrong readiness call —
append a one-line **`watch:`** bullet to the entry, commit, and push. Two cases:

- **Watch-only (PR still open)** — commit the amendment on the PR branch and
  push it, so it rides the open PR.
- **`merge`/auto mode (branch already merged + deleted in Phase 5)** — the PR
  branch is gone, so commit it on a **fresh branch off `origin/main`** and open
  a small follow-up PR; the same applies to any skill edits the auto
  recurring-pattern scan commits. Do this **before** Phase 7 teardown, and
  confirm it's pushed — otherwise teardown's `discard_changes` drops it.

**Any post-gate push re-opens the gate — re-watch before merge.** This governs
the *exceptions* above (a retro amendment, an approved skill edit from the
scan): every push re-triggers `claude-review` and the CI matrix, which can post
a **new blocking thread** (the `main` ruleset requires thread resolution) or
restart checks. After the **last** post-gate push, **return to the `/watch-pr`
loop once more**: re-sweep unresolved threads and re-confirm checks green before
treating the PR as merge-ready or merging. "Ready" is only ever true of the
*current* branch tip — never a tip you have since pushed past. (Bit `/deliver`
on #361, back when the retro itself was a routine post-gate push — the
sequencing Phase 3.7 now avoids.)

### Update the personal wiki (at wrap-up)

The retro (Phase 3.7) distils this delivery's durable learnings, so wrap-up is
the natural moment to feed the **personal `wiki`** (Adam's cross-project engineering knowledge, via
the `wiki` MCP). The retro/`knowledge/` base is *project-specific*; the wiki is
for **generalizable, reusable opinions, heuristics, and patterns** — the things
that would apply on the next project too (a design stance, a concurrency or
testing heuristic, a tooling gotcha that isn't TMDb-specific).

- **Degrade silently if the `wiki` MCP is absent** (a contributor's machine, a
  headless/cron run) — never block on it.
- **Search first** (`search_wiki`/`search_entries`) and prefer **updating** a
  near-match over creating a duplicate.
- **Propose, don't autonomously save.** The wiki tooling reserves `add_entry`/
  `update_entry` for Adam's explicit approval — use **`propose_entry`** to render
  each candidate for review, and only `add_entry`/`update_entry` once Adam
  approves. Cite the wiki when an answer later draws on it.
- **Be selective** — one or two high-signal entries beat a dump; skip anything
  that's only project-specific (that already lives in `knowledge/`) or already in
  the wiki. Capturing nothing is a valid outcome.

### Recurring-pattern scan (at wrap-up)

With the retro already on the PR (Phase 3.7), do a structured cross-delivery
scan — this is what turns one-off retros into reviewed skill improvements:

1. **Read the recent window + the log.** Read the **~last 12** entries of
   [`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md) (the
   rolling window — older deliveries are archived to one-liners, so this is the
   whole live history anyway), **all** of
   [`knowledge/skill-improvement-log.md`](../../../knowledge/skill-improvement-log.md),
   and **every** `SKILL.md` under `.claude/skills/` (including the sub-skills those
   skills reference). The bounded retro read keeps the scan's cost flat as history
   grows: a recurrence worth acting on shows up in the recent window, and anything
   already settled lives in the log.
2. **Find what recurs.** For any friction, deviation, or improvement suggestion
   that appears in **more than one** retro entry, write a numbered proposal in
   this exact format:

   Pattern: [what keeps happening]
   Seen in: [retro dates / feature names]
   Skill: [relative path to SKILL.md]
   Current text: [exact existing wording, or "missing"]
   Proposed change: [exact new wording and location]
   Rationale: [one sentence on why this eliminates the pattern]

   **Skip any pattern already decided in `skill-improvement-log.md`** — one
   already **applied** (the fix is in the skill), or **deferred/rejected** (don't
   re-propose a settled *no*; only resurface it if its recorded "reconsider when…"
   condition now holds).
3. **Stop and ask.** **Do not edit any skill files.** Present the proposals and
   wait for **explicit approval on each one** before changing anything. If no
   *new* pattern recurs across multiple entries, **say so and stop** — emit no
   proposals.
   - **Auto:** don't wait for the user. The panel reviews **each** proposal and
     **applies approved ones directly** (edit the skill, commit). Rejected
     proposals are still recorded in `skill-improvement-log.md` with the panel's
     rationale (step 4).
4. **Record every decision in the log.** For each proposal you presented, append
   an entry to
   [`knowledge/skill-improvement-log.md`](../../../knowledge/skill-improvement-log.md)
   **in the five-field format documented at the top of that file** (date · title ·
   status; Pattern / Decision / Rationale / Reconsider when) — **applied** (with
   the skill + commit it landed in), **deferred**, or **rejected**. The **Decision**
   (status) and **Reconsider when** fields are exactly what step 2's dedup keys on,
   so keep them on every entry; this is what stops the scan re-proposing a settled
   call next time.

## Phase 7 — Teardown on merge (reclaim the worktree)

A delivery's worktree carries a full `.build` (here **~3 GB** after the CI gate, on
top of the source). Leaving one per delivery accumulates fast, so **tear the
worktree down once the PR is merged** — this reclaims both the worktree **and** its
`.build` in one step.

**The trigger is the merge, and only the merge:**

- **`merge` mode** — `/watch-pr merge` squash-merged the PR. Tear down immediately
  after.
- **Watch-only (default)** — the worktree **stays** at the gate (Phase 5). When the
  merge happens *within this session* (the user says "merge" and you do it, or a
  later turn confirms the PR is `MERGED`), tear down **then**. If the session ends
  with the PR still open, **leave the worktree** — the work must survive until it's
  merged. Interactive sessions get a harness keep/remove prompt at exit; **headless /
  `auto` runs have no one to answer it**, so a merged-later worktree is reclaimed not
  here but by the **Phase 0.5 GC sweep at the start of the *next* delivery** (it
  removes any worktree whose PR has since merged). That sweep is the backstop that
  keeps unattended runs from leaking disk.
- **Stuck / blocked / abandoned** — **never** tear down. Keep the worktree so the
  work can be resumed.

**How to tear down** — two preconditions, both required:

1. **The PR is actually merged** — `mcp__github__pull_request_read` method `get`
   (owner/repo from the `origin` remote, `pullNumber: <n>`) → `merged: true`.
2. **The worktree has no unsaved work beyond what's merged** — `MERGED` only
   guarantees the *pushed* feature commits are on `main`; it says nothing about a
   commit made (or a file edited) **after** the last push, e.g. an exceptional
   retro amendment (Phase 6). Verify
   the tree is clean **and** fully pushed before discarding:

   ```bash
   git status --porcelain                                  # must be empty (no uncommitted work)
   test "$(git rev-parse HEAD)" = "$(git rev-parse @{u})"  # HEAD must equal its pushed upstream
   ```

   If either check fails, there is worktree-only work not yet on `main` — **stop**,
   land it (push it / move it to a follow-up off `origin/main`, per Phase 6), and
   only then tear down. Do **not** discard it.

Then:

```text
ExitWorktree(action: "remove", discard_changes: true)
```

- `remove` deletes the worktree directory (which **is** its `.build` — the multi-GB
  reclaim) and the local branch, then returns the session to the main checkout.
- `discard_changes: true` is needed only because a **squash**-merge lands the work
  as a *new* commit on `main`, so the branch's pushed-and-merged commits aren't
  *literally* on `main` and `ExitWorktree` would otherwise refuse. It is safe
  **only because** precondition 2 proved there's nothing un-merged left to lose —
  not merely because the PR is `MERGED`. Never pass it on an unverified tree.

After teardown, the session is back in the main checkout — **leave it as you found
it**. Do *not* auto-`merge --ff-only` it: the user may be actively working there
(the whole point of the worktree) with uncommitted or diverged state, and the FF
would fail noisily or fight their work. Only if it is **clean and on `main`**
(`git status --porcelain` empty) may you fast-forward it (`git fetch origin &&
git merge --ff-only origin/main`); otherwise just note "main checkout left as-is
(N commits behind)". Report the reclaimed worktree in the final summary.

## When the pipeline stops

Whether at the gate, a red gate it couldn't triage, or a stuck PR, always end with
a concise status: the phase reached, the branch and PR (if any), what passed,
what's blocking, and the single next action you need from the user. The destination
is a green PR ready for their merge — say plainly whether you got there.
