# Implementation Plan: PRD-005 Response Caching Layer

## Overview

Add an opt-in, actor-isolated, in-memory caching layer for 13 reference
data endpoint methods across 4 services. The design mirrors the existing
`RetryConfiguration` / `RetryHTTPClient` pattern from PRD-004. The cache
operates at the service layer, keyed by method identity plus parameters,
with per-entry TTLs and LRU eviction.

## Phased Implementation

### Phase 1: Core Cache Infrastructure

#### Step 1.1: Create `CacheConfiguration` model

**File:** `Sources/TMDb/Domain/Models/CacheConfiguration.swift` (new)

Follow the exact pattern of `RetryConfiguration`:

- Public struct conforming to `Hashable`, `Sendable`
- Properties: `defaultTTL: Duration` (default `.seconds(86400)` = 24h),
  `maxEntries: Int` (default `50`)
- Input validation: clamp `maxEntries` to minimum of 1 via `max(1, maxEntries)`
- Static `.default` property
- Full `///` doc comments on all public declarations

#### Step 1.2: Write `CacheConfiguration` tests (TDD)

**File:** `Tests/TMDbTests/Domain/Models/CacheConfigurationTests.swift`
(new)

Test cases:

- Default values (24h TTL, 50 max entries)
- Custom values
- Clamping of `maxEntries` to minimum 1 (zero and negative inputs)
- `.default` static constant
- `Equatable` equality and inequality
- `Hashable` consistency

#### Step 1.3: Create `ResponseCaching` protocol

**File:** `Sources/TMDb/Caching/ResponseCaching.swift` (new)

Internal protocol that decouples services from the concrete actor, enabling
mock injection in tests:

```swift
protocol ResponseCaching: Sendable {
    func value<T: Sendable>(forKey key: String, as type: T.Type) async -> T?
    func set<T: Sendable>(_ value: T, forKey key: String, ttl: Duration) async
    func removeAll() async
}
```

#### Step 1.4: Create `ResponseCache` actor

**File:** `Sources/TMDb/Caching/ResponseCache.swift` (new)

Actor-based implementation, generic over `Clock` for testability:

- `Entry` struct with `value: any Sendable`, `expiresAt: C.Instant`,
  `lastAccessed: C.Instant`
- `value(forKey:as:)` — returns `nil` for missing/expired/type-mismatch;
  updates `lastAccessed` on hit
- `set(_:forKey:ttl:)` — calls `evictIfNeeded()` before storing
- `removeAll()` — clears entire cache
- `evictIfNeeded()` — removes expired entries first, then LRU eviction
  when at `maxEntries` capacity

#### Step 1.5: Write `ResponseCache` tests (TDD)

**Files:**

- `Tests/TMDbTests/Caching/MockClock.swift` (new) — deterministic clock
  conforming to `Clock` with `Duration == Duration`
- `Tests/TMDbTests/Caching/MockResponseCache.swift` (new) — test double
  for `ResponseCaching` protocol
- `Tests/TMDbTests/Caching/ResponseCacheTests.swift` (new)
- `Tests/TMDbTests/TestUtils/Tags.swift` — add `.caching` tag

Test cases:

1. `get` returns `nil` for non-existent key
2. `set` then `get` returns stored value
3. `get` returns `nil` after TTL expires (advance mock clock)
4. `get` returns value just before TTL expires
5. LRU eviction: least recently accessed entry evicted at capacity
6. Eviction prefers expired entries over valid ones
7. `removeAll` clears all entries
8. Type mismatch returns `nil`
9. Multiple distinct keys coexist
10. Overwriting existing key updates value and TTL
11. `lastAccessed` updated on read (accessed entry survives eviction)

---

### Phase 2: Wire into Configuration and Factory

#### Step 2.1: Add `cache` to `TMDbConfiguration`

**File:** `Sources/TMDb/TMDbConfiguration.swift` (modify)

- Add `public let cache: CacheConfiguration?` property (after `retry`)
- Add `cache: CacheConfiguration? = nil` parameter to `init` (after
  `retry`)
- Doc comments for both property and parameter

The existing `static let default` and `static var system` don't pass
`cache:`, so they get `nil` — correct, since caching is opt-in.

#### Step 2.2: Add factory method to `TMDbFactory`

**File:** `Sources/TMDb/TMDbFactory.swift` (modify)

```swift
static func responseCache(
    cacheConfiguration: CacheConfiguration?
) -> (any ResponseCaching)? {
    guard let cacheConfiguration else { return nil }
    return ResponseCache(
        configuration: cacheConfiguration,
        clock: ContinuousClock()
    )
}
```

#### Step 2.3: Wire cache into `TMDBClient`

**File:** `Sources/TMDb/TMDBClient.swift` (modify)

In the convenience `init(apiKey:httpClient:configuration:)`:

1. Create shared cache:
   `let responseCache = TMDbFactory.responseCache(cacheConfiguration: configuration.cache)`
