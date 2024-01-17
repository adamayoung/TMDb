//
//  TVSeriesPageableListTests.swift
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

final class TVSeriesPageableListTests: XCTestCase {

    func testDecodeReturnsTVSeriesPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(TVSeriesPageableList.self, fromResource: "tv-series-pageable-list")

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let list = TVSeriesPageableList(
        page: 1,
        results: [
            TVSeries(id: 1, name: "TV Series 1"),
            TVSeries(id: 2, name: "TV Series 2"),
            TVSeries(id: 3, name: "TV Series 3")
        ],
        totalResults: 3,
        totalPages: 1
    )

}
