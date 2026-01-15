# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TMDb is a Swift Package for The Movie Database API, supporting iOS 16+, macOS 13+, watchOS 9+, tvOS 16+, visionOS 1+, Linux, and Windows. Built with Swift 6.0+ and strict concurrency.

## Common Commands

```bash
# Build
make build                    # Build for current platform
make build-release            # Release build

# Test
make test                     # Unit tests (macOS)
make test-ios                 # iOS simulator tests
make integration-test         # Integration tests (requires TMDB_API_KEY, TMDB_USERNAME, TMDB_PASSWORD)

# Single test (Swift Testing framework)
swift test --filter "TestClassName"
swift test --filter "TestClassName/testMethodName"

# Code Quality
make lint                     # Check swift-format compliance
make format                   # Auto-format code
make lint-markdown            # Lint markdown files

# Documentation
make preview-docs             # Preview DocC locally
make build-docs               # Build documentation

# Full CI check
make ci                       # All checks: lint, test, build, docs
```

## Architecture

### Service-Based Design

The library uses protocol-based services with dependency injection:

```
TMDbClient (main facade)
├── AccountService
├── AuthenticationService
├── MovieService
├── TVSeriesService
├── PersonService
├── SearchService
├── DiscoverService
├── TrendingService
└── ... (15 service protocols total)
```

**Key files:**
- `Sources/TMDb/TMDbClient.swift` - Main public API entry point
- `Sources/TMDb/TMDbFactory.swift` - Dependency injection factory
- `Sources/TMDb/Domain/Services/` - Service protocols and implementations
- `Sources/TMDb/Domain/Models/` - Codable data models (84 files)

### Networking Layer

```
HTTPClient (protocol)
└── URLSessionHTTPClientAdapter (default implementation)
    └── TMDbAPIClient (API-specific client)
```

### Test Organization

- `Tests/TMDbTests/` - Unit tests with mocks and JSON fixtures
- `Tests/TMDbIntegrationTests/` - Live API tests
- Uses Swift Testing framework (not XCTest)

## Code Style Requirements

Enforced via `.swift-format`:

- **Line length:** 100 characters
- **All public declarations must have documentation** (`///` style)
- **No force unwrapping** (`!`) or force try (`try!`)
- **Use guard for early exits**
- **No leading underscores** - use file-private instead

## Testing Requirements

**CRITICAL: Always run both unit tests AND integration tests after making code changes.**

### Why Both Test Types Matter

- **Unit tests** verify code logic with mocked data and fast execution
- **Integration tests** validate against the live TMDb API and catch real-world issues like:
  - Missing fields in API responses
  - Incorrect date/time formats
  - Type mismatches between mocks and actual API data
  - API changes or deprecations

### Testing Workflow

After implementing or modifying features:

1. **Run unit tests**: `make test` - Fast feedback on logic and mocked scenarios
2. **Run integration tests**: `make integration-test` - Validates against real API
3. **Both must pass** before considering the work complete

### Common Pitfalls

Unit tests alone may pass even when:
- JSON fixtures don't match actual API responses
- Mock data uses simplified date formats
- Required fields are missing from models
- API response structure has changed

**Integration tests catch these issues by using real API data.**

## Adding New Features

1. Define protocol in `Domain/Services/<ServiceName>/`
2. Add implementation prefixed with `TMDb` (e.g., `TMDbMovieService`)
3. Add models to `Domain/Models/` - must conform to `Codable`, `Equatable`, `Hashable`, `Sendable`
4. Register in `TMDbFactory.swift`
5. Expose via `TMDbClient.swift`
6. Add unit tests with JSON fixtures in `Tests/TMDbTests/Resources/`

## Understanding the TMDb API

### TMDb OpenAPI Specification

The complete TMDb API specification is available at:
**https://developer.themoviedb.org/openapi/tmdb-api.json**

Use this OpenAPI spec to:
- Understand available endpoints and their parameters
- See request/response schemas
- Discover query parameters, headers, and authentication requirements
- Find endpoint documentation and examples

### Using TMDb MCP Server

When implementing new features or exploring TMDb API responses:

**ALWAYS use the TMDb MCP server** (`mcp__tmdb__*` tools) to query the live TMDb API instead of making assumptions about response structures.

### When to Use TMDb MCP

- **Exploring API responses** - Fetch real data to understand response structure
- **Creating JSON fixtures** - Get actual API responses to create test fixtures
- **Verifying endpoint behavior** - Check what fields are returned, nullable fields, etc.
- **Discovering new endpoints** - Explore available TMDb API endpoints

### Example Workflow

1. Check the OpenAPI spec to understand the endpoint structure and parameters
2. Use MCP to fetch real data: `mcp__tmdb__movie_details` with a movie ID
3. Examine the actual JSON response structure
4. Create models based on real data, not assumptions
5. Save response as JSON fixture in `Tests/TMDbTests/Resources/json/`
6. Implement the feature with confidence in the data structure

### Benefits

- **Accurate models** - No guessing about field names or types
- **Real-world data** - Handles edge cases (null values, optional fields)
- **Up-to-date** - Always matches current TMDb API behavior
- **Faster development** - No need to manually test with curl or Postman

## Creating Pull Requests

When asked to create a PR, follow these steps:

### 1. Push the Branch

```bash
git push -u origin <branch-name>
```

### 2. Create PR with gh CLI

```bash
gh pr create --base main --head <branch-name> --title "<title>" --body "<body>"
```

### 3. PR Title Format

- Use appropriate **gitmoji** from [gitmoji.dev](https://gitmoji.dev) that best suits the changes
- Common gitmojis for this project:
  - ✨ `:sparkles:` - New features
  - 🐛 `:bug:` - Bug fixes
  - 📝 `:memo:` - Documentation updates
  - ♻️ `:recycle:` - Refactoring
  - ✅ `:white_check_mark:` - Adding/updating tests
  - 🔧 `:wrench:` - Configuration changes
  - ⚡️ `:zap:` - Performance improvements
  - 🎨 `:art:` - Code style/formatting

**Example:** `✨ Add createdBy property to TVSeries`

### 4. PR Body Structure

Use the following structure with appropriate sections:

```markdown
## Summary

[Brief description of what this PR does and why]

## Changes

[Detailed list of changes with gitmojis and bullet points]

**New Model/Feature/Component:**
- ✨ [Description]

**Existing Files:**
- 📝 [Description]
- 🔧 [Description]

**Tests:**
- ✅ [Description of test coverage]
- ✅ [Test results summary]

**Documentation:**
- 📚 [Description]

## Benefits

[List the benefits and improvements this PR provides]

- **[Benefit Category]**: [Description]
- **[Benefit Category]**: [Description]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

### 5. Determine Changes

Compare the branch against main to understand what changed:

```bash
# See which files changed
git diff --stat main...HEAD

# See commit history
git log --oneline main..HEAD
```

### 6. Example PR Creation

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

- Always reference [gitmoji.dev](https://gitmoji.dev) for the correct emoji
- Use comprehensive bullet points in all sections
- Include test results and validation in the Changes section
- Only include sections (Summary, Changes, Benefits) that are relevant
- Always end with the Claude Code attribution
