//
//  CollectionImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension CollectionImageCollection {

    static var mock: Self {
        CollectionImageCollection(
            id: 10,
            posters: [.mock(), .mock()],
            backdrops: [.mock(), .mock()]
        )
    }

}
