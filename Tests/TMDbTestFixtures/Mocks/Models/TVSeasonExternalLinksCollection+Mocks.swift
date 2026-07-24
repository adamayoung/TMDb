//
//  TVSeasonExternalLinksCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

package extension TVSeasonExternalLinksCollection {

    static func mock(
        id: Int = 1,
        wikiData: WikiDataLink? = nil
    ) -> TVSeasonExternalLinksCollection {
        TVSeasonExternalLinksCollection(
            id: id,
            wikiData: wikiData
        )
    }

}
