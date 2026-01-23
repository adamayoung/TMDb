//
//  ProductionCountryTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct ProductionCountryTests {

    @Test("id returns country code")
    func idReturnsCountryCode() {
        #expect(productionCountry.id == productionCountry.countryCode)
    }

    @Test("JSON decoding of ProductionCountry", .tags(.decoding))
    func decodeReturnsProductionCountry() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ProductionCountry.self, fromResource: "production-country"
        )

        #expect(result.countryCode == productionCountry.countryCode)
        #expect(result.name == productionCountry.name)
    }

    private let productionCountry = ProductionCountry(
        countryCode: "US",
        name: "United States of America"
    )

}
