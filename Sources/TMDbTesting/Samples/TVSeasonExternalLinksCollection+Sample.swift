//
//  TVSeasonExternalLinksCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVSeasonExternalLinksCollection {

    /// A sample `TVSeasonExternalLinksCollection` populated with representative data.
    static var sample: TVSeasonExternalLinksCollection {
        TVSeasonExternalLinksCollection(
            id: 3624,
            wikiData: WikiDataLink(wikiDataID: "Q1658029")
        )
    }

}
