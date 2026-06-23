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
            id: 1,
            episodeGroups: [
                TVEpisodeGroup(
                    id: "5acf93e60e0a26346c00000b",
                    name: "Aired Order",
                    description: "",
                    episodeCount: 73,
                    groupCount: 8,
                    type: 1
                )
            ]
        )
    }

}
