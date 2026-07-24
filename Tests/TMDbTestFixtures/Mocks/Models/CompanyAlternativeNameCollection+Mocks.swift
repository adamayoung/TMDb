//
//  CompanyAlternativeNameCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension CompanyAlternativeNameCollection {

    static func mock(
        id: Int = 1,
        results: [CompanyAlternativeName] = [.mock(), .mock()]
    ) -> CompanyAlternativeNameCollection {
        CompanyAlternativeNameCollection(
            id: id,
            results: results
        )
    }

}
