# Plan 5: TV Season & Episode Service Additions

**Priority:** MEDIUM
**Impact:** Medium - Extends TV coverage to season/episode level
**Effort:** Medium
**Dependencies:** Plan 1 (AccountStates model)

## Overview

Add missing TV Season and TV Episode Service endpoints to enable user interactions (ratings, account states) and improve metadata access (external IDs, translations, watch providers).

## TV Season Service - Missing Endpoints

### Critical - User Interaction (1 endpoint)

1. **GET /3/tv/{series_id}/season/{season_number}/account_states** - Get user states for season
   - Returns: `AccountStates` (reuse from Movies)
   - Requires: Session ID
   - Method: `accountStates(forSeason:inTVSeries:session:)`

### Important - Metadata (4 endpoints)

2. **GET /3/tv/{series_id}/season/{season_number}/external_ids** - Get season external IDs
   - Returns: External IDs (IMDb, TVDB, etc.)
   - Method: `externalLinks(forSeason:inTVSeries:)`

3. **GET /3/tv/{series_id}/season/{season_number}/translations** - Get season translations
   - Returns: `TranslationCollection<TVSeasonTranslationData>`
   - Method: `translations(forSeason:inTVSeries:)`

4. **GET /3/tv/{series_id}/season/{season_number}/watch/providers** - Get season watch providers
   - Returns: `ShowWatchProvidersByCountry`
   - Method: `watchProviders(forSeason:inTVSeries:)`

### Lower Priority - Changes (1 endpoint)

5. **GET /3/tv/season/{season_id}/changes** - Get season changes
   - Parameters: start_date, end_date, page
   - Returns: `ChangeCollection`
   - Method: `changes(forSeason:startDate:endDate:page:)`

---

## TV Episode Service - Missing Endpoints

### Critical - User Interaction (3 endpoints)

6. **GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/account_states**
   - Get user states for episode
   - Returns: `AccountStates`
   - Requires: Session ID
   - Method: `accountStates(forEpisode:inSeason:inTVSeries:session:)`

7. **POST /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/rating**
   - Rate an episode
   - Body: `{ value: 0.5-10.0 }`
   - Method: `addRating(value:episode:season:tvSeries:session:)`

8. **DELETE /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/rating**
   - Delete episode rating
   - Method: `deleteRating(forEpisode:inSeason:inTVSeries:session:)`

### Important - Metadata (2 endpoints)

9. **GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/external_ids**
   - Get episode external IDs
   - Returns: External IDs (IMDb, TVDB, etc.)
   - Method: `externalLinks(forEpisode:inSeason:inTVSeries:)`

10. **GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/translations**
    - Get episode translations
    - Returns: `TranslationCollection<TVEpisodeTranslationData>`
    - Method: `translations(forEpisode:inSeason:inTVSeries:)`

### Lower Priority - Changes (1 endpoint)

11. **GET /3/tv/episode/{episode_id}/changes** - Get episode changes
    - Parameters: start_date, end_date, page
    - Returns: `ChangeCollection`
    - Method: `changes(forEpisode:startDate:endDate:page:)`

---

## New Models Required

### 1. TVSeasonExternalLinksCollection

**File:** `Sources/TMDb/Domain/Models/TVSeasonExternalLinksCollection.swift`

```swift
public struct TVSeasonExternalLinksCollection: Codable, Equatable, Hashable, Sendable {
    public let id: Int?
    public let imdb: IMDbLink?
    public let tvdb: TVDBLink?
    public let wikidata: WikiDataLink?

    private enum CodingKeys: String, CodingKey {
        case id
        case imdb = "imdb_id"
        case tvdb = "tvdb_id"
        case wikidata = "wikidata_id"
    }
}
```

### 2. TVEpisodeExternalLinksCollection

**File:** `Sources/TMDb/Domain/Models/TVEpisodeExternalLinksCollection.swift`

```swift
public struct TVEpisodeExternalLinksCollection: Codable, Equatable, Hashable, Sendable {
    public let id: Int?
    public let imdb: IMDbLink?
    public let tvdb: TVDBLink?
    public let wikidata: WikiDataLink?

    private enum CodingKeys: String, CodingKey {
        case id
        case imdb = "imdb_id"
        case tvdb = "tvdb_id"
        case wikidata = "wikidata_id"
    }
}
```

### 3. TVDBLink

**File:** Add to `Sources/TMDb/Domain/Models/Link.swift` (if exists) or create new file

