# TMDb Live-API Notes

Behaviours of the **live** TMDb API discovered while implementing — the things the
docs don't say, or say wrongly. This is an API-client library, so these recur.
Newest at the top; cite the endpoint and the date observed.

## v4 API

### A v3 API key authenticates v4 *reads* — as a query item, never as a bearer

*2026-08-07.* The two credentials TMDb shows on one settings page are not
interchangeable, and the boundary is not where the docs imply:

| Request | Result |
| --- | --- |
| `GET /4/list/1?api_key=<32-char v3 key>` | **200** with real data |
| same key as `Authorization: Bearer` | **401** — a v3 key is not a bearer token |
| `GET /4/account/{id}/lists` with api_key | **401** — needs a *user* token |
| `POST`/`PUT`/`DELETE /4/list…` with api_key | **401** — needs a *user* token |

So public v4 reads work from a `TMDbClient(apiKey:)`; the v4 auth endpoints and
every write need a bearer credential. The bearer credential is itself two
different things — the **API Read Access Token** identifies the *application*,
the **user access token** (from the approval flow) identifies a *user*.

### Unauthenticated v4 requests auth-gate *before* routing, so 401-vs-404 proves nothing

*2026-08-07.* With no valid credential every v4 path returns an identical `401`,
including `/4/completely/bogus/nonsense`. The usual trick of probing an unknown
REST path and reading 401 ("exists") vs 404 ("wrong path") therefore **cannot
discriminate** on v4 until you hold a working credential. With one, routing shows
through normally and 404 means the path is wrong.

This matters because TMDb's v4 docs name endpoints in prose that is not the
route: the real paths are `POST /4/auth/request_token` and
`POST /4/auth/access_token`, while the documented-sounding
`…/auth/create-request-token` and `…/auth/create-access-token` are **404**.

### The same field has different wire types on different v4 endpoints

*2026-08-07.* Verified by capturing both responses. This is the single most
dangerous v4 behaviour — a shared model across the two endpoints cannot decode:

| field | `GET /4/list/{id}` | `GET /4/account/{id}/lists` |
| --- | --- | --- |
| `public` | `true` (bool) | `1` (int) |
| `sort_by` | `"original_order.asc"` (String) | `1` (int) |
| `runtime` | `8433` (int) | `"0"` (**String**) |
| `adult` / `featured` | absent | `0` (int) |

Dates diverge too: account-list summaries carry `created_at`/`updated_at` as
`"2026-08-06 23:26:00 UTC"` (the format `JSONDecoder.theMovieDatabaseAuth`
already handles) while list *items* carry plain `yyyy-MM-dd`. Neither existing
decoder handles both, so a v4 decoder needs a strategy that tries each in turn.

### v4 list quirks: a state-changing GET, a 404-means-false status, and out-of-band comments

*2026-08-07.* Four shapes that will not be guessed from the docs:

- **`GET /4/list/{id}/clear` clears the list** — `POST` to it returns 404. A
  state-changing GET must be kept out of any response cache. It returns
  `items_deleted`.
- **`GET /4/list/{id}/item_status`** returns 200 for a member and **404**
  (`status_code` 34) for a non-member. There is no `item_present` boolean, so a
  `Bool`-returning wrapper has to catch not-found — and that conflates "not in
  the list" with "no such list" and "no access", all of which are also 404.
- **`comments` is a top-level dictionary** keyed `"media_type:id"` (e.g.
  `"movie:550"`, `"tv:1399"`) with nullable values. List items carry no comment
  field of their own, so a per-item comment must be stitched in from that dict.
- **Create returns HTTP 201** with `id` — not v3's `list_id`. Delete returns
  `status_code` 13.
- **Add-items accepts a per-item `comment`, answers `success: true`, and stores
  nothing.** Only `PUT /4/list/{id}/items` persists one. So an add-items input
  model must *not* expose a comment field, or it is a parameter that silently
  does nothing.
- **A write's `success` describes the request, not the items.** Removing an item
  that is not in the list returns overall `success: true` with that item's
  per-item `success: false`. Always read `results[]`.

### `{"public": false}` is ignored on create; `{"public": 0}` is honoured

*2026-08-07.* `POST /4/list` accepts a visibility field, but only as an
**integer**. Sending the boolean `false` returns a list that reads back
`public: true`; sending `0` produces a private list. `is_public` and `private`
are ignored entirely. `PUT /4/list/{id}` accepts *either* form, so the asymmetry
is specific to create.

This is why the v4 auth work concluded "TMDb ignores the visibility field" and
nearly shipped without the parameter — the probe had sent a boolean. **Prove a
field is honoured by reading the resource back, and if it appears ignored, try
the other wire type before concluding anything.** The same endpoint reports
`public` as a bool on read while requiring an int on create.

### `sort_by` is honoured on create, update **and read**, with exactly ten values

*2026-08-07.* `GET /4/list/{id}?sort_by=title.desc` genuinely reorders the
response — it is not decoration, so a client wrapping this endpoint needs a sort
parameter on its *read* methods, not only on create and update.

