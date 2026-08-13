//
//  MovieReleaseDatesResultTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct MovieReleaseDatesResultTests {

    /// The by-country element was covered; the wrapper this endpoint actually
    /// returns was not.
    @Test("JSON decoding of MovieReleaseDatesResult")
    func decodeReturnsMovieReleaseDatesResult() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieReleaseDatesResult.self,
            fromResource: "movie-release-dates"
        )

        #expect(result.id == 550)
        #expect(result.results.count == 3)

        let gb = try #require(result.results.first { $0.countryCode == "GB" })
        #expect(gb.releaseDates.count == 2)
        #expect(gb.releaseDates.map(\.certification) == ["18", "18"])
        #expect(gb.releaseDates.map(\.note) == ["", "Blu-ray"])

        // `descriptors` is populated only on some certifications.
        let turkey = try #require(result.results.first { $0.countryCode == "TR" })
        let turkishRating = try #require(turkey.releaseDates.first)
        #expect(turkishRating.certification == "18+")
        #expect(turkishRating.descriptors == ["Violence / Horror", "Sexuality", "Negative examples"])

        // A per-language release carries iso_639_1; most rows send "".
        let swiss = try #require(result.results.first { $0.countryCode == "CH" })
        let swissRating = try #require(swiss.releaseDates.first)
        #expect(swissRating.languageCode == "fr")
    }

}
