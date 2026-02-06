//
//  MovieAppendOption.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Options for data to append to a movie details response.
///
/// Use these options with ``MovieService/details(forMovie:appending:language:)``
/// to fetch additional data in a single request.
///
/// ```swift
/// let result = try await client.movies.details(
///     forMovie: 550,
///     appending: [.credits, .images, .videos]
/// )
/// ```
///
public struct MovieAppendOption: OptionSet, Hashable, Sendable {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Append cast and crew credits.
    public static let credits = MovieAppendOption(rawValue: 1 << 0)

    /// Append image collection.
    public static let images = MovieAppendOption(rawValue: 1 << 1)

    /// Append video collection.
    public static let videos = MovieAppendOption(rawValue: 1 << 2)

    /// Append user reviews.
    public static let reviews = MovieAppendOption(rawValue: 1 << 3)

    /// Append recommended movies.
    public static let recommendations = MovieAppendOption(rawValue: 1 << 4)

    /// Append similar movies.
    public static let similar = MovieAppendOption(rawValue: 1 << 5)

    /// Append release dates by country.
    public static let releaseDates = MovieAppendOption(rawValue: 1 << 6)

    /// Append alternative titles.
    public static let alternativeTitles = MovieAppendOption(rawValue: 1 << 7)

    /// Append translations.
    public static let translations = MovieAppendOption(rawValue: 1 << 8)

    /// Append keywords.
    public static let keywords = MovieAppendOption(rawValue: 1 << 9)

    /// Append watch providers by country.
    public static let watchProviders = MovieAppendOption(rawValue: 1 << 10)

    /// Append external IDs.
    public static let externalIDs = MovieAppendOption(rawValue: 1 << 11)

    /// Append lists containing this movie.
    public static let lists = MovieAppendOption(rawValue: 1 << 12)

    /// Append change history.
    public static let changes = MovieAppendOption(rawValue: 1 << 13)

}

extension MovieAppendOption {

    private static let mapping: [(MovieAppendOption, String)] = [
        (.credits, "credits"),
        (.images, "images"),
        (.videos, "videos"),
        (.reviews, "reviews"),
        (.recommendations, "recommendations"),
        (.similar, "similar"),
        (.releaseDates, "release_dates"),
        (.alternativeTitles, "alternative_titles"),
        (.translations, "translations"),
        (.keywords, "keywords"),
        (.watchProviders, "watch/providers"),
        (.externalIDs, "external_ids"),
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
