//
//  PersonPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension PersonPageableList {

    static func mock(
        page: Int = .random(in: 1 ... 5),
        results: [Person] = .mocks,
        totalResults: Int = .random(in: 1 ... 100),
        totalPages: Int = .random(in: 1 ... 5)
    ) -> Self {
        .init(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
