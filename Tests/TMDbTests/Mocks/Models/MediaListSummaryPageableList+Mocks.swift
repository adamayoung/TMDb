//
//  MediaListSummaryPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension MediaListSummaryPageableList {

    static func mock(
        page: Int = 1,
        results: [MediaListSummary] = .mocks,
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> MediaListSummaryPageableList {
        MediaListSummaryPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
