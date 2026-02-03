# Plan 1: Movie Service Additions

**Priority:** HIGHEST
**Impact:** High - Movies are core functionality with high user engagement
**Effort:** Medium
**Dependencies:** None

## Overview

Add missing Movie Service endpoints to enable user interactions (ratings, account states) and improve content discovery (alternative titles, translations, changes tracking).

## Missing Endpoints

### Critical - User Interaction (9 endpoints)

1. **GET /3/movie/{movie_id}/account_states** - Get user's rating/favorite/watchlist state
   - Returns: `{ id, favorite, rated: { value }, watchlist }`
   - Requires: Session ID
   - Method: `accountStates(forMovie:session:)`

2. **POST /3/movie/{movie_id}/rating** - Rate a movie
   - Body: `{ value: 0.5-10.0 }` (increments of 0.5)
   - Requires: Session ID or Guest Session ID
   - Method: `addRating(value:movie:session:)`

3. **DELETE /3/movie/{movie_id}/rating** - Delete movie rating
   - Requires: Session ID or Guest Session ID
   - Method: `deleteRating(forMovie:session:)`

### Important - Content Discovery (5 endpoints)

4. **GET /3/movie/{movie_id}/alternative_titles** - Get alternative titles by country
   - Returns: `{ id, titles: [{ iso_3166_1, title, type }] }`
   - Optional: country filter
   - Method: `alternativeTitles(forMovie:country:)`

5. **GET /3/movie/{movie_id}/translations** - Get movie translations
   - Returns: `{ id, translations: [{ iso_3166_1, iso_639_1, name, english_name, data }] }`
   - Method: `translations(forMovie:)`

6. **GET /3/movie/{movie_id}/lists** - Get lists containing this movie
   - Returns: Pageable list of `MediaList`
   - Method: `lists(forMovie:page:)`

### Lower Priority - Metadata (3 endpoints)

7. **GET /3/movie/{movie_id}/changes** - Get movie changes by date range
   - Parameters: start_date, end_date, page
   - Returns: Change entries with keys and values
   - Method: `changes(forMovie:startDate:endDate:page:)`

8. **GET /3/movie/latest** - Get latest movie added to TMDb
   - Returns: Full `Movie` object
   - Method: `latest()`

9. **GET /3/movie/changes** - Get list of movie IDs that changed
   - Parameters: start_date, end_date, page
   - Returns: `{ results: [{ id, adult }], ... }`
   - Method: `changes(startDate:endDate:page:)`

## New Models Required

### 1. AccountStates
```swift
public struct AccountStates: Codable, Equatable, Hashable, Sendable {
    public let id: Int
    public let favorite: Bool
    public let rated: RatedValue?
    public let watchlist: Bool

    public struct RatedValue: Codable, Equatable, Hashable, Sendable {
        public let value: Double
    }
}
```

**Location:** `Sources/TMDb/Domain/Models/AccountStates.swift`

### 2. AlternativeTitle
```swift
public struct AlternativeTitle: Codable, Equatable, Hashable, Sendable {
    public let iso3166_1: String
    public let title: String
    public let type: String?
}

public struct AlternativeTitleCollection: Codable, Equatable, Hashable, Sendable {
    public let id: Int
    public let titles: [AlternativeTitle]
}
```

**Location:** `Sources/TMDb/Domain/Models/AlternativeTitle.swift`

### 3. Translation & TranslationData
```swift
public struct Translation<DataType: Codable & Equatable & Hashable & Sendable>:
    Codable, Equatable, Hashable, Sendable {
    public let iso3166_1: String
    public let iso639_1: String
    public let name: String
    public let englishName: String
    public let data: DataType
}

public struct MovieTranslationData: Codable, Equatable, Hashable, Sendable {
    public let title: String
    public let overview: String
    public let homepage: String?
    public let tagline: String?
}

public struct TranslationCollection<DataType: Codable & Equatable & Hashable & Sendable>:
    Codable, Equatable, Hashable, Sendable {
    public let id: Int
    public let translations: [Translation<DataType>]
}
```

**Location:** `Sources/TMDb/Domain/Models/Translation.swift`

### 4. Change Models
```swift
public struct Change: Codable, Equatable, Hashable, Sendable {
    public let key: String
    public let items: [ChangeItem]
}

public struct ChangeItem: Codable, Equatable, Hashable, Sendable {
    public let id: String
    public let action: String
    public let time: Date
    public let iso639_1: String?
    public let iso3166_1: String?
    public let value: AnyCodable?
    public let originalValue: AnyCodable?
}

public struct ChangeCollection: Codable, Equatable, Hashable, Sendable {
    public let changes: [Change]
}

public struct ChangedID: Codable, Equatable, Hashable, Sendable {
    public let id: Int
    public let adult: Bool?
}

public struct ChangedIDCollection: Codable, Equatable, Hashable, Sendable {
    public let results: [ChangedID]
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
}
```

**Location:** `Sources/TMDb/Domain/Models/Change.swift`

**Note:** Requires `AnyCodable` wrapper for dynamic JSON values

### 5. RatingRequest
```swift
struct RatingRequest: Codable {
    let value: Double
}
```

**Location:** Internal to service implementation

## Service Protocol Updates

Update `Sources/TMDb/Domain/Services/Movies/MovieService.swift`:

