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
            id: 1,
            imdb: IMDbLink(imdbTitleID: "tt2178784"),
            wikiData: WikiDataLink(wikiDataID: "Q18027861")
        )
    }

}
