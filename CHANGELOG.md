# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- Adding a new major-version ([X.0.0]) section? Read
     knowledge/next-major.md first — it lists approved breaking changes
     waiting for exactly this bump. Ship them or consciously re-defer. -->

## [20.0.0]

### Added

- `TMDbError.cancelled` — task cancellation is now its own error case instead of
  being reported as a network failure. See the *Handling Errors* article.

- `client.v4Lists` — TMDb v4 lists. Unlike the v3 `client.lists`, a v4 list
  holds **movies and TV series together**, can be private, and can carry a
  comment on each item. All eleven operations are covered: reading a list and
  its items, checking whether an item is present, listing an account's lists,
  creating, updating, adding, commenting, removing, clearing and deleting.

  Reading a public list needs no user credential; everything else takes an
  access token from `client.v4Authentication`. Adds `V4ListService` and its
  models, plus `MockV4ListService` and samples in `TMDbTesting`. See the
  *Authenticating with the v4 API* article.

- `NaturalLanguageSearchError.searchFailed(TMDbError)` (in `TMDbIntelligence`) —
  a TMDb request that fails while a natural-language search is being carried out
  now reports as itself, carrying the underlying `TMDbError`. Unlike
  `.planningFailed`, it compares by cause, so a rate limit can be told from a
  network drop.

- **Breaking:** `SearchDegradation` (in `TMDbIntelligence`) gains an
  `.other(String)` case. This only affects you if you switch **exhaustively** over
  it — add an `.other` branch, or a `default`.

  It is a reserved growth slot carrying a stable identifier. From here on, new
  kinds of degradation ship as `.other` in a **minor** release rather than as new
  cases, so a `switch` written against 20.0.0 keeps compiling. Render `.other` the
  way you would render a degradation you do not recognise.

- `NaturalLanguageSearchAvailability.Reason.unknown` (in `TMDbIntelligence`) — an
  availability reason or state added by a future OS now surfaces here. It was
  previously reported as `.modelNotReady` (an unrecognised unavailability reason)
  or `.unsupportedOS` (an unrecognised availability state), so a caller would
  either wait for a model download that was never pending, or tell the user to
  upgrade an OS that is already current.

### Fixed

- **Breaking:** `TMDbError.network(_:)` no longer hands your API key to whatever
  you log the error to. A `URLSession` failure carries the whole URL of the
  request that failed in its `NSError` `userInfo`, and for a client created with
  `TMDbClient(apiKey:)` that URL contains the `api_key` query item — so an
  ordinary timeout, DNS failure or dropped connection put the credential into
  consumer logs, crash reports and analytics breadcrumbs. The library already
  scrubbed token-bearing *path* segments from `TMDbErrorContext.endpointPath`;
  it now covers the failing URL too.

  The value of any credential-bearing query item (`api_key`, `session_id`,
  `request_token`, `guest_session_id`), and any guest session id or account id
  in the path, is replaced with `REDACTED`. The attached error keeps its
  `domain`, `code` and `localizedDescription`, so branching on those is
  unaffected, and on Apple platforms it still bridges to `URLError`.

  Breaking, and silently so — nothing stops compiling. The other diagnostic
  `userInfo` entries (`NSUnderlyingError` and the related-task keys) are
  **dropped** rather than scrubbed, because they can nest a second copy of the
  same URL, so code reading them will now find them absent. An error with
  nothing to redact — including one thrown by your own `HTTPClient` — is
  attached exactly as raised, so its concrete type still matches in a `catch`.

  The v4 bearer token itself was never at risk — it travels as a header, never
  in a URL. A `session_id` was: a user-scoped v3 call carries it as a query item
  whichever way the client was created, so `TMDbClient(bearerToken:)` leaked one
  too wherever you passed a session id.

