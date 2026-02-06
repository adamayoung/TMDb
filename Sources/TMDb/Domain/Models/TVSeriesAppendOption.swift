//
//  TVSeriesAppendOption.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Options for data to append to a TV series details response.
///
/// Use these options with
/// ``TVSeriesService/details(forTVSeries:appending:language:)``
/// to fetch additional data in a single request.
///
/// ```swift
/// let result = try await client.tvSeries.details(
///     forTVSeries: 1399,
///     appending: [.credits, .images, .videos]
/// )
/// ```
///
public struct TVSeriesAppendOption: OptionSet, Hashable, Sendable {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Append cast and crew credits.
    public static let credits = TVSeriesAppendOption(rawValue: 1 << 0)

    /// Append aggregate credits.
    public static let aggregateCredits = TVSeriesAppendOption(rawValue: 1 << 1)

    /// Append image collection.
    public static let images = TVSeriesAppendOption(rawValue: 1 << 2)

    /// Append video collection.
    public static let videos = TVSeriesAppendOption(rawValue: 1 << 3)

    /// Append user reviews.
    public static let reviews = TVSeriesAppendOption(rawValue: 1 << 4)

    /// Append recommended TV series.
    public static let recommendations = TVSeriesAppendOption(rawValue: 1 << 5)

    /// Append similar TV series.
    public static let similar = TVSeriesAppendOption(rawValue: 1 << 6)

    /// Append content ratings by country.
    public static let contentRatings = TVSeriesAppendOption(rawValue: 1 << 7)

    /// Append alternative titles.
    public static let alternativeTitles = TVSeriesAppendOption(rawValue: 1 << 8)

    /// Append translations.
    public static let translations = TVSeriesAppendOption(rawValue: 1 << 9)

    /// Append keywords.
    public static let keywords = TVSeriesAppendOption(rawValue: 1 << 10)

    /// Append watch providers by country.
    public static let watchProviders = TVSeriesAppendOption(rawValue: 1 << 11)

    /// Append external IDs.
    public static let externalIDs = TVSeriesAppendOption(rawValue: 1 << 12)

    /// Append episodes screened theatrically.
    public static let screenedTheatrically = TVSeriesAppendOption(rawValue: 1 << 13)

    /// Append episode groups.
    public static let episodeGroups = TVSeriesAppendOption(rawValue: 1 << 14)

    /// Append lists containing this TV series.
    public static let lists = TVSeriesAppendOption(rawValue: 1 << 15)

    /// Append change history.
    public static let changes = TVSeriesAppendOption(rawValue: 1 << 16)

}

extension TVSeriesAppendOption {

    private static let mapping: [(TVSeriesAppendOption, String)] = [
        (.credits, "credits"),
        (.aggregateCredits, "aggregate_credits"),
        (.images, "images"),
        (.videos, "videos"),
        (.reviews, "reviews"),
        (.recommendations, "recommendations"),
        (.similar, "similar"),
        (.contentRatings, "content_ratings"),
        (.alternativeTitles, "alternative_titles"),
        (.translations, "translations"),
        (.keywords, "keywords"),
        (.watchProviders, "watch/providers"),
        (.externalIDs, "external_ids"),
        (.screenedTheatrically, "screened_theatrically"),
        (.episodeGroups, "episode_groups"),
        (.lists, "lists"),
        (.changes, "changes")
    ]

    var queryValue: String {
        Self.mapping
            .filter { contains($0.0) }
            .map(\.1)
            .joined(separator: ",")
    }

}