2. Pass `cache: responseCache` to 4 service constructors:
   `TMDbConfigurationService`, `TMDbGenreService`,
   `TMDbCertificationService`, `TMDbWatchProviderService`

---

### Phase 3: Add Caching to Services (TDD for Each)

Each service follows the same pattern:

1. Write cache-specific tests in a new test file
2. Add `cache: (any ResponseCaching)? = nil` parameter to `init`
3. Each cacheable method: check cache → call API on miss → store result

Default `nil` preserves backward compatibility — all existing tests pass
unchanged.

#### Step 3.1: `TMDbConfigurationService` (6 methods)

**Modify:** `Sources/TMDb/Domain/Services/Configuration/TMDbConfigurationService.swift`
**Create:** `Tests/TMDbTests/Domain/Services/Configuration/TMDbConfigurationServiceCacheTests.swift`

| Method | Cache Key | TTL |
|--------|-----------|-----|
| `apiConfiguration()` | `configuration.api` | 24h |
| `countries(language:)` | `configuration.countries.<lang>` | 24h |
| `jobsByDepartment()` | `configuration.jobs` | 24h |
| `languages()` | `configuration.languages` | 24h |
| `primaryTranslations()` | `configuration.primaryTranslations` | 24h |
| `timezones()` | `configuration.timezones` | 24h |

#### Step 3.2: `TMDbGenreService` (2 methods)

**Modify:** `Sources/TMDb/Domain/Services/Genres/TMDbGenreService.swift`
**Create:** `Tests/TMDbTests/Domain/Services/Genres/TMDbGenreServiceCacheTests.swift`

| Method | Cache Key | TTL |
|--------|-----------|-----|
| `movieGenres(language:)` | `genre.movie.<resolvedLang>` | 24h |
| `tvSeriesGenres(language:)` | `genre.tvSeries.<resolvedLang>` | 24h |

**Important:** Use resolved language (after `configuration.defaultLanguage`
fallback) in cache key to avoid duplicate entries.

#### Step 3.3: `TMDbCertificationService` (2 methods)

**Modify:** `Sources/TMDb/Domain/Services/Certifications/TMDbCertificationService.swift`
**Create:** `Tests/TMDbTests/Domain/Services/Certifications/TMDbCertificationServiceCacheTests.swift`

| Method | Cache Key | TTL |
|--------|-----------|-----|
| `movieCertifications()` | `certification.movie` | 24h |
| `tvSeriesCertifications()` | `certification.tvSeries` | 24h |

#### Step 3.4: `TMDbWatchProviderService` (3 methods)

**Modify:** `Sources/TMDb/Domain/Services/WatchProviders/TMDbWatchProviderService.swift`
**Create:** `Tests/TMDbTests/Domain/Services/WatchProviders/TMDbWatchProviderServiceCacheTests.swift`

| Method | Cache Key | TTL |
|--------|-----------|-----|
| `countries(language:)` | `watchProvider.countries.<lang>` | 24h |
| `movieWatchProviders(filter:language:)` | `watchProvider.movie.<country>.<lang>` | 6h |
| `tvSeriesWatchProviders(filter:language:)` | `watchProvider.tvSeries.<country>.<lang>` | 6h |

---

### Phase 4: Fix Misleading Doc Comment

**File:** `Sources/TMDb/Domain/Services/Configuration/ConfigurationService.swift`
(modify)

The `apiConfiguration()` doc comment currently claims "The result is
cached, so there is no overhead in making multiple calls." Update to
accurately describe the opt-in caching behavior:

> When the client is configured with a ``CacheConfiguration``, the result
> is cached in memory to avoid redundant network requests.

---

### Phase 5: Documentation Updates

#### Step 5.1: DocC catalog

**File:** `Sources/TMDb/TMDb.docc/TMDb.md` (modify)

Add topic section after "Retry Configuration":

```markdown
### Cache Configuration

- ``CacheConfiguration``
```

#### Step 5.2: Getting Started guide

**File:** `Sources/TMDb/TMDb.docc/GettingStarted/CreatingTMDbClient.md`
(modify)

Add section with usage examples after the retry configuration section.

#### Step 5.3: README

**File:** `README.md` (modify)

- Add "Response Caching" feature bullet
- Add "Response Caching" configuration subsection with code example

---

### Phase 6: Verify All Tests Pass

1. `make test` — all unit tests (existing + new)
2. `make integration-test` — live API tests

---

### Phase 7: Completion Checklist

Per `CLAUDE.md`, run in order:

1. `make format`
2. `make lint`
3. `make test` (**must pass**)
4. `make integration-test` (**must pass**)
5. `make build-docs` (public API changed)
6. `make lint-markdown` (`.md` files changed)
7. `make ci` (**must pass before PR**)

Self-review all changes before marking complete.

---

## File Inventory

### New Files (11)

