---
name: deliver
description: Take the current plan all the way to a ready-to-merge pull request — review the plan, implement it test-first, code-review and fix, run the CI gate, open the PR, and watch it green. Use after you have a plan (e.g. from /plan) and want the rest of the feature pipeline run end-to-end. Stops for approval only at two gates: the revised plan, and ready-to-merge.
---

# Deliver

Drive the **current plan** through the whole feature pipeline to a PR that is
green and ready to merge — without you hand-running each step. This skill is an
**orchestrator**: it does not re-implement review, TDD, or PR logic; it sequences
the existing skills and the `code-reviewer` agent, adds the safety gates, and
keeps going across the long session until the PR is ready.

```text
/plan → /review-plan → /implement-plan → code-review + fix → capture → /pr reviewed → /watch-pr
 (you)       │                │                  │              │            │            │
         GATE 1 ▲          TDD loop        the single review  record     make ci +     GATE 2 ▲
       approve revised     to empty        (once, or per unit) learnings  open PR       stop at
           plan           test list        fix Critical/High  to knowledge/ (no review) ready-to-merge
```

The plan itself is **not** part of this skill — create it first with `/plan` (or
plan mode). `/deliver` picks up from there.

## Agent Behaviour Contract

These are non-negotiable. Do them by default, without being reminded.

1. **Run the phases in order; never skip the gate.** Branch → review-plan →
   implement → code-review/fix → capture → pr → watch-pr. Stop and wait for
   explicit user approval at **Gate 1** (revised plan) and **Gate 2**
   (ready-to-merge). Between gates, proceed autonomously.
2. **Delegate to the existing skills — don't reinvent them.** Invoke
   `/review-plan`, `/implement-plan`, `/review-changes`, `/capture-knowledge`,
   `/pr`, and `/watch-pr` (`/review-changes` is what spawns the `code-reviewer`
   agent or the review Workflow). This skill only sequences and gates; the
   expertise lives in those pieces.
3. **Never work on `main`.** Branch first — before `/review-plan` or any file edit
   (see *Phase 0.5*). `CLAUDE.md` forbids editing `main`.
4. **A red gate stops the pipeline.** If tests can't go green, `make ci` fails, or
   the code-review/fix loop can't converge within its cap, **stop and report** —
   do not push forward to a PR on a broken state.
5. **Test-first all the way.** Every fix in the code-review loop follows
   `canon-tdd` — reproduce with a failing test, then fix. No untested patches.
6. **Keep a phase ledger.** This is a long session that may be summarised; record
   which phase you're in, the branch name, the PR number, and per-phase outcomes
   in your working notes so you can resume cleanly after compaction.
7. **Jot knowledge candidates as you go.** Keep a running **knowledge-candidates**
   list in the ledger and append to it the *moment* a learning occurs during
   Phases 2–3 — a thing you had to look up or web-search, a gotcha or dead-end, a
   surprising live-API behaviour, or a non-obvious decision. One line each
   (`<category>: <gist> [where]`). Phase 3.5 curates this list; reconstructing it
   at the end loses the best material (and may not survive compaction).

## Context & isolation (by design)

`/deliver` is a **lean main-context conductor** — it should hold only the plan
reference, the phase ledger, the two gate interactions, and a short summary
returned from each phase. The heavy or independent-judgment work is deliberately
isolated so it never bloats or biases the main window:

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
- **Gates must stay in the main agent.** Subagents are non-interactive; the Gate 1
  and Gate 2 approvals require the user, so the conductor — not a subagent — owns
  them. Phases hand off via **git / disk / the PR**, not via context.

## Phase 0 — Preconditions

- **A plan must exist.** Locate it the way `/review-plan` does (named target →
  plan-mode plan → most recent plan in the conversation). If there is no plan,
  stop and tell the user to run `/plan` first — do not invent one.
- **State the goal** in a sentence so every downstream phase is anchored to it.

## Phase 0.5 — Ensure a feature branch (before any edit)

Do this **before** Phase 1 — `/review-plan` applies its consensus by editing the
plan, and if the plan is a **tracked file** that edit must not land on `main`
(`CLAUDE.md` forbids editing `main`; Contract §3). Branch first, then nothing
downstream can touch `main`.

```bash
git branch --show-current
```

If on `main` (or any protected base), create a branch off `main` with a
conventional prefix derived from the plan — `feature/<slug>` for new work,
`fix/<slug>` for a bug fix, etc.:

```bash
git checkout -b feature/<slug>
```

Record the branch name in the ledger. If already on a suitable feature branch,
keep it. (Creating the branch before Gate 1 is cheap; an abandoned branch if you
reject the plan is a negligible cost next to editing `main`.)

## Phase 1 — Review the plan  → GATE 1

Invoke **`/review-plan`**. It runs the three adversarial Opus critics, reconciles
a consensus, and applies the agreed feedback to the plan.

**GATE 1 — hard stop.** Present the **revised** plan plus the change log
(applied / rejected / open questions) and **wait for explicit user approval**
before implementing. The point of this gate: never spend implementation time on a
plan the reviewers just rewrote, until you've confirmed the rewrite. If the user
wants changes, fold them in and re-confirm. Do not proceed on silence.

## Phase 2 — Implement the plan

