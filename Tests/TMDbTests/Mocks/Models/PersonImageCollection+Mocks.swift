//
//  PersonImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension PersonImageCollection {

    static func mock(
        id: Int = .randomID,
        profiles: [ImageMetadata] = [.mock(), .mock()]
    ) -> Self {
        .init(
            id: id,
            profiles: profiles
        )
    }

}
