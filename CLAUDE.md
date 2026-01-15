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
