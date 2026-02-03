# Plan 4: Account Service Additions

**Priority:** HIGH
**Impact:** High - Enables complete user interaction features
**Effort:** Low
**Dependencies:** Plan 1 (AccountStates model)

## Overview

Add missing Account Service endpoints to enable users to retrieve their ratings and TV watchlist. This completes the account management functionality.

## Missing Endpoints

### Critical - User Ratings (3 endpoints)

1. **GET /3/account/{account_id}/rated/movies** - Get user's rated movies
   - Parameters: sort_by, page, session_id
   - Returns: `MoviePageableList` with ratings
   - Method: `ratedMovies(sortedBy:page:accountID:session:)`

2. **GET /3/account/{account_id}/rated/tv** - Get user's rated TV series
   - Parameters: sort_by, page, session_id
   - Returns: `TVSeriesPageableList` with ratings
   - Method: `ratedTVSeries(sortedBy:page:accountID:session:)`

3. **GET /3/account/{account_id}/rated/tv/episodes** - Get user's rated TV episodes
   - Parameters: sort_by, page, session_id
   - Returns: `TVEpisodePageableList` with ratings
   - Method: `ratedTVEpisodes(sortedBy:page:accountID:session:)`

### Important - Watchlist (1 endpoint)

4. **GET /3/account/{account_id}/watchlist/tv** - Get TV series watchlist
   - Parameters: sort_by, page, session_id
   - Returns: `TVSeriesPageableList`
   - Method: `tvSeriesWatchlist(sortedBy:page:accountID:session:)`

### Lower Priority - User Lists (1 endpoint)

5. **GET /3/account/{account_id}/lists** - Get user's custom lists
   - Parameters: page, session_id
   - Returns: Pageable list of `MediaList`
   - Method: `lists(page:accountID:session:)`

## Models Required

### 1. RatedSort Enum

**File:** `Sources/TMDb/Domain/Models/RatedSort.swift`

```swift
/// Sort order for rated content
public enum RatedSort: String, Codable, Sendable {
    /// Sort by creation date (when rated)
    case createdAtAscending = "created_at.asc"
    case createdAtDescending = "created_at.desc"
}
```

### 2. TVEpisodePageableList

**File:** `Sources/TMDb/Domain/Models/TVEpisodePageableList.swift`

```swift
/// Pageable list of TV episodes
public typealias TVEpisodePageableList = PageableListResult<TVEpisode>
```

### 3. MediaListPageableList

**File:** `Sources/TMDb/Domain/Models/MediaListPageableList.swift`

```swift
/// Pageable list of media lists
public typealias MediaListPageableList = PageableListResult<MediaList>
```

### Models Reused
- `MoviePageableList` (exists)
- `TVSeriesPageableList` (exists)
- `FavouriteSort` (exists - can be reused for watchlist)
- `MediaList` (exists)

---

## Service Protocol Updates

Update `Sources/TMDb/Domain/Services/Account/AccountService.swift`:

```swift
public protocol AccountService: Sendable {
    // ... existing methods ...

    /// Returns movies rated by the user
    func ratedMovies(
        sortedBy: RatedSort?,
        page: Int?,
        accountID: Int?,
        session: Session
    ) async throws -> MoviePageableList

    /// Returns TV series rated by the user
    func ratedTVSeries(
        sortedBy: RatedSort?,
        page: Int?,
        accountID: Int?,
        session: Session
    ) async throws -> TVSeriesPageableList

    /// Returns TV episodes rated by the user
    func ratedTVEpisodes(
        sortedBy: RatedSort?,
        page: Int?,
        accountID: Int?,
        session: Session
    ) async throws -> TVEpisodePageableList

    /// Returns TV series in the user's watchlist
    func tvSeriesWatchlist(
        sortedBy: WatchlistSort?,
        page: Int?,
        accountID: Int?,
        session: Session
    ) async throws -> TVSeriesPageableList

    /// Returns user's custom lists
    func lists(
        page: Int?,
        accountID: Int?,
        session: Session
    ) async throws -> MediaListPageableList
}
```

---

## Implementation Steps

### Phase 1: Create Models
1. Create `RatedSort` enum
2. Create `TVEpisodePageableList` typealias
3. Create `MediaListPageableList` typealias
4. Add unit tests for models

### Phase 2: Implement Methods
1. Implement `ratedMovies(sortedBy:page:accountID:session:)` method
2. Implement `ratedTVSeries(sortedBy:page:accountID:session:)` method
3. Implement `ratedTVEpisodes(sortedBy:page:accountID:session:)` method
4. Implement `tvSeriesWatchlist(sortedBy:page:accountID:session:)` method
5. Implement `lists(page:accountID:session:)` method
6. Add default parameter handling for accountID (fetch from session if nil)

