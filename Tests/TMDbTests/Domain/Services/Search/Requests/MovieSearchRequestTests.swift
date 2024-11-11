//
//  MovieSearchRequestTests.swift
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

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .search))
struct MovieSearchRequestTests {

    @Test("path is correct")
    func path() {
        let request = MovieSearchRequest(query: "")

        #expect(request.path == "/search/movie")
    }

    @Test("queryItems with query")
    func queryItemsWithQuery() {
        let request = MovieSearchRequest(query: "fight club")

        #expect(request.queryItems == ["query": "fight club"])
    }

    @Test("queryItems with query and primaryReleaseYear")
    func queryItemsWithQueryAndPrimaryReleaseYear() {
        let request = MovieSearchRequest(query: "fight club", primaryReleaseYear: 2024)

        #expect(request.queryItems == ["query": "fight club", "primary_release_year": "2024"])
    }

    @Test("queryItems with query and country")
    func queryItemsWithQueryAndCountry() {
        let request = MovieSearchRequest(query: "fight club", country: "GB")

        #expect(request.queryItems == ["query": "fight club", "region": "GB"])
    }

    @Test("queryItems with query and includeAdult")
    func queryItemsWithQueryAndIncludeAdult() {
        let request = MovieSearchRequest(query: "fight club", includeAdult: true)

        #expect(request.queryItems == ["query": "fight club", "include_adult": "true"])
    }

    @Test("queryItems with query and page")
    func queryItemsWithQueryAndPage() {
        let request = MovieSearchRequest(query: "fight club", page: 3)

        #expect(request.queryItems == ["query": "fight club", "page": "3"])
    }

    @Test("queryItems with query and language")
    func queryItemsWithQueryAndLanguage() {
        let request = MovieSearchRequest(query: "fight club", language: "en")

        #expect(request.queryItems == ["query": "fight club", "language": "en"])
    }

    @Test("queryItems with query, primaryReleaseYear, country, includeAdult, page and language")
    func queryItemsWithQueryAndPrimaryReleaseYearAndCountryAndIncludeAdultAndPageAndLanugage() {
        let request = MovieSearchRequest(
            query: "fight club",
            primaryReleaseYear: 2024,
            includeAdult: false,
            page: 2,
            language: "en"
        )

        #expect(
            request.queryItems == [
                "query": "fight club",
                "primary_release_year": "2024",
                "include_adult": "false",
                "page": "2",
                "language": "en",
            ])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MovieSearchRequest(query: "")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MovieSearchRequest(query: "")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MovieSearchRequest(query: "")

        #expect(request.body == nil)
    }

}
