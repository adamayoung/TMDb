//
//  MovieSearchFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A search filter when searching for movies.
///
public struct MovieSearchFilter {

    ///
    /// Filter by primary release year.
    ///
    public let primaryReleaseYear: Int?

    ///
    /// ISO-3166-1 country code to filter by.
    ///
    /// Filters movies that were released in the specified country.
    ///
    public let country: String?

    ///
    /// Include adult results.
    ///
    public let includeAdult: Bool?

    ///
    /// Creates a search filter for movie searches.
    ///
    /// - Parameters:
    ///   - primaryReleaseYear: Filter by primary release year.
    ///   - country: ISO-3166-1 country code to filter by.
    ///   - includeAdult: Include adult results.
    ///
    public init(
        primaryReleaseYear: Int? = nil,
        country: String? = nil,
        includeAdult: Bool? = nil
    ) {
        self.primaryReleaseYear = primaryReleaseYear
        self.country = country
        self.includeAdult = includeAdult
    }

}
