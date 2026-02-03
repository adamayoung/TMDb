# Plan 9: Changes Service Creation

**Priority:** LOW
**Impact:** Low - Specialized sync/caching use case
**Effort:** Medium
**Dependencies:** Plan 1 (Change models)

## Overview

Create a new ChangesService to centralize all change tracking endpoints. This service enables applications to track changes to movies, TV series, people, seasons, and episodes over time - critical for sync and caching strategies.

---

## Purpose

The Changes Service provides endpoints to:
1. Get lists of IDs that have changed (for bulk sync)
2. Get detailed change history for individual entities (for granular updates)

This is essential for applications that cache TMDb data and need to keep it in sync.

---

## Endpoints

### Entity Change Lists (3 endpoints)

1. **GET /3/movie/changes** - Get list of movie IDs that changed
   - Parameters: start_date, end_date, page
   - Returns: `ChangedIDCollection`
   - Method: `movieChanges(startDate:endDate:page:)`

2. **GET /3/tv/changes** - Get list of TV series IDs that changed
   - Parameters: start_date, end_date, page
   - Returns: `ChangedIDCollection`
   - Method: `tvSeriesChanges(startDate:endDate:page:)`

3. **GET /3/person/changes** - Get list of person IDs that changed
   - Parameters: start_date, end_date, page
   - Returns: `ChangedIDCollection`
   - Method: `personChanges(startDate:endDate:page:)`

### Detailed Change History (5 endpoints)

4. **GET /3/movie/{movie_id}/changes** - Get movie change details
   - Parameters: movie_id, start_date, end_date, page
   - Returns: `ChangeCollection`
   - Method: `movieDetails(forMovie:startDate:endDate:page:)`

5. **GET /3/tv/{series_id}/changes** - Get TV series change details
   - Parameters: series_id, start_date, end_date, page
   - Returns: `ChangeCollection`
   - Method: `tvSeriesDetails(forTVSeries:startDate:endDate:page:)`

6. **GET /3/person/{person_id}/changes** - Get person change details
   - Parameters: person_id, start_date, end_date, page
   - Returns: `ChangeCollection`
   - Method: `personDetails(forPerson:startDate:endDate:page:)`

7. **GET /3/tv/season/{season_id}/changes** - Get season change details
   - Parameters: season_id, start_date, end_date, page
   - Returns: `ChangeCollection`
   - Method: `tvSeasonDetails(forSeason:startDate:endDate:page:)`

8. **GET /3/tv/episode/{episode_id}/changes** - Get episode change details
   - Parameters: episode_id, start_date, end_date, page
   - Returns: `ChangeCollection`
   - Method: `tvEpisodeDetails(forEpisode:startDate:endDate:page:)`

---

## Models Required

All models already defined in Plan 1:
- `Change`
- `ChangeItem`
- `ChangeCollection`
- `ChangedID`
- `ChangedIDCollection`
- `AnyCodable` (for dynamic JSON values)

---

## Service Protocol

**File:** `Sources/TMDb/Domain/Services/Changes/ChangesService.swift`

```swift
/// Provides change tracking for TMDb entities
///
/// The Changes Service enables applications to track updates to movies, TV series,
/// people, seasons, and episodes over time. This is essential for maintaining
/// synchronized caches and detecting content updates.
public protocol ChangesService: Sendable {
    // MARK: - Entity Change Lists

    /// Returns a list of movie IDs that have changed within a date range
    ///
    /// Use this to identify which movies have been updated and need to be refreshed.
    ///
    /// - Parameters:
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Pageable list of changed movie IDs
    func movieChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection

    /// Returns a list of TV series IDs that have changed within a date range
    ///
    /// Use this to identify which TV series have been updated and need to be refreshed.
    ///
    /// - Parameters:
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Pageable list of changed TV series IDs
    func tvSeriesChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection

    /// Returns a list of person IDs that have changed within a date range
    ///
    /// Use this to identify which people have been updated and need to be refreshed.
    ///
    /// - Parameters:
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Pageable list of changed person IDs
    func personChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection

    // MARK: - Detailed Change History

    /// Returns detailed change history for a movie
    ///
    /// Shows exactly what properties changed and their old/new values.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Collection of changes with keys and values
    func movieDetails(
        forMovie movieID: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    /// Returns detailed change history for a TV series
    ///
    /// Shows exactly what properties changed and their old/new values.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Collection of changes with keys and values
    func tvSeriesDetails(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    /// Returns detailed change history for a person
    ///
    /// Shows exactly what properties changed and their old/new values.
    ///
    /// - Parameters:
    ///   - personID: The person identifier
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Collection of changes with keys and values
    func personDetails(
        forPerson personID: Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    /// Returns detailed change history for a TV season
    ///
    /// Shows exactly what properties changed and their old/new values.
    ///
    /// - Parameters:
    ///   - seasonID: The season identifier
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Collection of changes with keys and values
    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    /// Returns detailed change history for a TV episode
    ///
    /// Shows exactly what properties changed and their old/new values.
    ///
    /// - Parameters:
    ///   - episodeID: The episode identifier
    ///   - startDate: Start of date range (max 14 days from endDate)
    ///   - endDate: End of date range
    ///   - page: Page number (1-1000)
    /// - Returns: Collection of changes with keys and values
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection
}
```

