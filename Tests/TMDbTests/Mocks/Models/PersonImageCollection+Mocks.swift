//
//  PersonImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension PersonImageCollection {

    static func mock(
        id: Int = 1,
        profiles: [ImageMetadata] = [.mock(), .mock()]
    ) -> PersonImageCollection {
        PersonImageCollection(
            id: id,
            profiles: profiles
        )
    }

}
