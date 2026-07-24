//
//  RetryHTTPClientTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct RetryHTTPClientTests {

    private static let fastConfig = RetryConfiguration(
        maxRetries: 3,
        initialDelay: .milliseconds(1),
        maxDelay: .milliseconds(10),
        retryableErrors: [.rateLimit, .serverErrors]
    )

    @Test("success on first attempt performs request once")
    func successOnFirstAttempt() async throws {
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

    @Test("429 exhausts retries and returns last response")
    func rateLimitExhaustsRetries() async throws {
        let mockClient = SequencingHTTPMockClient()
        for _ in 0 ... 3 {
            mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))
        }

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 429)
        #expect(mockClient.performCount == 4)
    }

    @Test("500 then 200 succeeds on second attempt")
    func serverErrorThenSuccess() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 500)))
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

    @Test("429 with Retry-After header retries")
    func rateLimitWithRetryAfterHeader() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 429, headers: ["Retry-After": "1"]))
        )
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let config = RetryConfiguration(
            maxRetries: 1,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: [.rateLimit]
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
    }

    @Test("Retry-After larger than maxDelay is capped to maxDelay")
    func retryAfterCappedToMaxDelay() async throws {
        let mockClient = SequencingHTTPMockClient()
        // An untrusted server returns an unreasonably large Retry-After. The
        // client must not block for the full duration — it caps the sleep to
        // configuration.maxDelay.
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 429, headers: ["Retry-After": "100"]))
        )
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let config = RetryConfiguration(
            maxRetries: 1,
            initialDelay: .milliseconds(1),
            maxDelay: .milliseconds(10),
            retryableErrors: [.rateLimit]
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let start = ContinuousClock.now
        let response = try await retryClient.perform(request: request)
        let elapsed = ContinuousClock.now - start

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
        // The 100-second Retry-After must have been capped well below itself.
        #expect(elapsed < .seconds(5))
    }

    @Test("Retry-After smaller than maxDelay is honoured unchanged")
    func retryAfterSmallerThanMaxDelay() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 429, headers: ["Retry-After": "0"]))
        )
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let config = RetryConfiguration(
            maxRetries: 1,
            initialDelay: .milliseconds(1),
            maxDelay: .seconds(30),
            retryableErrors: [.rateLimit]
        )
        let retryClient = RetryHTTPClient(httpClient: mockClient, configuration: config)
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let start = ContinuousClock.now
        let response = try await retryClient.perform(request: request)
        let elapsed = ContinuousClock.now - start

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 2)
        // A zero-second Retry-After should not be inflated to maxDelay.
        #expect(elapsed < .seconds(5))
    }

    @Test("404 is not retried")
    func notFoundNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 404)))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 404)
        #expect(mockClient.performCount == 1)
    }

    @Test("POST with retryable response is not retried")
    func postWithRetryableResponseNotRetried() async throws {
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

    @Test("POST with retryable error is not retried")
    func postWithRetryableErrorNotRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.failure(TMDbAPIError.tooManyRequests(TMDbErrorContext())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let url = try #require(URL(string: "https://example.com"))
        let request = HTTPRequest(url: url, method: .post)

        await #expect(throws: TMDbAPIError.self) {
            _ = try await retryClient.perform(request: request)
        }

        #expect(mockClient.performCount == 1)
    }

    @Test("502 bad gateway is retried")
    func badGatewayIsRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 502)))
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

    @Test("503 service unavailable is retried")
    func serviceUnavailableIsRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 503)))
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

    @Test("504 gateway timeout is retried")
    func gatewayTimeoutIsRetried() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 504)))
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

    @Test("500 exhausts retries and returns last 500 response")
    func serverErrorExhaustsRetriesReturnsResponse() async throws {
        let mockClient = SequencingHTTPMockClient()
        for _ in 0 ... 3 {
            mockClient.enqueue(.success(HTTPResponse(statusCode: 500)))
        }

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 500)
        #expect(mockClient.performCount == 4)
    }

    @Test("mixed 5xx then 429 then success retries all")
    func mixedServerErrorAndRateLimitThenSuccess() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 502)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 429)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let request = try HTTPRequest(url: #require(URL(string: "https://example.com")))

        let response = try await retryClient.perform(request: request)

        #expect(response.statusCode == 200)
        #expect(mockClient.performCount == 3)
    }

    @Test("request is forwarded unchanged on each retry")
    func requestForwardedUnchanged() async throws {
        let mockClient = SequencingHTTPMockClient()
        mockClient.enqueue(.success(HTTPResponse(statusCode: 500)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 500)))
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data())))

        let retryClient = RetryHTTPClient(
            httpClient: mockClient,
            configuration: Self.fastConfig
        )
        let url = try #require(URL(string: "https://example.com/test?key=value"))
        let request = HTTPRequest(url: url, method: .get, headers: ["X-Custom": "header"])

        _ = try await retryClient.perform(request: request)

        let allRequests = mockClient.allRequests
        #expect(allRequests.count == 3)
        for receivedRequest in allRequests {
            #expect(receivedRequest.url == url)
            #expect(receivedRequest.method == .get)
            #expect(receivedRequest.headers["X-Custom"] == "header")
        }
    }

}
