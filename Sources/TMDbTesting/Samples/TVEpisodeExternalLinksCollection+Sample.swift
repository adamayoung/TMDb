//
//  TVEpisodeExternalLinksCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVEpisodeExternalLinksCollection {

    /// A sample `TVEpisodeExternalLinksCollection` populated with representative data.
    static var sample: TVEpisodeExternalLinksCollection {
        TVEpisodeExternalLinksCollection(
            id: 63056,
            imdb: IMDbLink(imdbTitleID: "tt1480055"),
            wikiData: WikiDataLink(wikiDataID: "Q2614622")
        )
    }

}
