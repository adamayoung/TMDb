//
//  DiscoverTVSeriesFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for discovering TV series.
///
public struct DiscoverTVSeriesFilter: Sendable {

    ///
    /// The original language of the TV series.
    ///
    public let originalLanguage: String?

    ///
    /// A list of genre identifiers associated with the TV series.
    ///
    public let genres: [Genre.ID]?

    ///
    /// Creates a discover TV series filter.
    ///
    /// - Parameters:
    ///   - originalLanguage: The original language of the TV series.
    ///   - genres: A list of genre identifiers associated with the TV series.
    ///
    public init(
        originalLanguage: String? = nil,
        genres: [Genre.ID]? = nil
    ) {
        self.originalLanguage = originalLanguage
        self.genres = genres
    }

}
