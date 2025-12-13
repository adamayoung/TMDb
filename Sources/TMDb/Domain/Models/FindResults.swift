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
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// A model representing find results from an external ID search.
///
public struct FindResults: Codable, Equatable, Hashable, Sendable {

    ///
    /// Movie results.
    ///
    public let movieResults: [MovieListItem]

    ///
    /// TV series results.
    ///
    public let tvSeriesResults: [TVSeriesListItem]

    ///
    /// TV episode results.
    ///
    public let tvEpisodeResults: [TVEpisode]

    ///
    /// Person results.
    ///
    public let personResults: [PersonListItem]

    ///
    /// Creates find results.
    ///
    /// - Parameters:
    ///    - movieResults: Movie results.
    ///    - tvSeriesResults: TV series results.
    ///    - tvEpisodeResults: TV episode results.
    ///    - personResults: Person results.
    ///
    public init(
        movieResults: [MovieListItem] = [],
        tvSeriesResults: [TVSeriesListItem] = [],
        tvEpisodeResults: [TVEpisode] = [],
        personResults: [PersonListItem] = []
    ) {
        self.movieResults = movieResults
        self.tvSeriesResults = tvSeriesResults
        self.tvEpisodeResults = tvEpisodeResults
        self.personResults = personResults
    }

}

extension FindResults {

    private enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
        case tvSeriesResults = "tv_results"
        case tvEpisodeResults = "tv_episode_results"
        case personResults = "person_results"
    }

}
