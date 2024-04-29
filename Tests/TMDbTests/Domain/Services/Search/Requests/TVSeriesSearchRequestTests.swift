//
//  TVSeriesSearchRequestTests.swift
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

final class TVSeriesSearchRequestTests: XCTestCase {

    func testPath() {
        let request = TVSeriesSearchRequest(query: "")

        XCTAssertEqual(request.path, "/search/tv")
    }

    func testQueryItemsWithQuery() {
        let request = TVSeriesSearchRequest(query: "fight club")

        XCTAssertEqual(request.queryItems, ["query": "fight club"])
    }

    func testQueryItemsWhenPageIsNilQueryItemsDoNotContainPage() {
        let request = TVSeriesSearchRequest(query: "", page: nil)

        XCTAssertEqual(request.queryItems, ["query": ""])
    }

    func testQueryItemsWhenPageQueryItemHasPage() {
        let request = TVSeriesSearchRequest(query: "", page: 3)

        XCTAssertEqual(request.queryItems, ["query": "", "page": "3"])
    }

    func testQueryItemsWhenFirstAirDateYearIsNilQueryItemsDoNotContainFirstAirDateYear() {
        let request = TVSeriesSearchRequest(query: "", firstAirDateYear: nil)

        XCTAssertEqual(request.queryItems, ["query": ""])
    }

    func testQueryItemsWhenFirstAirDateYearQueryItemHasFirstAirDateYear() {
        let request = TVSeriesSearchRequest(query: "", firstAirDateYear: 2024)

        XCTAssertEqual(request.queryItems, ["query": "", "first_air_date_year": "2024"])
    }

    func testQueryItemsWhenPageAndFirstAirDateYearQueryItemHasPageAndFirstAirDateYear() {
        let request = TVSeriesSearchRequest(query: "", firstAirDateYear: 2021, page: 4)

        XCTAssertEqual(request.queryItems, ["query": "", "first_air_date_year": "2021", "page": "4"])
    }

    func testMethodIsGet() {
        let request = TVSeriesSearchRequest(query: "")

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = TVSeriesSearchRequest(query: "")

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = TVSeriesSearchRequest(query: "")

        XCTAssertNil(request.body)
    }

}
