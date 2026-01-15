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
