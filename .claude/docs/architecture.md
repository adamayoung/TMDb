# Architecture

> Topic doc referenced from [`CLAUDE.md`](../../CLAUDE.md). Read before
> changing services, networking, models, the intelligence products, or
> adding a feature.

## Service-Based Design

The library uses protocol-based services with dependency injection.
`TMDbClient` is the main facade exposing the following service properties:

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
library product** (see [ADR-0010](../../knowledge/decisions/0010-tmdb-intelligence-product.md)),
so the core `TMDb` product carries no API that cannot function on Linux.
`TMDbIntelligence` depends on `TMDb` and adds two `TMDbClient`
extensions, both **Apple-platforms only**:

- `naturalLanguageSearch` — gated by `#if canImport(NaturalLanguage)`. It
  interprets free-text queries on-device with a deterministic planner (a
  rule-based intent classifier plus `NLTagger` person-name extraction) and, on
  capable devices, an optional `FoundationModelsSearchPlanGenerator` fallback
  for fuzzier prompts — degrading to a plain multi-search where neither is
  available. That fallback is additionally gated
  `&& !os(tvOS) && !os(watchOS)`: Apple ships no on-device system language
  model on those two platforms, so they are always deterministic.
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

## Networking Layer

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
[ADR-0001](../../knowledge/decisions/0001-error-mapping-api-client.md).

## Language Model Tools (Apple-only)

`TMDbToolbox` (`Sources/TMDbIntelligence/LanguageModelTools/`) wraps the services
as FoundationModels `Tool`s so TMDb can back a conversational movie assistant
through a `LanguageModelSession`. It is gated by
`#if canImport(FoundationModels) && !os(tvOS)` and annotated
`@available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)`.

The exposed tools are `search`, `movieDetails`, `movieCredits`,
`tvSeriesDetails`, `personFilmography`, `trending`, `watchProviders`, and
`discoverMovies`. They
are reachable from `TMDbClient` via `languageModelTools` (shorthand for
`TMDbToolbox(client:).all`) and individual `*Tool` accessors (`searchTool`,
`movieDetailsTool`, …). Each tool returns compact text whose every line leads
with the relevant TMDb `id`, letting the model chain calls — search a title,
then fetch its details or watch providers.

## Adding New Features

Structural pattern for a new service:

1. Protocol in `Domain/Services/<ServiceName>/`; implementation prefixed `TMDb`
   (e.g. `TMDbMovieService`).
2. Models in `Domain/Models/` conform to `Codable`, `Equatable`, `Hashable`,
   `Sendable`.
3. Construct and expose the service in `TMDbClient.swift`'s private init.
   `TMDbFactory` vends the shared plumbing — `makeServiceDependencies`,
   `httpClient(wrapping:)`, and the three API-client factories (`apiClient`,
   `authAPIClient`, `v4APIClient`) — but services are **not** registered there.
4. Unit tests with JSON fixtures (`Tests/TMDbTests/Resources/`) **and** integration
   tests (`Tests/TMDbIntegrationTests/`).

Drive it test-first with `canon-tdd`; keep DocC + `README.md` in sync via
`/document-swift`. A new method on an existing service follows the same testing
and documentation rules.
