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

    func testPath() {
        let request = DiscoverMoviesRequest()

        XCTAssertEqual(request.path, "/discover/movie")
    }

    func testQueryItemsAreEmpty() {
        let request = DiscoverMoviesRequest()

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWithSortedBy() {
        let request = DiscoverMoviesRequest(sortedBy: .originalTitle(descending: false))

        XCTAssertEqual(request.queryItems, ["sort_by": "original_title.asc"])
    }

    func testQueryItemsWithPeople() {
        let request = DiscoverMoviesRequest(people: [1, 2, 3])

        XCTAssertEqual(request.queryItems, ["with_people": "1,2,3"])
    }

    func testQueryItemsWithPage() {
        let request = DiscoverMoviesRequest(page: 1)

        XCTAssertEqual(request.queryItems, ["page": "1"])
    }

    func testQueryItemsWithSortByAndPeopleAndPage() throws {
        let request = DiscoverMoviesRequest(sortedBy: .originalTitle(descending: false), people: [1, 2, 3], page: 1)

        XCTAssertEqual(request.queryItems, ["sort_by": "original_title.asc", "with_people": "1,2,3", "page": "1"])
    }

    func testMethodIsGet() {
        let request = DiscoverMoviesRequest()

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = DiscoverMoviesRequest()

        XCTAssertTrue(request.headers.isEmpty)
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
