# PRD-001: Complete API Parity

| Field    | Value                                  |
|----------|----------------------------------------|
| Priority | High                                   |
| Effort   | Small                                  |
| Status   | Complete                               |

## Problem Statement

The TMDb Swift package currently covers ~170 endpoints across 25
services, but four v3 API endpoints are missing. Three of these create
asymmetries in the public API surface:

1. **Movie keywords** — `TVSeriesService` has `keywords(forTVSeries:)`
   but `MovieService` does not have an equivalent, even though
   `GET /3/movie/{id}/keywords` exists.
2. **All trending** — `TrendingService` has `movies()`, `tvSeries()`,
   and `people()` but no unified `all()` endpoint matching
   `GET /3/trending/all/{time_window}`.
3. **Screened theatrically** — `GET /3/tv/{id}/screened_theatrically`
   has no equivalent in `TVSeriesService`.
4. **TV series episode groups** —
   `GET /3/tv/{id}/episode_groups` lists all episode groups for a
   TV series but has no method in `TVSeriesService`. (The existing
   `TVEpisodeGroupService` only covers fetching a single group by
   ID via `GET /3/tv/episode_group/{id}`.)

## Proposed Solution

Add four new methods to existing service protocols.

### 1. `keywords(forMovie:)` on `MovieService`

```swift
// MovieService.swift
func keywords(forMovie movieID: Movie.ID) async throws -> KeywordCollection
```

**API note:** The movie keywords endpoint returns keywords under a
`"keywords"` JSON key, whereas the TV series endpoint uses `"results"`.
The existing `KeywordCollection` model maps `keywords` from the
`"results"` coding key. A new model or a custom decoding strategy is
needed for the movie variant.

**Decoding note:** The existing `KeywordCollection` model has a
`CodingKey` that maps `keywords` from the JSON key `"results"` (to
match the TV series endpoint). For the movie endpoint, which uses
`"keywords"` as the JSON key, create an internal
`MovieKeywordsResponse` model that decodes from `"keywords"` (the
default CodingKey) and converts to `KeywordCollection` at the service
layer. This avoids coupling the public model to endpoint-specific
JSON quirks.

Movie keywords API response (`GET /3/movie/550/keywords`):

```json
{
  "id": 550,
  "keywords": [
    { "id": 851, "name": "dual identity" },
    { "id": 818, "name": "based on novel or book" }
  ]
}
```

TV series keywords API response (`GET /3/tv/1396/keywords`):

```json
{
  "id": 1396,
  "results": [
    { "id": 1508, "name": "new mexico" },
    { "id": 2231, "name": "drug dealer" }
  ]
}
```

### 2. `allTrending(inTimeWindow:page:language:)` on `TrendingService`

```swift
// TrendingService.swift
func allTrending(
    inTimeWindow timeWindow: TrendingTimeWindowFilterType,
    page: Int?,
    language: String?
) async throws -> TrendingPageableList
```

The `GET /3/trending/all/{time_window}` endpoint returns a mix of
movies, TV shows, and people in a single list. Each result includes a
`media_type` field (`"movie"`, `"tv"`, or `"person"`).

