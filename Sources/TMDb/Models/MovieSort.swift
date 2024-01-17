//
//  MovieSort.swift
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

///
/// A sort specifier when fetching movies.
///
public enum MovieSort: CustomStringConvertible {

    ///
    /// By popularity.
    ///
    case popularity(descending: Bool = true)

    ///
    /// By release date.
    ///
    case releaseDate(descending: Bool = true)

    ///
    /// By primary release date.
    ///
    case primaryReleaseDate(descending: Bool = true)

    ///
    /// By revenue.
    ///
    case revenue(descending: Bool = true)

    ///
    /// By original title.
    ///
    case originalTitle(descending: Bool = true)

    ///
    /// By vote average.
    ///
    case voteAverage(descending: Bool = true)

    ///
    /// By vote count.
    ///
    case voteCount(descending: Bool = true)

    public var description: String {
        "\(fieldName).\(isDescending ? "desc" : "asc")"
    }

}

extension MovieSort {

    private var fieldName: String {
        switch self {
        case .popularity:
            "popularity"

        case .releaseDate:
            "release_date"

        case .primaryReleaseDate:
            "primary_release_date"

        case .revenue:
            "revenue"

        case .originalTitle:
            "original_title"

        case .voteAverage:
            "vote_average"

        case .voteCount:
            "vote_count"
        }
    }

    private var isDescending: Bool {
        switch self {
        case let .popularity(descending):
            descending

        case let .releaseDate(descending):
            descending

        case let .revenue(descending):
            descending

        case let .primaryReleaseDate(descending):
            descending

        case let .originalTitle(descending):
            descending

        case let .voteAverage(descending):
            descending

        case let .voteCount(descending):
            descending
        }
    }

}

extension URL {

    private enum QueryItemName {
        static let sortBy = "sort_by"
    }

    func appendingSortBy(_ sortBy: MovieSort?) -> Self {
        guard let sortBy else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.sortBy, value: sortBy)
    }

}