- A type conforming to one of the service protocols itself, rather than using
  `TMDbTesting`'s mocks, no longer risks an infinite recursion. 54 protocol
  conveniences shared their requirement's signature, differing only by default
  argument values — which are not part of a signature for witness matching, so
  each convenience *was* that requirement's default implementation. A conformer
  that omitted the requirement compiled, then recursed until the stack
  overflowed, where a compile error was intended. Each is replaced by explicit
  overloads covering every combination of the parameters it can drop (306 in
  all), so **no call site needs to change**. This completes the sweep begun
  earlier in this release, which fixed the 37 single-default sites (see below).

  One caveat, and it is not a call-site one: an *unapplied* reference to these
  methods — `let fetch = client.movies.popular` — now has several candidates
  where it had one, so it may need an explicit function-type annotation.

  Also removes a `MovieService.releaseDates(forMovie:)` convenience that
  duplicated its own requirement exactly and called itself. Its signature was
  identical, so callers are unaffected and now reach the requirement.

- **Breaking:** cancelling a task no longer surfaces as `TMDbError.network`. A dismissed
  SwiftUI `.task {}` looked like an outage, `withThrowingTaskGroup` sibling
  cancellation produced N phantom network errors, "retry on network error" logic
  re-ran work the user had cancelled, and telemetry counted cancellations as
  outages. Cancellation the library observes now throws `TMDbError.cancelled`,
  and is never retried.

  `URLSession.invalidateAndCancel()` and app teardown raise the same underlying
  code while the caller's task is alive; those remain `TMDbError.network`, since
  they are real failures rather than the caller changing their mind.

- **Breaking:** `client.images` no longer blocks a cancelled caller. A caller
  waiting on the shared configuration fetch was dragged along to the end of it —
  up to ~30s, or minutes with retry enabled. It now abandons its wait and throws
  `TMDbError.cancelled` where it previously returned the fetched value; the
  shared fetch still runs on and delivers to every other caller. A caller served
  from the cache never suspends and is unaffected.

- **Breaking:** a cancelled natural-language search (`TMDbIntelligence`) no
  longer issues three fresh searches, and throws
  `NaturalLanguageSearchError.cancelled` where it previously returned those
  fallback results. Cancellation was wrapped as
  `NaturalLanguageSearchError.planningFailed`, which is eligible for the
  literal-search fallback, so the library did the very work the caller had
  cancelled.

- **Breaking:** a TMDb request failure during a natural-language search
  (`TMDbIntelligence`) no longer reports as
  `NaturalLanguageSearchError.planningFailed`, whose description claims the prompt
  could not be interpreted. A rate limit or network drop — during plan execution
  **or** during the literal-search fallback — now throws
  `NaturalLanguageSearchError.searchFailed` carrying the real `TMDbError`, so a
  caller branching on TMDb's 429 can see it. If you branch on `.planningFailed`
  to show "couldn't interpret that", add a `.searchFailed` branch. A
  `.searchFailed` is never rescued by the literal-search fallback, which would
  otherwise retry against the API that just failed.

### Changed

- **Breaking:** the minimum Swift toolchain is now **6.1** (Xcode 16.3), raised
  from 6.0. `Package.swift` declares `// swift-tools-version:6.1`, so SwiftPM
  running an older toolchain will not resolve this version — rather than
  failing, it silently falls back to the newest release still on tools-version
  6.0, so a dependency on `from: "19.0.0"` stays pinned to 19.x with no
  diagnostic. Upgrade to Xcode 16.3+, or a Swift 6.1+ toolchain on Linux, to
  take 20.0.0.

- **Breaking:** `TMDbError` gains a `.cancelled` case, and
  `NaturalLanguageSearchError` (in `TMDbIntelligence`) gains one too. This only
  affects you if you switch **exhaustively** over either — add a `.cancelled`
  branch, or a `default`.

