//
//  PersonTVSeriesCreditsTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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

@testable import TMDb
import XCTest

final class PersonTVSeriesCreditsTests: XCTestCase {

    func testDecodeReturnsPersonTVSeriesCredits() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonTVSeriesCredits.self, fromResource: "person-tv-series-credits")

        XCTAssertEqual(result.id, personTVSeriesCredits.id)
        XCTAssertEqual(result.cast, personTVSeriesCredits.cast)
        XCTAssertEqual(result.crew, personTVSeriesCredits.crew)
    }

    func testAllShows() {
        let tvSeries1 = TVSeries(id: 1, name: "TV Series 1")
        let tvSeries2 = TVSeries(id: 2, name: "TV Series 2")
        let credits = PersonTVSeriesCredits(id: 999, cast: [tvSeries1, tvSeries2], crew: [tvSeries1])

        let expectedResult = [tvSeries1, tvSeries2]

        let result = credits.allShows

        XCTAssertEqual(result, expectedResult)
    }

    // swiftlint:disable line_length
    private let personTVSeriesCredits = PersonTVSeriesCredits(
        id: 287,
        cast: [
            TVSeries(
                id: 54,
                name: "Growing Pains",
                originalName: "Growing Pains",
                originalLanguage: "en",
                overview: "Growing Pains is an American television sitcom about an affluent family, residing in Huntington, Long Island, New York, with a working mother and a stay-at-home psychiatrist father raising three children together, which aired on ABC from September 24, 1985, to April 25, 1992.",
                firstAirDate: DateFormatter.theMovieDatabase.date(from: "1985-09-24"),
                originCountry: ["US"],
                posterPath: URL(string: "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg"),
                backdropPath: URL(string: "/xYpXcp7S8pStWihcksTQQue3jlV.jpg"),
                popularity: 2.883124,
                voteAverage: 6.2,
                voteCount: 25
            )
        ],
        crew: [
            TVSeries(
                id: 69061,
                name: "The OA",
                originalName: "The OA",
                originalLanguage: "en",
                overview: "Prairie Johnson, blind as a child, comes home to the community she grew up in with her sight restored. Some hail her a miracle, others a dangerous mystery, but Prairie won’t talk with the FBI or her parents about the seven years she went missing.", firstAirDate: DateFormatter.theMovieDatabase.date(from: "2016-12-16"),
                originCountry: [],
                posterPath: URL(string: "/ppSiYu2D0nw6KNF0kf5lKDxOGRR.jpg"),
                backdropPath: URL(string: "/k9kPIikcQBzl93nSyXUfqc74J9S.jpg"),
                popularity: 6.990147,
                voteAverage: 7.3,
                voteCount: 121
            )
        ]
    )
    // swiftlint:enable line_length

}
