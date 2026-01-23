//
//  Country+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Country {

    static func mock(
        countryCode: String = "US",
        name: String = "United States",
        englishName: String = "United States of America"
    ) -> Country {
        Country(
            countryCode: countryCode,
            name: name,
            englishName: englishName
        )
    }

    static var unitedKingdom: Country {
        Country.mock(
            countryCode: "GB",
            name: "United Kingdom",
            englishName: "United Kingdom"
        )
    }

    static var unitedStates: Country {
        Country.mock(
            countryCode: "US",
            name: "United States",
            englishName: "United States of America"
        )
    }

}

extension [Country] {

    static var mocks: [Element] {
        [.unitedKingdom, .unitedStates]
    }

}
