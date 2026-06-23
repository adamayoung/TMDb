//
//  TVSeason+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVSeason {

    /// A sample `TVSeason` for use in tests and previews.
    static var sample: TVSeason {
        TVSeason(
            id: 1,
            name: "TV Season",
            seasonNumber: 2,
            overview: "TV Season Overview",
            airDate: Date(timeIntervalSince1970: 1_384_510_800),
            posterPath: nil,
            voteAverage: nil,
            episodeCount: 10,
            episodes: [
                TVEpisode(
                    id: 1,
                    name: "TV Episode Name",
                    episodeNumber: 3,
                    seasonNumber: 2,
                    overview: "Overview for TV Episode",
                    airDate: Date(timeIntervalSince1970: 1_384_510_800)
                )
            ],
            networks: nil
        )
    }

}
