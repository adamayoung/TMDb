//
//  ChangedIDCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ChangedIDCollection {

    static func mock(
        results: [ChangedID] = [
            ChangedID(id: 1, adult: false),
            ChangedID(id: 2, adult: false)
        ],
        page: Int = 1,
        totalPages: Int = 1,
        totalResults: Int = 2
    ) -> ChangedIDCollection {
        ChangedIDCollection(
            results: results,
            page: page,
            totalPages: totalPages,
            totalResults: totalResults
        )
    }

}
