# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [19.0.0] - 2026-07-24

### Added

- `TMDbStatusCode`, an enum modelling TMDb's documented numeric `status_code`
  values (with an `.unknown(Int)` fallback for codes not yet modelled).
- `TMDbErrorContext`, carrying the HTTP status code, TMDb `TMDbStatusCode`,
  server-supplied message, redacted endpoint path, and `Retry-After` delay of a
  failed request.
- `TMDbError.invalidURL(_:)` and `TMDbError.encode(_:)` cases, giving honest
  representation to failures that previously collapsed into `.badRequest` /
  `.unknown`.

### Changed

- **Breaking:** `TMDbError`'s `badRequest`, `unauthorised`, `forbidden`,
  `notFound`, `tooManyRequests` and `serverError` cases now carry a
  `TMDbErrorContext` instead of an optional message `String`. Migration: replace
  `catch .notFound(let message)` with `catch .notFound(let context)` and read
  `context.statusMessage`; the context also exposes the HTTP status, TMDb status
  code, endpoint, and `Retry-After`.
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

[18.1.0]: https://github.com/adamayoung/TMDb/releases/tag/18.1.0
[18.0.1]: https://github.com/adamayoung/TMDb/releases/tag/18.0.1
[18.0.0]: https://github.com/adamayoung/TMDb/releases/tag/18.0.0
