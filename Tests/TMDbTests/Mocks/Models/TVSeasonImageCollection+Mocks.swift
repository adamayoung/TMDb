//
//  TVSeasonImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension TVSeasonImageCollection {

    static func mock(
        id: Int = .randomID,
        posters: [ImageMetadata] = .mocks
    ) -> Self {
        .init(
            id: id,
            posters: posters
        )
    }

}
