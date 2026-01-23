//
//  CountryTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct CountryTests {

    @Test("JSON decoding of Country", .tags(.decoding))
    func decodeCountry() throws {
        let expectedResult = Country(
            countryCode: "US",
            name: "United States",
            englishName: "United States of America"
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            Country.self, fromResource: "configuration-country"
        )

        #expect(result.id == expectedResult.countryCode)
        #expect(result.countryCode == expectedResult.countryCode)
        #expect(result.name == expectedResult.name)
        #expect(result.englishName == expectedResult.englishName)
    }

}
