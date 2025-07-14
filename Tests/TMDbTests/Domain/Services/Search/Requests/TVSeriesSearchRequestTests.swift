//
//  TVSeriesSearchRequestTests.swift
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

@Suite(.tags(.requests, .search))
struct TVSeriesSearchRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesSearchRequest(query: "")

        #expect(request.path == "/search/tv")
    }

    @Test("queryItems with query")
    func queryItemsWithQuery() {
        let request = TVSeriesSearchRequest(query: "fight club")

        #expect(request.queryItems == ["query": "fight club"])
    }

    @Test("queryItems with query and firstAirDateYear")
    func queryItemsWithQueryAndFirstAirDateYear() {
        let request = TVSeriesSearchRequest(query: "fight club", firstAirDateYear: 2024)

        #expect(request.queryItems == ["query": "fight club", "first_air_date_year": "2024"])
    }

    @Test("queryItems with query and year")
    func queryItemsWithQueryAndYear() {
        let request = TVSeriesSearchRequest(query: "fight club", year: 2024)

        #expect(request.queryItems == ["query": "fight club", "year": "2024"])
    }

    @Test("queryItems with query and includeAdult")
    func queryItemsWithQueryAndIncludeAdult() {
        let request = TVSeriesSearchRequest(query: "fight club", includeAdult: true)

        #expect(request.queryItems == ["query": "fight club", "include_adult": "true"])
    }

    @Test("queryItems with query and page")
    func queryItemsWithQueryAndPage() {
        let request = TVSeriesSearchRequest(query: "fight club", page: 2)

        #expect(request.queryItems == ["query": "fight club", "page": "2"])
    }

    @Test("queryItems with query and language")
    func queryItemsWithQueryAndLanguage() {
        let request = TVSeriesSearchRequest(query: "fight club", language: "en")

        #expect(request.queryItems == ["query": "fight club", "language": "en"])
    }

    @Test("queryItems with query, firstAirDateYear, year, includeAdult, page and language")
    func queryItemsWithQueryAndFirstAirDateYearAndYearAndIncludeAdultAndPageAndLanguage() {
        let request = TVSeriesSearchRequest(
            query: "fight club",
            firstAirDateYear: 2024,
            year: 2022,
            includeAdult: false,
            page: 3,
            language: "en"
        )

        #expect(
            request.queryItems == [
                "query": "fight club",
                "first_air_date_year": "2024",
                "year": "2022",
                "include_adult": "false",
                "page": "3",
                "language": "en"
            ])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesSearchRequest(query: "")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesSearchRequest(query: "")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesSearchRequest(query: "")

        #expect(request.body == nil)
    }

}
