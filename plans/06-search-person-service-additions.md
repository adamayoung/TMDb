# Plan 6: Search & Person Service Additions

**Priority:** MEDIUM
**Impact:** Medium - Improves content discovery and person metadata
**Effort:** Low-Medium
**Dependencies:** Plan 1 (Translation models)

## Overview

Extend Search Service to support collections, companies, and keywords. Add missing Person Service endpoints for tagged images and translations.

---

## Search Service - Missing Endpoints

### Important - Extended Search (3 endpoints)

1. **GET /3/search/collection** - Search collections
   - Parameters: query, page, language
   - Returns: `CollectionPageableList`
   - Method: `searchCollections(query:page:language:)`

2. **GET /3/search/company** - Search companies
   - Parameters: query, page
   - Returns: `CompanyPageableList`
   - Method: `searchCompanies(query:page:)`

3. **GET /3/search/keyword** - Search keywords
   - Parameters: query, page
   - Returns: `KeywordPageableList`
   - Method: `searchKeywords(query:page:)`

---

## Person Service - Missing Endpoints

### Important - Metadata (2 endpoints)

4. **GET /3/person/{person_id}/tagged_images** - Get images tagged with this person
   - Parameters: page
   - Returns: `TaggedImagePageableList`
   - Method: `taggedImages(forPerson:page:)`

5. **GET /3/person/{person_id}/translations** - Get person translations/biographies
   - Returns: `TranslationCollection<PersonTranslationData>`
   - Method: `translations(forPerson:)`

### Lower Priority - Changes & Latest (3 endpoints)

6. **GET /3/person/{person_id}/changes** - Get person changes by date range
   - Parameters: start_date, end_date, page
   - Returns: `ChangeCollection`
   - Method: `changes(forPerson:startDate:endDate:page:)`

7. **GET /3/person/latest** - Get latest person added to TMDb
   - Returns: Full `Person` object
   - Method: `latest()`

8. **GET /3/person/changes** - Get list of person IDs that changed
   - Parameters: start_date, end_date, page
   - Returns: `ChangedIDCollection`
   - Method: `changes(startDate:endDate:page:)`

---

## New Models Required

### 1. CollectionPageableList

**File:** `Sources/TMDb/Domain/Models/CollectionPageableList.swift`

```swift
/// Pageable list of collections
public typealias CollectionPageableList = PageableListResult<CollectionListItem>
```

### 2. CompanyPageableList

**File:** `Sources/TMDb/Domain/Models/CompanyPageableList.swift`

```swift
/// Pageable list of companies
public typealias CompanyPageableList = PageableListResult<Company>
```

### 3. KeywordPageableList

**File:** `Sources/TMDb/Domain/Models/KeywordPageableList.swift`

```swift
/// Pageable list of keywords
public typealias KeywordPageableList = PageableListResult<Keyword>
```

### 4. TaggedImage

**File:** `Sources/TMDb/Domain/Models/TaggedImage.swift`

```swift
/// Represents an image tagged with a person
public struct TaggedImage: Codable, Equatable, Hashable, Sendable {
    /// Image aspect ratio
    public let aspectRatio: Double

    /// Image file path
    public let filePath: URL

    /// Image height in pixels
    public let height: Int

    /// ISO 639-1 language code
    public let languageCode: String?

    /// Image vote average
    public let voteAverage: Double?

    /// Image vote count
    public let voteCount: Int?

    /// Image width in pixels
    public let width: Int

    /// Type of media this image is from
    public let mediaType: MediaType

    /// Media this image is tagged in
    public let media: Media
}
```

**CodingKeys:**
```swift
private enum CodingKeys: String, CodingKey {
    case aspectRatio = "aspect_ratio"
    case filePath = "file_path"
    case height
    case languageCode = "iso_639_1"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case width
    case mediaType = "media_type"
    case media
}
```

### 5. TaggedImagePageableList

**File:** `Sources/TMDb/Domain/Models/TaggedImagePageableList.swift`

```swift
/// Pageable list of tagged images
public typealias TaggedImagePageableList = PageableListResult<TaggedImage>
```

### 6. PersonTranslationData

**File:** Add to `Sources/TMDb/Domain/Models/Translation.swift`

```swift
/// Translation data for a person
public struct PersonTranslationData: Codable, Equatable, Hashable, Sendable {
    /// Translated biography
    public let biography: String
}
```

### Models Reused
- `CollectionListItem` (exists)
- `Company` (exists)
- `Keyword` (exists)
- `TranslationCollection<T>` (from Plan 1)
- `ChangeCollection`, `ChangedIDCollection` (from Plan 1)
- `Media`, `MediaType` (exists)

---

## Service Protocol Updates

### Search Service

Update `Sources/TMDb/Domain/Services/Search/SearchService.swift`:

```swift
public protocol SearchService: Sendable {
    // ... existing methods ...

    /// Searches for collections
    func searchCollections(
        query: String,
        page: Int?,
        language: String?
    ) async throws -> CollectionPageableList

    /// Searches for companies
    func searchCompanies(
        query: String,
        page: Int?
    ) async throws -> CompanyPageableList

    /// Searches for keywords
    func searchKeywords(
        query: String,
        page: Int?
    ) async throws -> KeywordPageableList
}
```

### Person Service

Update `Sources/TMDb/Domain/Services/People/PersonService.swift`:

