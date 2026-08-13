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

    /// The TV Series endpoint sends the titles under "results" rather than the
    /// Movies API's "titles" — a separate branch of the hand-written decoder that
    /// no fixture exercised until now.
    @Test("JSON decoding of AlternativeTitleCollection from the TV Series results key", .tags(.decoding))
    func decodeAlternativeTitleCollectionFromResultsKey() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AlternativeTitleCollection.self,
            fromResource: "tv-series-alternative-titles"
        )

        #expect(result.id == 1396)
        #expect(result.titles.count == 3)

        let brTitle = try #require(result.titles.first { $0.countryCode == "BR" })
        #expect(brTitle.title == "Breaking Bad: A Química do Mal")
        #expect(brTitle.type == "altered title for broadcast on tv channel Record")

        let usTitle = try #require(result.titles.first { $0.countryCode == "US" })
        #expect(usTitle.title == "BB")
        #expect(usTitle.type == "abbreviation")

        // TMDb sends an empty string, not null, when a title has no type.
        let bgTitle = try #require(result.titles.first { $0.countryCode == "BG" })
        #expect(bgTitle.title == "В обувките на Сатаната")
        #expect(bgTitle.type == "")
    }

    @Test("JSON decoding of AlternativeTitleCollection with neither titles nor results", .tags(.decoding))
    func decodeAlternativeTitleCollectionWithNoTitlesKey() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AlternativeTitleCollection.self,
            fromResource: "tv-series-alternative-titles-empty"
        )

        #expect(result.id == 1396)
        #expect(result.titles.isEmpty)
    }

}
