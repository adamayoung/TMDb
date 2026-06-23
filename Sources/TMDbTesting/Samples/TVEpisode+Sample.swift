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
            id: 63056,
            name: "Winter Is Coming",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: """
            Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his \
            oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen \
            plans to wed his sister to a nomadic warlord in exchange for an army.
            """,
            airDate: Date(timeIntervalSince1970: 1_302_998_400)
        )
    }

}
