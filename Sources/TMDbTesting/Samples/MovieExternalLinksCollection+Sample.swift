//
//  MovieExternalLinksCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension MovieExternalLinksCollection {

    /// A sample `MovieExternalLinksCollection` for use in previews and tests.
    static var sample: MovieExternalLinksCollection {
        MovieExternalLinksCollection(
            id: 346_698,
            imdb: IMDbLink(imdbTitleID: "tt1517268"),
            wikiData: WikiDataLink(wikiDataID: "Q55436290"),
            facebook: FacebookLink(facebookID: "BarbieTheMovie"),
            instagram: InstagramLink(instagramID: "barbiethemovie"),
            twitter: TwitterLink(twitterID: "barbiethemovie")
        )
    }

}
