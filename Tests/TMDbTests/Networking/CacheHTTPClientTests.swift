//
//  CacheHTTPClientTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct CacheHTTPClientTests {

    private static let defaultConfig = CacheConfiguration(
        defaultTTL: .seconds(60),
        maximumEntryCount: 100
    )

    @Test("GET cache hit returns cached response and performs request once")
    func getCacheHit() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("hello".utf8))))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.example.com/movie/550"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: url))
        _ = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(mockClient.performCount == 1)
    }

    @Test("a user-specific GET is never cached — two identical URLs both hit the network")
    func userSpecificGetIsNotCached() async throws {
        // Two users' reads of the same v4 list have byte-identical URLs; the
        // credential is only in a header. Caching by URL would serve one user's
        // private list to another.
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("alice".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("bob".utf8))))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))

        let first = try await cacheClient.perform(
            request: HTTPRequest(
                url: url,
                headers: ["Authorization": "Bearer alice"],
                isUserSpecific: true
            )
        )
        let second = try await cacheClient.perform(
            request: HTTPRequest(
                url: url,
                headers: ["Authorization": "Bearer bob"],
                isUserSpecific: true
            )
        )

        #expect(mockClient.performCount == 2)
        #expect(first.data == Data("alice".utf8))
        #expect(second.data == Data("bob".utf8))
    }

    @Test("a user-specific GET does not populate the cache for a later ordinary GET")
    func userSpecificGetDoesNotPopulateCache() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("private".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("public".utf8))))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))

        _ = try await cacheClient.perform(
            request: HTTPRequest(url: url, isUserSpecific: true)
        )
        let response = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(mockClient.performCount == 2)
        #expect(response.data == Data("public".utf8))
    }

    @Test("a bearer-token client's ordinary GET is still cached")
    func ordinaryBearerGetIsStillCached() async throws {
        // The Authorization header alone must not disable caching, or every
        // `TMDbClient(bearerToken:)` loses it for all reads.
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("movie".utf8))))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.themoviedb.org/3/movie/550"))
        let request = HTTPRequest(url: url, headers: ["Authorization": "Bearer app-token"])

        _ = try await cacheClient.perform(request: request)
        _ = try await cacheClient.perform(request: request)

        #expect(mockClient.performCount == 1)
    }

    @Test("a GET ending in /clear is treated as a mutation — never cached, and invalidating")
    func clearGetIsTreatedAsMutation() async throws {
        // `GET /4/list/{id}/clear` empties the list. Caching it would return a
        // stale success and never invalidate the list it just emptied.
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("list".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("cleared".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("empty".utf8))))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let listURL = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))
        let clearURL = try #require(URL(string: "https://api.themoviedb.org/4/list/1/clear"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: listURL))
        _ = try await cacheClient.perform(request: HTTPRequest(url: clearURL))
        let afterClear = try await cacheClient.perform(request: HTTPRequest(url: listURL))

        #expect(mockClient.performCount == 3)
        #expect(afterClear.data == Data("empty".utf8))
    }

    @Test("GET cache miss for different URLs performs request for each")
    func getCacheMiss() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url1 = try #require(URL(string: "https://api.example.com/movie/550"))
        let url2 = try #require(URL(string: "https://api.example.com/movie/551"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: url1))
        _ = try await cacheClient.perform(request: HTTPRequest(url: url2))

        #expect(mockClient.performCount == 2)
    }

    @Test("POST requests are not cached")
    func postNotCached() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.example.com/movie/550/rating"))
        let request = HTTPRequest(url: url, method: .post, body: Data())

        _ = try await cacheClient.perform(request: request)
        _ = try await cacheClient.perform(request: request)

        #expect(mockClient.performCount == 2)
    }

    @Test("DELETE requests are not cached")
    func deleteNotCached() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.example.com/movie/550/rating"))
        let request = HTTPRequest(url: url, method: .delete)

        _ = try await cacheClient.perform(request: request)
        _ = try await cacheClient.perform(request: request)

        #expect(mockClient.performCount == 2)
    }

    @Test("only 2xx responses are cached")
    func only2xxCached() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 404)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 404)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.example.com/movie/999999"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: url))
        _ = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(mockClient.performCount == 2)
    }

    @Test("cached entry expires after TTL")
    func ttlExpiration() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("first".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("second".utf8))))

        let config = CacheConfiguration(defaultTTL: .milliseconds(1), maximumEntryCount: 100)
        let cacheClient = CacheHTTPClient(httpClient: mockClient, configuration: config)
        let url = try #require(URL(string: "https://api.example.com/movie/550"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: url))
        try await Task.sleep(for: .milliseconds(50))
        _ = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(mockClient.performCount == 2)
    }

    @Test("zero TTL effectively disables caching")
    func zeroTTLDisablesCaching() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("a".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("b".utf8))))

        let config = CacheConfiguration(defaultTTL: .zero, maximumEntryCount: 100)
        let cacheClient = CacheHTTPClient(httpClient: mockClient, configuration: config)
        let url = try #require(URL(string: "https://api.example.com/movie/550"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: url))
        _ = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(mockClient.performCount == 2)
    }

    @Test("cached response preserves statusCode, data, and headers")
    func responseDataPreserved() async throws {
        let mockClient = SequencingHTTPMockClient()
        let originalData = Data("response body".utf8)
        let originalHeaders = ["Content-Type": "application/json", "X-Custom": "value"]
        mockClient.enqueue(.success(HTTPResponse(
            statusCode: 200, data: originalData, headers: originalHeaders
        )))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.example.com/movie/550"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: url))
        let cached = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(cached.statusCode == 200)
        #expect(cached.data == originalData)
        #expect(cached.headers == originalHeaders)
        #expect(mockClient.performCount == 1)
    }

    @Test("errors from underlying client propagate and are not cached")
    func errorPropagation() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(URLError(.notConnectedToInternet)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.example.com/movie/550"))

        do {
            _ = try await cacheClient.perform(request: HTTPRequest(url: url))
            Issue.record("Expected error to be thrown")
        } catch {
            // Expected
        }

        let response = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("request is forwarded unchanged to underlying client")
    func requestForwardedUnchanged() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(URL(string: "https://api.example.com/movie/550?language=en"))
        let request = HTTPRequest(url: url, method: .get, headers: ["X-Custom": "header"])

        _ = try await cacheClient.perform(request: request)

        let allRequests = mockClient.allRequests
        #expect(allRequests.count == 1)
        let forwarded = try #require(allRequests.first)
        #expect(forwarded.url == url)
        #expect(forwarded.method == .get)
        #expect(forwarded.headers["X-Custom"] == "header")
    }

}
