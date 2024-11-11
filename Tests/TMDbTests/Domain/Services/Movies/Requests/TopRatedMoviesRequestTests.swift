//
//  TopRatedMoviesRequestTests.swift
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

@Suite(.tags(.requests, .movie))
struct TopRatedMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = TopRatedMoviesRequest()

        #expect(request.path == "/movie/top_rated")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TopRatedMoviesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TopRatedMoviesRequest(page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TopRatedMoviesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with country")
    func queryItemsWithCountry() {
        let request = TopRatedMoviesRequest(country: "GB")

        #expect(request.queryItems == ["region": "GB"])
    }

    @Test("queryItems with page, language and country")
    func queryItemsWithPageAndLanguageAndCountry() {
        let request = TopRatedMoviesRequest(page: 3, country: "GB", language: "en")

        #expect(request.queryItems == ["page": "3", "language": "en", "region": "GB"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TopRatedMoviesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TopRatedMoviesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TopRatedMoviesRequest()

        #expect(request.body == nil)
    }

}
