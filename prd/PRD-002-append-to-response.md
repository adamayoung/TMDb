# PRD-002: Append to Response Support

| Field    | Value                                  |
|----------|----------------------------------------|
| Priority | High                                   |
| Effort   | Medium                                 |
| Status   | Complete                               |

## Problem Statement

The TMDb API supports an `append_to_response` query parameter on
detail endpoints (movies, TV series, TV seasons, TV episodes, people).
This allows clients to fetch related data (credits, images, videos,
reviews, etc.) in a single HTTP request instead of making multiple
round trips.

Currently, to get a movie's details, credits, and images, consumers
must make three separate API calls:

```swift
let movie = try await client.movies.details(forMovie: 550)
let credits = try await client.movies.credits(forMovie: 550)
let images = try await client.movies.images(forMovie: 550)
```

With `append_to_response`, the TMDb API can return all three in a
single response, reducing latency and API rate limit usage.

## Proposed Solution

Add overloads to detail methods that accept an option set specifying
which related data to append. The response type wraps the base detail
model with optional properties for each appendable resource.

### Usage Example

```swift
let result = try await client.movies.details(
    forMovie: 550,
    appending: [.credits, .images, .videos],
    language: "en"
)

let movie: Movie = result.movie            // Always present
let credits: ShowCredits? = result.credits  // Present because requested
let images: ImageCollection? = result.images
let videos: VideoCollection? = result.videos
let reviews: ReviewPageableList? = result.reviews  // nil — not requested
```

### Endpoints That Support `append_to_response`

| Endpoint | Service | Detail Model |
|----------|---------|-------------|
| `GET /3/movie/{id}` | `MovieService` | `Movie` |
| `GET /3/tv/{id}` | `TVSeriesService` | `TVSeries` |
| `GET /3/tv/{id}/season/{num}` | `TVSeasonService` | `TVSeason` |
| `GET /3/tv/{id}/season/{num}/episode/{num}` | `TVEpisodeService` | `TVEpisode` |
| `GET /3/person/{id}` | `PersonService` | `Person` |

### Appendable Resources Per Endpoint

**Note:** The TMDb API allows a maximum of **20 items** in the
`append_to_response` parameter per request.

**Movie** (14 appendable):
`credits`, `images`, `videos`, `reviews`, `recommendations`, `similar`,
`release_dates`, `alternative_titles`, `translations`, `keywords`,
`watch/providers`, `external_ids`, `lists`, `changes`

**TV Series** (18 appendable):
`credits`, `aggregate_credits`, `images`, `videos`, `reviews`,
`recommendations`, `similar`, `content_ratings`, `alternative_titles`,
`translations`, `keywords`, `watch/providers`, `external_ids`,
`screened_theatrically`, `episode_groups`, `lists`, `changes`

**TV Season** (7 appendable):
`credits`, `aggregate_credits`, `images`, `videos`, `translations`,
`watch/providers`, `external_ids`

**TV Episode** (5 appendable):
`credits`, `images`, `videos`, `translations`, `external_ids`

**Person** (8 appendable):
`movie_credits`, `tv_credits`, `combined_credits`, `images`,
`tagged_images`, `translations`, `external_ids`, `changes`

## Technical Design

### New Types

#### Option Sets

One option set per endpoint, defining the appendable resources:

```swift
/// Options for data to append to a movie details response.
public struct MovieAppendOption: OptionSet, Hashable, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let credits = MovieAppendOption(rawValue: 1 << 0)
    public static let images = MovieAppendOption(rawValue: 1 << 1)
    public static let videos = MovieAppendOption(rawValue: 1 << 2)
    public static let reviews = MovieAppendOption(rawValue: 1 << 3)
    public static let recommendations = MovieAppendOption(rawValue: 1 << 4)
    public static let similar = MovieAppendOption(rawValue: 1 << 5)
    // ...
}
```

Each option set provides an internal computed property that returns the
comma-separated query string value:

```swift
// "credits,images,videos"
var queryValue: String { ... }
```

#### Response Wrappers

```swift
/// A movie details response with optional appended data.
public struct MovieDetailsResponse: Codable, Equatable, Hashable, Sendable {
    public let movie: Movie          // Decoded from the top-level object
    public let credits: ShowCredits?
    public let images: ImageCollection?
    public let videos: VideoCollection?
    public let reviews: ReviewPageableList?
    // ... (see full appendable list above)
}
```

**TV Episode credits note:** The appended `credits` for TV episodes
include a `guest_stars` array alongside `cast` and `crew`. Verify
that the existing credits model can accommodate this, or use a
TV-episode-specific credits type for `TVEpisodeDetailsResponse`.

The response wrapper uses a flat decoding strategy — the TMDb API
embeds appended data as top-level keys alongside the movie fields:

```json
{
  "id": 550,
  "title": "Fight Club",
  "credits": { "cast": [...], "crew": [...] },
  "images": { "backdrops": [...], "posters": [...] },
  "videos": { "results": [...] }
}
```

