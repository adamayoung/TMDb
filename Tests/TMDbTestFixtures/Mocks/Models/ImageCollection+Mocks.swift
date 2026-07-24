//
//  ImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension ImageCollection {

    static func mock(
        id: Int = 1,
        posters: [ImageMetadata] = .mocks,
        logos: [ImageMetadata] = .mocks,
        backdrops: [ImageMetadata] = .mocks
    ) -> ImageCollection {
        ImageCollection(
            id: id,
            posters: posters,
            logos: logos,
            backdrops: backdrops
        )
    }

}
