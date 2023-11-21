//
//  TVSeriesPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension TVSeriesPageableList {

    static func mock(
        page: Int = Int.random(in: 1 ... 5),
        results: [TVSeries] = .mocks,
        totalResults: Int? = Int.random(in: 1 ... 100),
        totalPages: Int? = Int.random(in: 1 ... 5)
    ) -> Self {
        .init(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
