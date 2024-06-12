//
//  TVSeriesListItemTests.swift
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

final class TVSeriesListItemTests: XCTestCase {

    func testDecodeReturnsTVSeriesListItem() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(TVSeriesListItem.self, fromResource: "tv-series-list-item")

        XCTAssertEqual(result, tvSeries)
    }

}

extension TVSeriesListItemTests {

    // swiftlint:disable line_length
    private var tvSeries: TVSeriesListItem {
        TVSeriesListItem(
            id: 11366,
            name: "Big Brother",
            originalName: "Big Brother",
            originalLanguage: "en",
            overview: "A British reality television game show in which a number of contestants live in an isolated house for several weeks, trying to avoid being evicted by the public with the aim of winning a large cash prize at the end of the run.",
            genreIDs: [10764],
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2000-07-18"),
            originCountries: ["GB"],
            posterPath: URL(string: "/p7lsmCU5ZqaMGKZAuZMkFc02X8o.jpg"),
            backdropPath: URL(string: "/3SWOj8ydFrxiuZdLg63fDAt4jYR.jpg"),
            popularity: 5434.15,
            voteAverage: 3.833,
            voteCount: 48,
            isAdultOnly: false
        )
    }
    // swiftlint:enable line_length

}
