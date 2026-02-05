//
//  TaggedImagePageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TaggedImagePageableList {

    static func mock(
        page: Int = 1,
        results: [TaggedImage] = .mocks,
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> TaggedImagePageableList {
        TaggedImagePageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
