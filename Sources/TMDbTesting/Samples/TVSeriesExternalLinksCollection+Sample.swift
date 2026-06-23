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
            id: 86423,
            imdb: IMDbLink(imdbTitleID: "tt3007572"),
            wikiData: nil,
            facebook: FacebookLink(facebookID: "lockeandkeynetflix"),
            instagram: InstagramLink(instagramID: "lockeandkeynetflix"),
            twitter: TwitterLink(twitterID: "lockekeynetflix")
        )
    }

}