A new `TrendingItem` enum with associated values for
`MovieListItem`, `TVSeriesListItem`, and `PersonListItem` is needed,
decoded via the `media_type` discriminator field. `TrendingItem` must
conform to `Codable`, `Identifiable`, `Equatable`, `Hashable`, and
`Sendable` (required by `PageableListResult`'s generic constraint).

**Existing precedent:** The `Media` enum in
`Sources/TMDb/Domain/Models/Media.swift` already implements this
exact pattern for `SearchService.searchAll()`, using a `media_type`
discriminator to decode `MovieListItem`, `TVSeriesListItem`,
`PersonListItem`, and `CollectionListItem`. `TrendingItem` should
follow the same decoding approach but without the `.collection` case
(the trending all endpoint only returns movies, TV, and people).

**Note:** The TMDb OpenAPI spec only documents movie-like fields for
the trending all response. However, live API verification confirms
the response is polymorphic — each result includes a `media_type`
discriminator (`"movie"`, `"tv"`, or `"person"`) with different
field shapes per type.

**Field compatibility:** Verify that `PersonListItem` can decode
from trending person results, which do **not** include the
`known_for` array present in search results. All list item models
must use optional properties for fields that may be absent in
different API contexts.

The custom `Decodable` implementation should:

1. Decode `media_type` from the keyed container
2. Based on the value, decode the full object as the corresponding
   list item type from the same decoder
3. Throw `DecodingError` for unknown `media_type` values

```swift
public enum TrendingItem: Identifiable, Codable, Equatable,
    Hashable, Sendable {

    case movie(MovieListItem)
    case tvSeries(TVSeriesListItem)
    case person(PersonListItem)

    public var id: Int {
        switch self {
        case .movie(let item): item.id
        case .tvSeries(let item): item.id
        case .person(let item): item.id
        }
    }
}
```

`TrendingPageableList` is a typealias:

```swift
public typealias TrendingPageableList = PageableListResult<TrendingItem>
```

### 3. `screenedTheatrically(forTVSeries:)` on `TVSeriesService`

```swift
// TVSeriesService.swift
func screenedTheatrically(
    forTVSeries tvSeriesID: TVSeries.ID
) async throws -> ScreenedTheatricallyCollection
```

Returns seasons and episodes that have been screened theatrically.
Requires a new `ScreenedTheatricallyCollection` model and a
`ScreenedTheatricallyResult` model for each entry (containing
`id`, `episode_number`, `season_number`).

### 4. `episodeGroups(forTVSeries:)` on `TVSeriesService`

```swift
// TVSeriesService.swift
func episodeGroups(
    forTVSeries tvSeriesID: TVSeries.ID
) async throws -> TVEpisodeGroupCollection
```

Returns the episode groups that have been added to a TV series.
Requires a new `TVEpisodeGroupCollection` model containing an array
of `TVEpisodeGroupListItem` entries (each with `id`, `name`,
`description`, `type`, `episode_count`, `group_count`, `network`).

API response (`GET /3/tv/1399/episode_groups`):

```json
{
  "id": 1399,
  "results": [
    {
      "description": "",
      "episode_count": 73,
      "group_count": 8,
      "id": "5acf93e60e0a26346c00000b",
      "name": "Aired Order",
      "network": null,
      "type": 1
    }
  ]
}
```

## Technical Design

### Files to Create

| File | Purpose |
|------|---------|
| `Sources/TMDb/Domain/Services/Movies/Requests/MovieKeywordsRequest.swift` | API request for movie keywords |
| `Sources/TMDb/Domain/Services/Movies/MovieKeywordsResponse.swift` | Internal model decoding `"keywords"` JSON key; converts to `KeywordCollection` |
| `Sources/TMDb/Domain/Services/Trending/Requests/TrendingAllRequest.swift` | API request for all trending |
| `Sources/TMDb/Domain/Services/TVSeries/Requests/TVSeriesScreenedTheatricallyRequest.swift` | API request for screened theatrically |
| `Sources/TMDb/Domain/Services/TVSeries/Requests/TVSeriesEpisodeGroupsRequest.swift` | API request for episode groups |
| `Sources/TMDb/Domain/Models/TVEpisodeGroupCollection.swift` | Collection model for episode groups |
| `Sources/TMDb/Domain/Models/TVEpisodeGroupListItem.swift` | List item model for episode group entries |
| `Sources/TMDb/Domain/Models/TrendingItem.swift` | Union type for trending results |
| `Sources/TMDb/Domain/Models/TrendingPageableList.swift` | Typealias for pageable trending results |
| `Sources/TMDb/Domain/Models/ScreenedTheatricallyCollection.swift` | Collection model |
| `Sources/TMDb/Domain/Models/ScreenedTheatricallyResult.swift` | Individual result model |

### Files to Modify

| File | Change |
|------|--------|
| `Sources/TMDb/Domain/Services/Movies/MovieService.swift` | Add `keywords(forMovie:)` protocol method |
| `Sources/TMDb/Domain/Services/Movies/TMDbMovieService.swift` | Add implementation (single-file service, no extensions) |
| `Sources/TMDb/Domain/Services/Trending/TrendingService.swift` | Add `allTrending(inTimeWindow:page:language:)` |
| `Sources/TMDb/Domain/Services/Trending/TMDbTrendingService.swift` | Add implementation |
| `Sources/TMDb/Domain/Services/TVSeries/TVSeriesService.swift` | Add `screenedTheatrically(forTVSeries:)` and `episodeGroups(forTVSeries:)` |
| `Sources/TMDb/Domain/Services/TVSeries/TMDbTVSeriesService+Metadata.swift` | Add implementations (follows existing metadata extension pattern) |
| `Sources/TMDb/TMDb.docc/Extensions/MovieService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/Extensions/TrendingService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/Extensions/TVSeriesService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/TMDb.md` | Add new model types to topic sections |
| `README.md` | Update service descriptions if capabilities expanded |

### Test Files to Create

| File | Purpose |
|------|---------|
| `Tests/TMDbTests/Domain/Services/Movies/TMDbMovieServiceKeywordsTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Services/Trending/TMDbTrendingServiceAllTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Services/TVSeries/TMDbTVSeriesServiceScreenedTheatricallyTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Services/TVSeries/TMDbTVSeriesServiceEpisodeGroupsTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Models/TrendingItemTests.swift` | Decoding tests for `TrendingItem` (movie, TV, person, unknown media_type) |
| `Tests/TMDbTests/Mocks/Models/TrendingItem+Mocks.swift` | Mock data for `TrendingItem` |
| `Tests/TMDbTests/Mocks/Models/ScreenedTheatricallyCollection+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Mocks/Models/TVEpisodeGroupCollection+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Mocks/Models/TrendingPageableList+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Resources/json/movie-keywords.json` | JSON fixture |
| `Tests/TMDbTests/Resources/json/trending-all.json` | JSON fixture |
| `Tests/TMDbTests/Resources/json/tv-series-screened-theatrically.json` | JSON fixture |
| `Tests/TMDbTests/Resources/json/tv-series-episode-groups.json` | JSON fixture |

### Integration Test Files to Modify

Integration tests follow a single-file-per-service pattern. Add new
test methods to the existing files:

| File | Change |
|------|--------|
| `Tests/TMDbIntegrationTests/MovieIntegrationTests.swift` | Add `keywords(forMovie:)` test |
| `Tests/TMDbIntegrationTests/TrendingIntegrationTests.swift` | Add `allTrending()` test |
| `Tests/TMDbIntegrationTests/TVSeriesServiceTests.swift` | Add `screenedTheatrically()` and `episodeGroups()` tests |

## Acceptance Criteria

- [x] `MovieService.keywords(forMovie:)` returns a `KeywordCollection`
      with the correct keywords for a given movie
- [x] `TrendingService.allTrending(inTimeWindow:page:language:)` returns
      a pageable list of mixed media results
- [x] `TVSeriesService.screenedTheatrically(forTVSeries:)` returns
      theatrical screening data
- [x] `TVSeriesService.episodeGroups(forTVSeries:)` returns episode
      group data for a TV series
- [x] All new methods have `///` doc comments with parameters, throws,
      and returns
- [x] DocC extension files reference the new methods
- [x] `TMDb.docc/TMDb.md` topic sections include new model types
- [x] Unit tests pass with JSON fixtures
- [x] Integration tests pass against the live TMDb API
- [x] `make ci` passes

## Dependencies

- **PRD-003 depends on this** — PRD-003's `TrendingService` convenience
  extensions reference `allTrending`, which is added here.

## Out of Scope

- Pagination helpers for the trending endpoint (see PRD-003)
- Any TMDb API v4 endpoints
- `POST /3/authentication/session/convert/4` — v4 token session
  creation (low demand, requires v4 token infrastructure)
- `GET /3/movie/{id}/lists` — already implemented
