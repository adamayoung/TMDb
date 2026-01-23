//
//  TVSeriesPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TVSeriesPageableList {

    static func mock(
        page: Int = 1,
        results: [TVSeriesListItem] = .mocks,
        totalResults: Int? = 10,
        totalPages: Int? = 2
    ) -> TVSeriesPageableList {
        TVSeriesPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
