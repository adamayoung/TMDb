//
//  RetryHTTPClientMalformedResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct RetryHTTPClientMalformedResponseTests {

    private static let fastConfig = RetryConfiguration(
        maxRetries: 3,
        initialDelay: .milliseconds(1),
        maxDelay: .milliseconds(10),
        retryableErrors: [.rateLimit, .serverErrors]
    )

    @Test("200 with non-JSON body is retried")
    func malformedSuccessBodyIsRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("just a moment".utf8)))
        )
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("{\"page\":1}".utf8)))
        )

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(response.data == Data("{\"page\":1}".utf8))
        #expect(mockClient.performCount == 2)
    }

    @Test("200 with leading whitespace then valid JSON is not retried")
    func successBodyWithLeadingWhitespaceNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("  \n{\"page\":1}".utf8)))
        )

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 1)
    }

    @Test("200 with JSON array body is not retried")
    func successBodyWithJSONArrayNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("[1,2,3]".utf8)))
        )

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 1)
    }

    @Test("200 with empty body is not retried")
    func successWithEmptyBodyNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 1)
    }

    @Test("200 with non-JSON body is not retried when server errors disabled")
    func malformedSuccessBodyNotRetriedWhenServerErrorsDisabled() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("just a moment".utf8)))
        )

        let config = RetryConfiguration(
            maxRetries: 3,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: [.rateLimit]
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 1)
    }

    @Test("200 with non-JSON body exhausts retries and returns last response")
    func malformedSuccessBodyExhaustsRetries() async throws {
        let mockClient = SequencingHTTPMockClient()
        for _ in 0 ... 3 {
            mockClient.enqueue(
                .success(HTTPResponse(statusCode: 200, data: Data("just a moment".utf8)))
            )
        }

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 4)
    }

}
