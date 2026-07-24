//
//  TVEpisodeImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension TVEpisodeImageCollection {

    static func mock(
        id: Int = 1,
        stills: [ImageMetadata] = .mocks
    ) -> TVEpisodeImageCollection {
        TVEpisodeImageCollection(
            id: id,
            stills: stills
        )
    }

}
