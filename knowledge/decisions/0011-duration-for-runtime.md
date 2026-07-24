# ADR-0011: Represent runtimes as `Duration`, bridging integer minutes at the wire boundary

- **Status:** Accepted
- **Date:** 2026-07-24
- **Deciders:** Adam Young (with Claude Code)

## Context

TMDb model runtimes were exposed as bare `Int` values documented as "minutes"
(`Movie.runtime`, `TVEpisode.runtime`, `TVEpisodeAirDate.runtime`,
`TVSeries.episodeRunTime`), alongside the request-side runtime filters
(`DiscoverMovieFilter` / `DiscoverTVSeriesFilter` `runtimeMin`/`runtimeMax`, the
fluent `runtime(in:)`) and the `RuntimeFormatStyle` that rendered those minutes.
A bare `Int` carries no unit in the type — a caller cannot tell minutes from
seconds without reading the doc comment, and cannot use the value with
duration-aware APIs.

Constraints:

- The TMDb API represents runtime as an **integer number of minutes** on both
  response bodies and the `with_runtime.gte` / `with_runtime.lte` query
  parameters. The wire format must not change.
- `Duration` is available on every supported platform (iOS 16+, macOS 13+,
  watchOS 9+, tvOS 16+, visionOS 1+, Linux, Windows) and conforms to `Codable`,
  `Equatable`, `Hashable`, `Sendable`, and `Comparable`.
- `Duration`'s own `Codable` representation is a `(seconds, attoseconds)` pair —
  **not** an integer of minutes — so naively changing the property type would
  silently break the wire format.

## Decision

Expose runtimes as `Duration` at the public surface while keeping integer minutes
on the wire.

- **Response models** store the raw minute count in a
  `private let …InMinutes: Int?` and expose a computed `public var runtime:
  Duration?` (`[Duration]?` for `TVSeries.episodeRunTime`). The existing custom
  `init(from:)` decodes the `Int`; the **synthesized** `encode(to:)` re-emits the
  `Int`. The Codable wire format therefore stays integer minutes on both decode
  and encode, with no hand-written encode to keep in sync. `CodingKeys` keep the
  camelCase rawValue that the `.convertFromSnakeCase` decoder expects (e.g.
  `episodeRunTimeInMinutes = "episodeRunTime"`, not `"episode_run_time"`).
- **Request filters** hold `Duration?` directly (they are never decoded from the
  API); the request builders convert to integer minutes when setting the query
  items.
- A single internal `RuntimeMinutes` enum performs the minutes⇄`Duration`
  conversion. It is deliberately **not** a public `Duration` extension (a future
  stdlib `Duration.minutes` would collide) and **not** a
  `KeyedDecodingContainer` extension (keep those generic; localise the domain
  conversion).
- `RuntimeFormatStyle.FormatInput` becomes `Duration`, so
  `movie.runtime?.formatted(.runtimeStyle(…))` keeps working.

## Consequences

- **Breaking public-API change:** runtime property types, memberwise-initialiser
  signatures, and `RuntimeFormatStyle`'s input all change from `Int` to
  `Duration` — warranting a major version bump (19.0.0).
- The type now carries its unit; runtimes compose with `Comparable`, arithmetic,
  and Foundation's duration formatting.
- Truncation to whole minutes happens at the wire boundary (a caller-supplied
  `.seconds(90)` stores and encodes as 1 minute), matching the API's minute
  granularity — documented on the models and the format style.
- Guarded by per-model encode round-trip tests asserting the integer-minute wire
  format.

## Alternatives considered

- **Store `Duration` directly and hand-write `encode(to:)` per model.** Rejected:
  `Movie` alone has ~30 properties, and a forgotten field in a hand-written
  encode is silent data loss. The stored-minutes / computed-`Duration` approach
  keeps encode synthesized and correct for free.
- **A public `Duration.minutes(_:)` convenience** for construction ergonomics.
  Rejected: extending a stdlib type with API Apple may later add risks a
  source-breaking collision. Callers use `.seconds(minutes * 60)`.
- **Leave the request-side filters as `Int`.** Rejected: full type consistency
  across the runtime surface was preferred; only the NaturalLanguageSearch
  internal slot (`SearchPlan.runtimeMaxMinutes` and `ResolvedInputs`) stays
  `Int`, converting to `Duration` at the filter-construction seam.
