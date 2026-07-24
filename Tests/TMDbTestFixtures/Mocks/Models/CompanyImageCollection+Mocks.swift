//
//  CompanyImageCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension CompanyImageCollection {

    static func mock(
        id: Int = 1,
        logos: [ImageMetadata] = [.mock(), .mock()]
    ) -> CompanyImageCollection {
        CompanyImageCollection(
            id: id,
            logos: logos
        )
    }

}
