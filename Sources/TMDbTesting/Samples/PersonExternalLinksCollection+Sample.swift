//
//  PersonExternalLinksCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension PersonExternalLinksCollection {

    /// A sample `PersonExternalLinksCollection` populated with representative data.
    static var sample: PersonExternalLinksCollection {
        PersonExternalLinksCollection(
            id: 346_698,
            imdb: IMDbLink(imdbNameID: "nm2858875"),
            wikiData: WikiDataLink(wikiDataID: "Q49561909"),
            facebook: FacebookLink(facebookID: "sydney_sweeney"),
            instagram: InstagramLink(instagramID: "sydney_sweeney"),
            twitter: TwitterLink(twitterID: "sydney_sweeney"),
            tikTok: TikTokLink(tikTokID: "syds_garage")
        )
    }

}
