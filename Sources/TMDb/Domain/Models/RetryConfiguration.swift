//
//  RetryConfiguration.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Configuration for automatic retry with exponential backoff.
///
/// Use this to configure retry behaviour for transient HTTP errors such as
/// rate limiting (HTTP 429) and server errors (HTTP 5xx).
///
/// ```swift
/// let retryConfig = RetryConfiguration(
///     maxRetries: 5,
///     initialDelay: .seconds(2),
///     retryableErrors: .rateLimit
/// )
///
/// let configuration = TMDbConfiguration(retry: retryConfig)
/// let client = TMDbClient(apiKey: "your-api-key", configuration: configuration)
/// ```
///
public struct RetryConfiguration: Hashable, Sendable {

    ///
    /// The maximum number of retry attempts.
    ///
    /// Defaults to `3`. Values less than `0` are clamped to `0`.
    ///
    public let maxRetries: Int

    ///
    /// The initial delay before the first retry.
    ///
    /// Subsequent retries use exponential backoff based on this value.
    /// Defaults to 1 second.
    ///
    public let initialDelay: Duration

    ///
    /// The maximum delay between retries.
    ///
    /// Exponential backoff is capped at this value. Defaults to 30 seconds.
    ///
    public let maxDelay: Duration

    ///
    /// The categories of errors that should trigger a retry.
    ///
    /// Defaults to both ``RetryableErrors/rateLimit`` and
    /// ``RetryableErrors/serverErrors``.
    ///
    public let retryableErrors: RetryableErrors

    ///
    /// Creates a retry configuration.
    ///
    /// - Parameters:
    ///   - maxRetries: The maximum number of retry attempts. Defaults to `3`.
    ///   - initialDelay: The initial delay before the first retry. Defaults to 1 second.
    ///   - maxDelay: The maximum delay between retries. Defaults to 30 seconds.
    ///   - retryableErrors: The error categories to retry. Defaults to rate limit and server errors.
    ///
    public init(
        maxRetries: Int = 3,
        initialDelay: Duration = .seconds(1),
        maxDelay: Duration = .seconds(30),
        retryableErrors: RetryableErrors = [.rateLimit, .serverErrors]
    ) {
        self.maxRetries = max(0, maxRetries)
        self.initialDelay = initialDelay
        self.maxDelay = maxDelay
        self.retryableErrors = retryableErrors
    }

    ///
    /// The default retry configuration.
    ///
    /// Uses 3 retries, 1 second initial delay, 30 second max delay,
    /// and retries both rate limit and server errors.
    ///
    public static let `default` = RetryConfiguration()

}