This means `MovieDetailsResponse` decodes `Movie` from the same
container using `init(from decoder:)`, and appended properties decode
from their respective keys if present.

**Custom `Decodable` implementation:** Each response wrapper needs a
custom `init(from decoder:)` that:

1. Decodes the base model (e.g., `Movie`) from the top-level decoder
   (not a nested container) — since movie fields and appended data
   share the same JSON object
2. Gets a keyed container for the appended fields
3. Uses `decodeIfPresent` for each optional appended property

```swift
public init(from decoder: Decoder) throws {
    self.movie = try Movie(from: decoder)
    let container = try decoder.container(
        keyedBy: CodingKeys.self
    )
    self.credits = try container.decodeIfPresent(
        ShowCredits.self, forKey: .credits
    )
    self.images = try container.decodeIfPresent(
        ImageCollection.self, forKey: .images
    )
    // ...
}
```

This is the most technically delicate part — `Movie(from: decoder)`
must be called with the top-level decoder (not a container) so it can
decode its own keyed container independently.

### JSON Key Inconsistencies Across Endpoints

The TMDb API uses **different JSON key names** for the same logical
data depending on the parent endpoint. The response wrappers must
account for these:

| Appended Resource | Movie key | TV Series key |
|-------------------|-----------|---------------|
| Keywords | `"keywords"` → `{"keywords": [...]}` | `"keywords"` → `{"results": [...]}` |
| Alternative titles | `"alternative_titles"` → `{"titles": [...]}` | `"alternative_titles"` → `{"results": [...]}` |

The existing `KeywordCollection` model maps its `keywords` property
from the `"results"` CodingKey (matching the TV series format). For
`MovieDetailsResponse`, the appended `"keywords"` key contains
`{"keywords": [...]}` (not `"results"`), so `KeywordCollection`
cannot decode it directly. Use the internal `MovieKeywordsResponse`
model from PRD-001 or decode via a separate CodingKey mapping.

Similarly, movie alternative titles use a `"titles"` array key while
TV series use `"results"`. Each response wrapper must use the correct
nested key for its endpoint.

### `watch/providers` CodingKey

The `watch/providers` appended key contains a **forward slash** in
the JSON key name. Swift `CodingKey` enums require an explicit
string raw value for this:

```swift
private enum CodingKeys: String, CodingKey {
    case watchProviders = "watch/providers"
    // ...
}
```

### New Protocol Methods

```swift
// MovieService.swift
func details(
    forMovie movieID: Movie.ID,
    appending: MovieAppendOption,
    language: String?
) async throws -> MovieDetailsResponse

// TVSeriesService.swift
func details(
    forTVSeries tvSeriesID: TVSeries.ID,
    appending: TVSeriesAppendOption,
    language: String?
) async throws -> TVSeriesDetailsResponse

// TVSeasonService.swift
func details(
    forSeason seasonNumber: Int,
    inTVSeries tvSeriesID: TVSeries.ID,
    appending: TVSeasonAppendOption,
    language: String?
) async throws -> TVSeasonDetailsResponse

// TVEpisodeService.swift
func details(
    forEpisode episodeNumber: Int,
    inSeason seasonNumber: Int,
    inTVSeries tvSeriesID: TVSeries.ID,
    appending: TVEpisodeAppendOption,
    language: String?
) async throws -> TVEpisodeDetailsResponse

// PersonService.swift
func details(
    forPerson id: Person.ID,
    appending: PersonAppendOption,
    language: String?
) async throws -> PersonDetailsResponse
```

### Query Parameter

Add to `APIRequestQueryItem.Name`:

```swift
static let appendToResponse = APIRequestQueryItem.Name("append_to_response")
```

### Files to Create

| File | Purpose |
|------|---------|
| `Sources/TMDb/Domain/Models/MovieAppendOption.swift` | Option set |
| `Sources/TMDb/Domain/Models/MovieDetailsResponse.swift` | Response wrapper |
| `Sources/TMDb/Domain/Models/TVSeriesAppendOption.swift` | Option set |
| `Sources/TMDb/Domain/Models/TVSeriesDetailsResponse.swift` | Response wrapper |
| `Sources/TMDb/Domain/Models/TVSeasonAppendOption.swift` | Option set |
| `Sources/TMDb/Domain/Models/TVSeasonDetailsResponse.swift` | Response wrapper |
| `Sources/TMDb/Domain/Models/TVEpisodeAppendOption.swift` | Option set |
| `Sources/TMDb/Domain/Models/TVEpisodeDetailsResponse.swift` | Response wrapper |
| `Sources/TMDb/Domain/Models/PersonAppendOption.swift` | Option set |
| `Sources/TMDb/Domain/Models/PersonDetailsResponse.swift` | Response wrapper |

### Files to Modify

