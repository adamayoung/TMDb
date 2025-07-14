//
//  APIRequestQueryItemNameTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.apiClient, .domain))
struct APIRequestQueryItemNameTests {

    @Test("pageName")
    func pageQueryItemName() {
        #expect(APIRequestQueryItem.Name.page == "page")
    }

    @Test("sortBy")
    func sortByQueryItemName() {
        #expect(APIRequestQueryItem.Name.sortBy == "sort_by")
    }

    @Test("withPeople")
    func withPeopleQueryItemName() {
        #expect(APIRequestQueryItem.Name.withPeople == "with_people")
    }

    @Test("watchRegion")
    func watchRegionQueryItemName() {
        #expect(APIRequestQueryItem.Name.watchRegion == "watch_region")
    }

    @Test("includeImageLanguage")
    func includeImageLanguageQueryItemName() {
        #expect(APIRequestQueryItem.Name.includeImageLanguage == "include_image_language")
    }

    @Test("includeVideoLanguage")
    func includeVideoLanguageQueryItemName() {
        #expect(APIRequestQueryItem.Name.includeVideoLanguage == "include_video_language")
    }

    @Test("includeAdult")
    func includeAdultQueryItemName() {
        #expect(APIRequestQueryItem.Name.includeAdult == "include_adult")
    }

    @Test("query")
    func queryQueryItemName() {
        #expect(APIRequestQueryItem.Name.query == "query")
    }

    @Test("year")
    func yearQueryItemName() {
        #expect(APIRequestQueryItem.Name.year == "year")
    }

    @Test("primaryReleaseYear")
    func primaryReleaseYearQueryItemName() {
        #expect(APIRequestQueryItem.Name.primaryReleaseYear == "primary_release_year")
    }

    @Test("firstAirDateYear")
    func firstAirDateYearQueryItemName() {
        #expect(APIRequestQueryItem.Name.firstAirDateYear == "first_air_date_year")
    }

    @Test("sesionID")
    func sessionIDQueryItemName() {
        #expect(APIRequestQueryItem.Name.sessionID == "session_id")
    }

    @Test("language")
    func languageQueryItemName() {
        #expect(APIRequestQueryItem.Name.language == "language")
    }

    @Test("region")
    func regionQueryItemName() {
        #expect(APIRequestQueryItem.Name.region == "region")
    }

    @Test("apiKey")
    func apiKeyQueryItemName() {
        #expect(APIRequestQueryItem.Name.apiKey == "api_key")
    }

}