### Phase 3: Testing
1. Add unit tests with JSON fixtures
2. Add integration tests (requires rating content first)
3. Test sorting options
4. Test pagination

---

## Testing Requirements

### Unit Tests (`Tests/TMDbTests/Services/Account/`)

**Create Test Files:**
- `TMDbAccountServiceRatedMoviesTests.swift` - Rated movies tests
- `TMDbAccountServiceRatedTVSeriesTests.swift` - Rated TV tests
- `TMDbAccountServiceRatedTVEpisodesTests.swift` - Rated episodes tests
- `TMDbAccountServiceTVSeriesWatchlistTests.swift` - TV watchlist tests
- `TMDbAccountServiceListsTests.swift` - User lists tests

**JSON Fixtures (`Tests/TMDbTests/Resources/json/`):**
- `account-rated-movies.json`
- `account-rated-tv.json`
- `account-rated-tv-episodes.json`
- `account-watchlist-tv.json`
- `account-lists.json`

### Integration Tests (`Tests/TMDbIntegrationTests/`)

**Update `AccountIntegrationTests.swift`:**
- Test rated movies retrieval (requires pre-rated content)
- Test rated TV series retrieval
- Test rated TV episodes retrieval
- Test TV watchlist retrieval
- Test user lists retrieval
- Test sorting options
- Test pagination

**Setup Requirements:**
- Integration tests may need to rate some content before retrieving
- Consider using cleanup in tearDown to remove test ratings

---

## Documentation Updates

### DocC Extensions

Update `Sources/TMDb/TMDb.docc/Extensions/AccountService.md`:

Add new topic groups:
```markdown
### User Ratings

- ``AccountService/ratedMovies(sortedBy:page:accountID:session:)``
- ``AccountService/ratedTVSeries(sortedBy:page:accountID:session:)``
- ``AccountService/ratedTVEpisodes(sortedBy:page:accountID:session:)``

### Watchlist

- ``AccountService/movieWatchlist(sortedBy:page:accountID:session:)`` (existing)
- ``AccountService/tvSeriesWatchlist(sortedBy:page:accountID:session:)`` (new)

### Custom Lists

- ``AccountService/lists(page:accountID:session:)``
```

### New Model Documentation

Add to `Sources/TMDb/TMDb.docc/TMDb.md`:

Under "### Models":
```markdown
- ``RatedSort``
- ``TVEpisodePageableList``
- ``MediaListPageableList``
```

---

## API Endpoints Reference

```
GET /3/account/{account_id}/rated/movies?sort_by={sort}&page={page}&session_id={session_id}
GET /3/account/{account_id}/rated/tv?sort_by={sort}&page={page}&session_id={session_id}
GET /3/account/{account_id}/rated/tv/episodes?sort_by={sort}&page={page}&session_id={session_id}
GET /3/account/{account_id}/watchlist/tv?sort_by={sort}&page={page}&session_id={session_id}
GET /3/account/{account_id}/lists?page={page}&session_id={session_id}
```

**Sort Options:**
- Rated content: `created_at.asc`, `created_at.desc`
- Watchlist: Same as favorites (`created_at.asc`, `created_at.desc`)

---

## Implementation Notes

### Account ID Handling

Follow existing pattern:
```swift
func ratedMovies(
    sortedBy: RatedSort? = nil,
    page: Int? = nil,
    accountID: Int? = nil,
    session: Session
) async throws -> MoviePageableList {
    // Fetch account ID from session if not provided
    let accountID = try await resolveAccountID(accountID, session: session)
    // ... implementation
}
```

### Rating Metadata

Rated content includes the user's rating in the response:
```json
{
  "id": 550,
  "title": "Fight Club",
  ...
  "rating": 8.5
}
```

Ensure models support this extra property or use a wrapper type.

---

## Verification Checklist

Before considering complete:
- [ ] All models created with full test coverage
- [ ] All 5 methods implemented in TMDbAccountService
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation updated and building without warnings
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

---

## Impact Assessment

**User-Facing Benefits:**
- ✅ Users can retrieve all their ratings in one place
- ✅ Complete watchlist functionality (movies + TV)
- ✅ Access to user's custom lists
- ✅ Sorting and pagination support

**API Coverage Improvement:**
- Before: 7/11 endpoints (64%)
- After: 12/11 endpoints (100%+) - watchlist TV was missing

---

## Notes

- Rating values are returned with rated content (check model compatibility)
- Lists endpoint returns user's custom lists, not lists containing specific media
- Sort options differ from favorites/watchlist (created_at vs added_at)
- accountID can be omitted - fetched from session if needed
