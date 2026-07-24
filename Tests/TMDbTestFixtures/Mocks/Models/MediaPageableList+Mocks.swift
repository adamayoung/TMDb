//
//  MediaPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension MediaPageableList {

    static func mock(
        page: Int = 1,
        results: [Media] = .mocks,
        totalResults: Int? = 10,
        totalPages: Int? = 2
    ) -> MediaPageableList {
        MediaPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
