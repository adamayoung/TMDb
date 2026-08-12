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

extension CreditMovie {

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle
        case overview
        case posterPath
        case backdropPath
        case popularity
        case releaseDate
        case voteAverage
        case voteCount
        case character
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested
    /// type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        // An unreleased movie reports `release_date` as an empty string, which
        // the day-precision date strategy cannot parse.
        self.releaseDate = try container.decodeNonEmptyDateIfPresent(forKey: .releaseDate)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.character = try container.decodeIfPresent(String.self, forKey: .character)
    }

}
