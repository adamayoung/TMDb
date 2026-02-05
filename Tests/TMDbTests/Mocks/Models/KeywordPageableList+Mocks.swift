//
//  KeywordPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension KeywordPageableList {

    static func mock(
        page: Int = 1,
        results: [Keyword] = [.mock(), .mock(), .mock()],
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> KeywordPageableList {
        KeywordPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
