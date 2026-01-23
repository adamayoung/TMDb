//
//  MoviePageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension MoviePageableList {

    static func mock(
        page: Int = 1,
        results: [MovieListItem] = .mocks,
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> MoviePageableList {
        MoviePageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
