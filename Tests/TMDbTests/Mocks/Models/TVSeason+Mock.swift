//
//  TVSeason+Mock.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension TVSeason {

    static func mock(
        id: Int = .randomID,
        name: String? = nil,
        seasonNumber: Int = Int.random(in: 1 ... 10),
        overview: String? = .randomString,
        airDate: Date? = .random,
        posterPath: URL? = nil,
        episodes: [TVEpisode]? = .mocks
    ) -> Self {
        .init(
            id: id,
            name: name ?? "TV Season \(id)",
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            posterPath: posterPath,
            episodes: episodes
        )
    }

}
