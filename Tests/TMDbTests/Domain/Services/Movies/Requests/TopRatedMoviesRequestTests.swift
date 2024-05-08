//
//  TopRatedMoviesRequestTests.swift
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

final class TopRatedMoviesRequestTests: XCTestCase {

    func testPath() {
        let request = TopRatedMoviesRequest()

        XCTAssertEqual(request.path, "/movie/top_rated")
    }

    func testQueryItemsIsEmpty() {
        let request = TopRatedMoviesRequest()

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWithPage() {
        let request = TopRatedMoviesRequest(page: 3)

        XCTAssertEqual(request.queryItems, ["page": "3"])
    }

    func testQueryItemsWithLanguage() {
        let request = TopRatedMoviesRequest(language: "en")

        XCTAssertEqual(request.queryItems, ["language": "en"])
    }

    func testQueryItemsWithCountry() {
        let request = TopRatedMoviesRequest(country: "GB")

        XCTAssertEqual(request.queryItems, ["region": "GB"])
    }

    func testQueryItemsWithPageAndLanguageAndCountry() {
        let request = TopRatedMoviesRequest(page: 3, language: "en", country: "GB")

        XCTAssertEqual(request.queryItems, ["page": "3", "language": "en", "region": "GB"])
    }

    func testMethodIsGet() {
        let request = TopRatedMoviesRequest()

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = TopRatedMoviesRequest()

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = TopRatedMoviesRequest()

        XCTAssertNil(request.body)
    }

}
