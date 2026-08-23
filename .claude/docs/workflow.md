# Development Workflow

> Topic doc referenced from [`CLAUDE.md`](../../CLAUDE.md). Read before
> running a delivery, filing issues, reviewing, or opening a PR. The hard
> gates themselves (branching, the pre-PR `make ci` gate) are stated in
> `CLAUDE.md` — this doc carries the pipeline and its machinery.

## The Delivery Pipeline

Feature work is **skill-driven**. Draft and approve a plan in **plan mode**
(there is no `/plan` skill — use plan mode, or the `Plan` agent), then run
`/deliver` to carry it through to a ready-to-merge PR. **Invoking `/deliver` is
itself the plan-approval gate** — it then runs autonomously to a single hard stop,
**ready-to-merge**, pausing only for a plan-review blocker or a red gate it can't
triage. **A selection run needs no plan**: `/deliver next` takes the top
startable issue off the project board's Ready column, and
**`/deliver issue <n>`** takes the issue you name (which may sit in Backlog).
Either way it re-verifies, claims and drafts one —
adding a single approval stop for the plan it wrote (none in `auto`, where a
juror panel rules instead). It **auto-scales** its review machinery to the change's risk (lite vs
full), **triages** an unrelated red CI gate to `/fix-integration-failures` rather
than stalling, and records each delivery's short retrospective into
[`knowledge/delivery-retros.md`](../../knowledge/delivery-retros.md) **before the PR
opens**, so it rides the delivery's own PR:

branch → (`/review-plan` for risky/large changes) → `/implement-plan` →
`/review-changes` (+ fix) → `/security-review` (+ fix) → rubric check →
`/capture-knowledge` → retro → `/pr reviewed` → `/watch-pr`.

> `/deliver` runs the whole delivery in its own **git worktree** (under
> `.claude/worktrees/`, branched off `origin/main`) so the main checkout stays
> free for concurrent work, and tears the worktree down on merge. The
> branch-off-`main` rule in `CLAUDE.md` is the floor; the worktree is how
> `/deliver` meets it. See `.claude/skills/deliver/SKILL.md` (its
> worktree-entry and teardown phases).

## Key Skills

The README's *Claude Code Skills* tables list them all:

- **`/deliver`** — run the whole pipeline from an approved plan; `/deliver next`
  picks its own work off the board's Ready column first, and
  `/deliver issue <n>` delivers the issue you name.
- **`/review-plan`** — adversarial 3-critic review of a plan; apply the consensus.
- **`/implement-plan`** — implement test-first (`canon-tdd`) to an empty test
  list, committing at logical checkpoints.
- **`/review-changes`** — code review of the working-tree change (scales: one
  reviewer, or a fan-out + adversarial verification for large diffs).
- **`/capture-knowledge`** — record durable learnings into `knowledge/`.
- **`/triage-issues`** — groom the project board's Backlog against current
  `main`; owns the Ready test and the priority/size rubrics.
- **`/cut-release`** — work out the next SemVer version, do the pre-tag
  housekeeping, draft the notes, tag and publish. **Never headless**: it stops
  for approval before anything is tagged or published.
- **`/pr`**, **`/watch-pr`**, **`/review-pr-threads`**, **`/fix-pr-checks`** —
  open and shepherd the pull request.
