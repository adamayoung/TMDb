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
    /// A list of genre identifiers to exclude.
    ///
    public let withoutGenres: [Genre.ID]?

    ///
    /// The date of movie release.
    ///
    public let primaryReleaseYear: PrimaryReleaseYearFilter?

    ///
    /// Minimum vote average score.
    ///
    public let voteAverageMin: Double?

    ///
    /// Maximum vote average score.
    ///
    public let voteAverageMax: Double?

    ///
    /// Minimum number of votes.
    ///
    public let voteCountMin: Int?

    ///
    /// Maximum number of votes.
    ///
    public let voteCountMax: Int?

    ///
    /// A list of production company identifiers.
    ///
    public let companies: [Company.ID]?

    ///
    /// A list of keyword identifiers to include.
    ///
    public let keywords: [Keyword.ID]?

    ///
    /// A list of keyword identifiers to exclude.
    ///
    public let withoutKeywords: [Keyword.ID]?

    ///
    /// Minimum runtime in minutes.
    ///
    public let runtimeMin: Int?

    ///
    /// Maximum runtime in minutes.
    ///
    public let runtimeMax: Int?

    ///
    /// Include adult content.
    ///
    public let includeAdult: Bool?

    ///
    /// Include video content.
    ///
    public let includeVideo: Bool?

    ///
    /// A list of watch provider identifiers.
    ///
    public let watchProviders: [WatchProvider.ID]?

    ///
    /// ISO-3166-1 watch region code.
    ///
    public let watchRegion: String?

    ///
    /// Creates a discover movies filter.
    ///
    /// - Parameters:
    ///   - people: A list of Person identifiers which to return only movies
    ///     they have appeared in.
    ///   - originalLanguage: The original language of the movie.
    ///   - genres: A list of genre identifiers associated with the movie.
    ///   - withoutGenres: A list of genre identifiers to exclude.
    ///   - primaryReleaseYear: The date of movie release.
    ///   - voteAverageMin: Minimum vote average score.
    ///   - voteAverageMax: Maximum vote average score.
    ///   - voteCountMin: Minimum number of votes.
    ///   - voteCountMax: Maximum number of votes.
    ///   - companies: A list of production company identifiers.
    ///   - keywords: A list of keyword identifiers to include.
    ///   - withoutKeywords: A list of keyword identifiers to exclude.
    ///   - runtimeMin: Minimum runtime in minutes.
    ///   - runtimeMax: Maximum runtime in minutes.
    ///   - includeAdult: Include adult content.
    ///   - includeVideo: Include video content.
    ///   - watchProviders: A list of watch provider identifiers.
    ///   - watchRegion: ISO-3166-1 watch region code.
    ///
    public init(
        people: [Person.ID]? = nil,
        originalLanguage: String? = nil,
        genres: [Genre.ID]? = nil,
        withoutGenres: [Genre.ID]? = nil,
        primaryReleaseYear: PrimaryReleaseYearFilter? = nil,
        voteAverageMin: Double? = nil,
        voteAverageMax: Double? = nil,
        voteCountMin: Int? = nil,
        voteCountMax: Int? = nil,
        companies: [Company.ID]? = nil,
        keywords: [Keyword.ID]? = nil,
        withoutKeywords: [Keyword.ID]? = nil,
        runtimeMin: Int? = nil,
        runtimeMax: Int? = nil,
        includeAdult: Bool? = nil,
        includeVideo: Bool? = nil,
        watchProviders: [WatchProvider.ID]? = nil,
        watchRegion: String? = nil
    ) {
        self.people = people
        self.originalLanguage = originalLanguage
        self.genres = genres
        self.withoutGenres = withoutGenres
        self.primaryReleaseYear = primaryReleaseYear
        self.voteAverageMin = voteAverageMin
        self.voteAverageMax = voteAverageMax
        self.voteCountMin = voteCountMin
        self.voteCountMax = voteCountMax
        self.companies = companies
        self.keywords = keywords
        self.withoutKeywords = withoutKeywords
        self.runtimeMin = runtimeMin
        self.runtimeMax = runtimeMax
        self.includeAdult = includeAdult
        self.includeVideo = includeVideo
        self.watchProviders = watchProviders
        self.watchRegion = watchRegion
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
