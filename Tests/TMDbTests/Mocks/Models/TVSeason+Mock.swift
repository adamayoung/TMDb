//
//  TVSeason+Mock.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TVSeason {

    static func mock(
        id: Int = 1,
        name: String = "TV Season",
        seasonNumber: Int = 2,
        overview: String? = "TV Season Overview",
        airDate: Date? = Date(iso8601: "2013-11-15T10:20:00Z"),
        posterPath: URL? = nil,
        voteAverage: Double? = nil,
        episodes: [TVEpisode]? = .mocks
    ) -> TVSeason {
        TVSeason(
            id: id,
            name: name,
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            posterPath: posterPath,
            voteAverage: voteAverage,
            episodes: episodes
        )
    }

}
