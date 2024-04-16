//
//  WatchProviderEndpointTests.swift
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

final class WatchProviderEndpointTests: XCTestCase {

    func testRegionsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/regions"))

        let url = WatchProviderEndpoint.regions.path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieEndpointWhenGivenRegionCodeReturnsURL() throws {
        let regionCode = "GB"
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/movie?watch_region=\(regionCode)"))

        let url = WatchProviderEndpoint.movie(regionCode: regionCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieEndpointWhenNotGivenRegionCodeReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/movie"))

        let url = WatchProviderEndpoint.movie(regionCode: nil).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWhenGivenRegionCodeEndpointReturnsURL() throws {
        let regionCode = "GB"
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/tv?watch_region=\(regionCode)"))

        let url = WatchProviderEndpoint.tvSeries(regionCode: regionCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWhenNotGivenRegionCodeEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/tv"))

        let url = WatchProviderEndpoint.tvSeries(regionCode: nil).path

        XCTAssertEqual(url, expectedURL)
    }

}
