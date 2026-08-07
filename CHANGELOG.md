# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- Adding a new major-version ([X.0.0]) section? Read
     knowledge/next-major.md first — it lists approved breaking changes
     waiting for exactly this bump. Ship them or consciously re-defer. -->

## [Unreleased]

### Added

- `client.v4Authentication` — TMDb v4 user authentication. Create a request
  token, send the user to the approval URL, then exchange the approved token
  for a long-lived user access token; revoke it with `deleteAccessToken(_:)`.
  Adds `V4AuthenticationService`, `V4RequestToken` and `V4AccessToken`, plus
  `MockV4AuthenticationService` and samples in `TMDbTesting`.

  These endpoints authenticate with a bearer credential and reject a v3 API
  key, so they require a client created with `TMDbClient(bearerToken:)` using
  your API Read Access Token. See the *Authenticating with the v4 API* article.

## [19.0.0] - 2026-07-29

### Added

- `Company` and `Company.Parent` now conform to `LogoImageProviding`, so
  `logoURL(using:size:)` works on them as it already does on `Network`,
  `ProductionCompany` and `WatchProvider`. Previously blocked only by
  `logoPath` being non-optional.

- `ImageService`, exposed as `TMDbClient.images`, resolving a model's image
  path to a fully qualified URL in one call:
  `try await client.images.posterURL(for: movie.posterPath, size: .width(500))`.
  It fetches TMDb's image configuration on first use and caches it for the
  client's lifetime, so callers no longer have to fetch `APIConfiguration` and
  manage that object themselves. The configuration is fetched at most once
  however many callers ask concurrently; `preload()` warms it at launch and
  `refresh()` re-fetches it, replacing the cached value only once a fresh one
  arrives (so a failed refresh keeps the previous one). A `nil` image path
  returns `nil` without making a request. `MockImageService` and
  `ImagesConfiguration.sample` ship in `TMDbTesting`.
- `TMDbStatusCode`, an enum modelling TMDb's documented numeric `status_code`
  values (with an `.unknown(Int)` fallback for codes not yet modelled).
- `TMDbErrorContext`, carrying the HTTP status code, TMDb `TMDbStatusCode`,
  server-supplied message, redacted endpoint path, and `Retry-After` delay of a
  failed request.
- `TMDbError.invalidURL(_:)` and `TMDbError.encode(_:)` cases, giving honest
  representation to failures that previously collapsed into `.badRequest` /
  `.unknown`.

### Changed

- **Breaking:** `Company.logoPath` is now `URL?` and `Company.originCountry` is
  now `String?`, and `Company.Parent.logoPath` is now `URL?`. TMDb returns
  `null` for these fields on many production companies (roughly 1 in 6 sampled
  for `logo_path`), which previously made the **entire `Company` decode throw** —
  `details(forCompany:)` failed outright for companies such as Time Warner
  (id 128) and Paramount Pictures (id 4, whose parent company has no logo).
  Migration: unwrap before use, e.g. `company.logoPath.map { ... }` or
  `if let logoPath = company.logoPath`. Note the encoded JSON now omits
  `logo_path` / `origin_country` when they are `nil`, rather than always
  emitting them.

- **Breaking:** `TMDbError`'s `badRequest`, `unauthorised`, `forbidden`,
  `notFound`, `tooManyRequests` and `serverError` cases now carry a
  `TMDbErrorContext` instead of an optional message `String`. Migration: replace
  `catch .notFound(let message)` with `catch .notFound(let context)` and read
  `context.statusMessage`; the context also exposes the HTTP status, TMDb status
  code, endpoint, and `Retry-After`.
- **Breaking:** On-device intelligence moved into a new `TMDbIntelligence`
  library product. Natural-language search
  (`TMDbClient.naturalLanguageSearch`, `NaturalLanguageSearchService`,
  `SearchPlan`, `NaturalLanguageSearchResult`,
  `NaturalLanguageSearchAvailability`, `NaturalLanguageSearchError`,
  `SearchDegradation`) and the Foundation Models tools
  (`TMDbClient.languageModelTools`, `TMDbToolbox` and the individual
  `*Tool` accessors) are no longer part of the core `TMDb` module.

  **Migrating:** add the `TMDbIntelligence` product to your target's
  dependencies and `import TMDbIntelligence` alongside `import TMDb`. No
  other code changes are required — the API is unchanged. The mock and
  samples move correspondingly from `TMDbTesting` to a new
  `TMDbIntelligenceTesting` product.

  This keeps the core `TMDb` product exactly cross-platform: every public
  symbol it vends now functions on Linux and Windows as well as Apple
  platforms. See
  [ADR-0010](knowledge/decisions/0010-tmdb-intelligence-product.md).
