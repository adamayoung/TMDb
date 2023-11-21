//
//  TVEpisodeImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension TVEpisodeImageCollection {

    static func mock(
        id: Int = .randomID,
        stills: [ImageMetadata] = .mocks
    ) -> Self {
        .init(
            id: id,
            stills: stills
        )
    }

}
