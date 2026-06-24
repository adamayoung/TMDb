# ADR-0007: Percent-encode user-supplied URL path segments with the RFC 3986 unreserved set

- **Status:** Accepted
- **Date:** 2026-06-24
- **Deciders:** Adam Young (security-review-driven delivery)

## Context

A handful of request builders interpolate a caller-supplied `String` directly
into the request path, e.g. `"/find/\(externalID)"`. Unlike query items (which
go through `URLComponents`/`URLQueryItem` and are percent-encoded), a raw string
in the path is parsed by `URL(string:)` in `TMDbAPIClient`, so characters like
`?` and `#` let the value break out of its path segment and inject a query string
or fragment. There were **four** such sites — `FindByIDRequest`,
`CreditRequest`, `TVEpisodeGroupRequest`, `ReviewRequest` (all take `String`
IDs); every other path uses `Int` IDs, which are injection-safe.

The fix needs a single reusable encoder. The open question was *which* allowed
character set to pass to `addingPercentEncoding(withAllowedCharacters:)`.

## Decision

We will percent-encode a path segment against the **RFC 3986 *unreserved* set**
only — `CharacterSet.alphanumerics` plus `-._~` — via a `String`
`urlPathSegmentEncoded` helper, and apply it at every site where a `String` is
interpolated into a request path.

## Consequences

- Every character outside the unreserved set (including `/`, `?`, `#`, `=`, `&`,
  spaces, `%` itself) is percent-encoded, so a segment is maximally inert and
  trivially reviewable — "only unreserved survives" needs no case analysis.
- No legitimate identifier is altered: real TMDb IDs (IMDb `tt…`, hex
  credit/episode-group/review IDs, Wikidata `Q…`) are already unreserved, so the
  encoded form is byte-identical to the input.
- To find all sites needing this, grep for `path = "/…\(stringVar)"` — only
  `String`-typed interpolations are at risk; `Int` IDs need nothing.
- End-to-end caveat (not a regression): `TMDbAPIClient.urlFromPath` round-trips
  the path through `URLComponents`, which re-encodes `?`/`#` but decodes `%2F`
  back to a literal `/`. Query/fragment injection is fully prevented; an injected
  `/` only adds path segments within the force-locked `api.themoviedb.org` host
  (path-only, no SSRF). See `knowledge/gotchas.md` → *URLComponents path
  round-trip*.

## Alternatives considered

- **`CharacterSet.urlPathAllowed.subtracting("/")`** — rejected. `.urlPathAllowed`
  permits the sub-delimiters (`= & ; : @ + , $ ! * ' ( )`), leaving them literal.
  Harmless for the locked host, but it forces a "which sub-delimiters matter?"
  analysis on every reviewer; the unreserved-only set sidesteps that entirely.
- **Encoding centrally in `TMDbAPIClient`** — rejected. The path already contains
  `/` separators that must *not* be encoded, so the client can't blanket-encode;
  encoding the variable segment at the interpolation site is the correct seam.
