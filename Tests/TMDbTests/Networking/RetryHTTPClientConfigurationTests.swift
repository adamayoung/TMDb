//
//  RetryHTTPClientConfigurationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct RetryHTTPClientConfigurationTests {

    private static let fastConfig = RetryConfiguration(
        maxRetries: 3,
        initialDelay: .milliseconds(1),
        maxDelay: .milliseconds(10),
        retryableErrors: [.rateLimit, .serverErrors]
    )

    @Test("non-retryable thrown error propagates immediately")
    func nonRetryableErrorPropagatesImmediately() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(TMDbAPIError.notFound("Not found")))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: TMDbAPIError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

    @Test("non-TMDbAPIError thrown error is not retried")
    func nonTMDbAPIErrorNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        let urlError = URLError(.networkConnectionLost)
        mockClient.enqueue(.failure(urlError))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: URLError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

    @Test("retryable thrown tooManyRequests is retried then succeeds")
    func retryableThrownErrorRetriedThenSucceeds() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(TMDbAPIError.tooManyRequests("rate limited")))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("thrown internalServerError is retried then succeeds")
    func thrownInternalServerErrorRetriedThenSucceeds() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(TMDbAPIError.internalServerError("server error")))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("thrown serviceUnavailable is retried then succeeds")
    func thrownServiceUnavailableRetriedThenSucceeds() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(TMDbAPIError.serviceUnavailable("unavailable")))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("thrown server error exhausts retries")
    func thrownServerErrorExhaustsRetries() async throws {
        let mockClient = SequencingHTTPMockClient()
        for _ in 0 ... 3 {
            mockClient.enqueue(.failure(TMDbAPIError.internalServerError("server error")))
        }

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        await #expect(throws: TMDbAPIError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 4)
    }

    @Test("empty retryableErrors means no retry")
    func emptyRetryableErrorsNoRetry() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))

        let config = RetryConfiguration(
            maxRetries: 3,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: []
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 429)
        #expect(mockClient.performCount == 1)
    }

    @Test("only rateLimit configured does not retry 500")
    func onlyRateLimitDoesNotRetryServerError() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 500)))

        let config = RetryConfiguration(
            maxRetries: 3,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: .rateLimit
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 500)
        #expect(mockClient.performCount == 1)
    }

    @Test("only serverErrors configured does not retry 429")
    func onlyServerErrorsDoesNotRetryRateLimit() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))

        let config = RetryConfiguration(
            maxRetries: 3,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: .serverErrors
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 429)
        #expect(mockClient.performCount == 1)
    }

    @Test("cancellation stops retry loop")
    func cancellationStopsLoop() async throws {
        let mockClient = SequencingHTTPMockClient()
        for _ in 0 ... 3 {
            mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))
        }

        let config = RetryConfiguration(
            maxRetries: 3,
            initialDelay: .seconds(60),
            maxDelay: .seconds(60),
            retryableErrors: [.rateLimit]
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let task = Task {
            try await retryClient.perform(request: request)
        }

        try await Task.sleep(for: .milliseconds(50))
        task.cancel()

        await #expect(throws: (any Error).self) {
            try await task.value
        }
    }

    @Test("maxRetries zero means single attempt only")
    func maxRetriesZeroSingleAttempt() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))

        let config = RetryConfiguration(
            maxRetries: 0,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: [.rateLimit]
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 429)
        #expect(mockClient.performCount == 1)
    }

}
