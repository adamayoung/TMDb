# ADR-0007: Document existing response caching instead of building a custom on-disk cache

- **Status:** Accepted
- **Date:** 2026-06-24
- **Deciders:** Adam Young, Claude

## Context

A feature request asked for an opt-in, configurable, TTL'd, lightweight on-disk
cache so repeated API requests avoid repeated HTTP calls. The premise was that no
on-disk caching existed.

Investigation showed the capability already exists on Apple platforms:

- The default `URLSession` adapter is configured in
  `TMDbFactory.urlSessionConfiguration()` with `.useProtocolCachePolicy` and a
  `URLCache` of 50 MB memory / 1 GB disk (`TMDbFactory.urlCache()`). This is
  gated `#if !canImport(FoundationNetworking)`, so it is **Apple-platforms-only**
  (absent on Linux/Windows).
- TMDb serves `Cache-Control: public, max-age=<seconds>` and a weak `ETag` on
  every GET endpoint (see `tmdb-api-notes.md` → *HTTP caching*).

Together these already satisfy the request on Apple platforms: responses are
cached on disk, persist across launches, expire per-resource via the API's own
`max-age`, and are revalidated with `ETag` (a `304` reuses the cached body). A
separate opt-in **in-memory** layer also already exists — `CacheHTTPClient` /
`CacheConfiguration`, enabled via `TMDbConfiguration(cache:)`.

## Decision

We will **not** build a custom on-disk cache (SwiftData / file / `Codable`).
Instead we document the two caching layers that already exist — the default
on-disk `URLCache` and the opt-in in-memory `CacheConfiguration` — including how
they interact and how to tune or disable the `URLCache` (supply a custom
`HTTPClient` backed by your own `URLSession`). Delivered as a DocC HowTo
(`CachingResponses.md`) plus doc-comment and README clarifications.

## Consequences

- No new code or public API surface to maintain; no new dependency.
- Users get persistent on-disk caching with per-resource TTL and `ETag`
  revalidation — semantics a hand-rolled fixed-TTL cache would not match.
- **Gap:** on Linux/Windows no `URLCache` is installed, so only the in-memory
  layer caches there. Deemed out of scope (the request targeted Apple platforms).
  If cross-platform persistent caching is later needed, revisit this ADR — a
  custom decorator would be the place to add it.

## Alternatives considered

- **Custom file/`Codable`/SwiftData on-disk decorator.** Rejected: largely
  duplicates `URLCache` on Apple platforms and is *inferior* — a single fixed TTL
  instead of per-resource `max-age`, and no conditional (`ETag`) revalidation. Its
  only real value is Linux/Windows persistence, which was out of scope.
- **Expose a config knob to size/disable `URLCache`.** Deferred: the existing
  custom-`HTTPClient` escape hatch already covers tuning/disabling; a dedicated
  knob can be added later if demand appears.
</content>
