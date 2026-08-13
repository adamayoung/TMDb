# ADR-0008: Percent-encode user-supplied URL path segments with the RFC 3986 unreserved set

- **Status:** Accepted (amended in part by [0022](0022-reject-traversal-capable-path-segments.md))
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
- To find all sites needing this, enumerate by **type** — every request
  initialiser taking a `String` that reaches `path` — not by text pattern. The
  grep this ADR originally prescribed (`path = "/…\(stringVar)"`) is single-line
  and **missed three sites** whose `let path =` sat on its own line: the sweep
  recorded four sites and there were eight. The three
  `GuestSessionRated*Request` builders went unencoded until issue #421.
  `Int` IDs need nothing.
- Encoding alone does **not** prevent path traversal end-to-end. TMDb's edge
  percent-decodes the path and then resolves dot-segments, so `%2F..%2F..` reaches
  another endpoint exactly as `/../..` does — measured, see
  [`../tmdb-api-notes.md`](../tmdb-api-notes.md) → *Path handling at the edge*.
  That residual is closed not by this ADR but by
  [ADR-0022](0022-reject-traversal-capable-path-segments.md), which refuses such a
  request at the `TMDbAPIClient` choke point. What this ADR's encoding still buys
  is the *client-side* break-out: a raw `?` would otherwise be split by
  `URL(string:)` into a query merged ahead of `api_key`.

## Alternatives considered

- **`CharacterSet.urlPathAllowed.subtracting("/")`** — rejected. `.urlPathAllowed`
  permits the sub-delimiters (`= & ; : @ + , $ ! * ' ( )`), leaving them literal.
  Harmless for the locked host, but it forces a "which sub-delimiters matter?"
  analysis on every reviewer; the unreserved-only set sidesteps that entirely.
- **Encoding centrally in `TMDbAPIClient`** — rejected. The path already contains
  `/` separators that must *not* be encoded, so the client can't blanket-encode;
  encoding the variable segment at the interpolation site is the correct seam.
  (Note that *validating* centrally is a different proposition, and is what
  [ADR-0022](0022-reject-traversal-capable-path-segments.md) later does — the
  client cannot re-encode a path, but it can refuse one.)
