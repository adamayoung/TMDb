# CLAUDE.md

This file provides guidance to Claude Code when working with code in this
repository.

## Project Overview

TMDb is a Swift Package for The Movie Database API, supporting iOS 16+,
macOS 13+, watchOS 9+, tvOS 16+, visionOS 1+, Linux, and Windows. Built
with Swift 6.0+ and strict concurrency.

## Architecture

### Service-Based Design

The library uses protocol-based services with dependency injection.
`TMDbClient` is the main facade exposing 25 service properties:

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
└── WatchProviderService
```

**Key files:**

- `Sources/TMDb/TMDbClient.swift` — main public API entry point
- `Sources/TMDb/TMDbFactory.swift` — dependency injection factory
- `Sources/TMDb/Domain/Services/` — service protocols and implementations
- `Sources/TMDb/Domain/Models/` — Codable data models (~140 files)

### Networking Layer

```text
HTTPClient (protocol)
└── URLSessionHTTPClientAdapter (default implementation)
    └── TMDbAPIClient (API-specific client)
```

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

## Build and Test Tooling

### When Xcode MCP is Available

**ALWAYS prefer Xcode MCP tools** (`mcp__xcode-tools__*`) when available:

- `mcp__xcode-tools__BuildProject` for building
- `mcp__xcode-tools__RunAllTests` for running tests
- `mcp__xcode-tools__XcodeRead`, `XcodeWrite`, `XcodeUpdate` for file
  operations

**Test Plan Selection:**

- **Unit tests**: Use the **TMDb** test plan (default)
- **Integration tests**: Use the **Integration** test plan

### When Xcode MCP is Not Available

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
make build-release            # Release build

# Test
make test                     # Unit tests (macOS)
make test-ios                 # iOS simulator tests
make integration-test         # Integration tests (requires env vars)

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

# Full CI check (run before creating a PR)
make ci                       # All checks: lint, test, build, docs
```

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

Tools are installed via Homebrew at `/opt/homebrew/bin/swiftlint` and
`/opt/homebrew/bin/swiftformat`, which is already on `PATH`.

## Testing

### Test-Driven Development

Use a TDD approach when implementing changes or new features:

1. **Write failing tests first** — define expected behaviour with unit
   tests and integration tests before writing implementation code
2. **Implement the minimum code** to make the tests pass
3. **Refactor** while keeping tests green

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
7. **Run full CI**: `make ci` — **REQUIRED before creating any PR**

Steps 3-4 must always pass. Steps 5-6 are conditional. Steps 1-2 can
be skipped if formatting tools are not installed. Step 7 is mandatory
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

## Creating Pull Requests

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
