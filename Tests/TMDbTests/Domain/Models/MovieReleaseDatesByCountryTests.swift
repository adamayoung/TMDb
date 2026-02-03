//
//  MovieReleaseDatesByCountryTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MovieReleaseDatesByCountryTests {

    @Test("decodes from JSON", .tags(.decoding))
    func decodesFromJSON() throws {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let expectedResult = try MovieReleaseDatesByCountry(
            countryCode: "US",
            releaseDates: [
                ReleaseDate(
                    certification: "R",
                    languageCode: "",
                    note: "Los Angeles, California",
                    releaseDate: #require(formatter.date(from: "1999-10-15T00:00:00.000Z")),
                    type: .premiere
                ),
                ReleaseDate(
                    certification: "R",
                    languageCode: "",
                    note: "",
                    releaseDate: #require(formatter.date(from: "1999-10-15T00:00:00.000Z")),
                    type: .theatrical
                )
            ]
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieReleaseDatesByCountry.self,
            fromResource: "movie-release-dates-by-country"
        )

        #expect(result == expectedResult)
    }

}
