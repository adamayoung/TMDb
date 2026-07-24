//
//  TVEpisodePageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension TVEpisodePageableList {

    static func mock(
        page: Int = 1,
        results: [TVEpisode] = .mocks,
        totalResults: Int? = 10,
        totalPages: Int? = 2
    ) -> TVEpisodePageableList {
        TVEpisodePageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
