//
//  FindResults.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
