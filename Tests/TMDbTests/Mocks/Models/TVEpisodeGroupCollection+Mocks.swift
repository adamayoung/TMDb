//
//  TVEpisodeGroupCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TVEpisodeGroupCollection {

    static func mock(
        id: Int = 1,
        episodeGroups: [TVEpisodeGroup] = [
            TVEpisodeGroup(
                id: "5acf93e60e0a26346c00000b",
                name: "Aired Order",
                description: "",
                episodeCount: 73,
                groupCount: 8,
                type: 1
            )
        ]
    ) -> TVEpisodeGroupCollection {
        TVEpisodeGroupCollection(
            id: id,
            episodeGroups: episodeGroups
        )
    }

}
