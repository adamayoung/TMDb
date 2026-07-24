//
//  CompanyPageableList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension CompanyPageableList {

    static func mock(
        page: Int = 1,
        results: [ProductionCompany] = .mocks,
        totalResults: Int = 10,
        totalPages: Int = 2
    ) -> CompanyPageableList {
        CompanyPageableList(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
