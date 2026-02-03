# Plan 2: TV Series Service Additions

**Priority:** HIGHEST
**Impact:** High - TV series are core functionality with high user engagement
**Effort:** Medium
**Dependencies:** Models from Plan 1 (AccountStates, AlternativeTitle, Translation, Change)

## Overview

Add missing TV Series Service endpoints to enable user interactions (ratings, account states) and improve content discovery (keywords, alternative titles, translations, changes tracking).

## Missing Endpoints

### Critical - User Interaction (3 endpoints)

1. **GET /3/tv/{series_id}/account_states** - Get user's rating/favorite/watchlist state
   - Returns: `AccountStates` (reuse from Movies)
   - Requires: Session ID
   - Method: `accountStates(forTVSeries:session:)`

2. **POST /3/tv/{series_id}/rating** - Rate a TV series
   - Body: `{ value: 0.5-10.0 }` (increments of 0.5)
   - Requires: Session ID or Guest Session ID
   - Method: `addRating(value:tvSeries:session:)`

3. **DELETE /3/tv/{series_id}/rating** - Delete TV series rating
   - Requires: Session ID or Guest Session ID
   - Method: `deleteRating(forTVSeries:session:)`

### Important - Content Discovery (7 endpoints)

4. **GET /3/tv/{series_id}/keywords** - Get keywords for TV series
   - Returns: `{ id, results: [{ id, name }] }`
   - Method: `keywords(forTVSeries:)`

5. **GET /3/tv/{series_id}/alternative_titles** - Get alternative titles
   - Returns: `{ id, results: [{ iso_3166_1, title, type }] }`
   - Method: `alternativeTitles(forTVSeries:)`

6. **GET /3/tv/{series_id}/translations** - Get TV translations
   - Returns: `{ id, translations: [...] }`
   - Method: `translations(forTVSeries:)`

7. **GET /3/tv/{series_id}/lists** - Get lists containing this series
   - Returns: Pageable list of `MediaList`
   - Method: `lists(forTVSeries:page:)`

### Lower Priority - Metadata (3 endpoints)

8. **GET /3/tv/{series_id}/changes** - Get series changes by date range
   - Parameters: start_date, end_date, page
   - Returns: Change entries with keys and values
   - Method: `changes(forTVSeries:startDate:endDate:page:)`

9. **GET /3/tv/latest** - Get latest TV series added to TMDb
   - Returns: Full `TVSeries` object
   - Method: `latest()`

10. **GET /3/tv/changes** - Get list of TV IDs that changed
    - Parameters: start_date, end_date, page
    - Returns: `ChangedIDCollection` (reuse from Movies)
    - Method: `changes(startDate:endDate:page:)`

## New Models Required

### 1. KeywordCollection
```swift
public struct KeywordCollection: Codable, Equatable, Hashable, Sendable {
    public let id: Int
    public let results: [Keyword]
}
```

**Location:** `Sources/TMDb/Domain/Models/KeywordCollection.swift`

**Note:** `Keyword` model already exists

### 2. TVSeriesTranslationData
```swift
public struct TVSeriesTranslationData: Codable, Equatable, Hashable, Sendable {
    public let name: String
    public let overview: String
    public let homepage: String?
    public let tagline: String?
}
```

**Location:** Add to `Sources/TMDb/Domain/Models/Translation.swift`

### Models Reused from Plan 1
- `AccountStates`
- `AlternativeTitle` / `AlternativeTitleCollection`
- `Translation<T>` / `TranslationCollection<T>`
- `Change` / `ChangeCollection`
- `ChangedIDCollection`

## Service Protocol Updates

Update `Sources/TMDb/Domain/Services/TVSeries/TVSeriesService.swift`:

```swift
public protocol TVSeriesService: Sendable {
    // ... existing methods ...

    /// Returns the user's rating, favorite, and watchlist state for a TV series
    func accountStates(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws -> AccountStates

    /// Adds a rating for a TV series
    func addRating(_ rating: Double, toTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws

    /// Deletes the user's rating for a TV series
    func deleteRating(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws

    /// Returns keywords for a TV series
    func keywords(forTVSeries tvSeriesID: TVSeries.ID) async throws -> KeywordCollection

    /// Returns alternative titles for a TV series
    func alternativeTitles(forTVSeries tvSeriesID: TVSeries.ID) async throws -> AlternativeTitleCollection

    /// Returns translations for a TV series
    func translations(forTVSeries tvSeriesID: TVSeries.ID) async throws -> TranslationCollection<TVSeriesTranslationData>

    /// Returns lists that contain the TV series
    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> MediaPageableList

    /// Returns change history for a TV series
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    /// Returns the latest TV series added to TMDb
    func latest() async throws -> TVSeries

    /// Returns a list of TV series IDs that have changed
    func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection
}
```

## Implementation Steps

### Phase 1: Account States & Ratings (Critical)
1. Reuse `AccountStates` model from Movies plan
2. Implement `accountStates(forTVSeries:session:)` method
3. Implement `addRating(_:toTVSeries:session:)` method with validation
4. Implement `deleteRating(forTVSeries:session:)` method
5. Add unit tests with JSON fixtures
6. Add integration tests

