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
            id: 550,
            imdb: IMDbLink(imdbTitleID: "tt0137523"),
            wikiData: WikiDataLink(wikiDataID: "Q190050"),
            facebook: FacebookLink(facebookID: "FightClub"),
            instagram: InstagramLink(instagramID: nil),
            twitter: TwitterLink(twitterID: nil)
        )
    }

}
