//
//  FindResults+Mocks.swift
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

@testable import TMDb

extension FindResults {

    static func mock(
        movieResults: [Movie] = [],
        personResults: [Person] = [],
        tvResults: [TVSeries] = [],
        tvSeasonResults: [TVSeason] = [],
        tvEpisodeResults: [TVEpisode] = []
    ) -> FindResults {
        FindResults(
            movieResults: movieResults,
            personResults: personResults,
            tvResults: tvResults,
            tvSeasonResults: tvSeasonResults,
            tvEpisodeResults: tvEpisodeResults
        )
    }

    static var movieResult: FindResults {
        FindResults(
            movieResults: [.mock()],
            personResults: [],
            tvResults: [],
            tvSeasonResults: [],
            tvEpisodeResults: []
        )
    }

    static var tvSeriesResult: FindResults {
        FindResults(
            movieResults: [],
            personResults: [],
            tvResults: [.mock()],
            tvSeasonResults: [],
            tvEpisodeResults: []
        )
    }

}