- **Breaking:** Model runtimes are now Swift `Duration` values instead of
  `Int` minutes — `Movie.runtime`, `TVEpisode.runtime`,
  `TVEpisodeAirDate.runtime` (`Duration?`) and `TVSeries.episodeRunTime`
  (`[Duration]?`). The JSON wire format is unchanged (integer minutes).
- **Breaking:** `DiscoverMovieFilter` and `DiscoverTVSeriesFilter`
  `runtimeMin` / `runtimeMax`, and the fluent `runtime(in:)`, now take
  `Duration` (a `ClosedRange<Duration>`) rather than `Int` minutes.
- **Breaking:** `RuntimeFormatStyle` now formats a `Duration` rather than an
  `Int`; `.runtimeStyle(...)` composes on `Duration.formatted(_:)`.

## [18.1.0] - 2026-06-18

### Added

- `AuthenticatedSession` wrapper for `AccountService`, simplifying calls
  that operate on an authenticated user session.
- Auto-pagination for the Account, GuestSession, Keyword, and Changes
  services.
- Opt-in next-page prefetch for auto-pagination.

### Changed

- `URLSessionHTTPClientAdapter` now declares explicit `Sendable`
  conformance.
- Standardised `details(...)` parameter labels to `<entity>ID` across
  services for consistency.

### Fixed

- `Retry-After` sleep is now capped to `maxDelay`.
- `RetryHTTPClient` now retries transient transport errors.
- Search queries and degenerate `Discover` filter inputs are now
  validated.
- Query items are sorted by name to produce a canonical cache key.
- Unknown `Status` and `media_type` values now decode resiliently
  instead of failing.

## [18.0.1] - 2026-06-11

### Fixed

- Missing `genre_ids` in search list items now decode as an empty array
  instead of failing.

## [18.0.0] - 2026-06-10

### Breaking

- Service protocol methods now use typed throws (`throws(TMDbError)`)
  instead of untyped `throws`. Callers that catch a generic `Error` should
  continue to work, but `do`/`catch` blocks can now bind the concrete
  `TMDbError` directly.
- `PageableListResult.page`, `PageableListResult.totalResults`, and
  `PageableListResult.totalPages` are now non-optional `Int` (previously
  `Int?`). Code that used `?? 0` or other optional handling on these
  properties can be simplified.

### Added

- `PersonService.latest()` — returns the latest person added to TMDb,
  replacing the deprecated `latestPerson()`.
- `PersonService.changes(startDate:endDate:page:)` — returns a list of
  person IDs that have changed, replacing the deprecated
  `personChanges(startDate:endDate:page:)`.

### Changed

- Internal error mapping is centralised in a new `ErrorMappingAPIClient`
  decorator that wraps the API client and maps `TMDbAPIError` values into
  the public `TMDbError` type.
- Date parsing has been modernised to use `Date.ISO8601FormatStyle` and
  `Date.ParseStrategy` in place of `DateFormatter`.

### Fixed

- Request body `.encode` failures are no longer misreported as `.network`
  errors; they now surface as the correct encoding error.
- `RetryHTTPClient` no longer retries non-idempotent (`POST`) requests,
  avoiding duplicate writes when a request times out or fails transiently.
- `NaturalLanguageSearch` now throws the documented
  `NaturalLanguageSearchError` on failure.

### Deprecated

- `PersonService.latestPerson()` — use `PersonService.latest()` instead.
- `PersonService.personChanges(startDate:endDate:page:)` — use
  `PersonService.changes(startDate:endDate:page:)` instead.

[19.0.0]: https://github.com/adamayoung/TMDb/releases/tag/19.0.0
[18.1.0]: https://github.com/adamayoung/TMDb/releases/tag/18.1.0
[18.0.1]: https://github.com/adamayoung/TMDb/releases/tag/18.0.1
[18.0.0]: https://github.com/adamayoung/TMDb/releases/tag/18.0.0
