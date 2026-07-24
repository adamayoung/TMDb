//
//  TVEpisodeAirDate.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing episode air date information for a TV series.
///
/// This model is used in the context of `lastEpisodeToAir` and `nextEpisodeToAir` properties on `TVSeries`,
/// providing information about episodes that have recently aired or will air soon.
///
public struct TVEpisodeAirDate: Identifiable, Codable, Equatable, Hashable, Sendable {

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
    /// Episode runtime.
    ///
    /// Runtimes have whole-minute granularity; any sub-minute component is
    /// truncated to match TMDb's wire format.
    ///
    public var runtime: Duration? {
        runtimeInMinutes.map { RuntimeMinutes.duration(fromMinutes: $0) }
    }

    private let runtimeInMinutes: Int?

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
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Creates a TV episode air date object.
    ///
    /// - Parameters:
    ///    - id: TV episode identifier.
    ///    - name: TV episode name.
    ///    - episodeNumber: TV episode number.
    ///    - seasonNumber: TV episode season number.
    ///    - overview: TV episode overview.
    ///    - airDate: TV episode air date.
    ///    - episodeType: Type of episode.
    ///    - runtime: Episode runtime.
    ///    - showID: Identifier of the parent TV series.
    ///    - productionCode: TV episode production code.
    ///    - stillPath: TV episode still image path.
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
        runtime: Duration? = nil,
        showID: Int? = nil,
        productionCode: String? = nil,
        stillPath: URL? = nil,
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
        self.runtimeInMinutes = runtime.map { RuntimeMinutes.minutes(from: $0) }
        self.showID = showID
        self.productionCode = productionCode
        self.stillPath = stillPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}

extension TVEpisodeAirDate {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case episodeNumber
        case seasonNumber
        case overview
        case airDate
        case episodeType
        case runtimeInMinutes = "runtime"
        case showID = "showId"
        case productionCode
        case stillPath
        case voteAverage
        case voteCount
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
        self.name = try container.decode(String.self, forKey: .name)
        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        self.seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.airDate = try container.decodeNonEmptyDateIfPresent(forKey: .airDate)
        self.episodeType = try container.decodeIfPresent(String.self, forKey: .episodeType)
        self.runtimeInMinutes = try container.decodeIfPresent(Int.self, forKey: .runtimeInMinutes)
        self.showID = try container.decodeIfPresent(Int.self, forKey: .showID)
        self.productionCode = try container.decodeIfPresent(String.self, forKey: .productionCode)
        self.stillPath = try container.decodeIfPresent(URL.self, forKey: .stillPath)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
    }

}
