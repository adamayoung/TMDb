//
//  MovieRequestTests.swift
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

final class MovieRequestTests: XCTestCase {

    func testPathReturnsURL() {
        let request = MovieRequest(id: 1)

        XCTAssertEqual(request.path, "/movie/1")
    }

    func testQueryItemsAreEmpty() {
        let request = MovieRequest(id: 1)

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testMethodIsGet() {
        let request = MovieRequest(id: 1)

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = MovieRequest(id: 1)

        XCTAssertEqual(request.headers, [:])
    }

    func testBodyIsNil() {
        let request = MovieRequest(id: 1)

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = MovieRequest(id: 1)

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
