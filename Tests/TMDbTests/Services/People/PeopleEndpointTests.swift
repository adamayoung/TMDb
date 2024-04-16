//
//  PeopleEndpointTests.swift
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

final class PeopleEndpointTests: XCTestCase {

    func testPersonDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1"))

        let url = PeopleEndpoint.details(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonCombinedCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/combined_credits"))

        let url = PeopleEndpoint.combinedCredits(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonMovieCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/movie_credits"))

        let url = PeopleEndpoint.movieCredits(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonTVSeriesCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/tv_credits"))

        let url = PeopleEndpoint.tvSeriesCredits(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonImagesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/images"))

        let url = PeopleEndpoint.images(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/popular"))

        let url = PeopleEndpoint.popular().path

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/popular?page=1"))

        let url = PeopleEndpoint.popular(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testExternalIDsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/external_ids"))

        let url = PeopleEndpoint.externalIDs(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
