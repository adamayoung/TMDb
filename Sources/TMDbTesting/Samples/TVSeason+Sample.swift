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
            id: 3624,
            name: "Season 1",
            seasonNumber: 1,
            overview: """
            Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of \
            this visionary world, control of Westeros' Iron Throne holds the lure of great power. \
            But in a land where the seasons can last a lifetime, winter is coming...and beyond the \
            Great Wall that protects them, an ancient evil has returned.
            """,
            airDate: Date(timeIntervalSince1970: 1_302_998_400),
            posterPath: URL(string: "/wgfKiqzuMrFIkU1M68DDDY8kGC1.jpg"),
            voteAverage: 8.4,
            episodeCount: 10,
            episodes: [
                TVEpisode(
                    id: 63056,
                    name: "Winter Is Coming",
                    episodeNumber: 1,
                    seasonNumber: 1,
                    overview: """
                    Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask \
                    his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys \
                    Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.
                    """,
                    airDate: Date(timeIntervalSince1970: 1_302_998_400)
                )
            ],
            networks: nil
        )
    }

}
