//
//  RetryHTTPClientNetworkErrorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

struct RetryHTTPClientNetworkErrorTests {

    private static let networkConfig = RetryConfiguration(
        maxRetries: 3,
        initialDelay: .milliseconds(1),
        maxDelay: .milliseconds(10),
        retryableErrors: [.rateLimit, .serverErrors, .networkErrors]
    )

    @Test("transient URLError then success retries and succeeds")
    func transientNetworkErrorThenSuccess() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(URLError(.timedOut)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.networkConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test(
        "transient URLError codes are retried",
        arguments: [
            URLError.Code.timedOut,
            .networkConnectionLost,
            .cannotConnectToHost,
            .notConnectedToInternet,
            .dnsLookupFailed,
            .cannotFindHost,
            .resourceUnavailable
        ]
    )
    func transientNetworkErrorCodesAreRetried(code: URLError.Code) async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(URLError(code)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.networkConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("transient URLError exhausts retries then rethrows")
    func transientNetworkErrorExhaustsRetries() async throws {
        let mockClient = SequencingHTTPMockClient()
        for _ in 0 ... 3 {
            mockClient.enqueue(.failure(URLError(.networkConnectionLost)))
        }

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.networkConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: URLError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 4)
    }

    @Test("non-transient URLError is not retried")
    func nonTransientNetworkErrorNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(URLError(.badURL)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.networkConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: URLError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

    @Test("cancelled URLError is never retried")
    func cancelledURLErrorNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(URLError(.cancelled)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.networkConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: URLError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

    @Test("CancellationError is never retried")
    func cancellationErrorNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(CancellationError()))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.networkConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: CancellationError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

    @Test("transient URLError not retried when networkErrors disabled")
    func transientNetworkErrorNotRetriedWhenDisabled() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(URLError(.timedOut)))

        let config = RetryConfiguration(
            maxRetries: 3,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: [.rateLimit, .serverErrors]
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: URLError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

    @Test("POST with transient network error is not retried")
    func postWithTransientNetworkErrorNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(URLError(.timedOut)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.networkConfig
        )
        let url = try #require(URL(string: "https://example.com"))
        let request = HTTPRequest(url: url, method: .post)

        await #expect(throws: URLError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

}
