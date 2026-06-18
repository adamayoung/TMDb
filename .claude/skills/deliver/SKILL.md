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
you approve the plan ─▶ /deliver ─▶ branch ─▶ [review-plan] ─▶ implement ─▶
  code-review + fix ─▶ capture ─▶ /pr reviewed ─▶ /watch-pr ─▶ GATE: ready-to-merge ─▶ retro
                                                                   ▲ the only hard stop
```

**Invoking `/deliver` on an approved plan is itself the plan-approval gate.** From
there it runs **autonomously** to a single hard stop — **ready-to-merge** — pausing
mid-run only for a genuine blocker (a plan-review blocker, or a red gate it cannot
triage). It **auto-scales** the machinery to the change's risk (see *Delivery
weight*), and ends with a short **retrospective** so the workflow keeps improving.

The plan itself is **not** part of this skill — create it first with `/plan` (or
plan mode). `/deliver` picks up from there.

## Agent Behaviour Contract

These are non-negotiable. Do them by default, without being reminded.

1. **Invoking `/deliver` is plan approval — then run autonomously to the one
   gate.** Do not stop for a second "is the plan ok?" confirmation. Proceed through
   branch → (review-plan) → implement → code-review/fix → capture → pr → watch-pr
   to the single hard stop, **Gate: ready-to-merge** (Phase 5). The only legitimate
   mid-run pauses are: a **blocker** raised by `/review-plan` (Phase 1), or a **red
   gate you cannot triage** (Contract §4).
2. **Delegate to the existing skills — don't reinvent them.** Invoke
   `/review-plan`, `/implement-plan`, `/review-changes`, `/capture-knowledge`,
   `/pr`, `/watch-pr`, and `/fix-integration-failures` (`/review-changes` is what
   spawns the `code-reviewer` agent or the review Workflow). This skill only
   sequences and gates; the expertise lives in those pieces.
3. **Never work on `main`.** Branch first — before `/review-plan` or any file edit
   (see *Phase 0.5*). `CLAUDE.md` forbids editing `main`.
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
   compaction better than prose working-notes, so you can resume cleanly.
7. **Jot knowledge candidates as you go.** Keep a running **knowledge-candidates**
   list (in the ledger) and append to it the *moment* a learning occurs during
   Phases 2–3 — a thing you had to look up or web-search, a gotcha or dead-end, a
   surprising live-API behaviour, or a non-obvious decision. One line each
   (`<category>: <gist> [where]`). Phase 3.5 curates this list; reconstructing it
   at the end loses the best material (and may not survive compaction).

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

## Phase 0 — Preconditions

- **A plan must exist.** Locate it the way `/review-plan` does (named target →
  plan-mode plan → most recent plan in the conversation). If there is no plan,
  stop and tell the user to run `/plan` first — do not invent one.
- **State the goal** in a sentence so every downstream phase is anchored to it.
- **Judge the delivery weight** (lite vs full) from the plan, and open the
  `TaskCreate` ledger (Contract §6).

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
keep it.

**Invoked from plan mode?** If you reach `/deliver` while in plan mode with an
approved plan, that approval *is* Gate-1: exit plan mode (the plan file is your
input), branch, and proceed — there's no separate `ExitPlanMode`-then-approve
dance, and no second "is the plan ok?" prompt.

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
**and** `/integration-test` passing, and the work committed. Re-confirm the
delivery weight from the actual diff now (a "lite" plan that ballooned is `full`).

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

**Granularity by delivery weight:**

- **Lite / single-unit** (one method, one model) → review **once**, on the full
  diff after Phase 2. `/review-changes` takes its single-`code-reviewer` path.
- **Full / multi-unit** (several new models/methods, or risky concurrency/
  networking) → review **per cohesive unit** as each completes (a finished model;
  a service method + its tests), rather than one large end-diff. Smaller diffs
  review more accurately, and a wrong foundational pattern is caught before later
  units build on it. Do not drop to per-test-list-item — per *unit*, not per
  *item*. Here Phases 2 and 3 **interleave**: review a unit as Phase 2 finishes it
  (and fix per the loop below) before moving on.

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

Invoke **`/capture-knowledge`**, **passing the knowledge-candidates list you kept
in the ledger (Contract §7) as the skill argument** (`$ARGUMENTS`) — paste the
list lines into the invocation rather than assuming the skill can still see the
ledger in context. The ledger may have been summarised away by now; the argument
travels with the call, so the candidates reach the skill even after compaction.
Its job here is to **curate** that list — filter
to the durable, non-obvious, reusable items, dedup against existing `knowledge/`
entries, and write them into the right file (gotchas / API notes / a new ADR for
decisions). Starting from the running list is the whole point — it captures the
learnings you'd have forgotten by now.

Do this **before** `/pr` so the notes are committed in the **same PR** as the
change. Capturing nothing is a valid outcome — don't manufacture entries. The
`knowledge/` files are Markdown, so they add no review noise (the GitHub reviewer
ignores `**/*.md`); keep entries tidy by hand.

## Phase 4 — Create the PR

Invoke **`/pr reviewed`** — the `reviewed` argument tells `/pr` to **skip its
internal `code-reviewer` pass**, because Phase 3 already reviewed and converged
this exact code; re-running the deep review on identical code is wasted work (and
its stop-to-ask gate would interrupt the autonomous run). `/pr` will then: run
`/format` (committing any formatting changes), run `make ci` (the **mandatory**
full gate — lint, markdown, unit + integration tests, release build, docs build),
then push the branch and open the PR with a gitmoji title and structured body.

**If `make ci` fails, triage before you stop** (Contract §4):

1. **Which check, and is it in your diff?** Read the failure. Compare the failing
   test/file against `git diff --name-only main...HEAD`.
2. **In-diff genuine failure** → it's yours: fix it (test-first), commit, re-run
   `make ci`. Only **stop and report** if it can't converge.
3. **Pre-existing / unrelated** — the failing test isn't in your diff and (for a
   live integration test) often passes in isolation / on a re-run → it's a `main`
   problem, not yours. Hand it to **`/fix-integration-failures`** (it fixes the
   flake on its own branch off `main`, runs `make ci`, and merges), then bring this
   branch up to date (`git merge main` / `gh pr update-branch`) and re-run the gate.
   Don't patch an unrelated test onto this feature branch, and don't hard-stop on it.

Record the PR number/URL in the ledger.

## Phase 5 — Watch to ready  → GATE: ready-to-merge

Invoke **`/watch-pr`** in **watch-only** mode (do not pass `merge`). It resolves
review threads and fixes failing checks (its §1c routes a pre-existing/unrelated
integration failure to `/fix-integration-failures`, per Contract §4), looping until
the PR is **ready** (green checks, threads resolved) or **stuck**.

**THE GATE — hard stop at ready-to-merge.** When the PR is ready, **stop and hand
it to the user for the final merge** — `/deliver` does not merge by default. Report
the PR URL and its ready state, then run Phase 6. If `/watch-pr` reports the PR is
**stuck** (a check it can't fix, or a human-decision review thread), stop and
summarise what's blocking.

> **Opt-in auto-merge:** if the user explicitly passes `merge` to `/deliver`,
> forward it to `/watch-pr` (`/watch-pr merge`) so it squash-merges once ready, and
> the gate becomes "report the merge" instead of stopping. Default is watch-only.

## Phase 6 — Retrospective (continuous improvement)

After the gate (PR ready, or merged in `merge` mode), run a **brief, honest
retrospective** so the workflow keeps improving — this is mandatory, not optional.
Reflect on *this* delivery and write a dated entry to
[`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md):

- **Feature / PR**, date, and delivery weight (lite/full).
- **What worked** — one or two things the pipeline did well.
- **Friction** — where it was rough, slow, or stopped unnecessarily.
- **Deviations** — anywhere you had to depart from this skill to do the right
  thing (a strong signal the skill has a gap).
- **One improvement** — the single highest-value change to `/deliver` (or a
  sub-skill) suggested by this run.

Keep it to a handful of bullets — a log, not a ceremony. Then **scan recent
entries** for recurring friction or deviations — the recurring-pattern scan below
formalizes this. Commit the retro with the PR when possible (watch-only), or as a
small follow-up when auto-merged.

### Recurring-pattern scan (after committing the retro)

Once the retro entry is committed, do a structured cross-delivery scan — this is
what turns one-off retros into reviewed skill improvements:

1. **Read the whole history.** Read all of
   [`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md) and
   **every** `SKILL.md` under `.claude/skills/` (including the sub-skills those
   skills reference).
2. **Find what recurs.** For any friction, deviation, or improvement suggestion
   that appears in **more than one** retro entry, write a numbered proposal in
   this exact format:

   Pattern: [what keeps happening]
   Seen in: [retro dates / feature names]
   Skill: [relative path to SKILL.md]
   Current text: [exact existing wording, or "missing"]
   Proposed change: [exact new wording and location]
   Rationale: [one sentence on why this eliminates the pattern]

3. **Stop and ask.** **Do not edit any skill files.** Present the proposals and
   wait for **explicit approval on each one** before changing anything. If no
   pattern recurs across multiple entries, **say so and stop** — emit no
   proposals.

## When the pipeline stops

Whether at the gate, a red gate it couldn't triage, or a stuck PR, always end with
a concise status: the phase reached, the branch and PR (if any), what passed,
what's blocking, and the single next action you need from the user. The destination
is a green PR ready for their merge — say plainly whether you got there.
