//
//  MultiSearchRequestTests.swift
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

final class MultiSearchRequestTests: XCTestCase {

    func testPath() {
        let request = MultiSearchRequest(query: "")

        XCTAssertEqual(request.path, "/search/multi")
    }

    func testQueryItemsWithQuery() {
        let request = MultiSearchRequest(query: "fight club")

        XCTAssertEqual(request.queryItems, ["query": "fight club"])
    }

    func testQueryItemsWithQueryAndIncludeAdult() {
        let request = MultiSearchRequest(query: "fight club", includeAdult: true)

        XCTAssertEqual(request.queryItems, ["query": "fight club", "include_adult": "true"])
    }

    func testQueryItemsWithQueryAndPage() {
        let request = MultiSearchRequest(query: "fight club", page: 2)

        XCTAssertEqual(request.queryItems, ["query": "fight club", "page": "2"])
    }

    func testQueryItemsWithQueryAndLanguage() {
        let request = MultiSearchRequest(query: "fight club", language: "en")

        XCTAssertEqual(request.queryItems, ["query": "fight club", "language": "en"])
    }

    func testQueryItemsWithQueryAndPageAndIncludeAdultAndLanguage() {
        let request = MultiSearchRequest(
            query: "fight club",
            includeAdult: false,
            page: 2,
            language: "en"
        )

        XCTAssertEqual(
            request.queryItems,
            ["query": "fight club", "page": "2", "include_adult": "false", "language": "en"]
        )
    }

    func testMethodIsGet() {
        let request = MultiSearchRequest(query: "")

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = MultiSearchRequest(query: "")

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = MultiSearchRequest(query: "")

        XCTAssertNil(request.body)
    }

}
