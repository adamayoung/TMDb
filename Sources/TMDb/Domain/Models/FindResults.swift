//
//  FindResults.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the results of a find by external ID query.
///
public struct FindResults: Codable, Equatable, Hashable, Sendable {

    ///
    /// Movies matching the external ID.
    ///
    public let movieResults: [Movie]

    ///
    /// People matching the external ID.
    ///
    public let personResults: [Person]

    ///
    /// TV series matching the external ID.
    ///
    public let tvResults: [TVSeries]

    ///
    /// TV seasons matching the external ID.
    ///
    public let tvSeasonResults: [TVSeason]

    ///
    /// TV episodes matching the external ID.
    ///
    public let tvEpisodeResults: [TVEpisode]

    ///
    /// Creates a find results object.
    ///
    /// - Parameters:
    ///   - movieResults: Movies matching the external ID.
    ///   - personResults: People matching the external ID.
    ///   - tvResults: TV series matching the external ID.
    ///   - tvSeasonResults: TV seasons matching the external ID.
    ///   - tvEpisodeResults: TV episodes matching the external ID.
    ///
    public init(
        movieResults: [Movie] = [],
        personResults: [Person] = [],
        tvResults: [TVSeries] = [],
        tvSeasonResults: [TVSeason] = [],
        tvEpisodeResults: [TVEpisode] = []
    ) {
        self.movieResults = movieResults
        self.personResults = personResults
        self.tvResults = tvResults
        self.tvSeasonResults = tvSeasonResults
        self.tvEpisodeResults = tvEpisodeResults
    }

}
