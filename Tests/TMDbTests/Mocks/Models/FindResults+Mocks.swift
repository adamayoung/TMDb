//
//  FindResults+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