```swift
public protocol PersonService: Sendable {
    // ... existing methods ...

    /// Returns images tagged with this person
    func taggedImages(
        forPerson personID: Person.ID,
        page: Int?
    ) async throws -> TaggedImagePageableList

    /// Returns translations/biographies for a person
    func translations(
        forPerson personID: Person.ID
    ) async throws -> TranslationCollection<PersonTranslationData>

    /// Returns change history for a person
    func changes(
        forPerson personID: Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    /// Returns the latest person added to TMDb
    func latest() async throws -> Person

    /// Returns a list of person IDs that have changed
    func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection
}
```

---

## Implementation Steps

### Phase 1: Search Extensions
1. Create pageable list typealiases (Collection, Company, Keyword)
2. Implement `searchCollections(query:page:language:)` method
3. Implement `searchCompanies(query:page:)` method
4. Implement `searchKeywords(query:page:)` method
5. Add unit tests with JSON fixtures
6. Add integration tests

### Phase 2: Person Tagged Images & Translations
1. Create `TaggedImage` model
2. Create `PersonTranslationData` model
3. Implement `taggedImages(forPerson:page:)` method
4. Implement `translations(forPerson:)` method
5. Add unit tests with JSON fixtures
6. Add integration tests

### Phase 3: Person Changes Tracking
1. Reuse Change models from Movies plan
2. Implement `changes(forPerson:startDate:endDate:page:)` method
3. Implement `changes(startDate:endDate:page:)` method
4. Implement `latest()` method
5. Add unit tests with JSON fixtures
6. Add integration tests

---

## Testing Requirements

### Unit Tests

**Search Service Tests (`Tests/TMDbTests/Services/Search/`):**
- `TMDbSearchServiceCollectionsTests.swift`
- `TMDbSearchServiceCompaniesTests.swift`
- `TMDbSearchServiceKeywordsTests.swift`

**Person Service Tests (`Tests/TMDbTests/Services/People/`):**
- `TMDbPersonServiceTaggedImagesTests.swift`
- `TMDbPersonServiceTranslationsTests.swift`
- `TMDbPersonServiceChangesTests.swift`

**JSON Fixtures (`Tests/TMDbTests/Resources/json/`):**
- `search-collections.json`
- `search-companies.json`
- `search-keywords.json`
- `person-tagged-images.json`
- `person-translations.json`
- `person-changes.json`
- `person-changes-list.json`
- `person-latest.json`

### Integration Tests

**Update Integration Tests:**
- `SearchIntegrationTests.swift` - Add collection, company, keyword search tests
- `PersonIntegrationTests.swift` - Add tagged images, translations, changes tests

---

## Documentation Updates

### DocC Extensions

**Update `Sources/TMDb/TMDb.docc/Extensions/SearchService.md`:**
```markdown
### Media Search

- ``SearchService/searchAll(query:filter:page:language:)`` (existing)
- ``SearchService/searchMovies(query:filter:page:language:)`` (existing)
- ``SearchService/searchTVSeries(query:filter:page:language:)`` (existing)
- ``SearchService/searchPeople(query:filter:page:language:)`` (existing)

### Extended Search

- ``SearchService/searchCollections(query:page:language:)``
- ``SearchService/searchCompanies(query:page:)``
- ``SearchService/searchKeywords(query:page:)``
```

**Update `Sources/TMDb/TMDb.docc/Extensions/PersonService.md`:**
```markdown
### Images

- ``PersonService/images(forPerson:)`` (existing)
- ``PersonService/taggedImages(forPerson:page:)``

### Metadata

- ``PersonService/translations(forPerson:)``

### Change Tracking

- ``PersonService/changes(forPerson:startDate:endDate:page:)``
- ``PersonService/changes(startDate:endDate:page:)``
- ``PersonService/latest()``
```

### New Model Documentation

Add to `Sources/TMDb/TMDb.docc/TMDb.md`:
```markdown
- ``CollectionPageableList``
- ``CompanyPageableList``
- ``KeywordPageableList``
- ``TaggedImage``
- ``TaggedImagePageableList``
- ``PersonTranslationData``
```

---

## API Endpoints Reference

### Search
```
GET /3/search/collection?query={query}&page={page}&language={language}
GET /3/search/company?query={query}&page={page}
GET /3/search/keyword?query={query}&page={page}
```

### Person
```
GET /3/person/{person_id}/tagged_images?page={page}
GET /3/person/{person_id}/translations
GET /3/person/{person_id}/changes?start_date={date}&end_date={date}&page={page}
GET /3/person/latest
GET /3/person/changes?start_date={date}&end_date={date}&page={page}
```

---

## Verification Checklist

Before considering complete:
- [ ] All models created with full test coverage
- [ ] All 3 search methods implemented
- [ ] All 5 person methods implemented
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation updated
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

---

## Impact Assessment

**User-Facing Benefits:**
- ✅ Complete search functionality across all content types
- ✅ Tagged images show person appearances in media
- ✅ Person biographies in multiple languages
- ✅ Change tracking for person updates

**API Coverage Improvement:**
- **Search:** 4/7 → 7/7 (100%)
- **Person:** 6/10 → 11/10 (100%+)

---

## Notes

- Tagged images show scenes where the person appears (useful for actors)
- Collection search helps find movie series/franchises
- Company search enables production company filtering
- Keyword search aids in content categorization
- Person translations provide biographies in different languages
