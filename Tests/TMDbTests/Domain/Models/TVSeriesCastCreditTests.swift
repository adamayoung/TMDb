//
//  TVSeriesCastCreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesCastCreditTests {

    @Test("JSON decoding of TVSeriesCastCredit", .tags(.decoding))
    func decodeReturnsTVSeriesCastCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesCastCredit.self, fromResource: "tv-series-cast-credit"
        )

        #expect(result == credit)
    }

}

extension TVSeriesCastCreditTests {

    private var credit: TVSeriesCastCredit {
        .init(
            id: 54,
            name: "Growing Pains",
            originalName: "Growing Pains",
            originalLanguage: "en",
            // swiftlint:disable:next line_length
            overview: "Growing Pains is an American television sitcom about an affluent family, residing in Huntington, Long Island, New York, with a working mother and a stay-at-home psychiatrist father raising three children together, which aired on ABC from September 24, 1985, to April 25, 1992.",
            genreIDs: [35],
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "1985-09-24"),
            originCountries: ["US"],
            posterPath: URL(string: "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg"),
            backdropPath: URL(string: "/xYpXcp7S8pStWihcksTQQue3jlV.jpg"),
            popularity: 2.883124,
            voteAverage: 6.2,
            voteCount: 25,
            episodeCount: 2,
            character: "",
            creditID: "525333fb19c295794002c720"
        )
    }

}
