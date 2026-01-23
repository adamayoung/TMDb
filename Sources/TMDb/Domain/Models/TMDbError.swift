//
//  TMDbError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An TMDb error.
///
public enum TMDbError: Equatable, LocalizedError, Sendable {

    /// An error indicating the resource could not be found.
    case notFound

    case unauthorised(String? = nil)

    /// An error indicating there was a network problem.
    case network(Error)

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
        case (.notFound, .notFound):
            true

        case (.unauthorised(let lhsMessage), .unauthorised(let rhsMessage)):
            lhsMessage == rhsMessage

        case (.network, .network):
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
        case .notFound:
            "Not found"

        case .unauthorised:
            "Unauthorised"

        case .network:
            "Network error"

        case .unknown:
            "Unknown"
        }
    }

}
