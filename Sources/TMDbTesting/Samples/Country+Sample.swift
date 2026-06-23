//
//  Country+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Country {

    /// A sample `Country` for use in previews and tests.
    static var sample: Country {
        Country(
            countryCode: "US",
            name: "United States",
            englishName: "United States of America"
        )
    }

}

public extension [Country] {

    /// A collection of sample `Country` values for use in previews and tests.
    static var samples: [Country] {
        [
            Country(
                countryCode: "GB",
                name: "United Kingdom",
                englishName: "United Kingdom"
            ),
            Country(
                countryCode: "US",
                name: "United States",
                englishName: "United States of America"
            )
        ]
    }

}
