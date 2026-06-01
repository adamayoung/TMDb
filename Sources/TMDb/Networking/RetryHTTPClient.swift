//
//  RetryHTTPClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class RetryHTTPClient: HTTPClient, Sendable {

    private let httpClient: any HTTPClient
    private let configuration: RetryConfiguration

    init(httpClient: some HTTPClient, configuration: RetryConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
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
        guard let apiError = error as? TMDbAPIError else {
            return false
        }

        switch apiError {
        case .tooManyRequests:
            return configuration.retryableErrors.contains(.rateLimit)

        case .internalServerError, .notImplemented, .badGateway,
             .serviceUnavailable, .gatewayTimeout:
            return configuration.retryableErrors.contains(.serverErrors)

        default:
            return false
        }
    }

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
