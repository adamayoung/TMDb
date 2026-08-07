//
//  RetryHTTPClientIdempotencyTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Which methods may be replayed. Split from `RetryHTTPClientTests` so neither
/// suite breaches swiftlint's `type_body_length`.
///
@Suite(.tags(.networking))
struct RetryHTTPClientIdempotencyTests {

    private static let fastConfig = RetryConfiguration(
        maxRetries: 3,
        initialDelay: .milliseconds(1),
        maxDelay: .milliseconds(10),
        retryableErrors: [.rateLimit, .serverErrors]
    )

    @Test("PUT with a retryable response is retried — it is idempotent")
    func putWithRetryableResponseIsRetried() async throws {
        // PUT replaces the resource with the request's own representation, so
        // replaying it converges on the same state.
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let url = try #require(URL(string: "https://example.com"))
        let request = HTTPRequest(url: url, method: .put)

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("a state-changing GET is not retried, despite GET being idempotent")
    func stateChangingGetIsNotRetried() async throws {
        // `GET /4/list/{id}/clear` empties the list. Replaying it after a lost
        // response reports `items_deleted: 0` for a clear that did happen.
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1/clear"))

        let response = try await retryClient.perform(request: HTTPRequest(url: url))

        #expect(response.statusCode == 429)
        #expect(mockClient.performCount == 1)
    }

    @Test("an ordinary GET is still retried")
    func ordinaryGetIsRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))

        let response = try await retryClient.perform(request: HTTPRequest(url: url))

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("POST with a retryable response is not retried — it appends")
    func postWithRetryableResponseIsNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let url = try #require(URL(string: "https://example.com"))
        let request = HTTPRequest(url: url, method: .post)

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 429)
        #expect(mockClient.performCount == 1)
    }

}