Accepted values, each confirmed by setting it and reading the list back:
`original_order`, `vote_average`, `primary_release_date`, `release_date` and
`title`, each `.asc` and `.desc`. **Rejected** (`success: false`, value
unchanged): `popularity`, `runtime`, `revenue`, `first_air_date`, `vote_count` —
several of which *are* valid on the v3 discover endpoints, so the sets are not
interchangeable. A new list defaults to `original_order.asc`.

### List creation is spam-filtered — `status_code` 18

*2026-08-07.* Creating several lists in quick succession, with
machine-looking names (`probe 24985`, `probe 7122`, …), gets them rejected with:

```json
{"success": false, "status_code": 18, "status_message": "Validation failed.",
 "errors": ["Content is suspected to be spam"]}
```

Two consequences. An integration suite that creates a list per test can trip
this in CI, so create once per run with a plausible name — and do **not** turn
the rejection into a skip, or a run that created nothing looks exactly like one
that worked.

And the diagnostic trap: ten identical failures across a parameter sweep read as
a definitive answer about the *parameter*. Here they were a rate limit, and only
the error **body** disproved it. A uniform failure across a sweep is evidence
about the sweep, not about what you were varying.

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

**The v4 surface does the same** — `GET /4/list/{id}` serves
`Cache-Control: public, max-age=300` (verified 2026-08-07). That is a hazard
rather than a gift: v4 list responses are *user-private* yet carry no credential
in the URL, so both cache layers would key them identically across users. See
[ADR-0017](decisions/0017-v4-api-client.md) → *Still open*.

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
- **The v4 API uses this same body shape** (verified 2026-08-07), so error
  mapping needs no v4-specific handling.

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

## Rate limiting

### v3 GET responses expose **no** `X-RateLimit-*` headers — you cannot budget against them

*2026-07-28, `/3/movie/{movie_id}`.* A successful v3 GET returns only
`server`, `cache-control`, `etag` (and an `age` when CDN-cached). There is **no**
`X-RateLimit-Limit` / `-Remaining` / `-Reset`, so a client has no way to see how
close it is to a limit, and no header to drive pre-emptive throttling. A burst of
12 back-to-back requests returned no `429`, consistent with TMDb having retired
its old 40-requests-per-10-seconds cap.

Consequences for this package:

- `RetryHTTPClient` and `HTTPResponse.retryAfterDuration` do parse and honour a
  `Retry-After` header (capping it to `maxDelay` so a hostile `Retry-After:
  86400` can't park the calling task) — but that path fires only *reactively*, on
  a `429` we have never observed live. **Treat the 429 branch as unexercised
  against the real API**; its unit tests are the only coverage.
- Don't add "remaining quota" style API to the client — there is no source of
  truth for it.
- **Not reproduced:** an actual `429`, and therefore whether TMDb sends
  `Retry-After` with it at all (the header is assumed, not confirmed). Deliberately
  not pursued — inducing one means abusing the live API. If a real `429` is ever
  captured in the wild, record its headers here.

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

**The same applies to request *bodies*, and it is worse there** — a body field is
accepted, reported as a success, and dropped. Both observed on v4 lists,
2026-08-07:

- `POST /4/list/{id}/items` with a per-item `comment` returns
  `{"success":true}` per item, and the comment is **never stored** — reading the
  list back shows `null`. Only `PUT /4/list/{id}/items` persists one.
- Creating a list with `"public": false` returns success and yields a **public**
  list.

So verify a body field by **reading the resource back**, never by the response's
success flag. Anything else risks exposing a parameter the API ignores — a
public method that silently does nothing.

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

### `/company/{id}`: `logo_path` and `origin_country` are frequently `null`

*2026-07-28, `/3/company/{company_id}`, 54-company sample.* Measured, not
guessed:

| field | `null` | `""` | notes |
| --- | --- | --- | --- |
| `logo_path` | **9** (17%) | 0 | never an empty string |
| `origin_country` | **5** (9%) | 0 | |
| `parent_company.logo_path` | **2 of 8** | 0 | parents are sparse too |
| `description` | 0 | 53 | empty, never null |
| `headquarters` | 0 | 12 | empty, never null |
| `homepage` | 0 | 23 | empty, never null |

- The nulls hit **prominent** companies, not obscure ones — Time Warner (128)
  and Viacom International (5308, Paramount's parent) return `null` for *both*
  `logo_path` and `origin_country`. Don't assume sparse records are edge cases.
- **The two null-bearing fields are exactly the two that were modelled as
  required**, so `details(forCompany:)` threw for those companies until 19.0.0.
- The `""`/`null` split tells you where a guard is *load-bearing*: `homepage`
  needs `decodeNonEmptyURLIfPresent` because it genuinely *is* `""` 23 times;
  for `logo_path` the guard is belt-and-braces, since the API never sent one.
  **Both `Company.logoPath` and `Company.Parent.logoPath` guard it anyway** —
  see the gotcha *Guard consistently within a type*: an unobserved value is a
  reason to rank the risk low, not a reason to leave one property of a type
  behaving differently from its neighbour.

### Verify optionality against real responses, not assumptions

- A property should be optional (`?`) only if the API can return `null` or omit
  it. Confirm against a live response via `mcp__tmdb__*` and the OpenAPI schema
  before deciding — the docs aren't always accurate about which fields are
  guaranteed.

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
