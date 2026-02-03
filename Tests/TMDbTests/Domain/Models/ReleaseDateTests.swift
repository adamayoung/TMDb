//
//  ReleaseDateTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ReleaseDateTests {

    @Test("decodes from JSON", .tags(.decoding))
    func decodesFromJSON() throws {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let releaseDate = try #require(formatter.date(from: "1999-10-15T00:00:00.000Z"))
        let expectedResult = ReleaseDate(
            certification: "R",
            languageCode: "",
            note: "Los Angeles, California",
            releaseDate: releaseDate,
            type: .premiere
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseDate.self,
            fromResource: "release-date"
        )

        #expect(result == expectedResult)
    }

}
