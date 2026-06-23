//
//  TVEpisodeGroup+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVEpisodeGroup {

    /// A sample `TVEpisodeGroup` for use in tests and previews.
    static var sample: TVEpisodeGroup {
        TVEpisodeGroup(
            id: "5acf93e60e0a26346d0000ce",
            name: "Netflix Collections",
            description: "Comedians in Cars organized.",
            episodeCount: 83,
            groupCount: 6,
            type: 4,
            network: Network(
                id: 213,
                name: "Netflix",
                logoPath: URL(string: "/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"),
                originCountry: ""
            ),
            groups: nil
        )
    }

}
