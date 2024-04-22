//
//  PopularMoviesRequestTests.swift
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

final class PopularMoviesRequestTests: XCTestCase {

    func testPath() {
        let request = PopularMoviesRequest()

        XCTAssertEqual(request.path, "/movie/popular")
    }

    func testQueryItemsWhenPageIsNilQueryItemsAreEmpty() {
        let request = PopularMoviesRequest()

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWhenPageQueryItemsHasPage() {
        let request = PopularMoviesRequest(page: 3)

        XCTAssertEqual(request.queryItems, ["page": "3"])
    }

    func testMethodIsGet() {
        let request = PopularMoviesRequest()

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = PopularMoviesRequest()

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = PopularMoviesRequest()

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = PopularMoviesRequest()

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
