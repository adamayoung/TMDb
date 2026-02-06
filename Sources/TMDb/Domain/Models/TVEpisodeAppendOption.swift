//
//  TVEpisodeAppendOption.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Options for data to append to a TV episode details response.
///
/// Use these options with
/// ``TVEpisodeService/details(forEpisode:inSeason:inTVSeries:appending:language:)``
/// to fetch additional data in a single request.
///
/// ```swift
/// let result = try await client.tvEpisodes.details(
///     forEpisode: 1,
///     inSeason: 1,
///     inTVSeries: 1399,
///     appending: [.credits, .images]
/// )
/// ```
///
public struct TVEpisodeAppendOption: OptionSet, Hashable, Sendable {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Append cast, crew, and guest star credits.
    public static let credits = TVEpisodeAppendOption(rawValue: 1 << 0)

    /// Append image collection.
    public static let images = TVEpisodeAppendOption(rawValue: 1 << 1)

    /// Append video collection.
    public static let videos = TVEpisodeAppendOption(rawValue: 1 << 2)

    /// Append translations.
    public static let translations = TVEpisodeAppendOption(rawValue: 1 << 3)

    /// Append external IDs.
    public static let externalIDs = TVEpisodeAppendOption(rawValue: 1 << 4)

}

extension TVEpisodeAppendOption {

    private static let mapping: [(TVEpisodeAppendOption, String)] = [
        (.credits, "credits"),
        (.images, "images"),
        (.videos, "videos"),
        (.translations, "translations"),
        (.externalIDs, "external_ids")
    ]

    var queryValue: String {
        Self.mapping
            .filter { contains($0.0) }
            .map(\.1)
            .joined(separator: ",")
    }

}