- **Breaking:** `SearchPlan.Intent`, `SearchPlan.ListKind` and
  `NaturalLanguageSearchAvailability.Reason` (all in `TMDbIntelligence`) change
  from enums to structs with static members. These vocabularies grow as the
  planner learns new requests and as Apple and TMDb add their own, and as public
  enums each addition broke every exhaustive `switch` downstream. As structs they
  can grow in a **minor** release instead.

  Almost nothing changes at the call site: construction (`SearchPlan(intent:
  .find)`), `==`, `if case .find = plan.intent`, and a `switch` with a `default:`
  all compile unchanged, and `Hashable` is **retained** so `Set` and dictionary
  use is unaffected. What no longer compiles is an **exhaustive** `switch` — add
  a `default:`. Should you have written your own `Hashable` or
  `CustomStringConvertible` conformance for one of these, remove it: they now
  conform themselves.

  `SearchPlan.MediaType` and `SearchPlan.RelativeDate` are deliberately unchanged.
  `MediaType` is bounded by this feature's **result surface** rather than by TMDb's
  media taxonomy — `NaturalLanguageSearchResult` exposes exactly `movies`,
  `tvSeries` and `people`, so a fourth media type could not be returned without a
  larger change than adding a member. (TMDb itself models more, including
  collections and TV episodes; should the result surface ever grow, `MediaType`
  should be converted too.) `RelativeDate` carries payloads the executor computes
  year bounds from, where a catch-all member would mean nothing.

- **Breaking:** a cancelled auto-pagination scan now throws `TMDbError.cancelled`
  rather than `CancellationError`, and stops at the next element even while
  items from the current page are still buffered. Replace
  `catch is CancellationError` with `catch TMDbError.cancelled`. This applies
  however the sequence was built: errors *from* a `pageFetcher` you supplied
  keep that fetcher's own error type, but cancellation the sequence itself
  observes always throws `TMDbError.cancelled`.
- **Breaking:** `ShowType` gains an `.unknown` case, and a `media_type` this
  library does not model now decodes to it instead of throwing — matching
  `CreditType`, `Status`, `VideoType`, `ReleaseType`, `VideoSize`, `Gender` and
  `TMDbStatusCode`. This only affects you if you switch exhaustively over a
  `ShowType` — add an `.unknown` branch, or a `default`. `.unknown` is
  **decode-only**: passing it to `v4Lists.itemStatus`, `addItems`,
  `updateItems` or `removeItems` throws `TMDbError.badRequest` rather than
  sending a media type TMDb cannot interpret.

- **Breaking:** `TVSeriesDetailsResponse.lists` changes from
  `MediaPageableList` to `MediaListSummaryPageableList`. `/tv/{id}/lists`
  returns list summaries, not media rows, so every row failed to decode and was
  silently dropped — `tvSeries.details(appending: .lists)` has always returned
  an empty array. Any code reading it was reading nothing. `MovieDetailsResponse`
  and the standalone `tvSeries.lists(forTVSeries:)` already used the correct
  type.

- Decode tolerance is now one policy: an element whose `media_type` this library
  does not model is skipped from its containing array and counted, and **every
  other decode failure throws**. Previously `PageableListResult` and `V4List`
  swallowed *any* undecodable element, unbounded and unreported, so a decoder
  regression showed up as a quietly short page with no signal at all — while
  `MediaList`, `PersonCombinedCredits` and `PersonListItem.knownFor` did the
  opposite and failed wholesale on one foreign entry. Those three are now
  tolerant too. **This is behavioural, not source-breaking** — but a response
  that previously came back quietly short may now throw `TMDbError.decode`. See
  ADR-0019.

- **Breaking:** `CreditType` gains `.creator` and `.unknown` cases, and an
  unrecognised `credit_type` now decodes to `.unknown` instead of throwing.
  TMDb returns `"creator"` for a TV series creator — so
  `credits.details(forCredit:)` failed outright with `TMDbError.decode` for
  every such credit, including Steven Spielberg's on *Invasion America*. This
  only affects you if you switch exhaustively over `CreditType` — add
  `.creator` and `.unknown` branches, or a `default`. `CreditType` now matches
  the tolerance every other decoded enum in the library already has
  (`Status`, `VideoType`, `ReleaseType`, `VideoSize`, `Gender`,
  `TMDbStatusCode`).