---

## Implementation

**File:** `Sources/TMDb/Domain/Services/Changes/TMDbChangesService.swift`

```swift
final class TMDbChangesService: ChangesService {
    private let apiClient: TMDbAPIClient

    init(apiClient: TMDbAPIClient) {
        self.apiClient = apiClient
    }

    // MARK: - Entity Change Lists

    func movieChanges(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        let path = "/movie/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangedIDCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    func tvSeriesChanges(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        let path = "/tv/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangedIDCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    func personChanges(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        let path = "/person/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangedIDCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    // MARK: - Detailed Change History

    func movieDetails(
        forMovie movieID: Movie.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        let path = "/movie/\(movieID)/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangeCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    func tvSeriesDetails(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        let path = "/tv/\(tvSeriesID)/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangeCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    func personDetails(
        forPerson personID: Person.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        let path = "/person/\(personID)/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangeCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        let path = "/tv/season/\(seasonID)/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangeCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        let path = "/tv/episode/\(episodeID)/changes"
        let queryItems = buildDateQueryItems(startDate: startDate, endDate: endDate, page: page)
        let collection: ChangeCollection = try await apiClient.get(path: path, queryItems: queryItems)
        return collection
    }

    // MARK: - Private Helpers

    private func buildDateQueryItems(startDate: Date?, endDate: Date?, page: Int?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        if let startDate {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            queryItems.append(URLQueryItem(name: "start_date", value: formatter.string(from: startDate)))
        }

        if let endDate {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            queryItems.append(URLQueryItem(name: "end_date", value: formatter.string(from: endDate)))
        }

        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }

        return queryItems
    }
}
```

---

## Integration Steps

### 1. Register in TMDbFactory

Update `Sources/TMDb/TMDbFactory.swift`:

```swift
let changesService = TMDbChangesService(apiClient: apiClient)

return Factory(
    // ... existing services ...
    changesService: changesService
)
```

### 2. Expose via TMDbClient

Update `Sources/TMDb/TMDbClient.swift`:

```swift
/// Changes service
public let changes: ChangesService

self.changes = factory.changesService
```

### 3. Update DocC TMDbClient Documentation

Update `Sources/TMDb/TMDb.docc/Extensions/TMDbClient.md`:

```markdown
- ``TMDbClient/changes``
```

---

## Testing Requirements

### Unit Tests

**Create Test Files:**
- `Tests/TMDbTests/Services/Changes/TMDbChangesServiceMovieTests.swift`
- `Tests/TMDbTests/Services/Changes/TMDbChangesServiceTVSeriesTests.swift`
- `Tests/TMDbTests/Services/Changes/TMDbChangesServicePersonTests.swift`
- `Tests/TMDbTests/Services/Changes/TMDbChangesServiceTVSeasonTests.swift`
- `Tests/TMDbTests/Services/Changes/TMDbChangesServiceTVEpisodeTests.swift`

**JSON Fixtures (`Tests/TMDbTests/Resources/json/`):**
- `movie-changes-list.json` (list of IDs)
- `movie-changes-details.json` (detailed changes)
- `tv-series-changes-list.json`
- `tv-series-changes-details.json`
- `person-changes-list.json`
- `person-changes-details.json`
- `tv-season-changes-details.json`
- `tv-episode-changes-details.json`

### Integration Tests

**Create Integration Test File:**
- `Tests/TMDbIntegrationTests/ChangesIntegrationTests.swift`

