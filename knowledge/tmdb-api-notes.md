# TMDb Live-API Notes

Behaviours of the **live** TMDb API discovered while implementing — the things the
docs don't say, or say wrongly. This is an API-client library, so these recur.
Newest at the top; cite the endpoint and the date observed.

## HTTP caching

### Every GET response is HTTP-cacheable — `Cache-Control: public, max-age` + `ETag`

*2026-06-24.* TMDb serves standard caching headers on every GET endpoint:
`Cache-Control: public, max-age=<seconds>` plus a weak `ETag` (and an `age`
header — responses are CDN-fronted). The `max-age` varies sensibly by resource:
`movie/{id}` ~18909s (~5h), `search/movie` ~15340s (~4h), `configuration` and
`person/{id}` several hours, `trending/*` ~36–395s (minutes). So responses are
fully cacheable *and* conditionally revalidatable (a stale entry's `ETag` yields
a `304 Not Modified`). This is why the default `URLSession` adapter's `URLCache`
gives real on-disk caching for free on Apple platforms — see
[ADR-0007](decisions/0007-document-existing-response-caching.md).

## Errors

### Error bodies are `{success, status_code, status_message}` — and `status_code` ≠ HTTP status

*2026-07-24.* Every GET error response carries the same flat JSON body, e.g.

```json
{"success":false,"status_code":34,"status_message":"The resource you requested could not be found."}
```

Verified live: **400** → code 22 (bad `page`), **401** → code 7 (invalid API key),
**404** → code 34 (`movie/{bogus id}`), **422** → code 20 (a `changes` date range
longer than 14 days).

- TMDb's numeric `status_code` is **not** the HTTP status and is **many-to-one**
  against it: a 404 can be code 6, 34 or 37; a 401 spans 14 different codes. Keep
  both — the HTTP status for coarse handling, the TMDb code for the exact cause.
  The full table is at <https://developer.themoviedb.org/docs/errors> (47 codes).
- **Key order varies** between endpoints (`success` sometimes first, sometimes
  last), which is harmless for keyed `Decodable` but will break any byte-compare
  of fixtures.
- POST body-validation can instead return an `{"errors":[…]}` array with no
  `status_code`, so a decoder for the shape above must degrade gracefully
  (the client decodes it with `try?` and keeps the HTTP status).

### Credentials and PII live in the URL *path*, not just the query

*2026-07-24.* Where a secret appears differs by kind, which matters for anything
that logs or surfaces a request path:

- **Path segments:** `guest_session_id` (`/guest_session/{id}/rated/…`, a
  bearer-like credential) and `account_id` (`/account/{id}/…`, personal data).
- **Query items:** `api_key`, `session_id`.
- **Request bodies:** `username`, `password`, `request_token`.

So a path is *not* automatically safe to expose. This is why `TMDbErrorContext`
runs its `endpointPath` through `EndpointPathRedactor` (see
[ADR-0012](decisions/0012-structured-tmdberror-context.md)); redaction keys off
the **first** path component so `/authentication/guest_session/new` is untouched.

## Discover

### `discover/movie` has *two* distinct release-date filters

*2026-06-24.* `release_date.gte`/`.lte` and `primary_release_date.gte`/`.lte` are
**not** the same parameter. `primary_release_date.*` bounds only a movie's
**primary** release; `release_date.*` bounds **any** release type (and pairs with
`with_release_type` + `region`). They return different result sets — so a client
needs both. In this package: the year-granular `primaryReleaseYear` filter maps to
`primary_release_date.*`, and the `Date`-granular `releaseDateMin`/`releaseDateMax`
maps to `release_date.*`.

### TMDb silently ignores unknown query parameters (returns 200)

*2026-06-24.* `discover/movie` and `discover/tv` return **HTTP 200** for a bogus
query key rather than erroring, so a misspelled or unsupported parameter looks like
it "works" but is a no-op. To confirm a parameter is real and effective, compare
**result counts** with vs without it (a bogus key yields the *unfiltered* count) —
status code alone proves nothing.

## OpenAPI spec

### The spec is ~3 MB minified JSON on a single line

