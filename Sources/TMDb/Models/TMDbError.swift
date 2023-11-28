//
//  TMDbError.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

public enum TMDbError: Equatable, LocalizedError {

    /// An error indicating the resource could not be found.
    case notFound

    /// An error indicating there was a network problem.
    case network(Error)

    /// An unknown error.
    case unknown

    public static func == (lhs: TMDbError, rhs: TMDbError) -> Bool {
        switch (lhs, rhs) {
        case (.notFound, .notFound):
            return true

        case (.network, .network):
            return true

        case (.unknown, .unknown):
            return true

        default:
            return false
        }
    }

}

public extension TMDbError {

    /// A localized message describing what error occurred.
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Not found"

        case .network:
            return "Network error"

        case .unknown:
            return "Unknown"
        }
    }

}
