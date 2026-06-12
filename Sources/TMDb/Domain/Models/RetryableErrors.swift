//
//  RetryableErrors.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Defines the categories of HTTP errors that should be retried.
///
/// Use this option set to configure which types of transient errors
/// trigger automatic retries when using ``RetryConfiguration``.
///
/// ```swift
/// // Retry only rate limit errors
/// let retryableErrors: RetryableErrors = .rateLimit
///
/// // Retry both rate limits and server errors
/// let retryableErrors: RetryableErrors = [.rateLimit, .serverErrors]
/// ```
///
public struct RetryableErrors: OptionSet, Hashable, Sendable {

    /// The raw value of the option set.
    public let rawValue: Int

    ///
    /// Creates a retryable errors set from a raw value.
    ///
    /// - Parameter rawValue: The raw value representing the error categories.
    ///
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// HTTP 429 Too Many Requests.
    public static let rateLimit = RetryableErrors(rawValue: 1 << 0)

    /// HTTP 5xx server errors.
    ///
    /// This also covers successful (2xx) responses whose body is not valid
    /// JSON, which indicate a transient server-side or infrastructure error
    /// (such as a proxy returning an error page with a 200 status).
    public static let serverErrors = RetryableErrors(rawValue: 1 << 1)

    /// Transient network transport errors.
    ///
    /// Covers connection-level `URLError`s that are usually temporary, such as
    /// a request timing out, a dropped connection, a DNS lookup failure, or a
    /// failure to reach the host. Deliberate cancellations are never retried.
    public static let networkErrors = RetryableErrors(rawValue: 1 << 2)

}
