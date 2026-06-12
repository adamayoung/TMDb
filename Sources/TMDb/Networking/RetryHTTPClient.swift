//
//  RetryHTTPClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class RetryHTTPClient: HTTPClient, Sendable {

    private let httpClient: any HTTPClient
    private let configuration: RetryConfiguration

    init(httpClient: some HTTPClient, configuration: RetryConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        // Only retry idempotent methods. Retrying a non-idempotent mutation
        // (e.g. a POST that adds to a list or rates an item) risks
        // double-applying it server-side, so perform it exactly once.
        guard request.method.isIdempotent else {
            return try await httpClient.perform(request: request)
        }

        for attempt in 0 ..< configuration.maxRetries {
            let response: HTTPResponse
            do {
                response = try await httpClient.perform(request: request)
            } catch {
                guard isRetryableError(error) else {
                    throw error
                }
                try await delay(forAttempt: attempt + 1, retryAfter: nil)
                continue
            }

            guard isRetryableResponse(response) else {
                return response
            }

            try await delay(
                forAttempt: attempt + 1,
                retryAfter: response.retryAfterDuration
            )
        }

        return try await httpClient.perform(request: request)
    }

}

extension RetryHTTPClient {

    private func isRetryableResponse(_ response: HTTPResponse) -> Bool {
        if isRetryableStatusCode(response.statusCode) {
            return true
        }

        return isMalformedSuccessResponse(response)
    }

    private func isMalformedSuccessResponse(_ response: HTTPResponse) -> Bool {
        guard configuration.retryableErrors.contains(.serverErrors) else {
            return false
        }

        guard (200 ... 299).contains(response.statusCode) else {
            return false
        }

        // A successful response whose non-empty body does not begin with a
        // valid JSON token indicates a transient infrastructure error — for
        // example a proxy or CDN returning an HTML or plain-text error page
        // with a 200 status. Treat these as retryable server errors. An empty
        // body is left alone, as some endpoints legitimately return no content.
        guard let data = response.data,
              let firstByte = data.first(where: { !$0.isJSONWhitespace })
        else {
            return false
        }

        return !firstByte.isJSONValueStart
    }

    private func isRetryableStatusCode(_ statusCode: Int) -> Bool {
        if configuration.retryableErrors.contains(.rateLimit), statusCode == 429 {
            return true
        }

        if configuration.retryableErrors.contains(.serverErrors),
           (500 ... 599).contains(statusCode) {
            return true
        }

        return false
    }

    private func isRetryableError(_ error: Error) -> Bool {
        // A deliberate cancellation must never be retried.
        if error is CancellationError {
            return false
        }

        if let apiError = error as? TMDbAPIError {
            return isRetryableAPIError(apiError)
        }

        // At the retry layer the transport adapter throws raw `URLError`s for
        // connection-level failures (timeouts, dropped connections, DNS
        // failures). Retry the transient ones when network retries are enabled.
        if let urlError = error as? URLError {
            return isRetryableURLError(urlError)
        }

        return false
    }

    private func isRetryableAPIError(_ apiError: TMDbAPIError) -> Bool {
        switch apiError {
        case .tooManyRequests:
            configuration.retryableErrors.contains(.rateLimit)

        case .internalServerError, .notImplemented, .badGateway,
             .serviceUnavailable, .gatewayTimeout:
            configuration.retryableErrors.contains(.serverErrors)

        default:
            false
        }
    }

    private func isRetryableURLError(_ urlError: URLError) -> Bool {
        guard configuration.retryableErrors.contains(.networkErrors) else {
            return false
        }

        // A URLError can wrap an explicit cancellation; never retry it.
        guard urlError.code != .cancelled else {
            return false
        }

        return Self.retryableURLErrorCodes.contains(urlError.code)
    }

    /// Transient `URLError` codes that warrant a retry.
    private static let retryableURLErrorCodes: Set<URLError.Code> = [
        .timedOut,
        .cannotConnectToHost,
        .cannotFindHost,
        .networkConnectionLost,
        .notConnectedToInternet,
        .dnsLookupFailed,
        .resourceUnavailable,
        .badServerResponse
    ]

    private func delay(forAttempt attempt: Int, retryAfter: Duration?) async throws {
        if let retryAfter {
            try await Task.sleep(for: retryAfter)
            return
        }

        let initialSeconds = Double(configuration.initialDelay.components.seconds)
            + Double(configuration.initialDelay.components.attoseconds) / 1e18
        let maxSeconds = Double(configuration.maxDelay.components.seconds)
            + Double(configuration.maxDelay.components.attoseconds) / 1e18

        let exponentialSeconds = initialSeconds * pow(2.0, Double(attempt - 1))
        let cappedSeconds = min(exponentialSeconds, maxSeconds)
        let jitteredSeconds = Double.random(in: 0 ... cappedSeconds)

        try await Task.sleep(for: .seconds(jitteredSeconds))
    }

}

private extension HTTPRequest.Method {

    /// Whether the HTTP method is idempotent and therefore safe to retry.
    ///
    /// Repeating an idempotent request has the same effect as making it once,
    /// so failed or transient responses can be retried without risk. Mutating
    /// methods such as `POST` are not idempotent and must never be retried.
    var isIdempotent: Bool {
        switch self {
        case .get, .delete:
            true

        case .post:
            false
        }
    }

}

private extension UInt8 {

    /// Whether the byte is JSON insignificant whitespace.
    var isJSONWhitespace: Bool {
        self == 0x20 || self == 0x09 || self == 0x0A || self == 0x0D
    }

    /// Whether the byte can legally begin a JSON value.
    var isJSONValueStart: Bool {
        switch self {
        case UInt8(ascii: "{"), UInt8(ascii: "["), UInt8(ascii: "\""),
             UInt8(ascii: "-"), UInt8(ascii: "t"), UInt8(ascii: "f"),
             UInt8(ascii: "n"), UInt8(ascii: "0") ... UInt8(ascii: "9"):
            true

        default:
            false
        }
    }

}
