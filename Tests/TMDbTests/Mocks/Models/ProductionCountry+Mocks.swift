//
//  ProductionCountry+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension ProductionCountry {

    static func mock(
        countryCode: String = .randomString,
        name: String = .randomString
    ) -> Self {
        .init(
            countryCode: countryCode,
            name: name
        )
    }

}

extension [ProductionCountry] {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