```swift
public protocol MovieService: Sendable {
    // ... existing methods ...

    /// Returns the user's rating, favorite, and watchlist state for a movie
    func accountStates(forMovie movieID: Movie.ID, session: Session) async throws -> AccountStates

    /// Adds a rating for a movie
    func addRating(_ rating: Double, toMovie movieID: Movie.ID, session: Session) async throws

    /// Deletes the user's rating for a movie
    func deleteRating(forMovie movieID: Movie.ID, session: Session) async throws

    /// Returns alternative titles for a movie
    func alternativeTitles(
        forMovie movieID: Movie.ID,
        country: String?,
        language: String?
    ) async throws -> AlternativeTitleCollection

    /// Returns translations for a movie
    func translations(forMovie movieID: Movie.ID) async throws -> TranslationCollection<MovieTranslationData>

    /// Returns lists that contain the movie
    func lists(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws -> MediaPageableList

    /// Returns change history for a movie
    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    /// Returns the latest movie added to TMDb
    func latest() async throws -> Movie

    /// Returns a list of movie IDs that have changed
    func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection
}
```

## Implementation Steps

### Phase 1: Account States & Ratings (Critical)
1. Create `AccountStates` model with tests
2. Implement `accountStates(forMovie:session:)` method
3. Implement `addRating(_:toMovie:session:)` method with validation (0.5-10.0, increments of 0.5)
4. Implement `deleteRating(forMovie:session:)` method
5. Add unit tests with JSON fixtures
6. Add integration tests

### Phase 2: Alternative Titles & Translations
1. Create `AlternativeTitle` and `Translation` models
2. Implement `alternativeTitles(forMovie:country:language:)` method
3. Implement `translations(forMovie:)` method
4. Implement `lists(forMovie:page:language:)` method
5. Add unit tests with JSON fixtures
6. Add integration tests

### Phase 3: Changes Tracking
1. Create `Change`, `ChangeItem`, and `ChangedID` models
2. Create `AnyCodable` helper for dynamic values
3. Implement `changes(forMovie:startDate:endDate:page:)` method
4. Implement `changes(startDate:endDate:page:)` method
5. Implement `latest()` method
6. Add unit tests with JSON fixtures
7. Add integration tests

## Testing Requirements

### Unit Tests (`Tests/TMDbTests/Services/Movies/`)

Create test files:
- `TMDbMovieServiceAccountStatesTests.swift` - Account states tests
- `TMDbMovieServiceRatingTests.swift` - Rating add/delete tests
- `TMDbMovieServiceAlternativeTitlesTests.swift` - Alternative titles tests
- `TMDbMovieServiceTranslationsTests.swift` - Translations tests
- `TMDbMovieServiceListsTests.swift` - Lists containing movie tests
- `TMDbMovieServiceChangesTests.swift` - Changes tracking tests

JSON Fixtures (`Tests/TMDbTests/Resources/json/`):
- `movie-account-states.json`
- `movie-alternative-titles.json`
- `movie-translations.json`
- `movie-lists.json`
- `movie-changes.json`
- `movie-changes-list.json`
- `movie-latest.json`

### Integration Tests (`Tests/TMDbIntegrationTests/`)

Add to `MovieIntegrationTests.swift`:
- Test account states retrieval
- Test rating add/delete (cleanup required)
- Test alternative titles
- Test translations
- Test lists containing movie
- Test changes (if available)
- Test latest movie

## Documentation Updates

### DocC Extensions

Update `Sources/TMDb/TMDb.docc/Extensions/MovieService.md`:

Add new topic groups:
```markdown
### User Interactions

- ``MovieService/accountStates(forMovie:session:)``
- ``MovieService/addRating(_:toMovie:session:)``
- ``MovieService/deleteRating(forMovie:session:)``

### Content Discovery

- ``MovieService/alternativeTitles(forMovie:country:language:)``
- ``MovieService/translations(forMovie:)``
- ``MovieService/lists(forMovie:page:language:)``

### Change Tracking

- ``MovieService/changes(forMovie:startDate:endDate:page:)``
- ``MovieService/changes(startDate:endDate:page:)``
- ``MovieService/latest()``
```

### New Model Documentation

Add to `Sources/TMDb/TMDb.docc/TMDb.md`:

Under "### Models":
```markdown
- ``AccountStates``
- ``AlternativeTitle``
- ``AlternativeTitleCollection``
- ``Translation``
- ``TranslationCollection``
- ``MovieTranslationData``
- ``Change``
- ``ChangeItem``
- ``ChangeCollection``
- ``ChangedID``
- ``ChangedIDCollection``
```

## API Endpoints Reference

```
GET  /3/movie/{movie_id}/account_states?session_id={session_id}
POST /3/movie/{movie_id}/rating?session_id={session_id}
      Body: { "value": 8.5 }
DELETE /3/movie/{movie_id}/rating?session_id={session_id}
GET  /3/movie/{movie_id}/alternative_titles?country={country}
GET  /3/movie/{movie_id}/translations
GET  /3/movie/{movie_id}/lists?page={page}
GET  /3/movie/{movie_id}/changes?start_date={date}&end_date={date}&page={page}
GET  /3/movie/latest
GET  /3/movie/changes?start_date={date}&end_date={date}&page={page}
```

## Verification Checklist

Before considering complete:
- [ ] All models created with full test coverage
- [ ] All 9 methods implemented in TMDbMovieService
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation updated and building without warnings
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

## Impact Assessment

**User-Facing Benefits:**
- ✅ Users can rate movies and manage ratings
- ✅ Users can check their interaction state with movies
- ✅ Improved internationalization with alternative titles and translations
- ✅ Apps can track changes for caching/sync

**API Coverage Improvement:**
- Before: 15/24 endpoints (63%)
- After: 24/24 endpoints (100%)

## Notes

- Rating validation: 0.5 to 10.0 in increments of 0.5
- Session ID supports both user sessions and guest sessions
- Changes tracking requires date range (max 14 days)
- Alternative titles can be filtered by country (ISO 3166-1)
