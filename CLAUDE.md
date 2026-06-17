# CLAUDE.md

This file provides guidance to Claude Code when working with code in this
repository.

## Project Overview

TMDb is a Swift Package for The Movie Database API, supporting iOS 16+,
macOS 13+, watchOS 9+, tvOS 16+, visionOS 1+, Linux, and Windows. Built
with Swift 6.0+ and strict concurrency.

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

**Before solving a non-trivial problem**, skim the relevant file. **After learning
something durable** (a gotcha, an API quirk, a design decision), record it there —
run `/capture-knowledge` (it runs automatically before a PR in `/deliver`). Add an
ADR for any non-obvious design decision.

## Architecture

### Service-Based Design

The library uses protocol-based services with dependency injection.
`TMDbClient` is the main facade exposing 26 service properties:

```text
TMDbClient (main facade)
├── AccountService
├── AuthenticationService
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
├── WatchProviderService
└── NaturalLanguageSearchService
```

The `naturalLanguageSearch` service is **Apple-platforms only** — it is
defined in a `TMDbClient` extension gated by `#if canImport(NaturalLanguage)`,
so it is unavailable on Linux and Windows. It interprets free-text queries
on-device with a deterministic planner (a rule-based intent classifier plus
`NLTagger` person-name extraction) and, on capable devices, an optional
`FoundationModelsSearchPlanGenerator` fallback for fuzzier prompts — degrading
to a plain multi-search where neither is available.

**Key files:**

- `Sources/TMDb/TMDbClient.swift` — main public API entry point
- `Sources/TMDb/TMDbFactory.swift` — dependency injection factory
- `Sources/TMDb/Domain/Services/` — service protocols and implementations
- `Sources/TMDb/Domain/Models/` — Codable data models (~170 files)
- `Sources/TMDb/Domain/LanguageModelTools/` — FoundationModels `Tool`s
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
└── APIClient
    └── TMDbAPIClient            (adds api_key, validates status, decodes)
        └── HTTPClient (protocol)
            └── CacheHTTPClient          (opt-in; cache hits short-circuit)
                └── RetryHTTPClient      (opt-in; exponential backoff)
                    └── URLSessionHTTPClientAdapter  (or user-supplied client)
```

In 18.0.0 an `ErrorMappingAPIClient` decorator wraps the `APIClient` to
centralise mapping of `TMDbAPIError` into the public `TMDbError`.

### Language Model Tools (Apple-only)

`TMDbToolbox` (`Sources/TMDb/Domain/LanguageModelTools/`) wraps the services
as FoundationModels `Tool`s so TMDb can back a conversational movie assistant
through a `LanguageModelSession`. It is gated by
`#if canImport(FoundationModels) && !os(tvOS)` and annotated
`@available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)`.

Seven tools are exposed: `search`, `movieDetails`, `tvSeriesDetails`,
`personFilmography`, `trending`, `watchProviders`, and `discoverMovies`. They
are reachable from `TMDbClient` via `languageModelTools` (shorthand for
`TMDbToolbox(client:).all`) and individual `*Tool` accessors (`searchTool`,
`movieDetailsTool`, …). Each tool returns compact text whose every line leads
with the relevant TMDb `id`, letting the model chain calls — search a title,
then fetch its details or watch providers.

### Test Organization

- `Tests/TMDbTests/` — unit tests with mocks and JSON fixtures
- `Tests/TMDbIntegrationTests/` — live API tests
- Uses **Swift Testing** framework (`@Test`, `#expect`, `#require`) — not
  XCTest

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
4. Create models based on real data, not assumptions
5. Save response as JSON fixture in `Tests/TMDbTests/Resources/json/`
6. Implement the feature

## Development Workflow

Feature work is **skill-driven**. Draft a plan with `/plan`, then run `/deliver`
to carry it through to a ready-to-merge PR. `/deliver` orchestrates the pipeline
and stops only at two approval gates (the revised plan, and ready-to-merge):

`/review-plan` → branch → `/implement-plan` → `/review-changes` (+ fix) →
`/capture-knowledge` → `/pr` → `/watch-pr`.

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

**Code review** — both the local `/review-changes` and the GitHub Actions reviewer
follow one shared spec, [`.github/CODE_REVIEW.md`](.github/CODE_REVIEW.md), and
**run only when the change touches Swift** (docs/config-only changes are not
reviewed). Two subagents back the pipeline: `code-reviewer` (deep Swift/TMDb
review) and `documentation-writer` (bulk DocC generation).

