//
//  CacheHTTPClientInvalidationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct CacheHTTPClientInvalidationTests {

    private static let defaultConfig = CacheConfiguration(
        defaultTTL: .seconds(60),
        maximumEntryCount: 100
    )

    @Test("successful POST invalidates cache")
    func postInvalidatesCache() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("first".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("second".utf8))))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let getURL = try #require(URL(string: "https://api.example.com/movie/550"))
        let postURL = try #require(URL(string: "https://api.example.com/movie/550/rating"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: getURL))
        _ = try await cacheClient.perform(
            request: HTTPRequest(url: postURL, method: .post, body: Data())
        )
        _ = try await cacheClient.perform(request: HTTPRequest(url: getURL))

        #expect(mockClient.performCount == 3)
    }

    @Test("successful DELETE invalidates cache")
    func deleteInvalidatesCache() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("first".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("second".utf8))))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let getURL = try #require(URL(string: "https://api.example.com/movie/550"))
        let deleteURL = try #require(URL(string: "https://api.example.com/movie/550/rating"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: getURL))
        _ = try await cacheClient.perform(request: HTTPRequest(url: deleteURL, method: .delete))
        _ = try await cacheClient.perform(request: HTTPRequest(url: getURL))

        #expect(mockClient.performCount == 3)
    }

    @Test("failed POST does not invalidate cache")
    func failedPostDoesNotInvalidate() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("cached".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 500)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let getURL = try #require(URL(string: "https://api.example.com/movie/550"))
        let postURL = try #require(URL(string: "https://api.example.com/movie/550/rating"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: getURL))
        _ = try await cacheClient.perform(
            request: HTTPRequest(url: postURL, method: .post, body: Data())
        )
        let response = try await cacheClient.perform(request: HTTPRequest(url: getURL))

        #expect(mockClient.performCount == 2)
        #expect(response.data == Data("cached".utf8))
    }

    @Test("thrown error from POST does not invalidate cache")
    func thrownErrorFromPostDoesNotInvalidate() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("cached".utf8))))
        mockClient.enqueue(.failure(URLError(.networkConnectionLost)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let getURL = try #require(URL(string: "https://api.example.com/movie/550"))
        let postURL = try #require(URL(string: "https://api.example.com/movie/550/rating"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: getURL))

        do {
            _ = try await cacheClient.perform(
                request: HTTPRequest(url: postURL, method: .post, body: Data())
            )
        } catch {
            // Expected error
        }

        let response = try await cacheClient.perform(request: HTTPRequest(url: getURL))

        #expect(mockClient.performCount == 2)
        #expect(response.data == Data("cached".utf8))
    }

    @Test("GET with session_id query parameter bypasses cache")
    func sessionIdBypassesCache() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(
            URL(string: "https://api.example.com/account?session_id=abc123")
        )

        _ = try await cacheClient.perform(request: HTTPRequest(url: url))
        _ = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(mockClient.performCount == 2)
    }

    @Test("GET with guest_session path bypasses cache")
    func guestSessionPathBypassesCache() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let url = try #require(
            URL(string: "https://api.example.com/guest_session/abc123/rated/movies")
        )

        _ = try await cacheClient.perform(request: HTTPRequest(url: url))
        _ = try await cacheClient.perform(request: HTTPRequest(url: url))

        #expect(mockClient.performCount == 2)
    }

    @Test("evicts oldest entry when at maximum capacity")
    func maxEntryEviction() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("a".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("b".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("c".utf8))))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("a-again".utf8))))

        let config = CacheConfiguration(defaultTTL: .seconds(60), maximumEntryCount: 2)
        let cacheClient = CacheHTTPClient(httpClient: mockClient, configuration: config)
        let urlA = try #require(URL(string: "https://api.example.com/a"))
        let urlB = try #require(URL(string: "https://api.example.com/b"))
        let urlC = try #require(URL(string: "https://api.example.com/c"))

        _ = try await cacheClient.perform(request: HTTPRequest(url: urlA))
        _ = try await cacheClient.perform(request: HTTPRequest(url: urlB))
        _ = try await cacheClient.perform(request: HTTPRequest(url: urlC))
        _ = try await cacheClient.perform(request: HTTPRequest(url: urlA))

        #expect(mockClient.performCount == 4)
    }

}
