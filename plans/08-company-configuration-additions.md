# Plan 8: Company & Configuration Service Additions

**Priority:** LOW
**Impact:** Low - Metadata completeness improvements
**Effort:** Low
**Dependencies:** None

## Overview

Add missing Company Service endpoints for alternative names and logos, and add missing Configuration Service endpoints for primary translations and timezones.

---

## Company Service - Missing Endpoints

### Metadata (2 endpoints)

1. **GET /3/company/{company_id}/alternative_names** - Get alternative company names
   - Returns: `{ id, results: [{ name, type }] }`
   - Method: `alternativeNames(forCompany:)`

2. **GET /3/company/{company_id}/images** - Get company logos
   - Returns: `{ id, logos: [ImageMetadata] }`
   - Method: `images(forCompany:)`

---

## Configuration Service - Missing Endpoints

### System Metadata (2 endpoints)

3. **GET /3/configuration/primary_translations** - Get primary translations list
   - Returns: Array of language codes
   - Method: `primaryTranslations()`

4. **GET /3/configuration/timezones** - Get timezones list
   - Returns: Timezones grouped by country
   - Method: `timezones()`

---

## New Models Required

### 1. CompanyAlternativeName

**File:** `Sources/TMDb/Domain/Models/CompanyAlternativeName.swift`

```swift
/// Alternative name for a company
public struct CompanyAlternativeName: Codable, Equatable, Hashable, Sendable {
    /// Alternative name
    public let name: String

    /// Name type
    public let type: String
}
```

### 2. CompanyAlternativeNameCollection

**File:** `Sources/TMDb/Domain/Models/CompanyAlternativeNameCollection.swift`

```swift
/// Collection of alternative company names
public struct CompanyAlternativeNameCollection: Codable, Equatable, Hashable, Sendable {
    /// Company ID
    public let id: Int

    /// Alternative names
    public let results: [CompanyAlternativeName]
}
```

### 3. CompanyImageCollection

**File:** `Sources/TMDb/Domain/Models/CompanyImageCollection.swift`

```swift
/// Collection of company logos
public struct CompanyImageCollection: Codable, Equatable, Hashable, Sendable {
    /// Company ID
    public let id: Int

    /// Company logos
    public let logos: [ImageMetadata]
}
```

### 4. Timezone

**File:** `Sources/TMDb/Domain/Models/Timezone.swift`

```swift
/// Timezone information
public struct Timezone: Codable, Equatable, Hashable, Sendable {
    /// ISO 3166-1 country code
    public let iso3166_1: String

    /// Timezone identifiers for this country
    public let zones: [String]
}
```

**CodingKeys:**
```swift
private enum CodingKeys: String, CodingKey {
    case iso3166_1 = "iso_3166_1"
    case zones
}
```

---

## Service Protocol Updates

### Company Service

Update `Sources/TMDb/Domain/Services/Companies/CompanyService.swift`:

```swift
public protocol CompanyService: Sendable {
    /// Returns company details
    func details(forCompany companyID: Int) async throws -> Company

    /// Returns alternative names for a company
    ///
    /// - Parameter companyID: The company identifier
    /// - Returns: Collection of alternative names
    func alternativeNames(forCompany companyID: Int) async throws -> CompanyAlternativeNameCollection

    /// Returns logos for a company
    ///
    /// - Parameter companyID: The company identifier
    /// - Returns: Collection of company logos
    func images(forCompany companyID: Int) async throws -> CompanyImageCollection
}
```

### Configuration Service

Update `Sources/TMDb/Domain/Services/Configurations/ConfigurationService.swift`:

```swift
public protocol ConfigurationService: Sendable {
    // ... existing methods ...

    /// Returns a list of primary translation languages
    ///
    /// Primary translations are the main languages supported by TMDb for translated content.
    ///
    /// - Returns: Array of ISO 639-1 language codes
    func primaryTranslations() async throws -> [String]

    /// Returns a list of timezones grouped by country
    ///
    /// - Returns: Array of timezones with country codes and zone identifiers
    func timezones() async throws -> [Timezone]
}
```

---

## Implementation Steps

### Phase 1: Company Extensions
1. Create alternative name models
2. Create image collection model
3. Implement `alternativeNames(forCompany:)` method
4. Implement `images(forCompany:)` method
5. Add unit tests with JSON fixtures
6. Add integration tests

