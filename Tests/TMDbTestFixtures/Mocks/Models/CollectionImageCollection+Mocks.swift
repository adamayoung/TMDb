//
//  CollectionImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension CollectionImageCollection {

    static var mock: Self {
        CollectionImageCollection(
            id: 10,
            posters: [.mock(), .mock()],
            backdrops: [.mock(), .mock()]
        )
    }

}