## Build and Test Tooling

### Prefer the Project Skills (Delegated to Haiku)

For builds and test runs, invoke the project skills rather than calling `make`
or the Xcode MCP directly: `/build`, `/build-for-testing`, `/test`, and
`/integration-test`. Each delegates to a Haiku subagent that runs the command,
writes the full output to a `.build/last-*.log` file, and returns only a
concise summary (status, counts, failures as `file:line`) — keeping this
context lean. `/lint` and `/format` run `make` directly (they are fast and
low-output), and `make ci` is run directly before a PR.

### When Running Inside Xcode (via Claude Agent)

Use **`xcode-tools` MCP server tools** — the native Xcode–Claude Agent
integration. Do **NOT** use `mcp__xcode__*` tools; those are a separate
server and are redundant here.

- `mcp__xcode-tools__BuildProject` for building
- `mcp__xcode-tools__RunAllTests` / `mcp__xcode-tools__RunSomeTests` for tests
- `mcp__xcode-tools__XcodeRead`, `mcp__xcode-tools__XcodeWrite`,
  `mcp__xcode-tools__XcodeUpdate` for file operations
- `mcp__xcode-tools__XcodeGrep`, `mcp__xcode-tools__XcodeGlob`,
  `mcp__xcode-tools__XcodeLS` for searching
- `mcp__xcode-tools__XcodeRefreshCodeIssuesInFile` for fast diagnostics
- `mcp__xcode-tools__RunCodeSnippet` for lightweight code evaluation

**Test Plan Selection:**

- **Unit tests**: Use the **TMDb** test plan (default)
- **Integration tests**: Use the **Integration** test plan

### When Not Running Inside Xcode

Fall back to `make` commands:

- `make build` for building
- `make test` for unit tests
- `make integration-test` for integration tests

### xcsift Output Formatting

All macOS `make` build and test targets pipe output through
[xcsift](https://github.com/ldomaradzki/xcsift) for structured,
token-efficient output. Linux/Docker targets do not use xcsift.

**Install:** `brew install xcsift`

- Local builds use `xcsift -f toon` (TOON format)
- CI builds use `xcsift -f github-actions` (GitHub annotations)
- Build targets include `--Werror` to treat warnings as errors
- `set -o pipefail` ensures failures propagate through the pipe
- `2>&1` captures stderr (where compiler diagnostics are emitted)

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
`TMDB_USERNAME`, `TMDB_PASSWORD`) are injected via the `env` block in
`.claude/settings.local.json`, and Homebrew tools (`gh`, `swiftlint`,
`swiftformat`, `xcsift`, `markdownlint-cli2`) are already on `PATH`.

```bash
make integration-test
gh pr create ...
```

## Common Commands

```bash
# Build
make build                    # Build for current platform
make build-tests              # Build the package + all test targets
make build-release            # Release build
make build-linux              # Build in a Swift Docker container

# Test
make test                     # Unit tests (macOS)
make integration-test         # Integration tests (requires env vars)
make test-linux               # Unit tests in a Swift Docker container

# Single test (Swift Testing framework)
swift test --filter "TestClassName"
swift test --filter "TestClassName/testMethodName"

# Code Quality
make format                   # Auto-format code
make lint                     # Check swiftlint and swiftformat compliance
make lint-markdown            # Lint markdown files

# Documentation
make preview-docs             # Preview DocC locally
make build-docs               # Build documentation (warnings-as-errors)
make generate-docs            # Generate static DocC site into docs/

# Full CI check (run before creating a PR)
make ci                       # lint, lint-markdown, test, integration-test,
                              #   build-release, build-docs
```

There is no `make test-ios` target. Run simulator tests
(iOS/watchOS/tvOS/visionOS) from Xcode using the **TMDb** (unit) or
**Integration** test plans.

## Code Style

Enforced via `swiftlint` and `swiftformat`:

- **Line length:** 100 characters
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
- **`.md` / `.markdown`** → `markdownlint --fix` (auto-fixable rules only — it
  **cannot** fix `MD013` line-length, so still wrap long lines by hand).

Consequences: the on-disk content can differ from what you wrote (imports
reordered, blank lines collapsed, list markers normalised). **Re-`Read` a file
before a dependent `Edit`** if the edit relies on exact surrounding text, and
don't attribute hook reformatting to your own diff. The hooks can't fix real
compile/lint errors — still run `/lint` and `make ci`.