### Phase 2: Configuration Extensions
1. Create `Timezone` model
2. Implement `primaryTranslations()` method
3. Implement `timezones()` method
4. Add unit tests with JSON fixtures
5. Add integration tests

---

## Testing Requirements

### Unit Tests

**Company Service Tests (`Tests/TMDbTests/Services/Companies/`):**
- `TMDbCompanyServiceAlternativeNamesTests.swift`
- `TMDbCompanyServiceImagesTests.swift`

**Configuration Service Tests (`Tests/TMDbTests/Services/Configurations/`):**
- `TMDbConfigurationServicePrimaryTranslationsTests.swift`
- `TMDbConfigurationServiceTimezonesTests.swift`

**JSON Fixtures (`Tests/TMDbTests/Resources/json/`):**
- `company-alternative-names.json`
- `company-images.json`
- `configuration-primary-translations.json`
- `configuration-timezones.json`

### Integration Tests

**Update Integration Tests:**
- `CompanyIntegrationTests.swift` - Add alternative names and images tests
- `ConfigurationIntegrationTests.swift` - Add primary translations and timezones tests

---

## Documentation Updates

### DocC Extensions

**Update `Sources/TMDb/TMDb.docc/Extensions/CompanyService.md`:**

```markdown
# ``CompanyService``

Get production company information.

## Overview

The Company Service provides access to production company details, including
alternative names and logo images.

## Topics

### Getting Company Details

- ``CompanyService/details(forCompany:)``
- ``CompanyService/alternativeNames(forCompany:)``
- ``CompanyService/images(forCompany:)``
```

**Update `Sources/TMDb/TMDb.docc/Extensions/ConfigurationService.md`:**

```markdown
### System Configuration

- ``ConfigurationService/apiConfiguration()``
- ``ConfigurationService/countries(language:)``
- ``ConfigurationService/languages()``
- ``ConfigurationService/jobsByDepartment()``
- ``ConfigurationService/primaryTranslations()``
- ``ConfigurationService/timezones()``
```

### New Model Documentation

Add to `Sources/TMDb/TMDb.docc/TMDb.md`:

```markdown
- ``CompanyAlternativeName``
- ``CompanyAlternativeNameCollection``
- ``CompanyImageCollection``
- ``Timezone``
```

---

## API Endpoints Reference

### Company
```
GET /3/company/{company_id}/alternative_names
GET /3/company/{company_id}/images
```

### Configuration
```
GET /3/configuration/primary_translations
GET /3/configuration/timezones
```

---

## Example API Responses

### Company Alternative Names
```json
{
  "id": 1,
  "results": [
    {
      "name": "20th Century Fox",
      "type": "Former name"
    },
    {
      "name": "TCF",
      "type": "Acronym"
    }
  ]
}
```

### Company Images
```json
{
  "id": 1,
  "logos": [
    {
      "aspect_ratio": 3.173,
      "file_path": "/o86DbpburjxrqAzEDhXZcyE8pDb.png",
      "height": 200,
      "width": 634,
      "vote_average": 5.384,
      "vote_count": 4
    }
  ]
}
```

### Primary Translations
```json
[
  "en",
  "es",
  "fr",
  "de",
  "it",
  "pt",
  "ja",
  "ko",
  "zh"
]
```

### Timezones
```json
[
  {
    "iso_3166_1": "US",
    "zones": [
      "America/New_York",
      "America/Chicago",
      "America/Los_Angeles",
      "America/Denver",
      "Pacific/Honolulu"
    ]
  },
  {
    "iso_3166_1": "GB",
    "zones": [
      "Europe/London"
    ]
  }
]
```

---

## Verification Checklist

Before considering complete:
- [ ] All models created with full test coverage
- [ ] All 2 company methods implemented
- [ ] All 2 configuration methods implemented
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation updated
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

---

## Impact Assessment

**User-Facing Benefits:**
- ✅ Complete company metadata (logos, alternative names)
- ✅ Primary translation language discovery
- ✅ Timezone information for scheduling features

**API Coverage Improvement:**
- **Company:** 1/3 → 3/3 (100%)
- **Configuration:** 4/6 → 6/6 (100%)

---

## Notes

- Company logos useful for displaying production company branding
- Alternative names help with company search/matching
- Primary translations list helps with localization features
- Timezones useful for scheduling/airing time calculations
- These are low-priority metadata endpoints with specialized use cases