Invoke **`/implement-plan`**. It derives the Canon TDD test list (shown before any
code), drives the Red-Green-Refactor loop one test at a time, and finishes only
when the **test list is empty** and the suites are green. It will pull in
`swift-testing-expert` and `swift-concurrency` as the work demands, and expects
the lint/format PostToolUse hook to reshape files after writes.

It also **commits at logical checkpoints** as it goes — each commit a coherent,
green, lint-clean increment (`/implement-plan`'s *Commit at logical points*). This
matters for the pipeline: Phase 3 reviews **committed** history (`git diff
main...HEAD`), so committing as you implement means the review sees the real
change rather than an empty diff.

Do not advance until `/implement-plan` reports an empty test list with `/test`
**and** `/integration-test` passing, and the work committed.

## Phase 3 — Code review + fix loop

**Skip this phase entirely if the change has no Swift source.** `/review-changes`
self-gates (it returns immediately when `git diff main...HEAD` touches no
`*.swift`), so a docs-only / config-only delivery sails straight to Phase 3.5
with no review. Code review is for Swift.

Review **stable** code, not work in progress. Code review is an independent,
adversarial lens — apply it once the design has settled, not after every Canon TDD
item (the test list is deliberately emergent; early items are reshaped by later
ones, so per-item review just flags churn). The per-item quality gate already
lives in Phase 2 — the passing test, the inline docs, the lint hook, and
refactor-on-green.

**Granularity by plan size:**

- **Small / single-unit plan** (one method, one model) → review **once**, on the
  full diff after Phase 2 finishes. This is the default.
- **Large / multi-unit plan** (several new models or service methods) → review
  **per cohesive unit** as each completes (a finished model; a service method +
  its tests), rather than one large end-diff. Smaller diffs review more
  accurately, and a wrong foundational pattern is caught before later units build
  on it. Do not drop to per-test-list-item — per *unit*, not per *item*.

  In this case Phases 2 and 3 **interleave**: review a unit as Phase 2 finishes
  it (and fix per the loop below) before moving to the next unit — the phase
  numbers describe order of concern, not a rigid barrier after all implementation.

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
   (`main...HEAD`), so an uncommitted fix would re-review as still-broken and never
   converge.
3. **Re-invoke `/review-changes`** on the updated (committed) diff. Repeat until no
   Critical/High findings remain.
4. **Cap at 3 iterations.** If Critical/High issues persist after three rounds,
   stop and surface them to the user — don't loop forever or paper over them.

Medium/Low findings: apply the cheap, clearly-correct ones; note the rest in the
PR description rather than blocking on them.

This is the **single substantive review** of the change — it converges Critical/
High here so the pipeline doesn't stall. `/pr` is therefore invoked in `reviewed`
mode (Phase 4) so it won't deep-review the identical code again.

## Phase 3.5 — Capture learnings

Invoke **`/capture-knowledge`**, handing it the **knowledge-candidates list** you
kept in the ledger (Contract §7). Its job here is to **curate** that list — filter
to the durable, non-obvious, reusable items, dedup against existing `knowledge/`
entries, and write them into the right file (gotchas / API notes / a new ADR for
decisions). Starting from the running list is the whole point — it captures the
learnings you'd have forgotten by now.

Do this **before** `/pr` so the notes are committed in the **same PR** as the
change. Capturing nothing is a valid outcome — don't manufacture entries. The
`knowledge/` files are Markdown, so they add no review noise (the GitHub reviewer
ignores `**/*.md`); note they are **not** in the `make lint-markdown` scope, so
keep entries tidy by hand — there's no gate to lean on.

## Phase 4 — Create the PR

Invoke **`/pr reviewed`** — the `reviewed` argument tells `/pr` to **skip its
internal `code-reviewer` pass**, because Phase 3 already reviewed and converged
this exact code; re-running the deep review on identical code is wasted work (and
its stop-to-ask gate would interrupt the autonomous run). `/pr` will then: run
`/format` (committing any formatting changes), run `make ci` (the **mandatory**
full gate — lint, markdown, unit + integration tests, release build, docs build),
then push the branch and open the PR with a gitmoji title and structured body.

- If `make ci` fails, `/pr` stops — treat that as a red gate (Contract §4): fix
  and re-run, do not force the PR. (`make ci` is the real safety net here — a
  green CI, not a second review.)

Record the PR number/URL in the ledger.

## Phase 5 — Watch to ready  → GATE 2

Invoke **`/watch-pr`** in **watch-only** mode (do not pass `merge`). It resolves
review threads and fixes failing checks, looping until the PR is **ready** (green
checks, threads resolved) or **stuck**.

**GATE 2 — hard stop at ready-to-merge.** When the PR is ready, **stop and hand
it to the user for the final merge** — `/deliver` does not merge. Report the PR
URL and its ready state. If `/watch-pr` reports the PR is stuck (e.g. a check it
can't fix, or a human-decision review thread), stop and summarise what's blocking.

> **Opt-in auto-merge:** if the user explicitly passes `merge` to `/deliver`,
> forward it to `/watch-pr` (`/watch-pr merge`) so it squash-merges once ready,
> and Gate 2 becomes "report the merge" instead of stopping. Default is
> watch-only.

## When the pipeline stops

Whether at a gate, a red gate, or a stuck PR, always end with a concise status:
the phase reached, the branch and PR (if any), what passed, what's blocking, and
the single next action you need from the user. The destination is a green PR
ready for their merge — say plainly whether you got there.
