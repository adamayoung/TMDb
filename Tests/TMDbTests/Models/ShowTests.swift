//
//  ShowTests.swift
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

final class ShowTests: XCTestCase {

    func testIDWhenMovieReturnsMovieID() {
        XCTAssertEqual(movieShow.id, 109_091)
    }

    func testIDWhenTVSeriesReturnsTVSeriesID() {
        XCTAssertEqual(tvSeriesShow.id, 54)
    }

    func testPopularityWhenMovieReturnsMoviePopularity() {
        XCTAssertEqual(movieShow.popularity, 3.597124)
    }

    func testPopularityWhenTVSeriesReturnsTVSeriesPopularity() {
        XCTAssertEqual(tvSeriesShow.popularity, 2.883124)
    }

    func testDateWhenMovieReturnsMovieReleaseDate() {
        let expectedResult = DateFormatter.theMovieDatabase.date(from: "2013-10-25")
        XCTAssertEqual(movieShow.date, expectedResult)
    }

    func testDateWhenTVSeriesReturnsTVSeriesFirstAirDate() {
        let expectedResult = DateFormatter.theMovieDatabase.date(from: "1985-09-24")
        XCTAssertEqual(tvSeriesShow.date, expectedResult)
    }

    func testDecodeReturnsMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, fromResource: "show-movie")

        XCTAssertEqual(result, movieShow)
    }

    func testDecodeReturnsTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, fromResource: "show-tv-series")

        XCTAssertEqual(result, tvSeriesShow)
    }

}

extension ShowTests {

    // swiftlint:disable line_length
    private var movieShow: Show {
        .movie(
            .init(
                id: 109_091,
                title: "The Counselor",
                originalTitle: "The Counselor",
                originalLanguage: "en",
                overview: "A rich and successful lawyer named Counselor is about to get married to his fiancée but soon meets up with the middle-man known as Westray who tells him his drug trafficking plan has taken a horrible twist and now he must protect himself and his soon bride-to-be lover as the truth of the drug business uncovers and targets become chosen.",
                releaseDate: DateFormatter.theMovieDatabase.date(from: "2013-10-25"),
                posterPath: URL(string: "/uxp6rHVBzUqZCyTaUI8xzUP5sOf.jpg"),
                backdropPath: URL(string: "/62xHmGnxMi0wV40BS3iKnDru0nO.jpg"),
                popularity: 3.597124,
                voteAverage: 5,
                voteCount: 661,
                hasVideo: false,
                isAdultOnly: false
            )
        )
    }

    private var tvSeriesShow: Show {
        .tvSeries(
            .init(
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
        )
    }
    // swiftlint:enable line_length

}
