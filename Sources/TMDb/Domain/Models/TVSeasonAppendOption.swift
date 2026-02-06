//
//  TVSeasonAppendOption.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Options for data to append to a TV season details response.
///
/// Use these options with
/// ``TVSeasonService/details(forSeason:inTVSeries:appending:language:)``
/// to fetch additional data in a single request.
///
/// ```swift
/// let result = try await client.tvSeasons.details(
///     forSeason: 1,
///     inTVSeries: 1399,
///     appending: [.credits, .images]
/// )
/// ```
///
public struct TVSeasonAppendOption: OptionSet, Hashable, Sendable {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Append cast and crew credits.
    public static let credits = TVSeasonAppendOption(rawValue: 1 << 0)

    /// Append aggregate credits.
    public static let aggregateCredits = TVSeasonAppendOption(rawValue: 1 << 1)

    /// Append image collection.
    public static let images = TVSeasonAppendOption(rawValue: 1 << 2)

    /// Append video collection.
    public static let videos = TVSeasonAppendOption(rawValue: 1 << 3)

    /// Append translations.
    public static let translations = TVSeasonAppendOption(rawValue: 1 << 4)

    /// Append watch providers by country.
    public static let watchProviders = TVSeasonAppendOption(rawValue: 1 << 5)

    /// Append external IDs.
    public static let externalIDs = TVSeasonAppendOption(rawValue: 1 << 6)

}

extension TVSeasonAppendOption {

    private static let mapping: [(TVSeasonAppendOption, String)] = [
        (.credits, "credits"),
        (.aggregateCredits, "aggregate_credits"),
        (.images, "images"),
        (.videos, "videos"),
        (.translations, "translations"),
        (.watchProviders, "watch/providers"),
        (.externalIDs, "external_ids")
    ]

    var queryValue: String {
        Self.mapping
            .filter { contains($0.0) }
            .map(\.1)
            .joined(separator: ",")
    }

}
