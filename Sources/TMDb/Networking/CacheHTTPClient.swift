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
    private let defaultTTL: Duration
    private let maximumEntryCount: Int
    private let clock = ContinuousClock()

    init(defaultTTL: Duration, maximumEntryCount: Int) {
        self.defaultTTL = defaultTTL
        self.maximumEntryCount = maximumEntryCount
    }

    func response(forKey key: String) -> HTTPResponse? {
        guard let entry = entries[key] else {
            return nil
        }

        if clock.now >= entry.expiresAt {
            entries.removeValue(forKey: key)
            return nil
        }

        return entry.response
    }

    func setResponse(_ response: HTTPResponse, forKey key: String) {
        sweepExpired()

        if entries.count >= maximumEntryCount {
            evictOldest()
        }

        let expiresAt = clock.now + defaultTTL
        entries[key] = CacheEntry(response: response, expiresAt: expiresAt)
    }

    func removeAll() {
        entries.removeAll()
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

        if let cachedResponse = await cache.response(forKey: cacheKey) {
            return cachedResponse
        }

        let response = try await httpClient.perform(request: request)

        if isSuccessful(response) {
            await cache.setResponse(response, forKey: cacheKey)
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
