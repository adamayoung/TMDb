//
//  CreditMovie.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a movie in a credit response.
///
public struct CreditMovie: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// Movie identifier.
    ///
    public let id: Int

    ///
    /// Movie title.
    ///
    public let title: String?

    ///
    /// Movie original title.
    ///
    public let originalTitle: String?

    ///
    /// Movie overview.
    ///
    public let overview: String?

    ///
    /// Movie poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Movie backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// Movie popularity.
    ///
    public let popularity: Double?

    ///
    /// Movie release date.
    ///
    public let releaseDate: Date?

    ///
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Character played in the movie.
    ///
    public let character: String?

    ///
    /// Creates a credit movie object.
    ///
    /// - Parameters:
    ///    - id: Movie identifier.
    ///    - title: Movie title.
    ///    - originalTitle: Movie original title.
    ///    - overview: Movie overview.
    ///    - posterPath: Movie poster path.
    ///    - backdropPath: Movie backdrop path.
    ///    - popularity: Movie popularity.
    ///    - releaseDate: Movie release date.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///    - character: Character played in the movie.
    ///
    public init(
        id: Int,
        title: String? = nil,
        originalTitle: String? = nil,
        overview: String? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        popularity: Double? = nil,
        releaseDate: Date? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        character: String? = nil
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.character = character
    }

}
