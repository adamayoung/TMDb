//
//  MovieSearchFilter.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
