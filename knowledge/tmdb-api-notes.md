# TMDb Live-API Notes

Behaviours of the **live** TMDb API discovered while implementing — the things the
docs don't say, or say wrongly. This is an API-client library, so these recur.
Newest at the top; cite the endpoint and the date observed.

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
