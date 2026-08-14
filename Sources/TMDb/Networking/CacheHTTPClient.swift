//
//  CacheHTTPClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

private actor ResponseCache {

    private struct CacheEntry {
        let response: HTTPResponse
        let expiresAt: ContinuousClock.Instant
    }

    private var entries: [String: CacheEntry] = [:]
    private var generation: UInt64 = 0
    private let defaultTTL: Duration
    private let maximumEntryCount: Int
    private let clock = ContinuousClock()

    init(defaultTTL: Duration, maximumEntryCount: Int) {
        self.defaultTTL = defaultTTL
        self.maximumEntryCount = maximumEntryCount
    }

    /// Looks `key` up, and reports the generation that lookup observed.
    ///
    /// Both come from a single actor turn, so a caller that misses can hand the
    /// generation back to ``setResponse(_:forKey:ifGeneration:)`` and have its
    /// write rejected if the cache was invalidated while it was fetching.
    func lookup(forKey key: String) -> (response: HTTPResponse?, generation: UInt64) {
        guard let entry = entries[key] else {
            return (nil, generation)
        }

        if clock.now >= entry.expiresAt {
            entries.removeValue(forKey: key)
            return (nil, generation)
        }

        return (entry.response, generation)
    }

    /// Stores `response`, unless the cache was invalidated since
    /// `expectedGeneration` was observed.
    ///
    /// A response fetched before an invalidation describes pre-mutation state,
    /// so storing it would serve stale data for a whole TTL — exactly what the
    /// invalidation exists to prevent.
    func setResponse(
        _ response: HTTPResponse,
        forKey key: String,
        ifGeneration expectedGeneration: UInt64
    ) {
        guard expectedGeneration == generation else {
            return
        }

        sweepExpired()

        if entries.count >= maximumEntryCount {
            evictOldest()
        }

        let expiresAt = clock.now + defaultTTL
        entries[key] = CacheEntry(response: response, expiresAt: expiresAt)
    }

    func removeAll() {
        entries.removeAll()

        // Bumped unconditionally, including when `entries` is already empty.
        // During the race this guards, the cache is *typically* empty — the only
        // read is still in flight and has yet to write — so guarding the bump on
        // `!entries.isEmpty` would reinstate the bug it exists to close.
        generation &+= 1
    }

    private func sweepExpired() {
        let now = clock.now
        entries = entries.filter { $0.value.expiresAt > now }
    }

    private func evictOldest() {
        if let oldestKey = entries.min(
            by: { $0.value.expiresAt < $1.value.expiresAt }
        )?.key {
            entries.removeValue(forKey: oldestKey)
        }
    }

}

///
/// An `HTTPClient` decorator that caches successful `GET` responses in memory.
///
/// Cache hits short-circuit the wrapped client. Requests needing a *user's*
/// credential bypass the cache entirely — see ``HTTPRequest/isUserSpecific`` —
/// and any successful mutation invalidates the whole cache. A mutation here
/// means a `POST`, `PUT` or `DELETE`, **or** a state-changing `GET`: TMDb
/// clears a v4 list with `GET /4/list/{id}/clear`, which must invalidate rather
/// than be cached. This layer sits above the underlying transport's own on-disk
/// `URLCache`.
///
/// Invalidation covers reads that were already in flight: a response fetched
/// before a mutation landed carries pre-mutation state, so it is still returned
/// to its caller but is not written to the cache. Each read captures the cache's
/// generation when it looks up, and a mutation bumps that generation — see
/// `ResponseCache.setResponse(_:forKey:ifGeneration:)`.
///
final class CacheHTTPClient: HTTPClient, Sendable {

    private let httpClient: any HTTPClient
    private let configuration: CacheConfiguration
    private let cache: ResponseCache

    init(httpClient: some HTTPClient, configuration: CacheConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
        self.cache = ResponseCache(
            defaultTTL: configuration.defaultTTL,
            maximumEntryCount: configuration.maximumEntryCount
        )
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        guard request.method == .get, !isStateChanging(request) else {
            return try await performMutation(request: request)
        }

        if isUserSpecificRequest(request) {
            return try await httpClient.perform(request: request)
        }

        let cacheKey = request.url.absoluteString
        let (cachedResponse, generation) = await cache.lookup(forKey: cacheKey)

        if let cachedResponse {
            return cachedResponse
        }

        let response = try await httpClient.perform(request: request)

        if isSuccessful(response) {
            await cache.setResponse(response, forKey: cacheKey, ifGeneration: generation)
        }

        return response
    }

}

extension CacheHTTPClient {

    private func performMutation(request: HTTPRequest) async throws -> HTTPResponse {
        let response = try await httpClient.perform(request: request)

        if isSuccessful(response) {
            await cache.removeAll()
        }

        return response
    }

    private func isUserSpecificRequest(_ request: HTTPRequest) -> Bool {
        // Set by `TMDbAPIClient` when the request carried its own credential —
        // the v4 endpoints thread a user access token per call, so two users'
        // reads of one list share a URL and differ only by a header.
        if request.isUserSpecific {
            return true
        }

        if let components = URLComponents(url: request.url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems,
           queryItems.contains(where: { $0.name == "session_id" }) {
            return true
        }

        if request.url.path.contains("/guest_session/") {
            return true
        }

        return false
    }

    private func isStateChanging(_ request: HTTPRequest) -> Bool {
        request.isStateChangingGET
    }

    private func isSuccessful(_ response: HTTPResponse) -> Bool {
        (200 ... 299).contains(response.statusCode)
    }

}
