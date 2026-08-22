# CLAUDE.md

This file provides guidance to Claude Code when working with code in this
repository. It carries the always-on rules; the detail behind them lives in
topic docs under [`.claude/docs/`](.claude/docs/) — **read the relevant doc
before working in its area** (see the table below).

## Project Overview

TMDb is a Swift Package for The Movie Database API, supporting iOS 16+,
macOS 13+, watchOS 9+, tvOS 16+, visionOS 1+, and Linux. Built with
Swift 6.1+ and strict concurrency. (Windows is deliberately **not**
claimed — no CI job builds it; see PR #374, which dropped the claim.)

`TMDbClient` is the main facade over protocol-based services with dependency
injection; the Apple-only on-device intelligence features ship as the separate
`TMDbIntelligence` product (with test doubles in `TMDbIntelligenceTesting`),
so the core `TMDb` product carries no API that cannot function on Linux.

## Topic Docs

| Doc | Read before… |
| --- | --- |
| [`architecture.md`](.claude/docs/architecture.md) | changing services, networking, models or the intelligence products; adding a feature |
| [`testing.md`](.claude/docs/testing.md) | writing or organising tests; adding a test target (names are hardcoded in five places) |
| [`tmdb-api.md`](.claude/docs/tmdb-api.md) | any work shaped by the live API — new endpoints, model changes, fixtures, probe scripts |
| [`workflow.md`](.claude/docs/workflow.md) | running a delivery, filing issues, code review, the completion checklist, opening a PR |
| [`tooling.md`](.claude/docs/tooling.md) | building/testing; choosing `make` vs skills vs Xcode; worktree/scratch-path isolation; the `.xctestplan` files (gitignored and untracked — don't plan work that edits them; `Integration.xctestplan` is credential-bearing) |
| [`code-style.md`](.claude/docs/code-style.md) | editing any file — auto-format hooks reshape it on disk; pinned tool versions; editor-diagnostic lag |

`.claude/docs/` carries imperative how-to-work-here detail; `knowledge/` (below)
carries reference material — why/what/gotcha. Keep new content on its own side
of that line.

## Knowledge Base

Durable, project-specific learnings live in [`knowledge/`](knowledge/) — read
it on demand: [`knowledge/decisions/`](knowledge/decisions/) (ADRs — design
decisions + rationale), [`knowledge/gotchas.md`](knowledge/gotchas.md) (quirks,
tooling traps, things that needed a lookup),
[`knowledge/tmdb-api-notes.md`](knowledge/tmdb-api-notes.md) (live-API
behaviours), [`knowledge/next-major.md`](knowledge/next-major.md) (deferred
**breaking changes**, queued so they resurface when the next major version
opens), and
[`knowledge/skill-improvement-log.md`](knowledge/skill-improvement-log.md)
(every skill-improvement proposal and its decision; the recurring-pattern
scan's dedup memory).

**Before solving a non-trivial problem**, skim the relevant file. Concretely:
when a command or tool fails **twice**, grep `knowledge/gotchas.md` for the
tool's name before a third attempt — the trap is usually already recorded, and
re-deriving it costs more than the grep. **After learning something durable**
(a gotcha, an API quirk, a design decision), record it there — run
`/capture-knowledge` (it runs automatically before a PR in `/deliver`). Add an
ADR for any non-obvious design decision.

## Development Workflow

Feature work is **skill-driven**: draft and approve a plan in **plan mode**
(there is no `/plan` skill), then run `/deliver` to carry it through to a
ready-to-merge PR — invoking `/deliver` is itself the plan-approval gate.
`/deliver next` and `/deliver issue <n>` are the planless selection runs.
Work discovered but not done gets **filed as a GitHub issue**
([`.github/ISSUE_FILING.md`](.github/ISSUE_FILING.md)), never left in a
transcript. Code review follows the shared spec
[`.github/CODE_REVIEW.md`](.github/CODE_REVIEW.md). The pipeline, the key
skills, the project board lifecycle and the supporting subagents are in
[`workflow.md`](.claude/docs/workflow.md).

## Build and Test Tooling

- **Prefer the project skills**: `/build`, `/build-for-testing`, `/test`,
  `/integration-test` (each delegates to the Haiku `tooling-runner` agent and
  returns a concise summary). `/lint` and `/format` run `make` directly, and
  `make ci` is run directly before a PR. The runner's report contract and the
  single-test exception are in [`tooling.md`](.claude/docs/tooling.md).
- **Run builds sequentially** within a worktree — concurrent `swift build`s
  fight over `.build` and hang. Parallel agents in separate worktrees each need
  their own `SCRATCH_PATH` (see [`tooling.md`](.claude/docs/tooling.md)).
- **ALWAYS use the TMDb MCP server** (`mcp__tmdb__*`) to query the live API
  instead of making assumptions about response structures — see
  [`tmdb-api.md`](.claude/docs/tmdb-api.md).
- For **symbol-level** Swift questions (call sites, conformances, real types),
  prefer SourceKit-LSP over `grep` — load it with `ToolSearch("select:LSP")`;
  usage notes in [`tooling.md`](.claude/docs/tooling.md).

## Code Style

Enforced via `swiftlint` and `swiftformat` (pinned versions and the
auto-format-on-edit hooks are in [`code-style.md`](.claude/docs/code-style.md)):

- **Line length:** 120 characters
- **All public declarations must have documentation** (`///` style)
- **No force unwrapping** (`!`) or force try (`try!`)
- **Use guard for early exits**
- **No leading underscores** — use file-private instead
- **Validate inputs at public API boundaries** — guard against empty
  `OptionSet` values, nil/empty strings, and other degenerate inputs
  even if callers are unlikely to pass them

`PostToolUse` hooks reshape `.swift` and `.md` files on disk after every
`Edit`/`Write` — **re-`Read` a file before a dependent `Edit`** that relies on
exact surrounding text (details in
[`code-style.md`](.claude/docs/code-style.md)).

## Testing

The detail behind each rule is in [`testing.md`](.claude/docs/testing.md):

- **TDD is mandatory — follow the `canon-tdd` skill**: test list first, then a
  failing test (unit **and** integration) before any production code; for bug
  fixes, a reproducing test first.
- **Both suites must pass**: unit tests (`/test`) AND integration tests
  (`/integration-test`) — unit tests alone can pass with fixtures that no
  longer match the live API.
- **JSON fixtures must exercise every code path in the decoder** — all N
  optional branches, plus a "without appended data" pairing.
- **Never force unwrap in tests** — use `try #require(...)`.
- Tests use **Swift Testing** (`@Test`, `#expect`, `#require`), not XCTest.

## Documentation

DocC documentation is **required** on every public declaration —
`make build-docs` runs warnings-as-errors, so a missing `///` breaks the build.
The canonical conventions (style, summary patterns, the `TMDb.docc/`
catalog-sync rules, the consistency checklist, and the README sync) live in the
**`/document-swift`** skill — applied inline as you write — while the
`documentation-writer` agent handles bulk sweeps. Keep
`Sources/TMDb/TMDb.docc/`, `README.md`, and inline `///` comments in sync with
every public-API change.

## Completion Checklist

Iterate with `/format`, `/lint`, `/test` and `/integration-test` while you
work — then **the pre-PR gate must pass before pushing or opening a PR — no
exceptions**: **`make ci` once**, or the docs/config-only narrowing `/pr` owns.
The full checklist — what not to re-run, the narrowing paraphrase, the
README-prose caveat — is in [`workflow.md`](.claude/docs/workflow.md).

## Branching

**CRITICAL: Never make changes directly on `main`.** All changes —
features, fixes, documentation, configuration — MUST be made on a
branch created from `main`. This is **enforced**, not just stated: a
`PreToolUse` hook in `.claude/settings.json` refuses `Edit`/`Write` while the
checkout is on `main`.

Before editing any file, verify you are on a branch other than `main`:

```bash
git branch --show-current
```

If you are on `main`, create a new branch first:

```bash
git checkout -b <branch-name>
```

Use a descriptive branch name with a conventional prefix
(`feature/`, `fix/`, `chore/`, `docs/`, etc.).

> **`/deliver` goes further** — it runs the whole delivery in its own **git
> worktree** (under `.claude/worktrees/`, branched off `origin/main`). This
> branch-off-`main` rule is the floor; the worktree is how `/deliver` meets it
> (see [`workflow.md`](.claude/docs/workflow.md)).

## Creating Pull Requests

Opening a PR is the **`/pr`** skill; `/deliver` runs it as the final pipeline
step. GitHub access goes through the **GitHub MCP** (`mcp__github__*`), with
`gh` as the fallback ([ADR-0009](knowledge/decisions/0009-github-mcp-over-gh-cli.md)).
Details in [`workflow.md`](.claude/docs/workflow.md).
