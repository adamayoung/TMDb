//
//  DiscoverMovieFilter.swift
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
/// A filter for discovering movies.
///
public struct DiscoverMovieFilter {

    ///
    /// A list of Person identifiers who have appeared in the movie.
    ///
    public let people: [Person.ID]?

    ///
    /// The original language of the movie.
    ///
    public let originalLanguage: String?

    ///
    /// A list of genre identifiers associated with the movie.
    ///
    public let genres: [Genre.ID]?

    ///
    /// The date of movie release.
    ///
    public let primaryReleaseYear: PrimaryReleaseYearFilter?

    ///
    /// Creates a discover movies filter.
    ///
    /// - Parameters:
    ///   - people: A list of Person identifiers which to return only movies they have appeared in.
    ///   - originalLanguage: The original language of the movie.
    ///   - genres: A list of genre identifiers associated with the movie.
    ///   - primaryReleaseYear: The date of movie release.
    ///
    public init(
        people: [Person.ID]? = nil,
        originalLanguage: String? = nil,
        genres: [Genre.ID]? = nil,
        primaryReleaseYear: PrimaryReleaseYearFilter? = nil
    ) {
        self.people = people
        self.originalLanguage = originalLanguage
        self.genres = genres
        self.primaryReleaseYear = primaryReleaseYear
    }

}

extension DiscoverMovieFilter {

    public enum PrimaryReleaseYearFilter: Equatable, Sendable {
        case on(Int)
        case from(Int)
        case upTo(Int)
        case between(start: Int, end: Int)

        func dateBounds() -> (gte: String?, lte: String?) {
            switch self {
            case .on(let year):
                return ("\(year)-01-01", "\(year)-12-31")

            case .from(let year):
                return ("\(year)-01-01", nil)

            case .upTo(let year):
                return (nil, "\(year)-12-31")

            case .between(let start, let end):
                return ("\(start)-01-01", "\(end)-12-31")
            }
        }
    }

}
