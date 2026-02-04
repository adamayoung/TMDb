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
public enum TMDbError: Equatable, LocalizedError, Sendable {

    /// An error indicating an invalid request was made.
    case badRequest(String? = nil)

    /// An error indicating the request was not authorised.
    case unauthorised(String? = nil)

    /// An error indicating access to the resource is forbidden.
    case forbidden(String? = nil)

    /// An error indicating the resource could not be found.
    case notFound(String? = nil)

    /// An error indicating too many requests have been made.
    case tooManyRequests(String? = nil)

    /// An error indicating there was a server error.
    case serverError(String? = nil)

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
        case (.badRequest(let lhsMessage), .badRequest(let rhsMessage)):
            lhsMessage == rhsMessage

        case (.unauthorised(let lhsMessage), .unauthorised(let rhsMessage)):
            lhsMessage == rhsMessage

        case (.forbidden(let lhsMessage), .forbidden(let rhsMessage)):
            lhsMessage == rhsMessage

        case (.notFound(let lhsMessage), .notFound(let rhsMessage)):
            lhsMessage == rhsMessage

        case (.tooManyRequests(let lhsMessage), .tooManyRequests(let rhsMessage)):
            lhsMessage == rhsMessage

        case (.serverError(let lhsMessage), .serverError(let rhsMessage)):
            lhsMessage == rhsMessage

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
        case .badRequest(let message):
            message ?? "Bad request"

        case .unauthorised(let message):
            message ?? "Unauthorised"

        case .forbidden(let message):
            message ?? "Forbidden"

        case .notFound(let message):
            message ?? "Not found"

        case .tooManyRequests(let message):
            message ?? "Too many requests"

        case .serverError(let message):
            message ?? "Server error"

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
