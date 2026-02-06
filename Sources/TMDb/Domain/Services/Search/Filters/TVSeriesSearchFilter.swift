//
//  TVSeriesSearchFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A search filter when searching for TV series.
///
public struct TVSeriesSearchFilter: Sendable {

    ///
    /// Filter by first air date year.
    ///
    public let firstAirDateYear: Int?

    ///
    /// Filter by the first air date and all episode air dates.
    ///
    public let year: Int?

    ///
    /// Include adult results.
    ///
    public let includeAdult: Bool?

    ///
    /// Creates a search filter for TV series searches.
    ///
    /// - Parameters:
    ///   - firstAirDateYear: Filter by first air date year.
    ///   - year: Filter by the first air date and all episode air dates.
    ///   - includeAdult: Include adult results.
    public init(firstAirDateYear: Int?, year: Int?, includeAdult: Bool?) {
        self.firstAirDateYear = firstAirDateYear
        self.year = year
        self.includeAdult = includeAdult
    }

}
