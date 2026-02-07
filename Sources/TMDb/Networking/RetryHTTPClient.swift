//
//  RetryHTTPClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class RetryHTTPClient: HTTPClient {

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

            guard isRetryableStatusCode(response.statusCode) else {
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
