//
//  CollectionPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CollectionPageableList {

    static func mock(
        page: Int = 1,
        results: [CollectionListItem] = [.mock(), .mock(), .mock()],
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> CollectionPageableList {
        CollectionPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
