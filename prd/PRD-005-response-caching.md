# PRD-005: Response Caching Layer

| Field    | Value                                  |
|----------|----------------------------------------|
| Priority | Low                                    |
| Effort   | Medium                                 |
| Status   | Draft                                  |

## Problem Statement

The TMDb package relies solely on `URLSession`'s HTTP-level caching
(configured in `TMDbFactory` with a 50 MB memory / 1 GB disk
`URLCache`). While this handles standard HTTP cache headers, several
TMDb API responses are effectively static but don't carry aggressive
cache headers:

- **API configuration** (`/3/configuration`) — image base URLs, size
  options; changes very rarely
- **Genre lists** (`/3/genre/movie/list`,
  `/3/genre/tv/list`) — almost never change
- **Certification lists** (`/3/certification/movie/list`,
  `/3/certification/tv/list`) — almost never change
- **Watch provider lists** (`/3/watch/providers/movie`,
  `/3/watch/providers/tv`) — change infrequently
- **Countries, languages, timezones, jobs** — reference data that
  rarely changes

Without application-level caching, these endpoints are re-fetched on
every call (unless `URLSession` caching happens to cover them), adding
unnecessary latency and API usage.

Additionally, the `ConfigurationService` protocol documentation claims
results are cached, but the implementation (`TMDbConfigurationService`)
makes a direct API call every time with no in-memory caching. This
documentation inaccuracy should be fixed as part of this PRD — either
by making the caching claim true (the primary goal) or by correcting
the doc comment if caching is not configured.

## Proposed Solution

Add an optional in-memory caching layer for reference data endpoints.
The cache is:

- **Opt-in** — disabled by default to preserve current behaviour
- **In-memory** — no disk persistence beyond `URLSession`'s cache
- **Time-based** — entries expire after a configurable TTL
- **Actor-isolated** — thread-safe via Swift's actor model

### Usage

```swift
let client = TMDbClient(
    apiKey: "...",
    configuration: TMDbConfiguration(
        cache: CacheConfiguration(
            defaultTTL: .seconds(3600),  // 1 hour
            maximumEntryCount: 100
        )
    )
)

// First call: fetches from API
let config1 = try await client.configurations.apiConfiguration()

// Second call within TTL: returns cached result instantly
let config2 = try await client.configurations.apiConfiguration()
```

### What Gets Cached

Only responses that are effectively static reference data:

| Service | Method | Default TTL |
|---------|--------|-------------|
| `ConfigurationService` | `apiConfiguration()` | 24 hours |
| `ConfigurationService` | `countries()` | 24 hours |
| `ConfigurationService` | `languages()` | 24 hours |
| `ConfigurationService` | `jobsByDepartment()` | 24 hours |
| `ConfigurationService` | `timezones()` | 24 hours |
| `ConfigurationService` | `primaryTranslations()` | 24 hours |
| `GenreService` | `movieGenres()` | 24 hours |
| `GenreService` | `tvSeriesGenres()` | 24 hours |
| `CertificationService` | `movieCertifications()` | 24 hours |
| `CertificationService` | `tvSeriesCertifications()` | 24 hours |
| `WatchProviderService` | `movieWatchProviders()` | 6 hours |
| `WatchProviderService` | `tvSeriesWatchProviders()` | 6 hours |
| `WatchProviderService` | `regions()` | 24 hours |

Dynamic endpoints (search, discover, details, trending) are **not**
cached at this layer.

## Technical Design

### Cache Actor

The cache uses a generic `Clock` parameter for testability — unit
tests can inject a mock clock to control time without real delays:

```swift
/// An actor-isolated in-memory cache for API responses.
actor ResponseCache<C: Clock> where C.Duration == Duration {

    private struct Entry {
        let value: any Sendable
        let expiresAt: C.Instant
    }

    private var storage: [String: Entry] = [:]
    private let defaultTTL: Duration
    private let maximumEntryCount: Int
    private let clock: C

    init(defaultTTL: Duration, maximumEntryCount: Int,
         clock: C = ContinuousClock()) {
        self.defaultTTL = defaultTTL
        self.maximumEntryCount = maximumEntryCount
        self.clock = clock
    }

    func get<T: Sendable>(_ key: String, as type: T.Type) -> T? {
        guard let entry = storage[key] else { return nil }
        guard clock.now < entry.expiresAt else {
            storage.removeValue(forKey: key)
            return nil
        }
        return entry.value as? T
    }

    func set<T: Sendable>(
        _ key: String,
        value: T,
        ttl: Duration? = nil
    ) {
        evictIfNeeded()
        storage[key] = Entry(
            value: value,
            expiresAt: clock.now.advanced(by: ttl ?? defaultTTL)
        )
    }

    func invalidate(_ key: String) {
        storage.removeValue(forKey: key)
    }

    func invalidateAll() {
        storage.removeAll()
    }

    private func evictIfNeeded() {
        guard storage.count >= maximumEntryCount else { return }
        // Remove expired entries first
        let now = clock.now
        storage = storage.filter { $0.value.expiresAt > now }
        // If still over limit, remove oldest entries
        if storage.count >= maximumEntryCount {
            let sorted = storage.sorted {
                $0.value.expiresAt < $1.value.expiresAt
            }
            let toRemove = storage.count - maximumEntryCount + 1
            for (key, _) in sorted.prefix(toRemove) {
                storage.removeValue(forKey: key)
            }
        }
    }
}
```

### Cache Keys

Cache keys are derived from the API request path and query parameters:

```swift
// Example keys:
// "/configuration" -> "configuration"
// "/genre/movie/list?language=en" -> "genre/movie/list:language=en"
```

### Integration

A single `ResponseCache` instance is created in `TMDbFactory` and
shared across all cacheable services. This ensures the
`maximumEntryCount` limit applies globally, not per-service.

