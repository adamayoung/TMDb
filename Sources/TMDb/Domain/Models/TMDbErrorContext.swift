//
//  TMDbErrorContext.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Structured context attached to a ``TMDbError`` describing a failed request.
///
/// Populated from the failing HTTP response, this surfaces the detail needed to
/// diagnose a production failure: the HTTP status code, TMDb's own numeric
/// ``TMDbStatusCode``, the server-supplied message, the endpoint that failed, and
/// the `Retry-After` delay on a rate-limited request.
///
/// Every field is optional — a failure raised before a request is sent (for
/// example a client-side validation error) carries only a ``statusMessage``.
///
/// - Note: ``endpointPath`` is redacted: token-bearing path segments such as a
///   guest session id or account id are replaced with a placeholder, so the
///   context is safe to log.
///
public struct TMDbErrorContext: Equatable, Hashable, Sendable {

    ///
    /// The HTTP status code of the response, such as `404`.
    ///
    public let httpStatusCode: Int?

    ///
    /// TMDb's numeric status code from the response body, such as
    /// ``TMDbStatusCode/resourceNotFound``.
    ///
    public let tmdbStatusCode: TMDbStatusCode?

    ///
    /// The human-readable `status_message` supplied by TMDb.
    ///
    public let statusMessage: String?

    ///
    /// The endpoint path that failed, with any token-bearing segments redacted,
    /// such as `/account/{account_id}/favorite`.
    ///
    public let endpointPath: String?

    ///
    /// The delay before retrying, taken from the `Retry-After` response header on
    /// a rate-limited (HTTP 429) request.
    ///
    public let retryAfter: Duration?

    ///
    /// Creates error context.
    ///
    /// - Parameters:
    ///   - httpStatusCode: The HTTP status code of the response.
    ///   - tmdbStatusCode: TMDb's numeric status code from the response body.
    ///   - statusMessage: The human-readable message supplied by TMDb.
    ///   - endpointPath: The redacted endpoint path that failed.
    ///   - retryAfter: The delay before retrying, from the `Retry-After` header.
    ///
    public init(
        httpStatusCode: Int? = nil,
        tmdbStatusCode: TMDbStatusCode? = nil,
        statusMessage: String? = nil,
        endpointPath: String? = nil,
        retryAfter: Duration? = nil
    ) {
        self.httpStatusCode = httpStatusCode
        self.tmdbStatusCode = tmdbStatusCode
        self.statusMessage = statusMessage
        self.endpointPath = endpointPath
        self.retryAfter = retryAfter
    }

}
