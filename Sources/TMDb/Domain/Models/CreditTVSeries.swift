//
//  CreditTVSeries.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV series in a credit response.
///
public struct CreditTVSeries: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// TV series identifier.
    ///
    public let id: Int

    ///
    /// TV series name.
    ///
    public let name: String?

    ///
    /// TV series original name.
    ///
    public let originalName: String?

    ///
    /// TV series overview.
    ///
    public let overview: String?

    ///
    /// TV series poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// TV series backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// TV series popularity.
    ///
    public let popularity: Double?

    ///
    /// TV series first air date.
    ///
    /// Midnight GMT on the day TMDb reports.
    ///
    public let firstAirDate: Date?

    ///
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Character played in the TV series.
    ///
    public let character: String?

    ///
    /// Creates a credit TV series object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - name: TV series name.
    ///    - originalName: TV series original name.
    ///    - overview: TV series overview.
    ///    - posterPath: TV series poster path.
    ///    - backdropPath: TV series backdrop path.
    ///    - popularity: TV series popularity.
    ///    - firstAirDate: TV series first air date.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///    - character: Character played.
    ///
    public init(
        id: Int,
        name: String? = nil,
        originalName: String? = nil,
        overview: String? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        popularity: Double? = nil,
        firstAirDate: Date? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        character: String? = nil
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.firstAirDate = firstAirDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.character = character
    }

}

extension CreditTVSeries {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case overview
        case posterPath
        case backdropPath
        case popularity
        case firstAirDate
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
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        // An unaired TV series reports `first_air_date` as an empty string,
        // which the day-precision date strategy cannot parse.
        self.firstAirDate = try container.decodeNonEmptyDateIfPresent(forKey: .firstAirDate)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.character = try container.decodeIfPresent(String.self, forKey: .character)
    }

}
