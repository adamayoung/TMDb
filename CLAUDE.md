# CLAUDE.md

This file provides guidance to Claude Code when working with code in this
repository.

## Project Overview

TMDb is a Swift Package for The Movie Database API, supporting iOS 16+,
macOS 13+, watchOS 9+, tvOS 16+, visionOS 1+, and Linux. Built with
Swift 6.0+ and strict concurrency. (Windows is deliberately **not**
claimed — no CI job builds it; see PR #374, which dropped the claim.)

## Knowledge Base

Durable, project-specific learnings live in [`knowledge/`](knowledge/) — read it
on demand; it is not loaded here to keep this file lean. (This is reference
knowledge; `CLAUDE.md` stays imperative.)

- [`knowledge/decisions/`](knowledge/decisions/) — **ADRs** (design decisions +
  rationale).
- [`knowledge/gotchas.md`](knowledge/gotchas.md) — quirks, tooling traps, things
  that needed a lookup.
- [`knowledge/tmdb-api-notes.md`](knowledge/tmdb-api-notes.md) — live-API
  behaviours.
- [`knowledge/next-major.md`](knowledge/next-major.md) — deferred **breaking
  changes**, queued so they resurface when the next major version opens.
- [`knowledge/skill-improvement-log.md`](knowledge/skill-improvement-log.md) —
  every skill-improvement proposal and its decision; the recurring-pattern
  scan's dedup memory.

**Before solving a non-trivial problem**, skim the relevant file. **After learning
something durable** (a gotcha, an API quirk, a design decision), record it there —
run `/capture-knowledge` (it runs automatically before a PR in `/deliver`). Add an
ADR for any non-obvious design decision.

## Architecture

### Service-Based Design

The library uses protocol-based services with dependency injection.
`TMDbClient` is the main facade exposing 28 service properties:

```text
TMDbClient (main facade)
├── AccountService
├── AuthenticationService
├── V4AuthenticationService
├── V4ListService
├── CertificationService
├── ChangesService
├── CollectionService
├── CompanyService
├── ConfigurationService
├── CreditService
├── DiscoverService
├── FindService
├── GenreService
├── GuestSessionService
├── ImageService
├── KeywordService
├── ListService
├── MovieService
├── NetworkService
├── PersonService
├── ReviewService
├── SearchService
├── TrendingService
├── TVEpisodeService
├── TVEpisodeGroupService
├── TVSeasonService
├── TVSeriesService
└── WatchProviderService
```

The on-device intelligence features live in a **separate `TMDbIntelligence`
library product** (see [ADR-0010](knowledge/decisions/0010-tmdb-intelligence-product.md)),
so the core `TMDb` product carries no API that cannot function on Linux.
`TMDbIntelligence` depends on `TMDb` and adds two `TMDbClient`
extensions, both **Apple-platforms only**:

- `naturalLanguageSearch` — gated by `#if canImport(NaturalLanguage)`. It
  interprets free-text queries on-device with a deterministic planner (a
  rule-based intent classifier plus `NLTagger` person-name extraction) and, on
  capable devices, an optional `FoundationModelsSearchPlanGenerator` fallback
  for fuzzier prompts — degrading to a plain multi-search where neither is
  available.
- `languageModelTools` / `TMDbToolbox` — see *Language Model Tools* below.

Consumers add the `TMDbIntelligence` product and `import TMDbIntelligence`
alongside `import TMDb`. Its test doubles ship in `TMDbIntelligenceTesting`.

**Key files:**

- `Sources/TMDb/TMDbClient.swift` — main public API entry point
- `Sources/TMDb/TMDbFactory.swift` — dependency injection factory
- `Sources/TMDb/Domain/Services/` — service protocols and implementations
- `Sources/TMDb/Domain/Models/` — Codable data models
- `Sources/TMDbIntelligence/NaturalLanguageSearch/` — on-device
  natural-language search (Apple-only)
- `Sources/TMDbIntelligence/LanguageModelTools/` — FoundationModels `Tool`s
  exposing TMDb to a conversational assistant (Apple-only)

### Networking Layer

Services call into `TMDbAPIClient`, which sits **above** the `HTTPClient`.
`TMDbAPIClient` adds the `api_key` query item, builds the request, validates
the response status, and decodes the body. It then delegates the raw HTTP
transport to an `HTTPClient`, which is a decorator chain: `CacheHTTPClient`
wraps `RetryHTTPClient`, which wraps the base adapter (the user-supplied
`HTTPClient` or the default `URLSessionHTTPClientAdapter`). Both retry and
cache decorators are opt-in (see `TMDbFactory.httpClient(wrapping:...)`).

```text
Service (e.g. TMDbMovieService)
└── APIClient (protocol)
    └── ErrorMappingAPIClient           (TMDbAPIError -> public TMDbError)
        └── UnmappedAPIClient (protocol)
            └── TMDbAPIClient           (adds api_key, validates status, decodes)
                └── HTTPClient (protocol)
                    └── CacheHTTPClient         (opt-in; hits short-circuit)
                        └── RetryHTTPClient     (opt-in; exponential backoff)
                            └── URLSessionHTTPClientAdapter  (or user-supplied)
```

`ErrorMappingAPIClient` is the **outermost** `APIClient`, so no service does its
own error translation. The two-protocol split is what enforces it: services
depend on `APIClient`, `TMDbAPIClient` conforms only to `UnmappedAPIClient`, so a
service *cannot* be wired to the unmapped client by accident. All three factory
methods (`apiClient`, `authAPIClient`, `v4APIClient`) wrap the same way — see
[ADR-0001](knowledge/decisions/0001-error-mapping-api-client.md).

### Language Model Tools (Apple-only)

`TMDbToolbox` (`Sources/TMDbIntelligence/LanguageModelTools/`) wraps the services
as FoundationModels `Tool`s so TMDb can back a conversational movie assistant
through a `LanguageModelSession`. It is gated by
`#if canImport(FoundationModels) && !os(tvOS)` and annotated
`@available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)`.

Eight tools are exposed: `search`, `movieDetails`, `movieCredits`,
`tvSeriesDetails`, `personFilmography`, `trending`, `watchProviders`, and
`discoverMovies`. They
are reachable from `TMDbClient` via `languageModelTools` (shorthand for
`TMDbToolbox(client:).all`) and individual `*Tool` accessors (`searchTool`,
`movieDetailsTool`, …). Each tool returns compact text whose every line leads
with the relevant TMDb `id`, letting the model chain calls — search a title,
then fetch its details or watch providers.

### Test Organization

- `Tests/TMDbTests/` — core unit tests with JSON fixtures (`Resources/`)
- `Tests/TMDbTestFixtures/` — **shared** mocks, `.mock` model factories, and
  test utilities (`Tags`, `Date+ISO8601`, `MockAPIClient`), at `package`
  access so both unit-test targets share one copy. It has no library product
  and is re-exported via `@_exported import TMDbTestFixtures`, so test files
  need no explicit import. Mocks of *internal* TMDb types stay in the target
  that `@testable`-imports them.
- `Tests/TMDbIntelligenceTests/` — unit tests for the intelligence module
- `Tests/TMDbTestingTests/` / `Tests/TMDbIntelligenceTestingTests/` — the
  testing kits, exercised through **public imports only** (no `@testable`)
- `Tests/TMDbIntegrationTests/` — live API tests
- Uses **Swift Testing** framework (`@Test`, `#expect`, `#require`) — not
  XCTest

**Adding a test target?** Test-target names are hardcoded in **four** places —
miss one and the failure is silent:

1. `Makefile` — `TEST_TARGET`.
2. `.github/workflows/ci.yml` — the macOS `Test` step's `--filter`.
3. `.github/workflows/ci.yml` — the Linux `Test` step's `--filter`.
4. `.github/workflows/ci.yml` — the **`Prepare Code Coverage`** loop
   (`for target in …`), which enumerates one `.xctest` bundle per target.

Miss 1–3 and the suite never runs; miss 4 and it runs but its coverage is
never exported, so the code it covers reads as uncovered on codecov.

## Understanding the TMDb API

### OpenAPI Specification

The complete API spec is at:
**<https://developer.themoviedb.org/openapi/tmdb-api.json>**

Use this to understand endpoints, request/response schemas, query
parameters, and authentication requirements.

### TMDb MCP Server

**ALWAYS use the TMDb MCP server** (`mcp__tmdb__*` tools) to query the
live API instead of making assumptions about response structures. Use it
for:

- **Exploring API responses** — fetch real data to understand structure
- **Creating JSON fixtures** — get actual API responses for test fixtures
- **Verifying endpoint behaviour** — check nullable/missing fields

### Workflow for New Endpoints

1. Check the OpenAPI spec for endpoint structure and parameters
2. Use MCP to fetch real data (e.g., `mcp__tmdb__movie_details`)
3. Examine the actual JSON response structure
4. **Sample the population before deciding optionality — don't spot-check.**
   One record tells you what *that* record has. Pull tens of records and build a
   field/nullability matrix: #404 nearly shipped a one-field fix because a
   single `curl` looked conclusive, and 54 companies showed a second field had
   the same bug; #432's 300-record sweep both cleared five decodes *and* found a
   bug the issue never mentioned. A sweep earns its keep by **excluding** as
   much as by finding — a measured "we checked, it isn't in the class" survives
   review; "the API probably never sends that" doesn't.
5. Create models based on real data, not assumptions
6. Save response as JSON fixture in `Tests/TMDbTests/Resources/json/`
7. Implement the feature

**A probe script must verify its own postcondition.** Live-API probing is how
this repo establishes truth, but the scripts doing it get none of the rigour the
Swift does, and two of #411's three bugs *were the probe lying*: a cleanup
`EXIT` trap that never fired and orphaned four lists on a real account, and a
uniform "rejected" result across a parameter sweep that was the spam filter
(`status_code` 18), not an answer. So: end a probe by asserting the state it
claims to have left — enumerate and confirm the cleanup happened — and treat a
**uniform** result across a sweep as evidence about the *sweep* until the error
body says otherwise.

## Development Workflow

Feature work is **skill-driven**. Draft and approve a plan in **plan mode**
(there is no `/plan` skill — use plan mode, or the `Plan` agent), then run
`/deliver` to carry it through to a ready-to-merge PR. **Invoking `/deliver` is
itself the plan-approval gate** — it then runs autonomously to a single hard stop,
**ready-to-merge**, pausing only for a plan-review blocker or a red gate it can't
triage. It **auto-scales** its review machinery to the change's risk (lite vs
full), **triages** an unrelated red CI gate to `/fix-integration-failures` rather
than stalling, and records each delivery's short retrospective into
[`knowledge/delivery-retros.md`](knowledge/delivery-retros.md) **before the PR
opens**, so it rides the delivery's own PR:

branch → (`/review-plan` for risky/large changes) → `/implement-plan` →
`/review-changes` (+ fix) → `/security-review` (+ fix) → rubric check →
`/capture-knowledge` → retro → `/pr reviewed` → `/watch-pr`.

Key skills (the README's *Claude Code Skills* tables list them all):

- **`/deliver`** — run the whole pipeline from an approved plan.
- **`/review-plan`** — adversarial 3-critic review of a plan; apply the consensus.
- **`/implement-plan`** — implement test-first (`canon-tdd`) to an empty test
  list, committing at logical checkpoints.
- **`/review-changes`** — code review of the working-tree change (scales: one
  reviewer, or a fan-out + adversarial verification for large diffs).
- **`/capture-knowledge`** — record durable learnings into `knowledge/`.
- **`/pr`**, **`/watch-pr`**, **`/review-pr-threads`**, **`/fix-pr-checks`** —
  open and shepherd the pull request.
- **`/document-swift`** — the canonical DocC conventions for public API.
- **`/fix-integration-failures`** — diagnose **and** fix a failing scheduled (or
  standalone) `Integration` run: re-run a transient, or fix real drift on a branch
  off `main` and open a PR. `/watch-pr` delegates the *pre-existing/unrelated*
  integration failure (one not in the PR's diff) here, since it's a `main` problem.

**Self-healing integration** — the weekly scheduled `Integration` run (Sunday
00:00 UTC) is watched by [`.github/workflows/integration-failure.yml`](.github/workflows/integration-failure.yml),
which runs `/fix-integration-failures` headless on a failure: it diagnoses, fixes
real drift on a branch off `main`, and opens a **PR for review** (never
auto-merges), then files/updates a tracking issue. Running headless, the skill
verifies with the targeted suite (not full `make ci`) and opens the PR via
`git`/`gh` (not `/pr`) — the PR's own CI is the gate.

**Code review** — both the local `/review-changes` and the GitHub Actions reviewer
follow one shared spec, [`.github/CODE_REVIEW.md`](.github/CODE_REVIEW.md), and
**run only when the change touches reviewable code** — Swift for both
reviewers, plus committed `.claude/workflows/` and `Scripts/` for the local one
(docs/prose-only changes are not reviewed, unless the caller passes
`force-review` — `/deliver` does for a delivery that rewrites the pipeline's own
skills). Three subagents back the pipeline:
`code-reviewer` (deep Swift/TMDb review, pinned to Opus),
`documentation-writer` (bulk DocC generation, pinned to Sonnet), and
`tooling-runner` (build/test execution, pinned to Haiku).

## Build and Test Tooling

### Prefer the Project Skills (Delegated to Haiku)

For builds and test runs, invoke the project skills rather than calling `make`
or the Xcode MCP directly: `/build`, `/build-for-testing`, `/test`, and
`/integration-test`. Each spawns the shared `tooling-runner` agent
(`.claude/agents/tooling-runner.md`, pinned to Haiku), which runs the command,
writes the full output to a `.build/last-*.log` file, and returns only a
concise summary (status, counts, failures as `file:line`) — keeping this
context lean. Its report is a **contract**: a `Directory:` and a `Status:`
line, always. `Status: refused` means a caller bug (wrong or missing package
directory) — surface it, never fall back; a report missing those lines means
the subagent died, so the run is *void* rather than failed — re-invoke once,
then fall back to `make -C <dir>` and say that you did.

`/lint` and `/format` run `make` directly (they are fast and low-output), and
`make ci` is run directly before a PR.

### Inside Xcode vs. terminal

Outside Xcode (terminal Claude Code), the skills fall back to `make`
(`make build` / `make test` / `make integration-test`). Inside Xcode (the native
Claude Agent integration) use the `mcp__xcode-tools__*` tools — **not**
`mcp__xcode__*` (a separate, redundant server). The full tool list, test-plan
selection (**TMDb** unit / **Integration**), and the xcsift output-formatting
details (`-f toon` local vs `-f github-actions` CI, `--Werror`, `pipefail`) are in
[`knowledge/gotchas.md`](knowledge/gotchas.md) under **Tooling**.

### Build Isolation and Sequential Builds

The `make` targets build with SwiftPM (`swift build`/`swift test`), not
`xcodebuild`, so there is no `-derivedDataPath`; the equivalent is the
scratch directory. Every target accepts an overridable `SCRATCH_PATH`
(default `.build`):

- Run builds **sequentially** within a worktree — concurrent `swift build`s
  fight over the same `.build` and cause SwiftPM lock contention and hangs.
- When multiple agents build at once in **separate git worktrees**, give each
  its own scratch dir, e.g. `make test SCRATCH_PATH=.build/agent-a`. Any path
  under `.build` is already covered by the `/.build` `.gitignore` rule.

### Shell Environment

Run shell commands directly — do not prefix them with
`source ~/.zshrc`. Required environment variables (`TMDB_API_KEY`,
`TMDB_USERNAME`, `TMDB_PASSWORD`) plus the two v4 credentials
(`TMDB_API_READ_ONLY_TOKEN`, `TMDB_API_USER_TOKEN` — without them the v4 suites
skip) are injected via the `env` block in `.claude/settings.local.json`, and Homebrew tools (`gh`, `swiftlint`,
`swiftformat`, `xcsift`, `markdownlint`) are already on `PATH`.

```bash
make integration-test
gh pr create ...
```

## Common Commands

The full command set lives in the `Makefile`; prefer the skills above (`/build`,
`/test`, `/lint`, `/format`) over raw `make`. The mandatory pre-PR gate is
`make ci` (lint, lint-markdown, test, integration-test, build-release,
build-docs); a single test runs via `swift test --filter "Suite/test"`.

There is no `make test-ios` target. Run simulator tests
(iOS/watchOS/tvOS/visionOS) from Xcode using the **TMDb** (unit) or
**Integration** test plans.

**The `.xctestplan` files are gitignored (`.gitignore:9`) and untracked**, so a
fresh clone has neither and this Xcode route is unavailable until you create
them locally. Nothing in CI depends on them — CI and `make` both drive SwiftPM
directly — so a contributor without them loses only the simulator route, not
coverage. Don't plan work that edits them: they are not in the repo (a plan once
scheduled a sweep over files that don't exist, #398). **Worktrees do get them**,
via `.worktreeinclude`. `Integration.xctestplan` stores the TMDb credentials as
literal values, since Xcode can't read `settings.local.json` — treat it as
credential-bearing.

## Code Style

Enforced via `swiftlint` and `swiftformat`:

- **Line length:** 120 characters (`.swiftformat --maxwidth 120`; SwiftLint's
  `line_length` default, with URLs, comments and interpolated strings exempt
  per `.swiftlint.yml`)
- **All public declarations must have documentation** (`///` style)
- **No force unwrapping** (`!`) or force try (`try!`)
- **Use guard for early exits**
- **No leading underscores** — use file-private instead
- **Validate inputs at public API boundaries** — guard against empty
  `OptionSet` values, nil/empty strings, and other degenerate inputs
  even if callers are unlikely to pass them

`swiftlint` and `swiftformat` are on `PATH`. **Versions are pinned** —
swiftlint `0.63.2` / swiftformat `0.61.1` — and CI downloads these exact
binaries, so keep local versions matched. A `superfluous_disable_command`
error on *unchanged* files is almost always a version-drift artifact (a
rule's behaviour changed between versions), not a real violation — check
`swiftlint version` against the pin before editing the flagged code.

### Auto-formatting on edit (PostToolUse hooks)

Two `PostToolUse` hooks (in `.claude/settings.json`) run automatically after every
`Edit`/`Write`, so files are reshaped on disk **after** you write them:

- **`.swift`** → `swiftlint --fix` then `swiftformat`.
- **`.md` / `.markdown`** → `markdownlint --fix` (auto-fixable rules only).
  `MD013` line-length is **disabled** repo-wide in `.markdownlintrc`, so long
  lines are not a lint failure — wrap prose near 80 columns for readability,
  not to satisfy a gate.

Consequences: the on-disk content can differ from what you wrote (imports
reordered, blank lines collapsed, list markers normalised). **Re-`Read` a file
before a dependent `Edit`** if the edit relies on exact surrounding text, and
don't attribute hook reformatting to your own diff. The hooks can't fix real
compile/lint errors — still run `/lint` and `make ci`.

**SourceKit `<new-diagnostics>` lag on new files.** After creating a **new**
`.swift` file and referencing its symbols elsewhere, the editor may report
`Cannot find 'X' in scope` or a spurious `No 'async' operations…within 'await'` —
**indexing-lag false positives** that clear on the next build. Trust
`make build` / `make build-tests` (they run with `--Werror`); don't chase them.
See [`knowledge/gotchas.md`](knowledge/gotchas.md).

## Testing

### Test-Driven Development

Use a TDD approach — **follow the `canon-tdd` skill**: write a test list, then a
failing test (unit **and** integration) before any production code, implement the
minimum to pass, then refactor green. For bug fixes, write a reproducing test
first.

### Always Run Both Unit Tests AND Integration Tests

- **Unit tests** (`make test`) verify logic with mocked data and JSON
  fixtures
- **Integration tests** (`make integration-test`) validate against the
  live TMDb API

Unit tests alone can pass even when JSON fixtures don't match actual API
responses, fields are missing from models, or the API structure has
changed. Integration tests catch these issues.

### Test Coverage

- **New features**: unit tests AND integration tests
- **Bug fixes**: test that reproduces the bug, then the fix
- **Refactoring**: existing tests must still pass; add tests for gaps
- **Model changes**: unit tests with JSON fixtures AND integration tests

### JSON Fixture Completeness

JSON fixtures must exercise **every code path** in the decoder. If a
custom `Decodable` init has separate branches for each optional
property, the fixture must include **all** of those properties — not
just a representative subset. Untested branches hide bugs.

- When a model decodes N optional appended properties, the fixture
  must include all N (use minimal data — one item per array is fine)
- Always pair with a "without appended data" test that verifies all
  optionals are `nil` when absent
- Never assume that "if one branch works, the rest will too" — each
  branch has its own `CodingKeys` and decoding logic

### Never Force Unwrap in Tests

Always use `#require()` instead of `!` for optionals:

```swift
// BAD
let item = result.items.first { $0.id == 42 }!

// GOOD
let item = try #require(result.items.first { $0.id == 42 })
```

## Adding New Features

Structural pattern for a new service:

1. Protocol in `Domain/Services/<ServiceName>/`; implementation prefixed `TMDb`
   (e.g. `TMDbMovieService`).
2. Models in `Domain/Models/` conform to `Codable`, `Equatable`, `Hashable`,
   `Sendable`.
3. Construct and expose the service in `TMDbClient.swift`'s private init.
   `TMDbFactory` vends only shared plumbing (`makeServiceDependencies`,
   `httpClient(wrapping:)`) — services are **not** registered there.
4. Unit tests with JSON fixtures (`Tests/TMDbTests/Resources/`) **and** integration
   tests (`Tests/TMDbIntegrationTests/`).

Drive it test-first with `canon-tdd`; keep DocC + `README.md` in sync via
`/document-swift`. A new method on an existing service follows the same testing and
documentation rules.

## Documentation

DocC documentation is **required** on every public declaration — `make build-docs`
runs warnings-as-errors, so a missing `///` breaks the build. The canonical
conventions (style, summary patterns, the `TMDb.docc/` catalog-sync rules, the
consistency checklist, and the README sync) live in the **`/document-swift`**
skill — applied inline as you write — and the `documentation-writer` agent handles
bulk sweeps. Keep `Sources/TMDb/TMDb.docc/`, `README.md`, and inline `///`
comments in sync with every public-API change.

## Completion Checklist

Iterate with `/format`, `/lint`, `/test` and `/integration-test` **while you
work** — then run **`make ci` once** before pushing or opening a PR. That is the
mandatory gate, and it already runs lint, markdown lint, both test suites, the
release build and the docs build, so **don't run those individually again just
before it**: the live integration suite is deliberately serialised, and
re-running it is the largest avoidable cost in a delivery (#401). `/pr`
documents the one sanctioned narrowing — a diff touching no `*.swift`,
`Makefile`, `Package.swift`, `Package.resolved`, `*.xctestplan` or
`.github/workflows/**` runs `make lint && make lint-markdown && make build-docs`
instead (drop `build-docs` only if no `*.docc/**` changed). `/pr` owns that rule;
if this paraphrase and `/pr` ever disagree, `/pr` is right.

**The one thing `make ci` cannot check is `README.md`** — `build-docs` compiles
DocC but cannot see a stale README. If the public API changed, keep it in sync
by hand (see `/document-swift`). Record durable learnings with
`/capture-knowledge`.

`/deliver` runs this checklist, the self-review (`/review-changes`), and the PR
end-to-end; the individual skills are the manual fallback. Self-review still
applies — read every modified file, remove dead/debug code, confirm each public
declaration has an accurate `///`, and simplify where you can.

## Branching

**CRITICAL: Never make changes directly on `main`.** All changes —
features, fixes, documentation, configuration — MUST be made on a
branch created from `main`.

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
> worktree** (under `.claude/worktrees/`, branched off `origin/main`) so the main
> checkout stays free for concurrent work, and tears the worktree down on merge.
> The branch-off-`main` rule above is the floor; the worktree is how `/deliver`
> meets it. See `.claude/skills/deliver/SKILL.md` (its worktree-entry and
> teardown phases).

## Creating Pull Requests

Opening a PR is the **`/pr`** skill (commit → rebase onto `origin/main` →
`make ci` → review → push → open via the GitHub MCP), and **`/deliver`** runs it as
the final pipeline step. The gitmoji title convention and the PR body template live
in that skill.

GitHub access goes through the **GitHub MCP** (`mcp__github__*`), with `gh` as the
fallback and for the few things the MCP can't do (the blocking CI wait,
headless Actions). The MCP registration command, the `/x/all`
path rationale, the owner/repo derivation, and the full `gh`-only exceptions are in
[ADR-0009](knowledge/decisions/0009-github-mcp-over-gh-cli.md).

**The pre-PR gate must pass before pushing or opening a PR — no exceptions.**
That is full `make ci`, or `/pr`'s docs/config-only narrowing above when the
diff qualifies. "Narrowed" is not "skipped": one of the two must run and be
green.
