# TMDb - The Movie Database

[![CI](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml)
[![Integration](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml)
[![CodeQL](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml)
[![Documentation](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml)
[![codecov](https://codecov.io/gh/adamayoung/TMDb/graph/badge.svg?token=TICHRASF6F)](https://codecov.io/gh/adamayoung/TMDb)
[![Swift 6.0+](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS%20|%20Linux-blue.svg)](https://github.com/adamayoung/TMDb)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Features

* **Comprehensive API Coverage**: Full support for TMDb API v3 with 26
  specialized services
* **Append to Response**: Fetch details with credits, images, videos,
  and more in a single request using `append_to_response`
* **Movie & TV Data**: Details, credits, images, videos, reviews,
  recommendations, similar content
* **Discovery & Search**: Advanced filtering, multi-type search,
  trending content
* **User Features**: Account management, favorites, watchlists, ratings
  (requires authentication)
* **Metadata**: Genres, certifications, companies, collections, watch
  providers
* **Image Generation**: Built-in URL generation for all image types with
  size optimization, typed `ImageSize` selection, and convenience accessors
  on models
* **Display Formatting**: Foundation `FormatStyle` conformances for
  rendering runtimes (`"2h 15m"`, `"139 min"`, `"2 hours, 15 minutes"`)
  and vote averages as percentages (e.g. `"85%"` in English locales)
* **Swift 6 Ready**: Full strict concurrency support with Sendable types
* **Cross-Platform**: iOS 16+, macOS 13+, watchOS 9+, tvOS 16+,
  visionOS 1+, Linux
* **Automatic Retry**: Opt-in retry with exponential backoff for rate
  limits (HTTP 429) and server errors (HTTP 5xx)
* **Response Caching**: On-disk HTTP caching by default on Apple platforms
  (via `URLCache`, honouring TMDb's `Cache-Control` headers), plus an opt-in
  in-memory cache with configurable TTL and entry limits
* **Natural-Language Search**: On-device "super search" — type a prompt,
  get movies, TV series, and people. Deterministic interpretation via
  Apple's Natural Language framework on every Apple platform, with
  Foundation Models handling fuzzier prompts on devices with Apple
  Intelligence
* **Language Model Tools**: Drop-in Foundation Models `Tool`s for a
  conversational movie assistant — add them to a `LanguageModelSession`
  and the model searches, fetches details, and finds streaming
  availability on its own (iOS/macOS/visionOS 26, watchOS 27)
* **Modern Swift**: Async/await throughout, strongly-typed models,
  protocol-based architecture

## Available Services

| Service | Description |
| ------- | ----------- |
| **movies** | Movie details, credits, keywords, images, videos, reviews, recommendations, similar, releases, watch providers, append-to-response |
| **tvSeries** | TV show details, credits, images, videos, reviews, recommendations, similar, watch providers, screened theatrically, episode groups, append-to-response |
| **tvSeasons** | Season-specific details, aggregate credits, credits, images, videos, translations, watch providers, append-to-response |
| **tvEpisodes** | Episode-specific details, credits, images, videos, translations, append-to-response |
| **people** | Person details, combined/movie/TV credits, images, external links, translations, append-to-response |
| **search** | Multi-search across movies, TV shows, people, collections, companies, keywords |
| **discover** | Advanced filtering for movies and TV shows with 30+ filter options |
| **trending** | Trending movies, TV shows, people, and all media (daily/weekly) |
| **find** | Find movies, TV shows, and people by external IDs (IMDb, TVDB, etc.) |
| **account** | User favorites, watchlist, rated items (requires authentication) |
| **authentication** | Session management, guest sessions, request tokens |
| **genres** | Genre lists for movies and TV shows |
| **keywords** | Keyword details and movies by keyword |
| **networks** | TV network details, alternative names, logos |
| **watchProviders** | Streaming availability by region |
| **certifications** | Content ratings (G, PG, R, etc.) |
| **collections** | Movie collection details, images, translations |
| **companies** | Production company details, alternative names, logos |
| **lists** | Custom list management (requires authentication) |
| **configurations** | API configuration, countries, jobs, languages, primary translations, timezones |
| **changes** | Track changes to movies, TV series, people, seasons, and episodes |
| **credits** | Credit details including person and media information |
| **reviews** | Review details with author and media information |
| **tvEpisodeGroups** | TV episode group details and episode organization |
| **guestSessions** | Guest session rated movies, TV series, and episodes |
| **naturalLanguageSearch** | On-device natural-language search (all Apple platforms; enhanced by Foundation Models with Apple Intelligence) |
| **languageModelTools** | Foundation Models tools for a `LanguageModelSession` movie assistant (iOS/macOS/visionOS 26, watchOS 27) |

See the [full API documentation](https://adamayoung.github.io/TMDb/documentation/tmdb/)
for detailed usage.

## Requirements

* Swift 6.0+
* OS
  * macOS 13+
  * iOS 16+
  * watchOS 9+
  * tvOS 16+
  * visionOS 1+
  * Linux

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the TMDb package as a dependency to your `Package.swift` file, and add it
as a dependency to your target.

```swift
// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "MyProject",

  dependencies: [
    .package(url: "https://github.com/adamayoung/TMDb.git", from: "18.0.0")
  ],

  targets: [
    .target(name: "MyProject", dependencies: ["TMDb"])
  ]
)
```

### Xcode project

Add the TMDb package to your Project's Package dependencies.

### Testing support

The package also vends a `TMDbTesting` library for use in **test targets**. It
provides a spy + stub mock for every service protocol (each records its calls
and returns an injectable result, defaulting to believable sample data) and
`.sample` / `.samples` factories for every service return type — so you can test
code that depends on TMDb without hitting the live API. Add it to your test
target only:

```swift
.testTarget(
  name: "MyProjectTests",
  dependencies: ["MyProject", "TMDbTesting"]
)
```

```swift
import TMDb
import TMDbTesting

let movieService = MockMovieService()
movieService.detailsResult = .success(.sample)

let movie = try await movieService.details(forMovie: 550)
#expect(movieService.detailsCalls.first?.movieID == 550)
```

## Setup

### Get an API Key

Create an API key from The Movie Database web site
[https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).

Alternatively, use the v4 **API Read Access Token** from the same settings
page. It is sent as an `Authorization: Bearer` header rather than in the URL,
keeping the credential out of logs, proxies, and cache keys:

```swift
let tmdbClient = TMDbClient(bearerToken: "<your-access-token>")
```

### Quick Start

```swift
import TMDb

// Initialize client
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

// Discover movies with filters
let popularMovies = try await tmdbClient.discover.movies(
    sortedBy: .popularity(descending: true)
).results

// Get movie details
let fightClub = try await tmdbClient.movies.details(forMovie: 550)
print("Title: \(fightClub.title)")
if let releaseDate = fightClub.releaseDate {
    print("Release Date: \(releaseDate.formatted(.dateTime.year().month().day()))")
}
if let voteAverage = fightClub.voteAverage {
    print("Rating: \(voteAverage.formatted(.voteAveragePercentage))")
}

// Search across movies, TV shows, and people
let searchResults = try await tmdbClient.search.multi(query: "Breaking Bad")

// Get trending movies today
let trendingMovies = try await tmdbClient.trending.movies(inTimeWindow: .day)

// Get streaming providers for a movie
let watchProviders = try await tmdbClient.movies.watchProviders(forMovie: 550)
if let usProvider = watchProviders.first(where: { $0.countryCode == "US" }) {
    print("Available on: \(usProvider.watchProviders.flatRate?.map(\.name) ?? [])")
}

// Generate poster image URL
let config = try await tmdbClient.configurations.apiConfiguration()
if let posterPath = fightClub.posterPath {
    let posterURL = config.images.posterURL(for: posterPath, idealWidth: 500)
}

// Or request a specific size, directly from the model
let posterURL = fightClub.posterURL(using: config.images, size: .width(500))
```

### Configuration

By default, the TMDb client automatically uses your system's language and
country settings from `Locale.current`:

```swift
import TMDb

// Uses system locale automatically (recommended)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>")
```

You can also configure the client with custom language and country settings:

```swift
// Custom configuration
let configuration = TMDbConfiguration(
    defaultLanguage: "es-ES",  // ISO 639-1 language code
    defaultCountry: "ES"       // ISO 3166-1 country code
)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>", configuration: configuration)

// Disable locale defaults (API determines language)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>", configuration: .default)
```

Per-request overrides are always available:

```swift
// Override language for a specific request
let movieInFrench = try await tmdbClient.movies.details(forMovie: 550, language: "fr")
```

#### Automatic Retry

Enable automatic retry with exponential backoff for transient errors. By
default this retries rate limits (HTTP 429), server errors (HTTP 5xx) and
transient network failures (timeouts, dropped connections, DNS failures):

```swift
// Use default retry (3 retries, exponential backoff)
let configuration = TMDbConfiguration(retry: .default)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>", configuration: configuration)

// Custom retry configuration: retry rate limits and transient network errors
let retryConfig = RetryConfiguration(
    maxRetries: 5,
    initialDelay: .seconds(2),
    retryableErrors: [.rateLimit, .networkErrors]
)
let tmdbClient = TMDbClient(
    apiKey: "<your-api-key>",
    configuration: TMDbConfiguration(retry: retryConfig)
)
```

#### Response Caching

On Apple platforms the default client already caches responses **on disk** via
`URLCache`, honouring TMDb's `Cache-Control` and `ETag` headers — so repeated
requests are served from disk (and persist across launches) with no
configuration. To tune or disable it, supply your own `HTTPClient` backed by a
`URLSession` you configure.

For an additional in-memory layer (or for caching on Linux, where
`URLCache` is not installed), enable in-memory response caching:

```swift
// Use default caching (1-hour TTL, 100 entries)
let configuration = TMDbConfiguration(cache: .default)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>", configuration: configuration)

// Custom cache configuration
let cacheConfig = CacheConfiguration(
    defaultTTL: .seconds(1800),    // 30-minute TTL
    maximumEntryCount: 200
)
let tmdbClient = TMDbClient(
    apiKey: "<your-api-key>",
    configuration: TMDbConfiguration(cache: cacheConfig)
)

// Combine retry and caching
let tmdbClient = TMDbClient(
    apiKey: "<your-api-key>",
    configuration: TMDbConfiguration(retry: .default, cache: .default)
)
```

## Common Use Cases

### Displaying Movie Details

```swift
let movie = try await tmdbClient.movies.details(forMovie: movieId)
let credits = try await tmdbClient.movies.credits(forMovie: movieId)
let images = try await tmdbClient.movies.images(forMovie: movieId)
```

### Building a Discover/Browse Interface

Compose filters fluently with copy-returning builder methods. Each method
returns a new filter, so filters can be built up incrementally without
mutating shared state:

```swift
let filter = DiscoverMovieFilter()
    .withGenres([28, 12]) // Action AND Adventure
    .voteAverage(in: 7...10)
    .primaryReleaseYear(.on(2024))

let movies = try await tmdbClient.discover.movies(
    filter: filter,
    sortedBy: .popularity(descending: true)
)
```

Multi-valued parameters such as genres and keywords can be joined with
logical `AND` (the default) or `OR` using `DiscoverFilterJoin`:

```swift
// Match movies tagged with genre 28 OR genre 12
let filter = DiscoverMovieFilter().withGenres([28, 12], joinedBy: .or)
```

### Getting Watch Providers (Streaming Availability)

```swift
let providers = try await tmdbClient.movies.watchProviders(forMovie: movieId)
if let usProvider = providers.first(where: { $0.countryCode == "US" }) {
    print("Available on: \(usProvider.watchProviders.flatRate?.map(\.name) ?? [])")
}
```

### Auto-Pagination

Iterate through all pages of paginated results using AsyncSequence without
manual pagination:

```swift
// Iterate through all popular movies across all pages
for try await movie in tmdbClient.movies.allPopular() {
    print(movie.title)
    // Automatically fetches next page when needed
}

// Early break stops fetching additional pages
var count = 0
for try await movie in tmdbClient.movies.allTopRated() {
    count += 1
    if count >= 50 { break }
}

// Iterate through entire pages with metadata
for try await page in tmdbClient.movies.allPopularPages() {
    print("Page \(page.page ?? 0) of \(page.totalPages ?? 0)")
    for movie in page.results {
        print("  - \(movie.title)")
    }
}

// Opt in to prefetching: the next page is fetched concurrently as the current
// page is consumed, hiding inter-page latency on long scans.
for try await movie in tmdbClient.movies.allPopular().prefetchingNextPage() {
    print(movie.title)
}
```

`prefetchingNextPage()` is opt-in: it trades at most one extra (possibly wasted)
request on an early `break` for lower latency, and the emitted items are
identical to the default lazy sequence.

Available for all paginated endpoints across 11 services: `MovieService`
(8 endpoints), `SearchService` (7 endpoints), `TrendingService` (4 endpoints),
`TVSeriesService` (8 endpoints), `PersonService` (2 endpoints),
`DiscoverService` (2 endpoints), `ListService` (1 endpoint), `AccountService`
(8 endpoints), `GuestSessionService` (3 endpoints), `KeywordService`
(1 endpoint), and `ChangesService` (3 endpoints). Total: 47 paginated endpoints
with 94 auto-pagination methods.

### User Account Features (Authentication Required)

Account features require an authenticated `Session`. Create one with the
`AuthenticationService`, then bundle it with the account ID into an
`AuthenticatedSession`:

```swift
// Authenticate the user and create a session
let token = try await tmdbClient.authentication.requestToken()
let authURL = tmdbClient.authentication.authenticateURL(for: token)
// Present authURL to the user to approve the token, then:
let session = try await tmdbClient.authentication.createSession(withToken: token)

// Bundle the account ID and session into one value
let authenticatedSession = try await tmdbClient.account.authenticatedSession(for: session)

// Add a movie to favourites
try await tmdbClient.account.addFavourite(
    movie: movieID,
    authenticatedSession: authenticatedSession
)

// Rate a movie
try await tmdbClient.movies.addRating(8.5, toMovie: movieID, session: session)

// Get the movie watchlist
let watchlist = try await tmdbClient.account.movieWatchlist(
    authenticatedSession: authenticatedSession
)
```

## Documentation

Documentation and examples of usage can be found at
[https://adamayoung.github.io/TMDb/documentation/tmdb/](https://adamayoung.github.io/TMDb/documentation/tmdb/)

## Related Resources

* [TMDb API Documentation](https://developer.themoviedb.org/docs)
* [Swift Package Index](https://swiftpackageindex.com/adamayoung/TMDb)
* [Full API Reference](https://adamayoung.github.io/TMDb/documentation/tmdb/)
* [Getting Started Guide](https://adamayoung.github.io/TMDb/documentation/tmdb/creatingtmdbclient)
* [Image URL Generation Guide](https://adamayoung.github.io/TMDb/documentation/tmdb/generatingimageurls)

## Development

### Prerequisites

Xcode 16.0+
Swift 6.0+
Homebrew

#### Homebrew

Install [homebrew](https://brew.sh) and the following formulae

* [swiftlint](https://github.com/realm/SwiftLint)
* [swiftformat](https://github.com/nicklockwood/SwiftFormat)
* [markdownlint](https://github.com/igorshubovych/markdownlint-cli)
* [xcsift](https://github.com/ldomaradzki/xcsift)

```bash
brew install swiftlint swiftformat markdownlint xcsift
```

### Before Submitting a PR

See [CLAUDE.md](CLAUDE.md) for comprehensive development guidelines including:

* Testing requirements (unit and integration tests)
* Code style enforcement with swift-format
* DocC documentation requirements
* Complete CI check commands

Quick reference:

```bash
make format        # Auto-format code
make lint          # Check code style
make test          # Run unit tests
make ci            # Full CI validation
```

**Important**: Both unit tests AND integration tests must pass.
Integration tests require these environment variables:

* `TMDB_API_KEY` - Your TMDb API key
* `TMDB_USERNAME` - Your TMDb username
* `TMDB_PASSWORD` - Your TMDB password

Running unit tests on Linux requires [Docker](https://www.docker.com) to be running.

### Claude Code Skills

This repository ships a suite of
[Claude Code](https://claude.com/claude-code) skills (in `.claude/skills/`)
that automate the development workflow. Invoke any of them with `/<name>`.

#### Delivery pipeline

| Skill | Purpose |
| --- | --- |
| `/deliver` | Orchestrate the full pipeline from an approved plan to a ready-to-merge PR |
| `/review-plan` | Adversarially review the current plan with three independent critics and apply the consensus |
| `/implement-plan` | Implement the plan test-first (Canon TDD) until the test list is empty |
| `/review-changes` | Review the working-tree changes — one reviewer, or a parallel fan-out with adversarial verification for large diffs |
| `/capture-knowledge` | Record durable learnings (gotchas, API quirks, ADRs) into `knowledge/` |
| `/pr` | Create a pull request (`/format` → `make ci` → review → open) |
| `/watch-pr` | Watch the PR: resolve review threads, fix failing checks, optionally merge |
| `/review-pr-threads` | Resolve the PR's unresolved review threads in one sweep |
| `/fix-pr-checks` | Fix the PR's failing CI checks in one sweep |

#### Build, test & quality

The build/test rows delegate to the shared `tooling-runner` agent (pinned to
Haiku) to keep the main context lean; `/lint` and `/format` run `make`
directly.

| Skill | Purpose |
| --- | --- |
| `/build` | Compile the package for the current platform |
| `/build-for-testing` | Compile the package and all test targets without running them |
| `/test` | Run the unit tests (Swift Testing) |
| `/integration-test` | Run the live-API integration tests |
| `/lint` | Check swiftlint + swiftformat compliance |
| `/format` | Auto-format with swiftlint + swiftformat |

#### Diagnosis, TDD & docs

| Skill | Purpose |
| --- | --- |
| `/diagnose-ci-failure` | Diagnose a failing CI job and propose a fix |
| `/diagnose-integration-failure` | Diagnose a failing integration-test run and propose a fix |
| `/fix-integration-failures` | Diagnose **and** fix a failing scheduled/standalone Integration run — re-run transients, or fix real drift on a branch off `main` and open a PR |
| `/canon-tdd` | Drive test-first development (test list → failing test → pass → refactor) |
| `/document-swift` | Write DocC documentation for public API per project conventions |

Three subagents back the pipeline: `code-reviewer` (deep Swift/TMDb review,
pinned to Opus), `documentation-writer` (bulk DocC generation, pinned to
Sonnet), and `tooling-runner` (build/test execution, pinned to Haiku). The
reviewer follows the shared spec in
[`.github/CODE_REVIEW.md`](.github/CODE_REVIEW.md).

#### Self-healing weekly integration run

The live-API integration suite runs on a weekly schedule
([`.github/workflows/integration.yml`](.github/workflows/integration.yml),
Sunday 00:00 UTC). When that scheduled run fails,
[`.github/workflows/integration-failure.yml`](.github/workflows/integration-failure.yml)
invokes `/fix-integration-failures` headless: it diagnoses the failure,
re-runs a transient, or fixes real drift (a TMDb backend/shape change or a
stale assumption) on a branch off `main` and opens a **PR for review** (it
never auto-merges), then files/updates a tracking issue linking the fix. See
the skill for the headless contract and the `INTEGRATION_FIX_PR_TOKEN` secret
it needs.

### Feature Workflow (`/plan` → `/deliver`)

To build a feature end-to-end, draft and approve a plan with `/plan` (Claude
Code plan mode), then run `/deliver` to carry it all the way to a ready-to-merge
pull request. **Invoking `/deliver` is itself the plan-approval gate** — it then
runs autonomously to a single hard stop, **ready-to-merge**, and ends with a
short retrospective.

```text
/plan                    ← you draft AND approve the plan
  │
  ▼  invoking /deliver = plan approval; it then runs autonomously:
  ├─ (feature branch)
  ├─ /review-plan        3 critics harden the plan (risky/large changes only)
  ├─ /implement-plan     Canon TDD → empty test list (unit + integration green)
  ├─ /review-changes     review + fix Critical/High (test-first; auto lite/full)
  ├─ /capture-knowledge  record learnings into knowledge/
  ├─ /pr reviewed        make ci gate → open the PR (red gate? triage, not stall)
  ├─ /watch-pr           resolve threads + fix checks    ── GATE: ready-to-merge
  └─ retrospective       append to knowledge/delivery-retros.md
```

* **The one gate** — `/deliver` stops at a green, ready-to-merge PR; you perform
  the final merge (or pass `merge` to have it squash-merge once green).
* **Auto-scaled** — mechanical changes take a *lite* path (skip the 3-critic plan
  review, single-reviewer code review); risky/large ones get the *full* machinery.
* **Red-gate triage** — a CI failure unrelated to your diff (e.g. a flaky live
  integration test) is routed to `/fix-integration-failures` rather than stalling
  the delivery.

Each step is also usable on its own — e.g. `/review-changes` to review local
changes, or `/watch-pr` to babysit an existing PR.

## Acknowledgments

* [The Movie Database (TMDb)](https://www.themoviedb.org) for providing
  the comprehensive movie and TV data API
* [JustWatch](https://www.justwatch.com) for watch provider data
* All contributors who have helped improve this library

**Disclaimer**: This product uses the TMDb API but is not endorsed or
certified by TMDb.

## License

This library is licensed under the Apache License 2.0. See
[LICENSE](https://github.com/adamayoung/TMDb/blob/main/LICENSE) for details.
