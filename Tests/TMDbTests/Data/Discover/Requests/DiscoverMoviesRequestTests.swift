//
//  DiscoverMoviesRequestTests.swift
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

final class DiscoverMoviesRequestTests: XCTestCase {

    func testPathReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/movie"))

        let request = DiscoverMoviesRequest()

        XCTAssertEqual(request.path, expectedPath)
    }

    func testPathWithSortedByReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/movie?sort_by=original_title.asc"))

        let request = DiscoverMoviesRequest(sortedBy: .originalTitle(descending: false))

        XCTAssertEqual(request.path, expectedPath)
    }

    func testPathWithWithPeopleReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/movie?with_people=1,2,3"))

        let request = DiscoverMoviesRequest(people: [1, 2, 3])

        XCTAssertEqual(request.path, expectedPath)
    }

    func testPathWithPageReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/movie?page=1"))

        let request = DiscoverMoviesRequest(page: 1)

        XCTAssertEqual(request.path, expectedPath)
    }

    func testPathWithSortedByAndWithPeopleAndPageReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(
            string: "/discover/movie?sort_by=original_title.asc&with_people=1,2,3&page=1")
        )

        let request = DiscoverMoviesRequest(sortedBy: .originalTitle(descending: false), people: [1, 2, 3], page: 1)

        XCTAssertEqual(request.path, expectedPath)
    }

    func testMethodIsGet() {
        let request = DiscoverMoviesRequest()

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = DiscoverMoviesRequest()

        XCTAssertEqual(request.headers, [:])
    }

    func testBodyIsNil() {
        let request = DiscoverMoviesRequest()

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = DiscoverMoviesRequest()

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
