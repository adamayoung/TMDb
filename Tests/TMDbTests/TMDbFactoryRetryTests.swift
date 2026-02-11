//
//  TMDbFactoryRetryTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct TMDbFactoryRetryTests {

    @Test("httpClient with nil retryConfiguration returns original client")
    func httpClientWithNilRetryConfigurationReturnsOriginal() {
        let mockClient = SequencingHTTPMockClient()

        let result = TMDbFactory.httpClient(
            wrapping: mockClient,
            retryConfiguration: nil,
            cacheConfiguration: nil
        )

        #expect(result is SequencingHTTPMockClient)
    }

    @Test("httpClient with retryConfiguration returns RetryHTTPClient")
    func httpClientWithRetryConfigurationReturnsRetryClient() {
        let mockClient = SequencingHTTPMockClient()
        let config = RetryConfiguration.default

        let result = TMDbFactory.httpClient(
            wrapping: mockClient,
            retryConfiguration: config,
            cacheConfiguration: nil
        )

        #expect(result is RetryHTTPClient)
    }

    @Test("httpClient with cacheConfiguration returns CacheHTTPClient")
    func httpClientWithCacheConfigurationReturnsCacheClient() {
        let mockClient = SequencingHTTPMockClient()
        let config = CacheConfiguration.default

        let result = TMDbFactory.httpClient(
            wrapping: mockClient,
            retryConfiguration: nil,
            cacheConfiguration: config
        )

        #expect(result is CacheHTTPClient)
    }

    @Test("httpClient with both configurations wraps cache around retry")
    func httpClientWithBothConfigurationsWrapsCacheAroundRetry() {
        let mockClient = SequencingHTTPMockClient()

        let result = TMDbFactory.httpClient(
            wrapping: mockClient,
            retryConfiguration: .default,
            cacheConfiguration: .default
        )

        #expect(result is CacheHTTPClient)
    }

    @Test("cache hit with both configurations skips retry and network")
    func cacheHitSkipsRetryAndNetwork() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("ok".utf8))))

        let wrappedClient = TMDbFactory.httpClient(
            wrapping: mockClient,
            retryConfiguration: .default,
            cacheConfiguration: .default
        )
        let url = try #require(URL(string: "https://api.example.com/movie/550"))
        let request = HTTPRequest(url: url)

        _ = try await wrappedClient.perform(request: request)
        let cached = try await wrappedClient.perform(request: request)

        #expect(mockClient.performCount == 1)
        #expect(cached.data == Data("ok".utf8))
    }

}
