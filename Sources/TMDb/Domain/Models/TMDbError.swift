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
    /// value.
    case invalidURL(String)

    /// An error indicating there was a problem encoding data.
    case encode(Error)

    /// An error indicating there was a network problem.
    case network(Error)

    /// An error indicating there was a problem decoding data.
    case decode(Error)

    /// An error indicating an invalid rating value was provided.
    case invalidRating

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

        case .unknown:
            "Unknown"
        }
    }

}
