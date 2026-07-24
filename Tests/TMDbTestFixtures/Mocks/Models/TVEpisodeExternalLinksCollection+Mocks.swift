//
//  TVEpisodeExternalLinksCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

package extension TVEpisodeExternalLinksCollection {

    static func mock(
        id: Int = 1,
        imdb: IMDbLink? = nil,
        wikiData: WikiDataLink? = nil
    ) -> TVEpisodeExternalLinksCollection {
        TVEpisodeExternalLinksCollection(
            id: id,
            imdb: imdb,
            wikiData: wikiData
        )
    }

}
