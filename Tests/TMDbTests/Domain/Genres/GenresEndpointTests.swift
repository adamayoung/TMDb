//
//  GenresEndpointTests.swift
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

final class GenresEndpointTests: XCTestCase {

    func testMovieEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/genre/movie/list"))

        let url = GenresEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/genre/tv/list"))

        let url = GenresEndpoint.tvSeries.path

        XCTAssertEqual(url, expectedURL)
    }

}
