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

### Resolved in the v4 list work (2026-08-07)

The four decisions this ADR deferred are now taken. Each is recorded here rather
than in a new ADR, because each is an amendment to *this* design rather than a
separate one.

- **Carrying a per-call bearer token.** Option (a): `TMDbAPIClient` applies the
  client credential only when the request did not bring its own `Authorization`.
  It also withholds the `api_key` query item in that case — sending two
  credentials would leave precedence to the server, which was never probed. The
  decorator chain is untouched.

- **`.put` on the public `HTTPRequest.Method`.** Added, and taken deliberately
  as a **source-breaking** change shipping in 20.0.0: a consumer whose custom
  `HTTPClient` switches exhaustively over the enum stops compiling. There is no
  other seam through which to express a PUT. `RetryHTTPClient` classifies it as
  idempotent — PUT replaces the resource with the request's own representation,
  so replaying it converges, unlike POST.

- **Credential-aware caching — in both layers, keyed on a new
  `HTTPRequest.isUserSpecific`.** The honest predicate is *"does this require a
  user's credential"*, not *"does it have an `Authorization` header"*: a
  `TMDbClient(bearerToken:)` sends that header on every request including wholly
  public ones, so keying on it would disable caching for every such client while
  protecting nothing. `TMDbAPIClient` is the only component that can tell a
  request-level credential from the client's own, so it sets the flag there, for
  all three user-scoped mechanisms (a v4 access token, a v3 `session_id`, a
  guest session). `CacheHTTPClient` then bypasses; `URLSessionHTTPClientAdapter`
  routes through a second session with no `URLCache`, because policy alone would
  stop a stale read but not the write. `isUserSpecific` is **public** because the
  README invites custom `HTTPClient`s, and a contract that cannot be seen cannot
  be honoured.

- **`GET /4/list/{id}/clear`.** A `GET` whose path ends `/clear` routes through
  `CacheHTTPClient`'s mutation path, so it invalidates rather than populates.
  v3's clear is a `POST` and never reaches it.

- **`create(isPublic:)`.** It **ships**, contrary to this ADR's original
  expectation — but only because probing established *how*. `{"public": false}`
  is silently ignored and the list comes back public; `{"public": 0}` is
  honoured. So the parameter is real and the request body encodes it as an
  integer, pinned by a test asserting the raw JSON text. (Update accepts either
  form.) The earlier "appears to be ignored" reading came from sending a boolean.

### Originally deferred — kept for the reasoning, all now resolved above

These were open when this ADR was written. Each is settled in *Resolved in the
v4 list work*; the original framing is kept because the reasoning that
identified them is what made them findable:

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

  This is measured, not theoretical. Probing the live API during the security
  review of this change:

  ```text
  GET https://api.themoviedb.org/4/list/1  ->  cache-control: public, max-age=300
  ```

  So once v4 list `GET`s land, private list responses **will** be stored:
  by `CacheHTTPClient` (keyed on `request.url.absoluteString`, and
  `isUserSpecificRequest` will not fire because a v4 URL carries neither
  `session_id` nor `/guest_session/`) and by the on-disk `URLCache` under
  `.useProtocolCachePolicy`. Not reachable from this change — all three v4
  auth requests are POST/POST/DELETE, which `CacheHTTPClient` routes straight
  to `performMutation`.
- **`GET /4/list/{id}/clear`.** Verified against the live API: clearing a list
  is a **GET** (`POST` returns 404). A state-changing GET must not be cached.
- **`create(isPublic:)`.** Creating a list with `"public": false` returned a
  public list, so the wire field appears to be ignored. The parameter must not
  ship until the correct behaviour is established.
