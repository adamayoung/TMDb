//
//  TVEpisode+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVEpisode {

    ///
    /// A sample TV episode, for use in tests and previews.
    ///
    static var sample: TVEpisode {
        TVEpisode(
            id: 1,
            name: "TV Episode Name",
            episodeNumber: 3,
            seasonNumber: 2,
            overview: "Overview for TV Episode",
            airDate: Date(timeIntervalSince1970: 1_384_510_800)
        )
    }

}
