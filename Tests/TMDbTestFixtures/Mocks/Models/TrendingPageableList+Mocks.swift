//
//  TrendingPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension TrendingPageableList {

    static func mock(
        page: Int = 1,
        results: [TrendingItem] = [.mockMovie(), .mockTVSeries(), .mockPerson()],
        totalResults: Int = 3,
        totalPages: Int = 1
    ) -> TrendingPageableList {
        TrendingPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
