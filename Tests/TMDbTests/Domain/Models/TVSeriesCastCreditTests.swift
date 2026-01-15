//
//  TVSeriesCastCreditTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesCastCreditTests {

    @Test("JSON decoding of TVSeriesCastCredit", .tags(.decoding))
    func decodeReturnsTVSeriesCastCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesCastCredit.self, fromResource: "tv-series-cast-credit")

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
            overview:
                "Growing Pains is an American television sitcom about an affluent family, residing in Huntington, Long Island, New York, with a working mother and a stay-at-home psychiatrist father raising three children together, which aired on ABC from September 24, 1985, to April 25, 1992.",
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