| File | Purpose |
|------|---------|
| `Sources/TMDb/Domain/Models/CacheConfiguration.swift` | Public configuration model |
| `Sources/TMDb/Caching/ResponseCaching.swift` | Internal cache protocol |
| `Sources/TMDb/Caching/ResponseCache.swift` | Actor-based cache implementation |
| `Tests/TMDbTests/Domain/Models/CacheConfigurationTests.swift` | Config model tests |
| `Tests/TMDbTests/Caching/ResponseCacheTests.swift` | Cache actor tests |
| `Tests/TMDbTests/Caching/MockClock.swift` | Test double for `Clock` |
| `Tests/TMDbTests/Caching/MockResponseCache.swift` | Test double for `ResponseCaching` |
| `Tests/TMDbTests/Domain/Services/Configuration/TMDbConfigurationServiceCacheTests.swift` | Config service cache tests |
| `Tests/TMDbTests/Domain/Services/Genres/TMDbGenreServiceCacheTests.swift` | Genre service cache tests |
| `Tests/TMDbTests/Domain/Services/Certifications/TMDbCertificationServiceCacheTests.swift` | Certification service cache tests |
| `Tests/TMDbTests/Domain/Services/WatchProviders/TMDbWatchProviderServiceCacheTests.swift` | Watch provider service cache tests |

### Modified Files (12)

| File | Change |
|------|--------|
| `Sources/TMDb/TMDbConfiguration.swift` | Add `cache: CacheConfiguration?` property |
| `Sources/TMDb/TMDbFactory.swift` | Add `responseCache()` factory method |
| `Sources/TMDb/TMDBClient.swift` | Create cache, inject into 4 services |
| `Sources/TMDb/Domain/Services/Configuration/TMDbConfigurationService.swift` | Cache 6 methods |
| `Sources/TMDb/Domain/Services/Configuration/ConfigurationService.swift` | Fix misleading doc comment |
| `Sources/TMDb/Domain/Services/Genres/TMDbGenreService.swift` | Cache 2 methods |
| `Sources/TMDb/Domain/Services/Certifications/TMDbCertificationService.swift` | Cache 2 methods |
| `Sources/TMDb/Domain/Services/WatchProviders/TMDbWatchProviderService.swift` | Cache 3 methods |
| `Sources/TMDb/TMDb.docc/TMDb.md` | Add `CacheConfiguration` topic section |
| `Sources/TMDb/TMDb.docc/GettingStarted/CreatingTMDbClient.md` | Add cache configuration docs |
| `README.md` | Add caching feature and configuration docs |
| `Tests/TMDbTests/TestUtils/Tags.swift` | Add `.caching` tag |

---

## Dependency Graph

```text
Phase 1.1 CacheConfiguration model
    │
Phase 1.2 CacheConfiguration tests
    │
Phase 1.3 ResponseCaching protocol
    │
Phase 1.4 ResponseCache actor
    │
Phase 1.5 ResponseCache tests + MockClock + MockResponseCache
    │
    ├──▶ Phase 2.1 TMDbConfiguration.cache property
    │        │
    │    Phase 2.2 TMDbFactory.responseCache()
    │        │
    │    Phase 2.3 TMDBClient wiring
    │
    ├──▶ Phase 3.1 ConfigurationService caching (tests first, then impl)
    ├──▶ Phase 3.2 GenreService caching (tests first, then impl)
    ├──▶ Phase 3.3 CertificationService caching (tests first, then impl)
    └──▶ Phase 3.4 WatchProviderService caching (tests first, then impl)
         │
     Phase 4   Fix ConfigurationService doc comment
         │
     Phase 5   Documentation (TMDb.md, GettingStarted, README)
         │
     Phase 6   Run full test suite
         │
     Phase 7   Completion checklist (format, lint, ci)
```

Phases 3.1–3.4 are independent and can be done in any order.

---

## Key Design Decisions

1. **Service-layer caching (not HTTP-layer):** Caches decoded Swift
   values, keyed by semantic method identity. More precise than URL-based
   caching, avoids serialization overhead on hits, enables per-endpoint
   TTLs.

2. **Protocol abstraction (`ResponseCaching`):** Services depend on the
   protocol, not the concrete actor. Enables `MockResponseCache`
   injection in tests without needing real `Clock` or actor timing.

3. **Resolved language in cache keys:** For `movieGenres(language:)`,
   the key uses the resolved language (after
   `configuration.defaultLanguage` fallback). Prevents duplicate cache
   entries when `movieGenres()` and `movieGenres(language: "en")` refer
   to the same data.

4. **`nil` cache = zero overhead:** Optional chaining
   (`await cache?.value(...)`) short-circuits immediately when cache is
   `nil`. No performance impact for users who don't enable caching.

5. **LRU eviction:** When at capacity, the least recently accessed entry
   is evicted (expired entries are evicted first). The default 50-entry
   cap comfortably holds all 13 cacheable endpoint types with language
   variants.

6. **Generic `Clock` for testability:** `MockClock` allows deterministic
   TTL expiration testing without real delays.
