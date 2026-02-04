//
//  TVSeason.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV season.
///
public struct TVSeason: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// TV season identifier.
    ///
    public let id: Int

    ///
    /// TV season name.
    ///
    public let name: String

    ///
    /// TV season number.
    ///
    public let seasonNumber: Int

    ///
    /// Overview of TV season.
    ///
    public let overview: String?

    ///
    /// TV season's air date.
    ///
    public let airDate: Date?

    ///
    /// TV season's poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Episodes in this TV season.
    ///
    public let episodes: [TVEpisode]?

    ///
    /// Creates a TV season object.
    ///
    /// - Parameters:
    ///    - id: TV season identifier.
    ///    - name: TV season name.
    ///    - seasonNumber: TV season number.
    ///    - overview: Overview of TV season.
    ///    - airDate: TV season's air date.
    ///    - posterPath: TV season's poster path.
    ///    - episodes: Episodes in this TV season.
    ///
    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        posterPath: URL? = nil,
        episodes: [TVEpisode]? = nil
    ) {
        self.id = id
        self.name = name
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.posterPath = posterPath
        self.episodes = episodes
    }

}

extension TVSeason {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case seasonNumber
        case overview
        case airDate
        case posterPath
        case episodes
    }

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
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)

        // Need to deal with empty strings - date decoding will fail with an empty string
        let airDateString = try container.decodeIfPresent(String.self, forKey: .airDate)
        self.airDate = try {
            guard let airDateString, !airDateString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(Date.self, forKey: .airDate)
        }()

        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.episodes = try container.decodeIfPresent([TVEpisode].self, forKey: .episodes)
    }

}
