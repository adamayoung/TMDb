//
//  VideoCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension VideoCollection {

    static func mock(
        id: Int = 1,
        results: [VideoMetadata] = .mocks
    ) -> VideoCollection {
        VideoCollection(
            id: id,
            results: results
        )
    }

}