## Testing

### Test-Driven Development

Use a TDD approach when implementing changes or new features. **Follow the
`canon-tdd` skill** — start every feature, endpoint, model, method, or bug
fix by writing a test list and a failing test before any production code.
The loop:

1. **Write a test list** — enumerate the behaviours and edge cases first
2. **Write failing tests first** — define expected behaviour with unit
   tests and integration tests before writing implementation code, one
   test at a time
3. **Implement the minimum code** to make the tests pass
4. **Refactor** while keeping tests green

For bug fixes, write a test that reproduces the bug before writing the
fix.

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

1. Define protocol in `Domain/Services/<ServiceName>/`
2. Add implementation prefixed with `TMDb` (e.g., `TMDbMovieService`)
3. Add models to `Domain/Models/` — conform to `Codable`, `Equatable`,
   `Hashable`, `Sendable`
4. Register in `TMDbFactory.swift`
5. Expose via `TMDbClient.swift`
6. Add unit tests with JSON fixtures in `Tests/TMDbTests/Resources/`
7. Add integration tests in `Tests/TMDbIntegrationTests/`
8. Update documentation (see Documentation section)
9. Run the completion checklist

### Adding New Methods to Existing Services

1. Add `///` doc comment with parameters, throws, and returns
2. Add method reference to `TMDb.docc/Extensions/<Service>Service.md`
3. Add any new return types to `TMDb.docc/TMDb.md` topic section
4. Update `README.md` if the method adds a notable capability
5. Run `make build-docs` and `make lint-markdown`

## Documentation

Update DocC documentation whenever the public API changes.

### Structure

```text
Sources/TMDb/TMDb.docc/
├── TMDb.md                      # Main catalog with topic sections
├── Extensions/
│   ├── TMDbClient.md            # TMDbClient properties
│   ├── <ServiceName>Service.md  # Service method groupings
│   └── ...
├── GettingStarted/
├── HowTos/
└── Resources/
```

### What to Update

- **New services**: create extension file in `TMDb.docc/Extensions/`,
  add to `TMDb.docc/TMDb.md`, add to
  `TMDb.docc/Extensions/TMDbClient.md`, update `README.md` service
  table and count
- **New public models**: add to appropriate topic section in
  `TMDb.docc/TMDb.md`
- **New service methods**: update the service's extension file
- **Renamed or removed API**: update all affected documentation files

### Consistency Checklist

After public API changes, verify all of the following are in sync:

1. **Service extension files**
   (`TMDb.docc/Extensions/<Service>Service.md`) reference **every**
   method in the corresponding service protocol
2. **DocC catalog** (`TMDb.docc/TMDb.md`) includes all return types in
   the appropriate topic section
3. **TMDbClient extension** (`TMDb.docc/Extensions/TMDbClient.md`)
   lists all public properties on `TMDbClient`
4. **README.md** service table has accurate descriptions and correct
   service count
5. **README.md** examples use the correct `swift-tools-version`
   matching `Package.swift`
6. **Inline doc comments** (`///`) use correct DocC syntax
   (`- Parameter name:` singular, `- Parameters:` plural for multiple)

### Common Mistakes

- Missing methods from extension files (e.g., `credits()` when both
  `credits()` and `aggregateCredits()` exist)
- Missing return types from `TMDb.md` topic sections
- Stale service count in README after adding services
- `- Parameters name:` (plural) instead of `- Parameter name:`
  (singular)
- Copy-paste errors in doc comments when creating similar models
  (e.g., "movie" instead of "person", wrong parameter descriptions)
- Initializer parameter types not matching property types (e.g.,
  `Movie.ID` instead of `Person.ID`) — compiles when both resolve to
  `Int` but is semantically wrong
- Missing `///` doc comments on custom `init(from:)` and
  `encode(to:)` methods in `public extension` blocks
- Placeholder or incomplete doc comments (e.g., `/// ?`,
  `Array of....`) — always write complete descriptions

## Completion Checklist

**Before considering ANY task complete, run these steps in order:**

1. **Format code** (if tools available): `make format`
2. **Check lint** (if tools available): `make lint`
3. **Run unit tests**: `make test` — **REQUIRED**, must pass
4. **Run integration tests**: `make integration-test` — **REQUIRED**,
   must pass
