//
//  ProductionCountry+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension ProductionCountry {

    static func mock(
        countryCode: String = "US",
        name: String = "United States of America"
    ) -> ProductionCountry {
        ProductionCountry(
            countryCode: countryCode,
            name: name
        )
    }

}

package extension [ProductionCountry] {

    static var mocks: [ProductionCountry] {
        [.mock(), .mock(), .mock()]
    }

}
