//
//  TVSeriesSort.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A sort specifier when fetching TV series.
///
public enum TVSeriesSort: CustomStringConvertible, Equatable, Sendable {

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

    ///
    /// A textual representation of this sort.
    ///
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
        case .popularity(let descending):
            descending

        case .firstAirDate(let descending):
            descending

        case .voteAverage(let descending):
            descending
        }
    }

}
