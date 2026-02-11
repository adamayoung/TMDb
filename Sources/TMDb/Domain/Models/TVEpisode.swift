//
//  TVEpisode.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV episode.
///
public struct TVEpisode: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// TV episode identifier.
    ///
    public let id: Int

    ///
    /// TV episode name.
    ///
    public let name: String

    ///
    /// TV episode number.
    ///
    public let episodeNumber: Int

    ///
    /// TV episode season number.
    ///
    public let seasonNumber: Int

    ///
    /// TV episode overview.
    ///
    public let overview: String?

    ///
    /// TV episode air date.
    ///
    public let airDate: Date?

    ///
    /// Type of episode (e.g., "finale", "standard").
    ///
    public let episodeType: String?

    ///
    /// Episode runtime in minutes.
    ///
    public let runtime: Int?

    ///
    /// Identifier of the parent TV series.
    ///
    public let showID: Int?

    ///
    /// TV episode production code.
    ///
    public let productionCode: String?

    ///
    /// TV episode still image path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let stillPath: URL?

    ///
    /// TV episode crew.
    ///
    public let crew: [CrewMember]?

    ///
    /// TV episode guest cast members.
    ///
    public let guestStars: [CastMember]?

    ///
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Creates a TV episode object.
    ///
    /// - Parameters:
    ///    - id: TV episode identifier.
    ///    - name: TV episode name.
    ///    - episodeNumber: TV episode number.
    ///    - seasonNumber: TV episode season number.
    ///    - overview: TV episode overview.
    ///    - airDate: TV episode air date.
    ///    - episodeType: Type of episode.
    ///    - runtime: Episode runtime in minutes.
    ///    - showID: Identifier of the parent TV series.
    ///    - productionCode: TV episode production code.
    ///    - stillPath: TV episode still image path.
    ///    - crew: TV episode crew.
    ///    - guestStars: TV episode guest cast members.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///
    public init(
        id: Int,
        name: String,
        episodeNumber: Int,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        episodeType: String? = nil,
        runtime: Int? = nil,
        showID: Int? = nil,
        productionCode: String? = nil,
        stillPath: URL? = nil,
        crew: [CrewMember]? = nil,
        guestStars: [CastMember]? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.episodeType = episodeType
        self.runtime = runtime
        self.showID = showID
        self.productionCode = productionCode
        self.stillPath = stillPath
        self.crew = crew
        self.guestStars = guestStars
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}

extension TVEpisode {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case episodeNumber
        case seasonNumber
        case overview
        case airDate
        case episodeType
        case runtime
        case showID = "showId"
        case productionCode
        case stillPath
        case crew
        case guestStars
        case voteAverage
        case voteCount
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
        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
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

        self.episodeType = try container.decodeIfPresent(String.self, forKey: .episodeType)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.showID = try container.decodeIfPresent(Int.self, forKey: .showID)
        self.productionCode = try container.decodeIfPresent(String.self, forKey: .productionCode)
        self.stillPath = try container.decodeIfPresent(URL.self, forKey: .stillPath)
        self.crew = try container.decodeIfPresent([CrewMember].self, forKey: .crew)
        self.guestStars = try container.decodeIfPresent([CastMember].self, forKey: .guestStars)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
    }

}
