# 17. A third `TMDbAPIClient` instance for the v4 API

Date: 2026-08-07

## Status

Accepted

## Context

TMDb's v4 API is a separate surface from v3: a different base URL
(`https://api.themoviedb.org/4`), different authentication semantics, and
different response shapes. Issue #394 adds v4 list support, which requires
reaching that surface for the first time.

`TMDbAPIClient` already takes its `baseURL` as an init parameter and makes no
assumption about `/3` — the version lives only in `URL.tmdbAPIBase`. And
`TMDbFactory` already constructs **two** differently-configured clients over
one shared HTTP stack: `apiClient` and `authAPIClient`, which differ solely in
their serialiser (`authAPIClient` decodes the
`yyyy-MM-dd HH:mm:ss UTC` timestamps that the session endpoints return).

So the question was not *whether* the seams existed, but which of them to use.

## Decision

Add a **third `TMDbAPIClient` instance**, `v4APIClient`, configured with the v4
base URL and carried as a new field on `TMDbServiceDependencies`. It sits
behind the same `APIClient` abstraction, is wrapped by the same
`ErrorMappingAPIClient` (per [ADR-0001](0001-error-mapping-api-client.md)), and
shares the same wrapped `HTTPClient`, so retry and cache behaviour are
identical to v3.

Rejected alternatives:

- **Teaching `TMDbAPIClient` two base paths.** Unnecessary — it is already
  base-URL-agnostic and per-instance. A mode flag would add branching to a type
  that currently has none.
- **A separate `TMDbV4APIClient` type.** It would duplicate URL building,
  validation and decoding to vary one stored property.
- **A separate SwiftPM target or product.** [ADR-0010](0010-tmdb-intelligence-product.md)
  extracted `TMDbIntelligence` into its own product, but the enabling fact
  there was that the moved code touched **no** internal symbols. v4 is the
  opposite: it needs `APIClient`, `APIRequest` and `TMDbFactory`. A product
  boundary would force those internals public.

### The per-call token is a `String`, not `V4AccessToken`

v4 user-scoped endpoints take the access token per call, mirroring how v3
threads `session: Session`. The token parameter is typed `String` rather than
the `V4AccessToken` value type that `createAccessToken(withRequestToken:)`
returns.

An adversarial plan review argued for the value type, on the grounds that
[ADR-0005](0005-authenticated-session-additive-overloads.md) introduced
`AuthenticatedSession` precisely to stop callers passing loose credential
primitives. The counter-argument won: `Session` *is* the whole v3 credential,
whereas `V4AccessToken` also carries `accountID`. List endpoints need only the
token, so requiring the wrapper would force callers who persisted just the
token (the normal case — it is what you put in the keychain) to synthesise a
`V4AccessToken` with a dummy account id in order to read a list.

## Consequences

- v4 gains a client for the cost of one factory method and one struct field.
  Nothing about the v3 path changes.
- v4 error bodies are shape-identical to v3 (`{success, status_code,
  status_message}`), verified against the live API, so `validate()`,
  `TMDbErrorContext` and the error mapping need no v4-specific handling.
- The v4 client uses the standard `TMDbJSONSerialiser`. The token models carry
  no dates, so no v4 date strategy is needed yet.
- `V4AuthenticationService` ships **complete** in this change. Growing a public
  protocol by adding requirements is source-breaking
  ([ADR-0005](0005-authenticated-session-additive-overloads.md), and
  `knowledge/gotchas.md` § *Growing a public protocol additively*), so v4 work
  is split by protocol, never by adding methods to a shipped one.

### Still open — decisions deferred to the v4 list work

These are **not** settled by this ADR and must be recorded when they are:

- **Carrying a per-call bearer token — the seam this ADR's own design needs.**
  `TMDbAPIClient.buildHTTPRequest` copies `request.headers` and *then* sets
  `Authorization` from the client credential, so a request-level
  `Authorization` is overwritten. A `V4ListService` that threads the user
  access token per call, as decided above, therefore has no way to reach the
  wire today: the request would go out authenticated as the *application* and
  quietly return the app owner's lists rather than the caller's. Two options —
  (a) have `buildHTTPRequest` set the credential header only when
  `headers["Authorization"] == nil`, a one-line change that preserves the
  decorator chain, or (b) construct a per-token `APIClient`. Decide and record
  before the first user-scoped v4 endpoint lands.
- **A `.put` case on the public `HTTPRequest.Method`.** v4 list update is a
  PUT. The enum is public and non-frozen in a non-resilient module, and the
  README invites consumers to supply their own `HTTPClient`, so adding a case
  is potentially source-breaking for any conformer that switches exhaustively.
  It must be taken as a deliberate, documented break, not filed as "additive".
- **Credential-aware caching.** v4 list reads are the package's first
  genuinely user-private `GET` responses whose URL contains no credential.
  Both cache layers need addressing — the opt-in `CacheHTTPClient` *and* the
  always-on 1 GB on-disk `URLCache` installed by `TMDbFactory`, which keys on
  URL alone. Fixing only the former leaves the leak open.
- **`GET /4/list/{id}/clear`.** Verified against the live API: clearing a list
  is a **GET** (`POST` returns 404). A state-changing GET must not be cached.
- **`create(isPublic:)`.** Creating a list with `"public": false` returned a
  public list, so the wire field appears to be ignored. The parameter must not
  ship until the correct behaviour is established.
