//
//  DiscoverMovieFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for discovering movies.
///
public struct DiscoverMovieFilter: Sendable {

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

public extension DiscoverMovieFilter {

    ///
    /// A release year filter.
    ///
    enum PrimaryReleaseYearFilter: Equatable, Sendable {

        ///
        /// On a specific year.
        ///
        case on(Int)

        ///
        /// From a specific year.
        ///
        case from(Int)

        ///
        /// Up to a specific year.
        ///
        case upTo(Int)

        ///
        /// Between specific years.
        ///
        case between(start: Int, end: Int)

        func dateBounds() -> (gte: String?, lte: String?) {
            switch self {
            case .on(let year):
                ("\(year)-01-01", "\(year)-12-31")

            case .from(let year):
                ("\(year)-01-01", nil)

            case .upTo(let year):
                (nil, "\(year)-12-31")

            case .between(let start, let end):
                ("\(start)-01-01", "\(end)-12-31")
            }
        }
    }

}
