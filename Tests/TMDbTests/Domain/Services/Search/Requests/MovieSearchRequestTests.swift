//
//  MovieSearchRequestTests.swift
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

final class MovieSearchRequestTests: XCTestCase {

    func testPath() {
        let request = MovieSearchRequest(query: "")

        XCTAssertEqual(request.path, "/search/movie")
    }

    func testQueryItemsWithQuery() {
        let request = MovieSearchRequest(query: "fight club")

        XCTAssertEqual(request.queryItems, ["query": "fight club"])
    }

    func testQueryItemsWhenPageIsNilQueryItemsDoNotContainPage() {
        let request = MovieSearchRequest(query: "", page: nil)

        XCTAssertEqual(request.queryItems, ["query": ""])
    }

    func testQueryItemsWhenPageQueryItemHasPage() {
        let request = MovieSearchRequest(query: "", page: 3)

        XCTAssertEqual(request.queryItems, ["query": "", "page": "3"])
    }

    func testQueryItemsWhenYearIsNilQueryItemsDoNotContainYear() {
        let request = MovieSearchRequest(query: "", year: nil)

        XCTAssertEqual(request.queryItems, ["query": ""])
    }

    func testQueryItemsWhenYearQueryItemHasYear() {
        let request = MovieSearchRequest(query: "", year: 2024)

        XCTAssertEqual(request.queryItems, ["query": "", "year": "2024"])
    }

    func testQueryItemsWhenPageAndYearQueryItemHasPageAndYear() {
        let request = MovieSearchRequest(query: "", year: 2021, page: 4)

        XCTAssertEqual(request.queryItems, ["query": "", "year": "2021", "page": "4"])
    }

    func testMethodIsGet() {
        let request = MovieSearchRequest(query: "")

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = MovieSearchRequest(query: "")

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = MovieSearchRequest(query: "")

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = MovieSearchRequest(query: "")

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
