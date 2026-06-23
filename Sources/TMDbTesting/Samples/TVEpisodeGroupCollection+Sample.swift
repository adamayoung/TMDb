//
//  TVEpisodeGroupCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVEpisodeGroupCollection {

    /// A sample `TVEpisodeGroupCollection` populated with representative data.
    static var sample: TVEpisodeGroupCollection {
        TVEpisodeGroupCollection(
            id: 1399,
            episodeGroups: [
                TVEpisodeGroup(
                    id: "5e9077d2e640d600151f32bd",
                    name: "Aired Order",
                    description: "",
                    episodeCount: 102,
                    groupCount: 9,
                    type: 1
                )
            ]
        )
    }

}
