//
//  ReviewPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ReviewPageableList {

    static func mock(
        page: Int = 1,
        results: [Review] = .mocks,
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> ReviewPageableList {
        ReviewPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
