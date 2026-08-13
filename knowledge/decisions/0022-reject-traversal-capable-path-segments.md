# ADR-0022: Reject traversal-capable path segments at the `TMDbAPIClient` choke point

- **Status:** Accepted (in 20.0.0, unreleased)
- **Date:** 2026-08-13
- **Deciders:** Adam Young (issue #421 delivery)

## Context

[ADR-0008](0008-percent-encode-url-path-segments.md) percent-encodes a
caller-supplied `String` before interpolating it into a request path, on the
premise that an encoded `%2F` is inert. Issue #421 reported that
`TMDbAPIClient` then undid the encoding by round-tripping through the decoding
`URLComponents.path` getter, and proposed composing via `percentEncodedPath`
instead.

Probing the live API showed the reported bug is real but the proposed fix is
**not sufficient**. TMDb's edge percent-decodes the path *and then* resolves
dot-segments, so the encoded form traverses exactly as the raw one does:

| Path sent to `api.themoviedb.org` | Result |
| --- | --- |
| `/3/credit/abcdefdoesnotexist` | `404` |
| `/3/credit/x/../../movie/550` | `200`, movie payload |
| `/3/credit/x%2F..%2F..%2Fmovie%2F550` | `200`, movie payload |
| `/3/credit/x%252F..` (double-encoded) | `404` |

The full measurement, including the negative results, is in
[`../tmdb-api-notes.md`](../tmdb-api-notes.md) → *Path handling at the edge*.
Encoding cannot close the class, because the peer undoes it. A request whose
path can resolve elsewhere must not be sent at all.

Two further facts constrained where the check could live. The eight sites that
interpolate a caller-supplied `String` into a path are spread across five
services, and ADR-0008's own sweep had already missed three of them. And a
segment can break out of the path *before* any request builder sees a problem:
a raw `?` is split by `URL(string:)` into the query component, which the client
then merged **ahead** of `api_key`.

## Decision

We will validate the request path **once, at `TMDbAPIClient.buildHTTPRequest`** —
the single seam every v3 and v4 request passes through — and throw rather than
send anything that fails.

The path is parsed once and that same parsed value is validated and dispatched.
A path is refused when it carries a query, fragment, scheme, host, userinfo or
port, or when any segment, after one percent-decode, is a dot-segment, contains
a separator, still contains a `%`, or contains a control character. Comparison
is per Unicode **scalar**, because that is the peer's unit.

The failure is reported as the **existing** `TMDbError.invalidURL`.

## Consequences

- The guard cannot be forgotten by a future request builder, which is the
  property the per-site encoder could not offer — and did not deliver, since
  three sites went unencoded for two months.
- Encoding at the interpolation site (ADR-0008) **stays**. It is still what keeps
  a `?` from splitting client-side; this ADR is the second layer, not a
  replacement.
- **Scope is narrow, deliberately.** This covers every request `TMDbAPIClient`
  sends. It does **not** cover `AuthenticateURLBuilder` or
  `V4AuthenticateURLBuilder`, which compose a browser-facing
  `www.themoviedb.org` URL for the caller to open. Those carry no `api_key` and
  no user token, and a security review confirmed they are outside issue #421's
  class. A third URL builder added outside the client would likewise be outside
  this guard — that is the limit of the guarantee.
- **Observable behaviour change:** an identifier that previously reached TMDb and
  came back `notFound` may now be refused locally as `invalidURL`. A pasted URL
  in a search field is the realistic case. No legitimate TMDb identifier is
  affected, but `FindByIDRequest` carries third-party ids that TMDb does not
  control.
- The `percentEncodedPath` setter traps on a badly-encoded string, so the
  ordering is load-bearing: malformed escapes are rejected *before* it runs.
  See [`../gotchas.md`](../gotchas.md) → *`URLComponents.percentEncodedPath`'s
  setter traps*.

## Alternatives considered

- **Compose via `percentEncodedPath` and stop there** (issue #421's proposal) —
  rejected on measurement: the encoded payload reaches the same endpoint. It is
  kept as part of this change, but as correct layering, not as the defence.
- **Validate at each public service boundary**, per `CLAUDE.md`'s "validate
  inputs at public API boundaries" — rejected as the *primary* seam. It is eight
  places instead of one, and its failure mode is silence when a ninth is added.
  Empty-string validation still lives there, because that check is about the
  caller's intent rather than the wire.
- **A dedicated `TMDbError` case** (e.g. `unsafePath`) — rejected on the merits,
  not on compatibility. The `20.0.0` window is open, so a new case *was*
  available; but the failure genuinely is "a URL could not be safely constructed
  from this value", and a second case would split one concept across two arms
  that callers would have to handle identically.
- **Sanitising instead of rejecting** (strip the dot-segments, re-encode) —
  rejected. Silently fetching a *different* resource than the caller named is a
  worse outcome than an error, and `URL.standardized` would resolve dot-segments
  rather than refuse them.
