//
//  CacheConfiguration.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Configuration for in-memory HTTP response caching.
///
/// Use this to configure automatic caching of GET responses. All successful
/// GET requests are cached; user-specific requests (with session IDs) are
/// excluded. Any successful POST or DELETE request invalidates the entire
/// cache.
///
/// This is an optional in-memory layer that sits above the default on-disk
/// `URLCache` (enabled automatically on Apple platforms). It is cleared when
/// the process ends and uses a single fixed time-to-live rather than the
/// per-response `max-age` honoured by `URLCache`. See <doc:CachingResponses>
/// for how the two layers interact.
///
/// ```swift
/// let cacheConfig = CacheConfiguration(
///     defaultTTL: .seconds(1800),
///     maximumEntryCount: 200
/// )
///
/// let configuration = TMDbConfiguration(cache: cacheConfig)
/// let client = TMDbClient(apiKey: "your-api-key", configuration: configuration)
/// ```
///
public struct CacheConfiguration: Hashable, Sendable {

    ///
    /// The default time-to-live for cached responses.
    ///
    /// Each cached entry expires after this duration. Defaults to 1 hour.
    /// Values less than `.zero` are clamped to `.zero`.
    ///
    public let defaultTTL: Duration

    ///
    /// The maximum number of entries the cache can hold.
    ///
    /// When the cache is full, the entry closest to expiration is evicted.
    /// Defaults to `100`. Values less than `1` are clamped to `1`.
    ///
    public let maximumEntryCount: Int

    ///
    /// Creates a cache configuration.
    ///
    /// - Parameters:
    ///   - defaultTTL: The time-to-live for cached responses. Defaults to 1 hour.
    ///   - maximumEntryCount: The maximum number of cache entries. Defaults to `100`.
    ///
    public init(
        defaultTTL: Duration = .seconds(3600),
        maximumEntryCount: Int = 100
    ) {
        self.defaultTTL = max(.zero, defaultTTL)
        self.maximumEntryCount = max(1, maximumEntryCount)
    }

    ///
    /// The default cache configuration.
    ///
    /// Uses a 1-hour TTL and a maximum of 100 entries.
    ///
    public static let `default` = CacheConfiguration()

}
