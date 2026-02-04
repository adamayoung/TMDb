//
//  AlternativeTitleTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct AlternativeTitleTests {

    @Test("JSON decoding of AlternativeTitleCollection", .tags(.decoding))
    func decodeAlternativeTitleCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AlternativeTitleCollection.self,
            fromResource: "alternative-title-collection"
        )

        #expect(result.id == 550)
        #expect(result.titles.count == 3)

        let usTitle = try #require(result.titles.first { $0.countryCode == "US" })
        #expect(usTitle.title == "Fight Club")
        #expect(usTitle.type == nil)

        let deTitle = try #require(result.titles.first { $0.countryCode == "DE" })
        #expect(deTitle.title == "Kampf-Club")
        #expect(deTitle.type == "Alternative Title")
    }

}
