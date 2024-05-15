//
//  APIRequestQueryItemNameTests.swift
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

final class APIRequestQueryItemNameTests: XCTestCase {

    func testPageName() {
        XCTAssertEqual(APIRequestQueryItem.Name.page, "page")
    }

    func testSortByName() {
        XCTAssertEqual(APIRequestQueryItem.Name.sortBy, "sort_by")
    }

    func testWithPeopleName() {
        XCTAssertEqual(APIRequestQueryItem.Name.withPeople, "with_people")
    }

    func testWatchRegionName() {
        XCTAssertEqual(APIRequestQueryItem.Name.watchRegion, "watch_region")
    }

    func testIncludeImageLanguageName() {
        XCTAssertEqual(APIRequestQueryItem.Name.includeImageLanguage, "include_image_language")
    }

    func testIncludeVideoLanguageName() {
        XCTAssertEqual(APIRequestQueryItem.Name.includeVideoLanguage, "include_video_language")
    }

    func testIncludeAdultName() {
        XCTAssertEqual(APIRequestQueryItem.Name.includeAdult, "include_adult")
    }

    func testQueryName() {
        XCTAssertEqual(APIRequestQueryItem.Name.query, "query")
    }

    func testYearName() {
        XCTAssertEqual(APIRequestQueryItem.Name.year, "year")
    }

    func testPrimaryReleaseYearName() {
        XCTAssertEqual(APIRequestQueryItem.Name.primaryReleaseYear, "primary_release_year")
    }

    func testFirstAirDateYearName() {
        XCTAssertEqual(APIRequestQueryItem.Name.firstAirDateYear, "first_air_date_year")
    }

    func testSessionIDName() {
        XCTAssertEqual(APIRequestQueryItem.Name.sessionID, "session_id")
    }

    func testLanguageName() {
        XCTAssertEqual(APIRequestQueryItem.Name.language, "language")
    }

    func testRegionName() {
        XCTAssertEqual(APIRequestQueryItem.Name.region, "region")
    }

    func testAPIKeyName() {
        XCTAssertEqual(APIRequestQueryItem.Name.apiKey, "api_key")
    }

}
