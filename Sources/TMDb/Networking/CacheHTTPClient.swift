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
        guard request.method == .get else {
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

    private func isSuccessful(_ response: HTTPResponse) -> Bool {
        (200 ... 299).contains(response.statusCode)
    }

}
