//
//  TVSeriesExternalLinksCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVSeriesExternalLinksCollection {

    ///
    /// A sample TV series external links collection, for use in tests and previews.
    ///
    static var sample: TVSeriesExternalLinksCollection {
        TVSeriesExternalLinksCollection(
            id: 1399,
            imdb: IMDbLink(imdbTitleID: "tt0944947"),
            wikiData: WikiDataLink(wikiDataID: "Q23572"),
            facebook: FacebookLink(facebookID: "GameOfThrones"),
            instagram: InstagramLink(instagramID: "gameofthrones"),
            twitter: TwitterLink(twitterID: "GameOfThrones")
        )
    }

}