The cache is injected into service implementations that support it.

**Option A (recommended): Cache at the service layer**

Each cacheable service checks the cache before calling the API client:

```swift
final class TMDbConfigurationService: ConfigurationService {
    private let apiClient: any APIClient
    private let cache: ResponseCache?

    func apiConfiguration() async throws -> APIConfiguration {
        let cacheKey = "configuration"

        if let cached = await cache?.get(cacheKey,
                                          as: APIConfiguration.self) {
            return cached
        }

        let result: APIConfiguration = try await apiClient
            .perform(APIConfigurationRequest())
        await cache?.set(cacheKey, value: result,
                         ttl: .seconds(86400))
        return result
    }
}
```

**Option B: Cache at the API client layer**

A caching decorator wraps `APIClient`, keyed by request path + params.
Simpler but less granular control over which endpoints are cached.

### Configuration Model

```swift
/// Configuration for the response cache.
public struct CacheConfiguration: Hashable, Sendable {

    /// Default time-to-live for cached entries.
    /// Default: 1 hour.
    public let defaultTTL: Duration

    /// Maximum number of entries in the cache.
    /// Default: 100.
    public let maximumEntryCount: Int

    /// Creates a cache configuration.
    public init(
        defaultTTL: Duration = .seconds(3600),
        maximumEntryCount: Int = 100
    ) { ... }

    /// A default cache configuration.
    public static let `default` = CacheConfiguration()
}
```

### Integration With `TMDbConfiguration`

Add a `cache` property to the existing configuration struct:

```swift
// Sources/TMDb/TMDbConfiguration.swift
public struct TMDbConfiguration: Sendable, Equatable {
    public let defaultLanguage: String?
    public let defaultCountry: String?
    public let cache: CacheConfiguration?    // New — nil means no cache

    public init(
        defaultLanguage: String? = nil,
        defaultCountry: String? = nil,
        cache: CacheConfiguration? = nil
    ) { ... }
}
```

> **Dependency note:** If PRD-004 (Automatic Retry) has been
> implemented first, `TMDbConfiguration` will already have a
> `retry: RetryConfiguration?` property. Add `cache` alongside it.

**`Equatable` conformance:** `TMDbConfiguration` conforms to
`Equatable`. `CacheConfiguration` must also conform to `Equatable`.
`Duration` already conforms, so the auto-synthesised `Equatable` from
`Hashable` works without manual implementation.

### Files to Create

| File | Purpose |
|------|---------|
| `Sources/TMDb/Caching/ResponseCache.swift` | Actor-based cache (new directory) |
| `Sources/TMDb/Domain/Models/CacheConfiguration.swift` | Configuration model |

### Files to Modify

| File | Change |
|------|--------|
| `Sources/TMDb/TMDbConfiguration.swift` | Add `cache` property |
| `Sources/TMDb/TMDbFactory.swift` | Create shared `ResponseCache` and inject into cacheable services |
| `Sources/TMDb/Domain/Services/Configuration/TMDbConfigurationService.swift` | Add cache lookup/store |
| `Sources/TMDb/Domain/Services/Configuration/ConfigurationService.swift` | Fix inaccurate doc comment claiming results are cached |
| `Sources/TMDb/Domain/Services/Genres/TMDbGenreService.swift` | Add cache lookup/store |
| `Sources/TMDb/Domain/Services/Certifications/TMDbCertificationService.swift` | Add cache lookup/store |
| `Sources/TMDb/Domain/Services/WatchProviders/TMDbWatchProviderService.swift` | Add cache lookup/store |
| `Sources/TMDb/TMDb.docc/TMDb.md` | Add `CacheConfiguration` to topic sections |
| `Sources/TMDb/TMDb.docc/GettingStarted/` | Document cache configuration usage |
| `README.md` | Document caching capability |

### Test Files to Create

| File | Purpose |
|------|---------|
| `Tests/TMDbTests/Caching/ResponseCacheTests.swift` | Unit tests for cache hit, miss, TTL expiration, eviction |
| `Tests/TMDbTests/Domain/Models/CacheConfigurationTests.swift` | Unit tests for configuration defaults |
| `Tests/TMDbTests/Domain/Services/Configuration/TMDbConfigurationServiceCacheTests.swift` | Verify service uses cache |
| `Tests/TMDbTests/Domain/Services/Genres/TMDbGenreServiceCacheTests.swift` | Verify service uses cache |

## Acceptance Criteria

- [ ] `ResponseCache` actor safely stores and retrieves cached values
- [ ] Cache entries expire after their TTL
- [ ] Cache evicts entries when `maximumEntryCount` is reached
- [ ] `ConfigurationService`, `GenreService`,
      `CertificationService`, and `WatchProviderService`
      implementations use the cache when configured
- [ ] Default configuration (no cache) preserves current behaviour
      with no breaking changes
- [ ] Second call within TTL returns cached data without an API
      request
- [ ] `invalidateAll()` clears all cached entries
- [ ] Unit tests verify cache hit, cache miss, TTL expiration, and
      eviction
- [ ] Integration tests confirm cached vs. fresh data behaviour
- [ ] `make ci` passes

## Dependencies

- **PRD-004 interacts with this** — both add properties to
  `TMDbConfiguration`. If implemented after PRD-004, the `retry`
  property will already exist; add `cache` alongside it.
- If neither PRD-004 nor PRD-005 has been implemented, either can go
  first.

## Out of Scope

- Disk-based persistence (rely on `URLSession` cache for that)
- Cache invalidation based on TMDb change feeds
- Per-endpoint TTL configuration by consumers
- Cache size limits by memory usage (only entry count)
- Caching of detail endpoints or search results
- Sharing cache across multiple `TMDbClient` instances