```swift
/// TVDB external link
public struct TVDBLink: Codable, Equatable, Hashable, Sendable {
    public let tvdbID: Int?

    public init(tvdbID: Int?) {
        self.tvdbID = tvdbID
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(), let id = try? container.decode(Int.self) {
            self.tvdbID = id
        } else {
            self.tvdbID = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(tvdbID)
    }
}
```

### 4. TVSeasonTranslationData

**File:** Add to `Sources/TMDb/Domain/Models/Translation.swift`

```swift
public struct TVSeasonTranslationData: Codable, Equatable, Hashable, Sendable {
    public let name: String
    public let overview: String
}
```

### 5. TVEpisodeTranslationData

**File:** Add to `Sources/TMDb/Domain/Models/Translation.swift`

```swift
public struct TVEpisodeTranslationData: Codable, Equatable, Hashable, Sendable {
    public let name: String
    public let overview: String
}
```

### Models Reused
- `AccountStates` (from Plan 1)
- `ChangeCollection` (from Plan 1)
- `TranslationCollection<T>` (from Plan 1)
- `ShowWatchProvidersByCountry` (exists)

---

## Service Protocol Updates

### TV Season Service

Update `Sources/TMDb/Domain/Services/TVSeasons/TVSeasonService.swift`:

```swift
public protocol TVSeasonService: Sendable {
    // ... existing methods ...

    /// Returns the user's rating, favorite, and watchlist state for a season
    func accountStates(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws -> AccountStates

    /// Returns external links for a season
    func externalLinks(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVSeasonExternalLinksCollection

    /// Returns translations for a season
    func translations(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TranslationCollection<TVSeasonTranslationData>

    /// Returns watch providers for a season
    func watchProviders(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> ShowWatchProvidersByCountry

    /// Returns change history for a season
    func changes(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection
}
```

### TV Episode Service

Update `Sources/TMDb/Domain/Services/TVEpisodes/TVEpisodeService.swift`:

```swift
public protocol TVEpisodeService: Sendable {
    // ... existing methods ...

    /// Returns the user's rating, favorite, and watchlist state for an episode
    func accountStates(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws -> AccountStates

    /// Adds a rating for an episode
    func addRating(
        _ rating: Double,
        toEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws

    /// Deletes the user's rating for an episode
    func deleteRating(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws

    /// Returns external links for an episode
    func externalLinks(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVEpisodeExternalLinksCollection

    /// Returns translations for an episode
    func translations(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TranslationCollection<TVEpisodeTranslationData>

    /// Returns change history for an episode
    func changes(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection
}
```

---

## Implementation Steps

### Phase 1: Season Account States & Metadata
1. Reuse `AccountStates` model from Movies plan
2. Create external links models (TVSeasonExternalLinksCollection, TVDBLink)
3. Create translation data models (TVSeasonTranslationData)
4. Implement `accountStates(forSeason:inTVSeries:session:)` method
5. Implement `externalLinks(forSeason:inTVSeries:)` method
6. Implement `translations(forSeason:inTVSeries:)` method
7. Implement `watchProviders(forSeason:inTVSeries:)` method
8. Add unit tests with JSON fixtures
9. Add integration tests

### Phase 2: Episode Account States & Ratings
1. Create episode external links model (TVEpisodeExternalLinksCollection)
2. Create translation data model (TVEpisodeTranslationData)
3. Implement `accountStates(forEpisode:inSeason:inTVSeries:session:)` method
4. Implement `addRating(_:toEpisode:inSeason:inTVSeries:session:)` method
5. Implement `deleteRating(forEpisode:inSeason:inTVSeries:session:)` method
6. Implement `externalLinks(forEpisode:inSeason:inTVSeries:)` method
7. Implement `translations(forEpisode:inSeason:inTVSeries:)` method
8. Add unit tests with JSON fixtures
9. Add integration tests

### Phase 3: Changes Tracking
1. Reuse Change models from Movies plan
2. Implement `changes(forSeason:startDate:endDate:page:)` method
3. Implement `changes(forEpisode:startDate:endDate:page:)` method
4. Add unit tests with JSON fixtures
5. Add integration tests

---

## Testing Requirements

### Unit Tests

**TV Season Tests (`Tests/TMDbTests/Services/TVSeasons/`):**
- `TMDbTVSeasonServiceAccountStatesTests.swift`
- `TMDbTVSeasonServiceExternalLinksTests.swift`
- `TMDbTVSeasonServiceTranslationsTests.swift`
- `TMDbTVSeasonServiceWatchProvidersTests.swift`
- `TMDbTVSeasonServiceChangesTests.swift`