- **`/document-swift`** — the canonical DocC conventions for public API.
- **`/fix-integration-failures`** — diagnose **and** fix a failing scheduled (or
  standalone) `Integration` run: re-run a transient, or fix real drift on a branch
  off `main` and open a PR. `/watch-pr` delegates the *pre-existing/unrelated*
  integration failure (one not in the PR's diff) here, since it's a `main` problem.

## Self-Healing Integration

The weekly scheduled `Integration` run (Sunday 00:00 UTC) is watched by
[`.github/workflows/integration-failure.yml`](../../.github/workflows/integration-failure.yml),
which runs `/fix-integration-failures` headless on a failure: it diagnoses, fixes
real drift on a branch off `main`, and opens a **PR for review** (never
auto-merges), then files/updates a tracking issue. Running headless, the skill
verifies with the targeted suite (not full `make ci`) and opens the PR via
`git`/`gh` (not `/pr`) — the PR's own CI is the gate.

## Issue Tracking

Work discovered but not done gets **filed**, never left in a
transcript. One shared spec, [`.github/ISSUE_FILING.md`](../../.github/ISSUE_FILING.md),
owns when to file, the body template, and the rule that every new issue lands in
the `TMDb` project board's **Backlog** column; `/review-changes`,
`/deliver`, `/capture-knowledge`, `/review-knowledge` and `/review-pr-threads`
point at it rather than restating it. `/triage-issues` then grooms Backlog into a
worked queue, and owns the Ready test and the priority/size rubrics in turn. The
split matters: filing and triage are separate judgements, so neither file states
the other's rules.

That spec also carries the **board's column lifecycle** — the one place the
column names and the `update_project_item` idiom are written down. An issue moves
Backlog → Ready (`/triage-issues`) → **In progress** (`/deliver`, on entering the
worktree — or at the pick, on a selection run) → **In review** (`/watch-pr`, when
the PR is green and waiting on you)
→ Done (the board's own "item closed" automation, via the `Closes #NNN` line
`/pr` puts in every PR body). `/deliver issue <n>` may also claim straight from
**Backlog**, since naming the issue is the triage judgement the Ready test
stands in for. Three **reverse** moves belong to `/deliver` —
Ready → Backlog when a `next` candidate fails re-verification, In progress →
its `claimedFrom` column when a claimed run stops before its PR opens, and the
same move again from Phase 1's reconcile sweep, which releases the claim of a
selection run that died without stopping. Each transition has exactly one owner; a board
write that fails is reported, never fatal.

## Code Review

Both the local `/review-changes` and the GitHub Actions reviewer
follow one shared spec, [`.github/CODE_REVIEW.md`](../../.github/CODE_REVIEW.md), and
**run only when the change touches reviewable code** — Swift for both
reviewers, plus committed `.claude/workflows/` and `Scripts/` for the local one
(docs/prose-only changes are not reviewed, unless the caller passes
`force-review` — `/deliver` does for a delivery that rewrites the pipeline's own
skills). Four subagents back the pipeline:
`code-reviewer` (deep Swift/TMDb review, pinned to Opus),
`documentation-writer` (bulk DocC generation, pinned to Sonnet),
`tooling-runner` (build/test execution, pinned to Haiku), and
`check-diagnoser` (PR-check diagnosis for `/fix-pr-checks` — reports, never
fixes; pinned to Haiku, with a repeat re-diagnosed on Opus via the caller's
call-site override).

## Completion Checklist

Iterate with `/format`, `/lint`, `/test` and `/integration-test` **while you
work** — then run **`make ci` once** before pushing or opening a PR. That is the
mandatory gate, and it already runs lint, markdown lint, both test suites, the
release build and the docs build, so **don't run those individually again just
before it**: the live integration suite is deliberately serialised, and
re-running it is the largest avoidable cost in a delivery (#401). `/pr`
documents the one sanctioned narrowing — a diff touching no `*.swift`,
`Makefile`, `Package.swift`, `Package.resolved`, `*.xctestplan`,
`.github/workflows/**` or `Tests/TMDbTests/Resources/**` (JSON fixtures are a
build input of `TMDbTests`) runs `make lint && make lint-markdown && make build-docs`
instead (drop `build-docs` only if no `*.docc/**` changed). `/pr` owns that rule;
if this paraphrase and `/pr` ever disagree, `/pr` is right. "Narrowed" is not
"skipped": one of the two must run and be green before pushing or opening a
PR — no exceptions.

**What `make ci` still cannot check in `README.md` is the narrative prose** —
`make lint` now gates the Swift code samples (`check-prose-call-forms.py`,
README + DocC articles) and the `.package(from:)` version
(`check-readme-version.py`), but feature lists, service tables and described
behaviour compile through no gate. If the public API changed, keep that prose
in sync by hand (see `/document-swift`). Record durable learnings with
`/capture-knowledge`.

`/deliver` runs this checklist, the self-review (`/review-changes`), and the PR
end-to-end; the individual skills are the manual fallback. Self-review still
applies — read every modified file, remove dead/debug code, confirm each public
declaration has an accurate `///`, and simplify where you can.

## Creating Pull Requests

Opening a PR is the **`/pr`** skill (commit → rebase onto `origin/main` →
`make ci` → review → push → open via the GitHub MCP), and **`/deliver`** runs it as
the final pipeline step. The gitmoji title convention and the PR body template live
in that skill.

GitHub access goes through the **GitHub MCP** (`mcp__github__*`), with `gh` as the
fallback and for the few things the MCP can't do (the blocking CI wait,
headless Actions). The MCP registration command, the `/x/all`
path rationale, the owner/repo derivation, and the full `gh`-only exceptions are in
[ADR-0009](../../knowledge/decisions/0009-github-mcp-over-gh-cli.md).
