//
//  TVSeriesSort.swift
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
/// A sort specifier when fetching TV series.
///
public enum TVSeriesSort: CustomStringConvertible {

    ///
    /// By popularity.
    ///
    case popularity(descending: Bool = true)

    ///
    /// By first air date.
    ///
    case firstAirDate(descending: Bool = true)

    ///
    /// By vote average.
    ///
    case voteAverage(descending: Bool = true)

    public var description: String {
        "\(fieldName).\(isDescending ? "desc" : "asc")"
    }

}

extension TVSeriesSort {

    private enum FieldName {
        static let popularity = "popularity"
        static let firstAirDate = "first_air_date"
        static let voteAverage = "vote_average"
    }

    private var fieldName: String {
        switch self {
        case .popularity:
            FieldName.popularity

        case .firstAirDate:
            FieldName.firstAirDate

        case .voteAverage:
            FieldName.voteAverage
        }
    }

    private var isDescending: Bool {
        switch self {
        case let .popularity(descending):
            descending

        case let .firstAirDate(descending):
            descending

        case let .voteAverage(descending):
            descending
        }
    }

}

extension URL {

    private enum QueryItemName {
        static let sortBy = "sort_by"
    }

    func appendingSortBy(_ sortBy: TVSeriesSort?) -> Self {
        guard let sortBy else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.sortBy, value: sortBy)
    }

}
