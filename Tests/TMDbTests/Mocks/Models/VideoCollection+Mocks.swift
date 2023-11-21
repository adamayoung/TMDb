//
//  VideoCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension VideoCollection {

    static func mock(
        id: Int = .randomID,
        results: [VideoMetadata] = .mocks
    ) -> Self {
        .init(
            id: id,
            results: results
        )
    }

}
