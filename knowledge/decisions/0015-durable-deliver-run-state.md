# ADR-0015: Durable `/deliver` run state in `.git/deliver/`

- **Status:** Accepted (unreleased — tooling only, no library impact)
- **Date:** 2026-07-29
- **Deciders:** Adam Young

## Context

`/deliver` kept its state in a `TaskCreate` ledger that the skill itself
documents as **not durable**: it is "CWD-scoped and cleared by `EnterWorktree`,
an MCP reconnect, or a plan-mode exit". So a run that died mid-pipeline lost the
acceptance criteria, the multi-deliverable decomposition, and every phase's
status. Re-invoking `/deliver` cut a fresh worktree off `origin/main` and
stranded the old one — and because the Phase 1 sweep keyed only on **merged
PRs**, a worktree interrupted before Phase 9 had no PR, was invisible to the
sweep, and leaked permanently.

A *Claude Code Insights* report over 71 sessions found four of eleven analysed
sessions ended "partially achieved" because the work outran the transcript, so
this is the failure mode that costs the most in practice.

A first design was blocked in review for **data loss** (it removed worktrees
with `--force` and no clean-tree proof, where Phase 12 demands two proofs) and
because its gate was **circular** — a ledger task meant to block `EnterWorktree`,
in a ledger `EnterWorktree` destroys.

## Decision

**The file records intent; git records progress; the file is never authoritative
for anything git can settle.**

1. **Location: `<main checkout>/.git/deliver/<id>.json`**, resolved with
   `git rev-parse --path-format=absolute --git-common-dir`. It **cannot enter a
   diff by construction** (`.git` is not a working-tree path, so it can never
   appear in `git status`/`git diff`/`git add -A`) — a structural guarantee, not
   a convention like a `.gitignore` entry. It is **shared by every worktree** via
   the *common* dir, so batch state is reachable from any of them, and it
   **survives `ExitWorktree(remove)`**, so tearing down deliverable 1 does not
   destroy the state of 2..N.

2. **The gate is a data dependency, not a checklist item.** Phase 0 writes the
   file (goal, weight, rubric, decomposition) *before* Phase 1; Phase 1 records
   the sweep into it; **Phase 6 reads the rubric from it**. Skipping a step
   therefore deletes an input a later *mandatory* phase requires, so it fails
   loudly. A **missing file, or one lacking its `reconciled` block, is a hard
   stop** at Phase 6 — the same shape as "a dead grader is not a pass".
   `rubric: none` is *present-and-empty* and distinct from a missing file.

3. **Liveness is a fact, not a timeout.** `EnterWorktree` writes
   `.git/worktrees/<name>/locked` containing `… (pid <PID> …)`. The classifier
   tests the **PID**. A time-based heuristic was rejected: normal Phase 3 and
   Phase 9 silences exceed any plausible threshold, so it would eventually adopt
   a *running* delivery and put two conductors and two Swift builds in one
   scratch directory — the most expensive incident this repo has recorded.

4. **Stamps hash reviewable content, not commits.** `/pr` rebases onto
   `origin/main`, rewriting every SHA, so a commit-sha stamp is void after every
   rebase by construction; and Phases 7-9 commit to `knowledge/`, which should
   not invalidate a code review. The stamp is
   `git ls-tree -r HEAD | grep -v $'\tknowledge/' | git hash-object --stdin`,
   honoured only alongside a clean tree.

5. **Buckets are total and ordered, and the sweep's powers do not grow.**
   First-match-wins over `live` / `report` / `reclaim` / `resumable` /
   `settled` / `report`, scoped to `<main-root>/.claude/worktrees/` only.
   Reclaiming keeps Phase 12's two existing proofs; everything else is
   **reported, never removed**.

## Consequences

- An interrupted delivery is **resumable**, and one that died before Phase 9 is
  at least **visible** rather than leaking silently.
- A **batch is the N=1 case generalised** (more entries in `deliverables[]`) —
  no second mechanism, and it is the only state that survives Phase 10's
  background-watch handoff.
- The sweep is **strictly less destructive** than before: it gained enumeration
  that works and lost the ability to remove anything without Phase 12's proofs.
- **Cost:** state outside the working tree is invisible to the user and lost on
  a re-clone. Accepted — it holds only in-flight pipeline state, and the
  alternative (`.build/deliver/`) is per-worktree, so batch state breaks, and is
  destroyed by `make clean`.
- Teardown must branch on `entry: created | adopted`, because `ExitWorktree`
  refuses to remove a worktree entered by `path` and would otherwise no-op while
  reporting a reclaim.

## Alternatives rejected

- **Pure evidence-derivation (no file).** Nothing can lie, but the acceptance
  criteria, the decomposition graph, and the fact that Phases 4/5/6 ran leave
  **no git trace**. A resumed run would silently lose its exit gate.
- **A state file as the source of truth.** `phase: 6 complete` is a claim, not a
  signal; a mid-phase crash leaves it confidently wrong.
- **`.build/deliver/`.** More discoverable, already gitignored — but
  per-worktree (breaks batch state) and destroyed by `make clean`.
