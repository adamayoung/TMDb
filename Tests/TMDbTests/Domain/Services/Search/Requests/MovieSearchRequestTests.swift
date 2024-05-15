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

    func testQueryItemsWithQueryAndPrimaryReleaseYear() {
        let request = MovieSearchRequest(query: "fight club", primaryReleaseYear: 2024)

        XCTAssertEqual(request.queryItems, ["query": "fight club", "primary_release_year": "2024"])
    }

    func testQueryItemsWithQueryAndCountry() {
        let request = MovieSearchRequest(query: "fight club", country: "GB")

        XCTAssertEqual(request.queryItems, ["query": "fight club", "region": "GB"])
    }

    func testQueryItemsWithQueryAndIncludeAdult() {
        let request = MovieSearchRequest(query: "fight club", includeAdult: true)

        XCTAssertEqual(request.queryItems, ["query": "fight club", "include_adult": "true"])
    }

    func testQueryItemsWithQueryAndPage() {
        let request = MovieSearchRequest(query: "fight club", page: 3)

        XCTAssertEqual(request.queryItems, ["query": "fight club", "page": "3"])
    }

    func testQueryItemsWithQueryAndLanguage() {
        let request = MovieSearchRequest(query: "fight club", language: "en")

        XCTAssertEqual(request.queryItems, ["query": "fight club", "language": "en"])
    }

    func testQueryItemsWithQueryAndPrimaryReleaseYearAndCountryAndIncludeAdultAndPageAndLanugage() {
        let request = MovieSearchRequest(
            query: "fight club",
            primaryReleaseYear: 2024,
            includeAdult: false,
            page: 2,
            language: "en"
        )

        XCTAssertEqual(
            request.queryItems,
            [
                "query": "fight club",
                "primary_release_year": "2024",
                "include_adult": "false",
                "page": "2",
                "language": "en"
            ]
        )
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

}
