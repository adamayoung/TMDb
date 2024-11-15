//
//  TMDbError.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

public enum TMDbError: Equatable, LocalizedError, Sendable {

    /// An error indicating the resource could not be found.
    case notFound

    case unauthorised(String?)

    /// An error indicating there was a network problem.
    case network(Error)

    /// An unknown error.
    case unknown

    ///
    /// Returns a Boolean value indicating whether two `TMDBError`s are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
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

extension TMDbError {

    ///
    /// A localized message describing what error occurred.
    ///
    public var errorDescription: String? {
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