- `https://developer.themoviedb.org/openapi/tmdb-api.json` is one giant minified
  line. **Never** `cat` / `grep` / `Read` it whole (it dumps the entire file into
  context). Extract one endpoint with `jq`:
  - List paths: `jq -r '.paths | keys[]' tmdb-openapi.json`
  - One 200 schema: `jq '.paths."/3/movie/{movie_id}".get.responses."200".content."application/json".schema' tmdb-openapi.json`

### Response schemas are inlined per endpoint — no reusable components

- It's OpenAPI 3.1, but there is **no `components.schemas`**; each endpoint inlines
  its response schema. Don't look for shared model definitions — read the
  endpoint's own schema.

## TV seasons

### `tv-season-details` returns top-level `networks` and `_id`

*2026-06-19, `/3/tv/{series_id}/season/{season_number}`.*

- The season-details response carries a **top-level `networks`** array (the
  networks that aired the season — e.g. Game of Thrones S1 → HBO, id 49), mapped
  onto `TVSeason.networks` as `[Network]?`. It arrives on the **base** endpoint —
  no append-to-response option is needed.
- The response also has a top-level **`_id`** string (TMDb's internal
  Mongo-style document id). It is **intentionally unmapped**, consistent with how
  other models ignore `_id`.
- `TVSeason`'s decoder is reused by `TVSeasonDetailsResponse.init(from:)` (via
  `try TVSeason(from: decoder)`), so `networks` also surfaces on the appended
  details response for free.

## Decoding resilience

### Unknown enum-like string values should decode resiliently

- Fields like `status` and `media_type` can return values not in our enums; decode
  them resiliently (fall back rather than throw) so a new backend value doesn't
  break an otherwise-valid response. (See the resilient-decoding work in recent
  history.)

## Field nullability

### Verify optionality against real responses, not assumptions

- A property should be optional (`?`) only if the API can return `null` or omit
  it. Confirm against a live response via `mcp__tmdb__*` and the OpenAPI schema
  before deciding — the docs aren't always accurate about which fields are
  guaranteed.

### `Company.logoPath` is a required decode — latent throw if `logo_path` is absent

*2026-06-30, `/3/company/{company_id}`.* `Company.logoPath` is non-optional
(`public let logoPath: URL`) and decoded with a **required**
`try container.decode(URL.self, forKey: .logoPath)`
(`Sources/TMDb/Domain/Models/Company.swift`), so an absent, `null`, or empty
`logo_path` makes the **whole `Company` decode throw**. TMDb does return
logo-less production companies, so this is a real latent failure, not theoretical.
Note the asymmetry in the *same* decoder: `homepageURL` **is** guarded (empty
string → `nil`, with the comment "URL decoding will fail with an empty string"),
and the sibling `Network.logoPath` is correctly `URL?` — only `Company.logoPath`
is unguarded. **Fixing it means making `logoPath` optional (`URL?`), a breaking
public-API change** (property type + `init` parameter), so it is deferred to a
deliberate major version rather than patched ad hoc. Until then, treat a company
with no logo as a known decode-failure risk. (Surfaced in the 2026-06-30
standardization audit.)

## Changes endpoints

### `changes/movie|tv|person` list responses are large and carry an unmodelled `softcore` field

*2026-06-18, `/3/movie/changes` (and the tv/person equivalents).*

- These list endpoints return many pages — `total_pages` was ~76 for the default
  24-hour movie window — so iterate them with a bounded `.prefix(n)` rather than
  draining the whole sequence.
- Each result object is `{ id, adult, softcore }`. `ChangedID` models only `id`
  and `adult`; the extra `softcore` key is silently absorbed by
  `PageableListResult`'s tolerant `FailableDecodable` decoder, so decoding never
  fails — but the model is incomplete if `softcore` is ever needed.
- The change **list** endpoints return a paged shape (`page`/`total_pages`/
  `total_results`, modelled as `ChangedIDCollection`), but the per-entity change
  **detail** endpoints (`/movie/{id}/changes` etc.) return an unpaged
  `{ changes: [...] }` (`ChangeCollection`) — see [ADR-0002](decisions/0002-changes-auto-pagination-adapter.md).