- **Breaking:** `HTTPRequest.Method` gains a `.put` case. v4 list update is a
  PUT and there is no other way to express it. This only affects you if you
  supply your own `HTTPClient` **and** switch exhaustively over the method — add
  a `.put` branch, or a `default`.

- **Breaking:** `Network.homepage` is renamed to `homepageURL`, matching
  `Company.homepageURL`. The two models describe the same kind of thing and
  disagreed only by accident. The JSON key is unchanged, so only Swift call
  sites need updating: `network.homepage` becomes `network.homepageURL`.

- `HTTPRequest` gains `isUserSpecific`. It is `true` when a request required a
  specific user's credential — a v4 access token, a v3 `session_id`, or a guest
  session. **A custom `HTTPClient` must not cache, store or log such a
  response.** This is source-compatible: it is a new property with a defaulted
  trailing initialiser parameter, so nothing needs changing to compile — but a
  custom `HTTPClient` should be updated to honour it.

- A request that carries its own `Authorization` header now suppresses the
  client credential entirely, rather than having it overwritten. Without this a
  per-call user token never reached the wire, and a user-scoped v4 read returned
  the *application owner's* data.

- Responses requiring a user's credential are no longer written to, or served
  from, either cache — the opt-in in-memory cache or the always-on on-disk
  `URLCache`. This changes behaviour for v3 session and guest-session requests,
  which were previously stored on disk. Responses authenticated with an
  application bearer token are unaffected and remain cached.

### Fixed

- `lists.details(forList:)` and `lists.items(forList:)` no longer throw for a
  list containing a TV series — which is most real lists. TMDb sends a list's TV
  rows with `name`, `original_name` and `first_air_date` and **no** `title`,
  `original_title` or `release_date`, while `MediaListItem` required the
  movie-shaped keys. Both key pairs now decode into `title`, `originalTitle` and
  `releaseDate`, as `CollectionListItem` already did, so callers never branch on
  `mediaType`.

- `PersonListItem.knownFor` no longer removes the whole person from a page when
  one `known_for` entry has a `media_type` this library does not model. Only the
  entry is skipped.

- `credits.details(forCredit:)` no longer fails for a credit attached to an
  unreleased movie or an unaired TV series. TMDb reports an absent date as an
  empty string, which the day-precision date parser rejected, so the whole call
  threw `TMDbError.decode`. `CreditMovie.releaseDate` and
  `CreditTVSeries.firstAirDate` now decode an empty string as `nil`, matching
  every sibling model.

- 37 convenience methods on the public service protocols no longer share a
  signature with the requirement they forward to. A default argument value is
  not part of a signature for witness matching, so each of these *was* its
  requirement's default implementation — a type conforming to, say,
  `MovieService` without implementing `details(forMovie:language:)` compiled,
  then recursed until the stack overflowed. Each convenience now drops the
  parameter instead of defaulting it (`details(forMovie:)` forwarding to
  `details(forMovie:language:)`), so omitting a requirement is a compile error
  again.

  **Calling code is unaffected** — `details(forMovie: 550)` and
  `details(forMovie: 550, language: "en")` both still compile. The break is
  narrow and deliberate: a conformer that relied on the accidental default now
  fails to build, which is the point.

  Affected: `AccountService`, `AuthenticationService`, `ConfigurationService`,
  `FindService`, `GenreService`, `MovieService`, `PersonService`,
  `SearchService`, `TVEpisodeService`, `TVSeasonService`, `TVSeriesService`,
  `WatchProviderService`. The remaining 54 conveniences, which defaulted two or
  more parameters each, are fixed by the entry above — in this same release, and
  without any call-site change.

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
