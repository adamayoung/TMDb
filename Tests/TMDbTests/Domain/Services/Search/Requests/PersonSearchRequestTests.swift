//
//  PersonSearchRequestTests.swift
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

final class PersonSearchRequestTests: XCTestCase {

    func testPath() {
        let request = PersonSearchRequest(query: "")

        XCTAssertEqual(request.path, "/search/person")
    }

    func testQueryItemsWithQuery() {
        let request = PersonSearchRequest(query: "edward norton")

        XCTAssertEqual(request.queryItems, ["query": "edward norton"])
    }

    func testQueryItemsWithQueryAndIncludeAdult() {
        let request = PersonSearchRequest(query: "edward norton", includeAdult: true)

        XCTAssertEqual(request.queryItems, ["query": "edward norton", "include_adult": "true"])
    }

    func testQueryItemsWithPage() {
        let request = PersonSearchRequest(query: "edward norton", page: 3)

        XCTAssertEqual(request.queryItems, ["query": "edward norton", "page": "3"])
    }

    func testQueryItemsWithLanguage() {
        let request = PersonSearchRequest(query: "edward norton", language: "en")

        XCTAssertEqual(request.queryItems, ["query": "edward norton", "language": "en"])
    }

    func testQueryItemsWithQueryAndIncludeAdultAndPageAndLanguage() {
        let request = PersonSearchRequest(query: "edward norton", includeAdult: false, page: 2, language: "en")

        XCTAssertEqual(
            request.queryItems,
            ["query": "edward norton", "include_adult": "false", "page": "2", "language": "en"]
        )
    }

    func testMethodIsGet() {
        let request = PersonSearchRequest(query: "")

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = PersonSearchRequest(query: "")

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = PersonSearchRequest(query: "")

        XCTAssertNil(request.body)
    }

}
