//
//  WatchProvidersForMoviesRequestTests.swift
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

final class WatchProvidersForMoviesRequestTests: XCTestCase {

    func testPath() {
        let request = WatchProvidersForMoviesRequest(regionCode: nil)

        XCTAssertEqual(request.path, "/watch/providers/movie")
    }

    func testQueryItemsAreEmpty() {
        let request = WatchProvidersForMoviesRequest(regionCode: nil)

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWithWatchRegion() {
        let request = WatchProvidersForMoviesRequest(regionCode: "GB")

        XCTAssertEqual(request.queryItems, ["watch_region": "GB"])
    }

    func testMethodIsGet() {
        let request = WatchProvidersForMoviesRequest(regionCode: nil)

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = WatchProvidersForMoviesRequest(regionCode: nil)

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = WatchProvidersForMoviesRequest(regionCode: nil)

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = WatchProvidersForMoviesRequest(regionCode: nil)

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
