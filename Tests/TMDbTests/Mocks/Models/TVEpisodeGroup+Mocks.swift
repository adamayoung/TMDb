//
//  TVEpisodeGroup+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TVEpisodeGroup {

    static func mock(
        id: String = "5acf93e60e0a26346d0000ce",
        name: String = "Netflix Collections",
        description: String? = "Comedians in Cars organized.",
        episodeCount: Int? = 83,
        groupCount: Int? = 6,
        type: Int? = 4,
        network: Network? = .mock(
            id: 213,
            name: "Netflix",
            logoPath: URL(
                string: "/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
            ),
            originCountry: ""
        ),
        groups: [TVEpisodeGroup.Group]? = nil
    ) -> TVEpisodeGroup {
        TVEpisodeGroup(
            id: id,
            name: name,
            description: description,
            episodeCount: episodeCount,
            groupCount: groupCount,
            type: type,
            network: network,
            groups: groups
        )
    }

    static var netflixCollections: TVEpisodeGroup {
        TVEpisodeGroup.mock()
    }

}
