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
            id: "5e9077d2e640d600151f32bd",
            name: "Aired Order",
            description: "",
            episodeCount: 102,
            groupCount: 9,
            type: 1,
            network: Network(
                id: 49,
                name: "HBO",
                logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
                originCountry: "US"
            ),
            groups: nil
        )
    }

}