**Test Coverage:**
- Test movie changes list retrieval
- Test TV series changes list retrieval
- Test person changes list retrieval
- Test movie detailed changes
- Test TV series detailed changes
- Test person detailed changes
- Test date range filtering
- Test pagination

---

## Documentation Updates

### DocC Extensions

**Create `Sources/TMDb/TMDb.docc/Extensions/ChangesService.md`:**

```markdown
# ``ChangesService``

Track changes to TMDb entities over time.

## Overview

The Changes Service enables applications to track updates to movies, TV series, people,
seasons, and episodes. This is essential for maintaining synchronized caches and
detecting when content needs to be refreshed.

### Use Cases

- **Cache Synchronization**: Identify which cached entities need refreshing
- **Content Updates**: Track when metadata changes (e.g., new images, updated ratings)
- **Audit Trails**: Monitor historical changes to entities

### Important Notes

- Date ranges are limited to **maximum 14 days**
- Changes are tracked at the property level with old/new values
- Use ID lists for bulk sync, detailed changes for granular updates

## Topics

### Entity Change Lists

- ``ChangesService/movieChanges(startDate:endDate:page:)``
- ``ChangesService/tvSeriesChanges(startDate:endDate:page:)``
- ``ChangesService/personChanges(startDate:endDate:page:)``

### Detailed Change History

- ``ChangesService/movieDetails(forMovie:startDate:endDate:page:)``
- ``ChangesService/tvSeriesDetails(forTVSeries:startDate:endDate:page:)``
- ``ChangesService/personDetails(forPerson:startDate:endDate:page:)``
- ``ChangesService/tvSeasonDetails(forSeason:startDate:endDate:page:)``
- ``ChangesService/tvEpisodeDetails(forEpisode:startDate:endDate:page:)``
```

### Update Main Documentation

Add to `Sources/TMDb/TMDb.docc/TMDb.md`:

```markdown
### Services

- ``ChangesService``
```

---

## API Endpoints Reference

### Change Lists
```
GET /3/movie/changes?start_date={date}&end_date={date}&page={page}
GET /3/tv/changes?start_date={date}&end_date={date}&page={page}
GET /3/person/changes?start_date={date}&end_date={date}&page={page}
```

### Detailed Changes
```
GET /3/movie/{movie_id}/changes?start_date={date}&end_date={date}&page={page}
GET /3/tv/{series_id}/changes?start_date={date}&end_date={date}&page={page}
GET /3/person/{person_id}/changes?start_date={date}&end_date={date}&page={page}
GET /3/tv/season/{season_id}/changes?start_date={date}&end_date={date}&page={page}
GET /3/tv/episode/{episode_id}/changes?start_date={date}&end_date={date}&page={page}
```

---

## Example Change Response

```json
{
  "changes": [
    {
      "key": "title",
      "items": [
        {
          "id": "5e3c7a9c0e0a2600157f4b3e",
          "action": "updated",
          "time": "2020-02-06 15:23:24 UTC",
          "iso_639_1": "en",
          "value": "New Title",
          "original_value": "Old Title"
        }
      ]
    },
    {
      "key": "images",
      "items": [
        {
          "id": "5e3c7b2c0e0a2600157f4b43",
          "action": "added",
          "time": "2020-02-06 15:25:48 UTC",
          "value": {
            "poster": {
              "file_path": "/new_poster.jpg"
            }
          }
        }
      ]
    }
  ]
}
```

---

## Verification Checklist

Before considering complete:
- [ ] ChangesService created with protocol and implementation
- [ ] All 8 methods implemented
- [ ] Service registered in TMDbFactory
- [ ] Service exposed via TMDbClient
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation complete
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

---

## Impact Assessment

**User-Facing Benefits:**
- ✅ Applications can maintain synchronized caches
- ✅ Track content updates over time
- ✅ Identify stale cached data

**API Coverage Improvement:**
- Adds 1 new service
- Implements 8 previously missing endpoints
- Completes all change tracking functionality

---

## Notes

- **14-day limit:** Date ranges cannot exceed 14 days
- Date format: `YYYY-MM-DD` (ISO 8601)
- Changes include property-level detail with old/new values
- Use ID lists for efficient bulk checking
- Use detailed changes for understanding exactly what changed
- Essential for apps with offline/caching capabilities
