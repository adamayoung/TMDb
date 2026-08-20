//
//  TMDbError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A TMDb error.
///
/// The failure cases raised from a request carry a ``TMDbErrorContext`` with the
/// HTTP status code, TMDb's numeric ``TMDbStatusCode``, the server message, the
/// (redacted) endpoint, and any `Retry-After` delay — read it to diagnose a
/// failure. Two errors are equal when they are the same case with equal context
/// (the ``network(_:)``, ``decode(_:)`` and ``encode(_:)`` cases compare only by
/// case, since a Swift `Error` is not `Equatable`).
///
public enum TMDbError: Equatable, LocalizedError, Sendable {

    /// An error indicating an invalid request was made.
    case badRequest(TMDbErrorContext = TMDbErrorContext())

    /// An error indicating the request was not authorised.
    case unauthorised(TMDbErrorContext = TMDbErrorContext())

    /// An error indicating access to the resource is forbidden.
    case forbidden(TMDbErrorContext = TMDbErrorContext())

    /// An error indicating the resource could not be found.
    case notFound(TMDbErrorContext = TMDbErrorContext())

    /// An error indicating too many requests have been made.
    case tooManyRequests(TMDbErrorContext = TMDbErrorContext())

    /// An error indicating there was a server error.
    case serverError(TMDbErrorContext = TMDbErrorContext())

    /// An error indicating a request URL could not be constructed from the given
    /// value, or was rejected as unsafe before any request was sent.
    ///
    /// A path segment is rejected when it cannot be certified inert: when it is
    /// the dot-segment `.` or `..`, when it decodes to contain a `/`, when it
    /// still contains a `%` after one decode, or when it contains a control
    /// character. The first two are the traversal cases — the API server decodes
    /// the path and resolves the dot-segments, so such an identifier would
    /// redirect the request to a *different* endpoint while it still carries
    /// your credentials.
    ///
    /// Such a value is refused on-device rather than sent. A caller passing an
    /// identifier of an unexpected shape — a pasted URL, say — receives this
    /// error rather than a response describing some other resource.
    ///
    /// The associated path is redacted in the same way as
    /// ``TMDbErrorContext/endpointPath``, so it is safe to log.
    case invalidURL(String)

    /// An error indicating there was a problem encoding data.
    case encode(Error)

    ///
    /// An error indicating there was a network problem.
    ///
    /// The associated error is the transport failure, with your credentials
    /// removed — so it is safe to log, forward to a crash reporter, or attach to
    /// an analytics breadcrumb.
    ///
    /// A `URLSession` failure carries the whole URL of the request that failed
    /// in its `userInfo`, and for a client created with ``TMDbClient/init(apiKey:configuration:)``
    /// that URL contains your `api_key`. Before the error is attached here, the
    /// value of any credential-bearing query item — and any guest session id or
    /// account id in the path — is replaced with `REDACTED`. The error keeps its
    /// `domain`, `code` and `localizedDescription`, so branching on those is
    /// unaffected; other diagnostic `userInfo` entries are dropped, because they
    /// can nest a copy of the same URL.
    ///
    /// An error with nothing to redact — including one thrown by your own
    /// ``HTTPClient`` — is attached exactly as it was raised, so its concrete
    /// type still matches in a `catch`.
    ///
    case network(Error)

    /// An error indicating there was a problem decoding data.
    case decode(Error)

    /// An error indicating an invalid rating value was provided.
    case invalidRating

    ///
    /// An error indicating the task performing the request was cancelled.
    ///
    /// Thrown when the calling `Task` is cancelled while a request is in flight
    /// or waiting to be retried — for example a SwiftUI `.task {}` whose view is
    /// dismissed. It is never the result of a network or server failure, so
    /// treat it as "the caller changed their mind", not as an error to report or
    /// retry.
    ///
    /// - Note: Cancellation is only reported when the library actually observes
    ///   it. A cached image configuration is returned without suspending, and so
    ///   without noticing the cancellation. An auto-pagination sequence, by
    ///   contrast, checks *before* serving buffered items, so a cancelled scan
    ///   throws at the next element even with a page still buffered.
    ///
    case cancelled

    /// An unknown error.
    case unknown

    ///
    /// Returns a Boolean value indicating whether two instances are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    ///
    /// - Returns: `true` if equal, or `false` if not.
    ///
    public static func == (lhs: TMDbError, rhs: TMDbError) -> Bool {
        switch (lhs, rhs) {
        case (.badRequest(let lhsContext), .badRequest(let rhsContext)):
            lhsContext == rhsContext

        case (.unauthorised(let lhsContext), .unauthorised(let rhsContext)):
            lhsContext == rhsContext

        case (.forbidden(let lhsContext), .forbidden(let rhsContext)):
            lhsContext == rhsContext

        case (.notFound(let lhsContext), .notFound(let rhsContext)):
            lhsContext == rhsContext

        case (.tooManyRequests(let lhsContext), .tooManyRequests(let rhsContext)):
            lhsContext == rhsContext

        case (.serverError(let lhsContext), .serverError(let rhsContext)):
            lhsContext == rhsContext

        case (.invalidURL(let lhsURL), .invalidURL(let rhsURL)):
            lhsURL == rhsURL

        case (.encode, .encode):
            true

        case (.network, .network):
            true

        case (.decode, .decode):
            true

        case (.invalidRating, .invalidRating):
            true

        case (.cancelled, .cancelled):
            true

        case (.unknown, .unknown):
            true

        default:
            false
        }
    }

}

public extension TMDbError {

    ///
    /// A localized message describing what error occurred.
    ///
    var errorDescription: String? {
        switch self {
        case .badRequest(let context):
            context.statusMessage ?? "Bad request"

        case .unauthorised(let context):
            context.statusMessage ?? "Unauthorised"

        case .forbidden(let context):
            context.statusMessage ?? "Forbidden"

        case .notFound(let context):
            context.statusMessage ?? "Not found"

        case .tooManyRequests(let context):
            context.statusMessage ?? "Too many requests"

        case .serverError(let context):
            context.statusMessage ?? "Server error"

        case .invalidURL(let url):
            "Invalid URL: \(url)"

        case .encode:
            "Encode error"

        case .network:
            "Network error"

        case .decode:
            "Decode error"

        case .invalidRating:
            "Invalid rating (must be between 0.5 and 10.0, in increments of 0.5)"

        case .cancelled:
            "Cancelled"

        case .unknown:
            "Unknown"
        }
    }

}