**TV Episode Tests (`Tests/TMDbTests/Services/TVEpisodes/`):**
- `TMDbTVEpisodeServiceAccountStatesTests.swift`
- `TMDbTVEpisodeServiceRatingTests.swift`
- `TMDbTVEpisodeServiceExternalLinksTests.swift`
- `TMDbTVEpisodeServiceTranslationsTests.swift`
- `TMDbTVEpisodeServiceChangesTests.swift`

**JSON Fixtures (`Tests/TMDbTests/Resources/json/`):**
- `tv-season-account-states.json`
- `tv-season-external-links.json`
- `tv-season-translations.json`
- `tv-season-watch-providers.json`
- `tv-season-changes.json`
- `tv-episode-account-states.json`
- `tv-episode-external-links.json`
- `tv-episode-translations.json`
- `tv-episode-changes.json`

### Integration Tests

**Update Integration Tests:**
- `TVSeasonIntegrationTests.swift` - Add account states, external IDs, translations, watch providers
- `TVEpisodeIntegrationTests.swift` - Add account states, ratings, external IDs, translations

---

## Documentation Updates

### DocC Extensions

**Update `Sources/TMDb/TMDb.docc/Extensions/TVSeasonService.md`:**
```markdown
### User Interactions

- ``TVSeasonService/accountStates(forSeason:inTVSeries:session:)``

### Metadata

- ``TVSeasonService/externalLinks(forSeason:inTVSeries:)``
- ``TVSeasonService/translations(forSeason:inTVSeries:)``
- ``TVSeasonService/watchProviders(forSeason:inTVSeries:)``

### Change Tracking

- ``TVSeasonService/changes(forSeason:startDate:endDate:page:)``
```

**Update `Sources/TMDb/TMDb.docc/Extensions/TVEpisodeService.md`:**
```markdown
### User Interactions

- ``TVEpisodeService/accountStates(forEpisode:inSeason:inTVSeries:session:)``
- ``TVEpisodeService/addRating(_:toEpisode:inSeason:inTVSeries:session:)``
- ``TVEpisodeService/deleteRating(forEpisode:inSeason:inTVSeries:session:)``

### Metadata

- ``TVEpisodeService/externalLinks(forEpisode:inSeason:inTVSeries:)``
- ``TVEpisodeService/translations(forEpisode:inSeason:inTVSeries:)``

### Change Tracking

- ``TVEpisodeService/changes(forEpisode:startDate:endDate:page:)``
```

### New Model Documentation

Add to `Sources/TMDb/TMDb.docc/TMDb.md`:
```markdown
- ``TVSeasonExternalLinksCollection``
- ``TVEpisodeExternalLinksCollection``
- ``TVDBLink``
- ``TVSeasonTranslationData``
- ``TVEpisodeTranslationData``
```

---

## API Endpoints Reference

### TV Season
```
GET /3/tv/{series_id}/season/{season_number}/account_states?session_id={session_id}
GET /3/tv/{series_id}/season/{season_number}/external_ids
GET /3/tv/{series_id}/season/{season_number}/translations
GET /3/tv/{series_id}/season/{season_number}/watch/providers
GET /3/tv/season/{season_id}/changes?start_date={date}&end_date={date}&page={page}
```

### TV Episode
```
GET    /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/account_states?session_id={session_id}
POST   /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/rating?session_id={session_id}
DELETE /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/rating?session_id={session_id}
GET    /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/external_ids
GET    /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/translations
GET    /3/tv/episode/{episode_id}/changes?start_date={date}&end_date={date}&page={page}
```

---

## Verification Checklist

Before considering complete:
- [ ] All models created with full test coverage
- [ ] All 5 season methods implemented
- [ ] All 6 episode methods implemented
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation updated
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

---

## Impact Assessment

**User-Facing Benefits:**
- ✅ Users can rate individual episodes
- ✅ Complete external ID support for seasons/episodes
- ✅ Translations for seasons and episodes
- ✅ Watch provider info at season level

**API Coverage Improvement:**
- **TV Season:** 5/9 → 10/9 (100%+)
- **TV Episode:** 4/9 → 10/9 (100%+)

---

## Notes

- Episode rating follows same validation as movies/series (0.5-10.0, increments of 0.5)
- Season changes use season_id, not series_id + season_number
- Episode changes use episode_id, not series_id + season + episode
- TVDB links are important for cross-referencing with TVDB API
