//
//  TVSeriesCrewCreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesCrewCreditTests {

    @Test("JSON decoding of TVSeriesCrewCredit", .tags(.decoding))
    func decodeReturnsTVSeriesCrewCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesCrewCredit.self, fromResource: "tv-series-crew-credit"
        )

        #expect(result == credit)
    }

}

extension TVSeriesCrewCreditTests {

    private var credit: TVSeriesCrewCredit {
        .init(
            id: 69061,
            name: "The OA",
            originalName: "The OA",
            originalLanguage: "en",
            overview:
            // swiftlint:disable:next line_length
            "Prairie Johnson, blind as a child, comes home to the community she grew up in with her sight restored. Some hail her a miracle, others a dangerous mystery, but Prairie won't talk with the FBI or her parents about the seven years she went missing.",
            genreIDs: [18, 9648, 10765],
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2016-12-16"),
            originCountries: [],
            posterPath: URL(string: "/ppSiYu2D0nw6KNF0kf5lKDxOGRR.jpg"),
            backdropPath: URL(string: "/k9kPIikcQBzl93nSyXUfqc74J9S.jpg"),
            popularity: 6.990147,
            voteAverage: 7.3,
            voteCount: 121,
            episodeCount: 8,
            job: "Executive Producer",
            department: "Production",
            creditID: "58cf92ae9251415a7d0339c3"
        )
    }

}