### Phase 2: Keywords, Alternative Titles & Translations
1. Create `KeywordCollection` model
2. Create `TVSeriesTranslationData` model
3. Implement `keywords(forTVSeries:)` method
4. Implement `alternativeTitles(forTVSeries:)` method
5. Implement `translations(forTVSeries:)` method
6. Implement `lists(forTVSeries:page:language:)` method
7. Add unit tests with JSON fixtures
8. Add integration tests

### Phase 3: Changes Tracking
1. Reuse Change models from Movies plan
2. Implement `changes(forTVSeries:startDate:endDate:page:)` method
3. Implement `changes(startDate:endDate:page:)` method
4. Implement `latest()` method
5. Add unit tests with JSON fixtures
6. Add integration tests

## Testing Requirements

### Unit Tests (`Tests/TMDbTests/Services/TVSeries/`)

Create test files:
- `TMDbTVSeriesServiceAccountStatesTests.swift` - Account states tests
- `TMDbTVSeriesServiceRatingTests.swift` - Rating add/delete tests
- `TMDbTVSeriesServiceKeywordsTests.swift` - Keywords tests
- `TMDbTVSeriesServiceAlternativeTitlesTests.swift` - Alternative titles tests
- `TMDbTVSeriesServiceTranslationsTests.swift` - Translations tests
- `TMDbTVSeriesServiceListsTests.swift` - Lists containing series tests
- `TMDbTVSeriesServiceChangesTests.swift` - Changes tracking tests

JSON Fixtures (`Tests/TMDbTests/Resources/json/`):
- `tv-series-account-states.json`
- `tv-series-keywords.json`
- `tv-series-alternative-titles.json`
- `tv-series-translations.json`
- `tv-series-lists.json`
- `tv-series-changes.json`
- `tv-series-changes-list.json`
- `tv-series-latest.json`

### Integration Tests (`Tests/TMDbIntegrationTests/`)

Add to `TVSeriesIntegrationTests.swift`:
- Test account states retrieval
- Test rating add/delete (cleanup required)
- Test keywords retrieval
- Test alternative titles
- Test translations
- Test lists containing series
- Test changes (if available)
- Test latest series

## Documentation Updates

### DocC Extensions

Update `Sources/TMDb/TMDb.docc/Extensions/TVSeriesService.md`:

Add new topic groups:
```markdown
### User Interactions

- ``TVSeriesService/accountStates(forTVSeries:session:)``
- ``TVSeriesService/addRating(_:toTVSeries:session:)``
- ``TVSeriesService/deleteRating(forTVSeries:session:)``

### Content Discovery

- ``TVSeriesService/keywords(forTVSeries:)``
- ``TVSeriesService/alternativeTitles(forTVSeries:)``
- ``TVSeriesService/translations(forTVSeries:)``
- ``TVSeriesService/lists(forTVSeries:page:language:)``

### Change Tracking

- ``TVSeriesService/changes(forTVSeries:startDate:endDate:page:)``
- ``TVSeriesService/changes(startDate:endDate:page:)``
- ``TVSeriesService/latest()``
```

### New Model Documentation

Add to `Sources/TMDb/TMDb.docc/TMDb.md`:

Under "### Models":
```markdown
- ``KeywordCollection``
- ``TVSeriesTranslationData``
```

## API Endpoints Reference

```
GET  /3/tv/{series_id}/account_states?session_id={session_id}
POST /3/tv/{series_id}/rating?session_id={session_id}
      Body: { "value": 8.5 }
DELETE /3/tv/{series_id}/rating?session_id={session_id}
GET  /3/tv/{series_id}/keywords
GET  /3/tv/{series_id}/alternative_titles
GET  /3/tv/{series_id}/translations
GET  /3/tv/{series_id}/lists?page={page}
GET  /3/tv/{series_id}/changes?start_date={date}&end_date={date}&page={page}
GET  /3/tv/latest
GET  /3/tv/changes?start_date={date}&end_date={date}&page={page}
```

## Verification Checklist

Before considering complete:
- [ ] All models created with full test coverage
- [ ] All 10 methods implemented in TMDbTVSeriesService
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation updated and building without warnings
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

## Impact Assessment

**User-Facing Benefits:**
- ✅ Users can rate TV series and manage ratings
- ✅ Users can check their interaction state with TV series
- ✅ Keywords enable better content categorization
- ✅ Improved internationalization with alternative titles and translations
- ✅ Apps can track changes for caching/sync

**API Coverage Improvement:**
- Before: 14/23 endpoints (61%)
- After: 24/23 endpoints (100%+) - Note: episodeGroups already implemented

## Notes

- Rating validation: 0.5 to 10.0 in increments of 0.5
- Session ID supports both user sessions and guest sessions
- Changes tracking requires date range (max 14 days)
- Keywords are distinct from genres - provide more granular categorization
