//
//  TrendingTVSeriesRequestTests.swift
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

final class TrendingTVSeriesRequestTests: XCTestCase {

    func testPathWithDayTimeWindow() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.path, "/trending/tv/day")
    }

    func testPathWithWeekTimeWindow() {
        let request = TrendingTVSeriesRequest(timeWindow: .week, page: nil)

        XCTAssertEqual(request.path, "/trending/tv/week")
    }

    func testQueryItemsAreEmpty() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWithPage() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: 1)

        XCTAssertEqual(request.queryItems, ["page": "1"])
    }

    func testMethodIsGet() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.headers, [:])
    }

    func testBodyIsNil() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