5. **Build documentation**: `make build-docs` — required if public API
   changed
6. **Lint markdown**: `make lint-markdown` — required if `.md` files
   changed
7. **Capture learnings**: run `/capture-knowledge` — record durable
   gotchas, API quirks, and design decisions (ADRs) into `knowledge/`
   before a PR (no-op if nothing durable was learned)
8. **Run full CI**: `make ci` — **REQUIRED before creating any PR**

Run steps 3-4 (and any builds) via the `/test` and `/integration-test`
skills — they delegate to a Haiku subagent to keep this context lean.
`/format`, `/lint`, and `make ci` run directly.

Steps 3-4 must always pass. Steps 5-7 are conditional (5-6 on what
changed; 7 is a no-op when nothing durable was learned). Steps 1-2 can
be skipped if formatting tools are not installed. Step 8 is mandatory
before pushing code or creating a pull request.

### Self-Review

After all checks pass, review your own changes before considering the
task complete:

- Read through every modified file
- Remove unnecessary changes, leftover debugging code, or dead
  comments
- Check every public declaration has an accurate `///` doc comment
- Look for opportunities to simplify the implementation
- Verify consistency with existing patterns in the codebase
- Confirm DocC extension files, `TMDb.docc/TMDb.md`, `TMDbClient.md`,
  and `README.md` are all in sync with any API changes (see
  Documentation Consistency Checklist above)
- Run `make build-docs` if any documentation was updated

Make improvements where you find them.

### Update README.md

Before creating a PR, review `README.md` and update it to reflect your
changes:

- Service table and count if services were added, removed, or renamed
- Feature list if new capabilities were introduced
- Prerequisites if new tools or dependencies are required
- Code examples if usage patterns changed
- Requirements if platform support changed

Run `make lint-markdown` after any README changes.

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

## Creating Pull Requests

> The **`/pr`** skill automates this whole section (commit outstanding work →
> `make ci` → review → push → open), and **`/deliver`** runs it as the final step
> of the feature pipeline. The manual steps below are the fallback / reference.

**CRITICAL: You MUST run `make ci` and ensure it passes before pushing
and creating a PR.** This is a hard requirement - no exceptions.

### 1. Run Full CI Check (MANDATORY)

```bash
make ci
```

**All checks must pass before proceeding.** Do not skip this step. Do not
push code or create PRs if CI is failing.

### 2. Determine Changes

```bash
git diff --stat main...HEAD
git log --oneline main..HEAD
```

### 3. Push the Branch

```bash
git push -u origin <branch-name>
```

### 4. Create PR with gh CLI

```bash
gh pr create --base main --head <branch-name> \
  --title "<title>" --body "<body>"
```

### 5. PR Title Format

Use appropriate **gitmoji** from [gitmoji.dev](https://gitmoji.dev):

- ✨ `:sparkles:` — New features
- 🐛 `:bug:` — Bug fixes
- 📝 `:memo:` — Documentation updates
- ♻️ `:recycle:` — Refactoring
- ✅ `:white_check_mark:` — Adding/updating tests
- 🔧 `:wrench:` — Configuration changes
- ⚡️ `:zap:` — Performance improvements
- 🎨 `:art:` — Code style/formatting

**Example:** `✨ Add createdBy property to TVSeries`

### 6. PR Body Structure

```markdown
## Summary

[Brief description of what this PR does and why]

## Changes

**New Model/Feature/Component:**
- ✨ [Description]

**Existing Files:**
- 📝 [Description]

**Tests:**
- ✅ [Description of test coverage]

**Documentation:**
- 📚 [Description]

## Benefits

- **[Benefit Category]**: [Description]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

### 7. Example

```bash
gh pr create --base main --head feature/my-feature \
  --title "✨ Add new feature" \
  --body "$(cat <<'EOF'
## Summary

Brief description of the feature.

## Changes

**New Model:**
- ✨ Created `MyModel` with properties X, Y, Z

**Tests:**
- ✅ Added comprehensive unit tests
- ✅ All tests passing

## Benefits

- **Complete Coverage**: Users can now access feature X
- **Type Safety**: Strongly-typed models provide better IDE support

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Important Notes

- Reference [gitmoji.dev](https://gitmoji.dev) for the correct emoji
- Include test results in the Changes section
- Only include sections that are relevant
- Always end with the Claude Code attribution
