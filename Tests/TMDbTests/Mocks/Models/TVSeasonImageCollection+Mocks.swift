//
//  TVSeasonImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TVSeasonImageCollection {

    static func mock(
        id: Int = 1,
        posters: [ImageMetadata] = .mocks
    ) -> TVSeasonImageCollection {
        TVSeasonImageCollection(
            id: id,
            posters: posters
        )
    }

}