| File | Change |
|------|--------|
| `Sources/TMDb/Domain/APIClient/APIRequestQueryItem.swift` | Add `.appendToResponse` name |
| `Sources/TMDb/Domain/Services/Movies/MovieService.swift` | Add overloaded `details` method |
| `Sources/TMDb/Domain/Services/Movies/TMDbMovieService.swift` | Add implementation |
| `Sources/TMDb/Domain/Services/Movies/Requests/MovieRequest.swift` | Accept optional append query parameter |
| `Sources/TMDb/Domain/Services/TVSeries/TVSeriesService.swift` | Add overloaded `details` method |
| `Sources/TMDb/Domain/Services/TVSeries/TMDbTVSeriesService.swift` | Add implementation |
| `Sources/TMDb/Domain/Services/TVSeries/Requests/TVSeriesRequest.swift` | Accept optional append query parameter |
| `Sources/TMDb/Domain/Services/TVSeasons/TVSeasonService.swift` | Add overloaded `details` method |
| `Sources/TMDb/Domain/Services/TVSeasons/TMDbTVSeasonService.swift` | Add implementation |
| `Sources/TMDb/Domain/Services/TVEpisodes/TVEpisodeService.swift` | Add overloaded `details` method |
| `Sources/TMDb/Domain/Services/TVEpisodes/TMDbTVEpisodeService.swift` | Add implementation |
| `Sources/TMDb/Domain/Services/People/PersonService.swift` | Add overloaded `details` method |
| `Sources/TMDb/Domain/Services/People/TMDbPersonService.swift` | Add implementation |
| `Sources/TMDb/TMDb.docc/Extensions/MovieService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/Extensions/TVSeriesService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/Extensions/TVSeasonService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/Extensions/TVEpisodeService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/Extensions/PersonService.md` | Add method reference |
| `Sources/TMDb/TMDb.docc/TMDb.md` | Add new model types to topic sections |
| `README.md` | Document append-to-response capability |

### Test Files to Create

| File | Purpose |
|------|---------|
| `Tests/TMDbTests/Domain/Services/Movies/TMDbMovieServiceDetailsAppendTests.swift` | Unit test for movie details with appended data |
| `Tests/TMDbTests/Domain/Services/TVSeries/TMDbTVSeriesServiceDetailsAppendTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Services/TVSeasons/TMDbTVSeasonServiceDetailsAppendTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Services/TVEpisodes/TMDbTVEpisodeServiceDetailsAppendTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Services/People/TMDbPersonServiceDetailsAppendTests.swift` | Unit test |
| `Tests/TMDbTests/Domain/Models/MovieDetailsResponseTests.swift` | Decoding tests for flat JSON structure |
| `Tests/TMDbTests/Domain/Models/TVSeriesDetailsResponseTests.swift` | Decoding tests |
| `Tests/TMDbTests/Domain/Models/MovieAppendOptionTests.swift` | Query value generation tests |
| `Tests/TMDbTests/Mocks/Models/MovieDetailsResponse+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Mocks/Models/TVSeriesDetailsResponse+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Mocks/Models/TVSeasonDetailsResponse+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Mocks/Models/TVEpisodeDetailsResponse+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Mocks/Models/PersonDetailsResponse+Mocks.swift` | Mock data |
| `Tests/TMDbTests/Resources/json/movie-details-appended.json` | JSON fixture (fetch from live API using MCP) |
| `Tests/TMDbTests/Resources/json/tv-series-details-appended.json` | JSON fixture |
| `Tests/TMDbTests/Resources/json/tv-season-details-appended.json` | JSON fixture |
| `Tests/TMDbTests/Resources/json/tv-episode-details-appended.json` | JSON fixture |
| `Tests/TMDbTests/Resources/json/person-details-appended.json` | JSON fixture |

### Integration Test Files to Modify

| File | Change |
|------|--------|
| `Tests/TMDbIntegrationTests/MovieIntegrationTests.swift` | Add append-to-response test |
| `Tests/TMDbIntegrationTests/TVSeriesServiceTests.swift` | Add append-to-response test |
| `Tests/TMDbIntegrationTests/TVSeasonIntegrationTests.swift` | Add append-to-response test |
| `Tests/TMDbIntegrationTests/TVEpisodeIntegrationTests.swift` | Add append-to-response test |
| `Tests/TMDbIntegrationTests/PersonIntegrationTests.swift` | Add append-to-response test |

## Acceptance Criteria

- [ ] Each of the 5 detail endpoints has an overload accepting append
      options
- [ ] Option sets cover all appendable resources listed in the TMDb API
      spec
- [ ] Response wrappers correctly decode the flat JSON structure
- [ ] Existing `details()` methods remain unchanged (no breaking
      changes)
- [ ] Unit tests verify decoding of responses with various append
      combinations
- [ ] Integration tests confirm real API responses decode correctly
- [ ] DocC documentation covers the new types and method overloads
- [ ] `make ci` passes

## Dependencies

- None. This PRD is independent of PRD-001.
- **PRD-005 depends on this** — caching of appended responses is out
  of scope here but noted in PRD-005.

## Out of Scope

- Caching of appended data (see PRD-005)
- Type-safe enforcement that only requested fields are non-nil (the
  API returns all-or-nothing per appended key; unrequested keys will
  simply be `nil`)
- Builder-pattern or result-builder syntax for composing requests
