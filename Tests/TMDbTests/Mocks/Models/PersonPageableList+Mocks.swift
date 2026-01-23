//
//  PersonPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension PersonPageableList {

    static func mock(
        page: Int = 1,
        results: [PersonListItem] = .mocks,
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> PersonPageableList {
        PersonPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
