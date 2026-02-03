# Plan 3: Model Property Additions

**Priority:** HIGH
**Impact:** High - Fixes data completeness issues, addresses known bugs
**Effort:** Low-Medium
**Dependencies:** None

## Overview

Add missing properties to existing models based on TMDb API responses. This includes critical fixes like `TVSeries.createdBy` (Issue #257) and production-related properties for movies and TV series.

## Critical Model Updates

### 1. TVSeries Model

**File:** `Sources/TMDb/Domain/Models/TVSeries.swift`

**Missing Properties:**
```swift
public struct TVSeries: Codable, Equatable, Hashable, Sendable {
    // ... existing properties ...

    /// The creators of the TV series (different from executive producers)
    public let createdBy: [Creator]?

    /// Most recent aired episode
    public let lastEpisodeToAir: TVEpisode?

    /// Next scheduled episode to air
    public let nextEpisodeToAir: TVEpisode?

    /// Broadcasting networks
    public let networks: [Network]?

    /// Production companies
    public let productionCompanies: [ProductionCompany]?

    /// Countries where the series was produced
    public let productionCountries: [Country]?

    /// Languages spoken in the series
    public let spokenLanguages: [SpokenLanguage]?
}
```

**Impact:**
- ✅ Fixes Issue #257 (missing `createdBy` property)
- ✅ Provides complete production metadata
- ✅ Enables network and production company filtering
- ✅ Supports multilingual content discovery

---

### 2. Movie Model

**File:** `Sources/TMDb/Domain/Models/Movie.swift`

**Missing Properties:**
```swift
public struct Movie: Codable, Equatable, Hashable, Sendable {
    // ... existing properties ...

    /// Parent collection if movie is part of one
    public let belongsToCollection: Collection?

    /// Production budget in dollars
    public let budget: Int?

    /// Box office revenue in dollars
    public let revenue: Int?

    /// Duration in minutes
    public let runtime: Int?

    /// Movie tagline
    public let tagline: String?

    /// Production companies
    public let productionCompanies: [ProductionCompany]?

    /// Countries where the movie was produced
    public let productionCountries: [Country]?

    /// Languages spoken in the movie
    public let spokenLanguages: [SpokenLanguage]?
}
```

**Impact:**
- ✅ Enables collection browsing from movie details
- ✅ Provides financial data for analytics
- ✅ Complete production metadata
- ✅ Better internationalization support

---

### 3. ImageMetadata Model

**File:** `Sources/TMDb/Domain/Models/ImageMetadata.swift`

**Current Properties:**
```swift
public struct ImageMetadata: Codable, Equatable, Hashable, Sendable {
    public let filePath: URL
    public let width: Int
    public let height: Int
    public let aspectRatio: Double
    public let voteAverage: Double?
    public let voteCount: Int?
    public let languageCode: String?
}
```

**Potential Missing Property:**
```swift
    /// File size in bytes
    public let fileSize: Int?
```

**Action Required:** Verify with MCP if `file_size` is returned by API

---

## New Models Required

### 1. Creator Model

**File:** `Sources/TMDb/Domain/Models/Creator.swift`

```swift
/// Represents a TV series creator
public struct Creator: Codable, Equatable, Hashable, Sendable {
    /// Creator's unique identifier
    public let id: Int

    /// Creator's name
    public let name: String

    /// Credit ID for this specific creator role
    public let creditID: String

    /// Creator's gender
    public let gender: Gender?

    /// Path to creator's profile image
    public let profilePath: URL?
}
```

**CodingKeys:**
```swift
private enum CodingKeys: String, CodingKey {
    case id
    case name
    case creditID = "credit_id"
    case gender
    case profilePath = "profile_path"
}
```

---

### 2. SpokenLanguage Model

**File:** `Sources/TMDb/Domain/Models/SpokenLanguage.swift`

```swift
/// Represents a language spoken in a movie or TV series
public struct SpokenLanguage: Codable, Equatable, Hashable, Sendable {
    /// English name of the language
    public let englishName: String

    /// ISO 639-1 language code
    public let iso639_1: String

    /// Native name of the language
    public let name: String
}
```

**CodingKeys:**
```swift
private enum CodingKeys: String, CodingKey {
    case englishName = "english_name"
    case iso639_1 = "iso_639_1"
    case name
}
```

---

### 3. Country Model (Verify Existing)

**Action Required:** Verify if existing `Country` model matches `production_countries` schema

**Expected Structure:**
```swift
public struct Country: Codable, Equatable, Hashable, Sendable {
    public let iso3166_1: String
    public let name: String
}
```

**File:** Check `Sources/TMDb/Domain/Models/Country.swift`

If schema differs from configuration countries, create `ProductionCountry` model.

---

## Verification Steps Using MCP

Before implementing, verify actual API responses:

### 1. Verify TVSeries Properties
```bash
# Use Breaking Bad (1396) - long-running series with complete data
mcp__tmdb__tv_series_details(series_id: 1396)
```

**Check for:**
- `created_by` array
- `last_episode_to_air` object
- `next_episode_to_air` object (may be null)
- `networks` array
- `production_companies` array
- `production_countries` array
- `spoken_languages` array

### 2. Verify Movie Properties
```bash
# Use Fight Club (550) - well-documented movie
mcp__tmdb__movie_details(movie_id: 550)
```

**Check for:**
- `belongs_to_collection` object
- `budget` number
- `revenue` number
- `runtime` number
- `tagline` string
- `production_companies` array
- `production_countries` array
- `spoken_languages` array

### 3. Verify ImageMetadata
```bash
# Get movie images to check metadata
mcp__tmdb__movie_images(movie_id: 550)
```

**Check for:** `file_size` in image objects

---

## Implementation Steps

### Phase 1: API Response Verification
1. Use MCP to fetch real API responses
2. Save responses as reference files in scratchpad
3. Compare against current model definitions
4. Document all missing properties

### Phase 2: Create New Models
1. Create `Creator` model with full documentation
2. Create `SpokenLanguage` model with full documentation
3. Verify `Country` model compatibility
4. Add unit tests for each new model
5. Create JSON fixtures for testing

### Phase 3: Update Existing Models
1. Update `TVSeries` model with new properties
2. Update `Movie` model with new properties
3. Update `ImageMetadata` if needed
4. Mark all new properties as optional (`?`)
5. Update CodingKeys for snake_case mapping

### Phase 4: Update JSON Fixtures
1. Update `tv-series.json` with complete data from API
2. Update `tv-series-full.json` with all new properties
3. Update `movie.json` with complete data
4. Update `movie-full.json` with all new properties
5. Create fixtures for edge cases (null values)

### Phase 5: Update Tests
1. Update existing TVSeries tests to verify new properties
2. Update existing Movie tests to verify new properties
3. Add specific tests for `createdBy` property (Issue #257)
4. Ensure all tests handle optional properties correctly

### Phase 6: Integration Tests
1. Add integration test for TVSeries with `createdBy` property
2. Add integration test for Movie with `belongsToCollection`
3. Verify production metadata retrieval

---

## Testing Requirements

### Unit Tests

**New Test Files:**
- `Tests/TMDbTests/Domain/Models/CreatorTests.swift`
- `Tests/TMDbTests/Domain/Models/SpokenLanguageTests.swift`

**Update Existing:**
- `Tests/TMDbTests/Domain/Models/TVSeriesTests.swift` - Add tests for new properties
- `Tests/TMDbTests/Domain/Models/MovieTests.swift` - Add tests for new properties
- `Tests/TMDbTests/Domain/Models/ImageMetadataTests.swift` - Add fileSize test if needed

**JSON Fixtures:**
- `Tests/TMDbTests/Resources/json/creator.json`
- `Tests/TMDbTests/Resources/json/spoken-language.json`
- Update existing `tv-series-*.json` files
- Update existing `movie-*.json` files

### Integration Tests

**Update:**
- `Tests/TMDbIntegrationTests/TVSeriesIntegrationTests.swift`
  - Add test for `createdBy` property (use series ID 1396)
  - Verify production metadata
- `Tests/TMDbIntegrationTests/MovieIntegrationTests.swift`
  - Add test for `belongsToCollection` (use movie ID 550)
  - Verify financial data and production metadata

---

## Documentation Updates

### DocC Extensions

Add new models to `Sources/TMDb/TMDb.docc/TMDb.md`:

Under "### Models":
```markdown
- ``Creator``
- ``SpokenLanguage``
```

Update existing model documentation:
- Document new `TVSeries` properties in `TVSeries.md` (if exists) or inline docs
- Document new `Movie` properties in `Movie.md` (if exists) or inline docs

### Inline Documentation

Ensure all new properties have triple-slash comments:
```swift
/// The creators of the TV series.
///
/// Creators are the individuals who originally conceived and developed the series,
/// distinct from executive producers or showrunners.
public let createdBy: [Creator]?
```

---

## API Response Examples

### TVSeries with createdBy (Breaking Bad - ID 1396)
```json
{
  "created_by": [
    {
      "id": 66633,
      "credit_id": "52542286760ee313280017f9",
      "name": "Vince Gilligan",
      "gender": 2,
      "profile_path": "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg"
    }
  ],
  "last_episode_to_air": {
    "id": 62161,
    "name": "Felina",
    ...
  },
  "networks": [
    {
      "id": 174,
      "name": "AMC",
      "logo_path": "/pmvRmATOCaDykE6JrVoeYxlFHw3.png",
      "origin_country": "US"
    }
  ],
  "production_companies": [...],
  "spoken_languages": [
    {
      "english_name": "English",
      "iso_639_1": "en",
      "name": "English"
    },
    {
      "english_name": "Spanish",
      "iso_639_1": "es",
      "name": "Español"
    }
  ]
}
```

---

## Verification Checklist

Before considering complete:
- [ ] MCP verification complete for all models
- [ ] All new models created with tests
- [ ] TVSeries model updated with 7 new properties
- [ ] Movie model updated with 8 new properties
- [ ] ImageMetadata verified (fileSize if needed)
- [ ] All JSON fixtures updated with real API data
- [ ] Unit tests passing for all model changes
- [ ] Integration tests verify new properties
- [ ] DocC documentation updated
- [ ] Issue #257 verified as resolved
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

---

## Impact Assessment

**Critical Fixes:**
- ✅ Resolves Issue #257 - TVSeries missing `createdBy` property
- ✅ Adds production metadata for movies and TV series
- ✅ Improves data completeness across all models

**Data Completeness:**
- Before: Models missing 15+ properties
- After: Models fully aligned with TMDb API responses

**Breaking Changes:**
- ❌ None - all new properties are optional

---

## Related Issues

- **Issue #257**: ✅ Add createdBy property to TVSeries (#257)

---

## Notes

- All new properties must be optional to maintain backward compatibility
- Use MCP verification before implementation to avoid assumptions
- Production metadata enables filtering and analytics features
- `belongsToCollection` enables collection-based navigation in apps
